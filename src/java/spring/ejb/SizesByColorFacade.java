/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import spring.entity.SizesByColor;

/**
 *
 * @author tuan
 */
@Stateless
public class SizesByColorFacade extends AbstractFacade<SizesByColor> implements SizesByColorFacadeLocal {

    @PersistenceContext(unitName = "ShoeGardenPJPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public SizesByColorFacade() {
        super(SizesByColor.class);
    }
    
}
