package Staff;

import com.adminModel.Staff;
import com.staffModel.StaffDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/StaffController")
public class StaffController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private StaffDAO staffDAO = new StaffDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Security check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staff_id") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Get staff_id from SESSION — not from form
        int    staffId   = (Integer) session.getAttribute("staff_id");
        String action    = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("StaffFeatures.jsp");
            return;
        }

        switch (action) {

            // ══════════════════════════════════
            // View My Profile
            // ══════════════════════════════════
            case "viewProfile":
                Staff staff = staffDAO.getStaffById(staffId);
                request.setAttribute("staff", staff);
                if (staff == null) {
                    request.setAttribute("errorMessage", "Staff profile not found!");
                    request.getRequestDispatcher("CommonLoginError.jsp").forward(request, response);
                    return;
                }
                request.getRequestDispatcher("staffProfile.jsp").forward(request, response);
                break;

            // ══════════════════════════════════
            // View My Attendance
            // ══════════════════════════════════
            case "viewAttendance":
                Staff staffAtt = staffDAO.getStaffById(staffId);
                request.setAttribute("staff", staffAtt);
                request.getRequestDispatcher("staffAttendence.jsp").forward(request, response);
                break;

            // ══════════════════════════════════
            // View My Salary
            // ══════════════════════════════════
            case "viewSalary":
                Staff staffSal = staffDAO.getStaffById(staffId);
                request.setAttribute("staff", staffSal);
                request.getRequestDispatcher("staffSalary.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect("StaffFeatures.jsp");
                break;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}