package spring.client.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import spring.ejb.BrandsFacadeLocal;
import spring.ejb.CategoriesFacadeLocal;
import spring.ejb.OrderStateFullBean;
import spring.ejb.OrderStateFullBeanLocal;
import spring.ejb.OrderStateLessBeanLocal;

import spring.ejb.ProductsFacadeLocal;
import spring.ejb.SizesByColorFacadeLocal;
import spring.ejb.UserAddressesStateLessBeanLocal;
import spring.ejb.UsersFacadeLocal;
import spring.entity.Brands;
import spring.entity.CartLineInfo;

import spring.entity.Categories;

import spring.entity.Orders;
import spring.entity.Products;
import spring.entity.SizesByColor;
import spring.entity.UserAddresses;

import spring.entity.Users;

@Controller
@RequestMapping(value = "/orders/")
public class OrdersController{

    SizesByColorFacadeLocal sizesByColorFacade = lookupSizesByColorFacadeLocal();

    UserAddressesStateLessBeanLocal userAddressesStateLessBean = lookupUserAddressesStateLessBeanLocal();

    private @Autowired HttpServletRequest request;

    BrandsFacadeLocal brandsFacade = lookupBrandsFacadeLocal();

    CategoriesFacadeLocal categoriesFacade = lookupCategoriesFacadeLocal();

    OrderStateLessBeanLocal orderStateLessBean = lookupOrderStateLessBeanLocal();

    UsersFacadeLocal usersFacade = lookupUsersFacadeLocal();

    ProductsFacadeLocal productsFacade = lookupProductsFacadeLocal();

//    UserAddressesStateLessBeanLocal userAddressesStateLessBean = lookupUserAddressesStateLessBeanLocal();
//    UsersStateLessBeanLocal usersStateLessBean = lookupUsersStateLessBeanLocal();
//    ProductStateLessBeanLocal productStateLessBean = lookupProductStateLessBeanLocal();
//    OrderStateFulBeanLocal orderStateFulBean = lookupOrderStateFulBeanLocal();
//    OrderStateLessBeanLocal orderStateLessBean = lookupOrderStateLessBeanLocal();
    @ResponseBody
    @RequestMapping(value = "ajax/getSession", method = RequestMethod.GET)
    public String ajaxGetSession(HttpServletRequest request) {
        String emailUser = (String) request.getSession().getAttribute("emailUser");
        if (emailUser == null || emailUser.equals("")) {
            return "0";
        }
        return "1";
    }
    
    @ResponseBody
    @RequestMapping(value = "ajax/checkquantity", method = RequestMethod.POST)
    public String checkquantity(
            @RequestParam("sizeID") Integer sizeID,@RequestParam("colorID") Integer colorID
    ) {
        
        OrderStateFullBeanLocal orderStateFullBean = (OrderStateFullBeanLocal) request.getSession().getAttribute("cart");
        
        
        if(orderStateFullBean==null){
            System.err.println("quantity");
            orderStateFullBean = lookupOrderStateFullBeanLocal();
            request.getSession().setAttribute("cart", orderStateFullBean);
        }
        
        int inCartquantity = 0;
        SizesByColor s = sizesByColorFacade.find(sizeID);
        //lay so luong trong cart
        List<CartLineInfo> cli = orderStateFullBean.showCart();
        
        for (CartLineInfo cartLineInfo : cli) {
            if(cartLineInfo.getSizesByColor().getSizeID()==sizeID){
                inCartquantity = cartLineInfo.getQuantity();
            }
        }
        
        
        
        int quantityInDB = sizesByColorFacade.findSizeByColorBySizeIDAndColorID(Integer.parseInt(s.getSize()), colorID).getQuantity();
        int realQuantity = quantityInDB - inCartquantity;
        
        
        String returnValue = "";
            
        returnValue = inCartquantity+"-"+realQuantity+"-"+quantityInDB;
        
        
        return returnValue;
    }

