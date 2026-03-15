package com.verify;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/studentLoginVerifier")
public class VerifyStudent extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String rollNumber = request.getParameter("roll_number");
        String password   = request.getParameter("password"); // password = contact_number in DB

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/studentrecords", "root", "Kadalamuttai@143");

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM Student WHERE roll_number=? AND contact_number=?");
            ps.setString(1, rollNumber);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("roll_number",  rs.getString("roll_number"));
                session.setAttribute("student_name", rs.getString("student_name"));
                session.setAttribute("grade",        rs.getString("grade"));
                session.setAttribute("section",      rs.getString("section"));

                // ✅ Fixed — capital S matches actual filename
                request.getRequestDispatcher("StudentFeatures.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Invalid Roll Number or Contact Number!");
                request.getRequestDispatcher("CommonLoginError.jsp").forward(request, response);
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        }
    }
}