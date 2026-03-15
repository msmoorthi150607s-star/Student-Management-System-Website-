package Admin;

import com.adminModel.*;
import com.studentModel.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminController")
public class AdminController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Security check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("uname") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("AdminFeatures.jsp");
            return;
        }

        switch (action) {

            // ═══════════════════════════════════════════
            // STUDENT ACTIONS
            // ═══════════════════════════════════════════

            case "addStudent":
                request.getRequestDispatcher("addStudent.jsp")
                       .forward(request, response);
                break;

            case "addStudentSubmit":
                Student newStudent = new Student(
                    request.getParameter("roll_number"),
                    request.getParameter("student_name"),
                    Integer.parseInt(request.getParameter("age")),
                    request.getParameter("grade"),
                    request.getParameter("section"),
                    Double.parseDouble(request.getParameter("fees")),
                    request.getParameter("address"),
                    request.getParameter("parent_name"),
                    request.getParameter("contact_number"),
                    null
                );
                boolean added = adminDAO.addStudent(newStudent);
                request.setAttribute("message",
                    added ? "Student added successfully!" : "Failed to add student!");
                request.setAttribute("messageType",
                    added ? "success" : "error");
                request.getRequestDispatcher("addStudent.jsp")
                       .forward(request, response);
                break;

            case "updateStudent":
                String rollForUpdate = request.getParameter("roll_number");
                if (rollForUpdate != null && !rollForUpdate.isEmpty()) {
                    // roll number provided — fetch and show form
                    Student existing = adminDAO.getStudentByRollNumber(rollForUpdate);
                    if (existing != null) {
                        request.setAttribute("student", existing);
                        request.getRequestDispatcher("updateStudent.jsp")
                               .forward(request, response);
                    } else {
                        request.setAttribute("message", "Student not found!");
                        request.setAttribute("messageType", "error");
                        request.getRequestDispatcher("updateStudent.jsp")
                               .forward(request, response);
                    }
                } else {
                    // no roll number — show search form first
                    request.getRequestDispatcher("updateStudent.jsp")
                           .forward(request, response);
                }
                break;

            case "updateStudentSubmit":
                Student updatedStudent = new Student(
                    request.getParameter("roll_number"),
                    request.getParameter("student_name"),
                    Integer.parseInt(request.getParameter("age")),
                    request.getParameter("grade"),
                    request.getParameter("section"),
                    Double.parseDouble(request.getParameter("fees")),
                    request.getParameter("address"),
                    request.getParameter("parent_name"),
                    request.getParameter("contact_number"),
                    null
                );
                boolean updated = adminDAO.updateStudent(updatedStudent);
                request.setAttribute("message",
                    updated ? "Student updated successfully!" : "Failed to update student!");
                request.setAttribute("messageType",
                    updated ? "success" : "error");
                Student refreshed = adminDAO.getStudentByRollNumber(
                    request.getParameter("roll_number"));
                request.setAttribute("student", refreshed);
                request.getRequestDispatcher("updateStudent.jsp")
                       .forward(request, response);
                break;

            case "deleteStudent":
                String rollForDelete = request.getParameter("roll_number");
                if (rollForDelete != null && !rollForDelete.isEmpty()) {
                    boolean deleted = adminDAO.deleteStudent(rollForDelete);
                    request.setAttribute("message",
                        deleted ? "Student deleted successfully!" : "Failed to delete student!");
                    request.setAttribute("messageType",
                        deleted ? "success" : "error");
                } else {
                    request.setAttribute("message", "Please enter a Roll Number!");
                    request.setAttribute("messageType", "error");
                }
                request.getRequestDispatcher("deleteStudent.jsp")
                       .forward(request, response);
                break;

            case "viewStudent":
                String rollToView = request.getParameter("roll_number");
                if (rollToView != null && !rollToView.isEmpty()) {
                    Student found = adminDAO.getStudentByRollNumber(rollToView);
                    request.setAttribute("student", found);
                    if (found == null) {
                        request.setAttribute("message", "No student found with this Roll Number!");
                        request.setAttribute("messageType", "error");
                    }
                }
                request.getRequestDispatcher("viewStudent.jsp")
                       .forward(request, response);
                break;

            case "viewAllStudents":
                List<Student> allStudents = adminDAO.getAllStudents();
                request.setAttribute("studentList", allStudents);
                request.getRequestDispatcher("viewAllStudents.jsp")
                       .forward(request, response);
                break;

            // ═══════════════════════════════════════════
            // COURSE ACTIONS
            // ═══════════════════════════════════════════

            case "addCourse":
                request.getRequestDispatcher("addCourse.jsp")
                       .forward(request, response);
                break;

            case "addCourseSubmit":
                Course newCourse = new Course(
                    request.getParameter("course_id"),
                    request.getParameter("course_name"),
                    request.getParameter("course_description"),
                    Double.parseDouble(request.getParameter("course_fee"))
                );
                boolean courseAdded = adminDAO.addCourse(newCourse);
                request.setAttribute("message",
                    courseAdded ? "Course added successfully!" : "Failed to add course!");
                request.setAttribute("messageType",
                    courseAdded ? "success" : "error");
                request.getRequestDispatcher("addCourse.jsp")
                       .forward(request, response);
                break;

            case "updateCourse":
                String courseIdForUpdate = request.getParameter("course_id");
                if (courseIdForUpdate != null && !courseIdForUpdate.isEmpty()) {
                    List<Course> courses = adminDAO.getAllCourses();
                    Course toUpdate = null;
                    for (Course c : courses) {
                        if (c.getCourseId().equals(courseIdForUpdate)) {
                            toUpdate = c; break;
                        }
                    }
                    request.setAttribute("course", toUpdate);
                    if (toUpdate == null) {
                        request.setAttribute("message", "Course not found!");
                        request.setAttribute("messageType", "error");
                    }
                }
                request.getRequestDispatcher("updateCourse.jsp")
                       .forward(request, response);
                break;

            case "updateCourseSubmit":
                Course updatedCourse = new Course(
                    request.getParameter("course_id"),
                    request.getParameter("course_name"),
                    request.getParameter("course_description"),
                    Double.parseDouble(request.getParameter("course_fee"))
                );
                boolean courseUpdated = adminDAO.updateCourse(updatedCourse);
                request.setAttribute("message",
                    courseUpdated ? "Course updated successfully!" : "Failed to update course!");
                request.setAttribute("messageType",
                    courseUpdated ? "success" : "error");
                request.getRequestDispatcher("updateCourse.jsp")
                       .forward(request, response);
                break;

            case "deleteCourse":
                String courseIdToDelete = request.getParameter("course_id");
                if (courseIdToDelete != null && !courseIdToDelete.isEmpty()) {
                    boolean courseDeleted = adminDAO.deleteCourse(courseIdToDelete);
                    request.setAttribute("message",
                        courseDeleted ? "Course deleted successfully!" : "Failed to delete course!");
                    request.setAttribute("messageType",
                        courseDeleted ? "success" : "error");
                } else {
                    request.setAttribute("message", "Please enter a Course ID!");
                    request.setAttribute("messageType", "error");
                }
                request.getRequestDispatcher("deleteCourse.jsp")
                       .forward(request, response);
                break;

            case "viewCourses":
                List<Course> allCourses = adminDAO.getAllCourses();
                request.setAttribute("courseList", allCourses);
                request.getRequestDispatcher("viewCourses.jsp")
                       .forward(request, response);
                break;

            // ═══════════════════════════════════════════
            // FEES ACTIONS
            // ═══════════════════════════════════════════

            case "addFee":
                request.getRequestDispatcher("addFee.jsp")
                       .forward(request, response);
                break;

            case "addFeeSubmit":
                Fees newFee = new Fees(
                    0,
                    request.getParameter("roll_number"),
                    Double.parseDouble(request.getParameter("amount")),
                    request.getParameter("status"),
                    request.getParameter("due_date")
                );
                boolean feeAdded = adminDAO.addFee(newFee);
                request.setAttribute("message",
                    feeAdded ? "Fee added successfully!" : "Failed to add fee!");
                request.setAttribute("messageType",
                    feeAdded ? "success" : "error");
                request.getRequestDispatcher("addFee.jsp")
                       .forward(request, response);
                break;

            case "updateFee":
                String feeIdForUpdate = request.getParameter("fee_id");
                if (feeIdForUpdate != null && !feeIdForUpdate.isEmpty()) {
                    List<Fees> allFees = adminDAO.getAllFees();
                    Fees toUpdate = null;
                    for (Fees f : allFees) {
                        if (f.getFeeId() == Integer.parseInt(feeIdForUpdate)) {
                            toUpdate = f; break;
                        }
                    }
                    request.setAttribute("fee", toUpdate);
                    if (toUpdate == null) {
                        request.setAttribute("message", "Fee record not found!");
                        request.setAttribute("messageType", "error");
                    }
                }
                request.getRequestDispatcher("updateFee.jsp")
                       .forward(request, response);
                break;

            case "updateFeeSubmit":
                Fees updatedFee = new Fees(
                    Integer.parseInt(request.getParameter("fee_id")),
                    request.getParameter("roll_number"),
                    Double.parseDouble(request.getParameter("amount")),
                    request.getParameter("status"),
                    request.getParameter("due_date")
                );
                boolean feeUpdated = adminDAO.updateFee(updatedFee);
                request.setAttribute("message",
                    feeUpdated ? "Fee updated successfully!" : "Failed to update fee!");
                request.setAttribute("messageType",
                    feeUpdated ? "success" : "error");
                request.getRequestDispatcher("updateFee.jsp")
                       .forward(request, response);
                break;

            case "viewFees":
                List<Fees> allFees = adminDAO.getAllFees();
                request.setAttribute("feeList", allFees);
                request.getRequestDispatcher("viewFees.jsp")
                       .forward(request, response);
                break;

            // ═══════════════════════════════════════════
            // STAFF ACTIONS
            // ═══════════════════════════════════════════

            case "addStaff":
                request.getRequestDispatcher("addStaff.jsp")
                       .forward(request, response);
                break;

            case "addStaffSubmit":
                Staff newStaff = new Staff(
                    0,
                    request.getParameter("staff_name"),
                    request.getParameter("role"),
                    request.getParameter("department"),
                    Integer.parseInt(request.getParameter("age")),
                    Double.parseDouble(request.getParameter("salary")),
                    0
                );
                boolean staffAdded = adminDAO.addStaff(newStaff);
                request.setAttribute("message",
                    staffAdded ? "Staff added successfully!" : "Failed to add staff!");
                request.setAttribute("messageType",
                    staffAdded ? "success" : "error");
                request.getRequestDispatcher("addStaff.jsp")
                       .forward(request, response);
                break;

            case "updateStaff":
                String staffIdForUpdate = request.getParameter("staff_id");
                if (staffIdForUpdate != null && !staffIdForUpdate.isEmpty()) {
                    Staff existingStaff = adminDAO.getStaffById(
                        Integer.parseInt(staffIdForUpdate));
                    request.setAttribute("staff", existingStaff);
                    if (existingStaff == null) {
                        request.setAttribute("message", "Staff not found!");
                        request.setAttribute("messageType", "error");
                    }
                }
                request.getRequestDispatcher("updateStaff.jsp")
                       .forward(request, response);
                break;

            case "updateStaffSubmit":
                Staff updatedStaff = new Staff(
                    Integer.parseInt(request.getParameter("staff_id")),
                    request.getParameter("staff_name"),
                    request.getParameter("role"),
                    request.getParameter("department"),
                    Integer.parseInt(request.getParameter("age")),
                    Double.parseDouble(request.getParameter("salary")),
                    0
                );
                boolean staffUpdated = adminDAO.updateStaff(updatedStaff);
                request.setAttribute("message",
                    staffUpdated ? "Staff updated successfully!" : "Failed to update staff!");
                request.setAttribute("messageType",
                    staffUpdated ? "success" : "error");
                request.getRequestDispatcher("updateStaff.jsp")
                       .forward(request, response);
                break;

            case "viewStaff":
                List<Staff> allStaff = adminDAO.getAllStaff();
                request.setAttribute("staffList", allStaff);
                request.getRequestDispatcher("viewStaff.jsp")
                       .forward(request, response);
                break;

            case "attendance":
                String staffIdForAtt = request.getParameter("staff_id");
                if (staffIdForAtt != null && !staffIdForAtt.isEmpty()) {
                    boolean marked = adminDAO.markAttendance(
                        Integer.parseInt(staffIdForAtt));
                    request.setAttribute("message",
                        marked ? "Attendance marked successfully!" : "Failed to mark attendance!");
                    request.setAttribute("messageType",
                        marked ? "success" : "error");
                }
                List<Staff> staffForAtt = adminDAO.getAllStaff();
                request.setAttribute("staffList", staffForAtt);
                request.getRequestDispatcher("attendance.jsp")
                       .forward(request, response);
                break;

            default:
                response.sendRedirect("AdminFeatures.jsp");
                break;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}

/*
```

---

**Flow summary:**
```
AdminFeatures.jsp
│
├── addStudent      → addStudent.jsp     (show form)
│   addStudentSubmit→ addStudent.jsp     (process + show result)
│
├── updateStudent   → updateStudent.jsp  (search form)
│   updateStudentSubmit → updateStudent.jsp (process)
│
├── deleteStudent   → deleteStudent.jsp  (delete + result)
├── viewStudent     → viewStudent.jsp    (search by roll)
├── viewAllStudents → viewAllStudents.jsp
│
├── addCourse       → addCourse.jsp
├── updateCourse    → updateCourse.jsp
├── deleteCourse    → deleteCourse.jsp
├── viewCourses     → viewCourses.jsp
│
├── addFee          → addFee.jsp
├── updateFee       → updateFee.jsp
├── viewFees        → viewFees.jsp
│
├── addStaff        → addStaff.jsp
├── updateStaff     → updateStaff.jsp
├── viewStaff       → viewStaff.jsp
└── attendance      → attendance.jsp

*/