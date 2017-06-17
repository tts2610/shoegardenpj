/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.entity;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;
import org.springframework.format.annotation.DateTimeFormat;
import spring.ejb.DiscountDetailsFacadeLocal;

/**
 *
 * @author tuan
 */
@Entity
@Table(name = "products")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Products.findAll", query = "SELECT p FROM Products p")
    , @NamedQuery(name = "Products.findByProductID", query = "SELECT p FROM Products p WHERE p.productID = :productID")
    , @NamedQuery(name = "Products.findByProductName", query = "SELECT p FROM Products p WHERE p.productName = :productName")
    , @NamedQuery(name = "Products.findByPrice", query = "SELECT p FROM Products p WHERE p.price = :price")
    , @NamedQuery(name = "Products.findByUrlImg", query = "SELECT p FROM Products p WHERE p.urlImg = :urlImg")
    , @NamedQuery(name = "Products.findByPostedDate", query = "SELECT p FROM Products p WHERE p.postedDate = :postedDate")
    , @NamedQuery(name = "Products.findByProductViews", query = "SELECT p FROM Products p WHERE p.productViews = :productViews")
    , @NamedQuery(name = "Products.findByStatus", query = "SELECT p FROM Products p WHERE p.status = :status")})
public class Products implements Serializable {

    

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "productID")
    private Integer productID;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "productName")
    private String productName;
    @Basic(optional = false)
    @NotNull
    @Column(name = "price")
    private double price;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "urlImg")
    private String urlImg;
    @Lob
    @Size(max = 2147483647)
    @Column(name = "productDes")
    private String productDes;
    @DateTimeFormat(pattern = "dd/MM/yyyy")
    @Temporal(TemporalType.DATE)
    @Column(name = "postedDate")
    private Date postedDate;
    @Column(name = "productViews")
    private Integer productViews;
    @Column(name = "status")
    private Short status;
    @OneToMany(mappedBy = "productID")
    private List<Comments> commentsList;
    @OneToMany(mappedBy = "productID",cascade = CascadeType.PERSIST)
    private List<ProductColors> productColorsList;
    @OneToMany(mappedBy = "productID")
    private List<Rating> ratingList;
    @JoinColumn(name = "braID", referencedColumnName = "braID")
    @ManyToOne
    private Brands braID;
    @JoinColumn(name = "catID", referencedColumnName = "catID")
    @ManyToOne
    private Categories catID;
    @OneToMany(mappedBy = "productID")
    private List<DiscountDetails> discountDetailsList;
    @OneToMany(mappedBy = "productID")
    private List<OrdersDetail> ordersDetailList;

    public List<DiscountDetails> getDiscountDetailsList() {
        return discountDetailsList;
    }

    public void setDiscountDetailsList(List<DiscountDetails> discountDetailsList) {
        this.discountDetailsList = discountDetailsList;
    }

    
    
    
    
    
    
    public Products() {
    }

    public Products(Integer productID) {
        this.productID = productID;
    }

    public Products(Integer productID, String productName, double price, String urlImg) {
        this.productID = productID;
        this.productName = productName;
        this.price = price;
        this.urlImg = urlImg;
    }

    public Integer getProductID() {
        return productID;
    }

    public void setProductID(Integer productID) {
        this.productID = productID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getUrlImg() {
        return urlImg;
    }

    public void setUrlImg(String urlImg) {
        this.urlImg = urlImg;
    }

    public String getProductDes() {
        return productDes;
    }

    public void setProductDes(String productDes) {
        this.productDes = productDes;
    }

    public Date getPostedDate() {
        return postedDate;
    }

    public void setPostedDate(Date postedDate) {
        this.postedDate = postedDate;
    }

    public Integer getProductViews() {
        return productViews;
    }

    public void setProductViews(Integer productViews) {
        this.productViews = productViews;
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

    @XmlTransient
    public List<Comments> getCommentsList() {
        return commentsList;
    }

    public void setCommentsList(List<Comments> commentsList) {
        this.commentsList = commentsList;
    }

    @XmlTransient
    public List<ProductColors> getProductColorsList() {
        return productColorsList;
    }

    public void setProductColorsList(List<ProductColors> productColorsList) {
        this.productColorsList = productColorsList;
    }
    
     public List<ProductColors> getProductColorListWorking(){
        List<ProductColors> productRatingWorking = new ArrayList<>();
        for (ProductColors p : productColorsList) {
            if(p.getStatus() == 1){
                productRatingWorking.add(p);
            }
        }
//        Collections.sort(productRatingWorking, new Comparator<ProductColors>(){
//            @Override
//            public int compare(ProductColors p1, ProductColors p2) {
//                return p1.getColorOrder() - p2.getColorOrder();
//            }            
//        });
        return productRatingWorking;
    }
     
//    public float getProductDiscount(){
//        for(DiscountDetails d : discountDetailsList){
//            if(Objects.equals(d.getProductID().productID, this.productID)){
//                return d.getDiscount();
//            }
//        }
//        return 0;
//    }

    @XmlTransient
    public List<Rating> getRatingList() {
        return ratingList;
    }

    public void setRatingList(List<Rating> ratingList) {
        this.ratingList = ratingList;
    }

    public Brands getBraID() {
        return braID;
    }

    public void setBraID(Brands braID) {
        this.braID = braID;
    }

    public Categories getCatID() {
        return catID;
    }

    public void setCatID(Categories catID) {
        this.catID = catID;
    }

//    @XmlTransient
//    public List<DiscountDetails> getDiscountDetailsList() {
//        return discountDetailsList;
//    }
//
//    public void setDiscountDetailsList(List<DiscountDetails> discountDetailsList) {
//        this.discountDetailsList = discountDetailsList;
//    }

    @XmlTransient
    public List<OrdersDetail> getOrdersDetailList() {
        return ordersDetailList;
    }

    public void setOrdersDetailList(List<OrdersDetail> ordersDetailList) {
        this.ordersDetailList = ordersDetailList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (productID != null ? productID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Products)) {
            return false;
        }
        Products other = (Products) object;
        if ((this.productID == null && other.productID != null) || (this.productID != null && !this.productID.equals(other.productID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "spring.entity.Products[ productID=" + productID + " ]";
    }
    
//    public float getProductDiscountPrice(){
//        return (float) (price * getProductDiscount()/100);
//    }

    
    
}
