<%@page import="java.math.RoundingMode"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="spring.entity.Orders"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Page Content -->
<div id="page-wrapper">
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header"> 
                    <strong>Orders</strong> 
                    <i class="fa fa-caret-right fa-style" aria-hidden="true" style="color: #337ab7"></i> 
                    <span style="font-size: 0.9em">Details Order NO.${order.ordersID}</span>
                </h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->

        <div class="row">
            <div class="col-lg-12">
                <table class="table table-striped table-bordered table-hover">
                    <tr>
                        <th class="text-center" style="font-weight: 700;">Order Date</th>
                        <td class="text-center"><fmt:formatDate value="${order.ordersDate}" pattern="dd-MM-yyyy"/></td>
                        <td class="text-center"><fmt:formatDate value="${order.ordersDate}" pattern="hh:mm:ss"/></td>
                    </tr>
                    <tr>
                        <th class="text-center" style="font-weight: 700;">Ship to</th>
                        <td colspan="2" style="padding-left: 20px;">${order.receiverFirstName} ${order.receiverLastName}</td>
                    </tr>
                    <tr>
                        <th class="text-center" style="font-weight: 700;">Address</th>
                        <td colspan="2" style="padding-left: 20px;">${order.deliveryAddress}</td>
                    </tr>
                    <tr>
                        <th class="text-center" style="font-weight: 700;">Phone</th>
                        <td colspan="2" style="padding-left: 20px;">${order.phoneNumber}</td>
                    </tr>
                    
                    <tr>
                        <th class="text-center" style="width: 200px;">Order Note</th>
                        <td colspan="2" style="padding-left: 20px;">
                            <c:choose>
                                <c:when test="${order.note == null}">
                                    --
                                </c:when>
                                <c:otherwise>
                                    ${order.note}
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="col-lg-12">
                <table width="100%" class="table table-striped table-bordered table-hover" id="tableOrderDetails">
                    <thead>
                        <tr>
                            <th class="text-center fs-valign-middle">Product ID</th>
                            <th class="text-center fs-valign-middle">Product Name</th>
                            <th class="text-center fs-valign-middle">Color</th>
                            <th class="text-center fs-valign-middle">Size</th>
                            <th class="text-center fs-valign-middle">Quantity</th>
                            <th class="text-center fs-valign-middle">Price for one</th>
                            <th class="text-center fs-valign-middle">Product discount</th>
                            <th class="text-center fs-valign-middle">SubTotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${orderdetailList}" var="orderdetail">
                            <tr class="odd gradeX">
                                <td class="text-center fs-valign-middle">${orderdetail.productID.productID}</td>
                                <td class="text-center fs-valign-middle">${orderdetail.productID.productName}</td>
                                <td class="text-center fs-valign-middle">${orderdetail.sizeID.colorID.color}</td>
                                <td class="text-center fs-valign-middle">${orderdetail.sizeID.size}</td>
                                <td class="text-center fs-valign-middle">${orderdetail.quantity}</td>
                                <td class="text-center fs-valign-middle">$${orderdetail.price}</td>
                                <td class="text-center fs-valign-middle">${orderdetail.productDiscount}%</td>
                                <td class="text-center fs-valign-middle">$<fmt:formatNumber type="number" maxFractionDigits="2" value="${orderdetail.subTotal}" var="prodPrice"/>
                                    ${fn:replace(prodPrice, ",", ".")}</td>
                                
                            </tr>
                        </c:forEach>
                    </tbody>
                    <tfoot>
                        
                        
                        <tr>
                            <td colspan="7" align="right"><b>Order Total</b></td>
                            <td class="text-center fs-valign-middle">$<fmt:formatNumber type="number" maxFractionDigits="2" value="${order.total}" var="prodPrice"/>
                                    ${fn:replace(prodPrice, ",", ".")}</td>
                            <td></td>
                        </tr>
                    </tfoot>
                </table>
                <!-- /.table-responsive -->
            </div>

            <div class="col-lg-12" align="right">
                <button onclick="window.location = 'admin/orders/invoice/${order.ordersID}.html';" class="btn btn-primary">INVOICE</button>
                <button onclick="window.location = 'admin/orders/list.html'" class="btn btn-primary">BACK TO ORDER LIST</button>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
    </div>
    <!-- /.container-fluid -->
</div>
<!-- /#page-wrapper -->