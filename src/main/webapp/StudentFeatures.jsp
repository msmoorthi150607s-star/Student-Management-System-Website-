<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
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
    String grade       = httpSession.getAttribute("grade")   != null ? (String) httpSession.getAttribute("grade")   : "";
    String section     = httpSession.getAttribute("section") != null ? (String) httpSession.getAttribute("section") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Dashboard – Menaka's ICL</title>
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

  .header-right { display: flex; align-items: center; gap: 14px; }

  .student-badge {
    display: inline-flex; align-items: center; gap: 8px;
    padding: 5px 14px; border-radius: 999px;
    background: var(--green-dim);
    border: 1px solid rgba(90,158,114,0.22);
  }
  .student-badge .dot {
    width: 6px; height: 6px; border-radius: 50%;
    background: var(--green);
    animation: pulse 2s infinite;
  }
  .student-badge .name {
    font-size: 12px; font-weight: 500; color: var(--green);
    max-width: 140px; overflow: hidden;
    text-overflow: ellipsis; white-space: nowrap;
  }
  .student-badge .roll {
    font-size: 10px; font-weight: 400;
    color: rgba(90,158,114,0.7);
    border-left: 1px solid rgba(90,158,114,0.25);
    padding-left: 8px;
  }
  .student-badge .grade-tag {
    font-size: 10px; font-weight: 500;
    color: rgba(90,158,114,0.7);
    border-left: 1px solid rgba(90,158,114,0.25);
    padding-left: 8px;
  }

  @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.3} }

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
    margin-bottom: 36px;
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
  .page-title em {
    font-style: italic; color: var(--gold);
  }
  .page-sub {
    font-size: 13px; font-weight: 300; color: var(--muted);
  }

  /* grade + section pill */
  .meta-pills {
    display: flex; gap: 8px; margin-top: 10px;
  }
  .meta-pill {
    display: inline-flex; align-items: center; gap: 5px;
    padding: 3px 10px; border-radius: 999px;
    font-size: 11px; font-weight: 500;
    letter-spacing: 0.05em;
  }
  .meta-pill.grade   { background: var(--blue-dim);  color: var(--blue);  border: 1px solid rgba(74,143,212,0.2); }
  .meta-pill.section { background: var(--amber-dim); color: var(--amber); border: 1px solid rgba(196,154,74,0.2); }

  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(14px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  /* ═══ GRID ═══ */
  .grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
  }

  /* ═══ CARD ═══ */
  .card {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 16px;
    padding: 28px 28px 24px;
    transition: border-color 0.25s;
    animation: fadeUp 0.5s ease both;
    position: relative; overflow: hidden;
  }
  .card::before {
    content: '';
    position: absolute; top: 0; left: 0; right: 0; height: 2px;
    opacity: 0; transition: opacity 0.3s;
  }
  .card:hover { border-color: var(--border-h); }
  .card:hover::before { opacity: 1; }

  .card-green::before  { background: linear-gradient(to right, var(--green),  transparent); }
  .card-blue::before   { background: linear-gradient(to right, var(--blue),   transparent); }
  .card-amber::before  { background: linear-gradient(to right, var(--amber),  transparent); }
  .card-rose::before   { background: linear-gradient(to right, var(--rose),   transparent); }

  .card:nth-child(1) { animation-delay: 0.05s; }
  .card:nth-child(2) { animation-delay: 0.10s; }
  .card:nth-child(3) { animation-delay: 0.15s; }
  .card:nth-child(4) { animation-delay: 0.20s; }

  .card-header {
    display: flex; align-items: center; gap: 12px;
    margin-bottom: 22px;
  }
  .card-icon {
    width: 40px; height: 40px; border-radius: 10px;
    display: flex; align-items: center; justify-content: center;
    flex-shrink: 0;
  }
  .card-icon svg { width: 18px; height: 18px; }
  .card-icon.green { background: var(--green-dim); color: var(--green); }
  .card-icon.blue  { background: var(--blue-dim);  color: var(--blue);  }
  .card-icon.amber { background: var(--amber-dim); color: var(--amber); }
  .card-icon.rose  { background: var(--rose-dim);  color: var(--rose);  }

  .card-title {
    font-family: 'Cormorant Garamond', serif;
    font-size: 20px; font-weight: 500; color: var(--text);
  }
  .card-desc {
    font-size: 11px; font-weight: 400;
    color: var(--muted); margin-top: 1px;
  }

  .action-btn {
    display: inline-flex; align-items: center; gap: 8px;
    width: 100%; padding: 11px 16px;
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 10px;
    font-family: 'Jost', sans-serif;
    font-size: 13px; font-weight: 500;
    color: var(--mid); cursor: pointer;
    transition: background 0.18s, border-color 0.18s, color 0.18s, transform 0.15s;
  }
  .action-btn:hover {
    background: #1e1e1e; border-color: var(--border-h);
    color: var(--text); transform: translateY(-1px);
  }
  .action-btn:active { transform: translateY(0); }
  .action-btn svg { width: 15px; height: 15px; flex-shrink: 0; }

  .card-green .action-btn:hover { border-color: rgba(90,158,114,0.4);  color: var(--green); }
  .card-blue  .action-btn:hover { border-color: rgba(74,143,212,0.4);  color: var(--blue);  }
  .card-amber .action-btn:hover { border-color: rgba(196,154,74,0.4);  color: var(--amber); }

  .logout-card-btn {
    display: inline-flex; align-items: center; justify-content: center; gap: 8px;
    width: 100%; padding: 11px 16px;
    background: var(--rose-dim);
    border: 1px solid rgba(196,112,106,0.2);
    border-radius: 10px;
    font-family: 'Jost', sans-serif;
    font-size: 13px; font-weight: 500;
    color: var(--rose); cursor: pointer;
    transition: background 0.2s, border-color 0.2s, transform 0.15s;
  }
  .logout-card-btn:hover {
    background: rgba(196,112,106,0.2);
    border-color: rgba(196,112,106,0.4);
    transform: translateY(-1px);
  }
  .logout-card-btn:active { transform: translateY(0); }
  .logout-card-btn svg { width: 15px; height: 15px; }

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
    .grid  { grid-template-columns: 1fr; }
    footer { padding: 14px 20px; }
    .student-badge .roll { display: none; }
    .student-badge .grade-tag { display: none; }
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
    <div class="student-badge">
      <div class="dot"></div>
      <span class="name"><%= studentName %></span>
      <span class="roll"><%= rollNumber %></span>
      <% if (!grade.isEmpty()) { %>
        <span class="grade-tag">Grade <%= grade %> – <%= section %></span>
      <% } %>
    </div>
    <form action="AdminLogoutServlet" method="post" style="margin:0;">
      <button type="submit" class="logout-btn">Logout</button>
    </form>
  </div>
