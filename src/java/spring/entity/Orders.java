/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import java.io.Serializable;
import java.util.Date;
import java.util.List;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
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
@Table(name = "orders")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Orders.findAll", query = "SELECT o FROM Orders o")
    , @NamedQuery(name = "Orders.findByOrdersID", query = "SELECT o FROM Orders o WHERE o.ordersID = :ordersID")
    , @NamedQuery(name = "Orders.findByOrdersDate", query = "SELECT o FROM Orders o WHERE o.ordersDate = :ordersDate")
    , @NamedQuery(name = "Orders.findByReceiverFirstName", query = "SELECT o FROM Orders o WHERE o.receiverFirstName = :receiverFirstName")
    , @NamedQuery(name = "Orders.findByReceiverLastName", query = "SELECT o FROM Orders o WHERE o.receiverLastName = :receiverLastName")
    , @NamedQuery(name = "Orders.findByPhoneNumber", query = "SELECT o FROM Orders o WHERE o.phoneNumber = :phoneNumber")
    , @NamedQuery(name = "Orders.findByDeliveryAddress", query = "SELECT o FROM Orders o WHERE o.deliveryAddress = :deliveryAddress")
    , @NamedQuery(name = "Orders.findByStatus", query = "SELECT o FROM Orders o WHERE o.status = :status")})
public class Orders implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "ordersID")
    private Integer ordersID;
    @Column(name = "ordersDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date ordersDate;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "receiverFirstName")
    private String receiverFirstName;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "receiverLastName")
    private String receiverLastName;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "phoneNumber")
    private String phoneNumber;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "deliveryAddress")
    private String deliveryAddress;
    @Lob
    @Size(max = 2147483647)
    @Column(name = "note")
    private String note;
    @Column(name = "status")
    private Short status;
    @JoinColumn(name = "userID", referencedColumnName = "userID")
    @ManyToOne
    private Users userID;

    @OneToMany(mappedBy = "ordersID", cascade = CascadeType.ALL)
    @JsonManagedReference
    private List<OrdersDetail> orderDetailList;

    
    
    
    
    
    public List<OrdersDetail> getOrderDetailList() {
        return orderDetailList;
    }

    public void setOrderDetailList(List<OrdersDetail> orderDetailList) {
        this.orderDetailList = orderDetailList;
    }
    
//    public float getOrderDiscountPrice(){
//        float voucherDiscount = 0;
//        float total = 0;
//        if (voucher != null) {
//            voucherDiscount = Float.parseFloat(voucher.getDiscount().toString());
//        }
//        for (OrdersDetail orderDetail : orderDetailList) {
//            if (orderDetail.getStatus() != 1) {
//                total += orderDetail.getTotalPrice();
//            }
//        }
//        return (total * (voucherDiscount/100));
//    } 
//    
//    public float getPaymentTotal(){
//        float total = 0;
//        for (OrdersDetail orderDetail : orderDetailList) {
//            if (orderDetail.getStatus() != 1) {
//                total += orderDetail.getSubTotal();
//            }
//        }
//        return (total - getOrderDiscountPrice());
//    }
//    
//    public OrdersDetail getOrderDetailForOrderHistoryPage(){
//        if (!orderDetailList.isEmpty()) {
//            return orderDetailList.get(0);
//        }
//        return null;
//    }
    
    public float getTotal(){
        float total = 0;
        for(OrdersDetail od : orderDetailList){
            total += od.getSubTotal();
        }
        return total;
    }
    
    
    public Orders() {
    }

    public Orders(Integer ordersID) {
        this.ordersID = ordersID;
    }

    public Orders(Integer ordersID, String receiverFirstName, String receiverLastName, String phoneNumber, String deliveryAddress) {
        this.ordersID = ordersID;
        this.receiverFirstName = receiverFirstName;
        this.receiverLastName = receiverLastName;
        this.phoneNumber = phoneNumber;
        this.deliveryAddress = deliveryAddress;
    }

    public Integer getOrdersID() {
        return ordersID;
    }

    public void setOrdersID(Integer ordersID) {
        this.ordersID = ordersID;
    }

    public Date getOrdersDate() {
        return ordersDate;
    }

    public void setOrdersDate(Date ordersDate) {
        this.ordersDate = ordersDate;
    }

    public String getReceiverFirstName() {
        return receiverFirstName;
    }

    public void setReceiverFirstName(String receiverFirstName) {
        this.receiverFirstName = receiverFirstName;
    }

    public String getReceiverLastName() {
        return receiverLastName;
    }

    public void setReceiverLastName(String receiverLastName) {
        this.receiverLastName = receiverLastName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
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
        hash += (ordersID != null ? ordersID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Orders)) {
            return false;
        }
        Orders other = (Orders) object;
        if ((this.ordersID == null && other.ordersID != null) || (this.ordersID != null && !this.ordersID.equals(other.ordersID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "spring.entity.Orders[ ordersID=" + ordersID + " ]";
    }
    
}