    @ResponseBody
    @RequestMapping(value = "ajax/addtocart", method = RequestMethod.POST)
    public String ajaxAddtocart(@RequestParam("productID") Integer productID,
            @RequestParam("sizeID") Integer sizeID,
            @RequestParam("colorID") Integer colorID,
            @RequestParam("quantity") Integer quantity) {
        Products pro = orderStateLessBean.getProductByID(productID);

        SizesByColor sizesByColor = orderStateLessBean.getSizesByColorBySizeIDandColorID(sizeID, colorID);

        OrderStateFullBeanLocal orderStateFullBean = (OrderStateFullBeanLocal) request.getSession().getAttribute("cart");
        
        
        if(orderStateFullBean==null){
            orderStateFullBean = lookupOrderStateFullBeanLocal();
        }
        
        if (pro != null) {
            if (sizesByColor != null) {

                int inCartquantity = 0;

                SizesByColor s = sizesByColorFacade.find(sizeID);
                int quantityInDB = sizesByColorFacade.findSizeByColorBySizeIDAndColorID(Integer.parseInt(s.getSize()), colorID).getQuantity();

                //lay so luong trong cart
                List<CartLineInfo> cli = orderStateFullBean.showCart();
                if (cli.size() != 0) {
                    for (CartLineInfo cartLineInfo1 : cli) {

                        if (cartLineInfo1.getSizesByColor().getSizeID() == sizeID) {
                            inCartquantity += cartLineInfo1.getQuantity();

                        }
                    }
                }

                if (inCartquantity > quantityInDB) {
                    return "1";
                } else {

                    CartLineInfo cartLineInfo = new CartLineInfo();
                    cartLineInfo.setProduct(pro);
                    cartLineInfo.setSizesByColor(sizesByColor);
                    cartLineInfo.setQuantity(quantity);
                    orderStateFullBean.addProduct(cartLineInfo);

                    inCartquantity = cartLineInfo.getQuantity();
                    
                    int realQuantity = quantityInDB - inCartquantity;

                    String returnValue = "";

                    returnValue = inCartquantity + "-" + realQuantity + "-" + quantityInDB;

                    request.getSession().setAttribute("cart", orderStateFullBean);
                    
                    return returnValue; //Add Product to Cart Successfully!
                }
                
                
            }
            return "2"; //Color and Size error!
        }
        return "3";
    }

    @RequestMapping(value = "checkout", method = RequestMethod.GET)
    public String checkout(ModelMap model) {
        String email = (String) request.getSession().getAttribute("emailUser");
        OrderStateFullBeanLocal orderStateFullBean = (OrderStateFullBeanLocal) request.getSession().getAttribute("cart");
        
        
        if(orderStateFullBean==null){
            orderStateFullBean = lookupOrderStateFullBeanLocal();
            request.getSession().setAttribute("cart", orderStateFullBean);
        }
        if (email == null || orderStateFullBean.showCart().size() == 0) {
            return "redirect:/index.html";
        } else {
            Users users = usersFacade.findUserByEmail(email);
            if (users == null) {
                return "redirect:/index.html";
            } else {
                //2 dòng này thêm để render ra menu chính
                List<Brands> cateList = brandsFacade.findAll();
                model.addAttribute("emailU", users);
                model.addAttribute("braList", cateList);
                model.addAttribute("userAddressList", userAddressesStateLessBean.AddressListUser(users.getUserID()));
                model.addAttribute("cartList", orderStateFullBean.showCart());
                model.addAttribute("grandTotal", orderStateFullBean.subTotal());
                return "client/pages/checkout";
            }
        }
    }

