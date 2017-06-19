/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.admin.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.text.Normalizer;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import spring.ejb.OrderStateLessBeanLocal;
import spring.ejb.ProductsFacadeLocal;
import spring.entity.CartLineInfo;
import spring.entity.Categories;
import spring.entity.Orders;
import spring.entity.OrdersDetail;
import spring.entity.ProductColors;
import spring.entity.Products;
import spring.entity.SizesByColor;

@Controller
@RequestMapping(value = "/admin/orders/")
public class Orders_Controller {

    OrderStateLessBeanLocal orderStateLessBean = lookupOrderStateLessBeanLocal();

    ProductsFacadeLocal productStateLessBean = lookupProductsFacadeLocal();
    
    

    @RequestMapping(value = "list")
    public String ordersList(ModelMap model) {
        model.addAttribute("orderStatus", 4);
        model.addAttribute("orderList", orderStateLessBean.getAllOrder());
        return "admin/pages/orders-list";
    }
    
    @RequestMapping(value = "list/{status}")
    public String ordersListByStatus(ModelMap model, @PathVariable("status") Integer status) {
        model.addAttribute("orderStatus", status);
        model.addAttribute("orderList", orderStateLessBean.getAllOrderByStatus(status));
        return "admin/pages/orders-list";
    }

//    @RequestMapping(value = "orderchart")
//    public String ordersChart(ModelMap model) {
//        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//        String date = sdf.format(new Date());
//        SimpleDateFormat sdfMonth = new SimpleDateFormat("MM-yyyy");
//        String thisMonth = sdfMonth.format(new Date());
//        SimpleDateFormat sdfYear = new SimpleDateFormat("yyyy");
//        String thisYear = sdfYear.format(new Date());
//        List<Orders> orderList = orderStateLessBean.getAllOrder();
//        float totalRevenue = 0;
//        for (Orders order : orderList) {
//            if (order.getOrdersDate().getYear() == (new Date().getYear())) {
//                totalRevenue += order.getPaymentTotal();
//            }
//        }
//        model.addAttribute("thisYear", thisYear);
//        model.addAttribute("avgOrdersRevenueInYear", (totalRevenue/12));
//        model.addAttribute("thisMonth", thisMonth);
//        model.addAttribute("avgOrderPerUserByMonth", orderStateLessBean.averageOrdersPerUserByMonth(date));
//        model.addAttribute("totalOrders", orderStateLessBean.countOrders());
//        model.addAttribute("pendingOrders", orderStateLessBean.countOrderByStatus(2));
//        model.addAttribute("confirmedOrders", orderStateLessBean.countOrderByStatus(3));
//        model.addAttribute("completedOrders", orderStateLessBean.countOrderByStatus(1));
//        model.addAttribute("cancelOrders", orderStateLessBean.countOrderByStatus(0));
//        model.addAttribute("listYear", orderStateLessBean.getAllYearOrdered());
//        return "admin/pages/orders-chart";
//    }
//
//    @ResponseBody
//    @RequestMapping(value = "ajax/orderDonutQuantitySubcategory", method = RequestMethod.GET)
//    public String getDonutSubcategoryQuantityForChart() {
//        List<SubCategories> subCategoriesList = productStateLessBean.subCategoryList();
//        List<OrdersDetail> ordersDetailList = orderStateLessBean.getAllOrderDetail();
//        List<QuantityOrderChart> subcateQuantityChartList = new ArrayList<>();
//        for (SubCategories subCategory : subCategoriesList) {
//            String label = subCategory.getCategory().getCateName() + "-" + subCategory.getSubCateName();
//            int value = 0;
//            for (OrdersDetail ordersDetail : ordersDetailList) {
//                if (ordersDetail.getOrder().getStatus() == 1) {
//                    if (ordersDetail.getProduct().getSubCate().getCategory().getCateID().equals(subCategory.getCategory().getCateID())
//                              && ordersDetail.getProduct().getSubCate().getSubCateID().equals(subCategory.getSubCateID())) {
//                        value += ordersDetail.getQuantity();
//                    }
//                }
//            }
//            QuantityOrderChart totalQuantityOrderChart = new QuantityOrderChart();
//            totalQuantityOrderChart.setLabel(label);
//            totalQuantityOrderChart.setValue(value);
//            subcateQuantityChartList.add(totalQuantityOrderChart);
//        }
//        Collections.sort(subcateQuantityChartList, new QuantityOrderChart.QuantityOrderChartComparator());
//        try {
//            ObjectMapper mapper = new ObjectMapper();
//            String result = mapper.writeValueAsString(subcateQuantityChartList);
//            return result;
//        } catch (Exception e) {
//            return "Error!" + e.getMessage();
//        }
//    }
//
//    @ResponseBody
//    @RequestMapping(value = "ajax/orderDonutQuantityCategory", method = RequestMethod.GET)
//    public String getDonutCategoryQuantityForChart() {
//        List<Categories> categoriesList = productStateLessBean.categoryList();
//        List<OrdersDetail> ordersDetailList = orderStateLessBean.getAllOrderDetail();
//        List<QuantityOrderChart> categoryQuantityChartList = new ArrayList<>();
//        for (Categories categories : categoriesList) {
//            String label = categories.getCateName();
//            int value = 0;
//            for (OrdersDetail ordersDetail : ordersDetailList) {
//                if (ordersDetail.getOrder().getStatus() == 1) {
//                    if (ordersDetail.getProduct().getCategory().getCateID().equals(categories.getCateID())) {
//                        value += ordersDetail.getQuantity();
//                    }
//                }
//            }
//            QuantityOrderChart totalQuantityOrderChart = new QuantityOrderChart();
//            totalQuantityOrderChart.setLabel(label);
//            totalQuantityOrderChart.setValue(value);
//            categoryQuantityChartList.add(totalQuantityOrderChart);
//        }
//        Collections.sort(categoryQuantityChartList, new QuantityOrderChart.QuantityOrderChartComparator());
//        try {
//            ObjectMapper mapper = new ObjectMapper();
//            String result = mapper.writeValueAsString(categoryQuantityChartList);
//            return result;
//        } catch (Exception e) {
//            return "Error!" + e.getMessage();
//        }
//    }
//
//    @ResponseBody
//    @RequestMapping(value = "ajax/orderDonutMoneyCategory", method = RequestMethod.GET)
//    public String getDonutCategoryRevenueForChart() {
//        List<Categories> categoriesList = productStateLessBean.categoryList();
//        List<OrdersDetail> ordersDetailList = orderStateLessBean.getAllOrderDetail();
//        List<RevenueOrderChart> totalRevenueSubcateChartList = new ArrayList<>();
//        for (Categories categories : categoriesList) {
//            String label = categories.getCateName();
//            float value = 0;
//            for (OrdersDetail ordersDetail : ordersDetailList) {
//                if (ordersDetail.getOrder().getStatus() == 1) {
//                    if (ordersDetail.getProduct().getCategory().getCateID().equals(categories.getCateID())) {
//                        value += ordersDetail.getSubTotal();
//                    }
//                }
//            }
//            RevenueOrderChart revenueOrderChart = new RevenueOrderChart();
//            revenueOrderChart.setLabel(label);
//            revenueOrderChart.setValue(value);
//            totalRevenueSubcateChartList.add(revenueOrderChart);
//        }
//        Collections.sort(totalRevenueSubcateChartList, new RevenueOrderChart.RevenueOrderChartComparator());
//        try {
//            ObjectMapper mapper = new ObjectMapper();
//            String result = mapper.writeValueAsString(totalRevenueSubcateChartList);
//            return result;
//        } catch (Exception e) {
//            return "Error!" + e.getMessage();
//        }
//    }
//
//    @ResponseBody
//    @RequestMapping(value = "ajax/orderDonutMoneySubcategory", method = RequestMethod.GET)
//    public String getDonutSubcategoryRevenueForChart() {
//        List<SubCategories> subCategoriesList = productStateLessBean.subCategoryList();
//        List<OrdersDetail> ordersDetailList = orderStateLessBean.getAllOrderDetail();
//        List<RevenueOrderChart> totalRevenueSubcateChartList = new ArrayList<>();
//        for (SubCategories subCategory : subCategoriesList) {
//            String label = subCategory.getCategory().getCateName() + "-" + subCategory.getSubCateName();
//            float value = 0;
//            for (OrdersDetail ordersDetail : ordersDetailList) {
//                if (ordersDetail.getOrder().getStatus() == 1) {
//                    if (ordersDetail.getProduct().getSubCate().getCategory().getCateID().equals(subCategory.getCategory().getCateID())
//                              && ordersDetail.getProduct().getSubCate().getSubCateID().equals(subCategory.getSubCateID())) {
//                        value += ordersDetail.getSubTotal();
//                    }
//                }
//            }
//            RevenueOrderChart revenueOrderChart = new RevenueOrderChart();
//            revenueOrderChart.setLabel(label);
//            revenueOrderChart.setValue(value);
//            totalRevenueSubcateChartList.add(revenueOrderChart);
//        }
//        Collections.sort(totalRevenueSubcateChartList, new RevenueOrderChart.RevenueOrderChartComparator());
//        try {
//            ObjectMapper mapper = new ObjectMapper();
//            String result = mapper.writeValueAsString(totalRevenueSubcateChartList);
//            return result;
//        } catch (Exception e) {
//            return "Error!" + e.getMessage();
//        }
//    }
//
//    @ResponseBody
//    @RequestMapping(value = "ajax/orderLineMoneyChart", method = RequestMethod.GET)
//    public String getLineRevenueForChart(@RequestParam("month") Integer month,
//              @RequestParam("year") Integer year) {
//        List<Orders> orderList = orderStateLessBean.getAllOrderByMonth(month,year);
//        List<Integer> dayOrderedList = orderStateLessBean.getAllDayOrderedByMonth(month,year);
//        List<RevenueOrderChart> totalRevenueSubcateChartList = new ArrayList<>();
//        for (Integer day : dayOrderedList) {
//            String label = String.valueOf(year) + "-" + String.valueOf(month) + "-" + day;
//            float value = 0;
//            for (Orders order : orderList) {
//                if (order.getOrdersDate().getDate() == day && order.getStatus() == 1) {
//                    value += order.getPaymentTotal();
//                }
//            }
//            RevenueOrderChart revenueOrderChart = new RevenueOrderChart();
//            revenueOrderChart.setLabel(label);
//            revenueOrderChart.setValue(value);
//            totalRevenueSubcateChartList.add(revenueOrderChart);
//        }
//        try {
//            ObjectMapper mapper = new ObjectMapper();
//            String result = mapper.writeValueAsString(totalRevenueSubcateChartList);
//            return result;
//        } catch (Exception e) {
//            return "Error!" + e.getMessage();
//        }
//    }
//    
//    @ResponseBody
//    @RequestMapping(value = "ajax/getMonthOrderedByYear", method = RequestMethod.GET)
//    public String getMonthOrderedByYear(@RequestParam("year") Integer year) {
//        List<Integer> monthList = orderStateLessBean.getAllMonthOrderedByYear(year);
//        try {
//            ObjectMapper mapper = new ObjectMapper();
//            String result = mapper.writeValueAsString(monthList);
//            return result;
//        } catch (Exception e) {
//            return "Error!" + e.getMessage();
//        }
//    }

    

