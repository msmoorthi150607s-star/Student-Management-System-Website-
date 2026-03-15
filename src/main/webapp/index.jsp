<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login – Menaka's ICL</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400&family=Jost:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --dark:       #0d0d0d;
    --panel:      #111111;
    --surface:    #181818;
    --border:     rgba(255,255,255,0.08);
    --text:       #f0ece6;
    --muted:      #7a7570;
    --mid:        #a09890;
    --gold:       #c9a84c;
    --gold-glow:  rgba(201,168,76,0.25);
    --blue:       #4a8fd4;
    --blue-dim:   rgba(74,143,212,0.15);
    --green:      #5a9e72;
    --green-dim:  rgba(90,158,114,0.15);
    --amber:      #c49a4a;
    --amber-dim:  rgba(196,154,74,0.15);
    --rose:       #c4706a;
    --accent:     #c9a84c;
  }

  html, body { height: 100%; }

  body {
    min-height: 100vh;
    font-family: 'Jost', sans-serif;
    background: var(--dark);
    display: flex;
    overflow: hidden;
  }

  /* ═══ LEFT PANEL ═══ */
  /* AFTER */
.left {
    width: 44%;
    min-height: 100vh;
    background: var(--panel);
    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    padding: 48px 48px 36px;
    overflow-x: hidden;      /* hide horizontal scrollbar */
    overflow-y: auto;        /* keep vertical scroll */
    flex-shrink: 0;
    border-right: 1px solid var(--border);
}

/* styled vertical scrollbar */
.left::-webkit-scrollbar {
    width: 4px;
}
.left::-webkit-scrollbar-track {
    background: transparent;
}
.left::-webkit-scrollbar-thumb {
    background: rgba(201,168,76,0.25);
    border-radius: 999px;
}
.left::-webkit-scrollbar-thumb:hover {
    background: rgba(201,168,76,0.5);
}
  .left::before {
    content: '';
    position: absolute; inset: 0;
    background-image:
      repeating-linear-gradient(45deg,  rgba(201,168,76,0.04) 0px, rgba(201,168,76,0.04) 1px, transparent 1px, transparent 56px),
      repeating-linear-gradient(-45deg, rgba(201,168,76,0.03) 0px, rgba(201,168,76,0.03) 1px, transparent 1px, transparent 56px);
    pointer-events: none;
  }
  .left::after {
    content: '';
    position: absolute; bottom: -120px; right: -120px;
    width: 400px; height: 400px; border-radius: 50%;
    background: radial-gradient(circle, rgba(201,168,76,0.1) 0%, transparent 70%);
    pointer-events: none;
  }

  .left-top, .left-bottom { position: relative; z-index: 1; }

  .monogram {
    width: 56px; height: 56px;
    border: 1.5px solid var(--gold); border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    margin-bottom: 32px; position: relative;
    animation: fadeUp 0.8s ease both;
    flex-shrink: 0;
  }
  .monogram::before {
    content: ''; position: absolute; inset: 5px; border-radius: 50%;
    border: 0.5px solid rgba(201,168,76,0.25);
  }
  .monogram span {
    font-family: 'Cormorant Garamond', serif;
    font-size: 20px; font-weight: 600; color: var(--gold);
  }

  .left-title {
    font-family: 'Cormorant Garamond', serif;
    font-size: 34px; font-weight: 400; color: var(--text);
    line-height: 1.2; margin-bottom: 16px;
    animation: fadeUp 0.8s 0.1s ease both;
  }
  .left-title em { font-style: italic; color: var(--gold); opacity: 0.85; }

  .left-rule {
    width: 36px; height: 1px;
    background: var(--gold); opacity: 0.4;
    margin: 0 0 16px;
    animation: fadeUp 0.8s 0.2s ease both;
  }

  .left-desc {
    font-size: 12px; font-weight: 300;
    color: rgba(255,255,255,0.35);
    line-height: 1.9; max-width: 270px;
    margin-bottom: 28px;
    animation: fadeUp 0.8s 0.3s ease both;
  }

  /* ── About Section ── */
  .about-section {
    position: relative; z-index: 1;
    animation: fadeUp 0.8s 0.4s ease both;
  }

  .about-divider {
    height: 1px;
    background: linear-gradient(to right, rgba(201,168,76,0.3), transparent);
    margin-bottom: 20px;
  }

  /* developer card */
  .dev-card {
    background: rgba(255,255,255,0.03);
    border: 1px solid rgba(255,255,255,0.07);
    border-radius: 12px;
    padding: 16px 18px;
    margin-bottom: 16px;
    display: flex;
    align-items: center;
    gap: 14px;
}

