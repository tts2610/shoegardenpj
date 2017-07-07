<%@page import="spring.ejb.OrderStateLessBeanLocal"%>
<%@page import="spring.ejb.RatingFacadeLocal"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="spring.ejb.RatingFacade"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Navigation -->
<%!
    RatingFacadeLocal ratingFacade;
    OrderStateLessBeanLocal orderFacade;
%>
<%
try {
Context context = new InitialContext();
ratingFacade = (RatingFacadeLocal) context.lookup("java:global/ShoeGardenPJ/RatingFacade!spring.ejb.RatingFacadeLocal");
orderFacade = (OrderStateLessBeanLocal) context.lookup("java:global/ShoeGardenPJ/OrderStateLessBean!spring.ejb.OrderStateLessBeanLocal");
}
catch(Exception e) {
    e.printStackTrace();
}
%>
<nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
    <div class="navbar-header">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="admin/index.html">Shoe Garden</a>
    </div>
    <!-- /.navbar-header -->

    <ul class="nav navbar-top-links navbar-right">
       <li><a href="admin/logout.html"><i class="fa fa-sign-out fa-fw"></i> Logout</a>
                </li>
    </ul>
    <!-- /.navbar-top-links -->

    <div class="navbar-default sidebar" role="navigation">
        <div class="sidebar-nav navbar-collapse">
            <ul class="nav" id="side-menu">
                <c:if test="${sessionScope.rid==1}">
                <li>
                    <a href="#"><i class="fa fa-key fa-fw"></i> User Role<span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level">
                        <li>
                            <a href="admin/user/role.html"><i class="fa fa-list" aria-hidden="true"></i> List</a>
                        </li>
                        <li>
                            <a href="admin/user/role/create.html"><i class="fa fa-plus" aria-hidden="true"></i> New</a>
                        </li>
                    </ul>
                    <!-- /.nav-second-level -->
                </li>
                </c:if>
                <li>
                    <a href="#"><i class="fa fa-users fa-fw"></i> User<span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level">
                        <li>
                            <a href="admin/user/list.html"><i class="fa fa-list" aria-hidden="true"></i> List</a>
                        </li>

                    </ul>
                    <!-- /.nav-second-level -->
                </li>

                <li>
                    <a href="#"><i class="fa fa-cube fa-fw"></i>Brand<span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level">
                        <li>
                            <a href="admin/product-category.html"><i class="fa fa-list" aria-hidden="true"></i> List</a>
                        </li>
                        <li>
                            <a href="admin/product-category/create.html"><i class="fa fa-plus" aria-hidden="true"></i> New</a>
                        </li>
                    </ul>
                    <!-- /.nav-second-level -->
                </li>

                <li>
                    <a href="#"><i class="fa fa-cubes fa-fw"></i>Category<span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level">
                        <li>
                            <a href="admin/product-subcategory.html"><i class="fa fa-list" aria-hidden="true"></i> List</a>
                        </li>
                        <li>
                            <a href="admin/product-subcategory/create.html"><i class="fa fa-plus" aria-hidden="true"></i> New</a>
                        </li>
                    </ul>
                    <!-- /.nav-second-level -->
                </li>

                <li>
                    <a href="#"><i class="fa fa-diamond fa-fw"></i> Product<span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level">
                        <li>
                            <a href="admin/product.html"><i class="fa fa-list" aria-hidden="true"></i> List</a>
                        </li>
                        <li>
                            <a href="admin/product/create.html"><i class="fa fa-plus" aria-hidden="true"></i> New</a>
                        </li>
                    </ul>
                    <!-- /.nav-second-level -->
                </li>

                <li>
                    <a href="#"><i class="fa fa-shopping-cart fa-fw"></i> Orders&nbsp;
                        <%if(orderFacade.countPendingOrder()!=0){%>
                        <span class="badge" style="background: red"><%=orderFacade.countPendingOrder()%></span>
                        <%}%>
                        <span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level">
                        <li>
                            <a href="admin/orders/list.html"><i class="fa fa-list" aria-hidden="true"></i> List</a>
                        </li>
                    </ul>
                    <!-- /.nav-second-level -->
                </li>

                <li>
                    <a href="#"><i class="fa fa-shopping-cart fa-fw"></i> Discount<span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level">
                        <li>
                            <a href="admin/discount/discountlist.html"><i class="fa fa-wpforms" aria-hidden="true"></i> List</a>
                        </li>
                        <li>
                            <a href="admin/discount/discountadd.html"><i class="fa fa-plus" aria-hidden="true"></i> New</a>
                        </li>
                    </ul>
                    <!-- /.nav-second-level -->
                </li>

                <li>
                    <a href="#"><i class="fa fa-thumb-tack fa-fw"></i> Reviews&nbsp;
                        <%if(ratingFacade.countPendingRecord()!=0){%>
                        <span class="badge" style="background: red"><%=ratingFacade.countPendingRecord()%></span>
                        <%}%>
                        <span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level">
                        <li>
                            <a href="admin/comments/list.html"><i class="fa fa-list" aria-hidden="true"></i> List</a>
                        </li>
                    </ul>
                    <!-- /.nav-second-level -->
                </li>

                

            </ul>
        </div>
        <!-- /.sidebar-collapse -->
    </div>
    <!-- /.navbar-static-side -->
</nav>
