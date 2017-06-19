/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author tuan
 */
@Entity
@Table(name = "ordersDetail")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "OrdersDetail.findAll", query = "SELECT o FROM OrdersDetail o")
    , @NamedQuery(name = "OrdersDetail.findByOrdersDetailID", query = "SELECT o FROM OrdersDetail o WHERE o.ordersDetailID = :ordersDetailID")
    , @NamedQuery(name = "OrdersDetail.findByProductDiscount", query = "SELECT o FROM OrdersDetail o WHERE o.productDiscount = :productDiscount")
    , @NamedQuery(name = "OrdersDetail.findByQuantity", query = "SELECT o FROM OrdersDetail o WHERE o.quantity = :quantity")
    , @NamedQuery(name = "OrdersDetail.findByPrice", query = "SELECT o FROM OrdersDetail o WHERE o.price = :price")
    , @NamedQuery(name = "OrdersDetail.findByStatus", query = "SELECT o FROM OrdersDetail o WHERE o.status = :status")})
public class OrdersDetail implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ordersDetailID")
    private Integer ordersDetailID;
    @Basic(optional = false)
    @NotNull
    @Column(name = "productDiscount")
    private short productDiscount;
    @Basic(optional = false)
    @NotNull
    @Column(name = "quantity")
    private int quantity;
    @Basic(optional = false)
    @NotNull
    @Column(name = "price")
    private double price;
    @Column(name = "status")
    private Short status;
    @JoinColumn(name = "ordersID", referencedColumnName = "ordersID")
    @ManyToOne
    @JsonBackReference
    private Orders ordersID;
    @JoinColumn(name = "productID", referencedColumnName = "productID")
    @ManyToOne
    @JsonBackReference
    private Products productID;
    @JoinColumn(name = "sizeID", referencedColumnName = "sizeID")
    @ManyToOne
    @JsonBackReference
    private SizesByColor sizeID;

    public OrdersDetail() {
    }

    public OrdersDetail(Integer ordersDetailID) {
        this.ordersDetailID = ordersDetailID;
    }

    public OrdersDetail(Integer ordersDetailID, short productDiscount, int quantity, double price) {
        this.ordersDetailID = ordersDetailID;
        this.productDiscount = productDiscount;
        this.quantity = quantity;
        this.price = price;
    }

    public Integer getOrdersDetailID() {
        return ordersDetailID;
    }

    public void setOrdersDetailID(Integer ordersDetailID) {
        this.ordersDetailID = ordersDetailID;
    }

    public short getProductDiscount() {
        return productDiscount;
    }

    public void setProductDiscount(short productDiscount) {
        this.productDiscount = productDiscount;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

    public Orders getOrdersID() {
        return ordersID;
    }

    public void setOrdersID(Orders ordersID) {
        this.ordersID = ordersID;
    }

    public Products getProductID() {
        return productID;
    }

    public void setProductID(Products productID) {
        this.productID = productID;
    }

    public SizesByColor getSizeID() {
        return sizeID;
    }

    public void setSizeID(SizesByColor sizeID) {
        this.sizeID = sizeID;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (ordersDetailID != null ? ordersDetailID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof OrdersDetail)) {
            return false;
        }
        OrdersDetail other = (OrdersDetail) object;
        if ((this.ordersDetailID == null && other.ordersDetailID != null) || (this.ordersDetailID != null && !this.ordersDetailID.equals(other.ordersDetailID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "spring.entity.OrdersDetail[ ordersDetailID=" + ordersDetailID + " ]";
    }
    
    
//    public float getTotalPrice() {
//        return (float) (price*quantity);
//    }
//    
//    public float getSubTotal(){
//        return (getTotalPrice()-productID.getProductDiscountPrice());
//    }
    
    public float getSubTotal(){
        return (float) ((1-(float)getProductDiscount()/100)*getPrice()*getQuantity());
    }
    
}
