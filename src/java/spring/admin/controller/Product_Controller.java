/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.admin.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.support.DefaultMultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import spring.ejb.BrandsFacadeLocal;
import spring.ejb.CategoriesFacadeLocal;
import spring.ejb.ProductsFacadeLocal;
import spring.entity.Brands;
import spring.entity.Categories;
import spring.entity.ProductColors;
import spring.entity.ProductSubImgs;
import spring.entity.Products;
import spring.entity.SizesByColor;
import spring.functions.SharedFunctions;

/**
 *
 * @author tuan
 */
@Controller
@RequestMapping(value = "/admin/")
public class Product_Controller {

    CategoriesFacadeLocal categoriesFacade = lookupCategoriesFacadeLocal();

    BrandsFacadeLocal brandsFacade = lookupBrandsFacadeLocal();

    ProductsFacadeLocal productsFacade = lookupProductsFacadeLocal();
    
    
    
    @Autowired
    SharedFunctions shareFunc;

    @Autowired
    ServletContext app;
    
    
    
    @RequestMapping(value = "product")
    public String productList(ModelMap model) {
        model.addAttribute("productList", productsFacade.productList("admin"));
        return "admin/pages/product-list";
    }

    @RequestMapping(value = "product/create", method = RequestMethod.GET)
    public String productAdd() {
        return "admin/pages/product-add";
    }

