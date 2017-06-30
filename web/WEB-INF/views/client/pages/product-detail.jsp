<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!-- BREADCRUMBS -->
<jsp:include page="../blocks/breadcrumbs.jsp" flush="true"/>

<div class="space10"></div>
<!-- MAIN CONTENT -->
<div class="shop-single" id="fs-product-detail-page">
    <div class="container">
        <div class="row">
            <div class="col-md-12 col-sm-12">
                <div id="error-product-detail">

                </div>
                <div class="row">
                    <div class="col-md-5 col-sm-6" id="fs-product-detail-slide-img">                                    
                        <div class="owl-carousel prod-slider sync1"  >
                            <c:forEach items="${targetColor.productSubImgsList}" var="subImg">
                                <div class="item" id="gallery_01" data-zoom-image="assets/images/products/subImg/${subImg.urlImg}" alt="${subImg.urlImg}">
                                    <img src="assets/images/products/subImg/${subImg.urlImg}" alt="${subImg.urlImg}">
<!--                                    <a href="assets/images/products/subImg/${subImg.urlImg}" rel="prettyPhoto[gallery2]" title="Product" class="caption-link"><i class="fa fa-arrows-alt"></i></a>-->
                                </div>
                            </c:forEach>
                        </div>
                        <div  class="owl-carousel sync2">
                            <c:forEach items="${targetColor.productSubImgsList}" var="subImg">
                                <div class="item">
                                    <img src="assets/images/products/subImg/${subImg.urlImg}" alt="${subImg.urlImg}">
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="col-md-7 col-sm-6">
                        <div class="product-single">
                            <div class="ps-header fs-product-detail-name" fs-product-id="${targetProduct.productID}">
                                <h1>${targetProduct.productName}</h1>
                                <div class="ps-price" style="margin-top: 11px;">                                     
                                    <select id="fs-rating-star-result" name="fs-rating-star-result" data-current-rating="${ratingAVR}">
                                        <option value="1">1</option>
                                        <option value="2">2</option>
                                        <option value="3">3</option>
                                        <option value="4">4</option>
                                        <option value="5">5</option>
                                    </select>                            
                                </div>
                                <c:if test="${targetProduct.productWithDiscount!=targetProduct.price}">
                                    <div class="ps-price">
                                        <h1 style="color: #888888;text-decoration: line-through; display: inline">$${targetProduct.price} </h1>
                                        <h1 style="display: inline"><fmt:formatNumber type="number" maxFractionDigits="2" value="${targetProduct.productWithDiscount}" var="prodPrice"/>$${fn:replace(prodPrice, ",", ".")}</h1>
                                        &nbsp;&nbsp;<h1 style="display: inline">(-${targetProduct.discountByProduct}%)</h1>
                                    </div>
                                </c:if>
                                <c:if test="${targetProduct.productWithDiscount==targetProduct.price}">
                                    <div class="ps-price"><h1>$${targetProduct.price} </h1></div>
                                </c:if>
                            </div>
                            <div class="ps-stock">
                                Availability: <span style="color: #d6644a" class="fs-quantity-in-stock">---</span>
                                <div class="fs-display-none" id="fs-show-quantity"></div>
                            </div>
                            <div class="alert alert-warning fs-quantity-in-cart" style="display: none">

                            </div>
                            <div class="sep"></div>
                            <div class="ps-color fs-product-color">
                                <p>Color<span>*</span></p>
                                <c:forEach items="${targetProduct.productColorListWorking}" var="color">
                                    <div class="fs-product-color-border <c:if test="${color.colorID == targetColor.colorID}">fs-product-selected</c:if>" >
                                        <img fs-color="${color.colorID}" src="assets/images/products/colors/${color.urlColorImg}" class="img-responsive" alt="${color.urlColorImg}" title="${color.color}"/>
                                    </div>
                                </c:forEach>
                            </div>
                            <div class="fs-clear-fix"></div>
                            <div class="space10"></div>
                            <div class="row select-wraps">
                                <div class="col-md-7 col-xs-7">
                                    <p style="margin-bottom: 8px">Size<span>*</span></p>

                                    <div id="fs-product-size">
                                        <c:forEach items="${targetColor.sizesByColorList}" var="size">
                                            <c:if test="${size.status != 0}">
                                                <div class="fs-particular-size <c:if test="${size.quantity == 0}">fs-unselectable</c:if>" 
                                                     fs-product="${targetProduct.productID}" 
                                                     fs-size="${size.sizeID}">
                                                    ${size.size}
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </div>
                                <div class="col-md-4 col-xs-5 col-lg-3">
                                    <p style="margin-bottom: 8px !important;">Quantity<span>*</span></p>
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger fs-btn-number fs-btn-quantity-minus" data-type="minus" disabled>
                                                <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>

                                        <input type="text" name="quantity" id="quantity" class="form-control fs-input-number text-center" value="1" min="1" max="10" disabled>

                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-success fs-btn-number fs-btn-quantity-plus" data-type="plus" disabled>
                                                <span class="glyphicon glyphicon-plus"></span>
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="space20"></div>
                            <div class="share">
                                <span>
                                    <a class="fa fa-bar-chart" id="fs-product-detail-compare" fs-productID="${targetProduct.productID}"></a>
                                    <a class="likeitem fa fa-heart-o fs-product-detail-wl" id="fs-product-detail-wl" fs-userID="${sessionScope.findUsersID}" 
                                       fs-productID="${targetProduct.productID}"></a>
                                    <input type="hidden" name="emailUser" value="${sessionScope.emailUser}" />
                                </span>
                                <div class="addthis_native_toolbox"></div>
                            </div>
                            <div class="space20"></div>
                            <div class="sep"></div>
                            <button class="btn addtobag" id="fs-product-detail-add-to-cart">Add to Bag</button>
                        </div>
                    </div>
                </div>
                <div class="clearfix space40"></div>



                <!-- REVIEW -->


                <div> 
                    <div class="sep"></div>
                    <div class="row">                        
                        <div class="col-md-9">
                            <h2 style="font-weight: 400">Product Descriptions</h2>
                            ${targetProduct.productDes}
                        </div>                        
                    </div>
                    <div class="sep"></div>
                    <div class="fs-display-none" id="fs-number-of-rating" fs-nort="${numberOfRating}"></div>
                    <h2>Product Reviews</h2>
                    <c:forEach items="${targetProduct.ratingList}" var="review" varStatus="no">
                        <c:if test="${review.status==1}">                            
                            <p>
                                <b>${review.user.firstName} ${review.user.lastName}</b>
                                <span style="color: #444"> on <fmt:formatDate value="${review.ratingDate}" pattern="dd MMM, yyyy" timeZone="US"/></span>
                            </p>                            
                            <c:if test="${review.rating!=0}">
                                <select id="fs-rating-star-${no.index}" name="fs-rating-star-${no.index}" data-current-rating="${review.rating}">

                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                </select>
                            </c:if>
                            <p style="margin-top: 7px; margin-bottom: 7px">
                                ${review.review}
                            </p>
                        </c:if>
                    </c:forEach>                            
                    <c:choose>
                        <c:when test="${sessionScope.findUsersID != null && checkUserRated != 0}">
                            <!--<h3>Thank you! Your review is being verified</h3>-->
                        </c:when>
                        <c:when test="${sessionScope.findUsersID != null && checkUserRated == 0}">
                            <div id="fs-form-rating-review">
                                <h2>Write Your Review</h2>
                                <form>
                                    <div>
                                        <span id="fs-div-vote-value">

                                        </span>
                                    </div>
                                    <div class="clearfix space10"></div>
                                    <select id="fs-rating-star" name="fs-rating-star">
                                        <option value=""></option>
                                        <option value="1">1</option>
                                        <option value="2">2</option>
                                        <option value="3">3</option>
                                        <option value="4">4</option>
                                        <option value="5">5</option>
                                    </select>

                                    <div class="clearfix space20"></div>
                                    <p style="color: red" class="help-block" id="fs-review-product-error"></p>
                                    <label>Your Review</label>
                                    <br>
                                    <textarea style="width: 400px; height: 100px;" id="fs-review-product"></textarea>
                                    <br>
                                    <div class="clearfix space20"></div>

                                    <button type="button" 
                                            id="fs-btn-rating-review" 
                                            fs-user-id="${sessionScope.findUsersID}" 
                                            fs-product-id="${targetProduct.productID}"
                                            class="btn-black pull-left">
                                        Submit
                                    </button>
                                    <div style="position: relative; width: 50px; height: 50px; float: left">
                                        <span id="fs-ajax-loading-2"></span>
                                    </div>   
                                    <div class="clearfix space10"></div>
                                </form>
                            </div>
                        </c:when>    
                        <c:otherwise>
                            <button type="button" id="fs-btn-login-to-review">Login to Write a Review</button>
                        </c:otherwise>
                    </c:choose>
                </div>



                <div class="clearfix space40"></div>
                <div class="row">
                    <div class="col-md-12 col-sm-12">
                        <h5 class="heading space40"><span>Recently Products</span></h5>
                        <div class="product-carousel3">
                            <c:if test="${recentProductList != null}">
                                <c:forEach items="${recentProductList}" var="prod">
                                    <div class="pc-wrap">
                                        <div class="product-item">
                                            <div class="item-thumb">
                                                <c:if test="${product.productWithDiscount!=product.price}">
                                                    <div class="badge offer">-${product.discountByProduct}%</div>
                                                </c:if>
                                                <img src="assets/images/products/${prod.urlImg}" 
                                                     class="img-responsive" 
                                                     alt="${prod.urlImg}" 
                                                     fs-product-for-img="${prod.productID}"/>
                                                <div class=" fs-product-modal" 
                                                     fs-product="${prod.productID}" 
                                                     fs-product-modal-color="${prod.productColorListWorking[0].colorID}" 
                                                     data-toggle="modal" ></div>
                                                <div class="product-overlay">
                                                    <a href="#" class="addcart fa fa-shopping-cart"></a>
                                                    <a class="likeitem fa fa-heart-o fs-wl-add-lsp"
                                                       fs-userID="${sessionScope.findUsersID}" fs-productID="${prod.productID}" ></a>
                                                    <input type="hidden" name="emailUser" value="${sessionScope.emailUser}" />
                                                </div>
                                            </div>
                                            <div class="product-info">
                                                <h4 class="product-title">
                                                    <a href="${prod.productID}-${prod.productColorListWorking[0].colorID}.html">
                                                        ${prod.productName}
                                                    </a>
                                                </h4>

                                                <span class="product-price">
                                                    <c:if test="${product.productWithDiscount!=product.price}">
                                                        <small class="cutprice">$ ${prod.price}0 </small>  $
                                                        <fmt:formatNumber type="number" maxFractionDigits="2" value="${product.productWithDiscount}" var="prodPrice"/>
                                                        ${fn:replace(prodPrice, ",", ".")}

                                                    </c:if>
                                                    <c:if test="${product.productWithDiscount==product.price}">
                                                        $ ${prod.price}0
                                                    </c:if>
                                                </span>

                                                <div class="item-colors">
                                                    <c:if test="${prod.productColorListWorking.size() > 1}">
                                                        <c:forEach items="${prod.productColorListWorking}" var="color">
                                                            <img src="assets/images/products/colors/${color.urlColorImg}" 
                                                                 class="img-responsive fs-index-color-img" 
                                                                 fs-index-color-img="${color.colorID}" 
                                                                 fs-product="${prod.productID}" 
                                                                 alt="${color.urlColorImg}" 
                                                                 title="${color.color}"/>
                                                        </c:forEach>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>
                        </div>
                    </div>
                </div>
                <div class="clearfix space20"></div>
            </div>
        </div>
    </div>
