/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.client.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import static java.lang.Float.NaN;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import spring.ejb.BrandsFacadeLocal;
import spring.ejb.CategoriesFacadeLocal;
import spring.ejb.OrderStateFullBeanLocal;
import spring.ejb.ProductColorsFacadeLocal;

import spring.ejb.ProductsFacadeLocal;
import spring.ejb.SizesByColorFacadeLocal;
import spring.ejb.UsersFacadeLocal;

import spring.entity.Brands;
import spring.entity.CartLineInfo;
import spring.entity.Categories;
import spring.entity.ProductColors;

import spring.entity.Products;
import spring.entity.Rating;
import spring.entity.SizeLetterOrder;
import spring.entity.SizesByColor;

@Controller
public class ProductController {

    ProductColorsFacadeLocal productColorsFacade = lookupProductColorsFacadeLocal();

    SizesByColorFacadeLocal sizesByColorFacade = lookupSizesByColorFacadeLocal();

    OrderStateFullBeanLocal orderStateFullBean = lookupOrderStateFullBeanLocal();

    CategoriesFacadeLocal categoriesFacade = lookupCategoriesFacadeLocal();

    BrandsFacadeLocal brandsFacade = lookupBrandsFacadeLocal();

    ProductsFacadeLocal productsFacade = lookupProductsFacadeLocal();

    UsersFacadeLocal usersFacade = lookupUsersFacadeLocal();
    
    

    
    
    
    
//    ProductStateLessBeanLocal productStateLessBean = lookupProductStateLessBeanLocal();
//    UsersStateLessBeanLocal usersStateLessBean = lookupUsersStateLessBeanLocal();

    @RequestMapping(value = "/brand/{braID:[0-9]+}-{braName:[A-Za-z0-9-]+}")
    public String categorylist(ModelMap model,
            @PathVariable("braID") Integer cateID,
            @PathVariable("braName") String categoryNameNA) {
        int page = 1;
        int itemPerPage = 6;

        List<Brands> cateList = brandsFacade.findAll();
        
        List<Products> allProductByCate = brandsFacade.find(cateID).getProductListWorking();
        int numberOfProducts = allProductByCate.size();
        int fromProduct = ((page - 1) * itemPerPage) + 1;
        int toProduct = ((page - 1) * itemPerPage) + itemPerPage;
        if (toProduct > numberOfProducts) {
            toProduct = numberOfProducts;
        }
        String currentProductPageInfo = fromProduct + " - " + toProduct;

        if (numberOfProducts > 0) {
            double fromPrice = productsFacade.getMinPriceOfProduct_ByCate(cateID);
            double toPrice = productsFacade.getMaxPriceOfProduct_ByCate(cateID);

            List<Object[]> productIDList = productsFacade.filterProductByCategory(cateID, page, itemPerPage, fromPrice, toPrice, "", "", 1);
            
            List<Products> finalProductList = new ArrayList<>();
            for (Object[] prod : productIDList) {
                Products product = productsFacade.findProductByID((Integer) prod[0]);
                finalProductList.add(product);
            }
            List<ProductColors> colorSet = new ArrayList<>();
            Set<String> sizeSet = new HashSet<>();
            Set<String> colorNameSet = new HashSet<>();
            
            //get List of Color
            for (Products p : allProductByCate) {
                for (ProductColors pc : p.getProductColorsList()) {
                    colorNameSet.add(pc.getColor());
                    for (SizesByColor size : pc.getSizesByColorList()) {
                        sizeSet.add(size.getSize());
                    }
                }
            }

            for (String name : colorNameSet) {
                    colorSet.add(productColorsFacade.findTop1ByColorName(name));
            }
           
            
            model.addAttribute("numberOfProducts", numberOfProducts);
            model.addAttribute("currentProductPageInfo", currentProductPageInfo);
            model.addAttribute("braID", cateID);
            model.addAttribute("productsList", finalProductList);
            model.addAttribute("colorList", colorSet);
            model.addAttribute("sizeList", sizeSet);
            model.addAttribute("maxPrice", productsFacade.getMaxPriceOfProduct_ByCate(cateID));
            model.addAttribute("minPrice", productsFacade.getMinPriceOfProduct_ByCate(cateID));
        }
        model.addAttribute("braList", cateList);
        return "client/pages/brands-grid";
    }
    
    
    //Compare
    @RequestMapping(value = "/comparelist")
    public String compareNavigate(){
        return "client/pages/compare";
    }
    @ResponseBody
    @RequestMapping(value = "ajax/compare", method = RequestMethod.POST)
    public String comparelist(HttpServletRequest request, ModelMap model,
            @RequestParam("proID") Integer proID) {
        String error = "1";
        HttpSession session = request.getSession();
        List<Products> slist = (List<Products>) session.getAttribute("compareList");
        Products p = productsFacade.findProductByID(proID);
        if(slist==null){
            slist = new ArrayList<>();
            slist.add(p);
        }else{
            if(slist.contains(p)){
                error = "2";
            }else{
                slist.add(p);
            }
        }
        session.setAttribute("compareList", slist);
        return error;
    }
    
