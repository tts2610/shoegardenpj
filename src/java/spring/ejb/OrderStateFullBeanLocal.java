/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import java.util.List;
import javax.ejb.Local;
import spring.entity.CartLineInfo;
import spring.entity.Orders;

/**
 *
 * @author tuan
 */
@Local
public interface OrderStateFullBeanLocal {
    void addProduct(CartLineInfo cartLineInfo);
    boolean deleteProduct(CartLineInfo cartLineInfo);
    boolean deleteItem(int cartLineInfo);
    boolean updateProduct(CartLineInfo oldCartLineInfo, CartLineInfo cartLineInfo);
    List<CartLineInfo> showCart();
    CartLineInfo getProductInListByID(int productid, int sizeid, int colorid);
    String completePurchase(Orders orders);
    float subTotal();
    void remove();
    void init();
}
