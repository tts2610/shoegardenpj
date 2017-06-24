<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- BREADCRUMBS -->
<jsp:include page="../blocks/breadcrumbs.jsp" flush="true"/>


<!-- MY ACCOUNT -->
<div class="account-wrap">
    <div class="container">
        <div class="row">
            <div class="col-md-9 col-sm-8">
                <!-- HTML -->
                <div id="account-id">
                    <h4 class="account-title"><span class="fa fa-chevron-right"></span>Change Your Password</h4>    
                    <div>

                    </div>
                    <div class="account-form">
                        <form id="shipping-zip-form" class="fs-form-change-pass" action="user/change-password/${sessionScope.findUsersID}.html" method="post">    
                            ${error}
                            <ul class="form-list row">
                                <li class="col-md-7 col-sm-11 ">
                                    <label>Current Password<em>*</em></label>
                                    <input required name="oldpassword" type="password" class="input-text fs-old-pass">
                                    <p class="help-block" style="color: red; text-align: center; margin-top: -10px;" id="fs-oldpass-user-error"></p>
                                </li>

                                <li class="col-md-7 col-sm-11">
                                    <div class="column form-row" >
                                        <label>New Password <em>*</em></label>
                                        <input required name="password" type="password" class="input-text fs-password"><br/>
                                        <p class="help-block" style="color: red; text-align: center; margin-top: -10px;" id="fs-pass-user-error"></p>
                                    </div>
                                </li>
                                <li class="col-md-7 col-sm-11 ">
                                    <label>New Password Confirm <em>*</em></label>
                                    <input required name="repassword" type="password" class="input-text fs-repass">
                                    <p class="help-block" style="color: red; text-align: center; margin-top: -10px;" id="fs-repass-user-error"></p>
                                </li>    
                            </ul>
                            <div class="buttons-set">
                                <button class="btn-black fs-button-change-pass" type="submit"><span><span>Update</span></span></button>
                            </div>                                     
                        </form>
                    </div>                                 
                </div>
            </div>

            <div class="col-md-3 col-sm-4 checkout-steps">
                
                <!-- USER-RIGHT-MENU -->
                <jsp:include page="../blocks/user-right-menu.jsp" flush="true" />
            </div>
        </div>
    </div>
</div>
<div class="clearfix space20"></div>