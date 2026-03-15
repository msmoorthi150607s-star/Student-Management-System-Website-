package com.staffModel;

import com.adminModel.Staff;
import java.sql.*;

public class StaffDAO {

    private static final String URL      = "jdbc:mysql://localhost:3306/studentrecords";
    private static final String USER     = "root";
    private static final String PASSWORD = "Kadalamuttai@143";

    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // ══════════════════════════════════
    // Get staff by ID
    // Used for all 3 features —
    // profile, attendance, salary
    // ══════════════════════════════════
    public Staff getStaffById(int staffId) {
        Staff staff = null;
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM Staff WHERE staff_id = ?");
            ps.setInt(1, staffId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                staff = new Staff(
                    rs.getInt("staff_id"),
                    rs.getString("staff_name"),
                    rs.getString("role"),
                    rs.getString("department"),
                    rs.getInt("age"),
                    rs.getDouble("salary"),
                    rs.getInt("attendance")
                );
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return staff;
    }
}