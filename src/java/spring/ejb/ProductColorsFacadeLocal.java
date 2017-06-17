/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import java.util.List;
import javax.ejb.Local;
import spring.entity.ProductColors;

/**
 *
 * @author tuan
 */
@Local
public interface ProductColorsFacadeLocal {

    void create(ProductColors productColors);

    void edit(ProductColors productColors);

    void remove(ProductColors productColors);

    ProductColors find(Object id);

    List<ProductColors> findAll();

    List<ProductColors> findRange(int[] range);

    int count();
    
}
