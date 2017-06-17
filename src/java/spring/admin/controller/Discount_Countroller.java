/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.admin.controller;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import spring.ejb.DiscountDetailsFacadeLocal;
import spring.ejb.DiscountsFacadeLocal;
import spring.ejb.ProductsFacadeLocal;
import spring.entity.DiscountDetails;
import spring.entity.Discounts;
import spring.entity.Products;

/**
 *
 * @author tuan
 */
@Controller
@RequestMapping(value = "/admin/discount/")
public class Discount_Countroller {

    ProductsFacadeLocal productsFacade = lookupProductsFacadeLocal();

    DiscountDetailsFacadeLocal discountDetailsFacade = lookupDiscountDetailsFacadeLocal();

    DiscountsFacadeLocal discountsFacade = lookupDiscountsFacadeLocal();

    @RequestMapping(value = "discountlist", method = RequestMethod.GET)
    public String discountlist(ModelMap model) {
        model.addAttribute("discountList", discountsFacade.findAll());

        return "admin/pages/discount-list";
    }

    @RequestMapping(value = "discountadd", method = RequestMethod.GET)
    public String discountadd(ModelMap model) {
        Discounts discountVoucher = new Discounts();

        //lay tat ca nhung san pham co trong discountDetail
        List<Products> pList = new ArrayList<>();
        List<DiscountDetails> dList = discountDetailsFacade.findAll();
        for (DiscountDetails discountDetails : dList) {
            pList.add(discountDetails.getProductID());
        }

        //lay nhung san pham chua co trong discountdetail
        List<Products> uList = discountDetailsFacade.findListByProductListForUpdate(pList, productsFacade.getProductWorkingList("admin"));

        model.addAttribute("discount", discountVoucher);

        model.addAttribute("productList", uList);
        return "admin/pages/discount-add";
    }

    @RequestMapping(value = "discountadd", method = RequestMethod.POST)
    public String discountadd(
            HttpServletRequest request,
            ModelMap model,
            @RequestParam MultiValueMap<String, String> allRequestParams,
            RedirectAttributes flashAttr) throws ParseException {

        List<String> products = allRequestParams.get("check[]");
        String title = allRequestParams.get("discTitle").get(0);
        String discount = allRequestParams.get("discount").get(0);
        String dateBegin = allRequestParams.get("dateBegin").get(0);
        String dateEnd = allRequestParams.get("dateEnd").get(0);
        String content = allRequestParams.get("discContent").get(0);

        //simple format cho ngay
        DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
        Date dateBeginf = df.parse(dateBegin);
        Date dateEndf = df.parse(dateEnd);

        if (products == null) {
            //lay tat ca nhung san pham co trong discountDetail
            List<Products> pList = new ArrayList<>();
            List<DiscountDetails> dList = discountDetailsFacade.findAll();
            for (DiscountDetails discountDetails : dList) {
                pList.add(discountDetails.getProductID());
            }

            //lay nhung san pham chua co trong discountdetail
            List<Products> uList = discountDetailsFacade.findListByProductListForUpdate(pList, productsFacade.getProductWorkingList("admin"));
            model.addAttribute("error", "<div class=\"alert alert-danger\">\n"
                    + "<strong>Please choose product!</strong>\n"
                    + "</div>");
            model.addAttribute("productList", uList);
            model.addAttribute("discount", new Discounts(title, content, dateBeginf, dateEndf, new Short(discount)));

        } else {
            Discounts dc = discountsFacade.createOR(new Discounts(title, content, dateBeginf, dateEndf, new Short(discount)));
            for (String product : products) {
                discountDetailsFacade.create(new DiscountDetails(dc, new Products(Integer.parseInt(product))));
            }
            //lay tat ca nhung san pham co trong discountDetail
            List<Products> pList = new ArrayList<>();
            List<DiscountDetails> dList = discountDetailsFacade.findAll();
            for (DiscountDetails discountDetails : dList) {
                pList.add(discountDetails.getProductID());
            }

            //lay nhung san pham chua co trong discountdetail
            List<Products> uList = discountDetailsFacade.findListByProductListForUpdate(pList, productsFacade.getProductWorkingList("admin"));
            model.addAttribute("error", "<div class=\"alert alert-success\">\n"
                    + "<strong>CREATE DISCOUNT SUCCESSFULLY</strong>\n"
                    + "</div>");
            model.addAttribute("productList", uList);
            model.addAttribute("discount", new Discounts());

        }
        return "admin/pages/discount-add";
    }

    @RequestMapping(value = "discountupdate/{discountID}", method = RequestMethod.GET)
    public String discountupdate(@PathVariable("discountID") String discountID, ModelMap model, RedirectAttributes flashAttr) {
        Discounts dc = discountsFacade.find(Integer.parseInt(discountID));
        List<Products> allProductList = new ArrayList<>();
        List<Products> allProductByDiscountID = new ArrayList<>();

        //lay nhung san pham theo discountID trong bang discount detail
        List<Integer> idList = discountDetailsFacade.findListByDiscountID(Integer.parseInt(discountID));
        for (Integer i : idList) {
            allProductByDiscountID.add(productsFacade.findProductByID(i));
        }

        //lay tat ca nhung san pham da co trong bang discount detail
        List<DiscountDetails> dList = discountDetailsFacade.findAll();
        for (DiscountDetails discountDetails : dList) {
            allProductList.add(discountDetails.getProductID());
        }
        List<Products> uList = discountDetailsFacade.findListByProductListForUpdate(allProductList, productsFacade.getProductWorkingList("admin"));

        model.addAttribute("addedProductList", allProductByDiscountID);
        model.addAttribute("productList", uList);
        model.addAttribute("discount", dc);
        return "admin/pages/discount-update";
    }

