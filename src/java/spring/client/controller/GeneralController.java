package spring.client.controller;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import spring.ejb.BrandsFacadeLocal;
import spring.ejb.CategoriesFacadeLocal;
import spring.ejb.DiscountDetailsFacadeLocal;
import spring.ejb.DiscountsFacadeLocal;
import spring.ejb.ProductsFacadeLocal;
import spring.ejb.RatingFacadeLocal;
import spring.ejb.UsersFacadeLocal;
import spring.entity.Brands;

import spring.entity.Categories;
import spring.entity.DiscountDetails;
import spring.entity.Discounts;
import spring.entity.ProductColors;
import spring.entity.Products;
import spring.entity.Users;
import spring.functions.SharedFunctions;

@Controller
public class GeneralController {

    DiscountDetailsFacadeLocal discountDetailsFacade = lookupDiscountDetailsFacadeLocal();

    DiscountsFacadeLocal discountsFacade = lookupDiscountsFacadeLocal();

    RatingFacadeLocal ratingFacade = lookupRatingFacadeLocal();

    UsersFacadeLocal usersFacade = lookupUsersFacadeLocal();

    BrandsFacadeLocal brandsFacade = lookupBrandsFacadeLocal();

    CategoriesFacadeLocal categoriesFacade = lookupCategoriesFacadeLocal();

    ProductsFacadeLocal productsFacade = lookupProductsFacadeLocal();

//    ProductStateLessBeanLocal productStateLessBean = lookupProductStateLessBeanLocal();
//    BlogsSBLocal blogsSB = lookupBlogsSBLocal();
//    UsersStateLessBeanLocal usersStateLessBean = lookupUsersStateLessBeanLocal();
    @Autowired
    SharedFunctions sharedFunc;

    @RequestMapping(value = "/index")
    public String index(ModelMap model) {
        List<Brands> cateList = brandsFacade.findAll();
//        List<Blogs> blogListIndex = blogsSB.getAllBlogsIndex();
        for (Brands cate : cateList) {
            List<Products> productListByCate = cate.getProductsList();
            Collections.shuffle(productListByCate);
        }
        List<Object[]> bestSellerList = productsFacade.getTop3ProductBestSeller();
        List<Products> mostViewList = productsFacade.getTop3ProductMostViewed();

        List<Object[]> productTopRateList = productsFacade.getProductTop3Rated();
        List<Object[]> newTopRateList = new ArrayList<>();

        for (Object[] rate : productTopRateList) {
            int productID = (int) rate[0];
            Products product = productsFacade.findProductByID(productID);
            double avgRating = (double) rate[1];
            Object[] newObj = new Object[]{product, avgRating};
            newTopRateList.add(newObj);
        }

        List<Discounts> discount = discountsFacade.selectTop3Discount();

        model.addAttribute("braList", cateList);
        model.addAttribute("latestProducts", productsFacade.productList("client")); //lấy sản phẩm mới nhất
        model.addAttribute("bestSellerList", bestSellerList); //lấy sản phẩm bán chạy nhất
        model.addAttribute("mostViewList", mostViewList); //lấy sản phẩm xem nhiều nhất
        model.addAttribute("productTopRateList", newTopRateList); //lấy sản phẩm được rate nhiều nhất
        model.addAttribute("discount", discount); //lay 3 discount gan nhat dang trong thoi han
//        model.addAttribute("blogListIndex", blogListIndex);
        return "client/pages/index";
    }

    @RequestMapping(value = "/admin/index")
    public String admin(ModelMap model) {

        return "redirect:/admin/orders/orderchart.html";
    }

    @ResponseBody
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String login(ModelMap model,
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            @RequestParam(value = "checkremember", required = false) Short checkremember,
            HttpSession session, RedirectAttributes redirectAttributes,
            HttpServletResponse response
    ) {
        String err = "";
        int error = usersFacade.checkLoginUser(email, sharedFunc.encodePassword(password));
        if (error == 1) {
            session.setAttribute("emailUser", email);
            err = (String) session.getAttribute("emailUser");
            Users userfindUserID = usersFacade.findUserByEmail(email);
            session.setAttribute("findUsersID", userfindUserID.getUserID());
            session.setAttribute("USfirstname", userfindUserID.getFirstName() + " " + userfindUserID.getLastName());
            if (userfindUserID.getRoleID().getRoleID() == 1 || userfindUserID.getRoleID().getRoleID() == 2) {
                session.setAttribute("userRole", "mod");
            }

            if (checkremember != null && checkremember == 1) {
                Cookie ckEmail = new Cookie("emailU", email);
                ckEmail.setMaxAge(24 * 60 * 60);
                response.addCookie(ckEmail);
                Cookie ckPassword = new Cookie("passwordU", sharedFunc.encodePassword(password));
                ckPassword.setMaxAge(24 * 60 * 60);
                response.addCookie(ckPassword);
            }
            return err;
        } else if (error == 2) {
            return "2";
        } else if (error == 3) {
            return "4";
        } else {
            return "3";
        }
    }

    @RequestMapping(value = "/logout")
    public String logOut(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        //Remove Session
        session.removeAttribute("emailUser");
        session.removeAttribute("findUsersID");
        session.removeAttribute("USfirstname");
        session.removeAttribute("userRole");

        //Remove cookie
        for (Cookie ck : request.getCookies()) {
            if (ck.getName().equalsIgnoreCase("emailU")) {
                ck.setMaxAge(0);
                response.addCookie(ck);
            }
            if (ck.getName().equalsIgnoreCase("passwordU")) {
                ck.setMaxAge(0);
                response.addCookie(ck);
            }
        }
        return "redirect:/index.html";
    }