.dev-card img {
    display: block;
    width: 44px;
    height: 44px;
    border-radius: 50%;
    object-fit: cover;
    object-position: center top;
    flex-shrink: 0;
}
  .dev-avatar {
    width: 44px; height: 44px;
    border-radius: 50%;
    flex-shrink: 0;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
}
  .dev-info { flex: 1; min-width: 0; }
  .dev-name {
    font-size: 13px; font-weight: 600;
    color: var(--text); letter-spacing: 0.02em;
    margin-bottom: 3px;
  }
  .dev-title {
    font-size: 11px; font-weight: 300;
    color: rgba(255,255,255,0.4);
    line-height: 1.4;
  }
  .dev-github {
    display: inline-flex; align-items: center; gap: 5px;
    margin-top: 6px;
    font-size: 10px; font-weight: 500;
    color: var(--gold); text-decoration: none;
    letter-spacing: 0.04em;
    transition: color 0.2s;
  }
  .dev-github:hover { color: #e8c97a; }
  .dev-github svg { width: 11px; height: 11px; }

  /* about sub label */
  .about-label {
    font-size: 10px; font-weight: 600;
    letter-spacing: 0.12em; text-transform: uppercase;
    color: var(--gold); opacity: 0.7;
    margin-bottom: 10px;
    display: flex; align-items: center; gap: 8px;
  }
  .about-label::after {
    content: ''; flex: 1; height: 0.5px;
    background: rgba(201,168,76,0.2);
  }

  /* journey items */
  .journey-list {
    display: flex; flex-direction: column; gap: 7px;
    margin-bottom: 16px;
  }
  .journey-item {
    display: flex; align-items: flex-start; gap: 9px;
    font-size: 11px; font-weight: 300;
    color: rgba(255,255,255,0.4);
    line-height: 1.6;
  }
  .journey-dot {
    width: 5px; height: 5px; border-radius: 50%;
    background: var(--gold); opacity: 0.5;
    flex-shrink: 0; margin-top: 5px;
  }
  .journey-item strong {
    color: rgba(255,255,255,0.65);
    font-weight: 500;
  }

  /* next steps */
  .next-steps {
    background: rgba(201,168,76,0.05);
    border: 1px solid rgba(201,168,76,0.12);
    border-radius: 10px;
    padding: 14px 16px;
    margin-bottom: 16px;
  }
  .next-step-item {
    display: flex; align-items: flex-start; gap: 8px;
    font-size: 11px; font-weight: 300;
    color: rgba(255,255,255,0.38);
    line-height: 1.6; margin-bottom: 5px;
  }
  .next-step-item:last-child { margin-bottom: 0; }
  .next-step-icon {
    width: 4px; height: 4px; border-radius: 50%;
    background: var(--gold); opacity: 0.6;
    flex-shrink: 0; margin-top: 6px;
  }

  .left-year {
    font-size: 10px; font-weight: 300;
    color: rgba(255,255,255,0.15);
    letter-spacing: 0.14em; text-transform: uppercase;
    position: relative; z-index: 1;
    margin-top: 20px;
  }

  .deco-letter {
    position: absolute; bottom: -40px; right: -24px;
    font-family: 'Cormorant Garamond', serif;
    font-size: 200px; font-weight: 600;
    color: rgba(255,255,255,0.015);
    line-height: 1; pointer-events: none;
    user-select: none; z-index: 0;
  }

  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(18px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  /* ═══ RIGHT PANEL ═══ */
  .right {
    flex: 1;
    display: flex; align-items: center; justify-content: center;
    padding: 48px 56px;
    background: var(--dark);
    position: relative; overflow-y: auto;
  }
  .right::before {
    content: '';
    position: absolute; top: 36px; right: 36px;
    width: 28px; height: 28px;
    border-top: 1px solid rgba(201,168,76,0.2);
    border-right: 1px solid rgba(201,168,76,0.2);
  }
  .right::after {
    content: '';
    position: absolute; bottom: 36px; left: 36px;
    width: 28px; height: 28px;
    border-bottom: 1px solid rgba(201,168,76,0.2);
    border-left: 1px solid rgba(201,168,76,0.2);
  }

  .form-wrap {
    width: 100%; max-width: 360px;
    animation: fadeUp 0.6s 0.15s ease both;
  }

  .form-eyebrow {
    font-size: 11px; font-weight: 500;
    letter-spacing: 0.16em; text-transform: uppercase;
    color: var(--gold);
    display: flex; align-items: center; gap: 10px;
    margin-bottom: 12px;
  }
  .form-eyebrow::after {
    content: ''; flex: 1; height: 0.5px;
    background: linear-gradient(to right, rgba(201,168,76,0.4), transparent);
  }

  .form-title {
    font-family: 'Cormorant Garamond', serif;
    font-size: 32px; font-weight: 400;
    color: var(--text); margin-bottom: 6px;
  }
  .form-sub {
    font-size: 13px; font-weight: 300;
    color: var(--muted); margin-bottom: 28px;
  }

  /* ── Role Toggle ── */
  .role-toggle {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 8px; margin-bottom: 24px;
    background: var(--surface);
    border-radius: 12px; padding: 5px;
    border: 1px solid var(--border);
  }

  .role-btn {
    padding: 10px 0; border: none;
    border-radius: 8px; background: transparent;
    font-family: 'Jost', sans-serif;
    font-size: 13px; font-weight: 500;
    color: var(--muted); cursor: pointer;
    display: flex; align-items: center;
    justify-content: center; gap: 7px;
    transition: background 0.2s, color 0.2s, box-shadow 0.2s;
  }
  .role-btn svg { width: 14px; height: 14px; flex-shrink: 0; }

  .role-btn.active-admin {
    background: #1a1a1a; color: var(--blue);
    box-shadow: 0 1px 8px rgba(0,0,0,0.4);
    border: 1px solid rgba(74,143,212,0.2);
  }
  .role-btn.active-student {
    background: #1a1a1a; color: var(--green);
    box-shadow: 0 1px 8px rgba(0,0,0,0.4);
    border: 1px solid rgba(90,158,114,0.2);
  }
  .role-btn.active-staff {
    background: #1a1a1a; color: var(--amber);
    box-shadow: 0 1px 8px rgba(0,0,0,0.4);
    border: 1px solid rgba(196,154,74,0.2);
  }

  .role-pill {
    display: inline-flex; align-items: center; gap: 6px;
    padding: 4px 12px; border-radius: 999px;
    font-size: 11px; font-weight: 500;
    letter-spacing: 0.05em; text-transform: uppercase;
    margin-bottom: 22px; transition: all 0.3s;
  }
  .role-pill::before {
    content: '';
    width: 5px; height: 5px; border-radius: 50%;
    background: currentColor;
    animation: pulse 2s infinite;
  }
  @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.4} }
  .role-pill.admin   { background: var(--blue-dim);  color: var(--blue);  border: 1px solid rgba(74,143,212,0.2);  }
  .role-pill.student { background: var(--green-dim); color: var(--green); border: 1px solid rgba(90,158,114,0.2);  }
  .role-pill.staff   { background: var(--amber-dim); color: var(--amber); border: 1px solid rgba(196,154,74,0.2);  }

  /* ── Fields ── */
  .field { margin-bottom: 20px; }
  .field label {
    display: block;
    font-size: 11px; font-weight: 500;
    letter-spacing: 0.1em; text-transform: uppercase;
    color: var(--mid); margin-bottom: 8px;
  }
  .field-hint {
    font-size: 11px; font-weight: 300;
    color: var(--muted); margin-top: 5px;
  }

  .input-wrap { position: relative; }

  .input-wrap input {
    width: 100%;
    padding: 12px 40px 12px 14px;
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 10px;
    font-family: 'Jost', sans-serif;
    font-size: 14px; font-weight: 400;
    color: var(--text); outline: none;
    transition: border-color 0.2s, background 0.2s, box-shadow 0.2s;
  }
  .input-wrap input::placeholder {
    color: rgba(255,255,255,0.18); font-weight: 300;
  }
  .input-wrap input:focus {
    border-color: var(--accent);
    background: #1c1c1c;
    box-shadow: 0 0 0 3px var(--gold-glow);
  }
  .admin-focus:focus {
    border-color: var(--blue) !important;
    box-shadow: 0 0 0 3px rgba(74,143,212,0.2) !important;
  }
  .student-focus:focus {
    border-color: var(--green) !important;
    box-shadow: 0 0 0 3px rgba(90,158,114,0.2) !important;
  }
  .staff-focus:focus {
    border-color: var(--amber) !important;
    box-shadow: 0 0 0 3px rgba(196,154,74,0.2) !important;
  }

  .eye-btn {
    position: absolute; right: 12px; top: 50%;
    transform: translateY(-50%);
    background: none; border: none; cursor: pointer;
    color: var(--muted); padding: 4px;
    transition: color 0.2s;
    display: flex; align-items: center;
  }
  .eye-btn:hover { color: var(--text); }

  .row {
    display: flex; justify-content: flex-end;
    margin: 4px 0 24px;
  }
  .forgot {
    font-size: 12px; font-weight: 400;
    color: var(--muted); text-decoration: none;
    transition: color 0.2s;
  }
  .forgot:hover { color: var(--gold); }

  /* ── Buttons ── */
  .btn {
    width: 100%; padding: 13px; border: none;
    border-radius: 10px;
    font-family: 'Jost', sans-serif;
    font-size: 12px; font-weight: 600;
    letter-spacing: 0.16em; text-transform: uppercase;
    color: #fff; cursor: pointer;
    position: relative; overflow: hidden;
    transition: transform 0.15s, filter 0.2s;
  }
  .btn::before {
    content: ''; position: absolute; inset: 0;
    opacity: 0; background: rgba(255,255,255,0.06);
    transition: opacity 0.3s;
  }
  .btn:hover::before { opacity: 1; }
  .btn:hover  { transform: translateY(-1px); filter: brightness(1.07); }
  .btn:active { transform: translateY(0); }

  .btn.admin-btn {
    background: linear-gradient(135deg, #2d6bb5, #1a4f8a);
    box-shadow: 0 4px 20px rgba(45,107,181,0.35);
  }
  .btn.student-btn {
    background: linear-gradient(135deg, #4a8a62, #2e6044);
    box-shadow: 0 4px 20px rgba(74,138,98,0.35);
  }
  .btn.staff-btn {
    background: linear-gradient(135deg, #b8873a, #8a6020);
    box-shadow: 0 4px 20px rgba(184,135,58,0.35);
  }

  /* ── Error ── */
  .error-msg {
    background: rgba(176,48,42,0.12); color: #e07070;
    border: 1px solid rgba(176,48,42,0.3);
    border-radius: 9px; padding: 10px 14px;
    font-size: 13px; margin-bottom: 18px;
    display: flex; align-items: center; gap: 8px;
  }
  .error-msg::before {
    content: '!';
    width: 18px; height: 18px; border-radius: 50%;
    background: rgba(176,48,42,0.5); color: #e07070;
    font-size: 11px; font-weight: 700;
    display: flex; align-items: center; justify-content: center;
    flex-shrink: 0;
  }

  .form-footer {
    margin-top: 24px; text-align: center;
    font-size: 11px; font-weight: 300;
    color: rgba(255,255,255,0.18); letter-spacing: 0.04em;
  }

  @media (max-width: 820px) {
    body { flex-direction: column; overflow: auto; }
    .left {
      width: 100%; min-height: auto;
      padding: 40px 32px 32px;
      border-right: none; border-bottom: 1px solid var(--border);
    }
    .left-title { font-size: 28px; }
    .deco-letter { display: none; }
    .right { padding: 36px 24px; }
  }
</style>
</head>
<body>

<!-- ═══ LEFT PANEL ═══ -->
<div class="left">
  <div class="left-top">
    <div class="monogram"><span>M</span></div>
    <h1 class="left-title">Shaping minds,<br><em>inspiring futures.</em></h1>
    <div class="left-rule"></div>
    <p class="left-desc">Menaka's International Center for Learning — a legacy of academic excellence and holistic development.</p>
  </div>

  <!-- ── About Section ── -->
  <div class="about-section">

    <div class="about-divider"></div>

    <!-- Developer Card -->
    <div class="dev-card">
      <div class="dev-avatar">
  <img src="images/profile.png" alt="Sundar M"
       style="filter: brightness(1.4) contrast(1.1);">
</div>
      <div class="dev-info">
        <div class="dev-name">Sundar M</div>
        <div class="dev-title">Drive to become a Java Backend Developer</div>
        <a href="https://github.com/msmoorthi150607s-star"
           target="_blank" class="dev-github">
          <svg fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0 0 24 12c0-6.63-5.37-12-12-12z"/>
          </svg>
          msmoorthi150607s-star (HexMist)
        </a>
      </div>
    </div>

    <!-- Journey -->
    <div class="about-label">My Journey</div>
    <div class="journey-list">
      <div class="journey-item">
        <div class="journey-dot"></div>
        <span><strong>Bus Reservation System</strong> — OOP design and CRUD with in-memory collections.</span>
      </div>
      <div class="journey-item">
        <div class="journey-dot"></div>
        <span><strong>Bank Management System</strong> — transactions, validations and business rules.</span>
      </div>
      <div class="journey-item">
        <div class="journey-dot"></div>
        <span><strong>Student Management (JDBC)</strong> — persistence, schema design and transaction safety.</span>
      </div>
      <div class="journey-item">
        <div class="journey-dot"></div>
        <span><strong>Student Management (Web)</strong> — Servlets, JSP, MVC, sessions and MySQL. You are here now.</span>
      </div>
    </div>

    <!-- Next Steps -->
    <div class="about-label">Next Steps</div>
    <div class="next-steps">
      <div class="next-step-item">
        <div class="next-step-icon"></div>
        <span>Add attendance and payment tracking modules</span>
      </div>
      <div class="next-step-item">
        <div class="next-step-icon"></div>
        <span>Give staff access to manage grades, marks and attendance</span>
      </div>
      <div class="next-step-item">
        <div class="next-step-icon"></div>
        <span>Admin control over staff attendance and performance</span>
      </div>
      <div class="next-step-item">
        <div class="next-step-icon"></div>
        <span>Migrate to Spring Boot for enterprise-grade architecture</span>
      </div>
      <div class="next-step-item">
        <div class="next-step-icon"></div>
        <span>Add two-step OTP-based login for enhanced security</span>
      </div>
    </div>

  </div>

  <div class="left-bottom">
    <p class="left-year">Est. since excellence</p>
  </div>

  <div class="deco-letter">M</div>
</div>

<!-- ═══ RIGHT PANEL ═══ -->
<div class="right">
  <div class="form-wrap">

    <div class="form-eyebrow">Academic Portal</div>
    <h2 class="form-title">Welcome back</h2>
    <p class="form-sub">Choose your role and sign in to continue</p>

    <!-- ── Role Toggle ── -->
    <div class="role-toggle">
      <button type="button" class="role-btn active-admin" id="btnAdmin" onclick="setRole('admin')">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M12 2a5 5 0 1 1 0 10A5 5 0 0 1 12 2z"/>
          <path d="M3 20c0-4 3.6-7 9-7s9 3 9 7"/>
        </svg>
        Admin
      </button>
      <button type="button" class="role-btn" id="btnStudent" onclick="setRole('student')">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
          <path d="M6 12v5c0 2 2 3 6 3s6-1 6-3v-5"/>
        </svg>
        Student
      </button>
      <button type="button" class="role-btn" id="btnStaff" onclick="setRole('staff')">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
          <circle cx="12" cy="7" r="4"/>
        </svg>
        Staff
      </button>
    </div>

    <div class="role-pill admin" id="rolePill">Admin Login</div>

    <%-- Server-side error message --%>
    <% String errorMsg = (String) request.getAttribute("errorMsg");
       if (errorMsg != null && !errorMsg.isEmpty()) { %>
      <div class="error-msg"><%= errorMsg %></div>
    <% } %>

    <!-- ═══ ADMIN FORM ═══ -->
    <form id="adminForm" action="adminLogin" method="post" autocomplete="off">
      <div class="field">
        <label>Username or Email</label>
        <div class="input-wrap">
          <input type="text" name="userOrEmail"
                 placeholder="your@email.com"
                 class="admin-focus" required>
        </div>
      </div>
      <div class="field">
        <label>Password</label>
        <div class="input-wrap">
          <input type="password" name="password" id="adminPwd"
                 placeholder="••••••••" class="admin-focus" required>
          <button type="button" class="eye-btn" onclick="togglePwd('adminPwd', this)">
            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
              <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
            </svg>
          </button>
        </div>
      </div>
      <div class="row"><a href="#" class="forgot">Forgot password?</a></div>
      <button type="submit" class="btn admin-btn">Login as Admin</button>
    </form>

    <!-- ═══ STUDENT FORM ═══ -->
    <form id="studentForm" action="studentLoginVerifier" method="post"
          autocomplete="off" style="display:none;">
      <div class="field">
        <label>Roll Number</label>
        <div class="input-wrap">
          <input type="text" name="roll_number"
                 placeholder="e.g. STU001"
                 class="student-focus" maxlength="10" required>
        </div>
        <p class="field-hint">Enter your roll number as given by the institution</p>
      </div>
      <div class="field">
        <label>Password</label>
        <div class="input-wrap">
          <input type="password" name="password" id="stuPwd"
                 placeholder="Enter your contact number" class="student-focus" required>
          <button type="button" class="eye-btn" onclick="togglePwd('stuPwd', this)">
            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
              <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
            </svg>
          </button>
        </div>
        <p class="field-hint">Your password is your registered contact number</p>
      </div>
      <div class="row"><a href="#" class="forgot">Forgot password?</a></div>
      <button type="submit" class="btn student-btn">Login as Student</button>
    </form>

    <!-- ═══ STAFF FORM ═══ -->
    <form id="staffForm" action="staffVerifier" method="post"
          autocomplete="off" style="display:none;">
      <div class="field">
        <label>Staff ID</label>
        <div class="input-wrap">
          <input type="text" name="staff_id"
                 placeholder="e.g. 1"
                 class="staff-focus" required>
        </div>
        <p class="field-hint">Enter your numeric Staff ID</p>
      </div>
      <div class="field">
        <label>Password</label>
        <div class="input-wrap">
          <input type="password" name="password" id="staffPwd"
                 placeholder="••••••••" class="staff-focus" required>
          <button type="button" class="eye-btn" onclick="togglePwd('staffPwd', this)">
            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
              <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
            </svg>
          </button>
        </div>
        <p class="field-hint">Your password is your Staff ID</p>
      </div>
      <div class="row"><a href="#" class="forgot">Forgot password?</a></div>
      <button type="submit" class="btn staff-btn">Login as Staff</button>
    </form>

    <div class="form-footer">Menaka's ICL &nbsp;·&nbsp; Secure Access</div>
  </div>
</div>

<script>
  const eyeOpen   = `<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>`;
  const eyeClosed = `<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/><path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/><line x1="1" y1="1" x2="23" y2="23"/>`;
  const pwdState  = {};

  function togglePwd(id, btn) {
    const input = document.getElementById(id);
    const icon  = btn.querySelector('svg');
    pwdState[id] = !pwdState[id];
    input.type   = pwdState[id] ? 'text' : 'password';
    icon.innerHTML = pwdState[id] ? eyeClosed : eyeOpen;
  }

  function setRole(role) {
    const isAdmin   = role === 'admin';
    const isStudent = role === 'student';
    const isStaff   = role === 'staff';

    document.getElementById('adminForm').style.display   = isAdmin   ? '' : 'none';
    document.getElementById('studentForm').style.display = isStudent ? '' : 'none';
    document.getElementById('staffForm').style.display   = isStaff   ? '' : 'none';

    document.getElementById('btnAdmin').className   = 'role-btn' + (isAdmin   ? ' active-admin'   : '');
    document.getElementById('btnStudent').className = 'role-btn' + (isStudent ? ' active-student' : '');
    document.getElementById('btnStaff').className   = 'role-btn' + (isStaff   ? ' active-staff'   : '');

    const pill = document.getElementById('rolePill');
    pill.textContent = isAdmin ? 'Admin Login' : isStudent ? 'Student Login' : 'Staff Login';
    pill.className   = 'role-pill ' + role;
  }
</script>

</body>
</html>