/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import spring.entity.Rating;

/**
 *
 * @author tuan
 */
@Stateless
public class RatingFacade extends AbstractFacade<Rating> implements RatingFacadeLocal {

    @PersistenceContext(unitName = "ShoeGardenPJPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public RatingFacade() {
        super(Rating.class);
    }

    @Override
    public int countPendingRecord() {
        Query q = getEntityManager().createNativeQuery("SELECT COUNT(*) FROM rating r where r.status = 2 ");
        try{
        return (int) q.getSingleResult();
        }catch(Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public boolean updateStatusRating(int rateID, short status) {
        Rating targetRating = find(rateID);

        if (targetRating == null) {
            return false;
        }

        targetRating.setStatus(status);
        getEntityManager().merge(targetRating);

        return true;
    }
    
}
