<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
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
    String staffName  = (String) httpSession.getAttribute("staff_name");
    String staffRole  = (String) httpSession.getAttribute("staff_role");
    String department = (String) httpSession.getAttribute("department");
    int    staffId    = (Integer) httpSession.getAttribute("staff_id");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Staff Dashboard – Menaka's ICL</title>
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
    --amber:     #c49a4a;
    --amber-dim: rgba(196,154,74,0.12);
    --blue:      #4a8fd4;
    --blue-dim:  rgba(74,143,212,0.12);
    --green:     #5a9e72;
    --green-dim: rgba(90,158,114,0.12);
    --rose:      #c4706a;
    --rose-dim:  rgba(196,112,106,0.12);
    --purple:    #9b72d4;
    --purple-dim:rgba(155,114,212,0.12);
    --teal:      #4aa8a0;
    --teal-dim:  rgba(74,168,160,0.12);
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
    background: linear-gradient(to right, transparent, rgba(196,154,74,0.35), transparent);
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

  .staff-badge {
    display: inline-flex; align-items: center; gap: 8px;
    padding: 5px 14px; border-radius: 999px;
    background: var(--amber-dim);
    border: 1px solid rgba(196,154,74,0.22);
  }
  .staff-badge .dot {
    width: 6px; height: 6px; border-radius: 50%;
    background: var(--amber); animation: pulse 2s infinite;
  }
  .staff-badge .sname {
    font-size: 12px; font-weight: 500; color: var(--amber);
    max-width: 140px; overflow: hidden;
    text-overflow: ellipsis; white-space: nowrap;
  }
  .staff-badge .role-tag {
    font-size: 10px; color: rgba(196,154,74,0.7);
    border-left: 1px solid rgba(196,154,74,0.25); padding-left: 8px;
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
    margin-bottom: 32px;
    animation: fadeUp 0.5s ease both;
  }
  .page-eyebrow {
    font-size: 11px; font-weight: 500;
    letter-spacing: 0.16em; text-transform: uppercase;
    color: var(--amber);
    display: flex; align-items: center; gap: 10px;
    margin-bottom: 10px;
  }
  .page-eyebrow::after {
    content: ''; width: 40px; height: 0.5px;
    background: rgba(196,154,74,0.4);
  }
  .page-title {
    font-family: 'Cormorant Garamond', serif;
    font-size: 30px; font-weight: 400;
    color: var(--text); margin-bottom: 4px;
  }
  .page-title em { font-style: italic; color: var(--gold); }
  .page-sub { font-size: 13px; font-weight: 300; color: var(--muted); }

  .meta-pills { display: flex; gap: 8px; margin-top: 10px; flex-wrap: wrap; }
  .meta-pill {
    display: inline-flex; align-items: center; gap: 5px;
    padding: 3px 10px; border-radius: 999px;
    font-size: 11px; font-weight: 500;
  }
  .meta-pill.dept   { background: var(--amber-dim);  color: var(--amber);  border: 1px solid rgba(196,154,74,0.2);  }
  .meta-pill.role   { background: var(--blue-dim);   color: var(--blue);   border: 1px solid rgba(74,143,212,0.2);  }
  .meta-pill.id     { background: var(--purple-dim); color: var(--purple); border: 1px solid rgba(155,114,212,0.2); }

  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(14px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  /* ═══ SECTION LABEL ═══ */
  .section-label {
    font-size: 11px; font-weight: 500;
    letter-spacing: 0.14em; text-transform: uppercase;
    color: var(--mid);
    display: flex; align-items: center; gap: 10px;
    margin-bottom: 16px; margin-top: 32px;
  }
  .section-label::after {
    content: ''; flex: 1; height: 0.5px;
    background: var(--border);
  }
  .section-label:first-of-type { margin-top: 0; }

  /* ═══ GRID ═══ */
  .grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
    margin-bottom: 8px;
  }

  /* ═══ CARD ═══ */
  .card {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 16px;
    padding: 26px 26px 22px;
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

  /* future scope cards — dimmed */
  .card.future {
    opacity: 0.65;
  }
  .card.future:hover { opacity: 0.8; }

  .card-amber::before  { background: linear-gradient(to right, var(--amber),  transparent); }
  .card-blue::before   { background: linear-gradient(to right, var(--blue),   transparent); }
  .card-green::before  { background: linear-gradient(to right, var(--green),  transparent); }
  .card-purple::before { background: linear-gradient(to right, var(--purple), transparent); }
  .card-teal::before   { background: linear-gradient(to right, var(--teal),   transparent); }
  .card-rose::before   { background: linear-gradient(to right, var(--rose),   transparent); }
  .card-gold::before   { background: linear-gradient(to right, var(--gold),   transparent); }

  /* animation delays */
  .grid:nth-of-type(1) .card:nth-child(1) { animation-delay: 0.05s; }
  .grid:nth-of-type(1) .card:nth-child(2) { animation-delay: 0.10s; }
  .grid:nth-of-type(1) .card:nth-child(3) { animation-delay: 0.15s; }
  .grid:nth-of-type(2) .card:nth-child(1) { animation-delay: 0.20s; }
  .grid:nth-of-type(2) .card:nth-child(2) { animation-delay: 0.25s; }
  .grid:nth-of-type(2) .card:nth-child(3) { animation-delay: 0.30s; }
  .grid:nth-of-type(2) .card:nth-child(4) { animation-delay: 0.35s; }
  .grid:nth-of-type(3) .card:nth-child(1) { animation-delay: 0.40s; }

  .card-header {
    display: flex; align-items: center; gap: 12px;
    margin-bottom: 16px;
  }
  .card-icon {
    width: 40px; height: 40px; border-radius: 10px;
    display: flex; align-items: center; justify-content: center;
    flex-shrink: 0;
  }
  .card-icon svg { width: 18px; height: 18px; }
  .card-icon.amber  { background: var(--amber-dim);  color: var(--amber);  }
  .card-icon.blue   { background: var(--blue-dim);   color: var(--blue);   }
  .card-icon.green  { background: var(--green-dim);  color: var(--green);  }
  .card-icon.purple { background: var(--purple-dim); color: var(--purple); }
  .card-icon.teal   { background: var(--teal-dim);   color: var(--teal);   }
  .card-icon.rose   { background: var(--rose-dim);   color: var(--rose);   }
  .card-icon.gold   { background: var(--gold-dim);   color: var(--gold);   }

  .card-title {
    font-family: 'Cormorant Garamond', serif;
    font-size: 20px; font-weight: 500; color: var(--text);
  }
  .card-desc {
    font-size: 11px; font-weight: 400;
    color: var(--muted); margin-top: 1px;
  }

  /* future notice box */
  .future-notice {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 8px;
    padding: 10px 14px;
    font-size: 11px; font-weight: 400;
    color: var(--muted);
    display: flex; align-items: flex-start; gap: 8px;
    margin-bottom: 14px; line-height: 1.7;
  }
  .future-notice svg {
    width: 13px; height: 13px;
    flex-shrink: 0; margin-top: 2px;
    color: var(--amber);
  }
  .future-notice .by-loki {
    display: block;
    font-size: 10px; font-weight: 600;
    color: var(--amber); margin-top: 4px;
    letter-spacing: 0.06em;
  }

  /* action buttons */
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
    margin-bottom: 8px;
  }
  .action-btn:last-child { margin-bottom: 0; }
  .action-btn:hover {
    background: #1e1e1e; border-color: var(--border-h);
    color: var(--text); transform: translateY(-1px);
  }
  .action-btn:active { transform: translateY(0); }
  .action-btn svg { width: 15px; height: 15px; flex-shrink: 0; }

  .card-amber  .action-btn:hover { border-color: rgba(196,154,74,0.4);  color: var(--amber);  }
  .card-blue   .action-btn:hover { border-color: rgba(74,143,212,0.4);  color: var(--blue);   }
  .card-green  .action-btn:hover { border-color: rgba(90,158,114,0.4);  color: var(--green);  }
  .card-purple .action-btn:hover { border-color: rgba(155,114,212,0.4); color: var(--purple); }
  .card-teal   .action-btn:hover { border-color: rgba(74,168,160,0.4);  color: var(--teal);   }
  .card-gold   .action-btn:hover { border-color: rgba(201,168,76,0.4);  color: var(--gold);   }

  .action-btn.disabled {
    opacity: 0.35; cursor: not-allowed;
    pointer-events: none;
  }

  /* logout card button */
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
    .staff-badge .role-tag { display: none; }
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
    <div class="staff-badge">
      <div class="dot"></div>
      <span class="sname"><%= staffName %></span>
      <span class="role-tag"><%= staffRole %> &nbsp;·&nbsp; <%= department %></span>
    </div>
    <form action="AdminLogoutServlet" method="post" style="margin:0;">
      <button type="submit" class="logout-btn">Logout</button>
    </form>
  </div>
