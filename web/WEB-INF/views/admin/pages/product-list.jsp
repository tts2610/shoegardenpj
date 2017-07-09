<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Page Content -->
<div id="page-wrapper">
    <div class="container-fluid" id="productlist">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header"> 
                    <strong>Product</strong> 
                    <i class="fa fa-caret-right fa-style" aria-hidden="true" style="color: #337ab7"></i> 
                    <span style="font-size: 0.9em">List</span>
                </h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->

        <div class="row fs-div-product-list-select-box" >
            <div class="col-lg-12">
                <table width="100%" class="table table-striped table-bordered table-hover" id="productList_dataTable">
                    <thead>
                        <tr>
                            <th class="text-center fs-valign-middle">No</th>
                            <th class="text-center fs-valign-middle">Status</th>
                            <th class="text-center fs-valign-middle">Category - SubCategory</th>
                            <th class="text-center fs-valign-middle">Product</th>
                            <th class="text-center fs-valign-middle">Image</th>
                            <th class="text-center fs-valign-middle">Posted Date</th>
                            <th class="text-center fs-valign-middle">Actions</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach items="${productList}" var="product" varStatus="No">
                            <tr class="odd gradeX">
                                <td class="text-center fs-valign-middle">${No.index + 1}</td>
                                <td class="text-center fs-valign-middle" style="position: relative">
                                    <div class="fs-trigger"></div>
                                    <div class="fs-success-icon">
                                        <svg id="tick" x="0px" y="0px"
                                             viewBox="0 0 37 37"
                                             style="enable-background:new 0 0 37 37;">
                                        <path class="circ path" 
                                              style="fill:none; stroke:#31B131; stroke-width:3; stroke-linejoin:round; stroke-miterlimit:10; width:30px"
                                              d="M30.5,6.5L30.5,6.5c6.6,6.6,6.6,17.4,0,24l0,0c-6.6,6.6-17.4,6.6-24,0l0,0c-6.6-6.6-6.6-17.4,0-24l0,0C13.1-0.2,23.9-0.2,30.5,6.5z"/>
                                        <polyline class="tick path" 
                                                  style="fill:none; stroke:#31B131; stroke-width:3; stroke-linejoin:round; stroke-miterlimit:10;"
                                                  points="11.6,20 15.9,24.2 26.4,13.8 "/>
                                        </svg>
                                    </div>

                                    <div class="form-group" style="position: relative">
                                        <c:choose>
                                            <c:when test="${product.status == 0}">
                                                <div class="fs-stopworking-icon">
                                                    <i class="fa fa-minus-circle" aria-hidden="true"></i>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="fs-stopworking-icon fs-display-none">
                                                    <i class="fa fa-minus-circle" aria-hidden="true"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <select class="form-control fs-product-status-select-box" fs-product="${product.productID}">
                                            <option value="1" <c:if test="${product.status == 1}">selected</c:if>>
                                                    Working
                                                </option>
                                                <option value="0" <c:if test="${product.status == 0}">selected</c:if>>
                                                    Stopped 
                                                </option>
                                            </select>
                                        </div>
                                    </td>
                                <td class="text-center fs-valign-middle">${product.braID.braName} - ${product.catID.catName}</td>
                                <td class="text-center fs-valign-middle">${product.productName}</td>
                                <td class="text-center fs-valign-middle">
                                    <img class="responsive" style="width: 100px" src="assets/images/products/${product.urlImg}" alt="${product.urlImg}"/>
                                </td>
                                <td class="text-center fs-valign-middle">
                                    <fmt:formatDate pattern="dd/MM/yyyy" value="${product.postedDate}"/>
                                </td>

                                <td class="text-center fs-valign-middle">
                                    <a class="btn btn-info fs-product-modal" fs-product="${product.productID}" 
                                         fs-product-modal-color="${product.productColorListWorking[0].colorID}" 
                                         data-toggle="modal" style="margin-top: 4px;">
                                        <i class="fa fa-info-circle" aria-hidden="true"></i> Detail
                                    </a>
                                    <a href="admin/product/edit-${product.productID}.html" class="btn btn-warning" style="margin-top: 4px;">
                                        <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Update
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <!-- /.table-responsive -->
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
    </div>
    <!-- /.container-fluid -->
</div>
<!-- /#page-wrapper -->
<div class="modal fade" id="productModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-ku">
        <div class="modal-content">
            <button type="button" class="close fs-modal-close" data-dismiss="modal" aria-hidden="true">
                <i class="fa fa-times"></i>
            </button>
            <div class="row">
<!--                <div class="col-md-1 col-sm-6">
                    <div class="owl-carousel sync2 fs-main-product-img">
                    </div>  
                </div>-->
                <div class="col-md-5 col-sm-6" id="fs-product-modal-slide-img">
                    <div class="owl-carousel sync1 fs-main-product-img">
                    </div>  
                    <div class="owl-carousel sync2 fs-main-product-img">
                    </div>  
                </div>
                
                <div class="col-md-7 col-sm-6">
                    <div class="product-single fs-modal-product">
                        <div id="error-cart-product-modal">
                        </div>
                        <div class="ps-header">
                            <h3 class="fs-product-name" style="margin-top: 134px;"></h3>
                            <span class="product-price">
                                <!--                            <div class="ps-price fs-product-price"></div>-->
                                <small class="cutprice" style="display: inline; text-decoration: line-through"></small>&nbsp;<div class="ps-price fs-product-price" style="display: inline"></div>&nbsp;<div class="ps-price fs-product-discount" style="display: inline"></div>
                            </span>
                        </div>

                        <div class="ps-stock">
                            Availability: <span style="color: #d6644a" class="fs-quantity-in-stock">---</span>
                            <div class="fs-display-none" id="fs-show-quantity"></div>
                            
                        </div>
                        <div class="alert alert-warning fs-quantity-in-cart" style="display: none">
                           
                        </div>
                        <div class="sep"></div>
                        <div class="ps-color fs-product-modal-color">
                            <p>Color<span>*</span></p>                         
                            <div class="fs-product-modal-color-border">

                            </div>
                        </div>
                        <div class="fs-clear-fix"></div>
                        <div class="space10"></div>
                        <div class="row select-wraps">
                            <div class="col-md-7 col-xs-7">
                                <p>Size<span>*</span></p>
                                <div id="fs-product-modal-size">

                                </div>
                            </div>
                        </div>
                        <div class="space20"></div>
                        
                        <div class="space20"></div>
                        <div class="sep"></div>
                        <!--<form method="POST" action="">-->
                        <!--<a class="fs-modal-btn-addtobag" href="#">Add to Bag</a>-->
                        
                        <!--</form>-->
                        
                        <div class="space20"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
