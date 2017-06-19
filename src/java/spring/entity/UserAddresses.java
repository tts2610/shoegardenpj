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
@Table(name = "userAddresses")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "UserAddresses.findAll", query = "SELECT u FROM UserAddresses u")
    , @NamedQuery(name = "UserAddresses.findByAddressID", query = "SELECT u FROM UserAddresses u WHERE u.addressID = :addressID")
    , @NamedQuery(name = "UserAddresses.findByAddress", query = "SELECT u FROM UserAddresses u WHERE u.address = :address")
    , @NamedQuery(name = "UserAddresses.findByPhoneNumber", query = "SELECT u FROM UserAddresses u WHERE u.phoneNumber = :phoneNumber")})
public class UserAddresses implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "addressID")
    private Integer addressID;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "address")
    private String address;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "phoneNumber")
    private String phoneNumber;
    
    
    @ManyToOne
    @JoinColumn(name = "userID")
    @JsonBackReference
    private Users user;
    
    public Users getUser() {
        return user;
    }

    public void setUser(Users user) {
        this.user = user;
    }
    

    public UserAddresses() {
    }

    public UserAddresses(Integer addressID) {
        this.addressID = addressID;
    }

    public UserAddresses(Integer addressID, String address, String phoneNumber) {
        this.addressID = addressID;
        this.address = address;
        this.phoneNumber = phoneNumber;
    }

    public Integer getAddressID() {
        return addressID;
    }

    public void setAddressID(Integer addressID) {
        this.addressID = addressID;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (addressID != null ? addressID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UserAddresses)) {
            return false;
        }
        UserAddresses other = (UserAddresses) object;
        if ((this.addressID == null && other.addressID != null) || (this.addressID != null && !this.addressID.equals(other.addressID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "spring.entity.UserAddresses[ addressID=" + addressID + " ]";
    }
    
}
