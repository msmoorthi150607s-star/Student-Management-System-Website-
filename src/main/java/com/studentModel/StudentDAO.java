package com.studentModel;

import java.sql.*;
import java.util.*;

public class StudentDAO {

    private static final String URL      = "jdbc:mysql://localhost:3306/studentrecords";
    private static final String USER     = "root";
    private static final String PASSWORD = "Kadalamuttai@143";

    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // ══════════════════════════════════
    // Get student by roll number
    // → used for viewDetails
    // ══════════════════════════════════
    public Student getStudentByRollNumber(String rollNumber) {
        Student student = null;
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM Student WHERE roll_number = ?");
            ps.setString(1, rollNumber);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                student = new Student(
                    rs.getString("roll_number"),
                    rs.getString("student_name"),
                    rs.getInt("age"),
                    rs.getString("grade"),
                    rs.getString("section"),
                    rs.getDouble("fees"),
                    rs.getString("address"),
                    rs.getString("parent_name"),
                    rs.getString("contact_number"),
                    rs.getString("created_at")
                );
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return student;
    }

    // ══════════════════════════════════
    // Get fees by roll number
    // → used for viewFees
    // ══════════════════════════════════
    public List<Object[]> getFeesByRollNumber(String rollNumber) {
        List<Object[]> feeList = new ArrayList<>();
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT fee_id, amount, status, due_date " +
                "FROM Fees WHERE roll_number = ? ORDER BY due_date");
            ps.setString(1, rollNumber);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Object[] row = new Object[4];
                row[0] = rs.getInt("fee_id");       // Fee ID
                row[1] = rs.getDouble("amount");    // Amount
                row[2] = rs.getString("status");    // PAID / PENDING
                row[3] = rs.getString("due_date");  // Due date
                feeList.add(row);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return feeList;
    }

    // ══════════════════════════════════
    // Get courses by roll number
    // → used for viewCourses
    // ══════════════════════════════════
    public List<Object[]> getCoursesByRollNumber(String rollNumber) {
        List<Object[]> courseList = new ArrayList<>();
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT c.course_id, c.course_name, c.course_description, c.course_fee " +
                "FROM Course c " +
                "JOIN Student_Course sc ON c.course_id = sc.course_id " +
                "WHERE sc.roll_number = ? " +
                "ORDER BY c.course_id");
            ps.setString(1, rollNumber);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Object[] row = new Object[4];
                row[0] = rs.getString("course_id");          // Course ID
                row[1] = rs.getString("course_name");        // Course name
                row[2] = rs.getString("course_description"); // Description
                row[3] = rs.getDouble("course_fee");         // Fee
                courseList.add(row);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return courseList;
    }
}
/*
```

---

**Complete flow summary:**
```
StudentFeatures.jsp
│
├── action="viewDetails"  → StudentController → studentDAO.getStudentByRollNumber()  → studentDetails.jsp
├── action="viewFees"     → StudentController → studentDAO.getFeesByRollNumber()     → studentFees.jsp
├── action="viewCourses"  → StudentController → studentDAO.getCoursesByRollNumber()  → studentCourses.jsp
└── action="logout"       → LogoutServlet     → session.invalidate()                 → index.jsp
*/