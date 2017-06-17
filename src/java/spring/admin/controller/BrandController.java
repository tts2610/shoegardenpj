/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.admin.controller;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import spring.ejb.BrandsFacadeLocal;
import spring.entity.Brands;
import spring.functions.SharedFunctions;

/**
 *
 * @author tuan
 */
@Controller
@RequestMapping(value = "/admin/")
public class BrandController {

    BrandsFacadeLocal brandsFacade = lookupBrandsFacadeLocal();
    
    @Autowired
    SharedFunctions shareFunc;

    @Autowired
    ServletContext app;
    
    @RequestMapping(value = "product-category")
    public String productCateList(ModelMap model) {
        model.addAttribute("braList", brandsFacade.findAll());
        return "admin/pages/product-brand-list";
    }

    @RequestMapping(value = "product-category/create", method = RequestMethod.GET)
    public String productCateAdd(ModelMap model) {
        Brands newCate = new Brands();
        model.addAttribute("newCate", newCate);
        return "admin/pages/product-brand-add";
    }

    @RequestMapping(value = "product-category/create", method = RequestMethod.POST)
    public String productCateAdd(ModelMap model, @ModelAttribute("newCate") Brands newCate, RedirectAttributes flashAttr) {
//        newCate.setCateNameNA(shareFunc.changeText(newCate.getBraName()));
        
        
        int error_code = brandsFacade.createOR(newCate);
        System.err.println(error_code);
        if (error_code == 2) {
            model.addAttribute("error", "<div class=\"alert alert-danger\">\n"
                    + "<strong>Danger!</strong> Brand has been existed!.\n"
                    + "</div>");
            model.addAttribute("newCate", newCate);
            return "admin/pages/product-category-add";
        } else if (error_code == 1) {
            flashAttr.addFlashAttribute("error", "<div class=\"alert alert-success\">\n"
                    + "<strong>Success!</strong> Create New Brand Successfully!.\n"
                    + "</div>");
            return "redirect:/admin/product-category/create.html";
        } else {
            flashAttr.addFlashAttribute("error", "<div class=\"alert alert-danger\">\n"
                    + "<strong>Danger!</strong> Error was happened!.\n"
                    + "</div>");
            return "redirect:/admin/product-category/create.html";
        }
    }

    @RequestMapping(value = "product-category/{cateNameNA}-{cateID}", method = RequestMethod.GET)
    public String productCateUpdate(ModelMap model, @PathVariable("cateID") Integer cateID) {
        Brands targetCate = brandsFacade.find(cateID);
        model.addAttribute("targetCate", targetCate);
        return "admin/pages/product-brand-update";
    }

    @RequestMapping(value = "product-category/{cateNameNA}-{cateID}", method = RequestMethod.POST)
    public String productCateUpdate(ModelMap model,RedirectAttributes flashAttr, @ModelAttribute("targetCate") Brands targetCate,
            @PathVariable("cateID") Integer cateID) {
        Brands oldCate = brandsFacade.find(cateID);
//        targetCate.setCateNameNA(shareFunc.changeText(targetCate.getCateName()));

        

        targetCate.setBraID(cateID);
        
        int errorCode = brandsFacade.editOR(targetCate);
        if (errorCode == 1) { //Update thành công
            flashAttr.addFlashAttribute("error", "<div class=\"alert alert-success\">\n"
                    + "<strong>Success!</strong> Update Brand Successfully!.\n"
                    + "</div>");
            model.addAttribute("targetCate", targetCate);
            return "redirect:/admin/product-category/" + targetCate.getBraName()+ "-" + cateID + ".html";
        } else if (errorCode == 0) { //Update bị lỗi
            flashAttr.addFlashAttribute("error", "<div class=\"alert alert-danger\">\n"
                    + "<strong>Danger!</strong> Error was happened!.\n"
                    + "</div>");
        } else if (errorCode == 2) { //Update lỗi trùng tên đã tồn tại trước đó
            flashAttr.addFlashAttribute("error", "<div class=\"alert alert-warning\">\n"
                    + "<strong>Danger!</strong> Category name \"" + targetCate.getBraName()+ "\" existed!.\n"
                    + "</div>");
        }
        return "redirect:/admin/product-category/" + oldCate.getBraName()+ "-" + cateID + ".html";
    }

    @RequestMapping(value = "deletecategory-{cateID}", method = RequestMethod.GET)
    public String deletecategory(
            @PathVariable("cateID") Integer cateID,
            RedirectAttributes flashAttr
    ) {
        if (brandsFacade.removeOR(cateID)) {
            flashAttr.addFlashAttribute("error", "0");
        } else {
            flashAttr.addFlashAttribute("error", "1");
        }

        return "redirect:/admin/product-category.html";
    }

    @RequestMapping(value = "ajax/checkDupCategory", method = RequestMethod.POST)
    @ResponseBody
    public String checkDupCategory(
            @RequestParam(value = "cateID", required = false) Integer cateID,
            @RequestParam(value = "cateName") String cateName
    ) {
        if (cateID != null) { //kiểm tra khi update
            Brands cate = brandsFacade.find(cateID);
            List<Brands> cateList = brandsFacade.findAll();
            for (Brands c : cateList) {
                if (!cate.getBraName().equalsIgnoreCase(cateName) && c.getBraName().equalsIgnoreCase(cateName)) {
                    return "1"; //trùng
                }
            }
            return "0";
        } else { //kiểm tra khi create
            if (brandsFacade.findBrandsLikeName(cateName).size() > 0) {
                return "1"; //trùng
            } else {
                return "0"; //chưa tồn tại
            }
        }
    }

    private BrandsFacadeLocal lookupBrandsFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (BrandsFacadeLocal) c.lookup("java:global/ShoeGardenPJ/BrandsFacade!spring.ejb.BrandsFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }
}
