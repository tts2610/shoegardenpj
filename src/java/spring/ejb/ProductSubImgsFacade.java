/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import spring.entity.ProductSubImgs;

/**
 *
 * @author tuan
 */
@Stateless
public class ProductSubImgsFacade extends AbstractFacade<ProductSubImgs> implements ProductSubImgsFacadeLocal {

    @PersistenceContext(unitName = "ShoeGardenPJPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public ProductSubImgsFacade() {
        super(ProductSubImgs.class);
    }
    
}
