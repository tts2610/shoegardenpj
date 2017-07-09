/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import java.util.List;
import javax.ejb.Local;
import spring.entity.Brands;
import spring.entity.Categories;
import spring.entity.ProductColors;
import spring.entity.ProductSubImgs;
import spring.entity.Products;
import spring.entity.Rating;
import spring.entity.SizesByColor;

/**
 *
 * @author tuan
 */
@Local
public interface ProductsFacadeLocal {

    List<Products> productList(String role);

    Products findProductByID(int productID);

    List<Object[]> getTop3ProductBestSeller();

    List<Products> getTop3ProductMostViewed();
    
    List<Object[]> getProductTop3Rated();

    ProductColors findProductColorByColorID(int colorID);

    boolean checkDuplicateProductName(String name);

    boolean createNewProduct(Products newProduct);

    void updateProductStatus(int productID, short productStatus);

    Double getMaxPriceOfProduct_ByCate(int cateID);

    Double getMinPriceOfProduct_ByCate(int cateID);
    
    List<Object[]> productsByFilter_OfDiscount(double fromPrice, double toPrice, String filterColor, String filterSize);

    List<Object[]> productsByFilter_OfACategory(int cateID, double fromPrice, double toPrice, String filterColor, String filterSize);

    List<Object[]> filterProductByCategory(int cateID, int page, int itemPerPage, double fromPrice, double toPrice, String filterColor, String filterSize, int sortBy);

    List<Object[]> filterProductByDiscount(int page, int itemPerPage,
            double fromPrice, double toPrice,
            String filterColor, String filterSize, int sortBy);
    
    Double getMaxPriceOfProduct_BySubCate(int subCateID);

    Double getMinPriceOfProduct_BySubCate(int subCateID);

    List<Object[]> filterProductBySubCategory(int subCateID, int page, int itemPerPage, double fromPrice, double toPrice, String filterColor, String filterSize, int sortBy);

    List<Object[]> productsByFilter_OfASubCategory(int subCateID, double fromPrice, double toPrice, String filterColor, String filterSize);

    boolean updateProductGeneralInfo(Products targetProduct);

    boolean updateProductColorStatus(int colorID, short newStt);

    ProductColors getProductColorByID(int colorID);

    boolean updateProductColor(ProductColors targetColor);

    ProductSubImgs getProductSubImgByID(int subImgID);

    boolean updateProductSubImg(ProductSubImgs targetSubImg);

    int deleteProductSubImg(int targetSubImgID);

    SizesByColor getSizeByID(int sizeID);

    boolean updateSize(SizesByColor targetSize);

    int deleteProductSize(int sizeID);

    boolean createNewProductRating(int productID, Rating newProductRating);
    
    List<ProductColors> getProductColorsListOfAProductByName (int productID, String color);
    
    boolean createNewProductColor(ProductColors newProductColors);
    
    boolean addProductSubImage(ProductSubImgs newSubImg);
    
    boolean addSize(SizesByColor newSize);
    
    List<Products> getSearchedProducts(String prodName);
    
    List<Products> getProductWorkingList(String role);
    
    List<Products> selectTop8Product();
    
}