    @ResponseBody
    @RequestMapping(value = "ajax/comparedelete", method = RequestMethod.POST)
    public String comparedelete(HttpServletRequest request, ModelMap model,
            @RequestParam("proID") Integer proID) {
        String error = "1";
        HttpSession session = request.getSession();
        List<Products> slist = (List<Products>) session.getAttribute("compareList");
        Products p = productsFacade.findProductByID(proID);
        slist.remove(p);
        
        session.setAttribute("compareList", slist);
        return error;
    }
    @ResponseBody
    @RequestMapping(value = "compare/deleteAll", method = RequestMethod.GET)
    public String comparedeleteall(HttpServletRequest request) {
        String error = "1";
        HttpSession session = request.getSession();
        List<Products> slist = (List<Products>) session.getAttribute("compareList");
        slist.clear();
        
        session.setAttribute("compareList", slist);
        return error;
    }
    @ResponseBody
    @RequestMapping(value = "ajax/comparelist", method = RequestMethod.GET)
    public String compare(HttpServletRequest request) throws ParseException {
        String str_cart_detail = "";
        String str_cart_big = "";
        String str_cart_button = "";
        String str_subtotal = "";
        
        int cartSize = 0;
        HttpSession session = request.getSession();
        List<Products> slist = (List<Products>) session.getAttribute("compareList");
        if (slist==null) {
            
            cartSize = 0;
        } else {
            
            cartSize = slist.size();
            
            for (Products p : slist) {
                
                str_cart_button = "<div class=\"cart-btn\">\n"
                    + "                                <a href=\"comparelist.html\">VIEW COMPARE LIST</a>\n"
                    + "                                <button onclick=\"compareClearAllClick();\" style=\"background: #fe980f;\n"
                    + "                                font-size: 11px;\n"
                    + "                                color: #fff;\n"
                    + "                                text-transform: none;\n"
                    + "                                height: 33px;\n"
                    + "                                padding: 0 17px;\n"
                    + "                                line-height: 33px;\n"
                    + "                                font-weight: 700;\" class=\"btn\">CLEAR ALL</button> \n"
                    + "                            </div>";
            
                str_cart_detail += "<div class=\"ci-item\">\n"
                        + "        <img src=\"assets/images/products/" + p.getUrlImg() + "\" width=\"90\" alt=\"\"/>\n"
                        + "        <div class=\"ci-item-info\">\n"
                        + "            <h5>\n"
                        + "                <a style=\"font-weight: 700;\" href=\"" + p.getProductID() + "-" + p.getProductColorsList().get(0).getColorID()+ ".html\">\n"
                        + "                    " + p.getProductName() + "\n"
                        + "                </a>\n"
                        + "            </h5>\n";
                        
                       
                        if(p.getDiscountByProduct()!=0)
                        str_cart_detail +="  <p class=\"product-price\">\n"
                        + "                 Price: &nbsp\n"
                        + "                 <small class=\"cutprice\" style=\"display: inline;border-bottom:none;\">$" + String.format("%.2f", p.getPrice()) + "</small>\n"
                        + "            <small class=\"ps-price fs-product-price\" style=\"display: inline;color:#e74c3c;border-bottom:none;\">$" + p.getProductWithDiscount() + "</small>"
                        + "            <small class=\"ps-price fs-product-discount\" style=\"display: inline;color:#e74c3c;border-bottom:none;\">(-" + p.getDiscountByProduct() + "%)</small>\n"
                        + "            </p>\n";
                        else if(p.getDiscountByProduct()==0)
                        str_cart_detail +="  <p class=\"product-price\">\n"
                        + "                 Price: &nbsp\n"
                        + "            <small class=\"ps-price fs-product-price\" style=\"display: inline;color:#e74c3c;border-bottom:none;\">$" + String.format("%.2f", p.getPrice()) + "</small>&nbsp\n"
                        + "            </p>\n";   
                        str_cart_detail +="        </div>\n"
                        + "    </div>";
            }
        }
        //"
        str_cart_big = 
                
                "<small>You have <em class=\"highlight\">" + cartSize + " item(s)</em> in your compare table</small>\n"
                + str_cart_detail
                + str_subtotal
                + str_cart_button;

        return str_cart_big;
    }
    

    
    