    @RequestMapping(value = "checkout", method = RequestMethod.POST)
    public String checkoutPost(ModelMap model, RedirectAttributes flashAttr) {
        OrderStateFullBeanLocal orderStateFullBean = (OrderStateFullBeanLocal) request.getSession().getAttribute("cart");
        
        
        if(orderStateFullBean==null)
            orderStateFullBean = lookupOrderStateFullBeanLocal();
        String addressChoice = request.getParameter("address-chose");
        String success_orderID = "";
        String email = (String) request.getSession().getAttribute("emailUser");
        Users users = usersFacade.findUserByEmail(email);
        String addressSize = request.getParameter("addressSize");
        String note = request.getParameter("note");
        if (addressSize.equals("0")) {
            String firstname = request.getParameter("diffFirstname");
            String lastname = request.getParameter("diffLastname");
            String address = request.getParameter("diffAddress");
            String phone = request.getParameter("diffPhone");
            Orders orders = new Orders();
            orders.setUserID(users);
            orders.setOrdersDate(new Date());
            orders.setReceiverFirstName(firstname);
            orders.setReceiverLastName(lastname);
            orders.setPhoneNumber(phone);
            orders.setDeliveryAddress(address);

            orders.setNote(note);
            orders.setStatus(Short.parseShort("2"));
            success_orderID = orderStateFullBean.completePurchase(orders);
        } else {
            if (addressChoice.equals("difference")) {
                String firstname = request.getParameter("diffFirstname");
                String lastname = request.getParameter("diffLastname");
                String address = request.getParameter("diffAddress");
                String phone = request.getParameter("diffPhone");
                Orders orders = new Orders();
                orders.setUserID(users);
                orders.setOrdersDate(new Date());
                orders.setReceiverFirstName(firstname);
                orders.setReceiverLastName(lastname);
                orders.setPhoneNumber(phone);
                orders.setDeliveryAddress(address);
//                if (discountVoucher != null) {
//                    orders.setVoucher(discountVoucher);
//                } else {
//                    orders.setVoucher(null);
//                }
                orders.setNote(note);
                orders.setStatus(Short.parseShort("2"));
                success_orderID = orderStateFullBean.completePurchase(orders);
            } else {
                UserAddresses userAddresses = userAddressesStateLessBean.findAddressID(Integer.parseInt(addressChoice));
                if (userAddresses != null) {
                    String firstname = users.getFirstName();
                    String lastname = users.getLastName();
                    String address = userAddresses.getAddress();
                    String phone = userAddresses.getPhoneNumber();
                    Orders orders = new Orders();
                    orders.setUserID(users);
                    orders.setOrdersDate(new Date());
                    orders.setReceiverFirstName(firstname);
                    orders.setReceiverLastName(lastname);
                    orders.setPhoneNumber(phone);
                    orders.setDeliveryAddress(address);
//                    if (discountVoucher != null) {
//                        orders.setVoucher(discountVoucher);
//                    } else {
//                        orders.setVoucher(null);
//                    }
                    orders.setNote(note);
                    orders.setStatus(Short.parseShort("2"));
                    success_orderID = orderStateFullBean.completePurchase(orders);
                } else {
                    return "redirect:/orders/checkout.html";
                }
            }
        }
        if (success_orderID.equals("000")) {
            flashAttr.addFlashAttribute("error", "<div class=\"alert alert-danger\">\n"
                    + "<strong>ERROR</strong>\n"
                    + "</div>");
            return "redirect:/orders/checkout.html";
        } else {
            return "redirect:/orders/checkout-success/" + success_orderID + ".html";
        }
    }

    @RequestMapping(value = "checkout-success/{success_orderID}")
    public String checkout_success(ModelMap model, @PathVariable("success_orderID") Integer success_orderID) {
        //2 dòng này thêm để render ra menu chính
        List<Brands> cateList = brandsFacade.findAll();
        model.addAttribute("braList", cateList);
        model.addAttribute("success_orderID", success_orderID);
        return "client/pages/checkout-success";
    }

    @RequestMapping(value = "shoppingcart")
    public String shoppingcart(ModelMap model) {
        
        OrderStateFullBeanLocal orderStateFullBean = (OrderStateFullBeanLocal) request.getSession().getAttribute("cart");
        
        
        if(orderStateFullBean==null){
            orderStateFullBean = lookupOrderStateFullBeanLocal();
            request.getSession().setAttribute("cart", orderStateFullBean);
        }
        
        if (orderStateFullBean.showCart().size() == 0 || orderStateFullBean.showCart() == null) {
            return "redirect:/index.html";
        }
        //2 dòng này thêm để render ra menu chính
        List<Products> proList = productsFacade.selectTop8Product();
        List<Brands> cateList = brandsFacade.findAll();
        model.addAttribute("proList", proList);
        model.addAttribute("braList", cateList);
        model.addAttribute("cartList", orderStateFullBean.showCart());
        model.addAttribute("grandTotal", orderStateFullBean.subTotal());
        return "client/pages/shoppingcart";
    }

