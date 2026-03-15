package com.verify;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/adminLogin")
public class VerifyLogin extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String userOrEmail = req.getParameter("userOrEmail");
        String password    = req.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/studentrecords", "root", "Kadalamuttai@143");

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM Admins WHERE (username=? OR email=?) AND password=?");
            ps.setString(1, userOrEmail);
            ps.setString(2, userOrEmail);
            ps.setString(3, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = req.getSession();

                // ✅ All keys match AdminFeatures.jsp exactly
                session.setAttribute("uname", rs.getString("username"));
                session.setAttribute("email", rs.getString("email"));
                session.setAttribute("role",  rs.getString("role"));

                req.getRequestDispatcher("AdminFeatures.jsp").forward(req, res);
            } else {
                req.setAttribute("errorMessage", "Invalid Username/Email or Password!");
                req.getRequestDispatcher("CommonLoginError.jsp").forward(req, res);
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace(res.getWriter());
        }
    }
}