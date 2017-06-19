/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.entity;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
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

/**
 *
 * @author tuan
 */
@Entity
@Table(name = "rating")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Rating.findAll", query = "SELECT r FROM Rating r")
    , @NamedQuery(name = "Rating.findByRatingID", query = "SELECT r FROM Rating r WHERE r.ratingID = :ratingID")
    , @NamedQuery(name = "Rating.findByRating", query = "SELECT r FROM Rating r WHERE r.rating = :rating")
    , @NamedQuery(name = "Rating.findByRatingDate", query = "SELECT r FROM Rating r WHERE r.ratingDate = :ratingDate")
    , @NamedQuery(name = "Rating.findByStatus", query = "SELECT r FROM Rating r WHERE r.status = :status")})
public class Rating implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "ratingID")
    private Integer ratingID;
    @Basic(optional = false)
    @NotNull
    @Column(name = "rating")
    private int rating;
    @Temporal(TemporalType.DATE)
    private Date ratingDate;
    @Column(name = "status")
    private Short status;
    @JoinColumn(name = "productID", referencedColumnName = "productID")
    @ManyToOne
    private Products productID;
    @JoinColumn(name = "userID", referencedColumnName = "userID")
    @ManyToOne
    private Users userID;

    public Rating() {
    }

    public Rating(Integer ratingID) {
        this.ratingID = ratingID;
    }

    public Rating(Integer ratingID, int rating) {
        this.ratingID = ratingID;
        this.rating = rating;
    }

    public Integer getRatingID() {
        return ratingID;
    }

    public void setRatingID(Integer ratingID) {
        this.ratingID = ratingID;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public Date getRatingDate() {
        return ratingDate;
    }

    public void setRatingDate(Date ratingDate) {
        this.ratingDate = ratingDate;
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

    public Products getProductID() {
        return productID;
    }

    public void setProductID(Products productID) {
        this.productID = productID;
    }

    public Users getUserID() {
        return userID;
    }

    public void setUserID(Users userID) {
        this.userID = userID;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (ratingID != null ? ratingID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Rating)) {
            return false;
        }
        Rating other = (Rating) object;
        if ((this.ratingID == null && other.ratingID != null) || (this.ratingID != null && !this.ratingID.equals(other.ratingID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "spring.entity.Rating[ ratingID=" + ratingID + " ]";
    }
    
}