</div>

<div class="clearfix space20"></div>

<jsp:include page="../blocks/cart.jsp" flush="true"/>

<!-- MODAL -->
<jsp:include page="../blocks/modal.jsp" flush="true" />
<jsp:include page="../blocks/messmodal.jsp" flush="true"/>
<script type="text/javascript">
    var productObj = {
        productID: '${targetProduct.productID}',
        productColorID: '${targetColor.colorID}',
        productName: '${targetProduct.productName}',
        productNameNA: '${targetProduct.productName}',
        productImg: '${targetProduct.urlImg}'
    };

    // Check browser support
    if (typeof (Storage) !== "undefined") {

        if (localStorage.getItem("productsArrLocal") == null) {
            var productArr = [];
            productArr.push(productObj);
            localStorage.setItem("productsArrLocal", JSON.stringify(productArr));
        } else {
            var productsArrLocal = JSON.parse(localStorage.getItem("productsArrLocal"));
            var count = 0;
            for (var lc = 0; lc < productsArrLocal.length; lc++) {
                if (productsArrLocal[lc].productID == productObj.productID) {
                    count++;
                    break;
                }
            }

            if (count == 0) {
                productsArrLocal.push(productObj);
                localStorage.setItem("productsArrLocal", JSON.stringify(productsArrLocal));
            }
        }
    } else {
        document.getElementById("result").innerHTML = "Sorry, your browser does not support Web Storage...";
    }
</script>
