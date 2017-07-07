<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Page Content -->
<div id="page-wrapper">
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header"> 
                    <strong>Discount</strong> 
                    <i class="fa fa-caret-right fa-style" aria-hidden="true" style="color: #337ab7"></i> 
                    <span style="font-size: 0.9em">List</span>
                </h1>
            </div>
            <div class="col-xs-12" style="margin-bottom: 10px">
                <span style="color: red; font-size: 13px">
                    <i>* Click on ID to view discount details!</i>
                </span>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        
        <div class="row">
            <div class="col-lg-12">
                <div>
                    ${error}
                </div>
                <table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-example">
                    <thead>
                        <tr>
                            <td class="text-center fs-valign-middle">ID</td>
                            <th class="text-center fs-valign-middle">Discount</th>
                            <th class="text-center fs-valign-middle">Title</th>
                            <th class="text-center fs-valign-middle">Content</th>
                            <th class="text-center fs-valign-middle">Begin Date</th>
                            <th class="text-center fs-valign-middle">End Date</th>
                            <th class="text-center fs-valign-middle">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${discountList}" var="discount">
                            <tr class="odd gradeX">
                                <td class="text-center fs-valign-middle" style="font-size: 20px; font-weight: 700;"><a  
                                        href="admin/discount/viewdiscountdetail/${discount.discID}.html"
                                        >${discount.discID}</a></td>
                                <td class="text-center fs-valign-middle">${discount.discount}%</td>
                                <td class="text-center fs-valign-middle">${discount.discTitle}</td>
                                <td class="text-center fs-valign-middle">${discount.discContent}</td>
                                <td class="text-center fs-valign-middle">
                                    <c:choose>
                                        <c:when test="${discount.dateBegin == null}">
                                            --
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatDate value="${discount.dateBegin}" pattern="dd-MM-yyyy"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center fs-valign-middle">
                                    <c:choose>
                                        <c:when test="${discount.dateEnd == null}">
                                            --
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatDate value="${discount.dateEnd}" pattern="dd-MM-yyyy"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="text-center fs-valign-middle">
                                    <a href="admin/discount/discountupdate/${discount.discID}.html" type="button" class="btn btn-primary">UPDATE</a>
                                    <a data-href="admin/discount/discountdelete/${discount.discID}.html" 
                                       type="button" 
                                       class="btn btn-danger" 
                                       data-toggle="modal" 
                                       data-target="#confirm-discount-delete">DELETE</a>
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
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header"> 
                    <strong>Discount Details</strong> 


                </h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>            
        <div class="row fs-div-product-list-select-box" > 
            <div class="col-lg-12">
                <table width="100%" class="table table-striped table-bordered table-hover" id="tableOrder">
                    <thead>
                        <tr>
                            <th class="text-center fs-valign-middle">ID</th>
                            <th class="text-center fs-valign-middle">Status</th>
                            <th class="text-center fs-valign-middle">Brand - Category</th>
                            <th class="text-center fs-valign-middle">Product</th>
                            <th class="text-center fs-valign-middle">Image</th>
                            <th class="text-center fs-valign-middle">Posted Date</th>

                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach items="${productList}" var="product" varStatus="No">
                            <tr>
                                <td class="text-center fs-valign-middle" data-jtable="${product.productID}">${product.productID}</td>
                                <c:if test="${product.status == 1}">
                                    <td class="text-center fs-valign-middle">WORKING</td>
                                </c:if>
                                <c:if test="${product.status == 0}">
                                    <td class="text-center fs-valign-middle">STOPPED</td>
                                </c:if>
                                <td class="text-center fs-valign-middle">${product.braID.braName} - ${product.catID.catName}</td>
                                <td class="text-center fs-valign-middle">${product.productName}</td>
                                <td class="text-center fs-valign-middle">
                                    <img class="responsive" style="width: 100px" src="assets/images/products/${product.urlImg}" alt="${product.urlImg}"/>
                                </td>
                                <td class="text-center fs-valign-middle">
                                    <fmt:formatDate pattern="dd/MM/yyyy" value="${product.postedDate}"/>
                                </td>


                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <!-- /.table-responsive -->
            </div>

        </div>
    </div>
    <div class="modal fade" id="confirm-discount-delete" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="myModalLabel">Confirm Discount Delete</h4>
                </div>

                <div class="modal-body">
                    <p>Do you want to proceed?</p>
                    <p class="debug-url"></p>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    <a class="btn btn-danger btn-discount-delete-ok">Delete</a>
                </div>
            </div>
        </div>
    </div>


    <!-- /.container-fluid -->
</div>
<!-- /#page-wrapper -->