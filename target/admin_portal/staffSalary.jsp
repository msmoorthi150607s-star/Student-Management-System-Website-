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
    int    staffId    = (Integer) httpSession.getAttribute("staff_id");
    Staff  staff      = (Staff)   request.getAttribute("staff");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Salary – Menaka's ICL</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400&family=Jost:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
  *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
  :root {
    --dark:#0d0d0d; --panel:#111111; --surface:#161616; --card:#141414;
    --border:rgba(255,255,255,0.07); --border-h:rgba(255,255,255,0.13);
    --text:#f0ece6; --muted:#6a6460; --mid:#9a9088; --gold:#c9a84c;
    --gold-dim:rgba(201,168,76,0.12);
    --green:#5a9e72; --green-dim:rgba(90,158,114,0.12);
    --rose:#c4706a;  --rose-dim:rgba(196,112,106,0.12);
    --amber:#c49a4a; --amber-dim:rgba(196,154,74,0.12);
    --blue:#4a8fd4;  --blue-dim:rgba(74,143,212,0.12);
  }
  html,body{height:100%;}
  body{min-height:100vh;font-family:'Jost',sans-serif;background:var(--dark);color:var(--text);display:flex;flex-direction:column;}
  header{background:var(--panel);border-bottom:1px solid var(--border);padding:0 48px;height:64px;display:flex;align-items:center;justify-content:space-between;flex-shrink:0;position:relative;}
  header::after{content:'';position:absolute;bottom:0;left:0;right:0;height:1px;background:linear-gradient(to right,transparent,rgba(201,168,76,0.35),transparent);}
  .header-left{display:flex;align-items:center;gap:14px;}
  .header-logo{width:36px;height:36px;border:1px solid var(--gold);border-radius:50%;display:flex;align-items:center;justify-content:center;flex-shrink:0;position:relative;}
  .header-logo::before{content:'';position:absolute;inset:3px;border-radius:50%;border:0.5px solid rgba(201,168,76,0.2);}
  .header-logo span{font-family:'Cormorant Garamond',serif;font-size:16px;font-weight:600;color:var(--gold);}
  .header-title{font-family:'Cormorant Garamond',serif;font-size:18px;font-weight:400;color:var(--text);}
  .header-title span{color:var(--gold);font-style:italic;}
  .header-right{display:flex;align-items:center;gap:12px;}
  .back-btn{display:inline-flex;align-items:center;gap:6px;padding:7px 14px;background:transparent;border:1px solid var(--border-h);border-radius:8px;font-family:'Jost',sans-serif;font-size:12px;font-weight:500;color:var(--mid);text-decoration:none;transition:border-color 0.2s,color 0.2s;}
  .back-btn:hover{border-color:var(--gold);color:var(--gold);}
  .back-btn svg{width:13px;height:13px;}
  .logout-btn{padding:7px 16px;background:transparent;border:1px solid var(--border-h);border-radius:8px;font-family:'Jost',sans-serif;font-size:12px;font-weight:500;letter-spacing:0.06em;text-transform:uppercase;color:var(--mid);cursor:pointer;transition:border-color 0.2s,color 0.2s;}
  .logout-btn:hover{border-color:var(--rose);color:var(--rose);}
  main{flex:1;padding:40px 48px 48px;overflow-y:auto;}
  .page-header{margin-bottom:32px;animation:fadeUp 0.5s ease both;}
  .page-eyebrow{font-size:11px;font-weight:500;letter-spacing:0.16em;text-transform:uppercase;color:var(--gold);display:flex;align-items:center;gap:10px;margin-bottom:10px;}
  .page-eyebrow::after{content:'';width:40px;height:0.5px;background:rgba(201,168,76,0.4);}
  .page-title{font-family:'Cormorant Garamond',serif;font-size:30px;font-weight:400;color:var(--text);margin-bottom:4px;}
  .page-title em{font-style:italic;color:var(--gold);}
  .page-sub{font-size:13px;font-weight:300;color:var(--muted);}
  @keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}

  .sal-wrap{max-width:600px;animation:fadeUp 0.5s 0.1s ease both;}

  /* hero salary card */
  .sal-hero{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:40px 32px;text-align:center;position:relative;overflow:hidden;margin-bottom:20px;}
  .sal-hero::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(to right,transparent,var(--gold),transparent);}
  .sal-currency{font-size:16px;font-weight:400;color:var(--muted);margin-bottom:4px;letter-spacing:0.08em;}
  .sal-number{font-family:'Cormorant Garamond',serif;font-size:64px;font-weight:600;color:var(--gold);line-height:1;margin-bottom:8px;}
  .sal-label{font-size:12px;font-weight:500;letter-spacing:0.12em;text-transform:uppercase;color:var(--muted);}
  .sal-period{font-size:12px;font-weight:300;color:var(--muted);margin-top:6px;}

  /* summary grid */
  .summary-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:20px;}
  .summary-item{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:16px 18px;}
  .summary-label{font-size:10px;font-weight:500;letter-spacing:0.1em;text-transform:uppercase;color:var(--muted);margin-bottom:6px;}
  .summary-value{font-family:'Cormorant Garamond',serif;font-size:20px;font-weight:600;}

  /* info card */
  .info-card{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:24px;position:relative;overflow:hidden;}
  .info-card::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(to right,var(--blue),transparent);}
  .section-title{font-size:11px;font-weight:500;letter-spacing:0.12em;text-transform:uppercase;color:var(--blue);display:flex;align-items:center;gap:10px;margin-bottom:16px;}
  .section-title::after{content:'';flex:1;height:0.5px;background:rgba(74,143,212,0.2);}
  .info-row{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid var(--border);}
  .info-row:last-child{border-bottom:none;}
  .info-key{font-size:12px;font-weight:400;color:var(--muted);}
  .info-val{font-size:13px;font-weight:500;color:var(--mid);}

  .notice{background:var(--surface);border:1px solid var(--border);border-radius:10px;padding:12px 16px;font-size:12px;color:var(--muted);line-height:1.7;display:flex;gap:8px;margin-top:16px;}
  .notice svg{width:13px;height:13px;color:var(--amber);flex-shrink:0;margin-top:2px;}

  footer{padding:16px 48px;border-top:1px solid var(--border);background:var(--panel);font-size:11px;font-weight:300;color:rgba(255,255,255,0.18);letter-spacing:0.04em;display:flex;justify-content:space-between;align-items:center;flex-shrink:0;}
  @media(max-width:820px){header{padding:0 20px;}main{padding:28px 20px 40px;}footer{padding:14px 20px;}.sal-number{font-size:48px;}.summary-grid{grid-template-columns:1fr;}}
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
    <h1 class="page-title">My <em>Salary</em></h1>
    <p class="page-sub">Your current salary details</p>
  </div>

  <div class="sal-wrap">

    <!-- Hero -->
    <div class="sal-hero">
      <div class="sal-currency">INDIAN RUPEES — MONTHLY</div>
      <div class="sal-number"><%= String.format("%,.0f", staff.getSalary()) %></div>
      <div class="sal-label">Monthly Salary</div>
      <div class="sal-period"><%= staff.getStaffName() %> &nbsp;·&nbsp; <%= staff.getDepartment() %></div>
    </div>

    <!-- Summary grid -->
    <div class="summary-grid">
      <div class="summary-item">
        <div class="summary-label">Monthly</div>
        <div class="summary-value" style="color:var(--gold);">
          Rs. <%= String.format("%,.0f", staff.getSalary()) %>
        </div>
      </div>
      <div class="summary-item">
        <div class="summary-label">Annual (x12)</div>
        <div class="summary-value" style="color:var(--green);">
          Rs. <%= String.format("%,.0f", staff.getSalary() * 12) %>
        </div>
      </div>
    </div>

    <!-- Info card -->
    <div class="info-card">
      <div class="section-title">Salary Breakdown</div>
      <div class="info-row">
        <span class="info-key">Staff Name</span>
        <span class="info-val"><%= staff.getStaffName() %></span>
      </div>
      <div class="info-row">
        <span class="info-key">Staff ID</span>
        <span class="info-val">#<%= staff.getStaffId() %></span>
      </div>
      <div class="info-row">
        <span class="info-key">Role</span>
        <span class="info-val"><%= staff.getRole() %></span>
      </div>
      <div class="info-row">
        <span class="info-key">Department</span>
        <span class="info-val"><%= staff.getDepartment() %></span>
      </div>
      <div class="info-row">
        <span class="info-key">Monthly Salary</span>
        <span class="info-val" style="color:var(--gold);font-weight:600;">
          Rs. <%= String.format("%,.2f", staff.getSalary()) %>
        </span>
      </div>
      <div class="info-row">
        <span class="info-key">Annual Salary</span>
        <span class="info-val" style="color:var(--green);font-weight:600;">
          Rs. <%= String.format("%,.2f", staff.getSalary() * 12) %>
        </span>
      </div>
      <div class="info-row">
        <span class="info-key">Attendance Days</span>
        <span class="info-val"><%= staff.getAttendance() %> days</span>
      </div>

      <div class="notice">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
        Salary details are maintained by the admin. For any salary-related queries, please contact the administration.
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