<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ page import="com.adminModel.Staff, java.util.List" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%
    /*
     * HOW IT WORKS:
     * 1. Admin clicks "Attendance" → AdminController → action="attendance"
     * 2. adminDAO.getAllStaff() → forwards here with staffList
     * 3. Admin clicks "Mark" on a staff → action="attendance" with staff_id
     * 4. adminDAO.markAttendance(staffId) → attendance + 1
     * 5. Returns here with updated staffList + message
     */
    HttpSession httpSession = request.getSession(false);
    if (httpSession == null || httpSession.getAttribute("uname") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String message     = (String) request.getAttribute("message");
    String messageType = (String) request.getAttribute("messageType");
    List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Attendance – Menaka's ICL</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400&family=Jost:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
  *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
  :root {
    --dark:#0d0d0d; --panel:#111111; --surface:#161616; --card:#141414;
    --border:rgba(255,255,255,0.07); --border-h:rgba(255,255,255,0.13);
    --text:#f0ece6; --muted:#6a6460; --mid:#9a9088; --gold:#c9a84c;
    --green:#5a9e72; --green-dim:rgba(90,158,114,0.12);
    --rose:#c4706a; --rose-dim:rgba(196,112,106,0.12);
    --amber:#c49a4a; --amber-dim:rgba(196,154,74,0.12);
    --blue:#4a8fd4; --blue-dim:rgba(74,143,212,0.12);
  }
  html,body{height:100%;}
  body{min-height:100vh;font-family:'Jost',sans-serif;background:var(--dark);color:var(--text);display:flex;flex-direction:column;}
  header{background:var(--panel);border-bottom:1px solid var(--border);padding:0 48px;height:64px;display:flex;align-items:center;justify-content:space-between;flex-shrink:0;position:relative;}
  header::after{content:'';position:absolute;bottom:0;left:0;right:0;height:1px;background:linear-gradient(to right,transparent,rgba(201,168,76,0.3),transparent);}
  .header-left{display:flex;align-items:center;gap:14px;}
  .header-logo{width:36px;height:36px;border:1px solid var(--gold);border-radius:50%;display:flex;align-items:center;justify-content:center;flex-shrink:0;position:relative;}
  .header-logo::before{content:'';position:absolute;inset:3px;border-radius:50%;border:0.5px solid rgba(201,168,76,0.2);}
  .header-logo span{font-family:'Cormorant Garamond',serif;font-size:16px;font-weight:600;color:var(--gold);}
  .header-title{font-family:'Cormorant Garamond',serif;font-size:18px;font-weight:400;color:var(--text);}
  .header-title span{color:var(--gold);font-style:italic;}
  .header-right{display:flex;align-items:center;gap:12px;}
  .back-btn{display:inline-flex;align-items:center;gap:6px;padding:7px 14px;background:transparent;border:1px solid var(--border-h);border-radius:8px;font-family:'Jost',sans-serif;font-size:12px;font-weight:500;color:var(--mid);text-decoration:none;transition:border-color 0.2s,color 0.2s;}
  .back-btn:hover{border-color:var(--green);color:var(--green);}
  .back-btn svg{width:13px;height:13px;}
  .logout-btn{padding:7px 16px;background:transparent;border:1px solid var(--border-h);border-radius:8px;font-family:'Jost',sans-serif;font-size:12px;font-weight:500;letter-spacing:0.06em;text-transform:uppercase;color:var(--mid);cursor:pointer;transition:border-color 0.2s,color 0.2s;}
  .logout-btn:hover{border-color:var(--rose);color:var(--rose);}
  main{flex:1;padding:40px 48px 48px;overflow-y:auto;}
  .page-header{margin-bottom:28px;animation:fadeUp 0.5s ease both;}
  .page-eyebrow{font-size:11px;font-weight:500;letter-spacing:0.16em;text-transform:uppercase;color:var(--green);display:flex;align-items:center;gap:10px;margin-bottom:10px;}
  .page-eyebrow::after{content:'';width:40px;height:0.5px;background:rgba(90,158,114,0.4);}
  .page-title{font-family:'Cormorant Garamond',serif;font-size:30px;font-weight:400;color:var(--text);margin-bottom:4px;}
  .page-title em{font-style:italic;color:var(--gold);}
  .page-sub{font-size:13px;font-weight:300;color:var(--muted);}
  @keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
  .msg{padding:12px 16px;border-radius:10px;font-size:13px;font-weight:500;margin-bottom:24px;display:flex;align-items:center;gap:10px;}
  .msg.success{background:var(--green-dim);color:var(--green);border:1px solid rgba(90,158,114,0.25);}
  .msg.error{background:var(--rose-dim);color:var(--rose);border:1px solid rgba(196,112,106,0.25);}
  .msg svg{width:15px;height:15px;flex-shrink:0;}
  .table-card{background:var(--card);border:1px solid var(--border);border-radius:16px;overflow:hidden;animation:fadeUp 0.5s 0.05s ease both;}
  .table-card-header{padding:18px 24px;border-bottom:1px solid var(--border);}
  .table-title{font-size:11px;font-weight:500;letter-spacing:0.12em;text-transform:uppercase;color:var(--green);display:flex;align-items:center;gap:10px;}
  .table-title::after{content:'';flex:1;height:0.5px;background:rgba(90,158,114,0.2);}
  table{width:100%;border-collapse:collapse;}
  thead tr{background:var(--surface);border-bottom:1px solid var(--border);}
  thead th{padding:12px 16px;font-size:10px;font-weight:600;letter-spacing:0.1em;text-transform:uppercase;color:var(--muted);text-align:left;white-space:nowrap;}
  tbody tr{border-bottom:1px solid var(--border);transition:background 0.15s;}
  tbody tr:last-child{border-bottom:none;}
  tbody tr:hover{background:var(--surface);}
  tbody td{padding:14px 16px;font-size:13px;color:var(--mid);}
  .staff-id{font-family:monospace;font-size:11px;font-weight:600;color:var(--rose);background:var(--rose-dim);padding:3px 8px;border-radius:6px;}
  .name-cell{font-weight:500;color:var(--text);}
  .role-pill{display:inline-flex;padding:2px 8px;border-radius:999px;font-size:10px;font-weight:500;}
  .role-pill.teaching{background:var(--blue-dim);color:var(--blue);border:1px solid rgba(74,143,212,0.2);}
  .role-pill.clerical{background:var(--amber-dim);color:var(--amber);border:1px solid rgba(196,154,74,0.2);}
  .att-count{font-family:'Cormorant Garamond',serif;font-size:18px;font-weight:600;color:var(--gold);}
  /* mark button */
  .mark-btn{display:inline-flex;align-items:center;gap:5px;padding:7px 14px;border-radius:8px;font-family:'Jost',sans-serif;font-size:12px;font-weight:600;letter-spacing:0.06em;cursor:pointer;border:none;background:var(--green-dim);color:var(--green);border:1px solid rgba(90,158,114,0.3);transition:background 0.2s,border-color 0.2s,transform 0.15s;}
  .mark-btn:hover{background:rgba(90,158,114,0.2);border-color:rgba(90,158,114,0.5);transform:translateY(-1px);}
  .mark-btn:active{transform:translateY(0);}
  .mark-btn svg{width:12px;height:12px;}
  .empty-state{padding:48px 24px;text-align:center;}
  .empty-state svg{width:36px;height:36px;color:var(--muted);margin-bottom:10px;}
  .empty-state p{font-size:13px;color:var(--muted);}
  footer{padding:16px 48px;border-top:1px solid var(--border);background:var(--panel);font-size:11px;font-weight:300;color:rgba(255,255,255,0.18);letter-spacing:0.04em;display:flex;justify-content:space-between;align-items:center;flex-shrink:0;}
  @media(max-width:820px){header{padding:0 20px;}main{padding:28px 20px 40px;}footer{padding:14px 20px;}}
</style>
</head>
<body>
<header>
  <div class="header-left">
    <div class="header-logo"><span>M</span></div>
    <div class="header-title">Menaka's <span>ICL</span></div>
  </div>
  <div class="header-right">
    <a href="AdminFeatures.jsp" class="back-btn">
      <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M19 12H5M12 5l-7 7 7 7"/></svg>
      Back
    </a>
    <form action="AdminLogoutServlet" method="post" style="margin:0;">
      <button type="submit" class="logout-btn">Logout</button>
    </form>
  </div>
</header>
<main>
  <div class="page-header">
    <div class="page-eyebrow">Staff Management</div>
    <h1 class="page-title">Control <em>Attendance</em></h1>
    <p class="page-sub">Mark attendance for staff — each click increments count by 1</p>
  </div>
  <% if (message != null) { %>
    <div class="msg <%= messageType %>">
      <% if ("success".equals(messageType)) { %>
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
      <% } else { %>
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
      <% } %>
      <%= message %>
    </div>
  <% } %>
  <div class="table-card">
    <div class="table-card-header">
      <div class="table-title">Staff Attendance Records</div>
    </div>
    <% if (staffList == null || staffList.isEmpty()) { %>
      <div class="empty-state">
        <svg fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
        <p>No staff records found.</p>
      </div>
    <% } else { %>
      <table>
        <thead>
          <tr>
            <th>Staff ID</th>
            <th>Name</th>
            <th>Role</th>
            <th>Department</th>
            <th>Attendance Count</th>
            <th>Mark Attendance</th>
          </tr>
        </thead>
        <tbody>
          <% for (Staff s : staffList) { %>
          <tr>
            <td><span class="staff-id">#<%= s.getStaffId() %></span></td>
            <td><span class="name-cell"><%= s.getStaffName() %></span></td>
            <td><span class="role-pill <%= s.getRole().toLowerCase() %>"><%= s.getRole() %></span></td>
            <td><%= s.getDepartment() %></td>
            <td><span class="att-count"><%= s.getAttendance() %></span></td>
            <td>
              <form action="AdminController" method="post" style="margin:0;">
                <input type="hidden" name="action" value="attendance">
                <input type="hidden" name="staff_id" value="<%= s.getStaffId() %>">
                <button type="submit" class="mark-btn">
                  <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M9 11l3 3L22 4"/></svg>
                  Mark
                </button>
              </form>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    <% } %>
  </div>
</main>
<footer>
  <span>Menaka's International Center for Learning</span>
  <span>Admin Panel &nbsp;·&nbsp; Secure Access</span>
</footer>
</body>
</html>