    @RequestMapping(value = "/{brandName:[A-Za-z0-9- ]+}/{catID:[0-9]+}-{catName:[A-Za-z0-9- ]+}")
    public String subCategoryList(ModelMap model,
            @PathVariable("catID") Integer subCateID) {
        if (categoriesFacade.find(subCateID) != null) {
            //2 dòng này thêm để render ra menu chính
            List<Brands> cateList = brandsFacade.findAll();

            int page = 1;
            int itemPerPage = 6;

            List<Products> allProductBySubCate = categoriesFacade.find(subCateID).getProductListWorking();
            int numberOfProducts = allProductBySubCate.size();
            if (numberOfProducts > 0) {
                int fromProduct = ((page - 1) * itemPerPage) + 1;
                int toProduct = ((page - 1) * itemPerPage) + itemPerPage;
                if (toProduct > numberOfProducts) {
                    toProduct = numberOfProducts;
                }
                String currentProductPageInfo = fromProduct + " - " + toProduct;

                double fromPrice = productsFacade.getMinPriceOfProduct_BySubCate(subCateID);
                double toPrice = productsFacade.getMaxPriceOfProduct_BySubCate(subCateID);

                List<Object[]> productIDList = productsFacade.filterProductBySubCategory(subCateID, page, itemPerPage, fromPrice, toPrice, "", "", 1);
                List<Products> finalProductList = new ArrayList<>();

                for (Object[] prod : productIDList) {
                    Products product = productsFacade.findProductByID((Integer) prod[0]);
                    finalProductList.add(product);
                }
                Set<String> colorNameSet = new HashSet<>();
                Set<String> sizeSet = new HashSet<>();
                List<ProductColors> colorSet = new ArrayList<>();

            //get List of Color
            for (Products p : allProductBySubCate) {
                for (ProductColors pc : p.getProductColorsList()) {
                    colorNameSet.add(pc.getColor());
                    for (SizesByColor size : pc.getSizesByColorList()) {
                        sizeSet.add(size.getSize());
                    }
                }
            }
            
                for (String name : colorNameSet) {
                    colorSet.add(productColorsFacade.findTop1ByColorName(name));
                }
                

                model.addAttribute("subCateID", subCateID);
                model.addAttribute("numberOfProducts", numberOfProducts);
                model.addAttribute("currentProductPageInfo", currentProductPageInfo);
                model.addAttribute("productsList", finalProductList);
                model.addAttribute("colorList", colorSet);
                model.addAttribute("sizeList", sizeSet);
                model.addAttribute("maxPrice", productsFacade.getMaxPriceOfProduct_BySubCate(subCateID));
                model.addAttribute("minPrice", productsFacade.getMinPriceOfProduct_BySubCate(subCateID));
            }

            model.addAttribute("braList", cateList);
            return "client/pages/categories-grid";
        } else {
            return "Ve Trang 404!";
        }

    }

