/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import java.util.List;
import javax.ejb.Local;
import spring.entity.ProductSubImgs;

/**
 *
 * @author tuan
 */
@Local
public interface ProductSubImgsFacadeLocal {

    void create(ProductSubImgs productSubImgs);

    void edit(ProductSubImgs productSubImgs);

    void remove(ProductSubImgs productSubImgs);

    ProductSubImgs find(Object id);

    List<ProductSubImgs> findAll();

    List<ProductSubImgs> findRange(int[] range);

    int count();
    
}