</header>

<!-- ═══ MAIN ═══ -->
<main>

  <div class="page-header">
    <div class="page-eyebrow">Staff Portal</div>
    <h1 class="page-title">Welcome, <em><%= staffName %></em></h1>
    <p class="page-sub">Your staff portal — view your profile, attendance and salary details</p>
    <div class="meta-pills">
      <span class="meta-pill id">Staff ID: <%= staffId %></span>
      <span class="meta-pill role"><%= staffRole %></span>
      <span class="meta-pill dept"><%= department %></span>
    </div>
  </div>

  <!-- ══════════════════════════════════
       SECTION 1 — ACTIVE FEATURES
  ══════════════════════════════════ -->
  <div class="section-label">Available Now</div>
  <div class="grid">

    <!-- My Profile -->
    <div class="card card-amber">
      <div class="card-header">
        <div class="card-icon amber">
          <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
            <circle cx="12" cy="7" r="4"/>
          </svg>
        </div>
        <div>
          <div class="card-title">My Profile</div>
          <div class="card-desc">View your personal and department details</div>
        </div>
      </div>
      <form action="StaffController" method="post">
        <button class="action-btn" name="action" value="viewProfile">
          <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
            <circle cx="12" cy="12" r="3"/>
          </svg>
          View My Profile
        </button>
      </form>
    </div>

    <!-- My Attendance -->
    <div class="card card-green">
      <div class="card-header">
        <div class="card-icon green">
          <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
            <path d="M9 11l3 3L22 4"/>
            <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/>
          </svg>
        </div>
        <div>
          <div class="card-title">My Attendance</div>
          <div class="card-desc">View your attendance count from admin records</div>
        </div>
      </div>
      <form action="StaffController" method="post">
        <button class="action-btn" name="action" value="viewAttendance">
          <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
            <circle cx="12" cy="12" r="3"/>
          </svg>
          View My Attendance
        </button>
      </form>
    </div>

    <!-- My Salary -->
    <div class="card card-blue">
      <div class="card-header">
        <div class="card-icon blue">
          <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
            <line x1="12" y1="1" x2="12" y2="23"/>
            <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
          </svg>
        </div>
        <div>
          <div class="card-title">My Salary</div>
          <div class="card-desc">View your current salary details</div>
        </div>
      </div>
      <form action="StaffController" method="post">
        <button class="action-btn" name="action" value="viewSalary">
          <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
            <circle cx="12" cy="12" r="3"/>
          </svg>
          View My Salary
        </button>
      </form>
    </div>

  </div>

  <!-- ══════════════════════════════════
       SECTION 2 — FUTURE FEATURES
  ══════════════════════════════════ -->
  <div class="section-label">Coming in Future</div>
  <div class="grid">

    <!-- Assigned Students -->
    <div class="card card-purple future">
      <div class="card-header">
        <div class="card-icon purple">
          <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
            <circle cx="9" cy="7" r="4"/>
            <path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/>
          </svg>
        </div>
        <div>
          <div class="card-title">Assigned Students</div>
          <div class="card-desc">View students under your department</div>
        </div>
      </div>
      <div class="future-notice">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <circle cx="12" cy="12" r="10"/>
          <line x1="12" y1="8" x2="12" y2="12"/>
          <line x1="12" y1="16" x2="12.01" y2="16"/>
        </svg>
        <div>
          Needs a <strong>Staff_Student</strong> mapping table in the database.
          Will function once staff-to-student assignment is implemented.
          <span class="by-loki">— By Loki</span>
        </div>
      </div>
      <button class="action-btn disabled">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
          <circle cx="12" cy="12" r="3"/>
        </svg>
        View Assigned Students
      </button>
    </div>

    <!-- Leave Request -->
    <div class="card card-teal future">
      <div class="card-header">
        <div class="card-icon teal">
          <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
            <rect x="3" y="4" width="18" height="18" rx="2"/>
            <line x1="16" y1="2" x2="16" y2="6"/>
            <line x1="8"  y1="2" x2="8"  y2="6"/>
            <line x1="3"  y1="10" x2="21" y2="10"/>
          </svg>
        </div>
        <div>
          <div class="card-title">Leave Request</div>
          <div class="card-desc">Apply for leave and track approval status</div>
        </div>
      </div>
      <div class="future-notice">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <circle cx="12" cy="12" r="10"/>
          <line x1="12" y1="8" x2="12" y2="12"/>
          <line x1="12" y1="16" x2="12.01" y2="16"/>
        </svg>
        <div>
          Needs a <strong>Leave_Request</strong> table with from_date, to_date, reason and approval status.
          <span class="by-loki">— By Loki</span>
        </div>
      </div>
      <button class="action-btn disabled">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <line x1="12" y1="5" x2="12" y2="19"/>
          <line x1="5"  y1="12" x2="19" y2="12"/>
        </svg>
        Apply for Leave
      </button>
    </div>

    <!-- Timetable -->
    <div class="card card-blue future">
      <div class="card-header">
        <div class="card-icon blue">
          <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
            <circle cx="12" cy="12" r="10"/>
            <polyline points="12 6 12 12 16 14"/>
          </svg>
        </div>
        <div>
          <div class="card-title">My Timetable</div>
          <div class="card-desc">View weekly class schedule and timings</div>
        </div>
      </div>
      <div class="future-notice">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <circle cx="12" cy="12" r="10"/>
          <line x1="12" y1="8" x2="12" y2="12"/>
          <line x1="12" y1="16" x2="12.01" y2="16"/>
        </svg>
        <div>
          Needs a <strong>Timetable</strong> table linking staff, course, day and time slot.
          <span class="by-loki">— By Loki</span>
        </div>
      </div>
      <button class="action-btn disabled">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
          <circle cx="12" cy="12" r="3"/>
        </svg>
        View Timetable
      </button>
    </div>

    <!-- Exam Results Entry -->
    <div class="card card-amber future">
      <div class="card-header">
        <div class="card-icon amber">
          <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
          </svg>
        </div>
        <div>
          <div class="card-title">Results Entry</div>
          <div class="card-desc">Enter student exam marks for your courses</div>
        </div>
      </div>
      <div class="future-notice">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <circle cx="12" cy="12" r="10"/>
          <line x1="12" y1="8" x2="12" y2="12"/>
          <line x1="12" y1="16" x2="12.01" y2="16"/>
        </svg>
        <div>
          Needs a <strong>Marks</strong> table with roll_number, course_id, exam_type and marks columns.
          <span class="by-loki">— By Loki</span>
        </div>
      </div>
      <button class="action-btn disabled">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <line x1="12" y1="5" x2="12" y2="19"/>
          <line x1="5"  y1="12" x2="19" y2="12"/>
        </svg>
        Enter Marks
      </button>
    </div>

    <!-- Announcements -->
    <div class="card card-gold future">
      <div class="card-header">
        <div class="card-icon gold">
          <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
            <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
          </svg>
        </div>
        <div>
          <div class="card-title">Announcements</div>
          <div class="card-desc">Read and post notices for students</div>
        </div>
      </div>
      <div class="future-notice">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <circle cx="12" cy="12" r="10"/>
          <line x1="12" y1="8" x2="12" y2="12"/>
          <line x1="12" y1="16" x2="12.01" y2="16"/>
        </svg>
        <div>
          Needs an <strong>Announcements</strong> table with title, content, target_role and posted_by columns.
          <span class="by-loki">— By Loki</span>
        </div>
      </div>
      <button class="action-btn disabled">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
          <circle cx="12" cy="12" r="3"/>
        </svg>
        View Announcements
      </button>
    </div>

    <!-- Internal Messaging -->
    <div class="card card-purple future">
      <div class="card-header">
        <div class="card-icon purple">
          <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
            <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
          </svg>
        </div>
        <div>
          <div class="card-title">Internal Messaging</div>
          <div class="card-desc">Send and receive messages with admin</div>
        </div>
      </div>
      <div class="future-notice">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <circle cx="12" cy="12" r="10"/>
          <line x1="12" y1="8" x2="12" y2="12"/>
          <line x1="12" y1="16" x2="12.01" y2="16"/>
        </svg>
        <div>
          Needs a <strong>Messages</strong> table with sender, receiver, message content and timestamp.
          <span class="by-loki">— By Loki</span>
        </div>
      </div>
      <button class="action-btn disabled">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
        </svg>
        Open Messages
      </button>
    </div>

  </div>

  <!-- ══════════════════════════════════
       SECTION 3 — LOGOUT
  ══════════════════════════════════ -->
  <div class="section-label">Session</div>
  <div class="grid" style="grid-template-columns: 1fr;">

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
  <span>Staff Portal &nbsp;·&nbsp; Secure Access</span>
</footer>

</body>
</html>