    @RequestMapping(value = "updatecart", method = RequestMethod.POST)
    public String updatecart(ModelMap model, RedirectAttributes flashAttr) {
        String error = "";
        OrderStateFullBeanLocal orderStateFullBean = (OrderStateFullBeanLocal) request.getSession().getAttribute("cart");
        
        
        if(orderStateFullBean==null){
            orderStateFullBean = lookupOrderStateFullBeanLocal();
            
        }
        for (CartLineInfo cartLineInfo : orderStateFullBean.showCart()) {
            String codeIdentify = cartLineInfo.getProduct().getProductID() + "-"
                    + cartLineInfo.getSizesByColor().getSizeID() + "-"
                    + cartLineInfo.getSizesByColor().getColorID().getColorID();
            if (request.getParameter(codeIdentify) != null) {
                CartLineInfo oldCartLineInfo = cartLineInfo;
                cartLineInfo.setQuantity(Integer.parseInt(request.getParameter(codeIdentify)));
                SizesByColor sizesByColor = orderStateLessBean.getSizesByColorBySizeIDandColorID(cartLineInfo.getSizesByColor().getSizeID(), cartLineInfo.getSizesByColor().getColorID().getColorID());
                if (sizesByColor != null) {
                    if (sizesByColor.getQuantity() < Integer.parseInt(request.getParameter(codeIdentify))) {
                        error += " " + sizesByColor.getColorID().getProductID().getProductName() + "  ";
                    } else {
                        orderStateFullBean.updateProduct(oldCartLineInfo, cartLineInfo);
                    }
                }
            }
        }
        if (error.equals("")) {
            flashAttr.addFlashAttribute("error", "<div class=\"alert alert-success\">\n"
                    + "<strong>UPDATE CART SUCCESSFULLY</strong>\n"
                    + "</div>");
            request.getSession().setAttribute("cart", orderStateFullBean);
            return "redirect:/orders/shoppingcart.html";
        } else {
            flashAttr.addFlashAttribute("error", "<div class=\"alert alert-danger\">\n"
                    + "<strong>PRODUCT" + error + " OUT OF STOCK</strong>\n"
                    + "</div>");
            return "redirect:/orders/shoppingcart.html";
        }
    }

    @RequestMapping(value = "deleteitemCart/{productid}/{sizeID}/{colorID}", method = RequestMethod.GET)
    public String deleteitemCart(@PathVariable("productid") int productid,
            @PathVariable("sizeID") int sizeid,
            @PathVariable("colorID") int colorid,
            RedirectAttributes flashAttr) {
        OrderStateFullBeanLocal orderStateFullBean = (OrderStateFullBeanLocal) request.getSession().getAttribute("cart");
        
        
        if(orderStateFullBean==null){
            orderStateFullBean = lookupOrderStateFullBeanLocal();
            request.getSession().setAttribute("cart", orderStateFullBean);
        }
        CartLineInfo cartLineInfo = orderStateFullBean.getProductInListByID(productid, sizeid, colorid);
        if (cartLineInfo != null) {
            orderStateFullBean.deleteProduct(cartLineInfo);
            if (orderStateFullBean.showCart().size() == 0 || orderStateFullBean.showCart() == null) {
                request.getSession().setAttribute("cart", orderStateFullBean);
                return "redirect:/index.html";
            }
        }

        flashAttr.addFlashAttribute("error", "<div class=\"alert alert-success\">\n"
                + "<strong>DELETE ITEM SUCCESSFULLY</strong>\n"
                + "</div>");
        return "redirect:/orders/shoppingcart.html";
    }

    @ResponseBody
    @RequestMapping(value = "deleteitemCartInHeader", method = RequestMethod.POST)
    public String deleteitemCartInHeader(@RequestParam("productID") Integer productid,
            @RequestParam("sizeID") Integer sizeid,
            @RequestParam("colorID") Integer colorid) {
        OrderStateFullBeanLocal orderStateFullBean = (OrderStateFullBeanLocal) request.getSession().getAttribute("cart");
        
        
        if(orderStateFullBean==null){
            orderStateFullBean = lookupOrderStateFullBeanLocal();
            request.getSession().setAttribute("cart", orderStateFullBean);
        }
        CartLineInfo cartLineInfo = orderStateFullBean.getProductInListByID(productid, sizeid, colorid);
        if (cartLineInfo != null) {
            orderStateFullBean.deleteProduct(cartLineInfo);
            request.getSession().setAttribute("cart", orderStateFullBean);
        }
        return getCart();
    }

    @RequestMapping(value = "order-history")
    public String orderhistory(ModelMap model, HttpServletRequest request) {
        String email = (String) request.getSession().getAttribute("emailUser");
        if (email == null) {
            return "redirect:/index.html";
        }
        model.addAttribute("orderStatus", 4);
        model.addAttribute("orderList", orderStateLessBean.getAllOrderByUserID(usersFacade.findUserByEmail(email).getUserID()));
        //2 dòng này thêm để render ra menu chính
        List<Brands> cateList = brandsFacade.findAll();
        model.addAttribute("braList", cateList);
        return "client/pages/order-history";
    }

