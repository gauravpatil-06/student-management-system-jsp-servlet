<%@ page language = "java" contentType = "text/html; charset = UTF-8" pageEncoding = "UTF-8" import = "com.student.entity.*" %>
    <%
        com.student.entity.Student homeStudent = (session != null) ? (com.student.entity.Student) session.getAttribute("student") : null;
        com.student.entity.Teacher homeTeacher = (session != null) ? (com.student.entity.Teacher) session.getAttribute("teacher") : null;
        com.student.entity.Admin homeAdmin = (session != null) ? (com.student.entity.Admin) session.getAttribute("admin") : null;
        boolean isUserLoggedIn = (homeStudent != null || homeTeacher != null || homeAdmin != null);
        String targetDashboardUrl = "login.jsp" ;
        String userDashboardLabel = "Dashboard" ;
        if (homeStudent != null)
        {
            targetDashboardUrl = request.getContextPath() + "/student/dashboard.jsp" ;
            userDashboardLabel = "Student Dashboard" ;
        }
        else if (homeTeacher != null)
        {
            targetDashboardUrl = request.getContextPath() + "/teacher/dashboard.jsp" ;
            userDashboardLabel = "Teacher Dashboard" ;
        }
        else if (homeAdmin != null)
        {
            targetDashboardUrl = request.getContextPath() + "/admin/dashboard.jsp" ;
            userDashboardLabel = "Admin Dashboard" ;
        }
    %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Student Management System - Centralized Academic Portal</title>

            
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap"
                rel="stylesheet">

            <style>
                /* ==========================================================================
           1. DESIGN SYSTEM & COLOR TOKENS (Matching Admin Dashboard Theme)
           ========================================================================== */
                :root {
                    --primary-navy: #1E3A5F;
                    --dark-navy: #16345A;
                    --primary-blue: #2563EB;
                    --primary-blue-hover: #1D4ED8;
                    --light-blue: #EFF6FF;
                    --bg-main: #F8FAFC;
                    --card-bg: #FFFFFF;
                    --text-main: #1E293B;
                    --text-muted: #64748B;
                    --border: #E2E8F0;
                    --success: #16A34A;

                    --radius-sm: 8px;
                    --radius-md: 14px;
                    --radius-lg: 20px;
                    --radius-pill: 50px;

                    --shadow-sm: 0 2px 4px rgba(0, 0, 0, 0.03);
                    --shadow-md: 0 10px 25px -5px rgba(30, 58, 95, 0.08), 0 8px 10px -6px rgba(30, 58, 95, 0.03);
                    --shadow-hover: 0 16px 32px -8px rgba(37, 99, 235, 0.14);

                    --transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
                }

                /* Base Resets */
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                html {
                    scroll-behavior: smooth;
                    font-size: 16px;
                }

                body {
                    font-family: 'Plus Jakarta Sans', sans-serif;
                    background-color: var(--bg-main);
                    color: var(--text-main);
                    line-height: 1.6;
                    overflow-x: hidden;
                    -webkit-font-smoothing: antialiased;
                }

                a {
                    text-decoration: none;
                    color: inherit;
                }

                ul {
                    list-style: none;
                }

                .container {
                    width: 100%;
                    max-width: 1200px;
                    margin: 0 auto;
                    padding: 0 1.5rem;
                }

                /* Section Typography */
                .section-header {
                    text-align: center;
                    margin-bottom: 2.75rem;
                }

                .section-title {
                    font-size: 2rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                    margin-bottom: 0.65rem;
                    letter-spacing: -0.02em;
                }

                .section-subtitle {
                    font-size: 0.975rem;
                    color: var(--text-muted);
                    max-width: 620px;
                    margin: 0 auto;
                    line-height: 1.6;
                }

                /* Buttons */
                .btn {
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    gap: 0.5rem;
                    padding: 0.8rem 1.75rem;
                    font-size: 0.95rem;
                    font-weight: 700;
                    border-radius: var(--radius-sm);
                    transition: var(--transition);
                    cursor: pointer;
                    border: 1.5px solid transparent;
                    font-family: inherit;
                }

                .btn-pill {
                    border-radius: var(--radius-pill);
                }

                .btn-sm {
                    padding: 0.55rem 1.25rem;
                    font-size: 0.875rem;
                }

                .btn-primary {
                    background-color: var(--primary-blue);
                    color: #FFFFFF;
                    box-shadow: 0 4px 14px rgba(37, 99, 235, 0.25);
                }

                .btn-primary:hover {
                    background-color: var(--primary-blue-hover);
                    transform: translateY(-2px);
                    box-shadow: 0 6px 18px rgba(37, 99, 235, 0.35);
                }

                .btn-outline {
                    background-color: #FFFFFF;
                    color: var(--primary-navy);
                    border-color: var(--border);
                }

                .btn-outline:hover {
                    border-color: var(--primary-blue);
                    color: var(--primary-blue);
                    transform: translateY(-2px);
                    box-shadow: var(--shadow-sm);
                }

                .btn-white {
                    background-color: #FFFFFF;
                    color: var(--primary-navy);
                }

                .btn-white:hover {
                    background-color: var(--light-blue);
                    color: var(--primary-blue);
                    transform: translateY(-2px);
                }

                /* ==========================================================================
           2. STICKY NAVBAR
           ========================================================================== */
                .navbar-wrapper {
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    z-index: 1000;
                    background: rgba(255, 255, 255, 0.96);
                    backdrop-filter: blur(12px);
                    -webkit-backdrop-filter: blur(12px);
                    border-bottom: 1px solid var(--border);
                    transition: var(--transition);
                }

                .navbar-wrapper.scrolled {
                    box-shadow: var(--shadow-md);
                }

                .navbar {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    height: 72px;
                }

                .nav-brand {
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                    font-size: 1.15rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                    letter-spacing: -0.01em;
                }

                .nav-brand-icon {
                    width: 36px;
                    height: 36px;
                    background: var(--light-blue);
                    color: var(--primary-blue);
                    border-radius: var(--radius-sm);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    border: 1px solid rgba(37, 99, 235, 0.15);
                }

                .nav-menu {
                    display: flex;
                    align-items: center;
                    gap: 2.5rem;
                }

                .nav-links {
                    display: flex;
                    align-items: center;
                    gap: 2rem;
                }

                .nav-link {
                    font-weight: 600;
                    color: var(--text-muted);
                    font-size: 0.95rem;
                    transition: var(--transition);
                    position: relative;
                    padding: 0.25rem 0;
                }

                .nav-link.active,
                .nav-link:hover {
                    color: var(--primary-blue);
                }

                .nav-link.active::after {
                    content: '';
                    position: absolute;
                    bottom: -4px;
                    left: 0;
                    width: 100%;
                    height: 2.5px;
                    background: var(--primary-blue);
                    border-radius: 2px;
                }

                .nav-actions {
                    display: flex;
                    gap: 0.75rem;
                    align-items: center;
                }

                .nav-toggle {
                    display: none;
                    background: transparent;
                    border: none;
                    cursor: pointer;
                    padding: 0.5rem;
                    flex-direction: column;
                    gap: 5px;
                }

                .nav-toggle span {
                    width: 24px;
                    height: 2px;
                    background: var(--primary-navy);
                    transition: var(--transition);
                    border-radius: 2px;
                }

                .mobile-overlay {
                    display: none;
                    position: fixed;
                    inset: 0;
                    background: rgba(15, 23, 42, 0.5);
                    backdrop-filter: blur(4px);
                    z-index: 998;
                    opacity: 0;
                    transition: opacity 0.3s ease;
                }

                .mobile-overlay.active {
                    display: block;
                    opacity: 1;
                }

                /* ==========================================================================
           3. HERO SECTION (WITH DECORATION BACKGROUND & ANIMATED DASHBOARD MOCKUP)
           ========================================================================== */
                .hero-section {
                    padding: 8.5rem 0 5rem;
                    position: relative;
                    background: linear-gradient(180deg, #FFFFFF 0%, var(--bg-main) 100%);
                    overflow: hidden;
                }

                /* Background Decoration Shapes */
                .hero-bg-shapes {
                    position: absolute;
                    inset: 0;
                    pointer-events: none;
                    z-index: 0;
                    overflow: hidden;
                }

                .hero-shape-1 {
                    position: absolute;
                    top: -100px;
                    right: -100px;
                    width: 500px;
                    height: 500px;
                    background: radial-gradient(circle, rgba(37, 99, 235, 0.06) 0%, transparent 70%);
                    border-radius: 50%;
                }

                .hero-shape-2 {
                    position: absolute;
                    bottom: -50px;
                    left: -50px;
                    width: 400px;
                    height: 400px;
                    background: radial-gradient(circle, rgba(30, 58, 95, 0.05) 0%, transparent 70%);
                    border-radius: 50%;
                }

                .hero-grid-pattern {
                    position: absolute;
                    inset: 0;
                    opacity: 0.025;
                    background-image: radial-gradient(var(--primary-navy) 1px, transparent 1px);
                    background-size: 28px 28px;
                }

                .hero-grid {
                    display: grid;
                    grid-template-columns: 1.05fr 0.95fr;
                    gap: 2.75rem;
                    align-items: center;
                    position: relative;
                    z-index: 1;
                }

                .hero-badge {
                    display: inline-flex;
                    align-items: center;
                    gap: 0.5rem;
                    padding: 0.4rem 1rem;
                    background: var(--light-blue);
                    color: var(--primary-blue);
                    font-size: 0.75rem;
                    font-weight: 800;
                    letter-spacing: 0.03em;
                    border-radius: var(--radius-pill);
                    margin-bottom: 1rem;
                    border: 1px solid rgba(37, 99, 235, 0.15);
                }

                .hero-title {
                    font-size: 2.75rem;
                    line-height: 1.15;
                    font-weight: 800;
                    color: var(--primary-navy);
                    margin-bottom: 1rem;
                    letter-spacing: -0.02em;
                }

                .hero-subtitle {
                    font-size: 0.975rem;
                    color: var(--text-muted);
                    margin-bottom: 1.5rem;
                    line-height: 1.6;
                    max-width: 540px;
                }

                /* Hero Feature Bullets */
                .hero-bullets {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 0.75rem;
                    margin-bottom: 1.75rem;
                }

                .hero-bullet-item {
                    display: flex;
                    align-items: center;
                    gap: 0.65rem;
                    font-size: 0.9rem;
                    font-weight: 700;
                    color: var(--primary-navy);
                }

                .bullet-check-icon {
                    width: 20px;
                    height: 20px;
                    border-radius: 50%;
                    background: var(--light-blue);
                    color: var(--primary-blue);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    flex-shrink: 0;
                }

                .hero-buttons {
                    display: flex;
                    gap: 1rem;
                    align-items: center;
                }

                /* Hero Dashboard Mockup (CSS Animation) */
                .hero-mockup-wrapper {
                    position: relative;
                }

                .hero-mockup-card {
                    background: #FFFFFF;
                    border: 1px solid var(--border);
                    border-radius: var(--radius-lg);
                    padding: 1.75rem;
                    box-shadow: var(--shadow-md);
                    position: relative;
                    z-index: 2;
                    animation: floatDashboard 6s ease-in-out infinite alternate;
                }

                @keyframes floatDashboard {
                    0% {
                        transform: translateY(0px);
                    }

                    100% {
                        transform: translateY(-10px);
                    }
                }

                .mockup-header {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    padding-bottom: 1rem;
                    border-bottom: 1px solid var(--border);
                    margin-bottom: 1.25rem;
                }

                .mockup-header-title {
                    display: flex;
                    align-items: center;
                    gap: 0.6rem;
                    font-size: 0.95rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                }

                .mockup-header-dots {
                    display: flex;
                    gap: 6px;
                }

                .dot-circle {
                    width: 10px;
                    height: 10px;
                    border-radius: 50%;
                    background: #CBD5E1;
                }

                .mockup-grid {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 1rem;
                    margin-bottom: 1.25rem;
                }

                .mockup-stat-box {
                    background: var(--bg-main);
                    border: 1px solid var(--border);
                    border-radius: var(--radius-sm);
                    padding: 1rem;
                }

                .mockup-stat-label {
                    font-size: 0.725rem;
                    font-weight: 700;
                    color: var(--text-muted);
                    text-transform: uppercase;
                    letter-spacing: 0.03em;
                    margin-bottom: 0.3rem;
                }

                .mockup-stat-value {
                    font-size: 1.6rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                    line-height: 1;
                }

                /* Visual Progress & Circular Attendance */
                .mockup-visuals-row {
                    display: grid;
                    grid-template-columns: 1.2fr 0.8fr;
                    gap: 1rem;
                    align-items: center;
                    background: var(--light-blue);
                    border: 1px solid rgba(37, 99, 235, 0.15);
                    border-radius: var(--radius-sm);
                    padding: 1rem;
                    margin-bottom: 1.25rem;
                }

                .progress-block-title {
                    font-size: 0.75rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                    margin-bottom: 0.4rem;
                }

                .progress-bar-bg {
                    height: 8px;
                    background: #DBEAFE;
                    border-radius: 10px;
                    overflow: hidden;
                }

                .progress-bar-fill {
                    height: 100%;
                    width: 75%;
                    background: var(--primary-blue);
                    border-radius: 10px;
                    animation: pulseProgress 2s ease-in-out infinite alternate;
                }

                @keyframes pulseProgress {
                    0% {
                        opacity: 0.85;
                    }

                    100% {
                        opacity: 1;
                    }
                }

                .circular-indicator-wrap {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 0.5rem;
                }

                .circle-chart {
                    width: 38px;
                    height: 38px;
                    border-radius: 50%;
                    background: conic-gradient(var(--primary-blue) 0% 80%, #DBEAFE 80% 100%);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .circle-inner {
                    width: 26px;
                    height: 26px;
                    background: #FFFFFF;
                    border-radius: 50%;
                }

                /* Floating Mini Cards Around Dashboard */
                .floating-mini-card {
                    position: absolute;
                    background: #FFFFFF;
                    border: 1px solid var(--border);
                    border-radius: var(--radius-sm);
                    padding: 0.75rem 1rem;
                    box-shadow: var(--shadow-md);
                    z-index: 3;
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                    font-size: 0.825rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                }

                .mini-card-1 {
                    top: -20px;
                    right: -15px;
                    animation: floatMini1 5s ease-in-out infinite alternate;
                }

                .mini-card-2 {
                    bottom: -20px;
                    left: -15px;
                    animation: floatMini2 6s ease-in-out infinite alternate;
                }

                @keyframes floatMini1 {
                    0% {
                        transform: translateY(0px);
                    }

                    100% {
                        transform: translateY(-8px);
                    }
                }

                @keyframes floatMini2 {
                    0% {
                        transform: translateY(0px);
                    }

                    100% {
                        transform: translateY(8px);
                    }
                }

                .mini-icon-circle {
                    width: 28px;
                    height: 28px;
                    border-radius: 50%;
                    background: var(--light-blue);
                    color: var(--primary-blue);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 0.8rem;
                }

                /* ==========================================================================
           4. CORE MANAGEMENT MODULES (4 CARDS)
           ========================================================================== */
                .modules-section {
                    padding: 4.5rem 0;
                    background: #FFFFFF;
                    border-top: 1px solid var(--border);
                    border-bottom: 1px solid var(--border);
                }

                .modules-grid {
                    display: grid;
                    grid-template-columns: repeat(4, 1fr);
                    gap: 1.25rem;
                }

                .module-card {
                    background: var(--bg-main);
                    border: 1px solid var(--border);
                    border-radius: var(--radius-md);
                    padding: 1.75rem 1.5rem;
                    display: flex;
                    flex-direction: column;
                    justify-content: space-between;
                    transition: var(--transition);
                    position: relative;
                    overflow: hidden;
                }

                .module-card:hover {
                    background: #FFFFFF;
                    border-color: var(--primary-blue);
                    transform: translateY(-6px);
                    box-shadow: var(--shadow-hover);
                }

                .module-card::before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 3px;
                    background: var(--primary-blue);
                    opacity: 0;
                    transition: var(--transition);
                }

                .module-card:hover::before {
                    opacity: 1;
                }

                .module-icon-container {
                    width: 52px;
                    height: 52px;
                    border-radius: var(--radius-sm);
                    background: #FFFFFF;
                    border: 1px solid var(--border);
                    color: var(--primary-blue);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin-bottom: 1.5rem;
                    transition: var(--transition);
                }

                .module-card:hover .module-icon-container {
                    background: var(--primary-blue);
                    color: #FFFFFF;
                    border-color: var(--primary-blue);
                }

                .module-title {
                    font-size: 1.2rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                    margin-bottom: 0.65rem;
                }

                .module-desc {
                    font-size: 0.9rem;
                    color: var(--text-muted);
                    line-height: 1.6;
                    margin-bottom: 1.5rem;
                }

                .module-arrow-link {
                    display: inline-flex;
                    align-items: center;
                    gap: 0.4rem;
                    font-size: 0.875rem;
                    font-weight: 700;
                    color: var(--primary-blue);
                    transition: var(--transition);
                }

                .module-card:hover .module-arrow-link {
                    transform: translateX(4px);
                }

                /* ==========================================================================
           5. HOW IT WORKS WORKFLOW (5 STEPS CONNECTED TIMELINE)
           ========================================================================== */
                .workflow-section {
                    padding: 5.5rem 0;
                    background: var(--bg-main);
                }

                .timeline-container {
                    display: grid;
                    grid-template-columns: repeat(5, 1fr);
                    gap: 1.25rem;
                    position: relative;
                }

                .timeline-container::before {
                    content: '';
                    position: absolute;
                    top: 26px;
                    left: 10%;
                    width: 80%;
                    height: 2px;
                    background: var(--border);
                    z-index: 0;
                }

                .timeline-step {
                    background: #FFFFFF;
                    border: 1px solid var(--border);
                    border-radius: var(--radius-md);
                    padding: 1.75rem 1.25rem;
                    text-align: center;
                    position: relative;
                    z-index: 1;
                    box-shadow: var(--shadow-sm);
                    transition: var(--transition);
                }

                .timeline-step:hover {
                    border-color: var(--primary-blue);
                    transform: translateY(-4px);
                    box-shadow: var(--shadow-hover);
                }

                .step-number-circle {
                    width: 52px;
                    height: 52px;
                    border-radius: 50%;
                    background: #FFFFFF;
                    border: 2px solid var(--primary-blue);
                    color: var(--primary-blue);
                    font-size: 0.95rem;
                    font-weight: 800;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin: 0 auto 1.25rem;
                    box-shadow: 0 0 0 4px var(--bg-main);
                    transition: var(--transition);
                }

                .timeline-step:hover .step-number-circle {
                    background: var(--primary-blue);
                    color: #FFFFFF;
                }

                .step-role-title {
                    font-size: 1.05rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                    margin-bottom: 0.5rem;
                }

                .step-role-desc {
                    font-size: 0.85rem;
                    color: var(--text-muted);
                    line-height: 1.5;
                }

                /* ==========================================================================
           6. ABOUT SECTION (2-COLUMN VISUAL & HIGHLIGHTS)
           ========================================================================== */
                .about-section {
                    padding: 5.5rem 0;
                    background: #FFFFFF;
                    border-top: 1px solid var(--border);
                    border-bottom: 1px solid var(--border);
                }

                .about-grid {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 3.5rem;
                    align-items: center;
                }

                /* CSS Academic Visual Card (Left) */
                .about-visual-card {
                    background: var(--bg-main);
                    border: 1px solid var(--border);
                    border-radius: var(--radius-lg);
                    padding: 2.25rem;
                    box-shadow: var(--shadow-md);
                }

                .visual-card-header {
                    font-size: 1.15rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                    margin-bottom: 1.5rem;
                    padding-bottom: 0.75rem;
                    border-bottom: 1px solid var(--border);
                    display: flex;
                    align-items: center;
                    gap: 0.6rem;
                }

                .visual-list {
                    display: flex;
                    flex-direction: column;
                    gap: 0.85rem;
                }

                .visual-list-item {
                    background: #FFFFFF;
                    border: 1px solid var(--border);
                    border-radius: var(--radius-sm);
                    padding: 0.85rem 1.1rem;
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    font-size: 0.9rem;
                    font-weight: 700;
                    color: var(--primary-navy);
                }

                .visual-badge-sync {
                    font-size: 0.725rem;
                    font-weight: 800;
                    color: var(--primary-blue);
                    background: var(--light-blue);
                    padding: 0.2rem 0.6rem;
                    border-radius: 50px;
                }

                /* About Text Right */
                .about-text h2 {
                    font-size: 2.25rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                    margin-bottom: 1rem;
                    letter-spacing: -0.02em;
                }

                .about-text p {
                    font-size: 1.025rem;
                    color: var(--text-muted);
                    margin-bottom: 1.75rem;
                    line-height: 1.65;
                }

                .about-highlights {
                    display: flex;
                    flex-direction: column;
                    gap: 0.85rem;
                }

                .about-highlight-item {
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                    font-size: 0.95rem;
                    font-weight: 700;
                    color: var(--primary-navy);
                }

                .highlight-check {
                    width: 22px;
                    height: 22px;
                    border-radius: 50%;
                    background: var(--light-blue);
                    color: var(--primary-blue);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    flex-shrink: 0;
                }

                /* ==========================================================================
           8. CTA BANNER SECTION (#16345A DARK NAVY)
           ========================================================================== */
                .cta-section {
                    padding: 5rem 0;
                    background: var(--bg-main);
                }

                .cta-card {
                    background: linear-gradient(135deg, var(--dark-navy) 0%, var(--primary-navy) 100%);
                    border-radius: var(--radius-lg);
                    padding: 4.5rem 2rem;
                    text-align: center;
                    color: #FFFFFF;
                    box-shadow: var(--shadow-md);
                    position: relative;
                    overflow: hidden;
                }

                .cta-card::before {
                    content: '';
                    position: absolute;
                    top: -50%;
                    left: -50%;
                    width: 200%;
                    height: 200%;
                    background: radial-gradient(circle, rgba(37, 99, 235, 0.15) 0%, transparent 60%);
                    pointer-events: none;
                }

                .cta-content {
                    position: relative;
                    z-index: 1;
                    max-width: 640px;
                    margin: 0 auto;
                }

                .cta-content h2 {
                    font-size: 2.5rem;
                    font-weight: 800;
                    margin-bottom: 1rem;
                    letter-spacing: -0.02em;
                }

                .cta-content p {
                    font-size: 1.075rem;
                    color: #CBD5E1;
                    margin-bottom: 2.25rem;
                    line-height: 1.6;
                }

                .cta-buttons {
                    display: flex;
                    gap: 1rem;
                    justify-content: center;
                }

                /* ==========================================================================
           9. FOOTER (#1E3A5F)
           ========================================================================== */
                .footer {
                    background: var(--primary-navy);
                    color: #FFFFFF;
                    padding: 4.5rem 0 2rem;
                    border-top: 1px solid rgba(255, 255, 255, 0.08);
                }

                .footer-grid {
                    display: grid;
                    grid-template-columns: 1.5fr 1fr 1fr;
                    gap: 3.5rem;
                    margin-bottom: 3.5rem;
                }

                .footer-brand h3 {
                    display: flex;
                    align-items: center;
                    gap: 0.65rem;
                    font-size: 1.25rem;
                    font-weight: 800;
                    color: #FFFFFF;
                    margin-bottom: 0.85rem;
                }

                .footer-brand p {
                    font-size: 0.9rem;
                    color: #94A3B8;
                    line-height: 1.6;
                    max-width: 380px;
                }

                .footer-col h4 {
                    font-size: 0.85rem;
                    font-weight: 800;
                    color: #FFFFFF;
                    text-transform: uppercase;
                    letter-spacing: 0.06em;
                    margin-bottom: 1.25rem;
                }

                .footer-col ul {
                    display: flex;
                    flex-direction: column;
                    gap: 0.75rem;
                }

                .footer-col a {
                    font-size: 0.9rem;
                    font-weight: 600;
                    color: #94A3B8;
                    transition: var(--transition);
                }

                .footer-col a:hover {
                    color: #60A5FA;
                }

                .footer-bottom-bar {
                    border-top: 1px solid rgba(255, 255, 255, 0.1);
                    padding-top: 1.75rem;
                    text-align: center;
                    font-size: 0.875rem;
                    color: #94A3B8;
                }

                /* ==========================================================================
           10. REVEAL ANIMATIONS & RESPONSIVE BREAKPOINTS
           ========================================================================== */
                .reveal {
                    opacity: 0;
                    transform: translateY(25px);
                    transition: all 0.7s cubic-bezier(0.16, 1, 0.3, 1);
                }

                .reveal.active {
                    opacity: 1;
                    transform: translateY(0);
                }

                @media (max-width: 1100px) {

                    .hero-grid,
                    .about-grid {
                        grid-template-columns: 1fr;
                        gap: 3.5rem;
                        text-align: center;
                    }

                    .hero-subtitle,
                    .hero-bullets,
                    .about-highlights {
                        margin-left: auto;
                        margin-right: auto;
                    }

                    .hero-buttons,
                    .cta-buttons {
                        justify-content: center;
                    }

                    .modules-grid,
                    .capabilities-grid {
                        grid-template-columns: repeat(2, 1fr);
                    }

                    .timeline-container {
                        grid-template-columns: repeat(3, 1fr);
                    }

                    .timeline-container::before {
                        display: none;
                    }

                    .footer-grid {
                        grid-template-columns: 1fr 1fr;
                    }
                }

                @media (max-width: 768px) {
                    .nav-toggle {
                        display: flex;
                    }

                    .nav-menu {
                        position: fixed;
                        top: 72px;
                        right: -100%;
                        width: 280px;
                        height: calc(100vh - 72px);
                        background: #FFFFFF;
                        flex-direction: column;
                        padding: 2rem 1.5rem;
                        align-items: flex-start;
                        box-shadow: var(--shadow-md);
                        transition: var(--transition);
                        z-index: 999;
                    }

                    .nav-menu.open {
                        right: 0;
                    }

                    .nav-links {
                        flex-direction: column;
                        align-items: flex-start;
                        width: 100%;
                        gap: 1.25rem;
                        margin-bottom: 2rem;
                    }

                    .nav-actions {
                        flex-direction: column;
                        width: 100%;
                    }

                    .nav-actions .btn {
                        width: 100%;
                    }

                    .hero-title {
                        font-size: 2.35rem;
                    }

                    .hero-bullets {
                        grid-template-columns: 1fr;
                    }

                    .modules-grid,
                    .timeline-container,
                    .capabilities-grid,
                    .footer-grid {
                        grid-template-columns: 1fr;
                    }

                    .cta-buttons {
                        flex-direction: column;
                    }

                    .cta-buttons .btn {
                        width: 100%;
                    }
                }
            </style>
        </head>

        <body>

            <!-- Mobile Drawer Overlay -->
            <div class="mobile-overlay" id="mobileOverlay"></div>

            <!-- Sticky Navbar -->
            <header class="navbar-wrapper" id="navbarWrapper">
                <nav class="navbar container">
                    <a href="index.jsp" class="nav-brand">
                        <div class="nav-brand-icon">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
                                <path d="M6 12v5c3 3 9 3 12 0v-5" />
                            </svg>
                        </div>
                        <span>Student Management System</span>
                    </a>

                    <button class="nav-toggle" id="navToggle" aria-label="Toggle Navigation">
                        <span></span><span></span><span></span>
                    </button>

                    <div class="nav-menu" id="navMenu">
                        <ul class="nav-links">
                            <li><a href="index.jsp" class="nav-link active">Home</a></li>
                        </ul>

                        <div class="nav-actions">
                            <%
                                if (isUserLoggedIn)
                                {
                            %>
                                <a href="<%= targetDashboardUrl %>" class="btn btn-primary btn-sm">Dashboard</a>
                                <%
                                    }
                                    else
                                    {
                                %>
                                    <a href="login.jsp" class="btn btn-outline btn-sm">Login</a>
                                    <a href="register.jsp" class="btn btn-primary btn-sm">Register</a>
                                    <%
                                        }
                                    %>
                        </div>
                    </div>
                </nav>
            </header>

            <main>
                <!-- Hero Section -->
                <section class="hero-section">
                    <div class="hero-bg-shapes">
                        <div class="hero-shape-1"></div>
                        <div class="hero-shape-2"></div>
                        <div class="hero-grid-pattern"></div>
                    </div>

                    <div class="container hero-grid">
                        <!-- Left Content -->
                        <div class="hero-content reveal">
                            <h1 class="hero-title">Student Management System</h1>

                            <p class="hero-subtitle">
                                Manage students, teachers, CCE marks, attendance, academic records, and results through
                                one
                                centralized platform.
                            </p>

                            <div class="hero-bullets">
                                <div class="hero-bullet-item">
                                    <div class="bullet-check-icon">✓</div>
                                    Centralized Student Records
                                </div>
                                <div class="hero-bullet-item">
                                    <div class="bullet-check-icon">✓</div>
                                    Easy CCE Marks Management
                                </div>
                                <div class="hero-bullet-item">
                                    <div class="bullet-check-icon">✓</div>
                                    Attendance Tracking
                                </div>
                                <div class="hero-bullet-item">
                                    <div class="bullet-check-icon">✓</div>
                                    Result Processing
                                </div>
                            </div>

                            <div class="hero-buttons">
                                <%
                                    if (isUserLoggedIn)
                                    {
                                %>
                                    <a href="<%= targetDashboardUrl %>" class="btn btn-primary btn-pill">
                                        DASHBOARD
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <line x1="5" y1="12" x2="19" y2="12" />
                                            <polyline points="12 5 19 12 12 19" />
                                        </svg>
                                    </a>
                                    <%
                                        }
                                        else
                                        {
                                    %>
                                        <a href="register.jsp" class="btn btn-primary btn-pill">
                                            REGISTER
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2.5">
                                                <line x1="5" y1="12" x2="19" y2="12" />
                                                <polyline points="12 5 19 12 12 19" />
                                            </svg>
                                        </a>
                                        <a href="login.jsp" class="btn btn-outline btn-pill">LOGIN</a>
                                        <%
                                            }
                                        %>
                            </div>
                        </div>

                        <!-- Right Hero Animated Dashboard Mockup (HTML + CSS) -->
                        <div class="hero-mockup-wrapper reveal">
                            <!-- Main Card -->
                            <div class="hero-mockup-card">
                                <div class="mockup-header">
                                    <div class="mockup-header-title">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                                            <line x1="3" y1="9" x2="21" y2="9" />
                                            <line x1="9" y1="21" x2="9" y2="9" />
                                        </svg>
                                        Academic Overview
                                    </div>
                                    <div class="mockup-header-dots">
                                        <span class="dot-circle"></span>
                                        <span class="dot-circle"></span>
                                        <span class="dot-circle"></span>
                                    </div>
                                </div>

                                <div class="mockup-grid">
                                    <div class="mockup-stat-box">
                                        <div class="mockup-stat-label">Student Records</div>
                                        <div class="mockup-stat-value">Unified</div>
                                    </div>

                                    <div class="mockup-stat-box">
                                        <div class="mockup-stat-label">CCE Performance</div>
                                        <div class="mockup-stat-value">95%</div>
                                    </div>
                                </div>

                                <div class="mockup-visuals-row">
                                    <div>
                                        <div class="progress-block-title">Academic Progress Bar</div>
                                        <div class="progress-bar-bg">
                                            <div class="progress-bar-fill"></div>
                                        </div>
                                    </div>

                                    <div class="circular-indicator-wrap">
                                        <div class="circle-chart">
                                            <div class="circle-inner"></div>
                                        </div>
                                        <div style="font-size: 0.75rem; font-weight: 800; color: var(--primary-navy);">
                                            Attendance</div>
                                    </div>
                                </div>

                                <div class="mockup-grid">
                                    <div class="mockup-stat-box">
                                        <div class="mockup-stat-label">Attendance</div>
                                        <div class="mockup-stat-value">98%</div>
                                    </div>

                                    <div class="mockup-stat-box">
                                        <div class="mockup-stat-label">Result Status</div>
                                        <div class="mockup-stat-value">Active</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Floating Mini Card 1 -->
                            <div class="floating-mini-card mini-card-1">
                                <div class="mini-icon-circle">📈</div>
                                <div>
                                    <div style="font-size: 0.7rem; color: var(--text-muted);">CCE Performance</div>
                                    <div>95% Active</div>
                                </div>
                            </div>

                            <!-- Floating Mini Card 2 -->
                            <div class="floating-mini-card mini-card-2">
                                <div class="mini-icon-circle">📜</div>
                                <div>
                                    <div style="font-size: 0.7rem; color: var(--text-muted);">Result Status</div>
                                    <div>100% Synced</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Core Management Modules (4 Cards) -->
                <section class="modules-section">
                    <div class="container">
                        <div class="section-header reveal">
                            <h2 class="section-title">Core Management Modules</h2>
                            <p class="section-subtitle">Everything required for efficient academic management.</p>
                        </div>

                        <div class="modules-grid">
                            <!-- 1. Student Management -->
                            <div class="module-card reveal">
                                <div>
                                    <div class="module-icon-container">
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                            <circle cx="12" cy="7" r="4" />
                                        </svg>
                                    </div>
                                    <h3 class="module-title">Student Management</h3>
                                    <p class="module-desc">Manage student profiles, academic details, and records
                                        efficiently.</p>
                                </div>
                                <a href="login.jsp" class="module-arrow-link">
                                    Explore Module
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.5">
                                        <line x1="5" y1="12" x2="19" y2="12" />
                                        <polyline points="12 5 19 12 12 19" />
                                    </svg>
                                </a>
                            </div>

                            <!-- 2. Teacher Management -->
                            <div class="module-card reveal">
                                <div>
                                    <div class="module-icon-container">
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <rect x="2" y="7" width="20" height="14" rx="2" ry="2" />
                                            <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                                        </svg>
                                    </div>
                                    <h3 class="module-title">Teacher Management</h3>
                                    <p class="module-desc">Manage teacher information, subjects, and academic
                                        responsibilities.</p>
                                </div>
                                <a href="login.jsp" class="module-arrow-link">
                                    Explore Module
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.5">
                                        <line x1="5" y1="12" x2="19" y2="12" />
                                        <polyline points="12 5 19 12 12 19" />
                                    </svg>
                                </a>
                            </div>

                            <!-- 3. CCE Marks Management -->
                            <div class="module-card reveal">
                                <div>
                                    <div class="module-icon-container">
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                            <polyline points="14 2 14 8 20 8" />
                                            <line x1="16" y1="13" x2="8" y2="13" />
                                            <line x1="16" y1="17" x2="8" y2="17" />
                                        </svg>
                                    </div>
                                    <h3 class="module-title">CCE Marks Management</h3>
                                    <p class="module-desc">Manage CCE assessments and continuous academic performance.
                                    </p>
                                </div>
                                <a href="login.jsp" class="module-arrow-link">
                                    Explore Module
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.5">
                                        <line x1="5" y1="12" x2="19" y2="12" />
                                        <polyline points="12 5 19 12 12 19" />
                                    </svg>
                                </a>
                            </div>

                            <!-- 4. Result Management -->
                            <div class="module-card reveal">
                                <div>
                                    <div class="module-icon-container">
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <polygon
                                                points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                                        </svg>
                                    </div>
                                    <h3 class="module-title">Result Management</h3>
                                    <p class="module-desc">Process academic results and provide clear student
                                        performance
                                        information.</p>
                                </div>
                                <a href="login.jsp" class="module-arrow-link">
                                    Explore Module
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.5">
                                        <line x1="5" y1="12" x2="19" y2="12" />
                                        <polyline points="12 5 19 12 12 19" />
                                    </svg>
                                </a>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- How It Works Timeline -->
                <section class="workflow-section">
                    <div class="container">
                        <div class="section-header reveal">
                            <h2 class="section-title">How It Works</h2>
                            <p class="section-subtitle">A simple academic workflow from administration to student
                                access.
                            </p>
                        </div>

                        <div class="timeline-container">
                            <div class="timeline-step reveal">
                                <div class="step-number-circle">01</div>
                                <h3 class="step-role-title">Admin</h3>
                                <p class="step-role-desc">Manage academic records and users.</p>
                            </div>

                            <div class="timeline-step reveal">
                                <div class="step-number-circle">02</div>
                                <h3 class="step-role-title">Teacher</h3>
                                <p class="step-role-desc">Manage students, marks, and attendance.</p>
                            </div>

                            <div class="timeline-step reveal">
                                <div class="step-number-circle">03</div>
                                <h3 class="step-role-title">CCE Marks</h3>
                                <p class="step-role-desc">Record continuous assessment.</p>
                            </div>

                            <div class="timeline-step reveal">
                                <div class="step-number-circle">04</div>
                                <h3 class="step-role-title">Result</h3>
                                <p class="step-role-desc">Process academic performance.</p>
                            </div>

                            <div class="timeline-step reveal">
                                <div class="step-number-circle">05</div>
                                <h3 class="step-role-title">Student</h3>
                                <p class="step-role-desc">Access academic information and results.</p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- About Section (2-Column) -->
                <section class="about-section">
                    <div class="container about-grid">
                        <!-- Left Visual Card -->
                        <div class="about-visual-card reveal">
                            <div class="visual-card-header">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
                                    <path d="M6 12v5c3 3 9 3 12 0v-5" />
                                </svg>
                                Academic Management
                            </div>

                            <div class="visual-list">
                                <div class="visual-list-item">
                                    <span>Student Records</span>
                                    <span class="visual-badge-sync">Unified</span>
                                </div>
                                <div class="visual-list-item">
                                    <span>Teacher Records</span>
                                    <span class="visual-badge-sync">Active</span>
                                </div>
                                <div class="visual-list-item">
                                    <span>CCE Tracking</span>
                                    <span class="visual-badge-sync">Synced</span>
                                </div>
                                <div class="visual-list-item">
                                    <span>Result Processing</span>
                                    <span class="visual-badge-sync">Automated</span>
                                </div>
                            </div>
                        </div>

                        <!-- Right Copy -->
                        <div class="about-text reveal">
                            <h2>About Student Management System</h2>
                            <p>
                                Student Management System is a centralized academic platform designed to simplify
                                student,
                                teacher, CCE marks, attendance, and result management.
                            </p>

                            <div class="about-highlights">
                                <div class="about-highlight-item">
                                    <div class="highlight-check">✓</div>
                                    Centralized Student Records
                                </div>
                                <div class="about-highlight-item">
                                    <div class="highlight-check">✓</div>
                                    Easy CCE Marks Management
                                </div>
                                <div class="about-highlight-item">
                                    <div class="highlight-check">✓</div>
                                    Attendance Tracking
                                </div>
                                <div class="about-highlight-item">
                                    <div class="highlight-check">✓</div>
                                    Result Processing
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- CTA Section (#16345A Dark Navy) -->
                <section class="cta-section">
                    <div class="container">
                        <div class="cta-card reveal">
                            <div class="cta-content">
                                <h2>Manage Academic Records Smarter</h2>
                                <p>Access the Student Management System and simplify academic management from one
                                    centralized platform.</p>
                                <div class="cta-buttons">
                                    <a href="login.jsp" class="btn btn-primary btn-pill">Login Now</a>
                                    <a href="register.jsp" class="btn btn-white btn-pill">Create Account</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </main>

            <!-- Footer (#1E3A5F) -->
            <footer class="footer">
                <div class="container">
                    <div class="footer-grid">
                        <!-- Left Brand -->
                        <div class="footer-brand">
                            <h3>
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
                                    <path d="M6 12v5c3 3 9 3 12 0v-5" />
                                </svg>
                                Student Management System
                            </h3>
                            <p>Centralized Academic Management Portal</p>
                            <p style="font-size: 0.85rem; color: #94A3B8; margin-top: 0.5rem; line-height: 1.5;">
                                A comprehensive platform connecting students, teachers, and admins to streamline
                                academic
                                records, CCE evaluations, attendance, and results.
                            </p>
                        </div>

                        <!-- Middle Quick Links -->
                        <div class="footer-col">
                            <h4>Quick Links</h4>
                            <ul>
                                <li><a href="index.jsp">Home</a></li>
                                <li><a href="login.jsp">Login</a></li>
                                <li><a href="register.jsp">Register</a></li>
                            </ul>
                        </div>

                        <!-- Right Modules -->
                        <div class="footer-col">
                            <h4>Modules</h4>
                            <ul>
                                <li><a href="login.jsp">Student Management</a></li>
                                <li><a href="login.jsp">Teacher Management</a></li>
                                <li><a href="login.jsp">CCE Marks</a></li>
                                <li><a href="login.jsp">Result Management</a></li>
                            </ul>
                        </div>
                    </div>

                    <div class="footer-bottom-bar">
                        © 2026 Student Management System. All Rights Reserved.
                    </div>
                </div>
            </footer>

            <!-- JavaScript (Drawer Menu & Scroll Reveal) -->
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    // Mobile Hamburger Menu Drawer
                    const navToggle = document.getElementById('navToggle');
                    const navMenu = document.getElementById('navMenu');
                    const mobileOverlay = document.getElementById('mobileOverlay');

                    function openMenu() {
                        navMenu.classList.add('open');
                        mobileOverlay.classList.add('active');
                    }

                    function closeMenu() {
                        navMenu.classList.remove('open');
                        mobileOverlay.classList.remove('active');
                    }

                    if (navToggle && navMenu && mobileOverlay) {
                        navToggle.addEventListener('click', function (e) {
                            e.stopPropagation();
                            if (navMenu.classList.contains('open')) {
                                closeMenu();
                            } else {
                                openMenu();
                            }
                        });

                        mobileOverlay.addEventListener('click', closeMenu);

                        // Click outside to close
                        document.addEventListener('click', function (e) {
                            if (navMenu.classList.contains('open') && !navMenu.contains(e.target) && !navToggle.contains(e.target)) {
                                closeMenu();
                            }
                        });
                    }

                    // Navbar Scroll Shadow Toggle
                    const navbarWrapper = document.getElementById('navbarWrapper');
                    window.addEventListener('scroll', function () {
                        if (window.scrollY > 20) {
                            navbarWrapper.classList.add('scrolled');
                        } else {
                            navbarWrapper.classList.remove('scrolled');
                        }
                    });

                    // Scroll Reveal Observer
                    const revealElements = document.querySelectorAll('.reveal');
                    const observer = new IntersectionObserver((entries, obs) => {
                        entries.forEach(entry => {
                            if (entry.isIntersecting) {
                                entry.target.classList.add('active');
                                obs.unobserve(entry.target);
                            }
                        });
                    }, { threshold: 0.15 });

                    revealElements.forEach(el => observer.observe(el));
                });
            </script>
        </body>

        </html>