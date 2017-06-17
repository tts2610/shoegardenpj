/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import java.util.List;
import javax.ejb.Local;
import spring.entity.Brands;

/**
 *
 * @author tuan
 */
@Local
public interface BrandsFacadeLocal {

    int createOR(Brands brands);

    int editOR(Brands brands);

    public boolean removeOR(int braID);

    Brands find(Object id);

    List<Brands> findAll();

    List<Brands> findRange(int[] range);

    int count();
    
    Brands findBrandsByName(String braName);

    List<Brands> findBrandsLikeName(String braName);
    
}