    @RequestMapping(value = "order-history/{status}")
    public String orderhistoryByStatus(ModelMap model, HttpServletRequest request, @PathVariable("status") Integer status) {
        String email = (String) request.getSession().getAttribute("emailUser");
        if (email == null) {
            return "redirect:/index.html";
        }
        model.addAttribute("orderStatus", status);
        model.addAttribute("orderList", orderStateLessBean.getAllOrderByUserIDAndStatus(usersFacade.findUserByEmail(email).getUserID(), status));
        //2 dòng này thêm để render ra menu chính
        List<Brands> cateList = brandsFacade.findAll();
        model.addAttribute("cateList", cateList);
        return "client/pages/order-history";
    }

    @RequestMapping(value = "order-history-detail/{orderID}")
    public String orderhistorydetail(ModelMap model, @PathVariable("orderID") Integer orderID, HttpServletRequest request) {
        String email = (String) request.getSession().getAttribute("emailUser");
        if (email == null) {
            return "redirect:/index.html";
        }
        model.addAttribute("orderdetailList", orderStateLessBean.getAllOrderDetailByOrderID(orderID));
        model.addAttribute("order", orderStateLessBean.getOrderByID(orderID));
       
        //2 dòng này thêm để render ra menu chính
        List<Brands> cateList = brandsFacade.findAll();
        model.addAttribute("braList", cateList);
        return "client/pages/order-history-detail";
    }

    @RequestMapping(value = "cancelorder/{orderID}", method = RequestMethod.GET)
    public String cancelorder(@PathVariable("orderID") Integer orderID) {
        Orders order = orderStateLessBean.getOrderByID(orderID);
        if (order != null) {
            if (orderStateLessBean.confirmStatusOrder(order, Short.parseShort("0"))) {
                return "redirect:/orders/order-history.html";
            }
        }
        return "redirect:/orders/order-history.html";
    }
    @ResponseBody
    @RequestMapping(value = "ajax/cartdeleteall", method = RequestMethod.GET)
    public String deleteAll(){
        request.getSession().removeAttribute("cart");
        return "1";
    }
    
    @ResponseBody
    @RequestMapping(value = "ajax/deletecartitem", method = RequestMethod.POST)
    public String deleteItem(@RequestParam("cartInfo") int cartInfo){
        OrderStateFullBeanLocal orderStateFullBean = (OrderStateFullBeanLocal) request.getSession().getAttribute("cart");
        
        if(orderStateFullBean==null){
            orderStateFullBean = lookupOrderStateFullBeanLocal();
            request.getSession().setAttribute("cart", orderStateFullBean);
        }
        
        
        if(orderStateFullBean.deleteItem(cartInfo))
            return "1";
        return "0";
    }

