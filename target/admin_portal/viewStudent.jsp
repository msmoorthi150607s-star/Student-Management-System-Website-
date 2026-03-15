<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ page import="com.studentModel.Student" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%
    /*
     * HOW IT WORKS:
     * 1. Admin clicks "View by Roll No" on AdminFeatures.jsp
     * 2. AdminController → action="viewStudent" (no roll) → forwards here (search form)
     * 3. Admin enters roll number and submits
     * 4. AdminController → action="viewStudent" with roll_number → adminDAO.getStudentByRollNumber()
     * 5. Returns here with student object to display
     */
    HttpSession httpSession = request.getSession(false);
    if (httpSession == null || httpSession.getAttribute("uname") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String uname       = (String) httpSession.getAttribute("uname");
    String message     = (String) request.getAttribute("message");
    String messageType = (String) request.getAttribute("messageType");
    Student student    = (Student) request.getAttribute("student");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View Student – Menaka's ICL</title>
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
    --blue:      #4a8fd4;
    --blue-dim:  rgba(74,143,212,0.12);
    --green:     #5a9e72;
    --green-dim: rgba(90,158,114,0.12);
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
    background: linear-gradient(to right, transparent, rgba(201,168,76,0.3), transparent);
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
    color: var(--mid); text-decoration: none;
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

  /* ═══ MESSAGE ═══ */
  .msg {
    padding: 12px 16px; border-radius: 10px;
    font-size: 13px; font-weight: 500;
    margin-bottom: 24px;
    display: flex; align-items: center; gap: 10px;
  }
  .msg.error {
    background: var(--rose-dim); color: var(--rose);
    border: 1px solid rgba(196,112,106,0.25);
  }
  .msg svg { width: 15px; height: 15px; flex-shrink: 0; }

  /* ═══ SEARCH CARD ═══ */
  .search-card {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 16px;
    padding: 24px 28px;
    max-width: 700px;
    margin-bottom: 20px;
    animation: fadeUp 0.5s 0.05s ease both;
    position: relative; overflow: hidden;
  }
  .search-card::before {
    content: '';
    position: absolute; top: 0; left: 0; right: 0; height: 2px;
    background: linear-gradient(to right, var(--blue), transparent);
  }
  .search-row {
    display: flex; gap: 12px; align-items: flex-end;
  }
  .search-group {
    flex: 1; display: flex; flex-direction: column; gap: 7px;
  }
  .search-group label {
    font-size: 11px; font-weight: 500;
    letter-spacing: 0.08em; text-transform: uppercase;
    color: var(--mid);
  }
  .search-group input {
    padding: 11px 14px;
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 10px;
    font-family: 'Jost', sans-serif;
    font-size: 14px; color: var(--text); outline: none;
    transition: border-color 0.2s, background 0.2s, box-shadow 0.2s;
  }
  .search-group input::placeholder { color: rgba(255,255,255,0.2); }
  .search-group input:focus {
    border-color: var(--blue); background: #1c1c1c;
    box-shadow: 0 0 0 3px rgba(74,143,212,0.15);
  }
  .btn-search {
    padding: 11px 22px;
    background: var(--blue-dim);
    border: 1px solid rgba(74,143,212,0.3);
    border-radius: 10px;
    font-family: 'Jost', sans-serif;
    font-size: 12px; font-weight: 600;
    letter-spacing: 0.1em; text-transform: uppercase;
    color: var(--blue); cursor: pointer;
    transition: background 0.2s, border-color 0.2s;
    white-space: nowrap;
  }
  .btn-search:hover {
    background: rgba(74,143,212,0.2);
    border-color: rgba(74,143,212,0.5);
  }

  /* ═══ PROFILE LAYOUT ═══ */
  .profile-wrap {
    display: grid;
    grid-template-columns: 280px 1fr;
    gap: 20px;
    max-width: 900px;
    animation: fadeUp 0.5s 0.1s ease both;
  }

  /* avatar card */
  .avatar-card {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 16px;
    padding: 28px 22px;
    display: flex; flex-direction: column;
    align-items: center; gap: 14px;
    position: relative; overflow: hidden;
    height: fit-content;
  }
  .avatar-card::before {
    content: '';
    position: absolute; top: 0; left: 0; right: 0; height: 2px;
    background: linear-gradient(to right, transparent, var(--blue), transparent);
  }
  .avatar-circle {
    width: 80px; height: 80px; border-radius: 50%;
    background: var(--blue-dim);
    border: 2px solid rgba(74,143,212,0.3);
    display: flex; align-items: center; justify-content: center;
    font-family: 'Cormorant Garamond', serif;
    font-size: 30px; font-weight: 600; color: var(--blue);
  }
  .avatar-name {
    font-family: 'Cormorant Garamond', serif;
    font-size: 20px; font-weight: 500;
    color: var(--text); text-align: center;
  }
  .avatar-roll {
    font-size: 11px; color: var(--muted);
    letter-spacing: 0.04em;
  }
  .avatar-pills {
    display: flex; flex-wrap: wrap;
    justify-content: center; gap: 6px;
  }
  .pill {
    padding: 3px 10px; border-radius: 999px;
    font-size: 11px; font-weight: 500;
  }
  .pill.grade   { background: var(--blue-dim);  color: var(--blue);  border: 1px solid rgba(74,143,212,0.2);  }
  .pill.section { background: var(--amber-dim); color: var(--amber); border: 1px solid rgba(196,154,74,0.2);  }
  .pill.age     { background: var(--green-dim); color: var(--green); border: 1px solid rgba(90,158,114,0.2);  }

  .avatar-divider {
    width: 100%; height: 1px; background: var(--border);
  }
  .avatar-meta { width: 100%; display: flex; flex-direction: column; gap: 10px; }
  .avatar-meta-row { display: flex; align-items: center; gap: 8px; }
  .avatar-meta-row svg { width: 13px; height: 13px; color: var(--muted); flex-shrink: 0; }
  .avatar-meta-label { font-size: 11px; color: var(--muted); }
  .avatar-meta-value { font-size: 12px; font-weight: 500; color: var(--mid); margin-left: auto; text-align: right; }

  /* details card */
  .details-card {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 16px;
    padding: 28px;
    position: relative; overflow: hidden;
  }
  .details-card::before {
    content: '';
    position: absolute; top: 0; left: 0; right: 0; height: 2px;
    background: linear-gradient(to right, transparent, var(--gold), transparent);
  }

  .section-title {
    font-size: 11px; font-weight: 500;
    letter-spacing: 0.12em; text-transform: uppercase;
    color: var(--gold);
    display: flex; align-items: center; gap: 10px;
    margin-bottom: 18px;
  }
  .section-title::after {
    content: ''; flex: 1; height: 0.5px;
    background: rgba(201,168,76,0.2);
  }

  .detail-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 14px; margin-bottom: 24px;
  }
  .detail-item {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 10px; padding: 13px 15px;
    transition: border-color 0.2s;
  }
  .detail-item:hover { border-color: var(--border-h); }
  .detail-item.full  { grid-column: 1 / -1; }

  .detail-label {
    font-size: 10px; font-weight: 500;
    letter-spacing: 0.1em; text-transform: uppercase;
    color: var(--muted); margin-bottom: 5px;
  }
  .detail-value {
    font-size: 14px; font-weight: 500; color: var(--text);
  }
  .detail-value.highlight { color: var(--green); }

  /* action buttons */
  .action-row {
    display: flex; gap: 10px; margin-top: 8px;
  }
  .btn-edit {
    display: inline-flex; align-items: center; gap: 6px;
    padding: 9px 18px;
    background: var(--amber-dim);
    border: 1px solid rgba(196,154,74,0.3);
    border-radius: 9px;
    font-family: 'Jost', sans-serif;
    font-size: 12px; font-weight: 500;
    color: var(--amber); cursor: pointer; text-decoration: none;
    transition: background 0.2s, border-color 0.2s;
  }
  .btn-edit:hover { background: rgba(196,154,74,0.2); border-color: rgba(196,154,74,0.5); }
  .btn-edit svg { width: 13px; height: 13px; }

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

  @media (max-width: 900px) {
    header { padding: 0 20px; }
    main   { padding: 28px 20px 40px; }
    footer { padding: 14px 20px; }
    .profile-wrap   { grid-template-columns: 1fr; }
    .detail-grid    { grid-template-columns: 1fr; }
    .search-row     { flex-direction: column; }
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
    <a href="AdminFeatures.jsp" class="back-btn">
      <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <path d="M19 12H5M12 5l-7 7 7 7"/>
      </svg>
      Back
    </a>
    <form action="AdminLogoutServlet" method="post" style="margin:0;">
      <button type="submit" class="logout-btn">Logout</button>
    </form>
  </div>
</header>

<!-- ═══ MAIN ═══ -->
<main>
  <div class="page-header">
    <div class="page-eyebrow">Manage Students</div>
    <h1 class="page-title">View <em>Student</em></h1>
    <p class="page-sub">Search a student by roll number to view full details</p>
  </div>

  <%-- Message --%>
  <% if (message != null) { %>
    <div class="msg error">
      <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <circle cx="12" cy="12" r="10"/>
        <line x1="12" y1="8" x2="12" y2="12"/>
        <line x1="12" y1="16" x2="12.01" y2="16"/>
      </svg>
      <%= message %>
    </div>
  <% } %>

  <!-- Search -->
  <div class="search-card">
    <form action="AdminController" method="post" autocomplete="off">
      <input type="hidden" name="action" value="viewStudent">
      <div class="search-row">
        <div class="search-group">
          <label>Search by Roll Number</label>
          <input type="text" name="roll_number"
                 placeholder="e.g. STU001" maxlength="10" required>
        </div>
        <button type="submit" class="btn-search">Search</button>
      </div>
    </form>
  </div>

  <!-- Student Profile — shown only if found -->
  <% if (student != null) { %>
  <div class="profile-wrap">

    <!-- Avatar Card -->
    <div class="avatar-card">
      <div class="avatar-circle">
        <%= student.getStudentName().substring(0,1).toUpperCase() %>
      </div>
      <div class="avatar-name"><%= student.getStudentName() %></div>
      <div class="avatar-roll"><%= student.getRollNumber() %></div>
      <div class="avatar-pills">
        <span class="pill grade">Grade <%= student.getGrade() %></span>
        <span class="pill section">Section <%= student.getSection() %></span>
        <span class="pill age">Age <%= student.getAge() %></span>
      </div>
      <div class="avatar-divider"></div>
      <div class="avatar-meta">
        <div class="avatar-meta-row">
          <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path d="M22 16.92v3a2 2 0 0 1-2.18 2A19.79 19.79 0 0 1 11.37 19"/>
          </svg>
          <span class="avatar-meta-label">Contact</span>
          <span class="avatar-meta-value"><%= student.getContactNumber() %></span>
        </div>
        <div class="avatar-meta-row">
          <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/>
            <circle cx="12" cy="10" r="3"/>
          </svg>
          <span class="avatar-meta-label">Address</span>
          <span class="avatar-meta-value"><%= student.getAddress() %></span>
        </div>
        <div class="avatar-meta-row">
          <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <rect x="3" y="4" width="18" height="18" rx="2"/>
            <line x1="16" y1="2" x2="16" y2="6"/>
            <line x1="8"  y1="2" x2="8"  y2="6"/>
            <line x1="3"  y1="10" x2="21" y2="10"/>
          </svg>
          <span class="avatar-meta-label">Joined</span>
          <span class="avatar-meta-value">
            <%= student.getCreatedAt() != null
                ? student.getCreatedAt().toString().substring(0,10)
                : "N/A" %>
          </span>
        </div>
      </div>
    </div>

    <!-- Details Card -->
    <div class="details-card">
      <div class="section-title">Personal Information</div>
      <div class="detail-grid">

        <div class="detail-item">
          <div class="detail-label">Full Name</div>
          <div class="detail-value highlight"><%= student.getStudentName() %></div>
        </div>
        <div class="detail-item">
          <div class="detail-label">Roll Number</div>
          <div class="detail-value"><%= student.getRollNumber() %></div>
        </div>
        <div class="detail-item">
          <div class="detail-label">Age</div>
          <div class="detail-value"><%= student.getAge() %> years</div>
        </div>
        <div class="detail-item">
          <div class="detail-label">Grade &amp; Section</div>
          <div class="detail-value">Grade <%= student.getGrade() %> — Section <%= student.getSection() %></div>
        </div>
        <div class="detail-item">
          <div class="detail-label">Total Fees</div>
          <div class="detail-value">Rs. <%= String.format("%,.2f", student.getFees()) %></div>
        </div>
        <div class="detail-item">
          <div class="detail-label">Contact Number</div>
          <div class="detail-value"><%= student.getContactNumber() %></div>
        </div>
        <div class="detail-item full">
          <div class="detail-label">Address</div>
          <div class="detail-value"><%= student.getAddress() %></div>
        </div>

      </div>

      <div class="section-title">Parent / Guardian</div>
      <div class="detail-grid">
        <div class="detail-item">
          <div class="detail-label">Parent Name</div>
          <div class="detail-value"><%= student.getParentName() %></div>
        </div>
        <div class="detail-item">
          <div class="detail-label">Enrolled On</div>
          <div class="detail-value">
            <%= student.getCreatedAt() != null
                ? student.getCreatedAt().toString().substring(0,10)
                : "N/A" %>
          </div>
        </div>
      </div>

      <!-- Quick action -->
      <div class="action-row">
        <form action="AdminController" method="post" style="margin:0;">
          <input type="hidden" name="action" value="updateStudent">
          <input type="hidden" name="roll_number" value="<%= student.getRollNumber() %>">
          <button type="submit" class="btn-edit">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
              <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
            </svg>
            Edit This Student
          </button>
        </form>
      </div>

    </div>
  </div>
  <% } %>

</main>

<!-- ═══ FOOTER ═══ -->
<footer>
  <span>Menaka's International Center for Learning</span>
  <span>Admin Panel &nbsp;·&nbsp; Secure Access</span>
</footer>

</body>
</html>