    @RequestMapping(value = "/{productID:[0-9]+}-{colorID:[0-9]+}")
    public String productdetail(ModelMap model,
            @PathVariable("productID") Integer productID,
            @PathVariable("colorID") Integer colorID,
            HttpSession session,
            HttpServletRequest request,
            HttpServletResponse response
    ) {

        Products targetProduct = productsFacade.findProductByID(productID);

        List<Brands> cateList = brandsFacade.findAll();
        if ((targetProduct != null)) {
            int currentView = targetProduct.getProductViews();
            currentView++;
            targetProduct.setProductViews(currentView);
            productsFacade.updateProductGeneralInfo(targetProduct);
            List<Rating> ratingList = targetProduct.getRatingList();
            float ratingAVR = 0;
            float ratingSum = 0;
            int ratingfor1 = 0;
            int ratingfor2 = 0;
            int ratingfor3 = 0;
            int ratingfor4 = 0;
            int ratingfor5 = 0;
            int checkUserRated = 0;
            int ratecount = 0;
            if (ratingList.size() > 0) {
                for (Rating rating : ratingList) {
                    if(rating.getRating()!=0){
                        ratingSum += rating.getRating();
                        ratecount++;
                    }
                    if (rating.getRating() == 1) {
                        ratingfor1++;
                    }

                    if (rating.getRating() == 2) {
                        ratingfor2++;
                    }

                    if (rating.getRating() == 3) {
                        ratingfor3++;
                    }

                    if (rating.getRating() == 4) {
                        ratingfor4++;
                    }

                    if (rating.getRating() == 5) {
                        ratingfor5++;
                    }

                    if (session.getAttribute("findUsersID") != null) {
                        if (Objects.equals(rating.getUser().getUserID(), session.getAttribute("findUsersID"))) {
                            checkUserRated = 1;
                        }
                    }
                }
                ratingAVR = ratingSum / (float) ratecount;
            }
            if (Float.isNaN(ratingAVR)) {
                ratingAVR = 0;
            }
            
            DecimalFormat decimalformat = new DecimalFormat("#.#");
            decimalformat.format(ratingAVR);

            List<ProductColors> productColorList = targetProduct.getProductColorsList();
            int count = 0;
            for (ProductColors color : productColorList) {
                if (Objects.equals(color.getColorID(), colorID)) {
                    count++;
                    break;
                }
            }

            if (count > 0) {
                Cookie[] cookies = request.getCookies();
                if (cookies != null) { //có cookie mà chưa biết cookie nào
                    int dem = 0; //nếu có cookie thì dem tăng lên 1.
                    for (Cookie c : cookies) {
                        //kiểm tra có cookie recentProd ko
                        if (c.getName().equals("recentProdArr")) { //có thì lấy ra, thêm cái mới vào
                            dem++;
                            String productIDList = c.getValue();
                            String[] productIDArr = productIDList.split(",");
                            Collections.reverse(Arrays.asList(productIDArr));
                            List<Products> recentProductList = new ArrayList<>();
                            int cnt = 0;
                            for (String prodID : productIDArr) {
                                if (productID == (Integer.parseInt(prodID))) {
                                    cnt++;
                                }
                                Products recentprd = productsFacade.findProductByID(Integer.parseInt(prodID));
                                recentProductList.add(recentprd);
                            }
                            model.addAttribute("recentProductList", recentProductList);

                            if (cnt == 0) {
                                productIDList += productID.toString() + ",";
                                Cookie recentProdCookie = new Cookie("recentProdArr", productIDList);
                                recentProdCookie.setMaxAge(30 * 24 * 60 * 60);
                                response.addCookie(recentProdCookie);
                            }
                            break;
                        }
                    }
                    if (dem == 0) {//ko có => tạo mới  
                        String recentProdIDStr = productID.toString() + ",";
                        Cookie recentProdCookie = new Cookie("recentProdArr", recentProdIDStr);
                        recentProdCookie.setMaxAge(30 * 24 * 60 * 60);
                        response.addCookie(recentProdCookie);

                    }
                } else { //cookie == null => tạo cookie mới
                    String recentProdIDStr = productID.toString() + ",";
                    Cookie recentProdCookie = new Cookie("recentProdArr", recentProdIDStr);
                    recentProdCookie.setMaxAge(30 * 24 * 60 * 60);
                    response.addCookie(recentProdCookie);
                }

                ProductColors targetColor = productsFacade.findProductColorByColorID(colorID);
                model.addAttribute("targetProduct", targetProduct);
                model.addAttribute("targetColor", targetColor);
                model.addAttribute("braList", cateList);
                model.addAttribute("ratingAVR", ratingAVR);
                model.addAttribute("rateCount", ratecount);
                model.addAttribute("numberOfRating", ratingList.size());
                model.addAttribute("ratingfor1", ratingfor1);
                model.addAttribute("ratingfor2", ratingfor2);
                model.addAttribute("ratingfor3", ratingfor3);
                model.addAttribute("ratingfor4", ratingfor4);
                model.addAttribute("ratingfor5", ratingfor5);
                
                model.addAttribute("checkUserRated", checkUserRated);
            } else {
                String error = "Product has not this color!";
            }
        } else {
            String error = "Product isn't exist!";
        }

        return "client/pages/product-detail";
    }