</header>

<!-- ═══ MAIN ═══ -->
<main>
  <div class="page-header">
    <div class="page-eyebrow">Student Portal</div>
    <h1 class="page-title">Welcome, <em><%= studentName %></em></h1>
    <p class="page-sub">Access your academic information from one place</p>
    <div class="meta-pills">
      <% if (!grade.isEmpty()) { %>
        <span class="meta-pill grade">Grade <%= grade %></span>
        <span class="meta-pill section">Section <%= section %></span>
      <% } %>
      <span class="meta-pill grade">Roll No: <%= rollNumber %></span>
    </div>
  </div>

  <div class="grid">

    <!-- Personal Details -->
    <div class="card card-green">
      <div class="card-header">
        <div class="card-icon green">
          <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
            <circle cx="12" cy="7" r="4"/>
          </svg>
        </div>
        <div>
          <div class="card-title">Personal Details</div>
          <div class="card-desc">View your profile and contact info</div>
        </div>
      </div>
      <form action="StudentController" method="post">
        <button class="action-btn" name="action" value="viewDetails">
          <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
            <circle cx="12" cy="12" r="3"/>
          </svg>
          View My Details
        </button>
      </form>
    </div>

    <!-- Fee Details -->
    <div class="card card-amber">
      <div class="card-header">
        <div class="card-icon amber">
          <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
            <line x1="12" y1="1" x2="12" y2="23"/>
            <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
          </svg>
        </div>
        <div>
          <div class="card-title">Fee Details</div>
          <div class="card-desc">View your fee payment status</div>
        </div>
      </div>
      <form action="StudentController" method="post">
        <button class="action-btn" name="action" value="viewFees">
          <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
            <circle cx="12" cy="12" r="3"/>
          </svg>
          View My Fees
        </button>
      </form>
    </div>

    <!-- Enrolled Courses -->
    <div class="card card-blue">
      <div class="card-header">
        <div class="card-icon blue">
          <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
          </svg>
        </div>
        <div>
          <div class="card-title">Enrolled Courses</div>
          <div class="card-desc">View your current course enrollments</div>
        </div>
      </div>
      <form action="StudentController" method="post">
        <button class="action-btn" name="action" value="viewCourses">
          <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
            <circle cx="12" cy="12" r="3"/>
          </svg>
          View My Courses
        </button>
      </form>
    </div>

    <!-- Logout -->
    <div class="card card-rose">
      <div class="card-header">
        <div class="card-icon rose">
          <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
            <polyline points="16 17 21 12 16 7"/>
            <line x1="21" y1="12" x2="9" y2="12"/>
          </svg>
        </div>
        <div>
          <div class="card-title">Sign Out</div>
          <div class="card-desc">End your current session safely</div>
        </div>
      </div>
      <form action="LogoutServlet" method="post">
        <button class="logout-card-btn" type="submit">
          <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
            <polyline points="16 17 21 12 16 7"/>
            <line x1="21" y1="12" x2="9" y2="12"/>
          </svg>
          Logout
        </button>
      </form>
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