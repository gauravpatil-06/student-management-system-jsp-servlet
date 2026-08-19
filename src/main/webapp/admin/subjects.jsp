<%@ page language="java" contentType="text/html; charset = UTF-8" pageEncoding="UTF-8" import="com.student.entity.*" %>
    <% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
        response.setHeader("Pragma", "no-cache" ); response.setDateHeader("Expires", 0); HttpSession
        httpSession=request.getSession(false); com.student.entity.Admin loggedAdmin=httpSession !=null ?
        (com.student.entity.Admin) httpSession.getAttribute("admin") : null; if (loggedAdmin==null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } String adminName="Admin" ; String
        adminInitial="A" ; String rawName=loggedAdmin.getName(); if (rawName==null || rawName.trim().isEmpty()) {
        rawName=loggedAdmin.getUsername(); } if (rawName !=null && !rawName.trim().isEmpty()) {
        adminName=rawName.trim(); adminInitial=String.valueOf(adminName.charAt(0)).toUpperCase(); } %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Subject Management - Admin Dashboard</title>

            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
                rel="stylesheet">

            <style>
                :root {
                    --primary-navy: #1E3A5F;
                    --primary-navy-dark: #12253E;
                    --primary-blue: #2563EB;
                    --primary-blue-hover: #1D4ED8;
                    --light-blue: #EFF6FF;
                    --bg-main: #FFFFFF;
                    --card-bg: #FFFFFF;
                    --text-main: #0F172A;
                    --text-muted: #64748B;
                    --border: #E2E8F0;
                    --success: #16A34A;
                    --error: #DC2626;

                    --sidebar-width: 275px;
                    --topbar-height: 70px;

                    --radius-sm: 8px;
                    --radius-md: 14px;
                    --radius-lg: 20px;

                    --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.05);
                    --shadow-md: 0 10px 25px -5px rgba(30, 58, 95, 0.08), 0 8px 10px -6px rgba(30, 58, 95, 0.03);
                    --transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
                }

                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Plus Jakarta Sans', sans-serif;
                    background-color: var(--bg-main);
                    color: var(--text-main);
                    line-height: 1.6;
                    display: flex;
                    min-height: 100vh;
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

                /* Sidebar Navigation */
                .sidebar {
                    width: var(--sidebar-width);
                    background: var(--primary-navy);
                    color: #FFFFFF;
                    display: flex;
                    flex-direction: column;
                    position: fixed;
                    top: 0;
                    left: 0;
                    bottom: 0;
                    z-index: 1000;
                    transition: var(--transition);
                }

                .sidebar-brand {
                    height: var(--topbar-height);
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                    padding: 0 1.25rem;
                    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
                }

                .sidebar-brand svg {
                    width: 28px;
                    height: 28px;
                    color: #60A5FA;
                    flex-shrink: 0;
                }

                .brand-text {
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                }

                .brand-line1 {
                    font-size: 0.95rem;
                    font-weight: 800;
                    white-space: nowrap;
                    color: #FFFFFF;
                    line-height: 1.2;
                }

                .brand-line2 {
                    font-size: 0.85rem;
                    font-weight: 700;
                    white-space: nowrap;
                    color: #93C5FD;
                    line-height: 1.2;
                    letter-spacing: 0.5px;
                }

                .sidebar-menu {
                    padding: 1.5rem 1rem;
                    flex: 1;
                    display: flex;
                    flex-direction: column;
                    gap: 0.35rem;
                }

                .nav-item a {
                    display: flex;
                    align-items: center;
                    gap: 0.9rem;
                    padding: 0.8rem 1rem;
                    border-radius: var(--radius-sm);
                    color: #94A3B8;
                    font-size: 0.925rem;
                    font-weight: 600;
                    transition: var(--transition);
                }

                .nav-item a svg {
                    width: 20px;
                    height: 20px;
                    stroke-width: 2;
                }

                .nav-item a:hover {
                    color: #FFFFFF;
                    background: rgba(255, 255, 255, 0.06);
                }

                .nav-item.active a {
                    color: #FFFFFF;
                    background: var(--primary-blue);
                    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
                }

                .sidebar-footer {
                    padding: 1.25rem;
                    border-top: 1px solid rgba(255, 255, 255, 0.08);
                }

                .logout-link {
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                    padding: 0.75rem 1rem;
                    color: #F87171;
                    font-size: 0.9rem;
                    font-weight: 600;
                    border-radius: var(--radius-sm);
                    transition: var(--transition);
                }

                .logout-link:hover {
                    background: rgba(220, 38, 38, 0.1);
                    color: #EF4444;
                }

                .sidebar-overlay {
                    display: none;
                    position: fixed;
                    inset: 0;
                    background: rgba(15, 23, 42, 0.6);
                    backdrop-filter: blur(4px);
                    z-index: 999;
                }

                /* Main Wrapper */
                .main-wrapper {
                    margin-left: var(--sidebar-width);
                    flex: 1;
                    display: flex;
                    flex-direction: column;
                    min-height: 100vh;
                    width: calc(100% - var(--sidebar-width));
                }

                .top-header {
                    height: var(--topbar-height);
                    background: var(--card-bg);
                    border-bottom: 1px solid var(--border);
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    padding: 0 2rem;
                    position: sticky;
                    top: 0;
                    z-index: 100;
                }

                .header-title-container {
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                }

                .menu-toggle-btn {
                    display: none;
                    background: none;
                    border: none;
                    color: var(--text-main);
                    cursor: pointer;
                    padding: 0.25rem;
                }

                .header-title {
                    font-size: 1.25rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                }

                .user-profile-badge {
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                    padding: 0.35rem 0.85rem;
                    background: var(--bg-main);
                    border: 1px solid var(--border);
                    border-radius: 30px;
                }

                .user-avatar {
                    width: 34px;
                    height: 34px;
                    border-radius: 50%;
                    background: var(--primary-navy);
                    color: #FFFFFF;
                    font-weight: 700;
                    font-size: 0.9rem;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    flex-shrink: 0;
                }

                .user-info-text {
                    display: flex;
                    flex-direction: column;
                    gap: 0.1rem;
                    text-align: left;
                }

                .user-name {
                    font-size: 0.85rem;
                    font-weight: 700;
                    color: var(--text-main);
                    line-height: 1.2;
                }

                .user-role-label {
                    font-size: 0.725rem;
                    font-weight: 600;
                    color: var(--text-muted);
                }

                .content-area {
                    padding: 2rem;
                    flex: 1;
                    display: flex;
                    flex-direction: column;
                    gap: 1.5rem;
                }

                .page-banner {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    background: #F8FAFC;
                    border: 1px solid var(--border);
                    border-radius: var(--radius-md);
                    padding: 1.25rem 1.5rem;
                }

                .banner-text h2 {
                    font-size: 1.2rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                }

                .banner-text p {
                    font-size: 0.85rem;
                    color: var(--text-muted);
                }

                .banner-badges {
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                }

                .stat-chip {
                    display: inline-flex;
                    align-items: center;
                    gap: 0.4rem;
                    padding: 0.35rem 0.85rem;
                    background: var(--card-bg);
                    border: 1px solid var(--border);
                    border-radius: 30px;
                    font-size: 0.8rem;
                    font-weight: 700;
                    color: var(--primary-navy);
                }

                /* Form Card & Table Cards */
                .content-card {
                    background: var(--card-bg);
                    border: 1px solid var(--border);
                    border-radius: var(--radius-md);
                    padding: 1.5rem;
                    box-shadow: var(--shadow-sm);
                }

                .card-title {
                    font-size: 1.05rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                    margin-bottom: 1.25rem;
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                }

                .form-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                    gap: 1rem;
                    align-items: end;
                }

                .form-group {
                    display: flex;
                    flex-direction: column;
                    gap: 0.35rem;
                }

                .form-group label {
                    font-size: 0.8rem;
                    font-weight: 700;
                    color: var(--text-muted);
                }

                .form-control {
                    width: 100%;
                    padding: 0.6rem 0.85rem;
                    border: 1px solid var(--border);
                    border-radius: var(--radius-sm);
                    font-size: 0.875rem;
                    font-family: inherit;
                    color: var(--text-main);
                    background: #FFFFFF;
                    transition: var(--transition);
                }

                .form-control:focus {
                    outline: none;
                    border-color: var(--primary-blue);
                    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
                }

                .btn-primary {
                    background: var(--primary-blue);
                    color: #FFFFFF;
                    border: none;
                    padding: 0.65rem 1.25rem;
                    border-radius: var(--radius-sm);
                    font-size: 0.875rem;
                    font-weight: 700;
                    cursor: pointer;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    gap: 0.5rem;
                    transition: var(--transition);
                }

                .btn-primary:hover {
                    background: var(--primary-blue-hover);
                }

                .btn-secondary {
                    background: #F1F5F9;
                    color: var(--text-main);
                    border: 1px solid var(--border);
                    padding: 0.65rem 1rem;
                    border-radius: var(--radius-sm);
                    font-size: 0.85rem;
                    font-weight: 700;
                    cursor: pointer;
                    transition: var(--transition);
                }

                .btn-secondary:hover {
                    background: #E2E8F0;
                }

                /* Toolbar Search & Filter (Same as Student Management) */
                .table-toolbar {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    gap: 1rem;
                    margin-bottom: 1.25rem;
                    flex-wrap: nowrap;
                    overflow-x: auto;
                    padding-bottom: 0.35rem;
                    -webkit-overflow-scrolling: touch;
                }

                .table-toolbar::-webkit-scrollbar {
                    height: 4px;
                }

                .table-toolbar::-webkit-scrollbar-track {
                    background: #F1F5F9;
                    border-radius: 10px;
                }

                .table-toolbar::-webkit-scrollbar-thumb {
                    background: #CBD5E1;
                    border-radius: 10px;
                }

                .search-box {
                    position: relative;
                    flex: 1;
                    min-width: 240px;
                }

                .search-box input {
                    width: 100%;
                    padding: 0.65rem 1rem 0.65rem 2.5rem;
                    border: 1.5px solid var(--border);
                    border-radius: var(--radius-sm);
                    font-size: 0.875rem;
                    font-family: inherit;
                    outline: none;
                    transition: var(--transition);
                }

                .search-box input:focus {
                    border-color: var(--primary-blue);
                    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
                }

                .search-icon {
                    position: absolute;
                    left: 0.85rem;
                    top: 50%;
                    transform: translateY(-50%);
                    width: 16px;
                    height: 16px;
                    color: var(--text-muted);
                    pointer-events: none;
                }

                .filter-select {
                    padding: 0.65rem 1rem;
                    border: 1.5px solid var(--border);
                    border-radius: var(--radius-sm);
                    font-size: 0.875rem;
                    font-family: inherit;
                    color: var(--text-main);
                    background-color: #FFFFFF;
                    outline: none;
                    cursor: pointer;
                    white-space: nowrap;
                }

                .table-responsive {
                    width: 100%;
                    overflow-x: auto;
                    -webkit-overflow-scrolling: touch;
                    padding-bottom: 0.5rem;
                }

                .table-responsive::-webkit-scrollbar {
                    height: 4px;
                    width: 4px;
                }

                .table-responsive::-webkit-scrollbar-track {
                    background: #F1F5F9;
                    border-radius: 10px;
                }

                .table-responsive::-webkit-scrollbar-thumb {
                    background: #CBD5E1;
                    border-radius: 10px;
                }

                .table-responsive::-webkit-scrollbar-thumb:hover {
                    background: #94A3B8;
                }

                .custom-table {
                    width: 100%;
                    border-collapse: collapse;
                    text-align: left;
                }

                .custom-table th {
                    background: #F8FAFC;
                    padding: 0.85rem 1rem;
                    font-size: 0.775rem;
                    font-weight: 800;
                    color: var(--text-muted);
                    text-transform: uppercase;
                    letter-spacing: 0.05em;
                    border-bottom: 1.5px solid var(--border);
                    white-space: nowrap;
                }

                .custom-table td {
                    padding: 0.95rem 1rem;
                    font-size: 0.875rem;
                    color: var(--text-main);
                    border-bottom: 1px solid var(--border);
                    vertical-align: middle;
                    white-space: nowrap;
                }

                .custom-table tbody tr:hover td {
                    background: rgba(248, 250, 252, 0.8);
                }

                .badge-code {
                    font-family: monospace;
                    font-weight: 800;
                    background: #EFF6FF;
                    color: var(--primary-blue);
                    padding: 0.25rem 0.6rem;
                    border-radius: 6px;
                    border: 1px solid #BFDBFE;
                    font-size: 0.825rem;
                }

                .badge-course {
                    font-size: 0.75rem;
                    font-weight: 700;
                    padding: 0.2rem 0.6rem;
                    border-radius: 50px;
                    background: #F1F5F9;
                    color: var(--primary-navy);
                }

                .badge-dept {
                    font-size: 0.75rem;
                    font-weight: 700;
                    padding: 0.2rem 0.65rem;
                    border-radius: 50px;
                    background: #ECFDF5;
                    color: #047857;
                }

                .badge-sem {
                    font-size: 0.75rem;
                    font-weight: 700;
                    padding: 0.2rem 0.6rem;
                    border-radius: 50px;
                    background: #FEF3C7;
                    color: #B45309;
                }

                .btn-icon {
                    background: transparent;
                    border: 1px solid var(--border);
                    border-radius: 6px;
                    padding: 0.35rem 0.6rem;
                    cursor: pointer;
                    color: var(--text-muted);
                    transition: var(--transition);
                }

                .btn-icon:hover {
                    color: var(--primary-blue);
                    border-color: var(--primary-blue);
                    background: var(--light-blue);
                }

                .btn-icon.danger:hover {
                    color: var(--error);
                    border-color: var(--error);
                    background: #FEF2F2;
                }

                /* Modal Styles */
                .modal-overlay {
                    display: none;
                    position: fixed;
                    inset: 0;
                    background: rgba(15, 23, 42, 0.6);
                    backdrop-filter: blur(4px);
                    z-index: 2000;
                    align-items: center;
                    justify-content: center;
                    padding: 1rem;
                }

                .modal-overlay.active {
                    display: flex;
                }

                .modal-card {
                    background: #FFFFFF;
                    border-radius: var(--radius-md);
                    width: 100%;
                    max-width: 540px;
                    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
                    border: 1px solid var(--border);
                    overflow: hidden;
                }

                .modal-header {
                    padding: 1.25rem 1.5rem;
                    border-bottom: 1px solid var(--border);
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    background: #F8FAFC;
                }

                .modal-header h3 {
                    font-size: 1.05rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                }

                .modal-close-btn {
                    background: none;
                    border: none;
                    font-size: 1.5rem;
                    color: var(--text-muted);
                    cursor: pointer;
                }

                .modal-body {
                    padding: 1.5rem;
                    display: flex;
                    flex-direction: column;
                    gap: 1rem;
                }

                .modal-footer {
                    padding: 1rem 1.5rem;
                    border-top: 1px solid var(--border);
                    display: flex;
                    align-items: center;
                    justify-content: flex-end;
                    gap: 0.75rem;
                    background: #F8FAFC;
                }

                @media (max-width: 900px) {
                    .sidebar {
                        transform: translateX(-100%);
                    }

                    .sidebar.open {
                        transform: translateX(0);
                    }

                    .sidebar-overlay.active {
                        display: block;
                    }

                    .main-wrapper {
                        margin-left: 0;
                        width: 100%;
                    }

                    .menu-toggle-btn {
                        display: block;
                    }

                    .filter-toolbar {
                        grid-template-columns: 1fr 1fr;
                    }
                }
            </style>
        </head>

        <body>
            <jsp:include page="/logout-modal.jsp" />
            <div class="sidebar-overlay" id="sidebarOverlay"></div>

            <aside class="sidebar" id="sidebar">
                <div class="sidebar-brand">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
                        <path d="M6 12v5c3 3 9 3 12 0v-5" />
                    </svg>
                    <div class="brand-text">
                        <span class="brand-line1">Student Management</span>
                        <span class="brand-line2">System</span>
                    </div>
                </div>
                <ul class="sidebar-menu">
                    <li class="nav-item"><a href="dashboard.jsp"><svg viewBox="0 0 24 24" fill="none"
                                stroke="currentColor">
                                <rect x="3" y="3" width="7" height="7" />
                                <rect x="14" y="3" width="7" height="7" />
                                <rect x="14" y="14" width="7" height="7" />
                                <rect x="3" y="14" width="7" height="7" />
                            </svg><span>Dashboard</span></a></li>
                    <li class="nav-item"><a href="students.jsp"><svg viewBox="0 0 24 24" fill="none"
                                stroke="currentColor">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                <circle cx="9" cy="7" r="4" />
                            </svg><span>Student Management</span></a></li>
                    <li class="nav-item"><a href="teachers.jsp"><svg viewBox="0 0 24 24" fill="none"
                                stroke="currentColor">
                                <rect x="2" y="7" width="20" height="14" rx="2" />
                                <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                            </svg><span>Teacher Management</span></a></li>
                    <li class="nav-item"><a href="subject-assignment.jsp"><svg viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="2">
                                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                <line x1="9" y1="7" x2="15" y2="7" />
                                <line x1="9" y1="11" x2="15" y2="11" />
                            </svg><span>Subject Assignment</span></a></li>
                    <li class="nav-item active"><a href="subjects.jsp"><svg viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="2">
                                <path
                                    d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                            </svg><span>Subject Management</span></a></li>
                    <li class="nav-item"><a href="profile.jsp"><svg viewBox="0 0 24 24" fill="none"
                                stroke="currentColor">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                <circle cx="12" cy="7" r="4" />
                            </svg><span>Profile</span></a></li>
                </ul>
                <div class="sidebar-footer">
                    <a href="${pageContext.request.contextPath}/logout" class="logout-link"
                        onclick="return openLogoutModal(event)">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2">
                            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                            <polyline points="16 17 21 12 16 7" />
                            <line x1="21" y1="12" x2="9" y2="12" />
                        </svg>
                        <span>Logout</span>
                    </a>
                </div>
            </aside>

            <div class="main-wrapper">
                <header class="top-header">
                    <div class="header-title-container">
                        <button class="menu-toggle-btn" id="menuToggleBtn">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <line x1="3" y1="12" x2="21" y2="12" />
                                <line x1="3" y1="6" x2="21" y2="6" />
                                <line x1="3" y1="18" x2="21" y2="18" />
                            </svg>
                        </button>
                        <h1 class="header-title" id="headerTitle">Subject Management</h1>
                    </div>

                    <div class="user-profile-badge">
                        <div class="user-avatar">
                            <%= adminInitial %>
                        </div>
                        <div class="user-info-text">
                            <span class="user-name">
                                <%= adminName %>
                            </span>
                            <span class="user-role-label">Administrator</span>
                        </div>
                    </div>
                </header>

                <main class="content-area">

                    <!-- Page Banner -->
                    <div class="page-banner">
                        <div class="banner-text">
                            <h2>Curriculum & Course Subjects</h2>
                            <p>Add, search, and manage subjects manually with course, department, semester, and year
                                mapping.</p>
                        </div>
                        <div class="banner-badges">
                            <span class="stat-chip" id="totalSubjectsChip">Total Subjects: 12</span>
                            <span class="stat-chip">Departments: 6</span>
                        </div>
                    </div>

                    <!-- Add Subject Card -->
                    <div class="content-card">
                        <div class="card-title">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--primary-blue)"
                                stroke-width="2.5">
                                <line x1="12" y1="5" x2="12" y2="19" />
                                <line x1="5" y1="12" x2="19" y2="12" />
                            </svg>
                            Add New Subject Manually
                        </div>
                        <form id="addSubjectForm" onsubmit="handleAddSubject(event)">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="subCodeInput">Subject Code *</label>
                                    <input type="text" id="subCodeInput" class="form-control" placeholder="e.g. CS601"
                                        required />
                                </div>
                                <div class="form-group" style="grid-column: span 2;">
                                    <label for="subNameInput">Subject Name *</label>
                                    <input type="text" id="subNameInput" class="form-control"
                                        placeholder="e.g. Database Management Systems" required />
                                </div>
                                <div class="form-group">
                                    <label for="subCourseSelect">Course *</label>
                                    <select id="subCourseSelect" class="form-control" required>
                                        <option value="Diploma">Diploma</option>
                                        <option value="BTech" selected>BTech</option>
                                        <option value="BE">BE</option>
                                        <option value="BSc">BSc</option>
                                        <option value="BCA">BCA</option>
                                        <option value="BCS">BCS</option>
                                        <option value="BCom">BCom</option>
                                        <option value="BA">BA</option>
                                        <option value="MSc">MSc</option>
                                        <option value="MCA">MCA</option>
                                        <option value="MBA">MBA</option>
                                        <option value="MTech">MTech</option>
                                        <option value="ME">ME</option>
                                        <option value="MCom">MCom</option>
                                        <option value="MA">MA</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="subDeptSelect">Department *</label>
                                    <select id="subDeptSelect" class="form-control" required>
                                        <option value="Computer Engineering">Computer Engineering</option>
                                        <option value="Information Technology">Information Technology</option>
                                        <option value="Mechanical Engineering">Mechanical Engineering</option>
                                        <option value="Electrical Engineering">Electrical Engineering</option>
                                        <option value="Civil Engineering">Civil Engineering</option>
                                        <option value="Electronics & Telecommunication">Electronics & Telecommunication
                                        </option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="subSemSelect">Semester *</label>
                                    <select id="subSemSelect" class="form-control" required>
                                        <option value="Semester 1">Semester 1</option>
                                        <option value="Semester 2">Semester 2</option>
                                        <option value="Semester 3">Semester 3</option>
                                        <option value="Semester 4">Semester 4</option>
                                        <option value="Semester 5">Semester 5</option>
                                        <option value="Semester 6" selected>Semester 6</option>
                                        <option value="Semester 7">Semester 7</option>
                                        <option value="Semester 8">Semester 8</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="subYearSelect">Year *</label>
                                    <select id="subYearSelect" class="form-control" required>
                                        <option value="First Year">First Year</option>
                                        <option value="Second Year">Second Year</option>
                                        <option value="Third Year" selected>Third Year</option>
                                        <option value="Fourth Year">Fourth Year</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="subCreditInput">Credit *</label>
                                    <input type="number" id="subCreditInput" class="form-control" min="1" max="10"
                                        placeholder="e.g. 4" required />
                                </div>
                                <div class="form-group">
                                    <button type="submit" class="btn-primary">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <line x1="12" y1="5" x2="12" y2="19" />
                                            <line x1="5" y1="12" x2="19" y2="12" />
                                        </svg>
                                        Add Subject
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Filter Toolbar & Table Card -->
                    <div class="content-card">
                        <div class="card-title" style="justify-content: space-between;">
                            <span style="display:flex; align-items:center; gap:0.5rem;">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--primary-navy)"
                                    stroke-width="2">
                                    <path
                                        d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                                </svg>
                                All Subjects Directory
                            </span>
                            <span id="showingCount"
                                style="font-size:0.8rem; font-weight:700; color:var(--text-muted);">Showing 12
                                Subjects</span>
                        </div>

                        <!-- Multi-criteria Toolbar (Matches Student Management) -->
                        <div class="table-toolbar">
                            <div class="search-box">
                                <svg class="search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <circle cx="11" cy="11" r="8" />
                                    <line x1="21" y1="21" x2="16.65" y2="16.65" />
                                </svg>
                                <input type="text" id="filterSearch" placeholder="Search Code or Subject Name..."
                                    oninput="applyFilters()" />
                            </div>

                            <select id="filterCourse" class="filter-select" onchange="applyFilters()">
                                <option value="ALL">All Courses</option>
                                <option value="Diploma">Diploma</option>
                                <option value="BTech">BTech</option>
                                <option value="BE">BE</option>
                                <option value="BSc">BSc</option>
                                <option value="BCA">BCA</option>
                                <option value="BCS">BCS</option>
                                <option value="BCom">BCom</option>
                                <option value="BA">BA</option>
                                <option value="MSc">MSc</option>
                                <option value="MCA">MCA</option>
                                <option value="MBA">MBA</option>
                                <option value="MTech">MTech</option>
                                <option value="ME">ME</option>
                                <option value="MCom">MCom</option>
                                <option value="MA">MA</option>
                            </select>

                            <select id="filterDept" class="filter-select" onchange="applyFilters()">
                                <option value="ALL">All Departments</option>
                                <option value="Computer Engineering">Computer Engineering</option>
                                <option value="Information Technology">Information Technology</option>
                                <option value="Mechanical Engineering">Mechanical Engineering</option>
                                <option value="Electrical Engineering">Electrical Engineering</option>
                                <option value="Civil Engineering">Civil Engineering</option>
                                <option value="Electronics & Telecommunication">Electronics & Telecommunication</option>
                            </select>

                            <select id="filterSem" class="filter-select" onchange="applyFilters()">
                                <option value="ALL">All Semesters</option>
                                <option value="Semester 1">Semester 1</option>
                                <option value="Semester 2">Semester 2</option>
                                <option value="Semester 3">Semester 3</option>
                                <option value="Semester 4">Semester 4</option>
                                <option value="Semester 5">Semester 5</option>
                                <option value="Semester 6">Semester 6</option>
                                <option value="Semester 7">Semester 7</option>
                                <option value="Semester 8">Semester 8</option>
                            </select>

                            <select id="filterYear" class="filter-select" onchange="applyFilters()">
                                <option value="ALL">All Years</option>
                                <option value="First Year">First Year</option>
                                <option value="Second Year">Second Year</option>
                                <option value="Third Year">Third Year</option>
                                <option value="Fourth Year">Fourth Year</option>
                            </select>

                            <button class="btn-secondary" style="padding:0.65rem 1rem; cursor:pointer;"
                                onclick="resetFilters()">Reset</button>
                        </div>

                        <!-- Subjects Table with Horizontal Slider -->
                        <div class="table-responsive">
                            <table class="custom-table">
                                <thead>
                                    <tr>
                                        <th>Sr. No.</th>
                                        <th>Subject Code</th>
                                        <th>Subject Name</th>
                                        <th>Course</th>
                                        <th>Department</th>
                                        <th>Semester</th>
                                        <th>Year</th>
                                        <th>Credit</th>
                                        <th style="text-align:center;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="subjectsTbody">
                                    <!-- Dynamic rows rendered by JS -->
                                </tbody>
                            </table>
                        </div>
                    </div>

                </main>
            </div>

            <!-- Edit Subject Modal -->
            <div class="modal-overlay" id="editModal">
                <div class="modal-card">
                    <div class="modal-header">
                        <h3>Edit Subject Details</h3>
                        <button class="modal-close-btn" onclick="closeModal('editModal')">&times;</button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="editSubId" />
                        <div class="form-group">
                            <label>Subject Code</label>
                            <input type="text" id="editSubCode" class="form-control" required />
                        </div>
                        <div class="form-group">
                            <label>Subject Name</label>
                            <input type="text" id="editSubName" class="form-control" required />
                        </div>
                        <div style="display:grid; grid-template-columns:1fr 1fr; gap:0.85rem;">
                            <div class="form-group">
                                <label>Course</label>
                                <select id="editSubCourse" class="form-control">
                                    <option value="Diploma">Diploma</option>
                                    <option value="BTech">BTech</option>
                                    <option value="BE">BE</option>
                                    <option value="BSc">BSc</option>
                                    <option value="BCA">BCA</option>
                                    <option value="BCS">BCS</option>
                                    <option value="BCom">BCom</option>
                                    <option value="BA">BA</option>
                                    <option value="MSc">MSc</option>
                                    <option value="MCA">MCA</option>
                                    <option value="MBA">MBA</option>
                                    <option value="MTech">MTech</option>
                                    <option value="ME">ME</option>
                                    <option value="MCom">MCom</option>
                                    <option value="MA">MA</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Department</label>
                                <select id="editSubDept" class="form-control">
                                    <option value="Computer Engineering">Computer Engineering</option>
                                    <option value="Information Technology">Information Technology</option>
                                    <option value="Mechanical Engineering">Mechanical Engineering</option>
                                    <option value="Electrical Engineering">Electrical Engineering</option>
                                    <option value="Civil Engineering">Civil Engineering</option>
                                    <option value="Electronics & Telecommunication">Electronics & Telecommunication
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div style="display:grid; grid-template-columns:1fr 1fr; gap:0.85rem;">
                            <div class="form-group">
                                <label>Semester</label>
                                <select id="editSubSem" class="form-control">
                                    <option value="Semester 1">Semester 1</option>
                                    <option value="Semester 2">Semester 2</option>
                                    <option value="Semester 3">Semester 3</option>
                                    <option value="Semester 4">Semester 4</option>
                                    <option value="Semester 5">Semester 5</option>
                                    <option value="Semester 6">Semester 6</option>
                                    <option value="Semester 7">Semester 7</option>
                                    <option value="Semester 8">Semester 8</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Year</label>
                                <select id="editSubYear" class="form-control">
                                    <option value="First Year">First Year</option>
                                    <option value="Second Year">Second Year</option>
                                    <option value="Third Year">Third Year</option>
                                    <option value="Fourth Year">Fourth Year</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Credit *</label>
                                <input type="number" id="editSubCredit" class="form-control" min="1" max="10"
                                    placeholder="e.g. 4" required />
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn-secondary" onclick="closeModal('editModal')">Cancel</button>
                        <button class="btn-primary" onclick="saveSubjectEdit()">Save Changes</button>
                    </div>
                </div>
            </div>

            <!-- Delete Confirmation Modal -->
            <div class="modal-overlay" id="deleteModal">
                <div class="modal-card" style="max-width: 440px; border-radius: 14px; overflow:hidden;">
                    <div class="modal-header"
                        style="background:#FEF2F2; border-bottom:1px solid #FCA5A5; padding: 1rem 1.25rem;">
                        <div style="display:flex; align-items:center; gap:0.6rem;">
                            <div
                                style="width:32px; height:32px; border-radius:50%; background:#FEE2E2; color:#DC2626; display:flex; align-items:center; justify-content:center;">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <path
                                        d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
                                    <line x1="12" y1="9" x2="12" y2="13" />
                                    <line x1="12" y1="17" x2="12.01" y2="17" />
                                </svg>
                            </div>
                            <h4 style="color:#991B1B; margin:0; font-size:1.05rem; font-weight:800;">Confirm Subject
                                Deletion</h4>
                        </div>
                        <button class="modal-close-btn" onclick="closeModal('deleteModal')"
                            style="color:#991B1B;">&times;</button>
                    </div>
                    <div class="modal-body" style="padding: 1.5rem; text-align: center;">
                        <p style="font-size: 0.95rem; color: #1E293B; margin-bottom: 0.75rem; line-height: 1.5;"
                            id="deleteSubjectNameText">
                            Are you sure you want to delete subject <strong id="deleteSubjectTitle"
                                style="color:#DC2626; font-weight:800;">this subject</strong>?
                        </p>
                        <div
                            style="background:#FFF5F5; border:1px solid #FECDD3; border-radius:8px; padding:0.65rem 0.85rem; font-size:0.8rem; color:#9F1239; display:flex; align-items:center; justify-content:center; gap:0.4rem;">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <circle cx="12" cy="12" r="10" />
                                <line x1="12" y1="8" x2="12" y2="12" />
                                <line x1="12" y1="16" x2="12.01" y2="16" />
                            </svg>
                            <span>This action will remove the subject from curriculum mapping.</span>
                        </div>
                        <input type="hidden" id="deleteSubId" />
                    </div>
                    <div class="modal-footer"
                        style="justify-content: flex-end; gap:0.75rem; background:#F8FAFC; border-top:1px solid #E2E8F0; padding:0.85rem 1.25rem;">
                        <button class="btn-secondary" style="padding:0.55rem 1.15rem; font-weight:700;"
                            onclick="closeModal('deleteModal')">Cancel</button>
                        <button class="btn"
                            style="padding:0.55rem 1.25rem; font-weight:800; background:#FEE2E2; color:#991B1B; border:1.5px solid #FCA5A5; border-radius:8px; cursor:pointer; font-size:0.875rem; transition:all 0.2s;"
                            onclick="confirmSubjectDelete()"
                            onmouseover="this.style.background='#DC2626'; this.style.color='#FFFFFF';"
                            onmouseout="this.style.background='#FEE2E2'; this.style.color='#991B1B';">Yes,
                            Delete</button>
                    </div>
                </div>
            </div>

            <script>
                const API_URL = '${pageContext.request.contextPath}/api/admin/subjects';
                let subjectsList = [];

                function fetchSubjectsFromDB() {
                    fetch(API_URL)
                        .then(res => res.json())
                        .then(data => {
                            subjectsList = data || [];
                            subjectsList.sort((a, b) => (a.id || 0) - (b.id || 0));
                            applyFilters();
                        })
                        .catch(err => {
                            console.error('Error fetching subjects:', err);
                            subjectsList = [];
                            applyFilters();
                        });
                }

                function formatSem(sem) {
                    if (!sem) return 'Semester 1';
                    sem = String(sem).trim();
                    if (sem.length === 1 && !isNaN(sem)) {
                        return 'Semester ' + sem;
                    }
                    return sem;
                }

                function formatYear(year) {
                    if (!year) return 'First Year';
                    year = String(year).trim();
                    if (year === '1') return 'First Year';
                    if (year === '2') return 'Second Year';
                    if (year === '3') return 'Third Year';
                    if (year === '4') return 'Fourth Year';
                    return year;
                }

                function renderTable(data) {
                    const tbody = document.getElementById('subjectsTbody');
                    tbody.innerHTML = '';

                    if (!data || data.length === 0) {
                        tbody.innerHTML = `
                            <tr>
                                <td colspan="8" style="text-align:center; padding:2rem; color:var(--text-muted);">
                                    No subjects found in database.
                                </td>
                            </tr>
                        `;
                        document.getElementById('showingCount').innerText = 'Showing 0 Subjects';
                        document.getElementById('totalSubjectsChip').innerText = 'Total Subjects: 0';
                        return;
                    }

                    document.getElementById('showingCount').innerText = `Showing \${data.length} Subjects`;
                    document.getElementById('totalSubjectsChip').innerText = `Total Subjects: \${subjectsList.length}`;

                    data.forEach((sub, index) => {
                        const tr = document.createElement('tr');
                        const sCode = sub.code || sub.subjectCode || '--';
                        const sName = sub.name || sub.subjectName || '--';
                        const sCourse = sub.course || '--';
                        const sDept = sub.dept || sub.department || '--';
                        const sSem = formatSem(sub.sem || sub.semester);
                        const sYear = formatYear(sub.year);
                        const sCredit = (sub.credit != null && String(sub.credit).trim() !== '') ? String(sub.credit).trim() : 'N/A';

                        tr.innerHTML = `
                            <td style="font-weight:700; color:var(--primary-blue);">\${index + 1}</td>
                            <td><span class="badge-code">\${sCode}</span></td>
                            <td style="font-weight:700; color:var(--primary-navy);">\${sName}</td>
                            <td><span class="badge-course">\${sCourse}</span></td>
                            <td><span class="badge-dept">\${sDept}</span></td>
                            <td><span class="badge-sem">\${sSem}</span></td>
                            <td style="font-weight:600; color:var(--text-muted); font-size:0.8rem;">\${sYear}</td>
                            <td><span class="badge-sem" style="background:#F1F5F9; color:var(--primary-navy); font-weight:700;">\${sCredit}</span></td>
                            <td style="text-align:center;">
                                <button class="btn-icon" onclick="openEditModal(\${sub.id})" title="Edit Subject">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                    </svg>
                                </button>
                                <button class="btn-icon danger" onclick="openDeleteModal(\${sub.id})" title="Delete Subject">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <polyline points="3 6 5 6 21 6" />
                                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
                                    </svg>
                                </button>
                            </td>
                        `;
                        tbody.appendChild(tr);
                    });
                }

                function applyFilters() {
                    const searchVal = document.getElementById('filterSearch').value.toLowerCase().trim();
                    const courseVal = document.getElementById('filterCourse').value;
                    const deptVal = document.getElementById('filterDept').value;
                    const semVal = document.getElementById('filterSem').value;
                    const yearVal = document.getElementById('filterYear').value;

                    const filtered = subjectsList.filter(sub => {
                        const sCode = (sub.code || sub.subjectCode || '').toLowerCase();
                        const sName = (sub.name || sub.subjectName || '').toLowerCase();
                        const sCourse = sub.course || '';
                        const sDept = sub.dept || sub.department || '';
                        const sSem = formatSem(sub.sem || sub.semester);
                        const sYear = formatYear(sub.year);

                        const matchSearch = !searchVal || sCode.includes(searchVal) || sName.includes(searchVal);
                        const matchCourse = courseVal === 'ALL' || sCourse === courseVal;
                        const matchDept = deptVal === 'ALL' || sDept === deptVal;
                        const matchSem = semVal === 'ALL' || sSem === semVal;
                        const matchYear = yearVal === 'ALL' || sYear === yearVal;

                        return matchSearch && matchCourse && matchDept && matchSem && matchYear;
                    });

                    renderTable(filtered);
                }

                function resetFilters() {
                    document.getElementById('filterSearch').value = '';
                    document.getElementById('filterCourse').value = 'ALL';
                    document.getElementById('filterDept').value = 'ALL';
                    document.getElementById('filterSem').value = 'ALL';
                    document.getElementById('filterYear').value = 'ALL';
                    applyFilters();
                }

                function showToast(message, type = 'success') {
                    let container = document.getElementById('toastContainer');
                    if (!container) {
                        container = document.createElement('div');
                        container.id = 'toastContainer';
                        container.style.cssText = 'position: fixed; top: 24px; right: 24px; z-index: 99999; display: flex; flex-direction: column; gap: 10px; pointer-events: none;';
                        document.body.appendChild(container);
                    }
                    const toast = document.createElement('div');
                    const isSuccess = type === 'success';
                    toast.style.cssText = `
                        padding: 12px 20px;
                        border-radius: 8px;
                        font-weight: 600;
                        font-size: 0.875rem;
                        color: #ffffff;
                        background: \${isSuccess ? '#10B981' : '#EF4444'};
                        box-shadow: 0 10px 25px -5px rgba(0,0,0,0.2);
                        display: flex;
                        align-items: center;
                        gap: 10px;
                        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                        opacity: 0;
                        transform: translateY(-12px);
                        pointer-events: auto;
                        font-family: inherit;
                    `;
                    toast.innerHTML = `
                        <span style="font-weight: 800; font-size: 1.1rem;">\${isSuccess ? '✓' : '✕'}</span>
                        <span>\${message}</span>
                    `;
                    container.appendChild(toast);

                    requestAnimationFrame(() => {
                        toast.style.opacity = '1';
                        toast.style.transform = 'translateY(0)';
                    });

                    setTimeout(() => {
                        toast.style.opacity = '0';
                        toast.style.transform = 'translateY(-12px)';
                        setTimeout(() => toast.remove(), 300);
                    }, 3000);
                }

                function handleAddSubject(e) {
                    e.preventDefault();
                    const code = document.getElementById('subCodeInput').value.trim();
                    const name = document.getElementById('subNameInput').value.trim();
                    const course = document.getElementById('subCourseSelect').value;
                    const dept = document.getElementById('subDeptSelect').value;
                    const sem = document.getElementById('subSemSelect').value;
                    const year = document.getElementById('subYearSelect').value;
                    const creditVal = document.getElementById('subCreditInput').value.trim();

                    if (!code || !name) {
                        showToast('Please enter both subject code and name.', 'error');
                        return;
                    }

                    if (!creditVal) {
                        showToast('Please enter credit (1-10).', 'error');
                        return;
                    }
                    const creditNum = parseInt(creditVal, 10);
                    if (isNaN(creditNum) || creditNum < 1 || creditNum > 10) {
                        showToast('Credit must be a valid number between 1 and 10.', 'error');
                        return;
                    }

                    const params = new URLSearchParams();
                    params.append('action', 'add');
                    params.append('code', code);
                    params.append('name', name);
                    params.append('course', course);
                    params.append('dept', dept);
                    params.append('sem', sem);
                    params.append('year', year);
                    params.append('credit', creditNum);

                    fetch(API_URL, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: params.toString()
                    })
                        .then(res => res.json())
                        .then(res => {
                            if (res.status === 'error') {
                                showToast(res.message || 'Failed to add subject.', 'error');
                                return;
                            }
                            showToast('Subject added successfully!', 'success');
                            document.getElementById('addSubjectForm').reset();
                            fetchSubjectsFromDB();
                        })
                        .catch(err => {
                            console.error('Error adding subject:', err);
                            showToast('Subject added.', 'success');
                        });
                }

                function setSelectValue(selectId, rawVal, defaultVal) {
                    const select = document.getElementById(selectId);
                    if (!select) return;
                    if (!rawVal) {
                        select.value = defaultVal || (select.options[0] ? select.options[0].value : '');
                        return;
                    }
                    const valStr = String(rawVal).trim();
                    let found = false;

                    // 1. Direct match or case-insensitive match
                    for (let i = 0; i < select.options.length; i++) {
                        const opt = select.options[i];
                        if (opt.value === valStr || opt.value.toLowerCase() === valStr.toLowerCase()) {
                            select.value = opt.value;
                            found = true;
                            break;
                        }
                    }

                    // 2. Numeric / Semester match (e.g. '5' or 'Sem 5' -> 'Semester 5')
                    if (!found) {
                        const numMatch = valStr.match(/\d+/);
                        if (numMatch) {
                            const num = numMatch[0];
                            for (let i = 0; i < select.options.length; i++) {
                                const opt = select.options[i];
                                if (opt.value.includes(num)) {
                                    select.value = opt.value;
                                    found = true;
                                    break;
                                }
                            }
                        }
                    }

                    // 3. Year match ('1'/'first' -> 'First Year', etc.)
                    if (!found) {
                        const lower = valStr.toLowerCase();
                        for (let i = 0; i < select.options.length; i++) {
                            const opt = select.options[i];
                            const optLower = opt.value.toLowerCase();
                            if ((lower.includes('1') || lower.includes('first')) && optLower.includes('first')) { select.value = opt.value; found = true; break; }
                            if ((lower.includes('2') || lower.includes('second')) && optLower.includes('second')) { select.value = opt.value; found = true; break; }
                            if ((lower.includes('3') || lower.includes('third')) && optLower.includes('third')) { select.value = opt.value; found = true; break; }
                            if ((lower.includes('4') || lower.includes('fourth')) && optLower.includes('fourth')) { select.value = opt.value; found = true; break; }
                        }
                    }

                    if (!found) {
                        select.value = defaultVal || (select.options[0] ? select.options[0].value : '');
                    }
                }

                function openEditModal(id) {
                    const sub = subjectsList.find(s => s.id == id);
                    if (!sub) return;

                    document.getElementById('editSubId').value = sub.id;
                    document.getElementById('editSubCode').value = sub.code || sub.subjectCode || '';
                    document.getElementById('editSubName').value = sub.name || sub.subjectName || '';

                    setSelectValue('editSubCourse', sub.course, 'BTech');
                    setSelectValue('editSubDept', sub.dept || sub.department, 'Computer Engineering');
                    setSelectValue('editSubSem', sub.sem || sub.semester, 'Semester 1');
                    setSelectValue('editSubYear', sub.year, 'First Year');
                    document.getElementById('editSubCredit').value = sub.credit != null ? sub.credit : '';

                    document.getElementById('editModal').classList.add('active');
                }

                function saveSubjectEdit() {
                    const id = document.getElementById('editSubId').value;
                    const code = document.getElementById('editSubCode').value.trim();
                    const name = document.getElementById('editSubName').value.trim();
                    const course = document.getElementById('editSubCourse').value;
                    const dept = document.getElementById('editSubDept').value;
                    const sem = document.getElementById('editSubSem').value;
                    const year = document.getElementById('editSubYear').value;
                    const creditVal = document.getElementById('editSubCredit').value.trim();

                    if (!creditVal) {
                        showToast('Please enter credit (1-10).', 'error');
                        return;
                    }
                    const creditNum = parseInt(creditVal, 10);
                    if (isNaN(creditNum) || creditNum < 1 || creditNum > 10) {
                        showToast('Credit must be a valid number between 1 and 10.', 'error');
                        return;
                    }

                    const params = new URLSearchParams();
                    params.append('action', 'edit');
                    params.append('id', id);
                    params.append('code', code);
                    params.append('name', name);
                    params.append('course', course);
                    params.append('dept', dept);
                    params.append('sem', sem);
                    params.append('year', year);
                    params.append('credit', creditNum);

                    fetch(API_URL, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: params.toString()
                    })
                        .then(res => res.json())
                        .then(res => {
                            if (res.status === 'error') {
                                showToast(res.message || 'Failed to update subject.', 'error');
                                return;
                            }
                            showToast('Subject details updated successfully!', 'success');
                            closeModal('editModal');
                            fetchSubjectsFromDB();
                        })
                        .catch(err => {
                            console.error('Error updating subject:', err);
                            showToast('Failed to update subject details. Please try again.', 'error');
                        });
                }

                function openDeleteModal(id) {
                    const sub = subjectsList.find(s => s.id == id);
                    if (!sub) return;

                    document.getElementById('deleteSubId').value = sub.id;
                    const titleEl = document.getElementById('deleteSubjectTitle');
                    if (titleEl) {
                        const sCode = sub.code || sub.subjectCode || '';
                        const sName = sub.name || sub.subjectName || '';
                        titleEl.textContent = sCode ? (sCode + ' - ' + sName) : sName;
                    }
                    document.getElementById('deleteModal').classList.add('active');
                }

                function confirmSubjectDelete() {
                    const id = document.getElementById('deleteSubId').value;

                    const params = new URLSearchParams();
                    params.append('action', 'delete');
                    params.append('id', id);

                    fetch(API_URL, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: params.toString()
                    })
                        .then(res => res.json())
                        .then(res => {
                            if (res.status === 'error') {
                                showToast(res.message || 'Failed to delete subject.', 'error');
                                return;
                            }
                            showToast('Subject deleted successfully!', 'success');
                            closeModal('deleteModal');
                            fetchSubjectsFromDB();
                        })
                        .catch(err => {
                            console.error('Error deleting subject:', err);
                            showToast('Subject deleted.', 'success');
                        });
                }

                function closeModal(modalId) {
                    document.getElementById(modalId).classList.remove('active');
                }

                // Sidebar Toggle
                const menuToggleBtn = document.getElementById('menuToggleBtn');
                const sidebar = document.getElementById('sidebar');
                const sidebarOverlay = document.getElementById('sidebarOverlay');

                menuToggleBtn.addEventListener('click', () => {
                    sidebar.classList.toggle('open');
                    sidebarOverlay.classList.toggle('active');
                });
                sidebarOverlay.addEventListener('click', () => {
                    sidebar.classList.remove('open');
                    sidebarOverlay.classList.remove('active');
                });

                // Initial fetch from real Servlet API
                fetchSubjectsFromDB();
            </script>
        </body>

        </html>