/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import java.util.List;
import java.util.Objects;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import spring.entity.Brands;
import spring.entity.Categories;
import spring.entity.Products;

/**
 *
 * @author tuan
 */
@Stateless
public class CategoriesFacade extends AbstractFacade<Categories> implements CategoriesFacadeLocal {

    @PersistenceContext(unitName = "ShoeGardenPJPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public CategoriesFacade() {
        super(Categories.class);
    }

    @Override
    public int createOR(Categories categories) {
        int errorCode;

        Query q = getEntityManager().createQuery("SELECT sc FROM Categories sc WHERE sc.braID.braID = :cateID AND sc.catName LIKE :newSubCateName", Categories.class);
        q.setParameter("cateID", categories.getBraID().getBraID());
        q.setParameter("newSubCateName", categories.getCatName());

        int count = q.getResultList().size();
        if (count == 1) { //=> đã có SubCategory trong Category đó rồi.
            errorCode = 2;
        } else {//=> Chưa có SubCategory trong Category đó.
            try {
                create(categories);
                getEntityManager().find(Brands.class, categories.getBraID().getBraID()).getCategoriesList().add(categories);
                
                errorCode = 1;
            } catch (Exception e) {
                errorCode = 0;
            }
        }
        return errorCode;
    }

    @Override
    public int editOR(Categories categories) {
        int errorCode;
        Categories oldSubCate = getEntityManager().find(Categories.class, categories.getCatID());

        Query q = getEntityManager().createQuery("SELECT sc FROM Categories sc WHERE sc.braID.braID = :cateID AND sc.catName LIKE :targetSubCateName", Categories.class);
        q.setParameter("cateID", categories.getBraID().getBraID());
        q.setParameter("targetSubCateName", categories.getCatName());
        int count = q.getResultList().size();
        if (count == 1) { //=> trùng
            if ((Objects.equals(oldSubCate.getBraID().getBraID(), categories.getBraID().getBraID())) && oldSubCate.getCatName().equalsIgnoreCase(categories.getCatName())) {
                try {
                    List<Products> oldPrdList = oldSubCate.getProductsList();
                    categories.getProductsList().addAll(oldPrdList);
                    getEntityManager().find(Brands.class,oldSubCate.getBraID().getBraID()).getCategoriesList().remove(oldSubCate);
                    getEntityManager().find(Brands.class,categories.getBraID().getBraID()).getCategoriesList().add(categories);

                    edit(categories);
                    categories.getProductsList().addAll(oldPrdList);
                    List<Products> prdList = categories.getProductsList();
                    for (Products p : prdList) {
                        p.setBraID(categories.getBraID());
                        getEntityManager().merge(p);
                    }

                    errorCode = 1; //Update thành công.
                } catch (Exception e) {
                    e.printStackTrace();
                    errorCode = 0; //Update bị lỗi.
                }
            } else {
                errorCode = 2; //bị trùng
            }
        } else { //=> ko bị trùng
            try {
                List<Products> oldPrdList = oldSubCate.getProductsList();

                getEntityManager().find(Brands.class,oldSubCate.getBraID().getBraID()).getCategoriesList().remove(oldSubCate);
                getEntityManager().find(Brands.class,categories.getBraID().getBraID()).getCategoriesList().add(categories);

                getEntityManager().merge(categories);
                categories.getProductsList().addAll(oldPrdList);
                List<Products> prdList = categories.getProductsList();
                for (Products p : prdList) {
                    p.setBraID(categories.getBraID());
                    getEntityManager().merge(p);
                }
                errorCode = 1; //Update thành công.
            } catch (Exception e) {
                e.printStackTrace();
                errorCode = 0; //Update bị lỗi.
            }
        }
        return errorCode;
    }

    @Override
    public boolean removeOR(int categories) {
        Categories subCate = find(categories);

        if (subCate != null) {
            getEntityManager().find(Brands.class, subCate.getBraID().getBraID()).getCategoriesList().remove(subCate);
            getEntityManager().remove(subCate);
            return true;
        } else {
            return false;
        }
    }
    
}
