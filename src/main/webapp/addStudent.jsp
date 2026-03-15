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
    String message     = (String) request.getAttribute("message");
    String messageType = (String) request.getAttribute("messageType");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Add Student – Menaka's ICL</title>
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

  /* ═══ MESSAGE ═══ */
  .msg {
    padding: 12px 16px; border-radius: 10px;
    font-size: 13px; font-weight: 500;
    margin-bottom: 24px;
    display: flex; align-items: center; gap: 10px;
    animation: fadeUp 0.4s ease both;
  }
  .msg.success {
    background: var(--green-dim); color: var(--green);
    border: 1px solid rgba(90,158,114,0.25);
  }
  .msg.error {
    background: var(--rose-dim); color: var(--rose);
    border: 1px solid rgba(196,112,106,0.25);
  }
  .msg svg { width: 15px; height: 15px; flex-shrink: 0; }

  /* ═══ FORM CARD ═══ */
  .form-card {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 16px;
    padding: 32px;
    max-width: 700px;
    animation: fadeUp 0.5s 0.05s ease both;
    position: relative; overflow: hidden;
  }
  .form-card::before {
    content: '';
    position: absolute; top: 0; left: 0; right: 0; height: 2px;
    background: linear-gradient(to right, var(--blue), transparent);
  }

  .section-title {
    font-size: 11px; font-weight: 500;
    letter-spacing: 0.12em; text-transform: uppercase;
    color: var(--blue);
    display: flex; align-items: center; gap: 10px;
    margin-bottom: 20px;
  }
  .section-title::after {
    content: ''; flex: 1; height: 0.5px;
    background: rgba(74,143,212,0.2);
  }

  /* ── Form Grid ── */
  .form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 18px;
    margin-bottom: 18px;
  }
  .form-group { display: flex; flex-direction: column; gap: 7px; }
  .form-group.full { grid-column: 1 / -1; }

  .form-group label {
    font-size: 11px; font-weight: 500;
    letter-spacing: 0.08em; text-transform: uppercase;
    color: var(--mid);
  }

  .form-group input,
  .form-group select {
    padding: 11px 14px;
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 10px;
    font-family: 'Jost', sans-serif;
    font-size: 14px; font-weight: 400;
    color: var(--text); outline: none;
    transition: border-color 0.2s, background 0.2s, box-shadow 0.2s;
    width: 100%;
  }
  .form-group input::placeholder { color: rgba(255,255,255,0.2); }
  .form-group input:focus,
  .form-group select:focus {
    border-color: var(--blue);
    background: #1c1c1c;
    box-shadow: 0 0 0 3px rgba(74,143,212,0.15);
  }
  .form-group select option { background: var(--surface); color: var(--text); }

  /* ── Buttons ── */
  .btn-row {
    display: flex; gap: 12px; margin-top: 8px;
  }
  .btn-submit {
    flex: 1; padding: 13px;
    background: linear-gradient(135deg, #2d6bb5, #1a4f8a);
    border: none; border-radius: 10px;
    font-family: 'Jost', sans-serif;
    font-size: 12px; font-weight: 600;
    letter-spacing: 0.14em; text-transform: uppercase;
    color: #fff; cursor: pointer;
    box-shadow: 0 4px 20px rgba(45,107,181,0.3);
    transition: transform 0.15s, filter 0.2s;
  }
  .btn-submit:hover { transform: translateY(-1px); filter: brightness(1.07); }
  .btn-submit:active { transform: translateY(0); }

  .btn-reset {
    padding: 13px 20px;
    background: transparent;
    border: 1px solid var(--border-h);
    border-radius: 10px;
    font-family: 'Jost', sans-serif;
    font-size: 12px; font-weight: 500;
    letter-spacing: 0.08em; text-transform: uppercase;
    color: var(--mid); cursor: pointer;
    transition: border-color 0.2s, color 0.2s;
  }
  .btn-reset:hover { border-color: var(--rose); color: var(--rose); }

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
    .form-grid { grid-template-columns: 1fr; }
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
    <h1 class="page-title">Add <em>Student</em></h1>
    <p class="page-sub">Fill in the details to register a new student</p>
  </div>

  <%-- Message --%>
  <% if (message != null) { %>
    <div class="msg <%= messageType %>">
      <% if ("success".equals(messageType)) { %>
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
          <polyline points="22 4 12 14.01 9 11.01"/>
        </svg>
      <% } else { %>
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <circle cx="12" cy="12" r="10"/>
          <line x1="12" y1="8" x2="12" y2="12"/>
          <line x1="12" y1="16" x2="12.01" y2="16"/>
        </svg>
      <% } %>
      <%= message %>
    </div>
  <% } %>

  <div class="form-card">
    <div class="section-title">Student Information</div>

    <form action="AdminController" method="post" autocomplete="off">
      <input type="hidden" name="action" value="addStudentSubmit">

      <div class="form-grid">

        <div class="form-group">
          <label>Roll Number</label>
          <input type="text" name="roll_number"
                 placeholder="e.g. STU011" maxlength="10" required>
        </div>

        <div class="form-group">
          <label>Student Name</label>
          <input type="text" name="student_name"
                 placeholder="Full name" required>
        </div>

        <div class="form-group">
          <label>Age</label>
          <input type="number" name="age"
                 placeholder="e.g. 15" min="5" max="25" required>
        </div>

        <div class="form-group">
          <label>Grade</label>
          <select name="grade" required>
            <option value="" disabled selected>Select Grade</option>
            <option value="1">Grade 1</option>
            <option value="2">Grade 2</option>
            <option value="3">Grade 3</option>
            <option value="4">Grade 4</option>
            <option value="5">Grade 5</option>
            <option value="6">Grade 6</option>
            <option value="7">Grade 7</option>
            <option value="8">Grade 8</option>
            <option value="9">Grade 9</option>
            <option value="10">Grade 10</option>
            <option value="11">Grade 11</option>
            <option value="12">Grade 12</option>
          </select>
        </div>

        <div class="form-group">
          <label>Section</label>
          <select name="section" required>
            <option value="" disabled selected>Select Section</option>
            <option value="A">Section A</option>
            <option value="B">Section B</option>
            <option value="C">Section C</option>
            <option value="D">Section D</option>
          </select>
        </div>

        <div class="form-group">
          <label>Fees (INR)</label>
          <input type="number" name="fees"
                 placeholder="e.g. 15000" min="0" step="0.01" required>
        </div>

        <div class="form-group">
          <label>Parent Name</label>
          <input type="text" name="parent_name"
                 placeholder="Parent / Guardian name" required>
        </div>

        <div class="form-group">
          <label>Contact Number</label>
          <input type="text" name="contact_number"
                 placeholder="10-digit number"
                 maxlength="15" required>
        </div>

        <div class="form-group full">
          <label>Address</label>
          <input type="text" name="address"
                 placeholder="City / Full address">
        </div>

      </div>

      <div class="btn-row">
        <button type="submit" class="btn-submit">Add Student</button>
        <button type="reset"  class="btn-reset">Reset</button>
      </div>

    </form>
  </div>
</main>

<!-- ═══ FOOTER ═══ -->
<footer>
  <span>Menaka's International Center for Learning</span>
  <span>Admin Panel &nbsp;·&nbsp; Secure Access</span>
</footer>

</body>
</html>
