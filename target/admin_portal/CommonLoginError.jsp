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
<title>Login Error – Menaka's ICL</title>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400&family=Jost:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --dark:     #0d0d0d;
    --panel:    #111111;
    --surface:  #161616;
    --border:   rgba(255,255,255,0.07);
    --border-h: rgba(255,255,255,0.13);
    --text:     #f0ece6;
    --muted:    #6a6460;
    --mid:      #9a9088;
    --gold:     #c9a84c;
    --gold-dim: rgba(201,168,76,0.12);
    --rose:     #c4706a;
    --rose-dim: rgba(196,112,106,0.12);
    --rose-glow:rgba(196,112,106,0.2);
  }

  html, body { height: 100%; }

  body {
    min-height: 100vh;
    font-family: 'Jost', sans-serif;
    background: var(--dark);
    color: var(--text);
    display: flex;
    flex-direction: column;
  }

  /* ═══ HEADER ═══ */
  header {
    background: var(--panel);
    border-bottom: 1px solid var(--border);
    padding: 0 48px;
    height: 64px;
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

  /* ═══ MAIN ═══ */
  main {
    flex: 1; display: flex; align-items: center;
    justify-content: center; padding: 48px 24px;
    position: relative; overflow: hidden;
  }

  /* background glow */
  main::before {
    content: '';
    position: absolute;
    top: 50%; left: 50%;
    transform: translate(-50%, -50%);
    width: 500px; height: 500px; border-radius: 50%;
    background: radial-gradient(circle, rgba(196,112,106,0.06) 0%, transparent 70%);
    pointer-events: none;
  }

  /* corner brackets */
  main::after {
    content: '';
    position: absolute; top: 36px; right: 36px;
    width: 28px; height: 28px;
    border-top: 1px solid rgba(201,168,76,0.15);
    border-right: 1px solid rgba(201,168,76,0.15);
  }

  .error-card {
    width: 100%; max-width: 420px;
    background: var(--panel);
    border: 1px solid rgba(196,112,106,0.2);
    border-radius: 20px;
    padding: 44px 40px 40px;
    position: relative;
    overflow: hidden;
    animation: fadeUp 0.5s cubic-bezier(0.16,1,0.3,1) both;
    text-align: center;
  }

  /* top red accent line */
  .error-card::before {
    content: '';
    position: absolute; top: 0; left: 0; right: 0; height: 2px;
    background: linear-gradient(to right, transparent, var(--rose), transparent);
  }

  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(24px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  /* ── icon circle ── */
  .icon-wrap {
    width: 72px; height: 72px; border-radius: 50%;
    background: var(--rose-dim);
    border: 1px solid rgba(196,112,106,0.25);
    display: flex; align-items: center; justify-content: center;
    margin: 0 auto 28px;
    position: relative;
    animation: popIn 0.5s 0.15s cubic-bezier(0.16,1,0.3,1) both;
  }
  .icon-wrap::before {
    content: ''; position: absolute; inset: 6px; border-radius: 50%;
    border: 0.5px solid rgba(196,112,106,0.2);
  }
  .icon-wrap svg { width: 28px; height: 28px; color: var(--rose); }

  @keyframes popIn {
    from { opacity: 0; transform: scale(0.7); }
    to   { opacity: 1; transform: scale(1); }
  }

  /* ── shake animation on icon ── */
  .icon-wrap { animation: fadeUp 0.5s cubic-bezier(0.16,1,0.3,1) both, shake 0.5s 0.4s ease both; }
  @keyframes shake {
    0%,100% { transform: translateX(0); }
    20%     { transform: translateX(-6px); }
    40%     { transform: translateX(6px); }
    60%     { transform: translateX(-4px); }
    80%     { transform: translateX(4px); }
  }

  .error-eyebrow {
    font-size: 11px; font-weight: 500;
    letter-spacing: 0.14em; text-transform: uppercase;
    color: var(--rose); margin-bottom: 10px;
    display: flex; align-items: center; justify-content: center; gap: 8px;
    animation: fadeUp 0.5s 0.1s ease both;
  }
  .error-eyebrow::before, .error-eyebrow::after {
    content: ''; width: 24px; height: 0.5px;
    background: rgba(196,112,106,0.4);
  }

  .error-title {
    font-family: 'Cormorant Garamond', serif;
    font-size: 28px; font-weight: 400; color: var(--text);
    margin-bottom: 12px;
    animation: fadeUp 0.5s 0.15s ease both;
  }

  .error-message {
    font-size: 14px; font-weight: 300;
    color: var(--mid); line-height: 1.7;
    margin-bottom: 32px;
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 10px;
    padding: 14px 18px;
    animation: fadeUp 0.5s 0.2s ease both;
  }

  /* countdown ring */
  .countdown-wrap {
    display: flex; flex-direction: column;
    align-items: center; gap: 10px;
    margin-bottom: 28px;
    animation: fadeUp 0.5s 0.25s ease both;
  }
  .countdown-text {
    font-size: 12px; font-weight: 400;
    color: var(--muted); letter-spacing: 0.04em;
  }
  .countdown-text span {
    color: var(--rose); font-weight: 600;
  }
  .progress-bar {
    width: 100%; height: 2px;
    background: var(--surface);
    border-radius: 999px; overflow: hidden;
  }
  .progress-fill {
    height: 100%;
    background: linear-gradient(to right, var(--rose), rgba(196,112,106,0.4));
    border-radius: 999px;
    animation: drain 5s linear forwards;
    width: 100%;
  }
  @keyframes drain {
    from { width: 100%; }
    to   { width: 0%; }
  }

  /* ── buttons ── */
  .btn-group {
    display: flex; gap: 10px;
    animation: fadeUp 0.5s 0.3s ease both;
  }

  .btn-primary {
    flex: 1; padding: 12px;
    background: var(--rose);
    border: none; border-radius: 10px;
    font-family: 'Jost', sans-serif;
    font-size: 12px; font-weight: 600;
    letter-spacing: 0.12em; text-transform: uppercase;
    color: #fff; cursor: pointer;
    transition: filter 0.2s, transform 0.15s;
    text-decoration: none; display: flex;
    align-items: center; justify-content: center; gap: 7px;
  }
  .btn-primary:hover { filter: brightness(1.1); transform: translateY(-1px); }
  .btn-primary:active { transform: translateY(0); }
  .btn-primary svg { width: 13px; height: 13px; }

  .btn-secondary {
    flex: 1; padding: 12px;
    background: transparent;
    border: 1px solid var(--border-h);
    border-radius: 10px;
    font-family: 'Jost', sans-serif;
    font-size: 12px; font-weight: 500;
    letter-spacing: 0.08em; text-transform: uppercase;
    color: var(--mid); cursor: pointer;
    transition: border-color 0.2s, color 0.2s, transform 0.15s;
    text-decoration: none; display: flex;
    align-items: center; justify-content: center; gap: 7px;
  }
  .btn-secondary:hover { border-color: var(--gold); color: var(--gold); transform: translateY(-1px); }
  .btn-secondary:active { transform: translateY(0); }
  .btn-secondary svg { width: 13px; height: 13px; }

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

  @media (max-width: 520px) {
    header { padding: 0 20px; }
    .error-card { padding: 36px 24px 28px; }
    .btn-group { flex-direction: column; }
    footer { padding: 14px 20px; flex-direction: column; gap: 4px; text-align: center; }
  }
</style>
</head>
<body>

<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage == null) errorMessage = "Invalid login attempt!";
%>

<!-- ═══ HEADER ═══ -->
<header>
  <div class="header-left">
    <div class="header-logo"><span>M</span></div>
    <div class="header-title">Menaka's <span>ICL</span></div>
  </div>
</header>

<!-- ═══ MAIN ═══ -->
<main>
  <div class="error-card">

    <!-- Icon -->
    <div class="icon-wrap">
      <svg fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
        <circle cx="12" cy="12" r="10"/>
        <line x1="12" y1="8" x2="12" y2="12"/>
        <line x1="12" y1="16" x2="12.01" y2="16"/>
      </svg>
    </div>

    <div class="error-eyebrow">Authentication Failed</div>
    <h1 class="error-title">Login Unsuccessful</h1>

    <!-- Error message from servlet -->
    <div class="error-message">
      <%= errorMessage %>
    </div>

    <!-- Countdown bar -->
    <div class="countdown-wrap">
      <div class="countdown-text">
        Redirecting in <span id="counter">5</span> seconds...
      </div>
      <div class="progress-bar">
        <div class="progress-fill"></div>
      </div>
    </div>

    <!-- Buttons -->
    <div class="btn-group">
      <a href="index.jsp" class="btn-primary">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M19 12H5M12 5l-7 7 7 7"/>
        </svg>
        Try Again
      </a>
      <a href="index.jsp" class="btn-secondary">
        <svg fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
          <polyline points="9 22 9 12 15 12 15 22"/>
        </svg>
        Home
      </a>
    </div>

  </div>
</main>

<!-- ═══ FOOTER ═══ -->
<footer>
  <span>Menaka's International Center for Learning</span>
  <span>Secure Access &nbsp;·&nbsp; ICL Portal</span>
</footer>

<script>
  // Countdown timer
  let count = 5;
  const counter = document.getElementById('counter');
  const timer = setInterval(() => {
    count--;
    counter.textContent = count;
    if (count <= 0) {
      clearInterval(timer);
      window.location.href = 'index.jsp';
    }
  }, 1000);
</script>

</body>
</html>