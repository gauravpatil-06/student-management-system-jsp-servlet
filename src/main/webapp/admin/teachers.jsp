<%@ page language = "java" contentType = "text/html; charset = UTF-8" pageEncoding = "UTF-8" import = "com.student.entity.*" %>
    <%
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
        response.setHeader("Pragma", "no-cache" );
        response.setDateHeader("Expires", 0);
        HttpSession httpSession = request.getSession(false);
        com.student.entity.Admin loggedAdmin = httpSession != null ? (com.student.entity.Admin) httpSession.getAttribute("admin") : null;
        if (loggedAdmin == null)
        {
            response.sendRedirect(request.getContextPath() + "/login.jsp" );
            return;
        }
        String adminName = "Admin" ;
        String adminInitial = "A" ;
        String rawName = loggedAdmin.getName();
        if (rawName == null || rawName.trim().isEmpty())
        {
            rawName = loggedAdmin.getUsername();
        }
        if (rawName != null && !rawName.trim().isEmpty())
        {
            adminName = rawName.trim();
            adminInitial = String.valueOf(adminName.charAt(0)).toUpperCase();
        }
    %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Manage Teachers - Admin Dashboard</title>
            
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
                rel="stylesheet">

            <style>
                :root {
                    --primary-navy: #1E3A5F;
                    --primary-blue: #2563EB;
                    --primary-blue-hover: #1D4ED8;
                    --light-blue: #EFF6FF;
                    --bg-main: #F8FAFC;
                    --card-bg: #FFFFFF;
                    --text-main: #1E293B;
                    --text-muted: #64748B;
                    --border: #E2E8F0;
                    --sidebar-width: 275px;
                    --topbar-height: 70px;
                    --radius-sm: 8px;
                    --radius-md: 14px;
                    --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.04);
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
                    display: flex;
                    min-height: 100vh;
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
                }

                .brand-line1 {
                    font-size: 0.95rem;
                    font-weight: 800;
                    color: #FFFFFF;
                    line-height: 1.2;
                }

                .brand-line2 {
                    font-size: 0.85rem;
                    font-weight: 700;
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

                /* Main Content Wrapper */
                .main-wrapper {
                    margin-left: var(--sidebar-width);
                    flex: 1;
                    display: flex;
                    flex-direction: column;
                    min-height: 100vh;
                    width: calc(100% - var(--sidebar-width));
                }

                .top-navbar {
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

                .top-left {
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                }

                .menu-toggle-btn {
                    display: none;
                    background: none;
                    border: none;
                    cursor: pointer;
                    color: var(--primary-navy);
                    padding: 0.4rem;
                }

                .page-title {
                    font-size: 1.25rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                    letter-spacing: -0.02em;
                }

                .top-right {
                    display: flex;
                    align-items: center;
                    gap: 1.25rem;
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
                    text-align: left;
                    line-height: 1.15;
                }

                .user-name {
                    font-size: 0.875rem;
                    font-weight: 700;
                    color: var(--primary-navy);
                }

                .user-role-label {
                    font-size: 0.725rem;
                    font-weight: 600;
                    color: var(--text-muted);
                }

                .content-area {
                    padding: 2rem;
                    flex: 1;
                }

                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    display: flex;
                    flex-direction: column;
                    gap: 1.75rem;
                }

                .content-card {
                    background: var(--card-bg);
                    border-radius: var(--radius-md);
                    padding: 1.75rem;
                    border: 1px solid var(--border);
                    box-shadow: var(--shadow-sm);
                }

                .card-header-row {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    margin-bottom: 1.25rem;
                    padding-bottom: 1rem;
                    border-bottom: 1px solid var(--border);
                    flex-wrap: wrap;
                    gap: 1rem;
                }

                .card-header-row h3 {
                    font-size: 1.15rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                }

                /* Toolbar Search & Filter */
                .table-toolbar {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    gap: 1rem;
                    margin-bottom: 1.25rem;
                    flex-wrap: wrap;
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
                }

                /* Buttons */
                .btn {
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    gap: 0.5rem;
                    padding: 0.65rem 1.25rem;
                    border-radius: var(--radius-sm);
                    font-size: 0.875rem;
                    font-weight: 600;
                    border: none;
                    cursor: pointer;
                    transition: var(--transition);
                    font-family: inherit;
                }

                .btn-primary {
                    background: var(--primary-blue);
                    color: #FFFFFF;
                    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
                }

                .btn-primary:hover {
                    background: var(--primary-blue-hover);
                    transform: translateY(-1px);
                }

                .btn-outline {
                    background: transparent;
                    border: 1.5px solid var(--border);
                    color: var(--primary-navy);
                }

                .btn-outline:hover {
                    border-color: var(--primary-blue);
                    color: var(--primary-blue);
                    background: var(--light-blue);
                }

                .btn-danger {
                    background: #FEE2E2;
                    color: #DC2626;
                }

                .btn-danger:hover {
                    background: #DC2626;
                    color: #FFFFFF;
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

                .data-table {
                    width: 100%;
                    min-width: 1100px;
                    border-collapse: collapse;
                    text-align: left;
                    font-size: 0.925rem;
                    white-space: nowrap;
                }

                .data-table th {
                    background: var(--bg-main);
                    padding: 0.85rem 1rem;
                    font-weight: 700;
                    color: var(--text-muted);
                    text-transform: uppercase;
                    font-size: 0.775rem;
                    border-bottom: 1px solid var(--border);
                }

                .data-table td {
                    padding: 0.95rem 1rem;
                    border-bottom: 1px solid var(--border);
                    font-weight: 500;
                }

                .data-table tr:hover td {
                    background: var(--light-blue);
                }

                .badge {
                    display: inline-block;
                    padding: 0.25rem 0.65rem;
                    border-radius: 50px;
                    font-size: 0.75rem;
                    font-weight: 700;
                    text-transform: uppercase;
                }

                .badge-success {
                    background: #DCFCE7;
                    color: #15803D;
                }

                .badge-info {
                    background: #E0F2FE;
                    color: #0369A1;
                }

                /* Modal Overlay */
                .modal-backdrop {
                    display: none;
                    position: fixed;
                    inset: 0;
                    background: rgba(15, 23, 42, 0.6);
                    backdrop-filter: blur(4px);
                    z-index: 1100;
                    align-items: center;
                    justify-content: center;
                    padding: 1rem;
                }

                .modal-backdrop.open {
                    display: flex;
                }

                .modal-card {
                    background: #FFFFFF;
                    border-radius: var(--radius-md);
                    width: 100%;
                    max-width: 520px;
                    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
                    border: 1px solid var(--border);
                    overflow: hidden;
                }

                .modal-header {
                    padding: 1.25rem 1.5rem;
                    background: var(--bg-main);
                    border-bottom: 1px solid var(--border);
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                }

                .modal-header h4 {
                    font-size: 1.1rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                }

                .modal-close-btn {
                    background: none;
                    border: none;
                    font-size: 1.25rem;
                    cursor: pointer;
                    color: var(--text-muted);
                }

                .modal-body {
                    padding: 1.5rem;
                    display: flex;
                    flex-direction: column;
                    gap: 1rem;
                }

                .form-group label {
                    display: block;
                    font-size: 0.8rem;
                    font-weight: 700;
                    color: var(--text-main);
                    margin-bottom: 0.35rem;
                }

                .form-group input,
                .form-group select {
                    width: 100%;
                    padding: 0.7rem 0.9rem;
                    border: 1.5px solid var(--border);
                    border-radius: var(--radius-sm);
                    font-size: 0.9rem;
                    font-family: inherit;
                    outline: none;
                }

                .modal-footer {
                    padding: 1rem 1.5rem;
                    background: var(--bg-main);
                    border-top: 1px solid var(--border);
                    display: flex;
                    justify-content: flex-end;
                    gap: 0.75rem;
                }

                @media (max-width: 860px) {
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
                    <li class="nav-item active"><a href="teachers.jsp"><svg viewBox="0 0 24 24" fill="none"
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
                    <li class="nav-item"><a href="subjects.jsp"><svg viewBox="0 0 24 24" fill="none"
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
                <header class="top-navbar">
                    <div class="top-left">
                        <button class="menu-toggle-btn" id="menuToggleBtn" aria-label="Toggle menu">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <line x1="3" y1="12" x2="21" y2="12" />
                                <line x1="3" y1="6" x2="21" y2="6" />
                                <line x1="3" y1="18" x2="21" y2="18" />
                            </svg>
                        </button>
                        <h1 class="page-title">Teacher Management</h1>
                    </div>
                    <div class="top-right">
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
                    </div>
                </header>

                <main class="content-area">
                    <div class="container">

                        <%
                            if (request.getParameter("success") != null)
                            {
                        %>
                            <div id="alertBanner"
                                style="background-color: #DCFCE7; color: #15803D; padding: 0.85rem 1.25rem; border-radius: 10px; margin-bottom: 1.5rem; font-weight: 700; border: 1px solid #BBF7D0; display: flex; align-items: center; gap: 0.5rem; transition: opacity 0.5s ease, transform 0.5s ease;">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2.5">
                                    <polyline points="20 6 9 17 4 12" />
                                </svg>
                                <span>
                                    <%= request.getParameter("success") %>
                                </span>
                            </div>
                            <%
                                }
                            %>
                                <%
                                    if (request.getParameter("error") != null)
                                    {
                                %>
                                    <div id="alertBanner"
                                        style="background-color: #FEE2E2; color: #DC2626; padding: 0.85rem 1.25rem; border-radius: 10px; margin-bottom: 1.5rem; font-weight: 700; border: 1px solid #FCA5A5; display: flex; align-items: center; gap: 0.5rem; transition: opacity 0.5s ease, transform 0.5s ease;">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <circle cx="12" cy="12" r="10" />
                                            <line x1="12" y1="8" x2="12" y2="12" />
                                            <line x1="12" y1="16" x2="12.01" y2="16" />
                                        </svg>
                                        <span>
                                            <%= request.getParameter("error") %>
                                        </span>
                                    </div>
                                    <%
                                        }
                                    %>

                                        <div class="content-card">
                                            <div class="card-header-row">
                                                <div>
                                                    <h3>Teacher Records</h3>
                                                    <p style="font-size: 0.85rem; color: var(--text-muted);">Overview of
                                                        academic staff,
                                                        department allocations, and designations.</p>
                                                </div>
                                                <button class="btn btn-primary" onclick="openTeacherModal('add')">
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <line x1="12" y1="5" x2="12" y2="19" />
                                                        <line x1="5" y1="12" x2="19" y2="12" />
                                                    </svg>
                                                    <span>Add Teacher</span>
                                                </button>
                                            </div>

                                            <!-- Search & Filter Toolbar -->
                                            <div class="table-toolbar">
                                                <div class="search-box">
                                                    <svg class="search-icon" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <circle cx="11" cy="11" r="8" />
                                                        <line x1="21" y1="21" x2="16.65" y2="16.65" />
                                                    </svg>
                                                    <input type="text" id="searchInput"
                                                        placeholder="Search teacher name, email, or department..."
                                                        onkeyup="filterTable()">
                                                </div>
                                                <select class="filter-select" id="courseFilter"
                                                    onchange="filterTable()">
                                                    <option value="">All Courses</option>
                                                    <option value="Diploma">Diploma</option>
                                                    <option value="BTech">BTech</option>
                                                    <option value="BE">BE</option>
                                                    <option value="BSc">BSc</option>
                                                    <option value="BCA">BCA</option>
                                                    <option value="BCS">BCS</option>
                                                    <option value="MSc">MSc</option>
                                                    <option value="MCA">MCA</option>
                                                    <option value="MBA">MBA</option>
                                                    <option value="MTech">MTech</option>
                                                    <option value="ME">ME</option>
                                                    <option value="MCom">MCom</option>
                                                    <option value="MA">MA</option>
                                                    <option value="PhD">PhD</option>
                                                </select>
                                                <select class="filter-select" id="deptFilter" onchange="filterTable()">
                                                    <option value="">All Departments</option>
                                                    <option value="Computer Engineering">Computer Engineering</option>
                                                    <option value="Information Technology">Information Technology
                                                    </option>
                                                    <option value="Mechanical Engineering">Mechanical Engineering
                                                    </option>
                                                    <option value="Civil Engineering">Civil Engineering</option>
                                                    <option value="Electronics Engineering">Electronics Engineering
                                                    </option>
                                                </select>
                                            </div>

                                            <div class="table-responsive">
                                                <table class="data-table" id="teachersTable">
                                                    <thead>
                                                        <tr>
                                                            <th>Sr. No.</th>
                                                            <th>Full Name</th>
                                                            <th>Gender</th>
                                                            <th>Username</th>
                                                            <th>Email</th>
                                                            <th>Phone</th>
                                                            <th>Course</th>
                                                            <th>Department</th>
                                                            <th>Assigned Subjects</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="teachersTableBody">
                                                        <!-- Dynamic rows rendered by JS -->
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                    </div>
                </main>
            </div>

            <!-- View Teacher Modal -->
            <div class="modal-backdrop" id="viewTeacherModal">
                <div class="modal-card" style="max-width: 540px;">
                    <div class="modal-header">
                        <h4>Faculty Profile & Subject Details</h4>
                        <button type="button" class="modal-close-btn"
                            onclick="closeModal('viewTeacherModal')">&times;</button>
                    </div>
                    <div class="modal-body" id="viewTeacherModalBody">
                        <!-- Populated by JS -->
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary"
                            onclick="closeModal('viewTeacherModal')">Close</button>
                    </div>
                </div>
            </div>

            <!-- Add/Edit Teacher Modal -->
            <div class="modal-backdrop" id="teacherModal">
                <div class="modal-card" style="max-width: 540px;">
                    <div class="modal-header">
                        <h4 id="teacherModalTitle">Add New Faculty Member</h4>
                        <button type="button" class="modal-close-btn"
                            onclick="closeModal('teacherModal')">&times;</button>
                    </div>
                    <form onsubmit="saveTeacherForm(event)" id="adminTeacherForm">
                        <input type="hidden" id="mTeacherId">
                        <div class="modal-body" style="max-height: 70vh; overflow-y: auto;">
                            <div class="form-group" style="grid-column: span 2;">
                                <label>Gender *</label>
                                <div style="display: flex; gap: 1.5rem; align-items: center; padding: 0.35rem 0;">
                                    <label
                                        style="display: flex; align-items: center; gap: 0.4rem; cursor: pointer; font-size: 0.875rem; font-weight: 500;">
                                        <input type="radio" name="mTeacherGender" value="Male" checked> Male
                                    </label>
                                    <label
                                        style="display: flex; align-items: center; gap: 0.4rem; cursor: pointer; font-size: 0.875rem; font-weight: 500;">
                                        <input type="radio" name="mTeacherGender" value="Female"> Female
                                    </label>
                                    <label
                                        style="display: flex; align-items: center; gap: 0.4rem; cursor: pointer; font-size: 0.875rem; font-weight: 500;">
                                        <input type="radio" name="mTeacherGender" value="Other"> Other
                                    </label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Full Name</label>
                                <input type="text" id="mTeacherFullName" placeholder="Enter full name" required>
                            </div>
                            <div class="form-group">
                                <label>Username</label>
                                <input type="text" id="mTeacherUsername" placeholder="Enter username" required>
                            </div>
                            <div class="form-group">
                                <label>Email Address</label>
                                <input type="email" id="mTeacherEmail" placeholder="Enter email address" required>
                            </div>
                            <div class="form-group">
                                <label>Phone</label>
                                <input type="tel" id="mTeacherPhone" placeholder="Enter phone number">
                            </div>
                            <div class="form-group">
                                <label>Course</label>
                                <select id="mTeacherCourse" required>
                                    <option value="BTech">BTech</option>
                                    <option value="Diploma">Diploma</option>
                                    <option value="BE">BE</option>
                                    <option value="BSc">BSc</option>
                                    <option value="BCA">BCA</option>
                                    <option value="BCS">BCS</option>
                                    <option value="MSc">MSc</option>
                                    <option value="MCA">MCA</option>
                                    <option value="MBA">MBA</option>
                                    <option value="MTech">MTech</option>
                                    <option value="ME">ME</option>
                                    <option value="MCom">MCom</option>
                                    <option value="MA">MA</option>
                                    <option value="PhD">PhD</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Department</label>
                                <select id="mTeacherDept" required>
                                    <option value="Computer Engineering">Computer Engineering</option>
                                    <option value="Information Technology">Information Technology</option>
                                    <option value="Mechanical Engineering">Mechanical Engineering</option>
                                    <option value="Civil Engineering">Civil Engineering</option>
                                    <option value="Electronics Engineering">Electronics Engineering</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline"
                                onclick="closeModal('teacherModal')">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save Faculty</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Subject Assignment Workflow Modal -->
            <div class="modal-backdrop" id="assignSubjectModal">
                <div class="modal-card" style="max-width: 750px;">
                    <div class="modal-header">
                        <h4>Assigned Subjects & Subject Allocation</h4>
                        <button type="button" class="modal-close-btn"
                            onclick="closeModal('assignSubjectModal')">&times;</button>
                    </div>
                    <div class="modal-body"
                        style="max-height: 75vh; overflow-y: auto; display: flex; flex-direction: column; gap: 1.25rem;">
                        <!-- Teacher Info Banner -->
                        <div style="background: var(--light-blue); padding: 1rem 1.25rem; border-radius: var(--radius-sm); border: 1px solid #BFDBFE; display: flex; align-items: center; justify-content: space-between;"
                            id="assignTeacherBanner">
                            <!-- Populated dynamically -->
                        </div>

                        <!-- Assigned Subjects List Table -->
                        <div>
                            <div
                                style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 0.75rem;">
                                <h5
                                    style="font-size: 0.925rem; font-weight: 700; color: var(--primary-navy); margin: 0;">
                                    Currently Assigned Subjects
                                </h5>
                                <span id="assignedSubjectCountBadge" class="badge badge-info"
                                    style="font-size: 0.8rem;">0 Subjects</span>
                            </div>
                            <div class="table-responsive">
                                <table class="data-table" style="min-width: 550px;">
                                    <thead>
                                        <tr>
                                            <th>Subject Name</th>
                                            <th>Course</th>
                                            <th>Department</th>
                                            <th>Semester</th>
                                            <th>Students</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody id="assignedSubjectsTableBody">
                                        <!-- Assigned subjects rows -->
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Assign New Subject Box -->
                        <div
                            style="background: var(--bg-main); padding: 1.25rem; border-radius: var(--radius-sm); border: 1px solid var(--border);">
                            <h5
                                style="font-size: 0.9rem; font-weight: 700; color: var(--primary-navy); margin-bottom: 0.75rem;">
                                Assign New Subject to Faculty Member
                            </h5>
                            <div style="display: flex; gap: 0.75rem; align-items: center;">
                                <select id="mAssignSubjectSelect" class="form-control"
                                    style="flex: 1; padding: 0.6rem 0.8rem; border-radius: var(--radius-sm); border: 1px solid var(--border); background: #FFFFFF; font-size: 0.875rem;">
                                    <!-- Options populated dynamically -->
                                </select>
                                <button type="button" class="btn btn-primary"
                                    style="white-space: nowrap; padding: 0.6rem 1.25rem;"
                                    onclick="confirmAssignSelectedSubject()">+ Assign Subject</button>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline"
                            onclick="closeModal('assignSubjectModal')">Close</button>
                    </div>
                </div>
            </div>

            <!-- Manage Students Allocation Modal -->
            <div class="modal-backdrop" id="manageStudentsModal">
                <div class="modal-card" style="max-width: 950px;">
                    <div class="modal-header">
                        <h4 id="manageStudentsTitle">Allocate Students to Subject</h4>
                        <button type="button" class="modal-close-btn"
                            onclick="closeModal('manageStudentsModal')">&times;</button>
                    </div>
                    <div class="modal-body" style="max-height: 75vh; overflow-y: auto;">
                        <div
                            style="background: var(--light-blue); color: var(--primary-navy); padding: 0.85rem 1rem; border-radius: var(--radius-sm); font-size: 0.85rem; font-weight: 600; border: 1px solid #BFDBFE; margin-bottom: 1rem; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 0.75rem;">
                            <div id="manageStudentsSubjectInfo">
                                <!-- Info banner -->
                            </div>
                            <div style="display: flex; align-items: center; gap: 0.5rem;">
                                <label
                                    style="font-size: 0.8rem; font-weight: 700; color: var(--primary-navy); margin: 0; white-space: nowrap;">Year
                                    Filter:</label>
                                <select id="manageStudentsYearFilter" onchange="filterEligibleStudentsByYear()"
                                    class="form-control"
                                    style="padding: 0.35rem 0.6rem; font-size: 0.8rem; border-radius: 6px; width: 140px; background: #FFF;">
                                    <option value="ALL">All Years</option>
                                    <option value="First Year">First Year</option>
                                    <option value="Second Year">Second Year</option>
                                    <option value="Third Year">Third Year</option>
                                    <option value="Fourth Year">Fourth Year</option>
                                </select>
                            </div>
                        </div>

                        <div
                            style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.75rem;">
                            <label
                                style="display: flex; align-items: center; gap: 0.5rem; font-size: 0.875rem; font-weight: 700; cursor: pointer;">
                                <input type="checkbox" id="selectAllStudentsCb"
                                    onchange="toggleSelectAllStudents(this.checked)"> Select All Eligible Students
                            </label>
                            <span id="selectedStudentCounter" class="badge badge-info"
                                style="font-size:0.8rem;">Selected: 0 Students</span>
                        </div>

                        <div class="table-responsive" style="max-height: 300px; overflow-y: auto;">
                            <table class="data-table" style="min-width: 850px;">
                                <thead>
                                    <tr>
                                        <th style="width: 40px;">Select</th>
                                        <th>Roll No</th>
                                        <th>Student Name</th>
                                        <th>Username</th>
                                        <th>Email</th>
                                        <th>Course</th>
                                        <th>Department</th>
                                        <th>Semester</th>
                                        <th>Year</th>
                                    </tr>
                                </thead>
                                <tbody id="allocateStudentsTableBody">
                                    <!-- Eligible student rows with checkboxes -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline"
                            onclick="closeModal('manageStudentsModal')">Cancel</button>
                        <button type="button" class="btn btn-primary" onclick="saveStudentAllocation()">Assign Selected
                            Students</button>
                    </div>
                </div>
            </div>

            <!-- Delete Modal -->
            <div class="modal-backdrop" id="deleteModal">
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
                            <h4 style="color:#991B1B; margin:0; font-size:1.05rem; font-weight:800;">Confirm Faculty
                                Deletion</h4>
                        </div>
                        <button class="modal-close-btn" onclick="closeModal('deleteModal')"
                            style="color:#991B1B;">&times;</button>
                    </div>
                    <div class="modal-body" style="padding: 1.5rem; text-align: center;">
                        <p style="font-size: 0.95rem; color: #1E293B; margin-bottom: 0.75rem; line-height: 1.5;"
                            id="deleteModalText">
                            Are you sure you want to remove faculty <strong id="deleteTeacherName"
                                style="color:#DC2626; font-weight:800;">this faculty</strong>?
                        </p>
                        <div
                            style="background:#FFF5F5; border:1px solid #FECDD3; border-radius:8px; padding:0.65rem 0.85rem; font-size:0.8rem; color:#9F1239; display:flex; align-items:center; justify-content:center; gap:0.4rem;">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <circle cx="12" cy="12" r="10" />
                                <line x1="12" y1="8" x2="12" y2="12" />
                                <line x1="12" y1="16" x2="12.01" y2="16" />
                            </svg>
                            <span>This action is permanent and cannot be undone.</span>
                        </div>
                    </div>
                    <div class="modal-footer"
                        style="justify-content: flex-end; gap:0.75rem; background:#F8FAFC; border-top:1px solid #E2E8F0; padding:0.85rem 1.25rem;">
                        <button class="btn btn-outline" style="padding:0.55rem 1.15rem; font-weight:700;"
                            onclick="closeModal('deleteModal')">Cancel</button>
                        <button class="btn"
                            style="padding:0.55rem 1.25rem; font-weight:800; background:#FEE2E2; color:#991B1B; border:1.5px solid #FCA5A5; border-radius:8px; cursor:pointer; font-size:0.875rem; transition:all 0.2s;"
                            onclick="confirmDeleteModal()"
                            onmouseover="this.style.background='#DC2626'; this.style.color='#FFFFFF';"
                            onmouseout="this.style.background='#FEE2E2'; this.style.color='#991B1B';">Yes,
                            Delete</button>
                    </div>
                </div>
            </div>

            <!-- Delete Subject Assignment Confirmation Modal -->
            <div class="modal-backdrop" id="deleteSubjectAssignmentModal">
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
                            <h4 style="color:#991B1B; margin:0; font-size:1.05rem; font-weight:800;">Confirm Assignment
                                Deletion</h4>
                        </div>
                        <button class="modal-close-btn" onclick="closeModal('deleteSubjectAssignmentModal')"
                            style="color:#991B1B;">&times;</button>
                    </div>
                    <div class="modal-body" style="padding: 1.5rem; text-align: center;">
                        <p style="font-size: 0.95rem; color: #1E293B; margin-bottom: 0.75rem; line-height: 1.5;"
                            id="deleteSubjectAssignmentModalText">
                            Are you sure you want to delete subject <span style="color:#DC2626; font-weight:700;"
                                id="deleteSubjectAssignmentName">"this subject"</span>?
                        </p>
                        <div
                            style="background:#FFF5F5; border:1px solid #FECDD3; border-radius:8px; padding:0.65rem 0.85rem; font-size:0.8rem; color:#9F1239; display:flex; align-items:center; justify-content:center; gap:0.4rem;">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <circle cx="12" cy="12" r="10" />
                                <line x1="12" y1="8" x2="12" y2="12" />
                                <line x1="12" y1="16" x2="12.01" y2="16" />
                            </svg>
                            <span>This action is permanent and cannot be undone.</span>
                        </div>
                    </div>
                    <div class="modal-footer"
                        style="justify-content: flex-end; gap:0.75rem; background:#F8FAFC; border-top:1px solid #E2E8F0; padding:0.85rem 1.25rem;">
                        <button type="button" class="btn btn-outline" style="padding:0.55rem 1.15rem; font-weight:700;"
                            onclick="closeModal('deleteSubjectAssignmentModal')">Cancel</button>
                        <button type="button" class="btn"
                            style="padding:0.55rem 1.25rem; font-weight:800; background:#FEE2E2; color:#991B1B; border:1.5px solid #FCA5A5; border-radius:8px; cursor:pointer; font-size:0.875rem; transition:all 0.2s;"
                            onclick="executeRemoveAssignedSubject()"
                            onmouseover="this.style.background='#DC2626'; this.style.color='#FFFFFF';"
                            onmouseout="this.style.background='#FEE2E2'; this.style.color='#991B1B';">Yes,
                            Delete</button>
                    </div>
                </div>
            </div>

            <script>
                const menuToggleBtn = document.getElementById('menuToggleBtn');
                const sidebar = document.getElementById('sidebar');
                const sidebarOverlay = document.getElementById('sidebarOverlay');

                function toggleSidebar() {
                    sidebar.classList.toggle('open');
                    sidebarOverlay.classList.toggle('active');
                }

                if (menuToggleBtn) menuToggleBtn.addEventListener('click', toggleSidebar);
                if (sidebarOverlay) sidebarOverlay.addEventListener('click', toggleSidebar);

                // Demo Faculty Data
                let teachersData = [];
                let dbSubjects = [];
                let candidateStudents = [];

                function fetchTeachersFromDB() {
                    Promise.all([
                        fetch('${pageContext.request.contextPath}/api/admin/teachers').then(res => res.json()).catch(() => []),
                        fetch('${pageContext.request.contextPath}/api/admin/teacher-subjects').then(res => res.json()).catch(() => []),
                        fetch('${pageContext.request.contextPath}/api/admin/subjects').then(res => res.json()).catch(() => []),
                        fetch('${pageContext.request.contextPath}/api/admin/students').then(res => res.json()).catch(() => [])
                    ]).then(([teachers, assignments, subjects, students]) => {
                        teachersData = teachers || [];
                        const assignList = assignments || [];
                        dbSubjects = subjects || [];
                        if (students && students.length > 0) {
                            candidateStudents = students.map(st => ({
                                id: st.id,
                                rollNo: st.rollNo || st.prn || st.username || ('STU' + st.id),
                                name: st.name || st.fullName || 'Student',
                                username: st.username || '',
                                email: st.email || '',
                                course: st.course || 'BTech',
                                dept: st.dept || st.department || 'Computer Engineering',
                                sem: st.sem || st.semester || 'Semester 5',
                                year: st.year || 'Third Year'
                            }));
                        }

                        // Map DB assignments to each teacher
                        teachersData.forEach(t => {
                            const tAssigns = assignList.filter(a => String(a.teacherId) === String(t.id) || a.teacherUsername === t.username);
                            t.assignedSubjects = tAssigns.map(a => ({
                                id: a.id,
                                subjectId: a.subjectId,
                                code: a.subjectCode,
                                name: a.subjectName,
                                course: a.course || t.course || 'BTech',
                                dept: a.department || t.dept || 'Computer Engineering',
                                sem: String(a.semester || '').toLowerCase().includes('semester') ? a.semester : ('Semester ' + (a.semester || 5)),
                                year: a.year || 'Third Year',
                                studentCount: a.studentCount || 0
                            }));
                        });

                        filterTable();
                    }).catch(err => {
                        console.error("Failed to load teachers/assignments from DB:", err);
                        teachersData = [];
                        filterTable();
                    });
                }

                let activeAssignTeacherId = null;
                let activeManagingSubjectCode = null;
                let targetDeleteTeacherId = null;

                function formatGender(g) {
                    return g ? String(g).trim() : 'Male';
                }

                function renderTeachersTable(data = teachersData) {
                    const tbody = document.getElementById('teachersTableBody');
                    if (!tbody) return;
                    tbody.innerHTML = '';

                    if (!data || data.length === 0) {
                        tbody.innerHTML = '<tr><td colspan="9" style="text-align:center; padding: 2rem; color: var(--text-muted);">No faculty records found.</td></tr>';
                        return;
                    }

                    data.forEach((t, index) => {
                        const tr = document.createElement('tr');
                        const assignedList = t.assignedSubjects || [];
                        const subjectBadgeCount = assignedList.length;
                        const subjectBadge = '<span class="badge ' + (subjectBadgeCount > 0 ? 'badge-success' : 'badge-info') + '">' + subjectBadgeCount + ' Assigned</span>';

                        tr.innerHTML =
                            '<td style="font-weight:700; color: var(--primary-navy);">' + (index + 1) + '</td>' +
                            '<td><strong>' + (t.name || '--') + '</strong></td>' +
                            '<td><span class="badge" style="background:#F1F5F9; color:#334155; font-weight:700;">' + formatGender(t.gender) + '</span></td>' +
                            '<td>' + (t.username || '--') + '</td>' +
                            '<td>' + (t.email || '--') + '</td>' +
                            '<td>' + (t.phone || '--') + '</td>' +
                            '<td><span class="badge badge-success">' + (t.course || 'BTech') + '</span></td>' +
                            '<td>' + (t.dept || '--') + '</td>' +
                            '<td>' + subjectBadge + '</td>' +
                            '<td>' +
                            '<div style="display:flex; gap:0.35rem;">' +
                            '<button class="btn btn-outline" style="padding:0.3rem 0.5rem; font-size:0.75rem; color: var(--primary-blue);" onclick="openTeacherModal(\'edit\', ' + t.id + ')">Edit</button>' +
                            '<button class="btn btn-primary" style="padding:0.3rem 0.5rem; font-size:0.75rem;" onclick="openAssignSubjectModal(' + t.id + ')">Assign Subjects</button>' +
                            '<button class="btn btn-danger" style="padding:0.3rem 0.5rem; font-size:0.75rem;" onclick="openDeleteTeacherModal(' + t.id + ')">Delete</button>' +
                            '</div>' +
                            '</td>';
                        tbody.appendChild(tr);
                    });
                }

                function filterTable() {
                    const query = document.getElementById('searchInput').value.toLowerCase();
                    const course = document.getElementById('courseFilter') ? document.getElementById('courseFilter').value.toLowerCase() : '';
                    const dept = document.getElementById('deptFilter').value.toLowerCase();

                    const filtered = teachersData.filter(t => {
                        const matchText = (t.name || '').toLowerCase().includes(query) ||
                            (t.username || '').toLowerCase().includes(query) ||
                            (t.email || '').toLowerCase().includes(query);
                        const matchCourse = !course || (t.course && t.course.toLowerCase() === course);
                        const matchDept = !dept || (t.dept && t.dept.toLowerCase() === dept);
                        return matchText && matchCourse && matchDept;
                    });

                    renderTeachersTable(filtered);
                }

                function openModal(id) {
                    const el = document.getElementById(id);
                    if (el) el.classList.add('open');
                }
                function closeModal(id) {
                    const el = document.getElementById(id);
                    if (el) el.classList.remove('open');
                }

                function viewTeacherModal(id) {
                    const t = teachersData.find(teacher => teacher.id === id);
                    if (!t) return;

                    const assignedList = t.assignedSubjects || [];
                    const subjectsListHtml = assignedList.length > 0
                        ? assignedList.map(s => '<li style="padding:0.35rem 0; border-bottom:1px dashed var(--border); font-size:0.85rem;"><strong>' + s.name + '</strong> (' + s.code + ') - ' + s.course + ' | ' + s.sem + ' (' + s.studentCount + ' Students)</li>').join('')
                        : '<span style="color:var(--text-muted); font-size:0.85rem;">No subjects currently assigned.</span>';

                    const body = document.getElementById('viewTeacherModalBody');
                    body.innerHTML =
                        '<div style="text-align:center; padding-bottom: 0.5rem; border-bottom: 1px solid var(--border);">' +
                        '<div style="width:50px; height:50px; border-radius:50%; background: var(--primary-navy); color:#fff; display:flex; align-items:center; justify-content:center; font-weight:800; font-size:1.2rem; margin:0 auto 0.5rem;">' + (t.name ? t.name.charAt(0) : 'T') + '</div>' +
                        '<h3 style="color: var(--primary-navy); font-weight:800;">' + (t.name || 'N/A') + '</h3>' +
                        '<p style="color: var(--primary-blue); font-size:0.85rem; font-weight:700;">' + (t.dept || '--') + '</p>' +
                        '</div>' +
                        '<div style="display:grid; grid-template-columns: 1fr 1fr; gap:0.75rem; font-size:0.875rem; margin-top:0.75rem;">' +
                        '<div><strong>Faculty ID:</strong> ' + t.id + '</div>' +
                        '<div><strong>Gender:</strong> ' + formatGender(t.gender) + '</div>' +
                        '<div><strong>Username:</strong> ' + (t.username || '--') + '</div>' +
                        '<div><strong>Email:</strong> ' + (t.email || '--') + '</div>' +
                        '<div><strong>Phone:</strong> ' + (t.phone || '--') + '</div>' +
                        '<div><strong>Course:</strong> ' + (t.course || 'BTech') + '</div>' +
                        '<div><strong>Department:</strong> ' + (t.dept || '--') + '</div>' +
                        '</div>' +
                        '<div style="margin-top:1rem;">' +
                        '<h5 style="font-size:0.9rem; font-weight:700; color:var(--primary-navy); margin-bottom:0.5rem;">Assigned Subjects:</h5>' +
                        '<ul style="padding-left:0.5rem;">' + subjectsListHtml + '</ul>' +
                        '</div>';
                    openModal('viewTeacherModal');
                }

                function openTeacherModal(mode, id = null) {
                    const titleEl = document.getElementById('teacherModalTitle');
                    const form = document.getElementById('adminTeacherForm');

                    if (mode === 'add') {
                        titleEl.innerText = 'Add New Faculty Member';
                        document.getElementById('mTeacherId').value = '';
                        form.reset();
                        const maleRadio = document.querySelector('input[name="mTeacherGender"][value="Male"]');
                        if (maleRadio) maleRadio.checked = true;
                    } else {
                        titleEl.innerText = 'Edit Faculty Member Details';
                        const t = teachersData.find(teacher => teacher.id === id);
                        if (t) {
                            document.getElementById('mTeacherId').value = t.id;
                            document.getElementById('mTeacherFullName').value = t.name || '';
                            document.getElementById('mTeacherUsername').value = t.username || '';
                            document.getElementById('mTeacherEmail').value = t.email || '';
                            document.getElementById('mTeacherPhone').value = t.phone || '';
                            if (document.getElementById('mTeacherCourse')) document.getElementById('mTeacherCourse').value = t.course || 'BTech';
                            document.getElementById('mTeacherDept').value = t.dept || 'Computer Engineering';

                            const gFormatted = formatGender(t.gender);
                            const gRadio = document.querySelector('input[name="mTeacherGender"][value="' + gFormatted + '"]');
                            if (gRadio) gRadio.checked = true;
                        }
                    }
                    openModal('teacherModal');
                }

                function saveTeacherForm(e) {
                    e.preventDefault();
                    const idVal = document.getElementById('mTeacherId').value;
                    const name = document.getElementById('mTeacherFullName').value;
                    const username = document.getElementById('mTeacherUsername').value;
                    const email = document.getElementById('mTeacherEmail').value;
                    const phone = document.getElementById('mTeacherPhone').value;
                    const course = document.getElementById('mTeacherCourse') ? document.getElementById('mTeacherCourse').value : 'BTech';
                    const dept = document.getElementById('mTeacherDept').value;
                    const genderRadio = document.querySelector('input[name="mTeacherGender"]:checked');
                    const gender = genderRadio ? genderRadio.value : 'Male';

                    const formData = new URLSearchParams();
                    if (idVal) {
                        formData.append('action', 'edit');
                        formData.append('id', idVal);
                    } else {
                        formData.append('action', 'add');
                    }
                    formData.append('name', name);
                    formData.append('gender', gender);
                    formData.append('username', username);
                    formData.append('email', email);
                    formData.append('phone', phone);
                    formData.append('course', course);
                    formData.append('dept', dept);

                    fetch('${pageContext.request.contextPath}/api/admin/teachers', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: formData.toString()
                    })
                        .then(res => res.json())
                        .then(res => {
                            closeModal('teacherModal');
                            fetchTeachersFromDB();
                        })
                        .catch(err => {
                            console.error('Save teacher failed:', err);
                            closeModal('teacherModal');
                            fetchTeachersFromDB();
                        });
                }

                function openAssignSubjectModal(teacherId) {
                    activeAssignTeacherId = teacherId;
                    const t = teachersData.find(teacher => teacher.id == teacherId);
                    if (!t) return;

                    if (!t.assignedSubjects) t.assignedSubjects = [];
                    const tDept = (t.dept || t.department || 'Computer Engineering').trim().toLowerCase();

                    // Update Banner
                    const banner = document.getElementById('assignTeacherBanner');
                    if (banner) {
                        banner.innerHTML =
                            '<div>' +
                            '<div style="font-weight:800; color:var(--primary-navy); font-size:1.05rem;">' + (t.name || 'Faculty') + '</div>' +
                            '<div style="font-size:0.85rem; color:var(--text-muted); font-weight:600;">Department: <strong style="color:var(--text-main);">' + (t.dept || t.department || 'Computer Engineering') + '</strong></div>' +
                            '</div>';
                    }

                    // Render Available Subjects Select Dropdown dynamically from dbSubjects
                    const assignedCodes = t.assignedSubjects.map(s => (s.code || s.subjectCode || '').toLowerCase());
                    const assignedIds = t.assignedSubjects.map(s => String(s.subjectId || s.id));

                    const availableList = dbSubjects.filter(s => {
                        const sDept = (s.department || s.dept || '').trim().toLowerCase();
                        const matchesDept = !tDept || sDept === tDept;
                        const sCode = (s.subjectCode || s.code || '').toLowerCase();
                        const sId = String(s.id);
                        const notAssigned = !assignedCodes.includes(sCode) && !assignedIds.includes(sId);
                        return matchesDept && notAssigned;
                    });

                    const selectEl = document.getElementById('mAssignSubjectSelect');

                    if (selectEl) {
                        selectEl.innerHTML = '';
                        if (availableList.length === 0) {
                            selectEl.innerHTML = '<option value="">All department subjects are currently assigned</option>';
                            selectEl.disabled = true;
                        } else {
                            selectEl.disabled = false;
                            selectEl.innerHTML = '<option value="">-- Select Subject to Assign --</option>';
                            availableList.forEach(s => {
                                const sName = s.subjectName || s.name || '';
                                const sCode = s.subjectCode || s.code || '';
                                const semVal = s.semester || s.sem || 'Semester 5';
                                const semDisplay = String(semVal).toLowerCase().includes('semester') ? semVal : ('Semester ' + semVal);
                                selectEl.innerHTML += '<option value="' + s.id + '">' + sName + ' (' + sCode + ') - ' + semDisplay + '</option>';
                            });
                        }
                    }

                    // Update Count Badge
                    const badgeEl = document.getElementById('assignedSubjectCountBadge');
                    if (badgeEl) {
                        badgeEl.innerText = t.assignedSubjects.length + ' Subject' + (t.assignedSubjects.length === 1 ? '' : 's');
                    }

                    // Render Assigned Subjects Table
                    renderAssignedSubjectsTable(t);
                    openModal('assignSubjectModal');
                }

                let pendingDeleteAssignedSubject = null;

                function escapeJsString(str) {
                    if (!str) return '';
                    return String(str).replace(/'/g, "\\'").replace(/"/g, '&quot;');
                }

                function renderAssignedSubjectsTable(teacher) {
                    const tbody = document.getElementById('assignedSubjectsTableBody');
                    if (!tbody) return;
                    tbody.innerHTML = '';

                    if (!teacher.assignedSubjects || teacher.assignedSubjects.length === 0) {
                        tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; padding:1.25rem; color:var(--text-muted); font-size:0.85rem;">No subjects currently assigned to this teacher.</td></tr>';
                        return;
                    }

                    teacher.assignedSubjects.forEach(s => {
                        const tr = document.createElement('tr');
                        tr.innerHTML =
                            '<td><strong>' + s.name + '</strong> <span style="font-size:0.8rem; color:var(--text-muted);">(' + s.code + ')</span></td>' +
                            '<td>' + s.course + '</td>' +
                            '<td>' + s.dept + '</td>' +
                            '<td>' + s.sem + '</td>' +
                            '<td><span class="badge badge-success">' + s.studentCount + ' Students</span></td>' +
                            '<td>' +
                            '<div style="display:flex; gap:0.35rem;">' +
                            '<button class="btn btn-outline" style="padding:0.25rem 0.5rem; font-size:0.75rem; color:var(--primary-blue);" onclick="openManageStudentsModal(\'' + s.code + '\')">Manage Students</button>' +
                            '<button class="btn btn-danger" style="padding:0.25rem 0.5rem; font-size:0.75rem;" onclick="removeAssignedSubject(\'' + (s.id || s.code) + '\', \'' + escapeJsString(s.name) + '\')">Remove</button>' +
                            '</div>' +
                            '</td>';
                        tbody.appendChild(tr);
                    });
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

                function confirmAssignSelectedSubject() {
                    const t = teachersData.find(teacher => teacher.id == activeAssignTeacherId);
                    if (!t) return;

                    const selectEl = document.getElementById('mAssignSubjectSelect');
                    if (!selectEl || !selectEl.value) {
                        showToast('Please select a subject to assign.', 'error');
                        return;
                    }

                    const selectedSubjectId = selectEl.value;
                    const subjectObj = dbSubjects.find(s => String(s.id) === String(selectedSubjectId));
                    if (!subjectObj) return;

                    const params = new URLSearchParams();
                    params.append('action', 'assign');
                    params.append('teacherId', t.id);
                    params.append('subjectId', subjectObj.id);

                    fetch('${pageContext.request.contextPath}/api/admin/teacher-subjects', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: params.toString()
                    }).then(res => res.json()).then(data => {
                        showToast('Subject assigned to faculty member successfully!', 'success');
                        fetchTeachersFromDB();
                        setTimeout(() => openAssignSubjectModal(activeAssignTeacherId), 300);
                    }).catch(err => {
                        console.error("Assign subject failed:", err);
                        showToast('Subject assigned locally.', 'success');
                        fetchTeachersFromDB();
                    });
                }

                function removeAssignedSubject(subjectIdOrCode, subjectName) {
                    const t = teachersData.find(teacher => teacher.id == activeAssignTeacherId);
                    if (!t) return;
                    const sub = t.assignedSubjects ? t.assignedSubjects.find(s => s.id == subjectIdOrCode || s.code === subjectIdOrCode || s.name === subjectName) : null;
                    const sName = (sub && sub.name) ? sub.name : (subjectName || subjectIdOrCode);
                    const assignId = sub ? sub.id : null;

                    pendingDeleteAssignedSubject = {
                        teacherId: t.id,
                        assignId: assignId,
                        subjectCode: sub ? sub.code : subjectIdOrCode,
                        subjectName: sName
                    };

                    const nameEl = document.getElementById('deleteSubjectAssignmentName');
                    if (nameEl) {
                        nameEl.innerText = '"' + sName + '"';
                    }
                    openModal('deleteSubjectAssignmentModal');
                }

                async function executeRemoveAssignedSubject() {
                    if (!pendingDeleteAssignedSubject) return;
                    const { teacherId, assignId, subjectCode, subjectName } = pendingDeleteAssignedSubject;
                    closeModal('deleteSubjectAssignmentModal');

                    const params = new URLSearchParams();
                    params.append('action', 'delete');
                    if (assignId) {
                        params.append('id', assignId);
                    } else {
                        params.append('teacherId', teacherId);
                        params.append('subjectId', subjectCode);
                    }

                    try {
                        const res = await fetch('${pageContext.request.contextPath}/api/admin/teacher-subjects', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                            body: params.toString()
                        });
                        const data = await res.json();
                        showToast('Subject assignment removed successfully!', 'success');
                        await fetchTeachersFromDB();
                        if (activeAssignTeacherId) {
                            openAssignSubjectModal(activeAssignTeacherId);
                        }
                    } catch (err) {
                        console.error('Failed to delete assignment:', err);
                        showToast('Subject assignment removed.', 'success');
                        const t = teachersData.find(teacher => teacher.id == activeAssignTeacherId);
                        if (t && t.assignedSubjects) {
                            t.assignedSubjects = t.assignedSubjects.filter(s => s.id != assignId && s.code !== subjectCode);
                        }
                        if (activeAssignTeacherId) {
                            openAssignSubjectModal(activeAssignTeacherId);
                        }
                        filterTable();
                    }
                }

                function formatYearName(yVal, semVal) {
                    if (!yVal && !semVal) return 'Third Year';
                    const yStr = String(yVal || '').trim();
                    if (yStr === '1' || yStr === 'First Year') return 'First Year';
                    if (yStr === '2' || yStr === 'Second Year') return 'Second Year';
                    if (yStr === '3' || yStr === 'Third Year') return 'Third Year';
                    if (yStr === '4' || yStr === 'Fourth Year') return 'Fourth Year';
                    if (semVal) {
                        const s = parseInt(String(semVal).replace(/[^0-9]/g, '')) || 5;
                        if (s <= 2) return 'First Year';
                        if (s <= 4) return 'Second Year';
                        if (s <= 6) return 'Third Year';
                        return 'Fourth Year';
                    }
                    return 'Third Year';
                }

                async function openManageStudentsModal(subjectCode) {
                    activeManagingSubjectCode = subjectCode;
                    const t = teachersData.find(teacher => teacher.id == activeAssignTeacherId);
                    if (!t || !t.assignedSubjects) return;
                    const s = t.assignedSubjects.find(sub => sub.code === subjectCode || sub.name === subjectCode);
                    if (!s) return;

                    const formattedYear = formatYearName(s.year, s.sem);
                    document.getElementById('manageStudentsTitle').innerText = 'Allocate Students to ' + s.name;
                    document.getElementById('manageStudentsSubjectInfo').innerHTML =
                        'Subject: <strong>' + s.name + ' (' + s.code + ')</strong> | Course: <strong>' + s.course + '</strong> | Department: <strong>' + s.dept + '</strong> | ' + s.sem + ' | <strong>' + formattedYear + '</strong>';

                    const yearFilter = document.getElementById('manageStudentsYearFilter');
                    if (yearFilter) {
                        yearFilter.value = formattedYear;
                    }

                    let assignedStudentIds = [];
                    const subjObj = dbSubjects.find(sub => sub.subjectCode === s.code || sub.code === s.code || sub.name === s.name);
                    const subId = s.subjectId || (subjObj ? subjObj.id : null);
                    if (t.id && subId) {
                        try {
                            const res = await fetch('${pageContext.request.contextPath}/api/admin/student-subject-assignments?teacherId=' + t.id + '&subjectId=' + subId);
                            if (res.ok) {
                                const list = await res.json();
                                assignedStudentIds = list.map(item => item.studentId);
                            }
                        } catch (e) {
                            console.error('Failed to fetch assigned student IDs:', e);
                        }
                    }

                    renderEligibleStudentsList(s, formattedYear, assignedStudentIds);
                    openModal('manageStudentsModal');
                }

                function filterEligibleStudentsByYear() {
                    const t = teachersData.find(teacher => teacher.id == activeAssignTeacherId);
                    if (!t || !t.assignedSubjects) return;
                    const s = t.assignedSubjects.find(sub => sub.code === activeManagingSubjectCode || sub.name === activeManagingSubjectCode);
                    if (!s) return;

                    const yearVal = document.getElementById('manageStudentsYearFilter') ? document.getElementById('manageStudentsYearFilter').value : 'ALL';
                    renderEligibleStudentsList(s, yearVal, null);
                }

                function renderEligibleStudentsList(s, yearFilterVal, assignedStudentIds) {
                    const sSemNum = String(s.sem || '').replace(/[^0-9]/g, '');
                    const sDept = (s.dept || s.department || '').trim().toLowerCase();
                    let eligible = candidateStudents.filter(st => {
                        const courseMatch = !s.course || st.course === s.course;
                        const stDept = (st.dept || st.department || '').trim().toLowerCase();
                        const deptMatch = !sDept || !stDept || sDept === stDept || sDept.includes(stDept) || stDept.includes(sDept);
                        const stSemNum = String(st.sem || '').replace(/[^0-9]/g, '');
                        const semMatch = !s.sem || !st.sem || sSemNum === '' || stSemNum === '' || sSemNum === stSemNum;
                        return courseMatch && deptMatch && semMatch;
                    });

                    if (yearFilterVal && yearFilterVal !== 'ALL') {
                        eligible = eligible.filter(st => formatYearName(st.year, st.sem) === yearFilterVal);
                    }

                    const tbody = document.getElementById('allocateStudentsTableBody');
                    if (!tbody) return;
                    tbody.innerHTML = '';

                    if (eligible.length === 0) {
                        tbody.innerHTML = '<tr><td colspan="9" style="text-align:center; padding:1.25rem; color:var(--text-muted);">No eligible students found matching the selected filters.</td></tr>';
                        document.getElementById('selectAllStudentsCb').checked = false;
                        updateSelectedCount();
                        return;
                    }

                    eligible.forEach(st => {
                        const tr = document.createElement('tr');
                        const yearDisplay = formatYearName(st.year, st.sem);
                        const semText = String(st.sem).toLowerCase().includes('semester') ? st.sem : ('Semester ' + st.sem);
                        const isChecked = (assignedStudentIds && Array.isArray(assignedStudentIds)) ? assignedStudentIds.includes(st.id) : true;
                        tr.innerHTML =
                            '<td><input type="checkbox" class="student-alloc-cb" value="' + (st.id || st.rollNo) + '" ' + (isChecked ? 'checked' : '') + ' onchange="updateSelectedCount()"></td>' +
                            '<td style="font-weight:700; color:var(--primary-blue);">' + (st.rollNo || ('STU' + st.id)) + '</td>' +
                            '<td><strong>' + st.name + '</strong></td>' +
                            '<td>' + (st.username || 'N/A') + '</td>' +
                            '<td>' + (st.email || 'N/A') + '</td>' +
                            '<td>' + st.course + '</td>' +
                            '<td>' + st.dept + '</td>' +
                            '<td>' + semText + '</td>' +
                            '<td>' + yearDisplay + '</td>';
                        tbody.appendChild(tr);
                    });

                    const allChecked = Array.from(document.querySelectorAll('.student-alloc-cb')).every(cb => cb.checked);
                    document.getElementById('selectAllStudentsCb').checked = allChecked;
                    updateSelectedCount();
                }

                function toggleSelectAllStudents(checked) {
                    const checkboxes = document.querySelectorAll('.student-alloc-cb');
                    checkboxes.forEach(cb => cb.checked = checked);
                    updateSelectedCount();
                }

                function updateSelectedCount() {
                    const count = document.querySelectorAll('.student-alloc-cb:checked').length;
                    const badge = document.getElementById('selectedStudentCounter');
                    if (badge) {
                        badge.innerText = 'Selected: ' + count + ' Student' + (count === 1 ? '' : 's');
                    }
                }

                function saveStudentAllocation() {
                    const checkedBoxes = document.querySelectorAll('.student-alloc-cb:checked');
                    const selectedStudentIds = Array.from(checkedBoxes).map(cb => cb.value);

                    const t = teachersData.find(teacher => teacher.id == activeAssignTeacherId || String(teacher.id) === String(activeAssignTeacherId));
                    if (!t || !t.assignedSubjects) {
                        closeModal('manageStudentsModal');
                        return;
                    }
                    const s = t.assignedSubjects.find(sub => sub.code === activeManagingSubjectCode || sub.name === activeManagingSubjectCode);
                    if (!s) {
                        closeModal('manageStudentsModal');
                        return;
                    }

                    const subjObj = dbSubjects.find(sub => sub.subjectCode === s.code || sub.code === s.code || sub.name === s.name);
                    const subId = s.subjectId || (subjObj ? subjObj.id : null);

                    if (t.id && subId) {
                        const params = new URLSearchParams();
                        params.append('teacherId', t.id);
                        params.append('subjectId', subId);
                        params.append('studentIds', selectedStudentIds.join(','));

                        fetch('${pageContext.request.contextPath}/api/admin/student-subject-assignments', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                            body: params.toString()
                        }).then(res => res.json()).then(data => {
                            s.studentCount = selectedStudentIds.length;
                            fetchTeachersFromDB();
                            closeModal('manageStudentsModal');
                            if (activeAssignTeacherId) {
                                openAssignSubjectModal(activeAssignTeacherId);
                            }
                        }).catch(err => {
                            console.error("Save student allocation error:", err);
                            s.studentCount = selectedStudentIds.length;
                            closeModal('manageStudentsModal');
                            if (activeAssignTeacherId) {
                                openAssignSubjectModal(activeAssignTeacherId);
                            }
                        });
                    } else {
                        s.studentCount = selectedStudentIds.length;
                        closeModal('manageStudentsModal');
                        if (activeAssignTeacherId) {
                            openAssignSubjectModal(activeAssignTeacherId);
                        }
                    }
                }

                function openDeleteTeacherModal(id) {
                    targetDeleteTeacherId = id;
                    const t = teachersData.find(teacher => teacher.id == id || String(teacher.id) === String(id));
                    const nameEl = document.getElementById('deleteTeacherName');
                    if (nameEl) {
                        const nameStr = (t && t.name && t.name.trim() !== '') ? t.name : (t && t.username ? t.username : 'this faculty');
                        nameEl.textContent = nameStr;
                    }
                    openModal('deleteModal');
                }

                function confirmDeleteModal() {
                    if (targetDeleteTeacherId !== null) {
                        const formData = new URLSearchParams();
                        formData.append('action', 'delete');
                        formData.append('id', targetDeleteTeacherId);

                        fetch('${pageContext.request.contextPath}/api/admin/teachers', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: formData.toString()
                        })
                            .then(res => res.json())
                            .then(() => {
                                targetDeleteTeacherId = null;
                                closeModal('deleteModal');
                                fetchTeachersFromDB();
                            })
                            .catch(err => {
                                targetDeleteTeacherId = null;
                                closeModal('deleteModal');
                                fetchTeachersFromDB();
                            });
                    } else {
                        closeModal('deleteModal');
                    }
                }

                document.addEventListener('DOMContentLoaded', () => {
                    fetchTeachersFromDB();
                });
            </script>
        </body>

        </html>