    @ResponseBody
    @RequestMapping(value = "ajax/cart", method = RequestMethod.GET)
    public String getCart() {
        OrderStateFullBeanLocal orderStateFullBean = (OrderStateFullBeanLocal) request.getSession().getAttribute("cart");
        
        if(orderStateFullBean==null){
            orderStateFullBean = lookupOrderStateFullBeanLocal();
            request.getSession().setAttribute("cart", orderStateFullBean);
        }
        int size = orderStateFullBean.showCart().size();
        String cart_info = "";
        float subtotal = orderStateFullBean.subTotal();
        for (CartLineInfo cartLineInfo : orderStateFullBean.showCart()) {
            cart_info += "<li class=\"product\" fs-cartInfo=\""+orderStateFullBean.showCart().indexOf(cartLineInfo)+"\" >"
                + "<div class=\"product-image\">"
                + "<a href=\"#0\">"
                + "<img src=\"assets/images/products/"+cartLineInfo.getProduct().getUrlImg()+"\" alt=\""+cartLineInfo.getProduct().getProductName()+"\">"
                + "</a>"
                + "</div>"
                + "<div class=\"product-details\">"
                + "<h3><a href=\""+ cartLineInfo.getProduct().getProductID() + "-" + cartLineInfo.getProduct().getProductColorsList().get(0).getColorID() + ".html\"></a>"+cartLineInfo.getProduct().getProductName()+"</h3>"
                + "<div class=\"actions\"><a href=\"#0\" style=\"margin-left:13px;margin-right:0px;\" class=\"delete-item\">Delete</a>";
            if(cartLineInfo.getProduct().getDiscountByProduct()==0)
                cart_info += "<span style=\"color:#1a5996;\" class=\"price\">$"+String.format("%.2f", cartLineInfo.getProduct().getPrice())+"</span>";
                        else{
                cart_info +="<span class=\"price\" style=\"\n" +
                            "    text-decoration: line-through;\n" +
                            "    color: gray;\n" +
                            "    font-size: medium;\n" +
                            "\">$"+String.format("%.2f", cartLineInfo.getProduct().getPrice())+"</span>";
            }
                
                cart_info += "<div class=\"quantity\"><label for=\"cd-product-'+ productId +'\">Quantity: "+cartLineInfo.getQuantity()+"</label>"
                + "</div> "
                + "<div class=\"quantity\"><label for=\"cd-product-'+ productId +'\">/ Size: "+cartLineInfo.getSizesByColor().getSize()+"</label>"
                + "</div>\n\n"
                + "<div class=\"quantity\"><label for=\"cd-product-'+ productId +'\">Color:</label><img fs-color=\"" + cartLineInfo.getSizesByColor().getColorID().getColorID() + "\" \n"
                + "                                                 src=\"assets/images/products/colors/" + cartLineInfo.getSizesByColor().getColorID().getUrlColorImg() + "\" \n"
                + "                                                 class=\"img-responsive\" \n"
                + "                                                 alt=\"" + cartLineInfo.getSizesByColor().getColorID().getUrlColorImg() + "\" \n"
                + "                                                 title=\"" + cartLineInfo.getSizesByColor().getColorID().getColor() + "\"\n"
                + "                                                 style=\"width: 18px; height: 18px;display:inline;\"/>\n"
                + "</div>";
                if(cartLineInfo.getProduct().getDiscountByProduct()!=0)
                    cart_info += "<div class=\"quantity\" style=\"\n" +
                                 "    float: right;\n" +
                                 "    color: #1a5996;font-size:large;\n" +
                                 "\"><label style=\"margin-right:0px;\" for=\"cd-product-'+ productId +'\">$"+String.format("%.2f", cartLineInfo.getProduct().getProductWithDiscount())+"(-"+cartLineInfo.getProduct().getDiscountByProduct()+"%)</label>\n" +
                "</div>";
                cart_info+= "</div>"
                + "</div>"
                + "</li>";
            
        }
        
        
        if(size>0)
        cart_info+="<li class=\"product\">Grand Total: <div style=\"color:#1a5996;display:inline;font-weight:700;\">$"+subtotal+"</div>"
                 +"</li><li></li><a style=\"padding-left:118px;cursor:pointer;\" id=\"removeallbtn\">Remove All</a>&nbsp;&nbsp;|&nbsp;\n" +
"                <a href=\"orders/shoppingcart.html\">View Cart</a>";
        else
            cart_info+="<h2 style=\"text-align:center;\">EMPTY CART</h2>";
        
        return cart_info+"*"+size;
    }

//    @ResponseBody
//    @RequestMapping(value = "ajax/discount", method = RequestMethod.POST)
//    public String getDiscount(@RequestParam("discountCode") String discountCode, @RequestParam("emailUser") String emailUser) {
//        DiscountVoucher discountVoucher = orderStateLessBean.getDiscountVoucherByID(discountCode);
//        Users users = usersStateLessBean.findUserByEmail(emailUser);
//        ObjectMapper mapper = new ObjectMapper();
//        if (discountVoucher != null) {
//            if (discountCode.equals(discountVoucher.getVoucherID())) {
//                if (users != null) {
//                    List<Users> userList = orderStateLessBean.getAllUserUseDiscountVoucherByVouID(discountVoucher.getVoucherID());
//                    if (userList != null) {
//                        if (userList.size() != 0) {
//                            for (Users user : userList) {
//                                if (user.getUserID() == users.getUserID()) { // da su dung voucher nay
//                                    CheckoutResponse checkoutResponse = new CheckoutResponse();
//                                    checkoutResponse.setStatus("4");
//                                    try {
//                                        String result = mapper.writeValueAsString(checkoutResponse);
//                                        return result;
//                                    } catch (JsonProcessingException ex) {
//                                        Logger.getLogger(OrdersController.class.getName()).log(Level.SEVERE, null, ex);
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    if (discountVoucher.getQuantity() == 0) { // out of quantity
//                        CheckoutResponse checkoutResponse = new CheckoutResponse();
//                        checkoutResponse.setStatus("0");
//                        try {
//                            String result = mapper.writeValueAsString(checkoutResponse);
//                            return result;
//                        } catch (JsonProcessingException ex) {
//                            Logger.getLogger(OrdersController.class.getName()).log(Level.SEVERE, null, ex);
//                        }
//                    } else {
//                        Date todayDate = new Date();
//                        Date beginDate = discountVoucher.getBeginDate();
//                        Date endDate = discountVoucher.getEndDate();
//                        if ((beginDate == null && endDate == null)
//                                || (todayDate.after(beginDate) && todayDate.before(endDate))
//                                || (todayDate.after(beginDate) && endDate == null)
//                                || (beginDate == null && todayDate.before(endDate))) {
//                            CheckoutResponse checkoutResponse = new CheckoutResponse();
//                            DecimalFormat df = new DecimalFormat("#.#");
//                            df.setRoundingMode(RoundingMode.FLOOR);
//                            float discountTotal = orderStateFulBean.subTotal() * discountVoucher.getFloatDiscount();
//                            float orderTotal = orderStateFulBean.subTotal() - discountTotal;
//                            String str_show_discount = "<tr>\n"
//                                    + "                                    <th>Discount</th>\n"
//                                    + "                                    <td>\n"
//                                    + "                                        <div class=\"\">-$" + df.format(discountTotal) + "</div>\n"
//                                    + "                                    </td> \n"
//                                    + "                                </tr>\n"
//                                    + "                                <tr>\n"
//                                    + "                                    <th>Order Total</th>\n"
//                                    + "                                    <td>\n"
//                                    + "                                        <div class=\"grandTotal\">$" + orderTotal + "</div>\n"
//                                    + "                                    </td> \n"
//                                    + "                                </tr>";
//                            String str_show_percent_discount = "<div id=\"discountShow\" style=\"padding-bottom: 15px;\">\n"
//                                    + "<input type=\"hidden\" id=\"discount-code-input\" name=\"discount-code-input\" value=\"" + discountCode + "\"/>\n"
//                                    + "<b>Your Discount Code: " + discountCode + "; Discount " + discountVoucher.getDiscount() + "%</b>&nbsp<button type=\"button\" class=\"fa fa-times\" id=\"cancel-discount\"  onclick=\"enterDiscountAgain();\"></button>\n"
//                                    + "</div>";
//                            checkoutResponse.setShowDiscount(str_show_discount);
//                            checkoutResponse.setShowDiscountPercent(str_show_percent_discount);
//                            try {
//                                String result = mapper.writeValueAsString(checkoutResponse);
//                                return result;
//                            } catch (JsonProcessingException ex) {
//                                Logger.getLogger(OrdersController.class.getName()).log(Level.SEVERE, null, ex);
//                            }
//                        } else if ((todayDate.before(beginDate) && endDate != null) || (todayDate.before(beginDate) && endDate == null)) { // chua toi han
//                            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
//                            String date = sdf.format(beginDate);
//                            CheckoutResponse checkoutResponse = new CheckoutResponse();
//                            checkoutResponse.setStatus("2");
//                            checkoutResponse.setShowDiscount(date);
//                            try {
//                                String result = mapper.writeValueAsString(checkoutResponse);
//                                return result;
//                            } catch (JsonProcessingException ex) {
//                                Logger.getLogger(OrdersController.class.getName()).log(Level.SEVERE, null, ex);
//                            }
//                        } else if ((todayDate.after(endDate) && beginDate != null) || (todayDate.after(endDate) && beginDate == null)) { // qua han
//                            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
//                            String date = sdf.format(endDate);
//                            CheckoutResponse checkoutResponse = new CheckoutResponse();
//                            checkoutResponse.setStatus("3");
//                            checkoutResponse.setShowDiscount(date);
//                            try {
//                                String result = mapper.writeValueAsString(checkoutResponse);
//                                return result;
//                            } catch (JsonProcessingException ex) {
//                                Logger.getLogger(OrdersController.class.getName()).log(Level.SEVERE, null, ex);
//                            }
//                        }
//                    }
//                } else { // error
//                    CheckoutResponse checkoutResponse = new CheckoutResponse();
//                    checkoutResponse.setStatus("5");
//                    try {
//                        String result = mapper.writeValueAsString(checkoutResponse);
//                        return result;
//                    } catch (JsonProcessingException ex) {
//                        Logger.getLogger(OrdersController.class.getName()).log(Level.SEVERE, null, ex);
//                    }
//                }
//            } else { // wrong discount code
//                CheckoutResponse checkoutResponse = new CheckoutResponse();
//                checkoutResponse.setStatus("6");
//                try {
//                    String result = mapper.writeValueAsString(checkoutResponse);
//                    return result;
//                } catch (JsonProcessingException ex) {
//                    Logger.getLogger(OrdersController.class.getName()).log(Level.SEVERE, null, ex);
//                    return null;
//                }
//            }
//        } else {
//            CheckoutResponse checkoutResponse = new CheckoutResponse(); // khong tim thay discount vou
//            checkoutResponse.setStatus("1");
//            try {
//                String result = mapper.writeValueAsString(checkoutResponse);
//                return result;
//            } catch (JsonProcessingException ex) {
//                Logger.getLogger(OrdersController.class.getName()).log(Level.SEVERE, null, ex);
//                return null;
//            }
//        }
//
//        return null;
//    }
//    @ResponseBody
//    @RequestMapping(value = "ajax/nodiscount", method = RequestMethod.GET)
//    public String getNoDiscount() {
//        String str_show = "<tr>\n"
//                + "                                    <th>Discount</th>\n"
//                + "                                    <td>\n"
//                + "                                        <div class=\"\">$0.0</div>\n"
//                + "                                    </td> \n"
//                + "                                </tr>\n"
//                + "                                <tr>\n"
//                + "                                    <th>Order Total</th>\n"
//                + "                                    <td>\n"
//                + "                                        <div class=\"grandTotal\">$" + orderStateFulBean.subTotal() + "</div>\n"
//                + "                                    </td> \n"
//                + "                                </tr>";
//        return str_show;
//    }
//    // <editor-fold defaultstate="collapsed" desc="Look Up Beans Local">
//    private OrderStateLessBeanLocal lookupOrderStateLessBeanLocal() {
//        try {
//            Context c = new InitialContext();
//            return (OrderStateLessBeanLocal) c.lookup("java:global/fashionshop/OrderStateLessBean!spring.ejb.OrderStateLessBeanLocal");
//        } catch (NamingException ne) {
//            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
//            throw new RuntimeException(ne);
//        }
//    }
//
//    private OrderStateFulBeanLocal lookupOrderStateFulBeanLocal() {
//        try {
//            Context c = new InitialContext();
//            return (OrderStateFulBeanLocal) c.lookup("java:global/fashionshop/OrderStateFulBean!spring.ejb.OrderStateFulBeanLocal");
//        } catch (NamingException ne) {
//            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
//            throw new RuntimeException(ne);
//        }
//    }
//
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
//    private UserAddressesStateLessBeanLocal lookupUserAddressesStateLessBeanLocal() {
//        try {
//            Context c = new InitialContext();
//            return (UserAddressesStateLessBeanLocal) c.lookup("java:global/fashionshop/UserAddressesStateLessBean!spring.ejb.UserAddressesStateLessBeanLocal");
//        } catch (NamingException ne) {
//            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
//            throw new RuntimeException(ne);
//        }
//    }// </editor-fold>
    private ProductsFacadeLocal lookupProductsFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (ProductsFacadeLocal) c.lookup("java:global/ShoeGardenPJ/ProductsFacade!spring.ejb.ProductsFacadeLocal");
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

    private OrderStateLessBeanLocal lookupOrderStateLessBeanLocal() {
        try {
            Context c = new InitialContext();
            return (OrderStateLessBeanLocal) c.lookup("java:global/ShoeGardenPJ/OrderStateLessBean!spring.ejb.OrderStateLessBeanLocal");
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

    private OrderStateFullBeanLocal lookupOrderStateFullBeanLocal() {
        try {
            Context c = new InitialContext();
            return (OrderStateFullBeanLocal) c.lookup("java:global/ShoeGardenPJ/OrderStateFullBean!spring.ejb.OrderStateFullBeanLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    private UserAddressesStateLessBeanLocal lookupUserAddressesStateLessBeanLocal() {
        try {
            Context c = new InitialContext();
            return (UserAddressesStateLessBeanLocal) c.lookup("java:global/ShoeGardenPJ/UserAddressesStateLessBean!spring.ejb.UserAddressesStateLessBeanLocal");
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

}
