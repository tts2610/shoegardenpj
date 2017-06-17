/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.entity;

import java.io.Serializable;
import java.util.Date;
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
@Table(name = "discounts")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Discounts.findAll", query = "SELECT d FROM Discounts d")
    , @NamedQuery(name = "Discounts.findByDiscID", query = "SELECT d FROM Discounts d WHERE d.discID = :discID")
    , @NamedQuery(name = "Discounts.findByDiscTitle", query = "SELECT d FROM Discounts d WHERE d.discTitle = :discTitle")
    , @NamedQuery(name = "Discounts.findByDiscContent", query = "SELECT d FROM Discounts d WHERE d.discContent = :discContent")
    , @NamedQuery(name = "Discounts.findByDateBegin", query = "SELECT d FROM Discounts d WHERE d.dateBegin = :dateBegin")
    , @NamedQuery(name = "Discounts.findByDateEnd", query = "SELECT d FROM Discounts d WHERE d.dateEnd = :dateEnd")
    , @NamedQuery(name = "Discounts.findByDiscount", query = "SELECT d FROM Discounts d WHERE d.discount = :discount")})
public class Discounts implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "discID")
    private Integer discID;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "discTitle")
    private String discTitle;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "discContent")
    private String discContent;
    @Basic(optional = false)
    @NotNull
    @Temporal(TemporalType.DATE)
    @DateTimeFormat(pattern = "dd-MM-yyyy")
    @Column(name = "dateBegin")
    private Date dateBegin;
    @Basic(optional = false)
    @NotNull
    @Temporal(TemporalType.DATE)
    @DateTimeFormat(pattern = "dd-MM-yyyy")
    @Column(name = "dateEnd")
    private Date dateEnd;
    @Basic(optional = false)
    @NotNull
    @Column(name = "discount")
    private short discount;
    @OneToMany(mappedBy = "discID")
    private List<DiscountDetails> discountDetailList;

    public List<DiscountDetails> getDiscountDetailList() {
        return discountDetailList;
    }

    public void setDiscountDetailList(List<DiscountDetails> discountDetailList) {
        this.discountDetailList = discountDetailList;
    }
    
    
    
    public Discounts() {
    }

    public Discounts(Integer discID) {
        this.discID = discID;
    }

    public Discounts(Integer discID, String discTitle, String discContent, Date dateBegin, Date dateEnd, short discount) {
        this.discID = discID;
        this.discTitle = discTitle;
        this.discContent = discContent;
        this.dateBegin = dateBegin;
        this.dateEnd = dateEnd;
        this.discount = discount;
    }
    
    public Discounts(String discTitle, String discContent, Date dateBegin, Date dateEnd, short discount) {
        
        this.discTitle = discTitle;
        this.discContent = discContent;
        this.dateBegin = dateBegin;
        this.dateEnd = dateEnd;
        this.discount = discount;
    }

    public Integer getDiscID() {
        return discID;
    }

    public void setDiscID(Integer discID) {
        this.discID = discID;
    }

    public String getDiscTitle() {
        return discTitle;
    }

    public void setDiscTitle(String discTitle) {
        this.discTitle = discTitle;
    }

    public String getDiscContent() {
        return discContent;
    }

    public void setDiscContent(String discContent) {
        this.discContent = discContent;
    }

    public Date getDateBegin() {
        return dateBegin;
    }

    public void setDateBegin(Date dateBegin) {
        this.dateBegin = dateBegin;
    }

    public Date getDateEnd() {
        return dateEnd;
    }

    public void setDateEnd(Date dateEnd) {
        this.dateEnd = dateEnd;
    }

    public short getDiscount() {
        return discount;
    }

    public void setDiscount(short discount) {
        this.discount = discount;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (discID != null ? discID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Discounts)) {
            return false;
        }
        Discounts other = (Discounts) object;
        if ((this.discID == null && other.discID != null) || (this.discID != null && !this.discID.equals(other.discID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "spring.entity.Discounts[ discID=" + discID + " ]";
    }
    
}
