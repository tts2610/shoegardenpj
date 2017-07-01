/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.PostPersist;
import javax.persistence.Query;
import spring.entity.Discounts;
import spring.entity.Products;

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
        em.flush();
        em.refresh(entity);
    }
    
    public List<Discounts> selectTop3Discount(){
        
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate localDate = LocalDate.now();
        String date = dtf.format(localDate);
        System.err.println(date);
        Query q = getEntityManager().createNativeQuery("SELECT TOP 3 * FROM discounts d where d.dateBegin<= '"+date+"' AND d.dateEnd>='"+date+"'",Discounts.class);
        return q.getResultList();
    }
    
}
