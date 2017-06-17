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

/**
 *
 * @author tuan
 */
@Entity
@Table(name = "sizesByColor")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "SizesByColor.findAll", query = "SELECT s FROM SizesByColor s")
    , @NamedQuery(name = "SizesByColor.findBySizeID", query = "SELECT s FROM SizesByColor s WHERE s.sizeID = :sizeID")
    , @NamedQuery(name = "SizesByColor.findBySize", query = "SELECT s FROM SizesByColor s WHERE s.size = :size")
    , @NamedQuery(name = "SizesByColor.findByQuantity", query = "SELECT s FROM SizesByColor s WHERE s.quantity = :quantity")
    , @NamedQuery(name = "SizesByColor.findByStatus", query = "SELECT s FROM SizesByColor s WHERE s.status = :status")})
public class SizesByColor implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "sizeID")
    private Integer sizeID;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "size")
    private String size;
    @Basic(optional = false)
    @NotNull
    @Column(name = "quantity")
    private int quantity;
    @Column(name = "status")
    private Short status;
    @JoinColumn(name = "colorID", referencedColumnName = "colorID")
    @ManyToOne
    @JsonBackReference
    private ProductColors colorID;
    @OneToMany(mappedBy = "sizeID")
    @JsonManagedReference
    private List<OrdersDetail> ordersDetailList;

    public List<OrdersDetail> getOrdersDetailList() {
        return ordersDetailList;
    }

    public void setOrdersDetailList(List<OrdersDetail> ordersDetailList) {
        this.ordersDetailList = ordersDetailList;
    }
    
    
    
    public SizesByColor() {
    }

    public SizesByColor(Integer sizeID) {
        this.sizeID = sizeID;
    }

    public SizesByColor(Integer sizeID, String size, int quantity) {
        this.sizeID = sizeID;
        this.size = size;
        this.quantity = quantity;
    }

    public Integer getSizeID() {
        return sizeID;
    }

    public void setSizeID(Integer sizeID) {
        this.sizeID = sizeID;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
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
        hash += (sizeID != null ? sizeID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof SizesByColor)) {
            return false;
        }
        SizesByColor other = (SizesByColor) object;
        if ((this.sizeID == null && other.sizeID != null) || (this.sizeID != null && !this.sizeID.equals(other.sizeID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "spring.entity.SizesByColor[ sizeID=" + sizeID + " ]";
    }
    
}
