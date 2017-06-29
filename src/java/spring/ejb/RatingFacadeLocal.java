/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import java.util.List;
import javax.ejb.Local;
import spring.entity.Rating;

/**
 *
 * @author tuan
 */
@Local
public interface RatingFacadeLocal {

    void create(Rating rating);

    void edit(Rating rating);

    void remove(Rating rating);

    Rating find(Object id);

    List<Rating> findAll();

    List<Rating> findRange(int[] range);

    int count();
    
    int countPendingRecord();
    
    boolean updateStatusRating(int rateID, short status);
    
}
