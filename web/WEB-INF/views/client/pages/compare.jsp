<%@page import="spring.entity.CartLineInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- BREADCRUMBS -->
<jsp:include page="../blocks/breadcrumbs.jsp" flush="true" />

<!-- MAIN CONTENT -->
<c:if test="${empty compareList}">
    <h4 style="font-weight: bold; background-color: #FFFFFF; padding: 30px; text-align: center; font-size: 30px; line-height: 50px;">Please choose some products to compare! <br/><a style="cursor: pointer;" href="index.html">Continue shopping...</a>
    </h4>
    <div class="clearfix space90"></div>
</c:if>

<c:if test="${not empty compareList}">

    <div class="shop-single shopping-cart">
        <div class="container">
            <div class="row">
                <div class="col-md-12 col-sm-12">
                    <form method="GET">
                        <button id="comparedeleteall" type="submit" style="margin-left: 20px;" class="btn-black pull-right" onclick="return confirm('Are you sure to clear all?');">Clear all</button>
                        <a href="index.html" class="btn-black pull-right">Back to shopping</a>
                    </form>
                </div>
            </div>
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
                                    <th>Price</th>
                                    <th>Product discount</th>
                                    <th>Posted Date</th>
                                    <th>Views</th>
                                    <th>Remove</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${sessionScope.compareList}" var="item">
                                    <tr>
                                        <td><img src="assets/images/products/${item.urlImg}" class="img-responsive" alt=""/></td>
                                        <td>
                                            <h4>
                                                <a href="${item.productID}-${item.productColorListWorking[0].colorID}.html">
                                                    ${item.productName}
                                                </a>
                                            </h4>                                            
                                        </td>                                      
                                        <td>
                                            <div class="item-price">$${item.price}</div>
                                        </td>                                         
                                        <td>
                                            <div class="item-price">-$${item.discountByProduct}</div>
                                        </td> 
                                        <td>
                                            <div class="item-info"><fmt:formatDate pattern="dd/MM/yyyy" value="${item.postedDate}"/>
                                            </div>
                                        </td>
                                        <td>
                                            ${item.productViews}                                 
                                        </td> 

                                        <td>
                                            <a class="fs-compare-del" fs-compare-del-id="${item.productID}" ><i class="fa fa-trash-o">
                                                </i>
                                            </a>
                                        </td>                                    
                                    </c:forEach>
                            </tbody>                          
                        </table>                    
                    </form>

                    <div class="space40"></div>
                </div>
            </div>
        </div>
    </div>
    <div class="clearfix space20"></div> 


    <%-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    1 bang compare css khac
    
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>
  <%--  
    <div class="compare-table">
        <div class="container">
            <div class="row">
                <div class="col-md-12 col-sm-12">
                    <form method="GET">
                        <button id="comparedeleteall" type="submit" style="margin-left: 20px;" class="btn-black pull-right" onclick="return confirm('Are you sure to clear all?');">Clear all</button>
                        <a href="index.html" class="btn-black pull-right">Back to shopping</a>
                    </form>
                </div>
            </div>

            <section class="cd-products-comparison-table">
                <div class="cd-products-table">
                    <!--                <div class="features">
                                        <div class="top-info">Models</div>
                                        <ul class="cd-features-list">
                                            <li>Price</li>
                                            <li>Discount</li>
                                            <li>Posted Date</li>
                                            <li>Views</li>
                                        </ul>
                                    </div>  -->
                    <!--.features--> 

                    <div class="cd-products-wrapper">
                        <ul class="cd-products-columns">

                            <c:forEach items="${sessionScope.compareList}" var="item">
                                <li class="product" id="fs-compare-del-${item.productID}">
                                    <div class="top-info">
                                        <a class="fs-compare-del" fs-compare-del-id="${item.productID}"><span style="font-size: 40px;text-align: center;">&times;</span></a>
                                        <div class="compare-img">
                                            <img src="assets/images/products/${item.urlImg}" alt="product image" style="max-height: 100px;">
                                        </div>                            
                                        <h4>${item.productName}</h4>
                                    </div> <!-- .top-info -->

                                    <ul class="cd-features-list">
                                        <li style="color: #e74c3c">$ ${item.price}</li>
                                        <li><span style="color: #e74c3c">${item.discountByProduct}%</span> off</li>
                                        <li>Date post: <fmt:formatDate pattern="dd/MM/yyyy" value="${item.postedDate}"/></li>            
                                    </ul>
                                </li> <!-- .product -->
                            </c:forEach>

                        </ul> <!-- .cd-products-columns -->
                    </div> <!-- .cd-products-wrapper -->

                    <ul class="cd-table-navigation">
                        <li><a href="#0" ><i class="fa-angle-left"></i></a></li>
                        <li><a href="#0" ><i class="fa-angle-right"></i></a></li>
                    </ul>
                </div> <!-- .cd-products-table -->
            </section> <!-- .cd-products-comparison-table -->
        </div>
    </div>
  --%>

</c:if>

<!-- MODAL -->
<jsp:include page="../blocks/modal.jsp" flush="true" />