    @ResponseBody
    @RequestMapping(value = "/ajax/findProduct", method = RequestMethod.POST)
    public String getProductByID(@RequestParam("productID") Integer productID) {
        Products targetProduct = productsFacade.findProductByID(productID);

        try {
            ObjectMapper mapper = new ObjectMapper();
            String result = mapper.writeValueAsString(targetProduct);
            return result;
        } catch (Exception e) {
            return "Error!" + e.getMessage();
        }

    }

    @ResponseBody
    @RequestMapping(value = "/ajax/color", method = RequestMethod.POST)
    public String getInforByColorID(@RequestParam("colorID") Integer colorID) {
        ProductColors color = productsFacade.findProductColorByColorID(colorID);

        try {
            ObjectMapper mapper = new ObjectMapper();
            String result = mapper.writeValueAsString(color);
            return result;
        } catch (Exception e) {
            return "" + e.getMessage();
        }
    }
    
    @ResponseBody
    @RequestMapping(value = "ajax/productgetSession", method = RequestMethod.GET)
    public String ajaxGetSession(HttpServletRequest request) {
        Integer userid = (Integer) request.getSession().getAttribute("findUsersID");
        
        String email = (String) request.getSession().getAttribute("emailUser")==null?"":(String) request.getSession().getAttribute("emailUser");
        String uid = userid==null?"":userid.toString();
        
        return uid+"-"+email;
    }

    @ResponseBody
    @RequestMapping(value = "/ajax/productPagination", method = RequestMethod.POST)
    public String productPagination(
            @RequestParam("cateID") Integer cateID,
            @RequestParam("page") Integer page,
            @RequestParam("itemPerPage") Integer itemPerPage,
            @RequestParam("sortBy") Integer sortBy,
            @RequestParam("fromPrice") Double fromPrice,
            @RequestParam("toPrice") Double toPrice,
            @RequestParam(value = "colorFilterArr[]", required = false) List<String> colorFilterArr,
            @RequestParam(value = "sizeFilterArr[]", required = false) List<String> sizeFilterArr) {
        if (fromPrice == null) {
            fromPrice = productsFacade.getMinPriceOfProduct_ByCate(cateID);
        }

        if (toPrice == null) {
            toPrice = productsFacade.getMaxPriceOfProduct_ByCate(cateID);
        }
        String filterColor = "";
        String beginColorStr = "AND pc.color in (";
        String endColorStr = ") ";
        String contentColorStr = "";

        String filterSize = "";
        String beginSizeStr = "AND ps.size in (";
        String endSizeStr = ") ";
        String contentSizeStr = "";

        if (colorFilterArr != null) {
            for (String color : colorFilterArr) {
                contentColorStr += "'" + color + "',";
            }
            contentColorStr = contentColorStr.substring(0, contentColorStr.length() - 1);
            filterColor = beginColorStr + contentColorStr + endColorStr;
        }

        if (sizeFilterArr != null) {
            for (String size : sizeFilterArr) {
                contentSizeStr += "'" + size + "',";
            }
            contentSizeStr = contentSizeStr.substring(0, contentSizeStr.length() - 1);
            filterSize = beginSizeStr + contentSizeStr + endSizeStr;
        }

        List<Object[]> productIDList = productsFacade.filterProductByCategory(cateID, page, itemPerPage, fromPrice, toPrice, filterColor, filterSize, sortBy);
        List<Products> finalProductList = new ArrayList<>();
        
        for (Object[] prod : productIDList) {

            Products product = productsFacade.findProductByID((Integer) prod[0]);
            
            finalProductList.add(product);
        }
        ObjectMapper mapper = new ObjectMapper();
        String result = "";
        try {
            result = mapper.writeValueAsString(finalProductList);
        } catch (JsonProcessingException ex) {
            ex.printStackTrace();
        }
        return result;
    }

