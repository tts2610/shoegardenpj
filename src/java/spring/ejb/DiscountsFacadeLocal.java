/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import java.util.List;
import javax.ejb.Local;
import spring.entity.Discounts;

/**
 *
 * @author tuan
 */
@Local
public interface DiscountsFacadeLocal {

    Discounts createOR(Discounts discounts);

    Discounts editOR(Discounts discounts);

    public void removeOR(int discounts);

    Discounts find(Object id);

    List<Discounts> findAll();

    List<Discounts> findRange(int[] range);

    int count();
    List<Discounts> selectTop3Discount();
    
}
