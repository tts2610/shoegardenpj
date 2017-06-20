/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import java.io.Serializable;
import java.util.Date;
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
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;
import org.springframework.format.annotation.DateTimeFormat;

/**
 *
 * @author tuan
 */
@Entity
@Table(name = "wishList")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "WishList.findAll", query = "SELECT w FROM WishList w")
    , @NamedQuery(name = "WishList.findByWishID", query = "SELECT w FROM WishList w WHERE w.wishID = :wishID")
    , @NamedQuery(name = "WishList.findByCreateDate", query = "SELECT w FROM WishList w WHERE w.createDate = :createDate")})
public class WishList implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "wishID")
    private Integer wishID;
    @DateTimeFormat(pattern = "dd/MM/yyyy")
    @Temporal(TemporalType.DATE)
    private Date createDate;
    @ManyToOne
    @JoinColumn(name = "userID")
    @JsonBackReference
    private Users user;
    
    @ManyToOne
    @JoinColumn(name = "productID")
    @JsonBackReference
    private Products product;

    public Products getProduct() {
        return product;
    }

    public void setProduct(Products product) {
        this.product = product;
    }

    
    
    
    
    public WishList() {
    }

    public WishList(Integer wishID) {
        this.wishID = wishID;
    }

    public Integer getWishID() {
        return wishID;
    }

    public void setWishID(Integer wishID) {
        this.wishID = wishID;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Users getUser() {
        return user;
    }

    public void setUser(Users userID) {
        this.user = userID;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (wishID != null ? wishID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof WishList)) {
            return false;
        }
        WishList other = (WishList) object;
        if ((this.wishID == null && other.wishID != null) || (this.wishID != null && !this.wishID.equals(other.wishID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "spring.entity.WishList[ wishID=" + wishID + " ]";
    }
    
}
