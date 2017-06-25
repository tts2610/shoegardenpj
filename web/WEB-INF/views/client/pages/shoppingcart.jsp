<%@page import="spring.entity.CartLineInfo"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- BREADCRUMBS -->
<jsp:include page="../blocks/breadcrumbs.jsp" flush="true" />

<div class="space10"></div>

<!-- MAIN CONTENT -->
<div class="shop-single shopping-cart">
    <div class="container">
        <div class="row">
            <div id="error">
                ${error}
            </div>
            <div class="col-md-12 col-sm-12">
                <form method="POST" action="orders/updatecart.html">
                    <table class="cart-table">
                        <thead>
                            <tr>
                                <th>Product Image</th>
                                <th>Product Name</th>
                                <th>Quantity</th>
                                <th>Price for one</th>
                                <th>Product discount</th>
                                <th>Subtotal</th>
                                <th>Remove</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${cartList}" var="item">
                                <tr>
                                    <td><img src="assets/images/products/${item.getProduct().getUrlImg()}" class="img-responsive" alt=""/></td>
                                    <td>
                                        <h4>
                                            <a href="${item.getProduct().productID}-${item.getProduct().productColorsList[0].colorID}.html">
                                                ${item.getProduct().productName}
                                            </a>
                                        </h4>
                                        <p>Size: ${item.getSizesByColor().getSize()}  |  Color:   
                                            <img fs-color="${item.getSizesByColor().getColorID().colorID}" 
                                                 src="assets/images/products/colors/${item.getSizesByColor().getColorID().getUrlColorImg()}" 
                                                 class="img-responsive" 
                                                 alt="${item.getSizesByColor().getColorID().urlColorImg}" 
                                                 title="${item.getSizesByColor().getColorID().getColor()}"
                                                 style="width: 20px; height: 20px; display: inline;"/>
                                        </p>
                                    </td>
                                    <td style="width: 100px;" align="center">
                                        <select id="select-quantity-shoppingcart" name="${item.getProduct().productID}-${item.getSizesByColor().getSizeID()}-${item.getSizesByColor().getColorID().getColorID()}">
                                            <%
                                                CartLineInfo cartLineInfo = (CartLineInfo) pageContext.getAttribute("item");
                                                for (int i = 1; i <= cartLineInfo.getSizesByColor().getQuantity(); i++) {
                                                    if (cartLineInfo.getQuantity() == i) {
                                            %>
                                            <option value="<%= i%>" selected="selected"><%= i%></option>
                                            <%
                                            } else {
                                            %>
                                            <option value="<%= i%>"><%= i%></option>
                                            <%
                                                    }
                                                }
                                            %>
                                        </select>
                                    </td>
                                    <td>
                                        <div class="item-price">$${item.getProduct().getPrice()}</div>
                                    </td>
                                    <td>
                                        <div class="item-price">${item.product.discountByProduct}%</div>
                                    </td>
                                    <td>
                                        <div class="item-price">$${item.getSubTotal()}</div>
                                    </td>
                                    <td><a href="orders/deleteitemCart/${item.getProduct().productID}/${item.getSizesByColor().getSizeID()}/${item.getSizesByColor().getColorID().getColorID()}.html"><i class="fa fa-trash-o"></i></a></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="5" align="right" style="padding-left: 750px;"><strong>Grand Total</strong></td>
                                <td><strong>$${grandTotal}</strong></td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </table>
                    <div class="table-btn">
                        <a href="index.html" class="btn-black pull-left">Continue Shopping</a>
                        <button type="submit" class="btn-black pull-right">Update Shopping Cart</button>
                    </div>
                </form>
                <div class="table-btn" style="padding-top: 10px;">
                    <button onclick="checkoutClick();" class="btn btn-danger pull-right" style="color: #fff !important;">PROCEED TO CHECKOUT</button>
                </div>
                <div class="clearfix space10"></div>
                <div class="space40"></div>
                <div class="row">
                    <div class="col-md-12 col-sm-12">
                        <span class="heading-small">YOU MAY BE INTERESTED IN THE FOLLOWING ITEM(S)</span>
                        <div class="space30"></div>
                        <div class="product-carousel3">
                            <c:forEach items="${proList}" var="product">
                                <div class="pc-wrap">
                                    <div class="product-item">
                                        <div class="item-thumb">
                                            <c:if test="${product.discountDetailsList[0]!=null}">
                                                <div class="badge offer">-${product.discountDetailsList[0].discID.discount}%</div>
                                            </c:if>
                                            <img src="assets/images/products/${product.urlImg}"
                                                 class="img-responsive" 
                                                 alt="${product.urlImg}"
                                                 fs-product-for-img="${product.productID}"/>
                                            <div class="overlay-rmore fa fa-search quickview fs-product-modal" 
                                                 fs-product="${product.productID}" 
                                                 fs-product-modal-color="${product.productColorListWorking[0].colorID}" 
                                                 data-toggle="modal" >
                                            </div>
                                            <div class="product-overlay">
                                                <a href="#" class="addcart fa fa-shopping-cart"></a>
                                                <a href="#" class="compare fa fa-signal"></a>
                                                <a class="likeitem fa fa-heart-o fs-wishlish-add" 
                                                   fs-userID="${sessionScope.findUsersID}" 
                                                   fs-productID="${product.productID}" ></a>
                                                <input type="hidden" name="emailUser" value="${sessionScope.emailUser}" />
                                            </div>
                                        </div>
                                        <div class="product-info">
                                            <h4 class="product-title">
                                                <a href="${product.productID}-${product.productColorListWorking[0].colorID}-${product.productName}.html">
                                                    ${product.productName}
                                                </a></h4>
                                            <span class="product-price">
                                                <c:if test="${product.discountDetailsList[0] != null}">
                                                    <small class="cutprice">$ ${product.price}0 </small>  $
                                                    <fmt:formatNumber type="number" maxFractionDigits="2" value="${product.productWithDiscount}" var="prodPrice"/>
                                                    ${fn:replace(prodPrice, ",", ".")}
                                                </c:if>
                                                <c:if test="${product.discountDetailsList[0] == null}">
                                                    $ ${product.price}0
                                                </c:if>
                                            </span>
                                            <div class="item-colors" style="height: 25px;">
                                                <c:if test="${product.productColorListWorking.size() > 1}">
                                                    <c:forEach items="${product.productColorListWorking}" var="color" begin="0" end="4">
                                                        <img src="assets/images/products/colors/${color.urlColorImg}" 
                                                             class="img-responsive fs-index-color-img" 
                                                             fs-index-color-img="${color.colorID}" 
                                                             fs-product="${product.productID}" 
                                                             alt="${color.urlColorImg}" 
                                                             title="${color.color}"/>
                                                    </c:forEach>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="clearfix space20"></div> 
<!-- MODAL -->
<jsp:include page="../blocks/modal.jsp" flush="true" />
