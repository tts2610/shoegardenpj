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
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author tuan
 */
@Entity
@Table(name = "productSubImgs")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "ProductSubImgs.findAll", query = "SELECT p FROM ProductSubImgs p")
    , @NamedQuery(name = "ProductSubImgs.findBySubImgID", query = "SELECT p FROM ProductSubImgs p WHERE p.subImgID = :subImgID")
    , @NamedQuery(name = "ProductSubImgs.findByUrlImg", query = "SELECT p FROM ProductSubImgs p WHERE p.urlImg = :urlImg")})
public class ProductSubImgs implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "subImgID")
    private Integer subImgID;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "urlImg")
    private String urlImg;
    @JoinColumn(name = "colorID", referencedColumnName = "colorID")
    @ManyToOne
    @JsonBackReference
    private ProductColors colorID;

    public ProductSubImgs() {
    }

    public ProductSubImgs(Integer subImgID) {
        this.subImgID = subImgID;
    }

    public ProductSubImgs(Integer subImgID, String urlImg) {
        this.subImgID = subImgID;
        this.urlImg = urlImg;
    }

    public Integer getSubImgID() {
        return subImgID;
    }

    public void setSubImgID(Integer subImgID) {
        this.subImgID = subImgID;
    }

    public String getUrlImg() {
        return urlImg;
    }

    public void setUrlImg(String urlImg) {
        this.urlImg = urlImg;
    }

    public ProductColors getColorID() {
        return colorID;
    }

    public void setColorID(ProductColors colorID) {
        this.colorID = colorID;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (subImgID != null ? subImgID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ProductSubImgs)) {
            return false;
        }
        ProductSubImgs other = (ProductSubImgs) object;
        if ((this.subImgID == null && other.subImgID != null) || (this.subImgID != null && !this.subImgID.equals(other.subImgID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "spring.entity.ProductSubImgs[ subImgID=" + subImgID + " ]";
    }
    
}
