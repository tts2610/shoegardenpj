/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.interceptor;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import spring.ejb.UsersFacadeLocal;

import spring.entity.Users;

/**
 *
 * @author hoang
 */
public class CheckCookieUser extends HandlerInterceptorAdapter {

    UsersFacadeLocal usersFacade = lookupUsersFacadeLocal();

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
//        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
//        response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
//        response.setDateHeader("Expires", 0); // Proxies.
        HttpSession session = request.getSession();
        

        Cookie[] ck = request.getCookies();
        if (ck != null) { //check cookie
            String email = "";
            String pass = "";

            for (Cookie c : ck) {
                if (c.getName().equals("emailU")) {
                    email = c.getValue();
                }

                if (c.getName().equals("passwordU")) {
                    pass = c.getValue();
                }
            }

            if (email != "" && pass != "") {
                int error = usersFacade.checkLoginUser(email, pass);
                if (error == 1) {
                    session.setAttribute("emailUser", email);
                    Users userfindUserID = usersFacade.findUserByEmail(email);
                    session.setAttribute("findUsersID", userfindUserID.getUserID());
                    session.setAttribute("USfirstname", userfindUserID.getFirstName() + " " + userfindUserID.getLastName());
                }
            }
        }
        return true;
    }

    private UsersFacadeLocal lookupUsersFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (UsersFacadeLocal) c.lookup("java:global/ShoeGardenPJ/UsersFacade!spring.ejb.UsersFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    
}
