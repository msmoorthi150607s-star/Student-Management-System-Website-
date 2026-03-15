<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ page import="com.adminModel.Staff" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%
    HttpSession httpSession = request.getSession(false);
    if (httpSession == null || httpSession.getAttribute("staff_id") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String staffName  = (String)  httpSession.getAttribute("staff_name");
    String staffRole  = (String)  httpSession.getAttribute("staff_role");
    String department = (String)  httpSession.getAttribute("department");
    int    staffId    = (Integer) httpSession.getAttribute("staff_id");
    Staff  staff      = (Staff)   request.getAttribute("staff");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Profile – Menaka's ICL</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400&family=Jost:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
  *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
  :root {
    --dark:#0d0d0d; --panel:#111111; --surface:#161616; --card:#141414;
    --border:rgba(255,255,255,0.07); --border-h:rgba(255,255,255,0.13);
    --text:#f0ece6; --muted:#6a6460; --mid:#9a9088; --gold:#c9a84c;
    --gold-dim:rgba(201,168,76,0.12);
    --amber:#c49a4a; --amber-dim:rgba(196,154,74,0.12);
    --blue:#4a8fd4;  --blue-dim:rgba(74,143,212,0.12);
    --green:#5a9e72; --green-dim:rgba(90,158,114,0.12);
    --rose:#c4706a;  --rose-dim:rgba(196,112,106,0.12);
    --purple:#9b72d4;--purple-dim:rgba(155,114,212,0.12);
  }
  html,body{height:100%;}
  body{min-height:100vh;font-family:'Jost',sans-serif;background:var(--dark);color:var(--text);display:flex;flex-direction:column;}

  header{background:var(--panel);border-bottom:1px solid var(--border);padding:0 48px;height:64px;display:flex;align-items:center;justify-content:space-between;flex-shrink:0;position:relative;}
  header::after{content:'';position:absolute;bottom:0;left:0;right:0;height:1px;background:linear-gradient(to right,transparent,rgba(196,154,74,0.35),transparent);}
  .header-left{display:flex;align-items:center;gap:14px;}
  .header-logo{width:36px;height:36px;border:1px solid var(--gold);border-radius:50%;display:flex;align-items:center;justify-content:center;flex-shrink:0;position:relative;}
  .header-logo::before{content:'';position:absolute;inset:3px;border-radius:50%;border:0.5px solid rgba(201,168,76,0.2);}
  .header-logo span{font-family:'Cormorant Garamond',serif;font-size:16px;font-weight:600;color:var(--gold);}
  .header-title{font-family:'Cormorant Garamond',serif;font-size:18px;font-weight:400;color:var(--text);}
  .header-title span{color:var(--gold);font-style:italic;}
  .header-right{display:flex;align-items:center;gap:12px;}
  .back-btn{display:inline-flex;align-items:center;gap:6px;padding:7px 14px;background:transparent;border:1px solid var(--border-h);border-radius:8px;font-family:'Jost',sans-serif;font-size:12px;font-weight:500;color:var(--mid);text-decoration:none;transition:border-color 0.2s,color 0.2s;}
  .back-btn:hover{border-color:var(--amber);color:var(--amber);}
  .back-btn svg{width:13px;height:13px;}
  .logout-btn{padding:7px 16px;background:transparent;border:1px solid var(--border-h);border-radius:8px;font-family:'Jost',sans-serif;font-size:12px;font-weight:500;letter-spacing:0.06em;text-transform:uppercase;color:var(--mid);cursor:pointer;transition:border-color 0.2s,color 0.2s;}
  .logout-btn:hover{border-color:var(--rose);color:var(--rose);}

  main{flex:1;padding:40px 48px 48px;overflow-y:auto;}
  .page-header{margin-bottom:32px;animation:fadeUp 0.5s ease both;}
  .page-eyebrow{font-size:11px;font-weight:500;letter-spacing:0.16em;text-transform:uppercase;color:var(--amber);display:flex;align-items:center;gap:10px;margin-bottom:10px;}
  .page-eyebrow::after{content:'';width:40px;height:0.5px;background:rgba(196,154,74,0.4);}
  .page-title{font-family:'Cormorant Garamond',serif;font-size:30px;font-weight:400;color:var(--text);margin-bottom:4px;}
  .page-title em{font-style:italic;color:var(--gold);}
  .page-sub{font-size:13px;font-weight:300;color:var(--muted);}
  @keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}

  /* profile layout */
  .profile-wrap{display:grid;grid-template-columns:280px 1fr;gap:20px;max-width:900px;animation:fadeUp 0.5s 0.1s ease both;}

  /* avatar card */
  .avatar-card{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:28px 22px;display:flex;flex-direction:column;align-items:center;gap:14px;position:relative;overflow:hidden;height:fit-content;}
  .avatar-card::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(to right,transparent,var(--amber),transparent);}
  .avatar-circle{width:80px;height:80px;border-radius:50%;background:var(--amber-dim);border:2px solid rgba(196,154,74,0.3);display:flex;align-items:center;justify-content:center;font-family:'Cormorant Garamond',serif;font-size:30px;font-weight:600;color:var(--amber);}
  .avatar-name{font-family:'Cormorant Garamond',serif;font-size:20px;font-weight:500;color:var(--text);text-align:center;}
  .avatar-id{font-size:11px;color:var(--muted);letter-spacing:0.04em;}
  .avatar-pills{display:flex;flex-wrap:wrap;justify-content:center;gap:6px;}
  .pill{padding:3px 10px;border-radius:999px;font-size:11px;font-weight:500;}
  .pill.role-teaching{background:var(--blue-dim);color:var(--blue);border:1px solid rgba(74,143,212,0.2);}
  .pill.role-clerical{background:var(--amber-dim);color:var(--amber);border:1px solid rgba(196,154,74,0.2);}
  .pill.dept{background:var(--purple-dim);color:var(--purple);border:1px solid rgba(155,114,212,0.2);}
  .avatar-divider{width:100%;height:1px;background:var(--border);}
  .avatar-meta{width:100%;display:flex;flex-direction:column;gap:10px;}
  .avatar-meta-row{display:flex;align-items:center;gap:8px;}
  .avatar-meta-row svg{width:13px;height:13px;color:var(--muted);flex-shrink:0;}
  .avatar-meta-label{font-size:11px;color:var(--muted);}
  .avatar-meta-value{font-size:12px;font-weight:500;color:var(--mid);margin-left:auto;}

  /* details card */
  .details-card{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:28px;position:relative;overflow:hidden;}
  .details-card::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(to right,transparent,var(--gold),transparent);}
  .section-title{font-size:11px;font-weight:500;letter-spacing:0.12em;text-transform:uppercase;color:var(--gold);display:flex;align-items:center;gap:10px;margin-bottom:18px;}
  .section-title::after{content:'';flex:1;height:0.5px;background:rgba(201,168,76,0.2);}
  .detail-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:24px;}
  .detail-item{background:var(--surface);border:1px solid var(--border);border-radius:10px;padding:13px 15px;transition:border-color 0.2s;}
  .detail-item:hover{border-color:var(--border-h);}
  .detail-label{font-size:10px;font-weight:500;letter-spacing:0.1em;text-transform:uppercase;color:var(--muted);margin-bottom:5px;}
  .detail-value{font-size:14px;font-weight:500;color:var(--text);}
  .detail-value.highlight{color:var(--amber);}
  .detail-value.green{color:var(--green);}
  .detail-value.gold{color:var(--gold);}

  footer{padding:16px 48px;border-top:1px solid var(--border);background:var(--panel);font-size:11px;font-weight:300;color:rgba(255,255,255,0.18);letter-spacing:0.04em;display:flex;justify-content:space-between;align-items:center;flex-shrink:0;}
  @media(max-width:900px){header{padding:0 20px;}main{padding:28px 20px 40px;}footer{padding:14px 20px;}.profile-wrap{grid-template-columns:1fr;}.detail-grid{grid-template-columns:1fr;}}
