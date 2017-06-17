/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.entity;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
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
@Table(name = "brands")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Brands.findAll", query = "SELECT b FROM Brands b")
    , @NamedQuery(name = "Brands.findByBraID", query = "SELECT b FROM Brands b WHERE b.braID = :braID")
    , @NamedQuery(name = "Brands.findByBraName", query = "SELECT b FROM Brands b WHERE b.braName = :braName")
    , @NamedQuery(name = "Brands.findByStatus", query = "SELECT b FROM Brands b WHERE b.status = :status")})
public class Brands implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "braID")
    private Integer braID;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "braName")
    private String braName;
    @Column(name = "status")
    private Short status;
    @OneToMany(mappedBy = "braID")
    private List<Products> productsList;
    @OneToMany(mappedBy = "braID")
    private List<Categories> categoriesList;

    public Brands() {
    }

    public Brands(Integer braID) {
        this.braID = braID;
    }

    public Brands(Integer braID, String braName) {
        this.braID = braID;
        this.braName = braName;
    }

    public Integer getBraID() {
        return braID;
    }

    public void setBraID(Integer braID) {
        this.braID = braID;
    }

    public String getBraName() {
        return braName;
    }

    public void setBraName(String braName) {
        this.braName = braName;
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

    @XmlTransient
    public List<Products> getProductsList() {
        return productsList;
    }

    public void setProductsList(List<Products> productsList) {
        this.productsList = productsList;
    }

    @XmlTransient
    public List<Categories> getCategoriesList() {
        return categoriesList;
    }

    public void setCategoriesList(List<Categories> categoriesList) {
        this.categoriesList = categoriesList;
    }
    
    public List<Products> getProductListWorking(){
        List<Products> productListWorking = new ArrayList<>();
        for (Products p : productsList) {
            if(p.getStatus() == 1){
                productListWorking.add(p);
            }
        }
        return productListWorking;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (braID != null ? braID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Brands)) {
            return false;
        }
        Brands other = (Brands) object;
        if ((this.braID == null && other.braID != null) || (this.braID != null && !this.braID.equals(other.braID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "spring.entity.Brands[ braID=" + braID + " ]";
    }
    
}
