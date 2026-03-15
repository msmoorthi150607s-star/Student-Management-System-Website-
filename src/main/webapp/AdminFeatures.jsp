<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%
    HttpSession httpSession = request.getSession(false);
    if (httpSession == null || httpSession.getAttribute("uname") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String uname = (String) httpSession.getAttribute("uname");
    String role  = (String) httpSession.getAttribute("role");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard – Menaka's ICL</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400&family=Jost:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --dark:     #0d0d0d;
    --panel:    #111111;
    --surface:  #161616;
    --card:     #141414;
    --border:   rgba(255,255,255,0.07);
    --border-h: rgba(255,255,255,0.13);
    --text:     #f0ece6;
    --muted:    #6a6460;
    --mid:      #9a9088;
    --gold:     #c9a84c;
    --gold-dim: rgba(201,168,76,0.12);
    --gold-glow:rgba(201,168,76,0.22);
    --blue:     #4a8fd4;
    --blue-dim: rgba(74,143,212,0.12);
    --green:    #5a9e72;
    --green-dim:rgba(90,158,114,0.12);
    --rose:     #c4706a;
    --rose-dim: rgba(196,112,106,0.12);
    --amber:    #c49a4a;
    --amber-dim:rgba(196,154,74,0.12);
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
    font-size: 18px; font-weight: 400;
    color: var(--text); letter-spacing: 0.01em;
  }
  .header-title span { color: var(--gold); font-style: italic; }

  .header-right { display: flex; align-items: center; gap: 16px; }

  .admin-badge {
    display: inline-flex; align-items: center; gap: 6px;
    padding: 5px 12px; border-radius: 999px;
    background: var(--gold-dim);
    border: 1px solid rgba(201,168,76,0.2);
    font-size: 11px; font-weight: 500;
    letter-spacing: 0.08em; text-transform: uppercase;
    color: var(--gold);
  }
  .admin-badge::before {
    content: '';
    width: 5px; height: 5px; border-radius: 50%;
    background: var(--gold);
    animation: pulse 2s infinite;
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
    color: var(--gold);
    display: flex; align-items: center; gap: 10px;
    margin-bottom: 10px;
  }
  .page-eyebrow::after {
    content: ''; width: 40px; height: 0.5px;
    background: rgba(201,168,76,0.4);
  }
  .page-title {
    font-family: 'Cormorant Garamond', serif;
    font-size: 30px; font-weight: 400;
    color: var(--text); margin-bottom: 4px;
  }
  .page-sub { font-size: 13px; font-weight: 300; color: var(--muted); }

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
    transition: border-color 0.25s, box-shadow 0.25s;
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

  .card-blue::before  { background: linear-gradient(to right, var(--blue),  transparent); }
  .card-green::before { background: linear-gradient(to right, var(--green), transparent); }
  .card-rose::before  { background: linear-gradient(to right, var(--rose),  transparent); }
  .card-amber::before { background: linear-gradient(to right, var(--amber), transparent); }

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
  .card-icon.blue  { background: var(--blue-dim);  color: var(--blue);  }
  .card-icon.green { background: var(--green-dim); color: var(--green); }
  .card-icon.rose  { background: var(--rose-dim);  color: var(--rose);  }
  .card-icon.amber { background: var(--amber-dim); color: var(--amber); }

  .card-title {
    font-family: 'Cormorant Garamond', serif;
    font-size: 20px; font-weight: 500; color: var(--text);
  }
  .card-count {
    font-size: 11px; font-weight: 400;
    color: var(--muted); margin-top: 1px;
  }

  .btn-group { display: flex; flex-wrap: wrap; gap: 8px; }

  .action-btn {
    display: inline-flex; align-items: center; gap: 6px;
    padding: 8px 14px;
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 8px;
    font-family: 'Jost', sans-serif;
    font-size: 12px; font-weight: 500;
    color: var(--mid); cursor: pointer;
    transition: background 0.18s, border-color 0.18s, color 0.18s, transform 0.15s;
  }
  .action-btn:hover {
    background: #1e1e1e; border-color: var(--border-h);
    color: var(--text); transform: translateY(-1px);
  }
  .action-btn:active { transform: translateY(0); }
  .action-btn svg { width: 12px; height: 12px; flex-shrink: 0; }

  .card-blue  .action-btn:hover { border-color: rgba(74,143,212,0.4);  color: var(--blue);  }
  .card-green .action-btn:hover { border-color: rgba(90,158,114,0.4);  color: var(--green); }
  .card-rose  .action-btn:hover { border-color: rgba(196,112,106,0.4); color: var(--rose);  }
  .card-amber .action-btn:hover { border-color: rgba(196,154,74,0.4);  color: var(--amber); }

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
    .header-title { font-size: 15px; }
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
    <%-- ✅ Shows actual admin name + role from session --%>
    <div class="admin-badge"><%= uname %> &nbsp;·&nbsp; <%= role %></div>
    <form action="AdminLogoutServlet" method="post" style="margin:0;">
      <button type="submit" class="logout-btn">Logout</button>
    </form>
  </div>