    @RequestMapping(value = "discountupdate/{discountID}", method = RequestMethod.POST)
    public String discountupdate(HttpServletRequest request,
            ModelMap model,
            @RequestParam MultiValueMap<String, String> allRequestParams,
            RedirectAttributes flashAttr) throws ParseException {

        List<Products> allProductList = new ArrayList<>();
        List<String> deleteproducts = allRequestParams.get("deletecheck[]");
        List<String> addproducts = allRequestParams.get("addcheck[]");
        String id = allRequestParams.get("discID").get(0);
        String title = allRequestParams.get("discTitle").get(0);
        String discount = allRequestParams.get("discount").get(0);
        String dateBegin = allRequestParams.get("dateBegin").get(0);
        String dateEnd = allRequestParams.get("dateEnd").get(0);
        String content = allRequestParams.get("discContent").get(0);

        DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
        Date dateBeginf = df.parse(dateBegin);
        Date dateEndf = df.parse(dateEnd);

        if (deleteproducts == null || addproducts == null) {
            Discounts dc = discountsFacade.editOR(new Discounts(Integer.parseInt(id), title, content, dateBeginf, dateEndf, Short.parseShort(discount)));

            if (deleteproducts != null) {
                for (String product : deleteproducts) {
                    discountDetailsFacade.removeByDiscountidAndProductID(dc.getDiscID(), Integer.parseInt(product));
                }
            }
            if (addproducts != null) {
                for (String product : addproducts) {
                    discountDetailsFacade.create(new DiscountDetails(dc, new Products(Integer.parseInt(product))));
                }
            }

            //lay nhung san pham theo discountid trong discountdetail
            List<Integer> idList = discountDetailsFacade.findListByDiscountID(Integer.parseInt(id));
            List<Products> pList = new ArrayList<>();
            for (Integer i : idList) {
                pList.add(productsFacade.findProductByID(i));
            }

            //lay tat ca nhung san pham da co trong bang discount detail
            List<DiscountDetails> dList = discountDetailsFacade.findAll();
            for (DiscountDetails discountDetails : dList) {
                allProductList.add(discountDetails.getProductID());
            }
            List<Products> uList = discountDetailsFacade.findListByProductListForUpdate(allProductList, productsFacade.getProductWorkingList("admin"));
            model.addAttribute("addedProductList", pList);
            model.addAttribute("productList", uList);
            model.addAttribute("discount", dc);
            model.addAttribute("error", "<div class=\"alert alert-success\">\n"
                    + "<strong>UPDATE DISCOUNT SUCCESSFULLY</strong>\n"
                    + "</div>");
        }
        return "admin/pages/discount-update";
    }

//
    @RequestMapping(value = "discountdelete/{discountID}", method = RequestMethod.GET)
    public String discountupdate(@PathVariable("discountID") String discountID, RedirectAttributes flashAttr) {
        discountDetailsFacade.removeOR(Integer.parseInt(discountID));
        discountsFacade.removeOR(Integer.parseInt(discountID));
        flashAttr.addFlashAttribute("error", "<div class=\"col-xs-12 col-sm-6 col-sm-offset-3 alert alert-success\">\n"
                + "<strong>DELETE DISCOUNT SUCCESSFULLY!</strong> .\n"
                + "</div>");
        return "redirect:/admin/discount/discountlist.html";
    }

    @RequestMapping(value = "viewdiscountdetail/{discountID}", method = RequestMethod.GET)
    public String checkProductName(
            @PathVariable(value = "discountID") String productID,
            ModelMap model
    ) {

        List<Integer> idList = discountDetailsFacade.findListByDiscountID(Integer.parseInt(productID));
        List<Products> pList = new ArrayList<>();
        for (Integer id : idList) {
            pList.add(productsFacade.findProductByID(id));
        }
        model.addAttribute("discountList", discountsFacade.findAll());
        model.addAttribute("productList", pList);
        return "admin/pages/discount-list";
    }

    @RequestMapping(value = "ajax/checkDupDiscount", method = RequestMethod.POST)
    @ResponseBody
    public String checkDupCategory(
            @RequestParam(value = "discTitle") String discTitle
    ) {
//        if (cateID != null) { //kiểm tra khi update
//            Brands cate = brandsFacade.find(cateID);
//            List<Brands> cateList = brandsFacade.findAll();
//            for (Brands c : cateList) {
//                if (!cate.getBraName().equalsIgnoreCase(cateName) && c.getBraName().equalsIgnoreCase(cateName)) {
//                    return "1"; //trùng
//                }
//            }
//            return "0";
//        } else { //kiểm tra khi create
//            if (brandsFacade.findBrandsLikeName(cateName).size() > 0) {
//                return "1"; //trùng
//            } else {
//                return "0"; //chưa tồn tại
//            }
//        }
        List<Discounts> list = discountsFacade.findAll();
        for (Discounts discounts : list) {
            if (discTitle.equalsIgnoreCase(discounts.getDiscTitle())) {
                return "1";
            }
        }
        return "0";
    }

    private DiscountsFacadeLocal lookupDiscountsFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (DiscountsFacadeLocal) c.lookup("java:global/ShoeGardenPJ/DiscountsFacade!spring.ejb.DiscountsFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    private DiscountDetailsFacadeLocal lookupDiscountDetailsFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (DiscountDetailsFacadeLocal) c.lookup("java:global/ShoeGardenPJ/DiscountDetailsFacade!spring.ejb.DiscountDetailsFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    private ProductsFacadeLocal lookupProductsFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (ProductsFacadeLocal) c.lookup("java:global/ShoeGardenPJ/ProductsFacade!spring.ejb.ProductsFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }
}