    @ResponseBody
    @RequestMapping(value = "/ajax/getNumberOfProductsByFilter_OfACategory", method = RequestMethod.POST)
    public String getNumberOfProductsByFilter_OfACategory(
            @RequestParam("cateID") Integer cateID,
            @RequestParam("fromPrice") Double fromPrice,
            @RequestParam("toPrice") Double toPrice,
            @RequestParam(value = "colorFilterArr[]", required = false) List<String> colorFilterArr,
            @RequestParam(value = "sizeFilterArr[]", required = false) List<String> sizeFilterArr
    ) {
        
        if (fromPrice == null) {
            fromPrice = productsFacade.getMinPriceOfProduct_ByCate(cateID);
        }

        if (toPrice == null) {
            toPrice = productsFacade.getMaxPriceOfProduct_ByCate(cateID);
        }
        String filterColor = "";
        String beginColorStr = "AND pc.color in (";
        String endColorStr = ") ";
        String contentColorStr = "";

        String filterSize = "";
        String beginSizeStr = "AND ps.size in (";
        String endSizeStr = ") ";
        String contentSizeStr = "";

        if (colorFilterArr != null) {
            for (String color : colorFilterArr) {
                contentColorStr += "'" + color + "',";
            }
            contentColorStr = contentColorStr.substring(0, contentColorStr.length() - 1);
            filterColor = beginColorStr + contentColorStr + endColorStr;
        }

        if (sizeFilterArr != null) {
            for (String size : sizeFilterArr) {
                contentSizeStr += "'" + size + "',";
            }
            contentSizeStr = contentSizeStr.substring(0, contentSizeStr.length() - 1);
            filterSize = beginSizeStr + contentSizeStr + endSizeStr;
        }

        List<Object[]> allProductFilteredByPrice = productsFacade.productsByFilter_OfACategory(cateID, fromPrice, toPrice, filterColor, filterSize);

        int numberOfProducts = allProductFilteredByPrice.size();
        
        return "" + numberOfProducts;
    }

    @ResponseBody
    @RequestMapping(value = "/ajax/productPaginationForSubCate", method = RequestMethod.POST)
    public String productPaginationForSubCate(
            @RequestParam("subCateID") Integer subCateID,
            @RequestParam("page") Integer page,
            @RequestParam("itemPerPage") Integer itemPerPage,
            @RequestParam("sortBy") Integer sortBy,
            @RequestParam("fromPrice") Double fromPrice,
            @RequestParam("toPrice") Double toPrice,
            @RequestParam(value = "colorFilterArrSubCate[]", required = false) List<String> colorFilterArrSubCate,
            @RequestParam(value = "sizeFilterArrSubCate[]", required = false) List<String> sizeFilterArrSubCate) {
        if (fromPrice == null) {
            fromPrice = productsFacade.getMinPriceOfProduct_BySubCate(subCateID);
        }

        if (toPrice == null) {
            toPrice = productsFacade.getMaxPriceOfProduct_BySubCate(subCateID);
        }
        String filterColor = "";
        String beginColorStr = "AND pc.color in (";
        String endColorStr = ") ";
        String contentColorStr = "";

        String filterSize = "";
        String beginSizeStr = "AND ps.size in (";
        String endSizeStr = ") ";
        String contentSizeStr = "";

        if (colorFilterArrSubCate != null) {
            for (String color : colorFilterArrSubCate) {
                contentColorStr += "'" + color + "',";
            }
            contentColorStr = contentColorStr.substring(0, contentColorStr.length() - 1);
            filterColor = beginColorStr + contentColorStr + endColorStr;
        }

        if (sizeFilterArrSubCate != null) {
            for (String size : sizeFilterArrSubCate) {
                contentSizeStr += "'" + size + "',";
            }
            contentSizeStr = contentSizeStr.substring(0, contentSizeStr.length() - 1);
            filterSize = beginSizeStr + contentSizeStr + endSizeStr;
        }

        List<Object[]> productIDList = productsFacade.filterProductBySubCategory(subCateID, page, itemPerPage, fromPrice, toPrice, filterColor, filterSize, sortBy);
        List<Products> finalProductList = new ArrayList<>();
        for (Object[] prod : productIDList) {

            Products product = productsFacade.findProductByID((Integer) prod[0]);
            finalProductList.add(product);
        }
        ObjectMapper mapper = new ObjectMapper();
        String result = "";
        try {
            result = mapper.writeValueAsString(finalProductList);
        } catch (JsonProcessingException ex) {
            Logger.getLogger(ProductController.class.getName()).log(Level.SEVERE, null, ex);
        }

        return result;
    }

