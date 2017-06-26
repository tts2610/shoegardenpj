/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Cacheable;
import javax.persistence.CascadeType;
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
@Cacheable(false)
@Table(name = "discountDetails")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "DiscountDetails.findAll", query = "SELECT d FROM DiscountDetails d")
    , @NamedQuery(name = "DiscountDetails.findByDiscDetailID", query = "SELECT d FROM DiscountDetails d WHERE d.discDetailID = :discDetailID")})
public class DiscountDetails implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "discDetailID")
    private Integer discDetailID;
    @JoinColumn(name = "discID", referencedColumnName = "discID")
    @ManyToOne
    @JsonManagedReference
    private Discounts discID;
    @JoinColumn(name = "productID", referencedColumnName = "productID")
    @ManyToOne
    @JsonBackReference
    private Products productID;

    
    
    public DiscountDetails() {
    }

    public DiscountDetails(Discounts discID, Products productID) {
        this.discID = discID;
        this.productID = productID;
    }

    
    
    public Products getProductID() {
        return productID;
    }

    public void setProductID(Products productID) {
        this.productID = productID;
    }
    
    public DiscountDetails(Integer discDetailID) {
        this.discDetailID = discDetailID;
    }

    public Integer getDiscDetailID() {
        return discDetailID;
    }

    public void setDiscDetailID(Integer discDetailID) {
        this.discDetailID = discDetailID;
    }

    public Discounts getDiscID() {
        return discID;
    }

    public void setDiscID(Discounts discID) {
        this.discID = discID;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (discDetailID != null ? discDetailID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof DiscountDetails)) {
            return false;
        }
        DiscountDetails other = (DiscountDetails) object;
        if ((this.discDetailID == null && other.discDetailID != null) || (this.discDetailID != null && !this.discDetailID.equals(other.discDetailID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "spring.entity.DiscountDetails[ discDetailID=" + discDetailID + " ]";
    }
    
}