    @ResponseBody
    @RequestMapping(value = "ajax/discountProduct", method = RequestMethod.POST)
    public String getProductWithDiscount(@RequestParam("discountID") Integer discID, HttpSession session) {
        List<DiscountDetails> list = discountDetailsFacade.findListByDiscID(discID);
        String dynamicContent = "";
        DecimalFormat df = new DecimalFormat("#.00"); 
        dynamicContent += "<div class=\"row\" style=\"position: relative;\"><div id=\"fs-change-data-here\">";
        for (DiscountDetails discountDetails : list) {
            Products product = discountDetails.getProductID();
            dynamicContent += "<div class=\"col-md-4 col-sm-6\"><div class=\"product-item\">\n"
                    + "                                <div class=\"item-thumb\">\n";
            if (discountDetailsFacade.getProductWithDiscount(product) != product.getPrice()) {
                dynamicContent += "<div class=\"badge offer\" style=\"\n"
                        + "    width: 59px;\n"
                        + "    height: 52px;\n"
                        + "\">-" + discountDetailsFacade.getDiscountByProduct(product) + "%</div>\n";
            }
            dynamicContent += "<img src=\"assets/images/products/" + product.getUrlImg() + "\"\n"
                    + "                                         class=\"img-responsive\" \n"
                    + "                                         alt=\"${product.urlImg}\"\n"
                    + "                                         fs-product-for-img=\"" + product.getProductID() + "\"/>\n"
                    + "                                    <div class=\"overlay-rmore fa fa-search quickview fs-product-modal\" \n"
                    + "                                         fs-product=\"" + product.getProductID() + "\" \n"
                    + "                                         fs-product-modal-color=\"" + product.getProductColorListWorking().get(0).getColorID() + "\" \n"
                    + "                                         data-toggle=\"modal\" >\n"
                    + "                                    </div>\n"
                    
                    + "                                </div>\n"
                    + "                                <div class=\"product-info\">\n"
                    + "                                    <h4 class=\"product-title\">\n"
                    + "                                        <a href=\"" + product.getProductID() + "-" + product.getProductColorListWorking().get(0).getColorID() + ".html\">\n"
                    + "                                            " + product.getProductName() + "\n"
                    + "                                        </a>\n"
                    + "                                    </h4>\n"
                    + "                                    <span class=\"product-price\">\n";
            if (discountDetailsFacade.getProductWithDiscount(product) != product.getPrice()) {

                dynamicContent += "<small class=\"cutprice\">$" + product.getPrice() + "0 </small>"
                        + "$"+df.format(discountDetailsFacade.getProductWithDiscount(product))+"\n";
            } else if (discountDetailsFacade.getProductWithDiscount(product) == product.getPrice()) {
                dynamicContent += "$ " + product.getPrice() + "0\n";
            }
            dynamicContent += "</span>\n"
                    + "                                    <div class=\"item-colors\" style=\"height: 25px;\">\n";
            if (product.getProductColorListWorking().size() > 1) {
                for (ProductColors color : product.getProductColorListWorking()) {
                    dynamicContent += "<img src=\"assets/images/products/colors/" + color.getUrlColorImg() + "\" \n"
                            + "                                                     class=\"img-responsive fs-index-color-img\" \n"
                            + "                                                     fs-index-color-img=\""+color.getColorID()+"\" \n"
                            + "                                                     fs-product=\"" + product.getProductID() + "\" \n"
                            + "                                                     alt=\"" + color.getUrlColorImg() + "\" \n"
                            + "                                                     title=\"" + color.getColor() + "\"/>\n";
                }
            }
            dynamicContent += "</div>\n"
                    + "                                </div>\n"
                    + "                            </div></div>";
        }
        dynamicContent += "</div></div>";
        return dynamicContent;
    }

//    private ProductStateLessBeanLocal lookupProductStateLessBeanLocal() {
//        try {
//            Context c = new InitialContext();
//            return (ProductStateLessBeanLocal) c.lookup("java:global/fashionshop/ProductStateLessBean!spring.ejb.ProductStateLessBeanLocal");
//        } catch (NamingException ne) {
//            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
//            throw new RuntimeException(ne);
//        }
//    }
//
//    private UsersStateLessBeanLocal lookupUsersStateLessBeanLocal() {
//        try {
//            Context c = new InitialContext();
//            return (UsersStateLessBeanLocal) c.lookup("java:global/fashionshop/UsersStateLessBean!spring.ejb.UsersStateLessBeanLocal");
//        } catch (NamingException ne) {
//            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
//            throw new RuntimeException(ne);
//        }
//    }
//
//    private BlogsSBLocal lookupBlogsSBLocal() {
//        try {
//            Context c = new InitialContext();
//            return (BlogsSBLocal) c.lookup("java:global/fashionshop/BlogsSB!spring.ejb.BlogsSBLocal");
//        } catch (NamingException ne) {
//            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
//            throw new RuntimeException(ne);
//        }
//    }
    private ProductsFacadeLocal lookupProductsFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (ProductsFacadeLocal) c.lookup("java:global/ShoeGardenPJ/ProductsFacade!spring.ejb.ProductsFacadeLocal");
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

    private BrandsFacadeLocal lookupBrandsFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (BrandsFacadeLocal) c.lookup("java:global/ShoeGardenPJ/BrandsFacade!spring.ejb.BrandsFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
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

    private RatingFacadeLocal lookupRatingFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (RatingFacadeLocal) c.lookup("java:global/ShoeGardenPJ/RatingFacade!spring.ejb.RatingFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
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
}
