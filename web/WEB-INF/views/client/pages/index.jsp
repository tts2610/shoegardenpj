<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- SLIDER -->
<section id="slider"><!--slider-->
    <div class="container">
        <div class="row">           
            <div id="slider-carousel" class="carousel slide" data-ride="carousel">
                <ol class="carousel-indicators">
                    <li data-target="#slider-carousel" data-slide-to="0" class="active"></li>
                    <li data-target="#slider-carousel" data-slide-to="1"></li>
                    <li data-target="#slider-carousel" data-slide-to="2"></li>
                </ol>

                <div class="carousel-inner">
                    <div class="item active">
                        <div class="col-sm-6">
                            <h1><span>ADIDAS</span> CLIMACOOL</h1>
                            <h2>New summer - New shoes</h2>
                            <p>Run strong when the weather heats up in shoes that give you a burst of energy with every step.  </p>
                            <button type="button" class="btn btn-default get">Get it now</button>
                        </div>
                        <div class="col-sm-6">
                            <img src="assets/images/slides/adidas_alphabounce.jpg" class="girl img-responsive" alt="" />
                            <!--                            <img src="assets/images/slides/pricing.png"  class="pricing" alt="" />-->
                        </div>
                    </div>
                    <div class="item">
                        <div class="col-sm-6">
                            <h1><span>NIKE</span> AIR MAX</h1>
                            <h2>Run run run...</h2>
                            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. </p>
                            <button type="button" class="btn btn-default get">Get it now</button>
                        </div>
                        <div class="col-sm-6">
                            <img src="assets/images/slides/air-max-2017-mens-running-shoe.jpg" class="girl img-responsive" alt="" />
                            <!--                            <img src="assets/images/slides/pricing.png"  class="pricing" alt="" />-->
                        </div>
                    </div>

                    <div class="item">
                        <div class="col-sm-6">
                            <h1><span>VANS</span> OLD SKOOL</h1>
                            <h2>Shopping Now</h2>
                            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. </p>
                            <button type="button" class="btn btn-default get">Get it now</button>
                        </div>
                        <div class="col-sm-6">
                            <img src="assets/images/slides/vans-era.jpg" class="girl img-responsive" alt="" />
                            <!--                            <img src="assets/images/slides/pricing.png" class="pricing" alt="" />-->
                        </div>
                    </div>

                </div>

                <a href="#slider-carousel" class="left control-carousel hidden-xs" data-slide="prev">
                    <i class="fa fa-angle-left"></i>
                </a>
                <a href="#slider-carousel" class="right control-carousel hidden-xs" data-slide="next">
                    <i class="fa fa-angle-right"></i>
                </a>
            </div>
        </div>
    </div>
</section><!--/slider-->



<div class="clearfix"></div>


