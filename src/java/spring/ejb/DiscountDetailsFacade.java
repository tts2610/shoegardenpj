/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import java.util.ArrayList;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import spring.entity.DiscountDetails;
import spring.entity.Discounts;
import spring.entity.Products;

/**
 *
 * @author tuan
 */
@Stateless
public class DiscountDetailsFacade extends AbstractFacade<DiscountDetails> implements DiscountDetailsFacadeLocal {

    @PersistenceContext(unitName = "ShoeGardenPJPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public DiscountDetailsFacade() {
        super(DiscountDetails.class);
    }
    
    @Override
    public short findDiscountDetailsByProductID(Products pro){
        Query q = em.createNativeQuery("select d.discount from Discounts d JOIN DiscountDetails di on d.discID = di.discID AND di.productID = "+pro.getProductID());
        try{
        return (short) q.getSingleResult();}
        catch(Exception e){
            return 0;
        }
    }

    @Override
    public List<Integer> findListByDiscountID(int id) {
        Query q = em.createNativeQuery("SELECT productID from discountDetails where discID = "+ id);
        return q.getResultList();
    }
    
    @Override
    public List<Products> findListByProductListForUpdate(List<Products> pList,List<Products>uList) {
        List<Products> nList = new ArrayList<>();
        
        for (Products products : uList) {
            if(!pList.contains(products))
                nList.add(products);
        }
        
        return nList;
    }

    @Override
    public void removeByDiscountidAndProductID(int d, int pro) {
        Query q = em.createNativeQuery("Delete DiscountDetails where discID = "+d+" and productID = "+pro);
        q.executeUpdate();
    }
    @Override
    public void updateByDiscountidAndProductID(int d, int pro){
        Query q = em.createNativeQuery("Update DiscountDetails set productID = "+pro+" where discID="+d);
        q.executeUpdate();
    }

    @Override
    public void removeOR(int discountid) {
        Query q = em.createNativeQuery("Delete DiscountDetails where discID = "+discountid);
        q.executeUpdate();
    }
    
    
}
