/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import java.util.List;
import javax.ejb.Local;
import spring.entity.DiscountDetails;
import spring.entity.Products;

/**
 *
 * @author tuan
 */
@Local
public interface DiscountDetailsFacadeLocal {

    void create(DiscountDetails discountDetails);

    void edit(DiscountDetails discountDetails);

    void remove(DiscountDetails discountDetails);

    DiscountDetails find(Object id);

    List<DiscountDetails> findAll();

    List<DiscountDetails> findRange(int[] range);

    int count();
    
    public short findDiscountDetailsByProductID(Products pro);
    
    List<Integer>findListByDiscountID(int id);
    
    public List<Products> findListByProductListForUpdate(List<Products> pList,List<Products>uList);
    
    public void removeByDiscountidAndProductID(int d, int pro);
    public void updateByDiscountidAndProductID(int d, int pro);
    public void removeOR(int discountid);
    public void createOR(DiscountDetails discountDetails);
    
}