<!-- FEATURED PRODUCTS -->
<div class="featured-products">
    <div class="container">
        <div class="row">
            <h5 class="heading"><span>Featured Products</span></h5>
            <ul class="filter" data-option-key="filter">
                <li><a class="selected" href="#filter" data-option-value=".isotope_to_all">All</a></li>
                    <c:forEach items="${braList}" var="bra" varStatus="no"> 
                    <li>
                        <a href="#" data-option-value=".${bra.braName}">${bra.braName}</a>
                    </li>
                </c:forEach>
            </ul>
            <div id="isotope" class="isotope">
                <c:forEach items="${braList}" var="bra">
                    <c:forEach items="${bra.productListWorking}" var="product" begin="0" end="7" varStatus="no">

                        <div class="isotope-item ${bra.braName} <c:if test="${no.index % 2 == 0}">isotope_to_all</c:if>">
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
                                        <a class="fa fa-bar-chart fs-cp-fp" fs-productID="${product.productID}" ></a>
                                        <a class="likeitem fa fa-heart-o fs-wishlish-add" 
                                           fs-userID="${sessionScope.findUsersID}" 
                                           fs-productID="${product.productID}" ></a>
                                        <input type="hidden" name="emailUser" value="${sessionScope.emailUser}" />
                                    </div>
                                </div>
                                <div class="product-info">
                                    <h4 class="product-title">
                                        <a href="${product.productID}-${product.productColorListWorking[0].colorID}.html">
                                            ${product.productName}
                                        </a>
                                    </h4>
                                    <span class="product-price">
                                        <c:if test="${product.discountDetailsList[0] != null}">
                                            <small class="cutprice">$ ${product.price}0 </small>  $
                                            <fmt:formatNumber type="number" maxFractionDigits="2" value="${product.price * (1-product.discountDetailsList[0].discID.discount/100)}" var="prodPrice"/>
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
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<!-- BLOG -->
<div class="home-blog">


    <!-- LATEST PRODUCTS -->
    <div class="container padding40">
        <div class="row">
            <div class="col-md-12 col-sm-12">
                <h5 class="heading space40"><span>Latest Products</span></h5>
                <div class="product-carousel3">
                    <c:forEach items="${latestProducts}" var="ltp" begin="0" end="7">
                        <div class="pc-wrap">
                            <div class="product-item">
                                <div class="item-thumb">
                                    <c:if test="${ltp.discountDetailsList[0].discID.discount > 0}">
                                        <div class="badge offer">-${ltp.discountDetailsList[0].discID.discount}%</div>
                                    </c:if>
                                    <img src="assets/images/products/${ltp.urlImg}" 
                                         class="img-responsive" 
                                         alt="${ltp.urlImg}" 
                                         fs-product-for-img="${ltp.productID}"/>
                                    <div class="overlay-rmore fa fa-search quickview fs-product-modal" 
                                         fs-product="${ltp.productID}" 
                                         fs-product-modal-color="${ltp.productColorListWorking[0].colorID}" 
                                         data-toggle="modal" ></div>
                                    <div class="product-overlay">
                                        <a class="fa fa-bar-chart fs-cp-lsp" fs-productID="${ltp.productID}"></a>
                                        <a class="likeitem fa fa-heart-o fs-wl-add-lsp"
                                           fs-userID="${sessionScope.findUsersID}" fs-productID="${ltp.productID}" ></a>
                                        <input type="hidden" name="emailUser" value="${sessionScope.emailUser}" />
                                    </div>
                                </div>
                                <div class="product-info">
                                    <h4 class="product-title">
                                        <a href="${ltp.productID}-${ltp.productColorListWorking[0].colorID}.html">
                                            ${ltp.productName}
                                        </a>
                                    </h4>

                                    <span class="product-price">
                                        <c:if test="${ltp.discountDetailsList[0]!=null}">
                                            <small class="cutprice">$ ${ltp.price}0 </small>  $
                                            <fmt:formatNumber type="number" maxFractionDigits="2" value="${ltp.price * (1-ltp.discountDetailsList[0].discID.discount/100)}" var="ltpPrice"/>
                                            ${fn:replace(ltpPrice, ",", ".")}

                                        </c:if>
                                        <c:if test="${ltp.discountDetailsList[0]==null}">
                                            $ ${ltp.price}0
                                        </c:if>
                                    </span>

                                    <div class="item-colors">
                                        <c:if test="${ltp.productColorListWorking.size() > 1}">
                                            <c:forEach items="${ltp.productColorListWorking}" var="color">
                                                <img src="assets/images/products/colors/${color.urlColorImg}" 
                                                     class="img-responsive fs-index-color-img" 
                                                     fs-index-color-img="${color.colorID}" 
                                                     fs-product="${ltp.productID}" 
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

    <div class="space10 clearfix"></div>

    <!-- CLIENTS -->
    <div class="clients">
        <div class="container">
            <div class="row">
                <div class="col-md-12 col-sm-12"> 
                </div>
            </div>
        </div>
    </div>
    
    <!-- FOOTER WIDGETS -->
    <div class="f-widgets">
        <div class="container">
            <div class="row">
                <div class="col-md-4 col-sm-4">
                    <h6>Best Seller</h6>
                    <div class="f-widget-content">
                        <ul>
                            <c:forEach items="${bestSellerList}" var="prod">
                                <li>
                                    <div class="fw-thumb">
                                        <img src="assets/images/products/${prod[4]}" alt="${prod[4]}"/>
                                    </div>
                                    <div class="fw-info">
                                        <h4>
                                            <a href="${prod[0]}-${prod[5]}.html">
                                                ${prod[1]}
                                            </a>
                                        </h4>
                                        <span class="fw-price">$ ${prod[3]}0</span>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
                <div class="col-md-4 col-sm-4">
                    <h6>Most Viewed</h6>
                    <div class="f-widget-content">
                        <ul>
                            <c:forEach items="${mostViewList}" var="prod">
                                <li>
                                    <div class="fw-thumb">
                                        <img src="assets/images/products/${prod.urlImg}" alt="${prod.urlImg}"/>
                                    </div>
                                    <div class="fw-info">
                                        <h4>
                                            <a href="${prod.productID}-${prod.productColorListWorking[0].colorID}.html">
                                                ${prod.productName}
                                            </a>
                                        </h4>
                                        <span class="fw-price">$ ${prod.price}0</span>
                                    </div>
                                </li>
                            </c:forEach>

                        </ul>
                    </div>
                </div>
                <div class="col-md-4 col-sm-4">
                    <h6>Top Rated</h6>
                    <div class="f-widget-content">
                        <ul id="fs-recent-product-index-page">
                            <c:forEach items="${productTopRateList}" var="prod" varStatus="ind">
                                <li>
                                    <div class="fw-thumb">
                                        <img src="assets/images/products/${prod[0].urlImg}" alt="${prod[0].urlImg}"/>
                                    </div>
                                    <div class="fw-info">
                                        <h4>
                                            <a href="${prod[0].productID}-${prod[0].productColorListWorking[0].colorID}.html">
                                                ${prod[0].productName}
                                            </a>
                                        </h4>
                                        <select id="fs-index-top-rating-result-${ind.index}" data-current-rating="${prod[1]}">
                                            <option value="1">1</option>
                                            <option value="2">2</option>
                                            <option value="3">3</option>
                                            <option value="4">4</option>
                                            <option value="5">5</option>
                                        </select>
                                        <span class="fw-price">$ ${prod[0].price}0</span>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->
    <jsp:include page="../blocks/modal.jsp" flush="true"/>
    <!--Modal thong bao dang nhap-->
    <div id="fs-modal-mess" class="modal fade fs-modal-wl-mess" tabindex="-1" role="dialog" aria-labelledby="messlodalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-content fs-modal-wl-content">
            <button type="button" class="close fs-modal-close" data-dismiss="modal" aria-hidden="true">
                <i class="fa fa-times"></i>
            </button>
            <p class="text-center fs-wl-text"><b>Please login to add wishlist !</b></p>
            <div class="modal-body fs-modal-wl-body">
                <a class="btn fs-btn-wl fs-btn-login-wl text-center">Login</a>
            </div>
        </div>
    </div>

    <!--MODAL THONG BAO CHO KHI CO MODAL-->
    <div id="fs-wl-ajax-error" class="modal fade fs-modal-mess-wl" tabindex="-1" role="dialog">
        <div class="modal-content fs-modal-wl-content">
            <!--<h1 id="fs-mess-wl" style="color: #31b131; text-align: center">SUCCESS</h1>-->
            <h1 id="fs-mess-wl-success" style="color: #31b131; text-align: center"></h1>
            <h1 id="fs-mess-wl-error" style="color: #F65D20; text-align: center"></h1>

            <div class="modal-header">
                <button class="close" data-dismiss="modal">&times;</button>
                <!--<h1 id="fs-mess-wl" style="color: #31b131; text-align: center"></h1>-->
            </div>
            <div class="modal-body">
                <!--<p id="fs-mess-body-wl">Add Wish List success.</p>-->
                <p id="fs-mess-body-wl"></p>
            </div>
        </div>
    </div>
    <div class="ajax-progress"></div>
</div>
