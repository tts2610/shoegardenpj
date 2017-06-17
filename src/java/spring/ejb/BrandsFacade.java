/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import spring.entity.Brands;

/**
 *
 * @author tuan
 */
@Stateless
public class BrandsFacade extends AbstractFacade<Brands>implements BrandsFacadeLocal {

    @PersistenceContext(unitName = "ShoeGardenPJPU")
    private EntityManager em;

    
    protected EntityManager getEntityManager() {
        return em;
    }

    public BrandsFacade() {
        super(Brands.class);
    }

    @Override
    public Brands findBrandsByName(String braName) {
        try {
            Query q = getEntityManager().createQuery("SELECT c FROM Brands c WHERE c.braName LIKE :cateName", Brands.class);
            q.setParameter("cateName", braName);
            return (Brands) q.getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public List<Brands> findBrandsLikeName(String braName) {
        Query q = getEntityManager().createQuery("SELECT c FROM Brands c WHERE c.braName LIKE :cateName", Brands.class);
        q.setParameter("cateName", braName);
        return q.getResultList();
    }

    @Override
    public int createOR(Brands brands) {
        int errorCode;
        
        //Kiểm tra trùng tên
        Brands existedCate = findBrandsByName(brands.getBraName());
        if (existedCate != null) {
            errorCode = 2;  //Tên đã bị TRÙNG
        } else {
            //Insert mới
            try {
                create(brands);
                errorCode = 1;  //Insert thành công 1 dòng
            } catch (Exception e) {
                e.printStackTrace();
                errorCode = 0;  //Lỗi khi insert, 0 có dòng nào được insert
            }
        }
        return errorCode;
    }

    @Override
    public int editOR(Brands brands) {
        int errorCode; // = 1; => update thành công, = 0; => update bị lỗi, = 2 => update trùng với tên trước đó.
        
        Brands oldBra = find(brands.getBraID());
        Brands cate = findBrandsByName(brands.getBraName());
        if (oldBra.getBraName().equalsIgnoreCase(brands.getBraName())) {
            try {
                getEntityManager().merge(brands);
                errorCode = 1;
            } catch (Exception e) {
                errorCode = 0;
            }
        } else {
            if (cate != null) {
                errorCode = 2;
            } else {
                try {
                    getEntityManager().merge(brands);
                    errorCode = 1;
                } catch (Exception e) {
                    errorCode = 0;
                }
            }

        }
        return errorCode;
    }

    @Override
    public boolean removeOR(int braID) {
        Brands bra = find(braID);
        if (bra != null) {
            getEntityManager().remove(bra);
            return true;
        } else {
            return false;
        }
    }

    
    
}
