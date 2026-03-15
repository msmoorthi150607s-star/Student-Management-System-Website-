package Student;

import com.studentModel.Student;
import com.studentModel.StudentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/StudentController")
public class StudentController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //Security check first
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("roll_number") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        //  Get roll_number from SESSION — not from form
        // This ensures each student only sees their own data
        String rollNumber = (String) session.getAttribute("roll_number");
        String action     = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("StudentFeatures.jsp");
            return;
        }

        switch (action) {

            // ══════════════════════════════════
            // View personal details
            // ══════════════════════════════════
            case "viewDetails":
                Student student = studentDAO.getStudentByRollNumber(rollNumber);
                if (student != null) {
                    request.setAttribute("student", student);
                    request.getRequestDispatcher("studentDetails.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Student details not found!");
                    request.getRequestDispatcher("CommonLoginError.jsp").forward(request, response);
                }
                break;

            // ══════════════════════════════════
            // View fee details
            // ══════════════════════════════════
            case "viewFees":
                List<Object[]> fees = studentDAO.getFeesByRollNumber(rollNumber);
                request.setAttribute("feeList", fees);
                request.setAttribute("rollNumber", rollNumber);
                request.getRequestDispatcher("studentFees.jsp").forward(request, response);
                break;

            // ══════════════════════════════════
            // View enrolled courses
            // ══════════════════════════════════
            case "viewCourses":
                List<Object[]> courses = studentDAO.getCoursesByRollNumber(rollNumber);
                request.setAttribute("courseList", courses);
                request.setAttribute("rollNumber", rollNumber);
                request.getRequestDispatcher("studentCourses.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect("StudentFeatures.jsp");
                break;
        }
    }

    // Block direct GET access
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}