    @RequestMapping(value = "confirmstatusOrder/{orderid}/{status}", method = RequestMethod.GET)
    public String confirmstatusOrder(@PathVariable("orderid") int orderid, @PathVariable("status") short status) {
        Orders order = orderStateLessBean.getOrderByID(orderid);
        if (order != null) {
            if (orderStateLessBean.confirmStatusOrder(order, status)) {
                return "redirect:/admin/orders/list.html";
            }
        }
        return "redirect:/admin/orders/list.html";
    }

    @RequestMapping(value = "orderlistdetail/{orderid}", method = RequestMethod.GET)
    public String orderlistdetail(@PathVariable("orderid") int orderid, ModelMap model) {
        Orders order = orderStateLessBean.getOrderByID(orderid);
        List<OrdersDetail> list = orderStateLessBean.getAllOrderDetailByOrderID(orderid);
        
        if (order != null) {
            model.addAttribute("orderdetailList",list );
            model.addAttribute("order", order);
            return "admin/pages/orders-list-detail";
        }
        return "redirect:/admin/orders/list.html";
    }

    @RequestMapping(value = "invoice/{orderID}")
    public String invoice(ModelMap model, @PathVariable("orderID") Integer orderID) {
        Orders orders = orderStateLessBean.getOrderByID(orderID);
        
        model.addAttribute("orders", orders);
        return "admin/orders-invoice";
    }

    private ProductsFacadeLocal lookupProductsFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (ProductsFacadeLocal) c.lookup("java:global/ShoeGardenPJ/ProductsFacade!spring.ejb.ProductsFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    private OrderStateLessBeanLocal lookupOrderStateLessBeanLocal() {
        try {
            Context c = new InitialContext();
            return (OrderStateLessBeanLocal) c.lookup("java:global/ShoeGardenPJ/OrderStateLessBean!spring.ejb.OrderStateLessBeanLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    

    
}