</style>
</head>
<body>
<header>
  <div class="header-left">
    <div class="header-logo"><span>M</span></div>
    <div class="header-title">Menaka's <span>ICL</span></div>
  </div>
  <div class="header-right">
    <a href="StaffFeatures.jsp" class="back-btn">
      <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M19 12H5M12 5l-7 7 7 7"/></svg>
      Back
    </a>
    <form action="LogoutServlet" method="post" style="margin:0;">
      <button type="submit" class="logout-btn">Logout</button>
    </form>
  </div>
</header>

<main>
  <div class="page-header">
    <div class="page-eyebrow">Staff Portal</div>
    <h1 class="page-title">My <em>Profile</em></h1>
    <p class="page-sub">Your personal and department information</p>
  </div>

  <div class="profile-wrap">

    <!-- Avatar Card -->
    <div class="avatar-card">
      <div class="avatar-circle">
        <%= staff.getStaffName().substring(0,1).toUpperCase() %>
      </div>
      <div class="avatar-name"><%= staff.getStaffName() %></div>
      <div class="avatar-id">Staff ID: #<%= staff.getStaffId() %></div>
      <div class="avatar-pills">
        <span class="pill role-<%= staff.getRole().toLowerCase() %>"><%= staff.getRole() %></span>
        <span class="pill dept"><%= staff.getDepartment() %></span>
      </div>
      <div class="avatar-divider"></div>
      <div class="avatar-meta">
        <div class="avatar-meta-row">
          <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
          <span class="avatar-meta-label">Age</span>
          <span class="avatar-meta-value"><%= staff.getAge() %> years</span>
        </div>
        <div class="avatar-meta-row">
          <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
          <span class="avatar-meta-label">Salary</span>
          <span class="avatar-meta-value">Rs. <%= String.format("%,.0f", staff.getSalary()) %></span>
        </div>
        <div class="avatar-meta-row">
          <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M9 11l3 3L22 4"/></svg>
          <span class="avatar-meta-label">Attendance</span>
          <span class="avatar-meta-value"><%= staff.getAttendance() %> days</span>
        </div>
      </div>
    </div>

    <!-- Details Card -->
    <div class="details-card">
      <div class="section-title">Staff Information</div>
      <div class="detail-grid">
        <div class="detail-item">
          <div class="detail-label">Full Name</div>
          <div class="detail-value highlight"><%= staff.getStaffName() %></div>
        </div>
        <div class="detail-item">
          <div class="detail-label">Staff ID</div>
          <div class="detail-value">#<%= staff.getStaffId() %></div>
        </div>
        <div class="detail-item">
          <div class="detail-label">Role</div>
          <div class="detail-value"><%= staff.getRole() %></div>
        </div>
        <div class="detail-item">
          <div class="detail-label">Department</div>
          <div class="detail-value"><%= staff.getDepartment() %></div>
        </div>
        <div class="detail-item">
          <div class="detail-label">Age</div>
          <div class="detail-value"><%= staff.getAge() %> years</div>
        </div>
        <div class="detail-item">
          <div class="detail-label">Salary</div>
          <div class="detail-value green">Rs. <%= String.format("%,.2f", staff.getSalary()) %></div>
        </div>
        <div class="detail-item">
          <div class="detail-label">Attendance Count</div>
          <div class="detail-value gold"><%= staff.getAttendance() %> days</div>
        </div>
      </div>
    </div>

  </div>
</main>

<footer>
  <span>Menaka's International Center for Learning</span>
  <span>Staff Portal &nbsp;·&nbsp; Secure Access</span>
</footer>
</body>
</html>