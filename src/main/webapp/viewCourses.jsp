<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ page import="com.adminModel.Course, java.util.List" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%
    /*
     * HOW IT WORKS:
     * 1. Admin clicks "View All Courses" → AdminController → action="viewCourses"
     * 2. adminDAO.getAllCourses() → forwards here with courseList
     */
    HttpSession httpSession = request.getSession(false);
    if (httpSession == null || httpSession.getAttribute("uname") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    List<Course> courseList = (List<Course>) request.getAttribute("courseList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>All Courses – Menaka's ICL</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400&family=Jost:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
  *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
  :root {
    --dark:#0d0d0d; --panel:#111111; --surface:#161616; --card:#141414;
    --border:rgba(255,255,255,0.07); --border-h:rgba(255,255,255,0.13);
    --text:#f0ece6; --muted:#6a6460; --mid:#9a9088; --gold:#c9a84c;
    --green:#5a9e72; --green-dim:rgba(90,158,114,0.12);
    --rose:#c4706a; --rose-dim:rgba(196,112,106,0.12);
    --teal:#4aa8a0; --teal-dim:rgba(74,168,160,0.12);
    --amber:#c49a4a; --amber-dim:rgba(196,154,74,0.12);
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
  .back-btn:hover{border-color:var(--teal);color:var(--teal);}
  .back-btn svg{width:13px;height:13px;}
  .logout-btn{padding:7px 16px;background:transparent;border:1px solid var(--border-h);border-radius:8px;font-family:'Jost',sans-serif;font-size:12px;font-weight:500;letter-spacing:0.06em;text-transform:uppercase;color:var(--mid);cursor:pointer;transition:border-color 0.2s,color 0.2s;}
  .logout-btn:hover{border-color:var(--rose);color:var(--rose);}
  main{flex:1;padding:40px 48px 48px;overflow-y:auto;}
  .page-header{margin-bottom:28px;animation:fadeUp 0.5s ease both;}
  .page-eyebrow{font-size:11px;font-weight:500;letter-spacing:0.16em;text-transform:uppercase;color:var(--teal);display:flex;align-items:center;gap:10px;margin-bottom:10px;}
  .page-eyebrow::after{content:'';width:40px;height:0.5px;background:rgba(74,168,160,0.4);}
  .page-title{font-family:'Cormorant Garamond',serif;font-size:30px;font-weight:400;color:var(--text);margin-bottom:4px;}
  .page-title em{font-style:italic;color:var(--gold);}
  .page-sub{font-size:13px;font-weight:300;color:var(--muted);}
  @keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
  .summary-bar{display:flex;align-items:center;gap:20px;background:var(--card);border:1px solid var(--border);border-radius:14px;padding:16px 24px;margin-bottom:20px;animation:fadeUp 0.5s 0.05s ease both;}
  .summary-item{display:flex;flex-direction:column;gap:3px;}
  .summary-label{font-size:10px;font-weight:500;letter-spacing:0.1em;text-transform:uppercase;color:var(--muted);}
  .summary-value{font-family:'Cormorant Garamond',serif;font-size:22px;font-weight:600;color:var(--teal);}
  .summary-sep{width:1px;height:32px;background:var(--border);}
  .search-bar{display:flex;gap:12px;margin-bottom:20px;animation:fadeUp 0.5s 0.08s ease both;}
  .search-bar input{flex:1;padding:10px 14px;background:var(--surface);border:1px solid var(--border);border-radius:10px;font-family:'Jost',sans-serif;font-size:13px;color:var(--text);outline:none;transition:border-color 0.2s;}
  .search-bar input::placeholder{color:rgba(255,255,255,0.2);}
  .search-bar input:focus{border-color:var(--teal);}
  /* course grid */
  .course-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:16px;animation:fadeUp 0.5s 0.1s ease both;}
  .course-card{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:22px 24px;position:relative;overflow:hidden;transition:border-color 0.2s,transform 0.2s;}
  .course-card:hover{border-color:rgba(74,168,160,0.3);transform:translateY(-2px);}
  .course-card::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(to right,var(--teal),transparent);opacity:0;transition:opacity 0.3s;}
  .course-card:hover::before{opacity:1;}
  .course-top{display:flex;align-items:flex-start;justify-content:space-between;gap:12px;margin-bottom:10px;}
  .course-id{font-family:monospace;font-size:11px;font-weight:600;color:var(--teal);background:var(--teal-dim);padding:3px 9px;border-radius:6px;border:1px solid rgba(74,168,160,0.2);}
  .course-fee{font-family:'Cormorant Garamond',serif;font-size:18px;font-weight:600;color:var(--gold);}
  .course-name{font-family:'Cormorant Garamond',serif;font-size:18px;font-weight:500;color:var(--text);margin-bottom:6px;}
  .course-desc{font-size:12px;font-weight:300;color:var(--muted);line-height:1.7;margin-bottom:14px;}
  .course-actions{display:flex;gap:8px;}
  .tbl-btn{display:inline-flex;align-items:center;gap:4px;padding:6px 12px;border-radius:7px;font-family:'Jost',sans-serif;font-size:11px;font-weight:500;cursor:pointer;border:none;transition:background 0.18s;text-decoration:none;}
  .tbl-btn.edit{background:var(--amber-dim);color:var(--amber);}
  .tbl-btn.edit:hover{background:rgba(196,154,74,0.25);}
  .tbl-btn svg{width:11px;height:11px;}
  .empty-state{padding:48px 24px;text-align:center;background:var(--card);border:1px solid var(--border);border-radius:14px;}
  .empty-state svg{width:36px;height:36px;color:var(--muted);margin-bottom:10px;}
  .empty-state p{font-size:13px;color:var(--muted);}
  footer{padding:16px 48px;border-top:1px solid var(--border);background:var(--panel);font-size:11px;font-weight:300;color:rgba(255,255,255,0.18);letter-spacing:0.04em;display:flex;justify-content:space-between;align-items:center;flex-shrink:0;}
  @media(max-width:820px){header{padding:0 20px;}main{padding:28px 20px 40px;}footer{padding:14px 20px;}.course-grid{grid-template-columns:1fr;}}
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
    <div class="page-eyebrow">Manage Courses</div>
    <h1 class="page-title">All <em>Courses</em></h1>
    <p class="page-sub">Complete list of available courses</p>
  </div>
  <% int total = (courseList != null) ? courseList.size() : 0; %>
  <div class="summary-bar">
    <div class="summary-item">
      <div class="summary-label">Total Courses</div>
      <div class="summary-value"><%= total %></div>
    </div>
  </div>
  <div class="search-bar">
    <input type="text" id="searchInput" placeholder="Search by course name or ID..." onkeyup="filterCards()">
  </div>
  <% if (courseList == null || courseList.isEmpty()) { %>
    <div class="empty-state">
      <svg fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
      <p>No courses found in the system.</p>
    </div>
  <% } else { %>
  <div class="course-grid" id="courseGrid">
    <% for (Course c : courseList) { %>
    <div class="course-card" data-name="<%= c.getCourseName().toLowerCase() %>" data-id="<%= c.getCourseId().toLowerCase() %>">
      <div class="course-top">
        <span class="course-id"><%= c.getCourseId() %></span>
        <span class="course-fee">Rs. <%= String.format("%,.0f", c.getCourseFee()) %></span>
      </div>
      <div class="course-name"><%= c.getCourseName() %></div>
      <div class="course-desc"><%= c.getCourseDescription() %></div>
      <div class="course-actions">
        <form action="AdminController" method="post" style="margin:0;">
          <input type="hidden" name="action" value="updateCourse">
          <input type="hidden" name="course_id" value="<%= c.getCourseId() %>">
          <button type="submit" class="tbl-btn edit">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
            Edit
          </button>
        </form>
      </div>
    </div>
    <% } %>
  </div>
  <% } %>
</main>
<footer>
  <span>Menaka's International Center for Learning</span>
  <span>Admin Panel &nbsp;·&nbsp; Secure Access</span>
</footer>
<script>
  function filterCards() {
    const input = document.getElementById('searchInput').value.toLowerCase();
    document.querySelectorAll('.course-card').forEach(card => {
      const match = card.dataset.name.includes(input) || card.dataset.id.includes(input);
      card.style.display = match ? '' : 'none';
    });
  }
</script>
</body>
</html>