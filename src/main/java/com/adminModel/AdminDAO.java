package com.adminModel;

import java.sql.*;
import java.util.*;

public class AdminDAO {

    private static final String URL      = "jdbc:mysql://localhost:3306/studentrecords";
    private static final String USER     = "root";
    private static final String PASSWORD = "Kadalamuttai@143";

    // ── DB Connection ──
    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // ═══════════════════════════════════════════
    // STUDENT OPERATIONS
    // ═══════════════════════════════════════════

    // Add Student
    public boolean addStudent(com.studentModel.Student student) {
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO Student (roll_number, student_name, age, grade, section, " +
                "fees, address, parent_name, contact_number) VALUES (?,?,?,?,?,?,?,?,?)");
            ps.setString(1, student.getRollNumber());
            ps.setString(2, student.getStudentName());
            ps.setInt(3,    student.getAge());
            ps.setString(4, student.getGrade());
            ps.setString(5, student.getSection());
            ps.setDouble(6, student.getFees());
            ps.setString(7, student.getAddress());
            ps.setString(8, student.getParentName());
            ps.setString(9, student.getContactNumber());
            int rows = ps.executeUpdate();
            con.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update Student
    public boolean updateStudent(com.studentModel.Student student) {
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE Student SET student_name=?, age=?, grade=?, section=?, " +
                "fees=?, address=?, parent_name=?, contact_number=? " +
                "WHERE roll_number=?");
            ps.setString(1, student.getStudentName());
            ps.setInt(2,    student.getAge());
            ps.setString(3, student.getGrade());
            ps.setString(4, student.getSection());
            ps.setDouble(5, student.getFees());
            ps.setString(6, student.getAddress());
            ps.setString(7, student.getParentName());
            ps.setString(8, student.getContactNumber());
            ps.setString(9, student.getRollNumber());
            int rows = ps.executeUpdate();
            con.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete Student
    public boolean deleteStudent(String rollNumber) {
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM Student WHERE roll_number=?");
            ps.setString(1, rollNumber);
            int rows = ps.executeUpdate();
            con.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // View Student by Roll Number
    public com.studentModel.Student getStudentByRollNumber(String rollNumber) {
        com.studentModel.Student student = null;
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM Student WHERE roll_number=?");
            ps.setString(1, rollNumber);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                student = new com.studentModel.Student(
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

    // View All Students
    public List<com.studentModel.Student> getAllStudents() {
        List<com.studentModel.Student> list = new ArrayList<>();
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM Student ORDER BY roll_number");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new com.studentModel.Student(
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
                ));
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ═══════════════════════════════════════════
    // COURSE OPERATIONS
    // ═══════════════════════════════════════════

    // Add Course
    public boolean addCourse(Course course) {
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO Course (course_id, course_name, course_description, course_fee) " +
                "VALUES (?,?,?,?)");
            ps.setString(1, course.getCourseId());
            ps.setString(2, course.getCourseName());
            ps.setString(3, course.getCourseDescription());
            ps.setDouble(4, course.getCourseFee());
            int rows = ps.executeUpdate();
            con.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update Course
    public boolean updateCourse(Course course) {
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE Course SET course_name=?, course_description=?, course_fee=? " +
                "WHERE course_id=?");
            ps.setString(1, course.getCourseName());
            ps.setString(2, course.getCourseDescription());
            ps.setDouble(3, course.getCourseFee());
            ps.setString(4, course.getCourseId());
            int rows = ps.executeUpdate();
            con.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete Course
    public boolean deleteCourse(String courseId) {
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM Course WHERE course_id=?");
            ps.setString(1, courseId);
            int rows = ps.executeUpdate();
            con.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // View All Courses
    public List<Course> getAllCourses() {
        List<Course> list = new ArrayList<>();
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM Course ORDER BY course_id");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Course(
                    rs.getString("course_id"),
                    rs.getString("course_name"),
                    rs.getString("course_description"),
                    rs.getDouble("course_fee")
                ));
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ═══════════════════════════════════════════
    // FEES OPERATIONS
    // ═══════════════════════════════════════════

    // Add Fee
    public boolean addFee(Fees fee) {
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO Fees (roll_number, amount, status, due_date) " +
                "VALUES (?,?,?,?)");
            ps.setString(1, fee.getRollNumber());
            ps.setDouble(2, fee.getAmount());
            ps.setString(3, fee.getStatus());
            ps.setString(4, fee.getDueDate());
            int rows = ps.executeUpdate();
            con.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update Fee
    public boolean updateFee(Fees fee) {
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE Fees SET amount=?, status=?, due_date=? " +
                "WHERE fee_id=?");
            ps.setDouble(1, fee.getAmount());
            ps.setString(2, fee.getStatus());
            ps.setString(3, fee.getDueDate());
            ps.setInt(4,    fee.getFeeId());
            int rows = ps.executeUpdate();
            con.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // View All Fees
    public List<Fees> getAllFees() {
        List<Fees> list = new ArrayList<>();
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT f.*, s.student_name FROM Fees f " +
                "JOIN Student s ON f.roll_number = s.roll_number " +
                "ORDER BY f.due_date");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Fees fee = new Fees(
                    rs.getInt("fee_id"),
                    rs.getString("roll_number"),
                    rs.getDouble("amount"),
                    rs.getString("status"),
                    rs.getString("due_date")
                );
                list.add(fee);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ═══════════════════════════════════════════
    // STAFF OPERATIONS
    // ═══════════════════════════════════════════

    // Add Staff
    public boolean addStaff(Staff staff) {
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO Staff (staff_name, role, department, age, salary, attendance) " +
                "VALUES (?,?,?,?,?,?)");
            ps.setString(1, staff.getStaffName());
            ps.setString(2, staff.getRole());
            ps.setString(3, staff.getDepartment());
            ps.setInt(4,    staff.getAge());
            ps.setDouble(5, staff.getSalary());
            ps.setInt(6,    staff.getAttendance());
            int rows = ps.executeUpdate();
            con.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update Staff
    public boolean updateStaff(Staff staff) {
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE Staff SET staff_name=?, role=?, department=?, age=?, salary=? " +
                "WHERE staff_id=?");
            ps.setString(1, staff.getStaffName());
            ps.setString(2, staff.getRole());
            ps.setString(3, staff.getDepartment());
            ps.setInt(4,    staff.getAge());
            ps.setDouble(5, staff.getSalary());
            ps.setInt(6,    staff.getStaffId());
            int rows = ps.executeUpdate();
            con.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // View All Staff
    public List<Staff> getAllStaff() {
        List<Staff> list = new ArrayList<>();
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM Staff ORDER BY staff_id");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Staff(
                    rs.getInt("staff_id"),
                    rs.getString("staff_name"),
                    rs.getString("role"),
                    rs.getString("department"),
                    rs.getInt("age"),
                    rs.getDouble("salary"),
                    rs.getInt("attendance")
                ));
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Update Attendance — increment by 1
    public boolean markAttendance(int staffId) {
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE Staff SET attendance = attendance + 1 WHERE staff_id=?");
            ps.setInt(1, staffId);
            int rows = ps.executeUpdate();
            con.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get Staff by ID
    public Staff getStaffById(int staffId) {
        Staff staff = null;
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM Staff WHERE staff_id=?");
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