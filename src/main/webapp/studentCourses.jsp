<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ page import="java.util.List" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%
    HttpSession httpSession = request.getSession(false);
    if (httpSession == null || httpSession.getAttribute("roll_number") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String rollNumber  = (String) httpSession.getAttribute("roll_number");
    String studentName = (String) httpSession.getAttribute("student_name");
    List<Object[]> courseList = (List<Object[]>) request.getAttribute("courseList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Courses – Menaka's ICL</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400&family=Jost:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --dark:      #0d0d0d;
    --panel:     #111111;
    --surface:   #161616;
    --card:      #141414;
    --border:    rgba(255,255,255,0.07);
    --border-h:  rgba(255,255,255,0.13);
    --text:      #f0ece6;
    --muted:     #6a6460;
    --mid:       #9a9088;
    --gold:      #c9a84c;
    --gold-dim:  rgba(201,168,76,0.12);
    --green:     #5a9e72;
    --green-dim: rgba(90,158,114,0.12);
    --blue:      #4a8fd4;
    --blue-dim:  rgba(74,143,212,0.12);
    --amber:     #c49a4a;
    --amber-dim: rgba(196,154,74,0.12);
    --rose:      #c4706a;
    --rose-dim:  rgba(196,112,106,0.12);
  }

  html, body { height: 100%; }
  body {
    min-height: 100vh;
    font-family: 'Jost', sans-serif;
    background: var(--dark);
    color: var(--text);
    display: flex; flex-direction: column;
  }

  /* ═══ HEADER ═══ */
  header {
    background: var(--panel);
    border-bottom: 1px solid var(--border);
    padding: 0 48px; height: 64px;
    display: flex; align-items: center; justify-content: space-between;
    flex-shrink: 0; position: relative;
  }
  header::after {
    content: '';
    position: absolute; bottom: 0; left: 0; right: 0; height: 1px;
    background: linear-gradient(to right, transparent, rgba(74,143,212,0.35), transparent);
  }
  .header-left { display: flex; align-items: center; gap: 14px; }
  .header-logo {
    width: 36px; height: 36px;
    border: 1px solid var(--gold); border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    flex-shrink: 0; position: relative;
  }
  .header-logo::before {
    content: ''; position: absolute; inset: 3px; border-radius: 50%;
    border: 0.5px solid rgba(201,168,76,0.2);
  }
  .header-logo span {
    font-family: 'Cormorant Garamond', serif;
    font-size: 16px; font-weight: 600; color: var(--gold);
  }
  .header-title {
    font-family: 'Cormorant Garamond', serif;
    font-size: 18px; font-weight: 400; color: var(--text);
  }
  .header-title span { color: var(--gold); font-style: italic; }

  .header-right { display: flex; align-items: center; gap: 12px; }

  .back-btn {
    display: inline-flex; align-items: center; gap: 6px;
    padding: 7px 14px; background: transparent;
    border: 1px solid var(--border-h); border-radius: 8px;
    font-family: 'Jost', sans-serif;
    font-size: 12px; font-weight: 500;
    color: var(--mid); cursor: pointer;
    text-decoration: none;
    transition: border-color 0.2s, color 0.2s;
  }
  .back-btn:hover { border-color: var(--blue); color: var(--blue); }
  .back-btn svg { width: 13px; height: 13px; }

  .logout-btn {
    padding: 7px 16px; background: transparent;
    border: 1px solid var(--border-h); border-radius: 8px;
    font-family: 'Jost', sans-serif;
    font-size: 12px; font-weight: 500;
    letter-spacing: 0.06em; text-transform: uppercase;
    color: var(--mid); cursor: pointer;
    transition: border-color 0.2s, color 0.2s;
  }
  .logout-btn:hover { border-color: var(--rose); color: var(--rose); }

  /* ═══ MAIN ═══ */
  main { flex: 1; padding: 40px 48px 48px; overflow-y: auto; }

  .page-header {
    margin-bottom: 32px;
    animation: fadeUp 0.5s ease both;
  }
  .page-eyebrow {
    font-size: 11px; font-weight: 500;
    letter-spacing: 0.16em; text-transform: uppercase;
    color: var(--blue);
    display: flex; align-items: center; gap: 10px;
    margin-bottom: 10px;
  }
  .page-eyebrow::after {
    content: ''; width: 40px; height: 0.5px;
    background: rgba(74,143,212,0.4);
  }
  .page-title {
    font-family: 'Cormorant Garamond', serif;
    font-size: 30px; font-weight: 400;
    color: var(--text); margin-bottom: 4px;
  }
  .page-title em { font-style: italic; color: var(--gold); }
  .page-sub { font-size: 13px; font-weight: 300; color: var(--muted); }

  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(14px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  /* ═══ SUMMARY BAR ═══ */
  .summary-bar {
    display: flex; align-items: center; gap: 20px;
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 14px;
    padding: 18px 24px;
    margin-bottom: 24px;
    animation: fadeUp 0.5s 0.05s ease both;
  }
  .summary-item {
    display: flex; flex-direction: column; gap: 4px;
  }
  .summary-item-label {
    font-size: 10px; font-weight: 500;
    letter-spacing: 0.1em; text-transform: uppercase;
    color: var(--muted);
  }
  .summary-item-value {
    font-family: 'Cormorant Garamond', serif;
    font-size: 22px; font-weight: 600;
    color: var(--blue);
  }
  .summary-sep {
    width: 1px; height: 36px;
    background: var(--border);
  }
  .summary-item-value.gold  { color: var(--gold); }
  .summary-item-value.green { color: var(--green); }

  /* ═══ COURSE GRID ═══ */
  .course-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 16px;
    animation: fadeUp 0.5s 0.1s ease both;
  }

  .course-card {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 14px;
    padding: 22px 24px;
    position: relative; overflow: hidden;
    transition: border-color 0.2s, transform 0.2s;
  }
  .course-card:hover {
    border-color: rgba(74,143,212,0.3);
    transform: translateY(-2px);
  }
  .course-card::before {
    content: '';
    position: absolute; top: 0; left: 0; right: 0; height: 2px;
    background: linear-gradient(to right, var(--blue), transparent);
    opacity: 0; transition: opacity 0.3s;
  }
  .course-card:hover::before { opacity: 1; }

  .course-top {
    display: flex; align-items: flex-start;
    justify-content: space-between; gap: 12px;
    margin-bottom: 12px;
  }

  .course-id-badge {
    display: inline-flex; align-items: center;
    padding: 3px 9px; border-radius: 6px;
    background: var(--blue-dim);
    border: 1px solid rgba(74,143,212,0.2);
    font-size: 10px; font-weight: 600;
    letter-spacing: 0.08em; text-transform: uppercase;
    color: var(--blue); flex-shrink: 0;
    font-family: monospace;
  }

  .course-fee-tag {
    font-family: 'Cormorant Garamond', serif;
    font-size: 18px; font-weight: 600;
    color: var(--gold);
  }

  .course-name {
    font-family: 'Cormorant Garamond', serif;
    font-size: 20px; font-weight: 500;
    color: var(--text); margin-bottom: 8px;
    line-height: 1.3;
  }

  .course-desc {
    font-size: 12px; font-weight: 300;
    color: var(--muted); line-height: 1.7;
  }

  .course-divider {
    height: 1px; background: var(--border);
    margin: 14px 0;
  }

  .course-footer {
    display: flex; align-items: center;
    justify-content: space-between;
  }
  .enrolled-tag {
    display: inline-flex; align-items: center; gap: 5px;
    font-size: 11px; font-weight: 500;
    color: var(--green);
  }
  .enrolled-tag::before {
    content: '';
    width: 5px; height: 5px; border-radius: 50%;
    background: var(--green);
  }

  /* empty state */
  .empty-state {
    grid-column: 1 / -1;
    padding: 60px 24px; text-align: center;
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 14px;
  }
  .empty-state svg {
    width: 40px; height: 40px;
    color: var(--muted); margin-bottom: 12px;
  }
  .empty-state p { font-size: 13px; color: var(--muted); }

  /* ═══ FOOTER ═══ */
  footer {
    padding: 16px 48px;
    border-top: 1px solid var(--border);
    background: var(--panel);
    font-size: 11px; font-weight: 300;
    color: rgba(255,255,255,0.18);
    letter-spacing: 0.04em;
    display: flex; justify-content: space-between; align-items: center;
    flex-shrink: 0;
  }

  @media (max-width: 820px) {
    header { padding: 0 20px; }
    main   { padding: 28px 20px 40px; }
    footer { padding: 14px 20px; }
    .course-grid   { grid-template-columns: 1fr; }
    .summary-bar   { flex-wrap: wrap; gap: 14px; }
  }
</style>
</head>
<body>

<!-- ═══ HEADER ═══ -->
<header>
  <div class="header-left">
    <div class="header-logo"><span>M</span></div>
    <div class="header-title">Menaka's <span>ICL</span></div>
  </div>
  <div class="header-right">
    <a href="StudentFeatures.jsp" class="back-btn">
      <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <path d="M19 12H5M12 5l-7 7 7 7"/>
      </svg>
      Back
    </a>
    <form action="LogoutServlet" method="post" style="margin:0;">
      <button type="submit" class="logout-btn">Logout</button>
    </form>
  </div>
</header>

<!-- ═══ MAIN ═══ -->
<main>
  <div class="page-header">
    <div class="page-eyebrow">Student Portal</div>
    <h1 class="page-title">Enrolled <em>Courses</em></h1>
    <p class="page-sub">Your current course enrollments — <%= rollNumber %></p>
  </div>

  <%
    int totalCourses = (courseList != null) ? courseList.size() : 0;
    double totalCourseFee = 0;
    if (courseList != null) {
      for (Object[] c : courseList) {
        totalCourseFee += (Double) c[3];
      }
    }
  %>

  <!-- ═══ SUMMARY BAR ═══ -->
  <div class="summary-bar">
    <div class="summary-item">
      <div class="summary-item-label">Enrolled Courses</div>
      <div class="summary-item-value"><%= totalCourses %></div>
    </div>
    <div class="summary-sep"></div>
    <div class="summary-item">
      <div class="summary-item-label">Total Course Fee</div>
      <div class="summary-item-value gold">₹ <%= String.format("%,.2f", totalCourseFee) %></div>
    </div>
    <div class="summary-sep"></div>
    <div class="summary-item">
      <div class="summary-item-label">Student</div>
      <div class="summary-item-value green" style="font-size:16px;"><%= studentName %></div>
    </div>
  </div>

  <!-- ═══ COURSE GRID ═══ -->
  <div class="course-grid">
    <% if (courseList == null || courseList.isEmpty()) { %>
      <div class="empty-state">
        <svg fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
          <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
          <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
        </svg>
        <p>No courses enrolled yet.</p>
      </div>
    <% } else {
         int i = 0;
         for (Object[] course : courseList) {
           i++;
    %>
      <div class="course-card" style="animation-delay: <%= i * 0.05 %>s;">
        <div class="course-top">
          <span class="course-id-badge"><%= course[0] %></span>
          <span class="course-fee-tag">₹ <%= String.format("%,.2f", (Double) course[3]) %></span>
        </div>
        <div class="course-name"><%= course[1] %></div>
        <div class="course-desc"><%= course[2] %></div>
        <div class="course-divider"></div>
        <div class="course-footer">
          <span class="enrolled-tag">Enrolled</span>
          <span style="font-size:11px; color:var(--muted);">Course Fee: ₹ <%= String.format("%,.2f", (Double) course[3]) %></span>
        </div>
      </div>
    <% } } %>
  </div>
</main>

<!-- ═══ FOOTER ═══ -->
<footer>
  <span>Menaka's International Center for Learning</span>
  <span>Student Portal &nbsp;·&nbsp; Secure Access</span>
</footer>

</body>
</html>