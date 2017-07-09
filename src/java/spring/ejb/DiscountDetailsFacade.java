/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.PostPersist;
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

    @EJB
    private DiscountsFacadeLocal discountFacade;
    
    
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
//        Calendar cal = Calendar.getInstance();  
//        cal.setTime(new Date());  
//        cal.set(Calendar.HOUR_OF_DAY, 0);  
//        cal.set(Calendar.MINUTE, 0);  
//        cal.set(Calendar.SECOND, 0);  
//        cal.set(Calendar.MILLISECOND, 0);
//        Query q = em.createNativeQuery("select d.discount from Discounts d JOIN DiscountDetails di on d.discID = di.discID AND di.productID = "+pro.getProductID()+" WHERE (d.dateBegin <= "+cal.getTime()+") AND (d.dateEnd >= "+cal.getTime()+")");
//        try{
//        return (short) q.getSingleResult();}
//        catch(Exception e){
//            return 0;
//        }
          return 0;
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
    @Override
    public void createOR(DiscountDetails discountDetails){
        create(discountDetails);
    }
    
    @PostPersist
    public void insertEntity(Object entity) {
        em.flush();
        em.refresh(entity);
    }
    
    public List<DiscountDetails> findListByDiscID(int disid){
        Query q = getEntityManager().createNativeQuery("SELECT * FROM discountDetails where discID="+disid, DiscountDetails.class);
        return q.getResultList();
    }
    
    @Override
    public float getProductWithDiscount(Products pro){
        Query q = getEntityManager().createNativeQuery("SELECT * FROM discountDetails where productID ="+pro.getProductID(),DiscountDetails.class);
        DiscountDetails dt = (DiscountDetails) q.getSingleResult();
        Discounts d = discountFacade.find(dt.getDiscID().getDiscID());
        
        Date beginDate = d.getDateBegin();
        Date endDate = d.getDateEnd();
           
            Calendar cal = Calendar.getInstance();  
            cal.setTime(new Date());  
            cal.set(Calendar.HOUR_OF_DAY, 0);  
            cal.set(Calendar.MINUTE, 0);  
            cal.set(Calendar.SECOND, 0);  
            cal.set(Calendar.MILLISECOND, 0);
            if(!beginDate.after(cal.getTime())&&!endDate.before(cal.getTime())){
                
                return (float) (pro.getPrice()*(1-(float)d.getDiscount()/100));
            }
            return (float) pro.getPrice();
    }
    
    @Override
    public float getDiscountByProduct(Products pro) {
        Query q = getEntityManager().createNativeQuery("SELECT * FROM discountDetails where productID =" + pro.getProductID(), DiscountDetails.class);
        DiscountDetails dt;
        try{
        dt = (DiscountDetails) q.getSingleResult();
        }catch(Exception e){
            return 0;
        }
        Discounts d = discountFacade.find(dt.getDiscID().getDiscID());

        Date beginDate = d.getDateBegin();
        Date endDate = d.getDateEnd();

        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        if (!beginDate.after(cal.getTime()) && !endDate.before(cal.getTime())) {

            return d.getDiscount();
        }
        return 0;
    }
    
    
}