    @RequestMapping(value = "product/create", method = RequestMethod.POST)
    public String productAdd(HttpServletRequest request,
            ModelMap model,
            @RequestParam MultiValueMap<String, String> allRequestParams,
            RedirectAttributes flashAttr) {
        String productName = allRequestParams.get("productName").get(0);
        if (productsFacade.checkDuplicateProductName(productName)) {
            model.addAttribute("error", "<div class=\"col-xs-12 col-sm-6 col-sm-offset-3 alert alert-danger\">\n"
                    + "<strong>Error!</strong> Duplicate Product Name !.\n"
                    + "</div>");
            return "admin/pages/product-add";
        }
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd_HH_mm_ss");
        int cateID = Integer.parseInt(allRequestParams.get("category").get(0));
        int subCateID = Integer.parseInt(allRequestParams.get("subCategory").get(0));

        Float price = Float.parseFloat(allRequestParams.get("price").get(0));
//        Short discount = Short.parseShort(allRequestParams.get("discount").get(0));
        String description = allRequestParams.get("description").get(0);
        List<String> colorList = allRequestParams.get("color");
        List<MultipartFile> colorImgs = ((DefaultMultipartHttpServletRequest) request).getFiles("colorImg[]");

        Products product = new Products();

        //Load thông tin category theo cateID
        Brands cate = brandsFacade.find(cateID);

        //Load thông tin subCategory theo subCateID;
        Categories subCate = categoriesFacade.find(subCateID);

        //Load List<productColors>
        List<ProductColors> productColorsList = new ArrayList<>();

        for (int i = 0; i < colorList.size(); i++) {
            ProductColors productColor = new ProductColors();
            productColor.setColor(colorList.get(i));
//            productColor.setColorNA(shareFunc.changeText(colorList.get(i)));
            productColor.setStatus((short) 1);
            productColor.setProductID(product);
//            productColor.setColorOrder(i);

            //setUrlColorImg
            MultipartFile colorImg = colorImgs.get(i);
            if (!colorImg.isEmpty()) {
                //set productColor UrlColorImg
                productColor.setUrlColorImg(simpleDateFormat.format(new Date()) + shareFunc.changeText(colorImg.getOriginalFilename())); //Tên hình

                //Luu file duong dan
                String path = app.getRealPath("/assets/images/products/colors/") + "/" + productColor.getUrlColorImg();
                try {
                    colorImg.transferTo(new File(path));
                } catch (IOException | IllegalStateException ex) {
                    Logger.getLogger(Product_Controller.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            //set List<SizeByColor>
            List<SizesByColor> sizeList = new ArrayList<>();
            if (i == 0) {
                List<String> sizeListFromClient = allRequestParams.get("size");
                for (int j = 0; j < sizeListFromClient.size(); j++) {
                    SizesByColor size = new SizesByColor();
                    size.setSize(sizeListFromClient.get(j).toUpperCase());
                    size.setQuantity(Integer.parseInt(allRequestParams.get("quantity").get(j)));
//                    size.setSizeOrder(j);
                    size.setStatus((short) 1);
                    size.setColorID(productColor);
                    sizeList.add(size);
                }
            } else {
                List<String> sizeListFromClient = allRequestParams.get("size_" + i);
                for (int j = 0; j < sizeListFromClient.size(); j++) {
                    SizesByColor size = new SizesByColor();
                    size.setSize(sizeListFromClient.get(j).toUpperCase());
                    size.setQuantity(Integer.parseInt(allRequestParams.get("quantity_" + i).get(j)));
//                    size.setSizeOrder(j);
                    size.setStatus((short) 1);
                    size.setColorID(productColor);
                    sizeList.add(size);
                }
            }
            productColor.setSizesByColorList(sizeList);

            //set List<ProductSubImg>
            List<ProductSubImgs> productSubImgsList = new ArrayList<>();
            List<MultipartFile> subImgsList;
            if (i == 0) {
                subImgsList = ((DefaultMultipartHttpServletRequest) request).getFiles("productSubImg[]");
            } else {
                subImgsList = ((DefaultMultipartHttpServletRequest) request).getFiles("productSubImg_" + i + "[]");
            }
            int k = 0;
            for (MultipartFile file : subImgsList) {

                ProductSubImgs psi = new ProductSubImgs();
                //set urlimg
                psi.setUrlImg(simpleDateFormat.format(new Date()) + shareFunc.changeText(file.getOriginalFilename()));
//                psi.setSubImgOrder(k);
                //Luu file vao duong dan
                String subImgPath = app.getRealPath("/assets/images/products/subImg/") + "/" + psi.getUrlImg();
                try {
                    file.transferTo(new File(subImgPath));
                } catch (IOException | IllegalStateException ex) {
                    Logger.getLogger(Product_Controller.class.getName()).log(Level.SEVERE, null, ex);
                }
                psi.setColorID(productColor);
                productSubImgsList.add(psi);
                k++;
            }
            productColor.setProductSubImgsList(productSubImgsList);

            productColorsList.add(productColor);
        }

        //Load Main IMG
        MultipartFile mainImgFile = ((DefaultMultipartHttpServletRequest) request).getFile("urlImg");
        if (mainImgFile.isEmpty()) {
            model.addAttribute("mainImgFileError", "Product Image cannot be empty!");
        } else {
            //set product urlImg
            product.setUrlImg(simpleDateFormat.format(new Date()) + shareFunc.changeText(mainImgFile.getOriginalFilename()));

            //luu file vào duong dan
            String path = app.getRealPath("/assets/images/products/") + "/" + product.getUrlImg();
            try {
                mainImgFile.transferTo(new File(path));
            } catch (IOException | IllegalStateException ex) {
                Logger.getLogger(Product_Controller.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        product.setBraID(cate);
        product.setCatID(subCate);
        product.setProductName(productName);
//        product.setProductNameNA(shareFunc.changeText(productName));
        product.setPrice(price);
        product.setProductDes(description);
//        product.setProductDiscount(discount);
        product.setPostedDate(new Date());
        product.setProductViews(0);
        product.setStatus((short) 1);
        product.setProductColorsList(productColorsList);

        if (productsFacade.createNewProduct(product)) {
            flashAttr.addFlashAttribute("error", "<div class=\"col-xs-12 col-sm-6 col-sm-offset-3 alert alert-success\">\n"
                    + "<strong>Success!</strong> Create New Product Successfully!.\n"
                    + "</div>");
        } else {
            flashAttr.addFlashAttribute("error", "<div class=\"col-xs-12 col-sm-6 col-sm-offset-3 alert alert-danger\">\n"
                    + "<strong>Error!</strong> Sorry error was happened, please try again!.\n"
                    + "</div>");
        }
        return "redirect:/admin/product/create.html";
    }

    @RequestMapping(value = "ajax/checkProductName", method = RequestMethod.POST)
    @ResponseBody
    public String checkProductName(
            @RequestParam(value = "productID", required = false) Integer productID,
            @RequestParam("productName") String productName) {
        if (productID != null) { //kiem tra update
            Products p = productsFacade.findProductByID(productID);
            if (productsFacade.checkDuplicateProductName(productName) && !productName.equalsIgnoreCase(p.getProductName())) {
                return "1"; //trung
            } else {
                return "0"; //OK
            }
        } else { //kiem tra create
            if (productsFacade.checkDuplicateProductName(productName)) {
                return "1"; //trung
            } else {
                return "0"; //chua ton tai
            }
        }
    }

    @RequestMapping(value = "ajax/changeProductStatus", method = RequestMethod.POST)
    @ResponseBody
    public void changeProductStatus(
            @RequestParam("newProductStatus") short newProductStatus,
            @RequestParam("productID") int productID) {
        productsFacade.updateProductStatus(productID, newProductStatus);
    }

    @RequestMapping(value = "ajax/getSubCategory", method = RequestMethod.POST)
    @ResponseBody
    public String getSubCategory(@RequestParam("cateID") Integer cateID) {
        Brands cate = brandsFacade.find(cateID);
        List<Categories> subCateList = cate.getCategoriesList();
        List<Properties> newList = new ArrayList<>();
        for (Categories sc : subCateList) {
            Properties prop = new Properties();
            prop.setProperty("subCateID", sc.getCatID().toString());
            prop.setProperty("subCateName", sc.getCatName());
            newList.add(prop);
        }
        ObjectMapper mapper = new ObjectMapper();
        String result = "";
        try {
            result = mapper.writeValueAsString(newList);
        } catch (JsonProcessingException ex) {
            Logger.getLogger(Product_Controller.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }

    
    //UPDATE
    @RequestMapping(value = "product/edit-{productID}")
    public String productUpdate(
            @PathVariable("productID") Integer productID,
            ModelMap model) {
        Products targetProduct = productsFacade.findProductByID(productID);
        model.addAttribute("targetProduct", targetProduct);
        Brands cate = brandsFacade.find(targetProduct.getBraID().getBraID());
        List<Categories> subCateListByCate = cate.getCategoriesList();
        model.addAttribute("productID", productID);
        model.addAttribute("firstColorID", targetProduct.getProductColorListWorking().get(0).getColorID());
        model.addAttribute("productNameNA", targetProduct.getProductName());
        model.addAttribute("subCateList", subCateListByCate);
        return "admin/pages/product-update";
    }

    @RequestMapping(value = "product/edit-general-info-{productID}", method = RequestMethod.POST)
    public String productEditGeneralInfo(
            @PathVariable("productID") Integer productID,
            @RequestParam("category") Integer categoryID,
            @RequestParam("subCategory") Integer subCategoryID,
            @RequestParam("productName") String productName,
            @RequestParam("price") Float price,
            @RequestParam("urlImg") MultipartFile urlImg,
            @RequestParam("description") String description,
            RedirectAttributes flashAttr
    ) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd_HH_mm_ss");
        Products targetProduct = productsFacade.findProductByID(productID);
        String oldImg = targetProduct.getUrlImg();
        if (targetProduct != null) {
            targetProduct.setBraID(brandsFacade.find(categoryID));
            targetProduct.setCatID(categoriesFacade.find(subCategoryID));
            targetProduct.setProductName(productName);
//            targetProduct.setProductNameNA(shareFunc.changeText(productName));
            targetProduct.setPrice(price);
//            targetProduct.setProductDiscount(discount);
            targetProduct.setProductDes(description);

            if (!urlImg.isEmpty()) {
                //Xoa old img trong folder
                String oldPath = app.getRealPath("/assets/images/products/") + "/" + oldImg;
                File oldFile = new File(oldPath);
                oldFile.delete();

                //Them file moi
                targetProduct.setUrlImg(simpleDateFormat.format(new Date()) + shareFunc.changeText(urlImg.getOriginalFilename()));

                //luu file vào duong dan
                String path = app.getRealPath("/assets/images/products/") + "/" + targetProduct.getUrlImg();
                try {
                    urlImg.transferTo(new File(path));
                } catch (IOException | IllegalStateException ex) {
                    Logger.getLogger(Product_Controller.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            if (productsFacade.updateProductGeneralInfo(targetProduct)) {
                flashAttr.addFlashAttribute("error", "<div class=\"alert alert-success\">\n"
                        + "                                                                               <strong>Success!</strong> Update Products Info Completed!.\n"
                        + "                                                                          </div>");
            } else {
                flashAttr.addFlashAttribute("error", "<div class=\"alert alert-danger\">\n"
                        + "                                                                               <strong>Error!</strong> Update Products Info FAIL!, Please try again!.\n"
                        + "                                                                          </div>");
            }
            return "redirect:/admin/product/edit-" + productID + ".html";
        } else {
            return "Ve Trang Loi";
        }

    }

    @RequestMapping(value = "ajax/updateProductColorStatus", method = RequestMethod.POST)
    @ResponseBody
    public String updateProductColorStatus(
            @RequestParam("colorID") Integer colorID,
            @RequestParam("newStt") Short newStt
    ) {
        if (productsFacade.updateProductColorStatus(colorID, newStt)) {
            return "1";
        } else {
            return "0";
        }
    }

    @RequestMapping(value = "ajax/getProductColorByID", method = RequestMethod.POST)
    @ResponseBody
    public String getProductColorByID(
            @RequestParam("colorID") Integer colorID
    ) {
        
        ProductColors color = productsFacade.getProductColorByID(colorID);

        ObjectMapper mapper = new ObjectMapper();
        String result = "";
        try {
            result = mapper.writeValueAsString(color);
        } catch (JsonProcessingException ex) {
            ex.printStackTrace();
        }

        return result;
    }

    @RequestMapping(value = "ajax/updateProductColor", method = RequestMethod.POST)
    @ResponseBody
    public String updateProductColor(
            @RequestParam("productID") Integer productID,
            @RequestParam("colorID") Integer colorID,
            @RequestParam("color") String color,
            @RequestParam(value = "colorImg", required = false) MultipartFile colorImg
    ) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd_HH_mm_ss");
        ProductColors targetColor = productsFacade.getProductColorByID(colorID);
        targetColor.setColor(color);
//        targetColor.setColorNA(shareFunc.changeText(color));

        if (colorImg != null) {
            if (!colorImg.isEmpty()) {
                //Xoa old img trong folder
                String oldPath = app.getRealPath("/assets/images/products/colors") + "/" + colorImg;
                File oldFile = new File(oldPath);
                oldFile.delete();

                //Them file moi
                targetColor.setUrlColorImg(simpleDateFormat.format(new Date()) + shareFunc.changeText(colorImg.getOriginalFilename()));

                //luu file vào duong dan
                String path = app.getRealPath("/assets/images/products/colors") + "/" + targetColor.getUrlColorImg();
                try {
                    colorImg.transferTo(new File(path));
                } catch (IOException | IllegalStateException ex) {
                    Logger.getLogger(Product_Controller.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }

        if (productsFacade.updateProductColor(targetColor)) {
            List<ProductColors> productColorsList = productsFacade.findProductByID(productID).getProductColorsList();
            String result = "";

            for (ProductColors c : productColorsList) {
                String chooseOpt = "";

                if (c.getStatus() == 0) {
                    chooseOpt += "<div class=\"fs-stopworking-icon-product-color-update\">\n"
                            + "       <i class=\"fa fa-minus-circle\" aria-hidden=\"true\"></i>\n"
                            + "   </div>\n"
                            + "   <select class=\"form-control fs-product-update-color-status\" fs-product-colorID=\"" + c.getColorID() + "\">\n"
                            + "        <option value=\"1\">\n"
                            + "            Working\n"
                            + "        </option>\n"
                            + "        <option value=\"0\" selected>\n"
                            + "            Stopped\n"
                            + "        </option>\n"
                            + "   </select>";
                } else {
                    chooseOpt += "<div class=\"fs-stopworking-icon-product-color-update fs-display-none\">\n"
                            + "       <i class=\"fa fa-minus-circle\" aria-hidden=\"true\"></i>\n"
                            + "   </div>\n"
                            + "   <select class=\"form-control fs-product-update-color-status\" fs-product-colorID=\"" + c.getColorID() + "\">\n"
                            + "        <option value=\"1\" selected>\n"
                            + "            Working\n"
                            + "        </option>\n"
                            + "        <option value=\"0\">\n"
                            + "            Stopped\n"
                            + "        </option>\n"
                            + "   </select>";
                }
                result += "<tr class=\"text-center\" fs-product-colorID=\"" + c.getColorID() + "\">\n"
                        + "   <td class=\"fs-valign-middle\">" + c.getColorID()+ "</td>\n"
                        + "   <td class=\"fs-valign-middle\">" + c.getColor() + "</td>\n"
                        + "   <td class=\"fs-valign-middle\">\n"
                        + "       <img style=\"width: 30px\" src=\"assets/images/products/colors/" + c.getUrlColorImg() + "\"/>\n"
                        + "   </td>\n"
                        + "   <td class=\"fs-valign-middle\" style=\"position: relative\">\n"
                        + chooseOpt
                        + "   </td>\n"
                        + "   <td class=\"fs-valign-middle\">\n"
                        + "       <button type=\"button\" class=\"btn btn-warning btn-edit-product-color\" fs-product-colorID=\"" + c.getColorID() + "\">\n"
                        + "           <i class=\"fa fa-wrench\" aria-hidden=\"true\"></i> Edit\n"
                        + "       </button>\n"
                        + "   </td>\n"
                        + "</tr>";
            }
            return result;
        } else {
            return "fail";
        }
    }

    @RequestMapping(value = "ajax/updateColorOrder", method = RequestMethod.POST)
    @ResponseBody
    public void updateColorOrder(
            @RequestParam("colorID") Integer colorID,
            @RequestParam("position") Integer position
    ) {
        ProductColors targetColor = productsFacade.getProductColorByID(colorID);
//        targetColor.setColorOrder(position);

        productsFacade.updateProductColor(targetColor);
    }

    @RequestMapping(value = "ajax/getColorList", method = RequestMethod.POST)
    @ResponseBody
    public String getColorList(
            @RequestParam("productID") Integer productID
    ) {
        List<ProductColors> productColorsList = productsFacade.findProductByID(productID).getProductColorsList();
        String result = "";

        for (ProductColors c : productColorsList) {
            String chooseOpt = "";

            if (c.getStatus() == 0) {
                chooseOpt += "<div class=\"fs-stopworking-icon-product-color-update\">\n"
                        + "       <i class=\"fa fa-minus-circle\" aria-hidden=\"true\"></i>\n"
                        + "   </div>\n"
                        + "   <select class=\"form-control fs-product-update-color-status\" fs-product-colorID=\"" + c.getColorID() + "\">\n"
                        + "        <option value=\"1\">\n"
                        + "            Working\n"
                        + "        </option>\n"
                        + "        <option value=\"0\" selected>\n"
                        + "            Stopped\n"
                        + "        </option>\n"
                        + "   </select>";
            } else {
                chooseOpt += "<div class=\"fs-stopworking-icon-product-color-update fs-display-none\">\n"
                        + "       <i class=\"fa fa-minus-circle\" aria-hidden=\"true\"></i>\n"
                        + "   </div>\n"
                        + "   <select class=\"form-control fs-product-update-color-status\" fs-product-colorID=\"" + c.getColorID() + "\">\n"
                        + "        <option value=\"1\" selected>\n"
                        + "            Working\n"
                        + "        </option>\n"
                        + "        <option value=\"0\">\n"
                        + "            Stopped\n"
                        + "        </option>\n"
                        + "   </select>";
            }
            result += "<tr class=\"text-center\" fs-product-colorID=\"" + c.getColorID() + "\">\n"
                    
                    + "   <td class=\"fs-valign-middle\">" + c.getColor() + "</td>\n"
                    + "   <td class=\"fs-valign-middle\">\n"
                    + "       <img style=\"width: 30px\" src=\"assets/images/products/colors/" + c.getUrlColorImg() + "\"/>\n"
                    + "   </td>\n"
                    + "   <td class=\"fs-valign-middle\" style=\"position: relative\">\n"
                    + chooseOpt
                    + "   </td>\n"
                    + "   <td class=\"fs-valign-middle\">\n"
                    + "       <button type=\"button\" class=\"btn btn-warning btn-edit-product-color\" fs-product-colorID=\"" + c.getColorID() + "\">\n"
                    + "           <i class=\"fa fa-wrench\" aria-hidden=\"true\"></i> Edit\n"
                    + "       </button>\n"
                    + "   </td>\n"
                    + "</tr>";
        }
        return result;

    }

    @RequestMapping(value = "ajax/checkDuplicateColor.html", method = RequestMethod.POST)
    @ResponseBody
    public String checkDuplicateColor(
            @RequestParam("productID") Integer productID,
            @RequestParam("color") String color,
            @RequestParam("colorID") Integer colorID
    ) {
        ProductColors currentColor = productsFacade.getProductColorByID(colorID);
        String currentColorName = currentColor.getColor();
        List<ProductColors> productColorsList = productsFacade.findProductByID(productID).getProductColorsList();

        for (ProductColors c : productColorsList) {
            if (c.getColor().equalsIgnoreCase(color) && !color.equalsIgnoreCase(currentColorName)) {
                return "1";
            }
        }

        return "0";
    }

    @RequestMapping(value = "ajax/checkDuplicateColorInProduct.html", method = RequestMethod.POST)
    @ResponseBody
    public String checkDuplicateColorInProduct(
            @RequestParam("productID") Integer productID,
            @RequestParam("color") String color
    ) {
        List<ProductColors> alist = productsFacade.getProductColorsListOfAProductByName(productID, color);

        if (alist.size() > 0) { // trùng
            return "1";
        } else {
            return "0";
        }
    }

    @RequestMapping(value = "ajax/updateSubImgOrder", method = RequestMethod.POST)
    @ResponseBody
    public void updateSubImgOrder(
            @RequestParam("productSubImgID") Integer productSubImgID,
            @RequestParam("position") Integer position
    ) {
        ProductSubImgs targetSubImg = productsFacade.getProductSubImgByID(productSubImgID);
//        targetSubImg.setSubImgOrder(position);

        productsFacade.updateProductSubImg(targetSubImg);
    }

    @RequestMapping(value = "ajax/getSubImgListByColor", method = RequestMethod.POST)
    @ResponseBody
    public String getSubImgListByColor(
            @RequestParam("colorID") Integer colorID
    ) {
        List<ProductSubImgs> subImgsList = productsFacade.findProductColorByColorID(colorID).getProductSubImgsList();
        String result = "";
        for (ProductSubImgs si : subImgsList) {
            result += "<tr class=\"text-center\" fs-productSubImgID=\"" + si.getSubImgID() + "\">\n"
                    + "   <td class=\"fs-valign-middle\">" + si.getSubImgID()+ "</td>\n"
                    + "    <td class=\"fs-valign-middle fs-update-sub-img-change-image-here\">\n"
                    + "        <img src=\"assets/images/products/subImg/" + si.getUrlImg() + "\" style=\"width: 80px\"/>\n"
                    + "    </td>\n"
                    + "    <td class=\"fs-valign-middle\">\n"
                    + "        <input type=\"file\" name=\"fs-update-product-sub-img\" class=\"fs-update-product-sub-img\" disabled/>\n"
                    + "        <p class=\"help-block fs-update-product-sub-img-error-mes\"></p>\n"
                    + "    </td>\n"
                    + "    <td class=\"fs-valign-middle\">\n"
                    + "        <button type=\"button\" class=\"btn btn-warning fs-btn-edit-product-sub-img-form\">\n"
                    + "            <i class=\"fa fa-wrench\" aria-hidden=\"true\"></i> Edit\n"
                    + "        </button>\n"
                    + "        <button type=\"button\" class=\"btn btn-danger fs-btn-delete-product-sub-img\">\n"
                    + "            <i class=\"fa fa-close\" aria-hidden=\"true\"></i> Delete\n"
                    + "        </button>\n"
                    + "    </td>\n"
                    + "</tr>";
        }

        return result;
    }

    @RequestMapping(value = "ajax/changeSubImg", method = RequestMethod.POST)
    @ResponseBody
    public String changeSubImg(
            @RequestParam("subImgID") Integer subImgID,
            @RequestParam("newImg") MultipartFile newImg
    ) {
        ProductSubImgs targetSubImg = productsFacade.getProductSubImgByID(subImgID);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd_HH_mm_ss");
        if (!newImg.isEmpty()) {
            //Xoa old img trong folder
            String oldPath = app.getRealPath("/assets/images/products/subImg") + "/" + targetSubImg.getUrlImg();
            File oldFile = new File(oldPath);
            oldFile.delete();

            //Them file moi
            targetSubImg.setUrlImg(simpleDateFormat.format(new Date()) + shareFunc.changeText(newImg.getOriginalFilename()));

            //luu file vào duong dan
            String path = app.getRealPath("/assets/images/products/subImg") + "/" + targetSubImg.getUrlImg();
            try {
                newImg.transferTo(new File(path));
            } catch (IOException | IllegalStateException ex) {
                Logger.getLogger(Product_Controller.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        if (productsFacade.updateProductSubImg(targetSubImg)) {
            return targetSubImg.getUrlImg();
        } else {
            return "fail";
        }
    }

    @RequestMapping(value = "ajax/deleteProductSubImg", method = RequestMethod.POST)
    @ResponseBody
    public String deleteProductSubImg(
            @RequestParam("subImgID") Integer subImgID,
            @RequestParam("colorID") Integer colorID
    ) {
        int err = productsFacade.deleteProductSubImg(subImgID);
        if (err == 0) {
            List<ProductSubImgs> subImgsList = productsFacade.findProductColorByColorID(colorID).getProductSubImgsList();
            String result = "Nothing to Show!";
            for (ProductSubImgs si : subImgsList) {
                result += "<tr class=\"text-center\" fs-productSubImgID=\"" + si.getSubImgID() + "\">\n"
                        + "   <td class=\"fs-valign-middle\">" + si.getSubImgID()+ "</td>\n"
                        + "    <td class=\"fs-valign-middle fs-update-sub-img-change-image-here\">\n"
                        + "        <img src=\"assets/images/products/subImg/" + si.getUrlImg() + "\" style=\"width: 80px\"/>\n"
                        + "    </td>\n"
                        + "    <td class=\"fs-valign-middle\">\n"
                        + "        <input type=\"file\" name=\"fs-update-product-sub-img\" class=\"fs-update-product-sub-img\" disabled/>\n"
                        + "        <p class=\"help-block fs-update-product-sub-img-error-mes\"></p>\n"
                        + "    </td>\n"
                        + "    <td class=\"fs-valign-middle\">\n"
                        + "        <button type=\"button\" class=\"btn btn-warning fs-btn-edit-product-sub-img-form\">\n"
                        + "            <i class=\"fa fa-wrench\" aria-hidden=\"true\"></i> Edit\n"
                        + "        </button>\n"
                        + "        <button type=\"button\" class=\"btn btn-danger fs-btn-delete-product-sub-img\">\n"
                        + "            <i class=\"fa fa-close\" aria-hidden=\"true\"></i> Delete\n"
                        + "        </button>\n"
                        + "    </td>\n"
                        + "</tr>";
            }

            return result;
        } else if (err == 1) {
            return "1"; //Không tìm ra img
        } else {
            return "2"; //Lỗi trong quá trình xóa
        }
    }

    @RequestMapping(value = "ajax/changeProductSize", method = RequestMethod.POST)
    @ResponseBody
    public String changeProductSize(
            @RequestParam("name") String prodSize,
            @RequestParam("pk") Integer sizeID,
            @RequestParam("value") String newSize
    ) {
        SizesByColor targetSize = productsFacade.getSizeByID(sizeID);
        ProductColors colorOfSize = targetSize.getColorID();
        List<SizesByColor> sizeList = colorOfSize.getSizesByColorList();
        for (SizesByColor s : sizeList) {
            if (s.getSize().equalsIgnoreCase(newSize) && !newSize.equalsIgnoreCase(targetSize.getSize())) {
                return "2";
            }
        }

        targetSize.setSize(newSize.toUpperCase());

        if (productsFacade.updateSize(targetSize)) {
            return "0";
        } else {
            return "1";
        }
    }

    @RequestMapping(value = "ajax/changeProductQuantity", method = RequestMethod.POST)
    @ResponseBody
    public String changeProductQuantity(
            @RequestParam("pk") Integer sizeID,
            @RequestParam("value") Integer newQuantity
    ) {
        SizesByColor targetSize = productsFacade.getSizeByID(sizeID);

        targetSize.setQuantity(newQuantity);

        if (productsFacade.updateSize(targetSize)) {
            return "0";
        } else {
            return "1";
        }
    }

    @RequestMapping(value = "ajax/deleteProductSize", method = RequestMethod.POST)
    @ResponseBody
    public String deleteProductSize(
            @RequestParam("sizeID") Integer sizeID,
            @RequestParam("colorID") Integer colorID
    ) {
        int err = productsFacade.deleteProductSize(sizeID);
        if (err == 0) {
            List<SizesByColor> SizesList = productsFacade.findProductColorByColorID(colorID).getSizesByColorList();
            String result = "Nothing to Show!";
            for (SizesByColor si : SizesList) {
                String sltb = "";
                if (si.getStatus() == 0) {
                    sltb += " <div class=\"fs-stopworking-icon-product-color-update\">\n"
                            + "    <i class=\"fa fa-minus-circle\" aria-hidden=\"true\"></i>\n"
                            + " </div>\n"
                            + " <select class=\"form-control fs-product-update-size-status\" fs-size-id=\"" + si.getSizeID() + "\">\n"
                            + "       <option value=\"0\" selected>\n"
                            + "               Stopped\n"
                            + "       </option>\n"
                            + "       <option value=\"1\">\n"
                            + "               Working\n"
                            + "       </option>\n"
                            + " </select>\n";
                } else {
                    sltb += " <div class=\"fs-stopworking-icon-product-color-update fs-display-none\">\n"
                            + "    <i class=\"fa fa-minus-circle\" aria-hidden=\"true\"></i>\n"
                            + " </div>\n"
                            + " <select class=\"form-control fs-product-update-size-status\" fs-size-id=\"" + si.getSizeID() + "\">\n"
                            + "       <option value=\"0\">\n"
                            + "               Stopped\n"
                            + "       </option>\n"
                            + "       <option value=\"1\" selected>\n"
                            + "               Working\n"
                            + "       </option>\n"
                            + " </select>\n";
                }

                String btn = "";
                if (si.getOrdersDetailList().size() > 0) {
                    btn += "<button type=\"button\" \n"
                            + "    fs-size-id=\"" + si.getSizeID() + "\"\n"
                            + "    fs-size=\"" + si.getSize()+ "\"\n"
                            + "    class=\"btn btn-danger fs-update-product-button-delete-size\" disabled>\n"
                            + "    <i class=\"fa fa-close\" aria-hidden=\"true\"></i> Delete\n"
                            + "    </button>";
                } else {
                    btn += "<button type=\"button\" \n"
                            + "     fs-size-id=\"" + si.getSizeID() + "\"\n"
                            + "     fs-size=\"" + si.getSize()+ "\"\n"
                            + "     class=\"btn btn-danger fs-update-product-button-delete-size\">\n"
                            + "     <i class=\"fa fa-close\" aria-hidden=\"true\"></i> Delete\n"
                            + "  </button>\n";
                }

                result += "<tr class=\"text-center\">\n"
                        + "    <td class=\"fs-valign-middle\">\n"
                        + "         <span class=\"fs-edit-product-size-val\" data-type=\"text\" \n"
                        + "               data-pk=\"" + si.getSizeID() + "\" data-url=\"admin/ajax/changeProductSize.html\" \n"
                        + "               data-title=\"Enter New Size\" data-name=\"productSize\">\n"
                        + "               " + si.getSize()+ "\n"
                        + "         </span>\n"
                        + "    </td>\n"
                        + "    <td class=\"fs-valign-middle\">\n"
                        + "        <span class=\"fs-edit-product-quantity-val\" data-type=\"text\" \n"
                        + "              data-pk=\"" + si.getSizeID() + "\" data-url=\"admin/ajax/changeProductQuantity.html\" \n"
                        + "              data-title=\"Enter New Quantity\" data-name=\"quantity\">\n"
                        + "             " + si.getQuantity() + "\n"
                        + "         </span>\n"
                        + "     </td>\n"
                        + "     <td class=\"fs-valign-middle\" style=\"position: relative\">\n"
                        + sltb
                        + "     </td>\n"
                        + "     <td class=\"fs-valign-middle\">\n"
                        + btn
                        + "     </td>\n"
                        + " </tr>";
            }

            return result;
        } else if (err == 1) {
            return "1";//Không tìm thấy SIZE
        } else {
            return "2"; //Quá trình xóa lỗi
        }
    }

    @RequestMapping(value = "ajax/changeSizeStatus", method = RequestMethod.POST)
    @ResponseBody
    public String changeSizeStatus(
            @RequestParam("sizeID") Integer sizeID,
            @RequestParam("newSTT") Short newSTT
    ) {
        SizesByColor targetSize = productsFacade.getSizeByID(sizeID);
        targetSize.setStatus(newSTT);

        if (productsFacade.updateSize(targetSize)) {
            return "1";
        } else {
            return "0";
        }
    }

    @RequestMapping(value = "createNewProductColor", method = RequestMethod.POST)
    public String createNewProductColor(
            @RequestParam("productID") Integer productID,
            @RequestParam("fs-update-input-add-more-color") String color,
            @RequestParam("fs-update-input-add-color-img") MultipartFile colorImg,
            @RequestParam("size") List<String> size,
            @RequestParam("quantity") List<Integer> quantity,
            @RequestParam("fs-update-input-add-sub-img-in-add-more-color[]") List<MultipartFile> prodSubImg,
            RedirectAttributes flashAttr
    ) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd_HH_mm_ss");
        Products targetProduct = productsFacade.findProductByID(productID);
        targetProduct.getProductColorsList().size();
        ProductColors newColor = new ProductColors();
        newColor.setColor(color);
//        newColor.setColorNA(shareFunc.changeText(color));
        newColor.setProductID(targetProduct);
        newColor.setStatus((short) 1);
//        newColor.setColorOrder(targetProduct.getProductColorsList().size());

        //set productColor UrlColorImg
        newColor.setUrlColorImg(simpleDateFormat.format(new Date()) + shareFunc.changeText(colorImg.getOriginalFilename())); //Tên hình

        //Luu file duong dan
        String path = app.getRealPath("/assets/images/products/colors/") + "/" + newColor.getUrlColorImg();
        try {
            colorImg.transferTo(new File(path));
        } catch (IOException | IllegalStateException ex) {
            Logger.getLogger(Product_Controller.class.getName()).log(Level.SEVERE, null, ex);
        }
        List<SizesByColor> sizeList = new ArrayList<>();
        int sizeOrder = 0;
        for (String s : size) {
            SizesByColor newSize = new SizesByColor();
            newSize.setSize(s.toUpperCase());
            newSize.setQuantity(quantity.get(sizeOrder));
//            newSize.setSizeOrder(sizeOrder);
            newSize.setStatus((short) 1);
            newSize.setColorID(newColor);
            sizeList.add(newSize);
            sizeOrder++;
        }
        newColor.setSizesByColorList(sizeList);
        List<ProductSubImgs> productSubImgsList = new ArrayList<>();
        int k = 0;
        for (MultipartFile file : prodSubImg) {
            ProductSubImgs psi = new ProductSubImgs();
            //set urlimg
            psi.setUrlImg(simpleDateFormat.format(new Date()) + shareFunc.changeText(file.getOriginalFilename()));
//            psi.setSubImgOrder(k);
            //Luu file vao duong dan
            String subImgPath = app.getRealPath("/assets/images/products/subImg/") + "/" + psi.getUrlImg();
            try {
                file.transferTo(new File(subImgPath));
            } catch (IOException | IllegalStateException ex) {
                Logger.getLogger(Product_Controller.class.getName()).log(Level.SEVERE, null, ex);
            }
            psi.setColorID(newColor);
            productSubImgsList.add(psi);
            k++;
        }
        newColor.setProductSubImgsList(productSubImgsList);

        if (productsFacade.createNewProductColor(newColor)) {
            flashAttr.addFlashAttribute("error", "<div class=\"alert alert-success\">\n"
                    + "<strong>Success!</strong> Create New Color completed!.\n"
                    + "</div>");
        } else {
            flashAttr.addFlashAttribute("error", "<div class=\"alert alert-danger\">\n"
                    + "<strong>Danger!</strong> Error was happened!.\n"
                    + "</div>");
        }

        return "redirect:/admin/product/edit-" + productID + ".html";
    }

    @RequestMapping(value = "ajax/addNewProductSubImage", method = RequestMethod.POST)
    @ResponseBody
    public String addNewProductSubImage(
            @RequestParam("colorID") Integer colorID,
            @RequestParam("newImg") MultipartFile newImg
    ) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd_HH_mm_ss");
        ProductSubImgs newSubImg = new ProductSubImgs();
        ProductColors color = productsFacade.findProductColorByColorID(colorID);
        newSubImg.setColorID(color);
//        newSubImg.setSubImgOrder(color.getProductSubImgsList().size());

        //set productColor UrlColorImg
        newSubImg.setUrlImg(simpleDateFormat.format(new Date()) + shareFunc.changeText(newImg.getOriginalFilename())); //Tên hình

        //Luu file duong dan
        String path = app.getRealPath("/assets/images/products/subImg/") + "/" + newSubImg.getUrlImg();
        try {
            newImg.transferTo(new File(path));
        } catch (IOException | IllegalStateException ex) {
            Logger.getLogger(Product_Controller.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (productsFacade.addProductSubImage(newSubImg)) {
            List<ProductSubImgs> subImgsList = productsFacade.findProductColorByColorID(colorID).getProductSubImgsList();
            String result = "";
            for (ProductSubImgs si : subImgsList) {
                result += "<tr class=\"text-center\" fs-productSubImgID=\"" + si.getSubImgID() + "\">\n"
                        
                        + "    <td class=\"fs-valign-middle fs-update-sub-img-change-image-here\">\n"
                        + "        <img src=\"assets/images/products/subImg/" + si.getUrlImg() + "\" style=\"width: 80px\"/>\n"
                        + "    </td>\n"
                        + "    <td class=\"fs-valign-middle\">\n"
                        + "        <input type=\"file\" name=\"fs-update-product-sub-img\" class=\"fs-update-product-sub-img\" disabled/>\n"
                        + "        <p class=\"help-block fs-update-product-sub-img-error-mes\"></p>\n"
                        + "    </td>\n"
                        + "    <td class=\"fs-valign-middle\">\n"
                        + "        <button type=\"button\" class=\"btn btn-warning fs-btn-edit-product-sub-img-form\">\n"
                        + "            <i class=\"fa fa-wrench\" aria-hidden=\"true\"></i> Edit\n"
                        + "        </button>\n"
                        + "        <button type=\"button\" class=\"btn btn-danger fs-btn-delete-product-sub-img\">\n"
                        + "            <i class=\"fa fa-close\" aria-hidden=\"true\"></i> Delete\n"
                        + "        </button>\n"
                        + "    </td>\n"
                        + "</tr>";
            }
            return result; //thành công
        } else {
            return "1"; // lỗi
        }

    }

    @RequestMapping(value = "ajax/addProductSize", method = RequestMethod.POST)
    @ResponseBody
    public String addProductSize(
            @RequestParam("colorID") Integer colorID,
            @RequestParam("size") String size,
            @RequestParam("quantity") Integer quantity
    ) {
        ProductColors color = productsFacade.findProductColorByColorID(colorID);
        SizesByColor newSize = new SizesByColor();
        newSize.setSize(size.toUpperCase());
        newSize.setQuantity(quantity);
//        newSize.setSizeOrder(color.getSizeList().size());
        newSize.setColorID(color);
        newSize.setStatus((short) 1);

        if (productsFacade.addSize(newSize)) {
            String result = "";
            List<SizesByColor> sizeList = productsFacade.getProductColorByID(colorID).getSizesByColorList();
            for (SizesByColor si : sizeList) {
                String sltb = "";
                if (si.getStatus() == 0) {
                    sltb += " <div class=\"fs-stopworking-icon-product-color-update\">\n"
                            + "    <i class=\"fa fa-minus-circle\" aria-hidden=\"true\"></i>\n"
                            + " </div>\n"
                            + " <select class=\"form-control fs-product-update-size-status\" fs-size-id=\"" + si.getSizeID() + "\">\n"
                            + "       <option value=\"0\" selected>\n"
                            + "               Stopped\n"
                            + "       </option>\n"
                            + "       <option value=\"1\">\n"
                            + "               Working\n"
                            + "       </option>\n"
                            + " </select>\n";
                } else {
                    sltb += " <div class=\"fs-stopworking-icon-product-color-update fs-display-none\">\n"
                            + "    <i class=\"fa fa-minus-circle\" aria-hidden=\"true\"></i>\n"
                            + " </div>\n"
                            + " <select class=\"form-control fs-product-update-size-status\" fs-size-id=\"" + si.getSizeID() + "\">\n"
                            + "       <option value=\"0\">\n"
                            + "               Stopped\n"
                            + "       </option>\n"
                            + "       <option value=\"1\" selected>\n"
                            + "               Working\n"
                            + "       </option>\n"
                            + " </select>\n";
                }

                String btn = "";
                if (si.getOrdersDetailList().size() > 0) {
                    btn += "<button type=\"button\" \n"
                            + "    fs-size-id=\"" + si.getSizeID() + "\"\n"
                            + "    fs-size=\"" + si.getSize()+ "\"\n"
                            + "    class=\"btn btn-danger fs-update-product-button-delete-size\" disabled>\n"
                            + "    <i class=\"fa fa-close\" aria-hidden=\"true\"></i> Delete\n"
                            + "    </button>";
                } else {
                    btn += "<button type=\"button\" \n"
                            + "     fs-size-id=\"" + si.getSizeID() + "\"\n"
                            + "     fs-size=\"" + si.getSize()+ "\"\n"
                            + "     class=\"btn btn-danger fs-update-product-button-delete-size\">\n"
                            + "     <i class=\"fa fa-close\" aria-hidden=\"true\"></i> Delete\n"
                            + "  </button>\n";
                }

                result += "<tr class=\"text-center\">\n"
                        + "    <td class=\"fs-valign-middle\">\n"
                        + "         <span class=\"fs-edit-product-size-val\" data-type=\"text\" \n"
                        + "               data-pk=\"" + si.getSizeID() + "\" data-url=\"admin/ajax/changeProductSize.html\" \n"
                        + "               data-title=\"Enter New Size\" data-name=\"productSize\">\n"
                        + "               " + si.getSize()+ "\n"
                        + "         </span>\n"
                        + "    </td>\n"
                        + "    <td class=\"fs-valign-middle\">\n"
                        + "        <span class=\"fs-edit-product-quantity-val\" data-type=\"text\" \n"
                        + "              data-pk=\"" + si.getSizeID() + "\" data-url=\"admin/ajax/changeProductQuantity.html\" \n"
                        + "              data-title=\"Enter New Quantity\" data-name=\"quantity\">\n"
                        + "             " + si.getQuantity() + "\n"
                        + "         </span>\n"
                        + "     </td>\n"
                        + "     <td class=\"fs-valign-middle\" style=\"position: relative\">\n"
                        + sltb
                        + "     </td>\n"
                        + "     <td class=\"fs-valign-middle\">\n"
                        + btn
                        + "     </td>\n"
                        + " </tr>";
            }

            return result;
        } else {
            return "1"; //error
        }
    }

    @RequestMapping(value = "ajax/updateSizeOrder", method = RequestMethod.POST)
    @ResponseBody
    public void updateSizeOrder(
            @RequestParam("sizeID") Integer sizeID,
            @RequestParam("position") Integer position
    ) {
        SizesByColor targetSize = productsFacade.getSizeByID(sizeID);
//        targetSize.setSizeOrder(position);

        productsFacade.updateSize(targetSize);
    }

    @RequestMapping(value = "ajax/getSizeListByColor", method = RequestMethod.POST)
    @ResponseBody
    public String getSizeListByColor(
            @RequestParam("colorID") Integer colorID
    ) {
        String result = "";
        List<SizesByColor> sizeList = productsFacade.getProductColorByID(colorID).getSizesByColorList();
        for (SizesByColor si : sizeList) {
            String sltb = "";
            if (si.getStatus() == 0) {
                sltb += " <div class=\"fs-stopworking-icon-product-color-update\">\n"
                        + "    <i class=\"fa fa-minus-circle\" aria-hidden=\"true\"></i>\n"
                        + " </div>\n"
                        + " <select class=\"form-control fs-product-update-size-status\" fs-size-id=\"" + si.getSizeID() + "\">\n"
                        + "       <option value=\"0\" selected>\n"
                        + "               Stopped\n"
                        + "       </option>\n"
                        + "       <option value=\"1\">\n"
                        + "               Working\n"
                        + "       </option>\n"
                        + " </select>\n";
            } else {
                sltb += " <div class=\"fs-stopworking-icon-product-color-update fs-display-none\">\n"
                        + "    <i class=\"fa fa-minus-circle\" aria-hidden=\"true\"></i>\n"
                        + " </div>\n"
                        + " <select class=\"form-control fs-product-update-size-status\" fs-size-id=\"" + si.getSizeID() + "\">\n"
                        + "       <option value=\"0\">\n"
                        + "               Stopped\n"
                        + "       </option>\n"
                        + "       <option value=\"1\" selected>\n"
                        + "               Working\n"
                        + "       </option>\n"
                        + " </select>\n";
            }

            String btn = "";
            if (si.getOrdersDetailList().size() > 0) {
                btn += "<button type=\"button\" \n"
                        + "    fs-size-id=\"" + si.getSizeID() + "\"\n"
                        + "    fs-size=\"" + si.getSize()+ "\"\n"
                        + "    class=\"btn btn-danger fs-update-product-button-delete-size\" disabled>\n"
                        + "    <i class=\"fa fa-close\" aria-hidden=\"true\"></i> Delete\n"
                        + "    </button>";
            } else {
                btn += "<button type=\"button\" \n"
                        + "     fs-size-id=\"" + si.getSizeID() + "\"\n"
                        + "     fs-size=\"" + si.getSize()+ "\"\n"
                        + "     class=\"btn btn-danger fs-update-product-button-delete-size\">\n"
                        + "     <i class=\"fa fa-close\" aria-hidden=\"true\"></i> Delete\n"
                        + "  </button>\n";
            }

            result += "<tr class=\"text-center\">\n"
                    + "    <td class=\"fs-valign-middle\">\n"
                    + "         <span class=\"fs-edit-product-size-val\" data-type=\"text\" \n"
                    + "               data-pk=\"" + si.getSizeID() + "\" data-url=\"admin/ajax/changeProductSize.html\" \n"
                    + "               data-title=\"Enter New Size\" data-name=\"productSize\">\n"
                    + "               " + si.getSize()+ "\n"
                    + "         </span>\n"
                    + "    </td>\n"
                    + "    <td class=\"fs-valign-middle\">\n"
                    + "        <span class=\"fs-edit-product-quantity-val\" data-type=\"text\" \n"
                    + "              data-pk=\"" + si.getSizeID() + "\" data-url=\"admin/ajax/changeProductQuantity.html\" \n"
                    + "              data-title=\"Enter New Quantity\" data-name=\"quantity\">\n"
                    + "             " + si.getQuantity() + "\n"
                    + "         </span>\n"
                    + "     </td>\n"
                    + "     <td class=\"fs-valign-middle\" style=\"position: relative\">\n"
                    + sltb
                    + "     </td>\n"
                    + "     <td class=\"fs-valign-middle\">\n"
                    + btn
                    + "     </td>\n"
                    + " </tr>";
        }

        return result;
    }
    
    @ModelAttribute("brands")
    public List<Brands> getAllCategory() {
        return brandsFacade.findAll();
    }
    
    @ResponseBody
    @RequestMapping(value = "/ajax/findProduct", method = RequestMethod.POST)
    public String getProductByID(@RequestParam("productID") Integer productID) {
        Products targetProduct = productsFacade.findProductByID(productID);

        try {
            ObjectMapper mapper = new ObjectMapper();
            String result = mapper.writeValueAsString(targetProduct);
            return result;
        } catch (Exception e) {
            return "Error!" + e.getMessage();
        }

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

    private BrandsFacadeLocal lookupBrandsFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (BrandsFacadeLocal) c.lookup("java:global/ShoeGardenPJ/BrandsFacade!spring.ejb.BrandsFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    private CategoriesFacadeLocal lookupCategoriesFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (CategoriesFacadeLocal) c.lookup("java:global/ShoeGardenPJ/CategoriesFacade!spring.ejb.CategoriesFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }
}
