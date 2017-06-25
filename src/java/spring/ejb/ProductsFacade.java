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
import spring.entity.ProductColors;
import spring.entity.ProductSubImgs;
import spring.entity.Products;
import spring.entity.Rating;
import spring.entity.SizesByColor;

/**
 *
 * @author tuan
 */
@Stateless
public class ProductsFacade extends AbstractFacade<Products> implements ProductsFacadeLocal {

    @PersistenceContext(unitName = "ShoeGardenPJPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public ProductsFacade() {
        super(Products.class);
    }

    @Override
    public List<Products> productList(String role) {
        Query q;
        if (role.equals("client")) {
            q = getEntityManager().createQuery("SELECT p FROM Products p WHERE p.status = 1 ORDER BY p.productID DESC", Products.class);
        } else {
            q = getEntityManager().createQuery("SELECT p FROM Products p ORDER BY p.productID DESC", Products.class);
        }

        return q.getResultList();
    }

    @Override
    public Products findProductByID(int productID) {
        return getEntityManager().find(Products.class, productID);
    }

    @Override
    public List<Object[]> getTop3ProductBestSeller() {
        String sql = "SELECT p.productID, p.productName, p.price, p.urlImg, c.colorID, sum(od.quantity) as tongsoluong "
                + "FROM OrdersDetail od JOIN Products p JOIN p.productColorsList c "
                + "WHERE p.status = 1 AND c.status = 1 "
                + "GROUP BY p.productID, p.productName, p.price, p.urlImg, c.colorID "
                + "ORDER BY tongsoluong DESC";
        Query q = getEntityManager().createQuery(sql,Products.class).setMaxResults(3);

        return q.getResultList();
    }

    @Override
    public List<Products> getTop3ProductMostViewed() {
        String sql = "SELECT p FROM Products p WHERE p.status = 1 ORDER BY p.productViews DESC";
        Query q = getEntityManager().createQuery(sql, Products.class).setMaxResults(3);

        return q.getResultList();
    }
    
    @Override
    public List<Object[]> getProductTop3Rated(){
        String sql = "  SELECT "
                + "r.productID, "
                + "ROUND(AVG(CAST(r.rating AS FLOAT)), 1) as avrage, "
                + "COUNT(r.productID) as numberOfRate "
                + "FROM Rating r "
                + "GROUP BY r.productID "
                + "ORDER BY numberOfRate DESC, avrage DESC";
        Query q = getEntityManager().createNativeQuery(sql);
        q.setFirstResult(0);
        q.setMaxResults(3);
        return q.getResultList();
    }
    
    @Override
    public ProductColors findProductColorByColorID(int colorID) {
        ProductColors productColor = getEntityManager().find(ProductColors.class, colorID);
        return productColor;
    }

    @Override
    public boolean checkDuplicateProductName(String name) {
        String sql = "SELECT p FROM Products p WHERE p.productName LIKE :productName";
        Query q = getEntityManager().createQuery(sql, Products.class);
        q.setParameter("productName", name);

        int count = q.getResultList().size();
        return count == 1;
    }

