<%-- 
    Document   : cart
    Created on : Jun 28, 2017, 12:10:13 PM
    Author     : tuan
--%>

<div class="cd-cart-container">
	<a href="#0" class="cd-cart-trigger" style="
    background-color: #f5f5f5;">
		Cart
		<ul class="count"> <!-- cart items count -->
			<li>0</li>
			<li>0</li>
		</ul> <!-- .count -->
	</a>

    <div class="cd-cart">
        <div class="wrapper">
            <div>
                
            </div>

            <div class="body">
                <ul>
                    <!-- products added to the cart will be inserted here using JavaScript -->
                </ul>
            </div>

            <div id="cartft">
                <button onclick="return checkoutClick();" disabled="true" class="checkout btn" style="border-radius: 0px;width: 367px"><em>Checkout</em></button>
                <input type="hidden" name="order-emailUser" value="${sessionScope.emailUser}" />
            </div>
        </div>
    </div> <!-- .cd-cart -->
</div> <!-- cd-cart-container -->
