/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
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
@Table(name = "categories")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Categories.findAll", query = "SELECT c FROM Categories c")
    , @NamedQuery(name = "Categories.findByCatID", query = "SELECT c FROM Categories c WHERE c.catID = :catID")
    , @NamedQuery(name = "Categories.findByCatName", query = "SELECT c FROM Categories c WHERE c.catName = :catName")
    , @NamedQuery(name = "Categories.findByStatus", query = "SELECT c FROM Categories c WHERE c.status = :status")})
public class Categories implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "catID")
    private Integer catID;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "catName")
    private String catName;
    @Column(name = "status")
    private Short status;
    @OneToMany(mappedBy = "catID")
    @JsonManagedReference
    private List<Products> productsList;
    @JoinColumn(name = "braID", referencedColumnName = "braID")
    @ManyToOne
    @JsonBackReference
    private Brands braID;

    public Categories() {
    }

    public Categories(Integer catID) {
        this.catID = catID;
    }

    public Categories(Integer catID, String catName) {
        this.catID = catID;
        this.catName = catName;
    }

    public Integer getCatID() {
        return catID;
    }

    public void setCatID(Integer catID) {
        this.catID = catID;
    }

    public String getCatName() {
        return catName;
    }

    public void setCatName(String catName) {
        this.catName = catName;
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

    public List<Products> getProductListWorking(){
        List<Products> productListWorking = new ArrayList<>();
        for (Products p : productsList) {
            if(p.getStatus() == 1){
                productListWorking.add(p);
            }
        }
        return productListWorking;
    }
    
    public Brands getBraID() {
        return braID;
    }

    public void setBraID(Brands braID) {
        this.braID = braID;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (catID != null ? catID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Categories)) {
            return false;
        }
        Categories other = (Categories) object;
        if ((this.catID == null && other.catID != null) || (this.catID != null && !this.catID.equals(other.catID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "spring.entity.Categories[ catID=" + catID + " ]";
    }
    
}