    @Override
    public boolean createNewProduct(Products newProduct) {
        try {
            getEntityManager().persist(newProduct);
//            find(newProduct.getCatID().getCatID()).getPr().add(newProduct);
            getEntityManager().flush();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean createNewProductColor(ProductColors newProductColors) {
        try {
            getEntityManager().persist(newProductColors);
//            findProductByID(newProductColors.getProduct().getProductID()).getProductColorList().add(newProductColors);
            getEntityManager().flush();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public void updateProductStatus(int productID, short productStatus) {
        Products targetProduct = findProductByID(productID);

        targetProduct.setStatus(productStatus);
        getEntityManager().merge(targetProduct);
    }

    @Override
    public Double getMaxPriceOfProduct_ByCate(int cateID) {
        String sql = "SELECT MAX(p.price) FROM Products p WHERE p.braID.braID = :cateID";
        Query q = getEntityManager().createQuery(sql, Products.class);
        q.setParameter("cateID", cateID);
        Double price = (Double) q.getResultList().get(0);
        return price;
    }

    @Override
    public Double getMinPriceOfProduct_ByCate(int cateID) {
        String sql = "SELECT MIN(p.price) FROM Products p WHERE p.braID.braID = :cateID";
        Query q = getEntityManager().createQuery(sql, Products.class);
        q.setParameter("cateID", cateID);
        Double price = (Double) q.getResultList().get(0);
        return price;
    }

    @Override
    public List<Object[]> productsByFilter_OfACategory(int cateID, double fromPrice, double toPrice, String filterColor, String filterSize) {
        
        Query q = null;
        try{
            String sql = "SELECT DISTINCT"
                + "         p.productID, p.price\n"
                + "FROM Products p\n"
                + "JOIN p.productColorsList pc\n"
                + "JOIN pc.sizesByColorList ps\n"
                + "WHERE p.braID.braID = :cateID "
                + "AND (p.price BETWEEN :fromPrice AND :toPrice) "
                + filterColor
                + filterSize
                + "AND p.status = 1";
        q = getEntityManager().createQuery(sql, Products.class);
        q.setParameter("cateID", cateID);
        q.setParameter("fromPrice", fromPrice);
        q.setParameter("toPrice", toPrice);
        
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        return q.getResultList();

        
    }

    @Override
    public List<Object[]> filterProductByCategory(int cateID, int page, int itemPerPage,
            double fromPrice, double toPrice,
            String filterColor, String filterSize, int sortBy) {
        String sql;
        if (sortBy == 1) {//1: Newest; 2: Low to High Price; 3: High to Low Price
            sql = "SELECT DISTINCT"
                    + "         p.productID, p.price\n"
                    + "FROM Products p\n"
                    + "JOIN p.productColorsList pc\n"
                    + "JOIN pc.sizesByColorList ps\n"
                    + "WHERE p.braID.braID = :cateID "
                    + "AND (p.price BETWEEN :fromPrice AND :toPrice) "
                    + filterColor
                    + filterSize
                    + "AND p.status = 1 ORDER BY p.productID DESC";
            
        } else if (sortBy == 2) {
            sql = "SELECT DISTINCT"
                    + "         p.productID, p.price\n"
                    + "FROM Products p\n"
                    + "JOIN p.productColorsList pc\n"
                    + "JOIN pc.sizesByColorList ps\n"
                    + "WHERE p.braID.braID = :cateID "
                    + "AND (p.price BETWEEN :fromPrice AND :toPrice) "
                    + filterColor
                    + filterSize
                    + "AND p.status = 1 ORDER BY p.price ASC";
        } else {
            sql = "SELECT DISTINCT"
                    + "         p.productID, p.price\n"
                    + "FROM Products p\n"
                    + "JOIN p.productColorsList pc\n"
                    + "JOIN pc.sizesByColorList ps\n"
                    + "WHERE p.braID.braID = :cateID "
                    + "AND (p.price BETWEEN :fromPrice AND :toPrice) "
                    + filterColor
                    + filterSize
                    + "AND p.status = 1 ORDER BY p.price DESC";
        }
        int firstResult = (page - 1) * itemPerPage;
        Query q = getEntityManager().createQuery(sql,Products.class);
        q.setParameter("cateID", cateID);
        q.setParameter("fromPrice", fromPrice);
        q.setParameter("toPrice", toPrice);
        q.setFirstResult(firstResult);
        q.setMaxResults(itemPerPage);
        
        return q.getResultList();
    }

    @Override
    public Double getMaxPriceOfProduct_BySubCate(int subCateID) {
        String sql = "SELECT MAX(p.price) FROM Products p WHERE p.catID.catID = :subCateID";
        Query q = getEntityManager().createQuery(sql, Products.class);
        q.setParameter("subCateID", subCateID);
        Double price = (Double) q.getResultList().get(0);
        return price;
    }

    @Override
    public Double getMinPriceOfProduct_BySubCate(int subCateID) {
        String sql = "SELECT MIN(p.price) FROM Products p WHERE p.catID.catID = :subCateID";
        Query q = getEntityManager().createQuery(sql, Products.class);
        q.setParameter("subCateID", subCateID);
        Double price = (Double) q.getResultList().get(0);
        return price;
    }

    @Override
    public List<Object[]> filterProductBySubCategory(int subCateID, int page, int itemPerPage,
            double fromPrice, double toPrice,
            String filterColor, String filterSize, int sortBy) {
        String sql;
        if (sortBy == 1) {//1: Newest; 2: Low to High Price; 3: High to Low Price
            sql = "SELECT DISTINCT"
                    + "         p.productID, p.price\n"
                    + "FROM Products p\n"
                    + "JOIN p.productColorsList pc\n"
                    + "JOIN pc.sizesByColorList ps\n"
                    + "WHERE p.catID.catID = :subCateID "
                    + "AND (p.price BETWEEN :fromPrice AND :toPrice) "
                    + filterColor
                    + filterSize
                    + "AND p.status = 1 ORDER BY p.productID DESC";
        } else if (sortBy == 2) {
            sql = "SELECT DISTINCT"
                    + "         p.productID, p.price\n"
                    + "FROM Products p\n"
                    + "JOIN p.productColorsList pc\n"
                    + "JOIN pc.sizesByColorList ps\n"
                    + "WHERE p.catID.catID = :subCateID "
                    + "AND (p.price BETWEEN :fromPrice AND :toPrice) "
                    + filterColor
                    + filterSize
                    + "AND p.status = 1 ORDER BY p.price ASC";
        } else {
            sql = "SELECT DISTINCT"
                    + "         p.productID, p.price\n"
                    + "FROM Products p\n"
                    + "JOIN p.productColorsList pc\n"
                    + "JOIN pc.sizesByColorList ps\n"
                    + "WHERE p.catID.catID = :subCateID "
                    + "AND (p.price BETWEEN :fromPrice AND :toPrice) "
                    + filterColor
                    + filterSize
                    + "AND p.status = 1 ORDER BY p.price DESC";
        }
        int firstResult = (page - 1) * itemPerPage;
        Query q = getEntityManager().createQuery(sql);
        q.setParameter("subCateID", subCateID);
        q.setParameter("fromPrice", fromPrice);
        q.setParameter("toPrice", toPrice);
        q.setFirstResult(firstResult);
        q.setMaxResults(itemPerPage);
        return q.getResultList();
    }

    @Override
    public List<Object[]> productsByFilter_OfASubCategory(int subCateID, double fromPrice, double toPrice, String filterColor, String filterSize) {
        String sql = "SELECT DISTINCT"
                + "         p.productID, p.price\n"
                + "FROM Products p\n"
                + "JOIN p.productColorsList pc\n"
                + "JOIN pc.sizesByColorList ps\n"
                + "WHERE p.catID.catID = :subCateID "
                + "AND (p.price BETWEEN :fromPrice AND :toPrice) "
                + filterColor
                + filterSize
                + "AND p.status = 1";
        Query q = getEntityManager().createQuery(sql, Products.class);
        q.setParameter("subCateID", subCateID);
        q.setParameter("fromPrice", fromPrice);
        q.setParameter("toPrice", toPrice);

        return q.getResultList();
    }

    @Override
    public boolean updateProductGeneralInfo(Products targetProduct) {
        try {
            getEntityManager().merge(targetProduct);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public boolean updateProductColorStatus(int colorID, short newStt) {
        ProductColors targetColor = findProductColorByColorID(colorID);

        targetColor.setStatus(newStt);

        try {
            getEntityManager().merge(targetColor);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public ProductColors getProductColorByID(int colorID) {
        return getEntityManager().find(ProductColors.class, colorID);
    }

    @Override
    public boolean updateProductColor(ProductColors targetColor) {
        try {
            getEntityManager().merge(targetColor);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public ProductSubImgs getProductSubImgByID(int subImgID) {
        return getEntityManager().find(ProductSubImgs.class, subImgID);
    }

    @Override
    public boolean updateProductSubImg(ProductSubImgs targetSubImg) {
        try {
            getEntityManager().merge(targetSubImg);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public int deleteProductSubImg(int targetSubImgID) {
        try {
            ProductSubImgs targetSubImg = getEntityManager().find(ProductSubImgs.class, targetSubImgID);
            if (targetSubImg != null) {
                ProductColors parentColor = targetSubImg.getColorID();
                parentColor.getProductSubImgsList().remove(targetSubImg);
                getEntityManager().remove(targetSubImg);
                getEntityManager().flush();
                return 0;
            }
            return 1;
        } catch (Exception e) {
            e.printStackTrace();
            return 2;
        }
    }

    @Override
    public SizesByColor getSizeByID(int sizeID) {
        return getEntityManager().find(SizesByColor.class, sizeID);
    }

    @Override
    public boolean updateSize(SizesByColor targetSize) {
        try {
            getEntityManager().merge(targetSize);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public int deleteProductSize(int sizeID) {
        try {
            SizesByColor targetSize = getEntityManager().find(SizesByColor.class, sizeID);
            if (targetSize != null) {
                ProductColors parentColor = targetSize.getColorID();
                parentColor.getSizesByColorList().remove(targetSize);
                getEntityManager().remove(targetSize);
                getEntityManager().flush();
                return 0;
            }
            return 1; //Không tìm thấy size
        } catch (Exception e) {
            e.printStackTrace();
            return 2; //Loi trong khi xóa
        }
    }

    @Override
    public boolean createNewProductRating(int productID, Rating newProductRating) {
        Products targetProduct = findProductByID(productID);
        targetProduct.getRatingList().add(newProductRating);
        try {
            getEntityManager().persist(newProductRating);
            getEntityManager().merge(newProductRating);
            getEntityManager().flush();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public List<ProductColors> getProductColorsListOfAProductByName (int productID, String color){
        String sql = "SELECT c FROM ProductColors c WHERE c.productID.productID = :productID AND c.color LIKE :color";
        Query q = getEntityManager().createQuery(sql, ProductColors.class);
        q.setParameter("productID", productID);
        q.setParameter("color", color);
        
        return q.getResultList();
    }
    
    /* Returning Visitor */
//    @Override
//    public List<ReturningVisitor> getReturningVisitorList() {
//        String sql = "SELECT v FROM ReturningVisitor v";
//        Query q = getEntityManager().createQuery(sql, ReturningVisitor.class);
//
//        return q.getResultList();
//    }
//
//    @Override
//    public List<Object[]> getVisitTimesByMonthAndWeek(int month, String weekCondition) {
//        String sql = "SELECT r.onDate, sum(r.visitTimes) AS visits "
//                + "FROM ReturningVisitor r "
//                + "WHERE MONTH(r.onDate) = ? "
//                + weekCondition
//                + "GROUP BY r.onDate";
//        Query q = getEntityManager().createNativeQuery(sql);
//        q.setParameter(1, month);
//        return q.getResultList();
//    }
//
//    @Override
//    public void createNewVisitor(ReturningVisitor newVisitor) {
//        getEntityManager().persist(newVisitor);
//    }
//
//    @Override
//    public ReturningVisitor getReturningVisitorByIDAndDate(String visitorID, Date date) {
//        try {
//            String sql = "SELECT r FROM ReturningVisitor r "
//                    + "WHERE r.visitorID = :visitorID "
//                    + "AND r.onDate = :date";
//            Query q = getEntityManager().createQuery(sql, ReturningVisitor.class);
//            q.setParameter("visitorID", visitorID);
//            q.setParameter("date", date);
//            return (ReturningVisitor) q.getSingleResult();
//        } catch (Exception e) {
//            return null;
//        }
//    }
//    
//    @Override
//    public void updateVisitTimes (ReturningVisitor visitor){
//        if(getEntityManager().find(ReturningVisitor.class, visitor.getReVisitID())!= null){
//            getEntityManager().merge(visitor);
//        }
//    }

    @Override
    public boolean addProductSubImage(ProductSubImgs newSubImg) {
        try {
            getEntityManager().find(ProductColors.class, newSubImg.getColorID().getColorID()).getProductSubImgsList().add(newSubImg);
            getEntityManager().persist(newSubImg);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean addSize(SizesByColor newSize) {
        try {
            findProductColorByColorID(newSize.getColorID().getColorID()).getSizesByColorList().add(newSize);
            getEntityManager().persist(newSize);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
            
        }
    }

    @Override
    public List<Products> getSearchedProducts(String prodName) {
        String sql = "SELECT p FROM Products p WHERE p.productName LIKE :keyword AND p.status = 1";
        Query q = getEntityManager().createQuery(sql, Products.class);
        q.setParameter("keyword", "%"+prodName+"%");
        q.setFirstResult(0);
        q.setMaxResults(6);
        return q.getResultList();
    }

    @Override
    public List<Products> getProductWorkingList(String role) {
        Query q;
        
            q = getEntityManager().createQuery("SELECT p FROM Products p where p.status = 1 ORDER BY p.productID DESC", Products.class);
        

        return q.getResultList();
    }

    @Override
    public List<Products> selectTop8Product() {
        Query q = getEntityManager().createNativeQuery("SELECT TOP 8 * FROM PRODUCTS",Products.class);
        return q.getResultList();
    }

    
    
}
