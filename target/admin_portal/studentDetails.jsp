<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ page import="com.studentModel.Student" %>
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
    Student student = (Student) request.getAttribute("student");
    if (student == null) {
        response.sendRedirect("StudentFeatures.jsp");
        return;
    }
    String studentName = (String) httpSession.getAttribute("student_name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Details – Menaka's ICL</title>
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
    background: linear-gradient(to right, transparent, rgba(90,158,114,0.35), transparent);
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
    letter-spacing: 0.04em;
    color: var(--mid); cursor: pointer;
    text-decoration: none;
    transition: border-color 0.2s, color 0.2s;
  }
  .back-btn:hover { border-color: var(--green); color: var(--green); }
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

  /* page header */
  .page-header {
    margin-bottom: 32px;
    animation: fadeUp 0.5s ease both;
  }
  .page-eyebrow {
    font-size: 11px; font-weight: 500;
    letter-spacing: 0.16em; text-transform: uppercase;
    color: var(--green);
    display: flex; align-items: center; gap: 10px;
    margin-bottom: 10px;
  }
  .page-eyebrow::after {
    content: ''; width: 40px; height: 0.5px;
    background: rgba(90,158,114,0.4);
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

  /* ═══ PROFILE LAYOUT ═══ */
  .profile-wrap {
    display: grid;
    grid-template-columns: 300px 1fr;
    gap: 20px;
    animation: fadeUp 0.5s 0.1s ease both;
  }

  /* ── Left: Avatar card ── */
  .avatar-card {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 16px;
    padding: 32px 24px;
    display: flex; flex-direction: column;
    align-items: center; gap: 16px;
    position: relative; overflow: hidden;
    height: fit-content;
  }
  .avatar-card::before {
    content: '';
    position: absolute; top: 0; left: 0; right: 0; height: 2px;
    background: linear-gradient(to right, transparent, var(--green), transparent);
  }

  .avatar-circle {
    width: 88px; height: 88px; border-radius: 50%;
    background: var(--green-dim);
    border: 2px solid rgba(90,158,114,0.3);
    display: flex; align-items: center; justify-content: center;
    font-family: 'Cormorant Garamond', serif;
    font-size: 32px; font-weight: 600;
    color: var(--green);
    position: relative;
  }
  .avatar-circle::after {
    content: '';
    position: absolute; inset: 4px; border-radius: 50%;
    border: 0.5px solid rgba(90,158,114,0.2);
  }

  .avatar-name {
    font-family: 'Cormorant Garamond', serif;
    font-size: 20px; font-weight: 500;
    color: var(--text); text-align: center;
  }
  .avatar-roll {
    font-size: 12px; font-weight: 400;
    color: var(--muted); letter-spacing: 0.04em;
  }

  .avatar-pills {
    display: flex; flex-wrap: wrap;
    justify-content: center; gap: 6px;
    margin-top: 4px;
  }
  .pill {
    display: inline-flex; align-items: center; gap: 4px;
    padding: 4px 10px; border-radius: 999px;
    font-size: 11px; font-weight: 500;
  }
  .pill.grade   { background: var(--blue-dim);  color: var(--blue);  border: 1px solid rgba(74,143,212,0.2); }
  .pill.section { background: var(--amber-dim); color: var(--amber); border: 1px solid rgba(196,154,74,0.2); }
  .pill.age     { background: var(--green-dim); color: var(--green); border: 1px solid rgba(90,158,114,0.2); }

  .avatar-divider {
    width: 100%; height: 1px;
    background: var(--border); margin: 4px 0;
  }

  .avatar-meta {
    width: 100%;
    display: flex; flex-direction: column; gap: 10px;
  }
  .avatar-meta-row {
    display: flex; align-items: center; gap: 10px;
  }
  .avatar-meta-row svg {
    width: 14px; height: 14px;
    color: var(--muted); flex-shrink: 0;
  }
  .avatar-meta-label {
    font-size: 11px; font-weight: 400;
    color: var(--muted);
  }
  .avatar-meta-value {
    font-size: 12px; font-weight: 500;
    color: var(--mid); margin-left: auto;
    text-align: right;
  }

  /* ── Right: Details card ── */
  .details-card {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 16px;
    padding: 32px;
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
    margin-bottom: 20px;
  }
  .section-title::after {
    content: ''; flex: 1; height: 0.5px;
    background: rgba(201,168,76,0.2);
  }

  /* detail rows grid */
  .detail-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
    margin-bottom: 28px;
  }

  .detail-item {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 10px;
    padding: 14px 16px;
    transition: border-color 0.2s;
  }
  .detail-item:hover { border-color: var(--border-h); }

  .detail-label {
    font-size: 10px; font-weight: 500;
    letter-spacing: 0.1em; text-transform: uppercase;
    color: var(--muted); margin-bottom: 6px;
    display: flex; align-items: center; gap: 6px;
  }
  .detail-label svg { width: 11px; height: 11px; }

  .detail-value {
    font-size: 14px; font-weight: 500;
    color: var(--text); line-height: 1.4;
  }
  .detail-value.highlight { color: var(--green); }

  /* full-width item */
  .detail-item.full { grid-column: 1 / -1; }

  /* parent section */
  .parent-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
  }

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
    .profile-wrap { grid-template-columns: 1fr; }
    main { padding: 28px 20px 40px; }
    header { padding: 0 20px; }
    footer { padding: 14px 20px; }
    .detail-grid { grid-template-columns: 1fr; }
    .parent-grid { grid-template-columns: 1fr; }
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
    <h1 class="page-title">Personal <em>Details</em></h1>
    <p class="page-sub">Your registered academic profile information</p>
  </div>

  <div class="profile-wrap">

    <!-- ── LEFT: Avatar Card ── -->
    <div class="avatar-card">

      <!-- Initials circle -->
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
            <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12 19.79 19.79 0 0 1 1.58 3.44 2 2 0 0 1 3.54 1.27h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.91 8.82a16 16 0 0 0 6.29 6.29l1.12-1.12a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/>
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
            <rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
          </svg>
          <span class="avatar-meta-label">Joined</span>
          <span class="avatar-meta-value"><%= student.getCreatedAt().toString().substring(0,10) %></span>
        </div>
      </div>

    </div>

    <!-- ── RIGHT: Details Card ── -->
    <div class="details-card">

      <!-- Personal Info -->
      <div class="section-title">Personal Information</div>
      <div class="detail-grid">

        <div class="detail-item">
          <div class="detail-label">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            Full Name
          </div>
          <div class="detail-value highlight"><%= student.getStudentName() %></div>
        </div>

        <div class="detail-item">
          <div class="detail-label">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M4 4h16v16H4z"/><path d="M4 4l8 8 8-8"/></svg>
            Roll Number
          </div>
          <div class="detail-value"><%= student.getRollNumber() %></div>
        </div>

        <div class="detail-item">
          <div class="detail-label">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            Age
          </div>
          <div class="detail-value"><%= student.getAge() %> years</div>
        </div>

        <div class="detail-item">
          <div class="detail-label">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c0 2 2 3 6 3s6-1 6-3v-5"/></svg>
            Grade &amp; Section
          </div>
          <div class="detail-value">Grade <%= student.getGrade() %> — Section <%= student.getSection() %></div>
        </div>

        <div class="detail-item">
          <div class="detail-label">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
            Total Fees
          </div>
          <div class="detail-value">₹ <%= String.format("%,.2f", student.getFees()) %></div>
        </div>

        <div class="detail-item">
          <div class="detail-label">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12"/></svg>
            Contact Number
          </div>
          <div class="detail-value"><%= student.getContactNumber() %></div>
        </div>

        <div class="detail-item full">
          <div class="detail-label">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
            Address
          </div>
          <div class="detail-value"><%= student.getAddress() %></div>
        </div>

      </div>

      <!-- Parent Info -->
      <div class="section-title">Parent / Guardian</div>
      <div class="parent-grid">

        <div class="detail-item">
          <div class="detail-label">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>
            Parent Name
          </div>
          <div class="detail-value"><%= student.getParentName() %></div>
        </div>

        <div class="detail-item">
          <div class="detail-label">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
            Enrolled On
          </div>
          <div class="detail-value"><%= student.getCreatedAt().toString().substring(0,10) %></div>
        </div>

      </div>

    </div>
  </div>
</main>

<!-- ═══ FOOTER ═══ -->
<footer>
  <span>Menaka's International Center for Learning</span>
  <span>Student Portal &nbsp;·&nbsp; Secure Access</span>
</footer>

</body>
</html>