    @ResponseBody
    @RequestMapping(value = "/ajax/getNumberOfProductsByFilter_OfASubCategory", method = RequestMethod.POST)
    public String getNumberOfProductsByFilter_OfASubCategory(
            @RequestParam("subCateID") Integer subCateID,
            @RequestParam("fromPrice") Double fromPrice,
            @RequestParam("toPrice") Double toPrice,
            @RequestParam(value = "colorFilterArrSubCate[]", required = false) List<String> colorFilterArrSubCate,
            @RequestParam(value = "sizeFilterArrSubCate[]", required = false) List<String> sizeFilterArrSubCate
    ) {
        if (fromPrice == null) {
            fromPrice = productsFacade.getMinPriceOfProduct_BySubCate(subCateID);
        }

        if (toPrice == null) {
            toPrice = productsFacade.getMaxPriceOfProduct_BySubCate(subCateID);
        }
        String filterColor = "";
        String beginColorStr = "AND pc.color in (";
        String endColorStr = ") ";
        String contentColorStr = "";

        String filterSize = "";
        String beginSizeStr = "AND ps.size in (";
        String endSizeStr = ") ";
        String contentSizeStr = "";

        if (colorFilterArrSubCate != null) {
            for (String color : colorFilterArrSubCate) {
                contentColorStr += "'" + color + "',";
            }
            contentColorStr = contentColorStr.substring(0, contentColorStr.length() - 1);
            filterColor = beginColorStr + contentColorStr + endColorStr;
        }

        if (sizeFilterArrSubCate != null) {
            for (String size : sizeFilterArrSubCate) {
                contentSizeStr += "'" + size + "',";
            }
            contentSizeStr = contentSizeStr.substring(0, contentSizeStr.length() - 1);
            filterSize = beginSizeStr + contentSizeStr + endSizeStr;
        }

        List<Object[]> allProductFilteredByPrice = productsFacade.productsByFilter_OfASubCategory(subCateID, fromPrice, toPrice, filterColor, filterSize);

        int numberOfProducts = allProductFilteredByPrice.size();
        return "" + numberOfProducts;
    }

    @ResponseBody
    @RequestMapping(value = "/ajax/submitReviewRating", method = RequestMethod.POST)
    public String submitReviewRating(
            @RequestParam("productID") Integer productID,
            @RequestParam("userID") Integer userID,
            @RequestParam("ratingVal") Integer ratingVal,
            @RequestParam("review") String review
    ) {
        Products thatProd = productsFacade.findProductByID(productID);

        Rating newRating = new Rating();
        newRating.setProduct(thatProd);
        newRating.setUser(usersFacade.getUserByID(userID));
        newRating.setRating(ratingVal);
        newRating.setRatingDate(new Date());
        newRating.setReview(review);
        newRating.setStatus((short) 2);//2: pending

        if (productsFacade.createNewProductRating(productID, newRating)) {
            return "ok";
        } else {
            return "false";
        }
    }

    

    @ResponseBody
    @RequestMapping(value = "ajax/searchProductByKeyWord", method = RequestMethod.POST)
    public String searchProductByKeyWord(
            @RequestParam("keyword") String keyword
    ) {
        List<Products> productList = productsFacade.getSearchedProducts(keyword);

        String result = "";

        for (Products p : productList) {
            result += "<li class=\"fs-search-result\">\n"
                    + "     <a href=\"" + p.getProductID()+ "-" + p.getProductColorListWorking().get(0).getColorID()+ ".html\">"
                    + "         "+ p.getProductName() +""
                    + "     </a>\n"
                    + "</li>";
        }

        return result;
    }

    private UsersFacadeLocal lookupUsersFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (UsersFacadeLocal) c.lookup("java:global/ShoeGardenPJ/UsersFacade!spring.ejb.UsersFacadeLocal");
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

    private BrandsFacadeLocal lookupBrandsFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (BrandsFacadeLocal) c.lookup("java:global/ShoeGardenPJ/BrandsFacade!spring.ejb.BrandsFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
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

    private OrderStateFullBeanLocal lookupOrderStateFullBeanLocal() {
        try {
            Context c = new InitialContext();
            return (OrderStateFullBeanLocal) c.lookup("java:global/ShoeGardenPJ/OrderStateFullBean!spring.ejb.OrderStateFullBeanLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    private SizesByColorFacadeLocal lookupSizesByColorFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (SizesByColorFacadeLocal) c.lookup("java:global/ShoeGardenPJ/SizesByColorFacade!spring.ejb.SizesByColorFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    private ProductColorsFacadeLocal lookupProductColorsFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (ProductColorsFacadeLocal) c.lookup("java:global/ShoeGardenPJ/ProductColorsFacade!spring.ejb.ProductColorsFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    
}
