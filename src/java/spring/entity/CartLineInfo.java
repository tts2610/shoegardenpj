/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.entity;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import spring.ejb.DiscountDetailsFacadeLocal;

/**
 *
 * @author NganNgo
 */
public class CartLineInfo {

    DiscountDetailsFacadeLocal discountDetailsFacade = lookupDiscountDetailsFacadeLocal();

    
    private Products product;
    private SizesByColor sizesByColor;
    private int quantity;
    
    

    public SizesByColor getSizesByColor() {
        return sizesByColor;
    }

    public void setSizesByColor(SizesByColor sizesByColor) {
        this.sizesByColor = sizesByColor;
    }

    public CartLineInfo() {
        this.quantity = 0;
    }

    public Products getProduct() {
        return product;
    }

    public void setProduct(Products product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public double getSubTotal(){
//           return 0;
           return discountDetailsFacade.getProductWithDiscount(product)*quantity;
    }
    
    

    private DiscountDetailsFacadeLocal lookupDiscountDetailsFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (DiscountDetailsFacadeLocal) c.lookup("java:global/ShoeGardenPJ/DiscountDetailsFacade!spring.ejb.DiscountDetailsFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }
    
}
