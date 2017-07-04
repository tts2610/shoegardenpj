/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.admin.controller;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import spring.ejb.RatingFacadeLocal;

/**
 *
 * @author tuan
 */
@Controller
@RequestMapping(value = "/admin/comments")
public class Comment_Controller {

    RatingFacadeLocal ratingFacade = lookupRatingFacadeLocal();
    
    
    
    
    @RequestMapping(value = "list")
    public String productCateList(ModelMap model) {
        model.addAttribute("cList", ratingFacade.findAll());
        return "admin/pages/comment-list";
    }
    @RequestMapping(value = "list/{status}")
    public String reviewListByStatus(ModelMap model, @PathVariable("status") Integer status) {
        model.addAttribute("reviewStatus", status);
//        model.addAttribute("orderList", orderStateLessBean.getAllOrderByStatus(status));
        return "admin/pages/comment-list";
    }
    @ResponseBody
    @RequestMapping(value = "updateStatus", method = RequestMethod.POST)
    public String userStatusUpdate(@RequestParam("rateID") Integer rateID,
            @RequestParam("status") Short status) {
        if (ratingFacade.updateStatusRating(rateID, status)) {
            return "OK";
        } else {
            return "FAIL";
        }
    }

    private RatingFacadeLocal lookupRatingFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (RatingFacadeLocal) c.lookup("java:global/ShoeGardenPJ/RatingFacade!spring.ejb.RatingFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }
}
