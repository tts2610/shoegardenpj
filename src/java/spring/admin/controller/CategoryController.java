/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.admin.controller;

import java.util.List;
import java.util.Objects;
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
import spring.ejb.CategoriesFacadeLocal;
import spring.entity.Brands;
import spring.entity.Categories;
import spring.functions.SharedFunctions;

/**
 *
 * @author tuan
 */
@Controller
@RequestMapping(value = "/admin/")
public class CategoryController {

    BrandsFacadeLocal brandsFacade = lookupBrandsFacadeLocal();

    CategoriesFacadeLocal categoriesFacade = lookupCategoriesFacadeLocal();
    
    
    
    @Autowired
    SharedFunctions shareFunc;

    @Autowired
    ServletContext app;
    
    
    
    
    @RequestMapping(value = "product-subcategory")
    public String productSubCateList(ModelMap model) {
        model.addAttribute("cateList", categoriesFacade.findAll());
        return "admin/pages/product-category-list";
    }

    @RequestMapping(value = "product-subcategory/create", method = RequestMethod.GET)
    public String productSubCateAdd(ModelMap model) {
        Categories subCategory = new Categories();
        model.addAttribute("subCategory", subCategory);
        return "admin/pages/product-category-add";
    }

    @RequestMapping(value = "product-subcategory/create", method = RequestMethod.POST)
    public String productSubCateAdd(ModelMap model,
            @RequestParam("braID.braID") Integer cateID,
            @ModelAttribute("subCategory") Categories newSubCategory,
            RedirectAttributes flashAttr) {
//        newSubCategory.setSubCateNameNA(shareFunc.changeText(newSubCategory.getSubCateName()));


        Brands cate = brandsFacade.find(cateID);
        int errorCode = categoriesFacade.createOR(newSubCategory);
        if (errorCode == 1) {
            flashAttr.addFlashAttribute("error", "<div class=\"alert alert-success\">\n"
                    + "<strong>Success!</strong> Create Category Successfully!.\n"
                    + "</div>");
            return "redirect:/admin/product-subcategory/create.html";
        } else if (errorCode == 2) {
            model.addAttribute("error", "<div class=\"alert alert-danger\">\n"
                    + "<strong>Danger!</strong> Category existed<b>\"" + newSubCategory.getCatName()+ "\"</b> in <b>\"" + cate.getBraName()+ "\"</b>!.\n"
                    + "</div>");
            model.addAttribute("subCategory", newSubCategory);
            return "admin/pages/product-subcategory-add";
        } else {
            flashAttr.addFlashAttribute("error", "<div class=\"alert alert-danger\">\n"
                    + "<strong>Error! </strong> Error was happened!.\n"
                    + "</div>");
            return "redirect:/admin/product-subcategory/create.html";
        }
    }

    @RequestMapping(value = "product-subcategory/{subCateNameNA}-{subCateID}", method = RequestMethod.GET)
    public String productSubCateUpdate(ModelMap model,
            @PathVariable("subCateID") Integer subCateID) {
        Categories targetSubCategory = categoriesFacade.find(subCateID);
        model.addAttribute("targetSubCategory", targetSubCategory);
        return "admin/pages/product-category-update";
    }

    @RequestMapping(value = "product-subcategory/{subCateNameNA}-{subCateID}", method = RequestMethod.POST)
    public String productSubCateUpdate(ModelMap model,
            @PathVariable("subCateID") Integer subCateID,
            @RequestParam("braID.braID") Integer cateID,
            RedirectAttributes flashAttr,
            @ModelAttribute("targetSubCategory") Categories targetSubCategory) {
        Categories oldCategory = categoriesFacade.find(subCateID);
        
        Brands cate = brandsFacade.find(cateID);

        int errorCode = categoriesFacade.editOR(targetSubCategory);
        if (errorCode == 1) {
            flashAttr.addFlashAttribute("error", "<div class=\"alert alert-success\">\n"
                    + "<strong>Success!</strong> Update SubCategory Successfully!.\n"
                    + "</div>");
            return "redirect:/admin/product-subcategory/" + targetSubCategory.getCatName()+ "-" + subCateID + ".html";
        } else if (errorCode == 2) {
            flashAttr.addFlashAttribute("error", "<div class=\"alert alert-danger\">\n"
                    + "<strong>Danger!</strong> Category existed<b>\"" + targetSubCategory.getCatName()+ "\"</b> in <b>\"" + cate.getBraName()+ "\"</b>!.\n"
                    + "</div>");
            return "redirect:/admin/product-subcategory/" + oldCategory.getCatName()+ "-" + subCateID + ".html";
        } else {
            flashAttr.addFlashAttribute("error", "<div class=\"alert alert-danger\">\n"
                    + "<strong>Error! </strong> Error was happened!.\n"
                    + "</div>");
            return "redirect:/admin/product-subcategory/" + oldCategory.getCatName()+ "-" + subCateID + ".html";
        }
    }

    @RequestMapping(value = "deletesubcategory-{subCateID}", method = RequestMethod.GET)
    public String deleteSubCategory(
            @PathVariable("subCateID") Integer subCateID,
            RedirectAttributes flashAttr
    ) {
        if (categoriesFacade.removeOR(subCateID)) {
            flashAttr.addFlashAttribute("error", "0");
        } else {
            flashAttr.addFlashAttribute("error", "1");
        }

        return "redirect:/admin/product-subcategory.html";
    }

    @RequestMapping(value = "ajax/checkDupSubCategory", method = RequestMethod.POST)
    @ResponseBody
    public String checkDupSubCategory(
            @RequestParam("cateID") Integer cateID,
            @RequestParam(value = "subCateID", required = false) Integer subCateID,
            @RequestParam("subCateName") String subCateName
    ) {
        if (subCateID != null) { //check update
            Categories originalSubCate = categoriesFacade.find(subCateID);
            if (Objects.equals(originalSubCate.getBraID().getBraID(), cateID) && originalSubCate.getCatName().equalsIgnoreCase(subCateName)) {
                return "0";
            } else {
                Brands cate = brandsFacade.find(cateID);
                List<Categories> subCateList = cate.getCategoriesList();
                int count = 0;
                for (Categories sc : subCateList) {
                    if (subCateName.equalsIgnoreCase(sc.getCatName())) {
                        count++;
                    }
                }

                if (count != 0) {
                    return "1";//trùng
                } else {
                    return "0";//chưa tồn tại
                }
            }
        } else { //check create
            Brands cate = brandsFacade.find(cateID);
            List<Categories> subCateList = cate.getCategoriesList();

            int count = 0;
            for (Categories sc : subCateList) {
                if (subCateName.equalsIgnoreCase(sc.getCatName())) {
                    count++;
                }
            }

            if (count != 0) {
                return "1";//trùng
            } else {
                return "0";//chưa tồn tại
            }
        }
    }
    @ModelAttribute("brands")
    public List<Brands> getAllCategory() {
        return brandsFacade.findAll();
    }

    private CategoriesFacadeLocal lookupCategoriesFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (CategoriesFacadeLocal) c.lookup("java:global/ShoeGardenPJ/CategoriesFacade!spring.ejb.CategoriesFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
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
