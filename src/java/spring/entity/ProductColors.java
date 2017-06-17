/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import java.io.Serializable;
import java.util.List;
import javax.persistence.Basic;
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
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 *
 * @author tuan
 */
@Entity
@Table(name = "productColors")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "ProductColors.findAll", query = "SELECT p FROM ProductColors p")
    , @NamedQuery(name = "ProductColors.findByColorID", query = "SELECT p FROM ProductColors p WHERE p.colorID = :colorID")
    , @NamedQuery(name = "ProductColors.findByColor", query = "SELECT p FROM ProductColors p WHERE p.color = :color")
    , @NamedQuery(name = "ProductColors.findByUrlColorImg", query = "SELECT p FROM ProductColors p WHERE p.urlColorImg = :urlColorImg")
    , @NamedQuery(name = "ProductColors.findByStatus", query = "SELECT p FROM ProductColors p WHERE p.status = :status")})
public class ProductColors implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "colorID")
    private Integer colorID;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "color")
    private String color;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "urlColorImg")
    private String urlColorImg;
    @Column(name = "status")
    private Short status;
    @OneToMany(mappedBy = "colorID",cascade = CascadeType.PERSIST)
    @JsonManagedReference
    private List<ProductSubImgs> productSubImgsList;
    @OneToMany(mappedBy = "colorID",cascade = CascadeType.PERSIST)
    @JsonManagedReference
    private List<SizesByColor> sizesByColorList;
    @JoinColumn(name = "productID", referencedColumnName = "productID")
    @ManyToOne
    @JsonBackReference
    private Products productID;

    public ProductColors() {
    }

    public ProductColors(Integer colorID) {
        this.colorID = colorID;
    }

    public ProductColors(Integer colorID, String color, String urlColorImg) {
        this.colorID = colorID;
        this.color = color;
        this.urlColorImg = urlColorImg;
    }

    public Integer getColorID() {
        return colorID;
    }

    public void setColorID(Integer colorID) {
        this.colorID = colorID;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getUrlColorImg() {
        return urlColorImg;
    }

    public void setUrlColorImg(String urlColorImg) {
        this.urlColorImg = urlColorImg;
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

    @XmlTransient
    public List<ProductSubImgs> getProductSubImgsList() {
        return productSubImgsList;
    }

    public void setProductSubImgsList(List<ProductSubImgs> productSubImgsList) {
        this.productSubImgsList = productSubImgsList;
    }

    @XmlTransient
    public List<SizesByColor> getSizesByColorList() {
        return sizesByColorList;
    }

    public void setSizesByColorList(List<SizesByColor> sizesByColorList) {
        this.sizesByColorList = sizesByColorList;
    }

    public Products getProductID() {
        return productID;
    }

    public void setProductID(Products productID) {
        this.productID = productID;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (colorID != null ? colorID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ProductColors)) {
            return false;
        }
        ProductColors other = (ProductColors) object;
        if ((this.colorID == null && other.colorID != null) || (this.colorID != null && !this.colorID.equals(other.colorID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "spring.entity.ProductColors[ colorID=" + colorID + " ]";
    }
    
}
