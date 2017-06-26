/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.PostPersist;
import javax.persistence.Query;
import spring.entity.Discounts;

/**
 *
 * @author tuan
 */
@Stateless
public class DiscountsFacade extends AbstractFacade<Discounts> implements DiscountsFacadeLocal {

    @PersistenceContext(unitName = "ShoeGardenPJPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public DiscountsFacade() {
        super(Discounts.class);
    }

    @Override
    public Discounts createOR(Discounts discounts) {
        create(discounts);
        return discounts;
    }

    @Override
    public Discounts editOR(Discounts discounts) {
        edit(discounts);
        return discounts;
    }

    @Override
    public void removeOR(int discounts) {
        Query q = em.createNativeQuery("DELETE discounts where discID = "+discounts);
        q.executeUpdate();
    }
    
    @PostPersist
    public void insertEntity(Object entity) {
        System.err.println("CONCACACACAC");
        em.flush();
        em.refresh(entity);
    }
    
}
