/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import java.util.List;
import javax.ejb.Local;
import spring.entity.Categories;

/**
 *
 * @author tuan
 */
@Local
public interface CategoriesFacadeLocal{

    int createOR(Categories categories);

    int editOR(Categories categories);

    boolean removeOR(int categories);

    Categories find(Object categories);

    List<Categories> findAll();

    List<Categories> findRange(int[] range);

    int count();
    
}
