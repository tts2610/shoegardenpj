<%-- 
    Document   : comment-list
    Created on : Jun 20, 2017, 10:51:58 AM
    Author     : tuan
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="page-wrapper">
    <div class="container-fluid" id="comment">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header"> 
                    <strong>Rating & Reviews</strong> 
                    <i class="fa fa-caret-right fa-style" aria-hidden="true" style="color: #337ab7"></i> 
                    <span style="font-size: 0.9em">List</span>
                </h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->

        <div class="row">
            <div class="col-lg-12">
                <table width="100%" class="table table-striped table-bordered table-hover" id="fs-rating-dataTables">
                    <thead>
                        <tr>
                            <td class="text-center fs-valign-middle">No</td>
                            <td class="text-center fs-valign-middle">Product</td>
                            <td class="text-center fs-valign-middle">User</td>
                            <td class="text-center fs-valign-middle">Rate</td>
                            <td class="text-center fs-valign-middle">Rate Date</td>
                            <td class="text-center fs-valign-middle">Review</td>
                            <td class="text-center fs-valign-middle">Actions</td>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${cList}" var="rating" varStatus="no">
                            
                            <tr class="odd gradeX" id="fs-role-list-id-${rating.ratingID}" <c:if test="${rating.status == 2}">style="background-color: rgb(225, 255, 251)"</c:if><c:if test="${rating.status == 0}">style="background-color: rgb(255, 211, 211)"</c:if><c:if test="${rating.status == 1}">style="background-color: rgba(147, 177, 233, 0.56)"</c:if>>
                                    <td class="text-center fs-valign-middle">${no.index + 1}</td>
                                    <td class="text-center fs-valign-middle">${rating.product.productName}</td>
                                    <td class="text-center fs-valign-middle">${rating.user.firstName}&nbsp;${rating.user.lastName}</td>
                                    <td class="text-center fs-valign-middle">                        
                                        <select id="fs-rating-star-results-${no.index + 1}" class="fs-rating-star-results-select" index="${no.index + 1}" data-current-rating="${rating.rating}">
                                            <option value=""></option>
                                            <option value="1">1</option>
                                            <option value="2">2</option>
                                            <option value="3">3</option>
                                            <option value="4">4</option>
                                            <option value="5">5</option>
                                        </select>
                                    </td>
                                    <td class="text-center fs-valign-middle"><fmt:formatDate value="${rating.ratingDate}" pattern="dd MMM, yyyy" timeZone="US"/></td>
                                    <td class="text-center fs-valign-middle">${rating.review}</td>
                                    <td align="center">
                                        <select name="status" fs-comment="${rating.ratingID}" class="fs-select-comment-status form-control input-sm" id="fs-status-select">
                                            <c:choose>
                                                <c:when test="${rating.status != 2}">
                                                    <option id="fs-status-1" value="1" <c:if test="${rating.status == 1}">selected</c:if>>VERIFIED</option>
                                                    <option id="fs-status-2" value="0" <c:if test="${rating.status == 0}">selected</c:if>>NOT VERIFIED</option>
                                                </c:when>
                                                <c:otherwise>
                                                    <option id="fs-status-1" value="1" <c:if test="${rating.status == 1}">selected</c:if>>VERIFIED</option>
                                                    <option id="fs-status-2" value="0" <c:if test="${rating.status == 0}">selected</c:if>>NOT VERIFIED</option>
                                                    <option id="fs-status-2" value="0" <c:if test="${rating.status == 2}">selected</c:if>>PENDING</option>
                                                </c:otherwise>
                                            </c:choose>
                                        </select>
                                    </td>
                            <div id="countcmt" fs-value="${countcmt}" style="display: none"></div>
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