</header>

<!-- ═══ MAIN ═══ -->
<main>
  <div class="page-header">
    <div class="page-eyebrow">Control Panel</div>
    <h1 class="page-title">Admin Dashboard</h1>
    <p class="page-sub">Welcome back, <%= uname %>! Manage students, courses, fees and staff from one place</p>
  </div>

  <div class="grid">

    <!-- ── Manage Students ── -->
    <div class="card card-blue">
      <div class="card-header">
        <div class="card-icon blue">
          <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
            <circle cx="9" cy="7" r="4"/>
            <path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/>
          </svg>
        </div>
        <div>
          <div class="card-title">Manage Students</div>
          <div class="card-count">Add, update, delete &amp; view student records</div>
        </div>
      </div>
      <form action="AdminController" method="post">
        <div class="btn-group">
          <button class="action-btn" name="action" value="addStudent">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            Add Student
          </button>
          <button class="action-btn" name="action" value="updateStudent">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
            Update
          </button>
          <button class="action-btn" name="action" value="deleteStudent">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14H6L5 6"/><path d="M10 11v6M14 11v6"/><path d="M9 6V4h6v2"/></svg>
            Delete
          </button>
          <button class="action-btn" name="action" value="viewStudent">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            View by Roll No
          </button>
          <button class="action-btn" name="action" value="viewAllStudents">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><circle cx="3" cy="6" r="1"/><circle cx="3" cy="12" r="1"/><circle cx="3" cy="18" r="1"/></svg>
            View All
          </button>
        </div>
      </form>
    </div>

    <!-- ── Manage Courses ── -->
    <div class="card card-green">
      <div class="card-header">
        <div class="card-icon green">
          <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
          </svg>
        </div>
        <div>
          <div class="card-title">Manage Courses</div>
          <div class="card-count">Add, update, delete &amp; view courses</div>
        </div>
      </div>
      <form action="AdminController" method="post">
        <div class="btn-group">
          <button class="action-btn" name="action" value="addCourse">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            Add Course
          </button>
          <button class="action-btn" name="action" value="updateCourse">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
            Update
          </button>
          <button class="action-btn" name="action" value="deleteCourse">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14H6L5 6"/><path d="M10 11v6M14 11v6"/><path d="M9 6V4h6v2"/></svg>
            Delete
          </button>
          <button class="action-btn" name="action" value="viewCourses">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><circle cx="3" cy="6" r="1"/><circle cx="3" cy="12" r="1"/><circle cx="3" cy="18" r="1"/></svg>
            View All
          </button>
        </div>
      </form>
    </div>

    <!-- ── Manage Fees ── -->
    <div class="card card-amber">
      <div class="card-header">
        <div class="card-icon amber">
          <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
            <line x1="12" y1="1" x2="12" y2="23"/>
            <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
          </svg>
        </div>
        <div>
          <div class="card-title">Manage Fees</div>
          <div class="card-count">Add, update &amp; view fee records</div>
        </div>
      </div>
      <form action="AdminController" method="post">
        <div class="btn-group">
          <button class="action-btn" name="action" value="addFee">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            Add Fee
          </button>
          <button class="action-btn" name="action" value="updateFee">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
            Update Fee
          </button>
          <button class="action-btn" name="action" value="viewFees">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><circle cx="3" cy="6" r="1"/><circle cx="3" cy="12" r="1"/><circle cx="3" cy="18" r="1"/></svg>
            View Fees
          </button>
        </div>
      </form>
    </div>

    <!-- ── Staff Management ── -->
    <div class="card card-rose">
      <div class="card-header">
        <div class="card-icon rose">
          <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
            <circle cx="12" cy="7" r="4"/>
          </svg>
        </div>
        <div>
          <div class="card-title">Staff Management</div>
          <div class="card-count">Add, update, view &amp; control attendance</div>
        </div>
      </div>
      <form action="AdminController" method="post">
        <div class="btn-group">
          <button class="action-btn" name="action" value="addStaff">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            Add Staff
          </button>
          <button class="action-btn" name="action" value="updateStaff">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
            Update
          </button>
          <button class="action-btn" name="action" value="viewStaff">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><circle cx="3" cy="6" r="1"/><circle cx="3" cy="12" r="1"/><circle cx="3" cy="18" r="1"/></svg>
            View Staff
          </button>
          <button class="action-btn" name="action" value="attendance">
            <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
            Attendance
          </button>
        </div>
      </form>
    </div>

  </div>
</main>

<!-- ═══ FOOTER ═══ -->
<footer>
  <span>Menaka's International Center for Learning</span>
  <span>Admin Panel &nbsp;·&nbsp; Secure Access</span>
</footer>

</body>
</html>