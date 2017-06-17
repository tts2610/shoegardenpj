/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import java.util.List;
import javax.ejb.Local;
import spring.entity.SizesByColor;

/**
 *
 * @author tuan
 */
@Local
public interface SizesByColorFacadeLocal {

    void create(SizesByColor sizesByColor);

    void edit(SizesByColor sizesByColor);

    void remove(SizesByColor sizesByColor);

    SizesByColor find(Object id);

    List<SizesByColor> findAll();

    List<SizesByColor> findRange(int[] range);

    int count();
    
}
