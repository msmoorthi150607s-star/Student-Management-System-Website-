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
    List<Object[]> feeList = (List<Object[]>) request.getAttribute("feeList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Fees – Menaka's ICL</title>
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
    --amber:     #c49a4a;
    --amber-dim: rgba(196,154,74,0.12);
    --rose:      #c4706a;
    --rose-dim:  rgba(196,112,106,0.12);
    --blue:      #4a8fd4;
    --blue-dim:  rgba(74,143,212,0.12);
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
  .back-btn:hover { border-color: var(--amber); color: var(--amber); }
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

  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(14px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  /* ═══ SUMMARY CARDS ═══ */
  .summary-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 16px;
    margin-bottom: 28px;
    animation: fadeUp 0.5s 0.05s ease both;
  }

  .summary-card {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 14px;
    padding: 20px 22px;
    position: relative; overflow: hidden;
    transition: border-color 0.2s;
  }
  .summary-card:hover { border-color: var(--border-h); }
  .summary-card::before {
    content: '';
    position: absolute; top: 0; left: 0; right: 0; height: 2px;
  }
  .summary-card.total::before  { background: linear-gradient(to right, var(--amber), transparent); }
  .summary-card.status::before { background: linear-gradient(to right, var(--green), transparent); }
  .summary-card.due::before    { background: linear-gradient(to right, var(--blue),  transparent); }

  .summary-label {
    font-size: 11px; font-weight: 500;
    letter-spacing: 0.1em; text-transform: uppercase;
    color: var(--muted); margin-bottom: 10px;
    display: flex; align-items: center; gap: 6px;
  }
  .summary-label svg { width: 12px; height: 12px; }

  .summary-value {
    font-family: 'Cormorant Garamond', serif;
    font-size: 26px; font-weight: 600;
    color: var(--text);
  }
  .summary-value.amber { color: var(--amber); }
  .summary-value.green { color: var(--green); }
  .summary-value.rose  { color: var(--rose);  }
  .summary-value.blue  { color: var(--blue);  }

  /* ═══ FEE TABLE CARD ═══ */
  .table-card {
    background: var(--card);
    border: 1px solid var(--border);
    border-radius: 16px;
    overflow: hidden;
    animation: fadeUp 0.5s 0.1s ease both;
  }

  .table-card-header {
    padding: 20px 24px;
    border-bottom: 1px solid var(--border);
    display: flex; align-items: center; gap: 10px;
  }
  .table-card-title {
    font-size: 11px; font-weight: 500;
    letter-spacing: 0.12em; text-transform: uppercase;
    color: var(--amber);
    display: flex; align-items: center; gap: 10px;
    flex: 1;
  }
  .table-card-title::after {
    content: ''; flex: 1; height: 0.5px;
    background: rgba(196,154,74,0.2);
  }

  table {
    width: 100%; border-collapse: collapse;
  }
  thead tr {
    background: var(--surface);
    border-bottom: 1px solid var(--border);
  }
  thead th {
    padding: 12px 24px;
    font-size: 10px; font-weight: 600;
    letter-spacing: 0.1em; text-transform: uppercase;
    color: var(--muted); text-align: left;
  }
  tbody tr {
    border-bottom: 1px solid var(--border);
    transition: background 0.15s;
  }
  tbody tr:last-child { border-bottom: none; }
  tbody tr:hover { background: var(--surface); }

  tbody td {
    padding: 16px 24px;
    font-size: 13px; font-weight: 400;
    color: var(--mid);
  }

  .fee-id {
    font-size: 11px; font-weight: 500;
    color: var(--muted);
    font-family: monospace;
  }

  .fee-amount {
    font-family: 'Cormorant Garamond', serif;
    font-size: 18px; font-weight: 600;
    color: var(--amber);
  }

  /* status badge */
  .status-badge {
    display: inline-flex; align-items: center; gap: 5px;
    padding: 4px 10px; border-radius: 999px;
    font-size: 11px; font-weight: 600;
    letter-spacing: 0.05em; text-transform: uppercase;
  }
  .status-badge::before {
    content: '';
    width: 5px; height: 5px; border-radius: 50%;
    background: currentColor;
  }
  .status-badge.paid {
    background: var(--green-dim); color: var(--green);
    border: 1px solid rgba(90,158,114,0.25);
  }
  .status-badge.pending {
    background: var(--rose-dim); color: var(--rose);
    border: 1px solid rgba(196,112,106,0.25);
    animation: blink 2s infinite;
  }
  @keyframes blink { 0%,100%{opacity:1} 50%{opacity:0.6} }

  .due-date {
    font-size: 12px; font-weight: 400;
    color: var(--mid);
  }

  /* empty state */
  .empty-state {
    padding: 48px 24px;
    text-align: center;
  }
  .empty-state svg {
    width: 40px; height: 40px;
    color: var(--muted); margin-bottom: 12px;
  }
  .empty-state p {
    font-size: 13px; color: var(--muted);
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

  @media (max-width: 820px) {
    header { padding: 0 20px; }
    main   { padding: 28px 20px 40px; }
    footer { padding: 14px 20px; }
    .summary-grid { grid-template-columns: 1fr; }
    thead th, tbody td { padding: 12px 16px; }
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
    <h1 class="page-title">Fee <em>Details</em></h1>
    <p class="page-sub">Your fee payment records — <%= rollNumber %></p>
  </div>

  <%
    // Calculate summary values
    double totalAmount = 0;
    int paidCount = 0, pendingCount = 0;
    String overallStatus = "PAID";
    String latestDueDate = "—";

    if (feeList != null) {
      for (Object[] fee : feeList) {
        totalAmount += (Double) fee[1];
        String st = (String) fee[2];
        if ("PAID".equals(st))    paidCount++;
        else                      { pendingCount++; overallStatus = "PENDING"; }
        latestDueDate = (String) fee[3];
      }
    }
  %>

  <!-- ═══ SUMMARY CARDS ═══ -->
  <div class="summary-grid">

    <div class="summary-card total">
      <div class="summary-label">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <line x1="12" y1="1" x2="12" y2="23"/>
          <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
        </svg>
        Total Amount
      </div>
      <div class="summary-value amber">₹ <%= String.format("%,.2f", totalAmount) %></div>
    </div>

    <div class="summary-card status">
      <div class="summary-label">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
          <polyline points="22 4 12 14.01 9 11.01"/>
        </svg>
        Payment Status
      </div>
      <div class="summary-value <%= "PAID".equals(overallStatus) ? "green" : "rose" %>">
        <%= overallStatus %>
      </div>
    </div>

    <div class="summary-card due">
      <div class="summary-label">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <rect x="3" y="4" width="18" height="18" rx="2"/>
          <line x1="16" y1="2" x2="16" y2="6"/>
          <line x1="8"  y1="2" x2="8"  y2="6"/>
          <line x1="3"  y1="10" x2="21" y2="10"/>
        </svg>
        Due Date
      </div>
      <div class="summary-value blue" style="font-size:20px;"><%= latestDueDate %></div>
    </div>

  </div>

  <!-- ═══ FEE TABLE ═══ -->
  <div class="table-card">
    <div class="table-card-header">
      <div class="table-card-title">Payment Records</div>
    </div>

    <% if (feeList == null || feeList.isEmpty()) { %>
      <div class="empty-state">
        <svg fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
          <circle cx="12" cy="12" r="10"/>
          <line x1="12" y1="8" x2="12" y2="12"/>
          <line x1="12" y1="16" x2="12.01" y2="16"/>
        </svg>
        <p>No fee records found for this student.</p>
      </div>
    <% } else { %>
      <table>
        <thead>
          <tr>
            <th>Fee ID</th>
            <th>Amount</th>
            <th>Status</th>
            <th>Due Date</th>
          </tr>
        </thead>
        <tbody>
          <% for (Object[] fee : feeList) {
               String statusVal = (String) fee[2];
          %>
          <tr>
            <td><span class="fee-id">#<%= fee[0] %></span></td>
            <td><span class="fee-amount">₹ <%= String.format("%,.2f", (Double) fee[1]) %></span></td>
            <td>
              <span class="status-badge <%= "PAID".equals(statusVal) ? "paid" : "pending" %>">
                <%= statusVal %>
              </span>
            </td>
            <td><span class="due-date"><%= fee[3] %></span></td>
          </tr>
          <% } %>
        </tbody>
      </table>
    <% } %>
  </div>
</main>

<!-- ═══ FOOTER ═══ -->
<footer>
  <span>Menaka's International Center for Learning</span>
  <span>Student Portal &nbsp;·&nbsp; Secure Access</span>
</footer>

</body>
</html>