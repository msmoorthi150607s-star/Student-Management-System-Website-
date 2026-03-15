package com.verify;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/staffVerifier")
public class staffVerifier extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String staffIdStr = request.getParameter("staff_id");
        String password   = request.getParameter("password");

        if (staffIdStr == null || staffIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Staff ID cannot be empty!");
            request.getRequestDispatcher("CommonLoginError.jsp").forward(request, response);
            return;
        }

        try {
            int staffId = Integer.parseInt(staffIdStr);

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/studentrecords", "root", "Kadalamuttai@143");

            // password field in form = staff_id entered again
            // so we check: staff_id matches AND password == staff_id
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM Staff WHERE staff_id = ?");
            ps.setInt(1, staffId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                // password check — staff_id itself is the password
                String enteredPassword = password.trim();
                String actualPassword  = String.valueOf(staffId);

                if (!enteredPassword.equals(actualPassword)) {
                    request.setAttribute("errorMessage", "Invalid Staff ID or Password!");
                    request.getRequestDispatcher("CommonLoginError.jsp").forward(request, response);
                    con.close();
                    return;
                }

                HttpSession session = request.getSession();
                session.setAttribute("staff_id",   rs.getInt("staff_id"));
                session.setAttribute("staff_name", rs.getString("staff_name"));
                session.setAttribute("staff_role", rs.getString("role"));
                session.setAttribute("department", rs.getString("department"));

                request.getRequestDispatcher("StaffFeatures.jsp").forward(request, response);

            } else {
                request.setAttribute("errorMessage", "Invalid Staff ID or Password!");
                request.getRequestDispatcher("CommonLoginError.jsp").forward(request, response);
            }

            con.close();

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Staff ID must be a valid number!");
            request.getRequestDispatcher("CommonLoginError.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}