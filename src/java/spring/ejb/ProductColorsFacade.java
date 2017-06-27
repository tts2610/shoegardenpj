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
import spring.entity.ProductColors;

/**
 *
 * @author tuan
 */
@Stateless
public class ProductColorsFacade extends AbstractFacade<ProductColors> implements ProductColorsFacadeLocal {

    @PersistenceContext(unitName = "ShoeGardenPJPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public ProductColorsFacade() {
        super(ProductColors.class);
    }
    
    public ProductColors findTop1ByColorName(String name){
        Query q = getEntityManager().createNativeQuery("SELECT TOP 1 * FROM productColors p where p.color = '"+name+"'",ProductColors.class);
        return (ProductColors) q.getSingleResult();
    }
    
}
