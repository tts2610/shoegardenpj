jQuery(document).ready(function ($) {
    var cartWrapper = $('.cd-cart-container');
    //product id - you don't need a counter in your real project but you can use your real product id
    var productId = 0;



    if (cartWrapper.length > 0) {
        //store jQuery objects
        var cartBody = cartWrapper.find('.body')
        var cartList = cartBody.find('ul').eq(0);
        var cartTotal = cartWrapper.find('.checkout').find('span');
        var cartTrigger = cartWrapper.children('.cd-cart-trigger');
        var cartCount = cartTrigger.children('.count')
        var addToCartBtn = $('.fs-modal-btn-addtobag');
        var addToCartBtnDetailPage = $('#fs-product-detail-add-to-cart')
        var undo = cartWrapper.find('.undo');
        var undoTimeoutId;
        var productCount;
        

        //remove all button
        cartWrapper.on('click', '#removeallbtn', function (e) {
            $.ajax({
                url: "orders/ajax/cartdeleteall.html",
                method: "GET",
                success: function (response) {
                    $.ajax({
                        url: "orders/ajax/cart.html",
                        method: "GET",
                        dataType: 'html',
                        success: function (response) {
                            var info = response.split("*");
                            var productAdded = $(response);
                            var productCount = info[1];
                            updateCartCount(productCount);
                            cartList.html(productAdded);
                        }
                    });
                    cartWrapper.find('.checkout').prop('disabled', true);
                }
            });
        });

        //add product to cart
        addToCartBtn.on('click', function (event) {
            event.preventDefault();
            addToCart($(this));
        });
        
        //add product to cart in detail page
        addToCartBtnDetailPage.on('click', function (event) {
            event.preventDefault();
            addToCart_Detail($(this));
        });

        //open/close cart
        cartTrigger.on('click', function (event) {
            event.preventDefault();
            toggleCart();
        });

        //close cart when clicking on the .cd-cart-container::before (bg layer)
        cartWrapper.on('click', function (event) {
            if ($(event.target).is($(this)))
                toggleCart(true);
        });

        //delete an item from the cart
        cartList.on('click', '.delete-item', function (event) {
            event.preventDefault();
            removeProduct($(event.target).parents('.product'));
        });

        //update item quantity
        cartList.on('change', 'select', function (event) {
            quickUpdateCart();
        });


    }

    function toggleCart(bool) {
        var cartIsOpen = (typeof bool === 'undefined') ? cartWrapper.hasClass('cart-open') : bool;


        //enable checkoutbtn
        if(cartCount.find('li').eq(0).text()!="0"){
        cartWrapper.find('.checkout').prop('disabled', false)
        }
        if(cartCount.find('li').eq(0).text()=="0"){
        cartWrapper.find('.checkout').prop('disabled', true)
        }

        if (cartIsOpen) {
            cartWrapper.removeClass('cart-open');
            //reset undo
            clearInterval(undoTimeoutId);
            undo.removeClass('visible');
            cartList.find('.deleted').remove();

            setTimeout(function () {
                cartBody.scrollTop(0);
//				//check if cart empty to hide it
//				if( Number(cartCount.find('li').eq(0).text()) == 0) cartWrapper.addClass('empty');
            }, 500);
        } else {
            cartWrapper.addClass('cart-open');
        }
    }

    function addToCart(trigger) {
        //update cart product list
        addProduct();
    }

    function addProduct() {

        var errorHead = "<div class=\"alert alert-danger\"><strong>";
        var errorHeadSuccess = "<div class=\"alert alert-success\"><strong>";
        var errorFoot = "</strong></div>";
        var colorID = $(".fs-product-modal-color .fs-product-selected").find("img").attr("fs-color");
        var sizeID = $("#fs-product-modal-size .fs-product-selected").attr("fs-size");
        var productID = $(".fs-product-name").attr("fs-product-modal-id");
        var quantity = $(".fs-modal-input-number").val();
        if (colorID == null && sizeID == null) {
            $('#error-cart-product-modal').html(errorHead + "YOU MUST CHOOSE COLOR AND SIZE" + errorFoot);
        } else {
            if (colorID == null) {
                $('#error-cart-product-modal').html(errorHead + "YOU MUST CHOOSE COLOR" + errorFoot);
            } else if (sizeID == null) {
                $('#error-cart-product-modal').html(errorHead + "YOU MUST CHOOSE SIZE" + errorFoot);
            } else {
                $.ajax({
                    url: "orders/ajax/addtocart.html",
                    method: "POST",
                    data: {
                        productID: productID,
                        sizeID: sizeID,
                        colorID: colorID,
                        quantity: quantity
                    },
                    dataType: 'html',
                    success: function (response) {
                        if (response == "3") {
                            $('#error-cart-product-modal').html(errorHead + "PRODUCT ERROR!" + errorFoot);
                        } else if (response == "2") {
                            $('#error-cart-product-modal').html(errorHead + "COLOR AND SIZE ERROR!" + errorFoot);
                        } else if (response == "1") {
                            $('#error-cart-product-modal').html(errorHead + "NOT ENOUGH STOCK! PLEASE ENTER DIFFERENT QUANTITY" + errorFoot);
                        } else {
                            var res = response.split("-");
                            $(".fs-input-number, .fs-modal-input-number").removeAttr("disabled");
                            $(".fs-btn-quantity-plus, .fs-modal-btn-quantity-plus").removeAttr("disabled");
                            $(".fs-quantity-in-stock").text(" (In Stock " + res[2] + ")");
                            $(".fs-modal-input-number").val(1);
                            if (res[1] != res[2]) {
                                $(".fs-quantity-in-cart").css("display", "block")
                                $(".fs-quantity-in-cart").text("This pairs are available in your cart (" + res[0] + " pairs)");
                            }
                            if (res[1] == res[2]) {
                                $(".fs-quantity-in-cart").css("display", "none")
                                $(".fs-quantity-in-cart").text("");
                            }
                            if (res[0] == res[2]) {
                                $(".fs-modal-btn-quantity-plus").attr("disabled", "disabled");
                                $(".fs-modal-btn-quantity-minus").attr("disabled", "disabled");
                                $(".fs-modal-btn-addtobag").attr("disabled", "disabled")
                            }
                            $(".fs-input-number, .fs-modal-input-number").attr("max", res[1]);
                            $(".fs-input-number, .fs-modal-input-number").attr("disabled", "disabled");
                            $.ajax({
                                url: "orders/ajax/cart.html",
                                method: "GET",
                                dataType: 'html',
                                success: function (response) {
                                    var info = response.split("*");
                                    var productAdded = $(response);
                                    var productCount = info[1];
                                    updateCartCount(productCount);
                                    cartList.html(productAdded);
                                }
                            });
                        }
                    }
                });
            }
        }
    }
    
    function addToCart_Detail(trigger){
        var colorID = $(".fs-product-color .fs-product-selected").find("img").attr("fs-color");
        var sizeID = $("#fs-product-size .fs-product-selected").attr("fs-size");
        var productID = $(".fs-product-detail-name").attr("fs-product-id");
        var quantity = $(".fs-input-number").val();
        if (colorID == null && sizeID == null) {
            $("#error-product-detail").html("<div class=\"alert alert-danger\">\n" +
                    "<strong>YOU MUST CHOOSE COLOR AND SIZE</strong>\n" +
                    "</div>");
        } else {
            if (colorID == null) {
                $("#error-product-detail").html("<div class=\"alert alert-danger\">\n" +
                        "<strong>YOU MUST CHOOSE COLOR</strong>\n" +
                        "</div>");
            } else if (sizeID == null) {
                $("#error-product-detail").html("<div class=\"alert alert-danger\">\n" +
                        "<strong>YOU MUST CHOOSE SIZE</strong>\n" +
                        "</div>");
            } else {
                $.ajax({
                    url: "orders/ajax/addtocart.html",
                    method: "POST",
                    data: {
                        productID: productID,
                        sizeID: sizeID,
                        colorID: colorID,
                        quantity: quantity
                    },
                    dataType: 'html',
                    success: function (response) {
                        if (response == "3") {
                            $("#error-product-detail").html("<div class=\"alert alert-danger\">\n" +
                                    "<strong>PRODUCT ERROR</strong>\n" +
                                    "</div>");
                        } else if (response == "2") {
                            $("#error-product-detail").html("<div class=\"alert alert-danger\">\n" +
                                    "<strong>COLOR AND SIZE ERROR</strong>\n" +
                                    "</div>");
                        } else if (response == "1") {
                            $("#error-product-detail").html("<div class=\"alert alert-danger\">\n" +
                                    "<strong>OUT OF STOCK</strong>\n" +
                                    "</div>");
                        } else {
                            
                            $("#error-product-detail").html("<div class=\"alert alert-success\">\n" +
                                    "<strong>ADD PRODUCT TO CART SUCCESSFULLY</strong>\n" +
                                    "</div>");
                            
                            var res = response.split("-");
                            $(".fs-input-number, .fs-modal-input-number").removeAttr("disabled");
                            $(".fs-btn-quantity-plus, .fs-modal-btn-quantity-plus").removeAttr("disabled");
                            $(".fs-quantity-in-stock").text(" (In Stock " + res[2] + ")");
                            $(".fs-modal-input-number").val(1);
                            $(".fs-input-number").val(1);
                            if (res[1] != res[2]) {
                                $(".fs-quantity-in-cart").css("display", "block")
                                $(".fs-quantity-in-cart").text("This pairs are available in your cart (" + res[0] + " pairs)");
                            }
                            if (res[1] == res[2]) {
                                $(".fs-quantity-in-cart").css("display", "none")
                                $(".fs-quantity-in-cart").text("");
                            }
                            if (res[0] == res[2]) {
                                $(".fs-modal-btn-quantity-plus").attr("disabled", "disabled");
                                $(".fs-modal-btn-quantity-minus").attr("disabled", "disabled");
                                $("#fs-product-detail-add-to-cart").attr("disabled", "disabled")
                                $(".fs-btn-quantity-minus").attr("disabled", "disabled")
                                $(".fs-btn-quantity-plus").attr("disabled", "disabled")
                            }
                            $(".fs-input-number, .fs-modal-input-number").attr("max", res[1]);
                            $(".fs-input-number, .fs-modal-input-number").attr("disabled", "disabled");
                            $.ajax({
                                url: "orders/ajax/cart.html",
                                method: "GET",
                                dataType: 'html',
                                success: function (response) {
                                    var info = response.split("*");
                                    var productAdded = $(response);
                                    var productCount = info[1];
                                    updateCartCount(productCount);
                                    cartList.html(productAdded);
                                }
                            });
                        }
                    }
                });
            }
        }
    }

    function removeProduct(product) {
        clearInterval(undoTimeoutId);
        cartList.find('.deleted').remove();
        var cartInfo = product.attr("fs-cartInfo");



        var topPosition = product.offset().top - cartBody.children('ul').offset().top,
                productQuantity = Number(product.find('.quantity').find('select').val()),
                productTotPrice = Number(product.find('.price').text().replace('$', '')) * productQuantity;

        product.css('top', topPosition + 'px').addClass('deleted');
        //update items count + total price
        updateCartTotal(productTotPrice, false);

        //wait before completely remove the item
        undoTimeoutId = setTimeout(function () {

            cartList.find('.deleted').remove();
            $.ajax({
                url: "orders/ajax/deletecartitem.html",
                method: "POST",
                data: {
                    cartInfo: cartInfo

                },
                dataType: 'html',
                success: function (response) {
                    if (response == "1") {
                        $.ajax({
                            url: "orders/ajax/cart.html",
                            method: "GET",
                            dataType: 'html',
                            success: function (response) {
                                var info = response.split("*");
                                var productAdded = $(response);
                                var productCount = info[1];
                                updateCartCount(productCount);
                                cartList.html(productAdded);
                            }
                        });
                    } else
                        console.log("ERROR");
                }
            });
        }, 100);
    }

    function quickUpdateCart() {
        var quantity = 0;
        var price = 0;

        cartList.children('li:not(.deleted)').each(function () {
            var singleQuantity = Number($(this).find('select').val());
            quantity = quantity + singleQuantity;
            price = price + singleQuantity * Number($(this).find('.price').text().replace('$', ''));
        });

        cartTotal.text(price.toFixed(2));
        cartCount.find('li').eq(0).text(quantity);
        cartCount.find('li').eq(1).text(quantity + 1);
    }

    function updateCartCount(quantity) {

        var actual = Number(quantity);
        var next = actual + 1;


        cartCount.addClass('update-count');

        setTimeout(function () {
            cartCount.find('li').eq(0).text(actual);
        }, 150);

        setTimeout(function () {
            cartCount.removeClass('update-count');
        }, 200);

        setTimeout(function () {
            cartCount.find('li').eq(1).text(next);
        }, 230);


    }

    
});