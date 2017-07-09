<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!-- Page Content -->
<div id="page-wrapper">
    <div class="container-fluid" id="fs-update-category-admin-page" fs-category-id="${targetCate.braID}">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header"> 
                    <strong>Brand</strong> 
                    <i class="fa fa-caret-right fa-style" aria-hidden="true" style="color: #337ab7"></i> 
                    <span style="font-size: 0.9em">Edit Info</span>
                </h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->

        <div class="row">
            <div class="col-lg-12">
                <div class="col-lg-6">
                    <div>
                        ${error}
                    </div>
                        <form:form method="POST" action="" modelAttribute="targetCate">
                        <div class="form-group">
                            <label>Brand</label>
                            <form:hidden path="braID" cssClass="form-control" />
                            <form:input path="braName" cssClass="form-control" placeholder="Enter Product Brand Name" />
                            <!--Error Message-->
                            <p class="help-block" id="fs-cate-name-err-mes"></p>
                        </div>

                        <button type="submit" class="btn btn-warning" id="fs-btn-update-category">Update</button>
                        <button type="reset" class="btn btn-default">Reset</button>
                    </form:form>
                </div>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
    </div>
    <!-- /.container-fluid -->
</div>
<!-- /#page-wrapper -->