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
            <title>Student Management - Admin Dashboard</title>
            
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
                    --shadow-hover: 0 15px 30px -8px rgba(37, 99, 235, 0.12);
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
                    <li class="nav-item active"><a href="students.jsp"><svg viewBox="0 0 24 24" fill="none"
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
                        <h1 class="page-title">Student Management</h1>
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
                                                    <h3>Student Records</h3>
                                                    <p style="font-size: 0.85rem; color: var(--text-muted);">Overview of
                                                        active student
                                                        profiles and enrollment records.</p>
                                                </div>
                                                <button class="btn btn-primary" onclick="openStudentModal('add')">
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <line x1="12" y1="5" x2="12" y2="19" />
                                                        <line x1="5" y1="12" x2="19" y2="12" />
                                                    </svg>
                                                    <span>Add Student</span>
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
                                                        placeholder="Search by name, roll no, or email..."
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
                                                <select class="filter-select" id="semFilter" onchange="filterTable()">
                                                    <option value="">All Semesters</option>
                                                    <option value="Semester 1">Semester 1</option>
                                                    <option value="Semester 2">Semester 2</option>
                                                    <option value="Semester 3">Semester 3</option>
                                                    <option value="Semester 4">Semester 4</option>
                                                    <option value="Semester 5">Semester 5</option>
                                                    <option value="Semester 6">Semester 6</option>
                                                    <option value="Semester 7">Semester 7</option>
                                                    <option value="Semester 8">Semester 8</option>
                                                </select>
                                                <select class="filter-select" id="yearFilter" onchange="filterTable()">
                                                    <option value="">All Years</option>
                                                    <option value="First Year">First Year</option>
                                                    <option value="Second Year">Second Year</option>
                                                    <option value="Third Year">Third Year</option>
                                                    <option value="Fourth Year">Fourth Year</option>
                                                </select>
                                            </div>

                                            <div class="table-responsive">
                                                <table class="data-table" id="studentsTable">
                                                    <thead>
                                                        <tr>
                                                            <th>Sr. No.</th>
                                                            <th>Full Name</th>
                                                            <th>Gender</th>
                                                            <th>Roll No</th>
                                                            <th>Username</th>
                                                            <th>Email</th>
                                                            <th>Phone</th>
                                                            <th>Course</th>
                                                            <th>Department</th>
                                                            <th>Semester</th>
                                                            <th>Year</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="studentTableBody">
                                                        <!-- Dynamic rows rendered by JS -->
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                    </div>
                </main>
            </div>

            <!-- View Modal -->
            <div class="modal-backdrop" id="viewStudentModal">
                <div class="modal-card" style="max-width: 520px;">
                    <div class="modal-header">
                        <h4>Student Profile Details</h4>
                        <button type="button" class="modal-close-btn"
                            onclick="closeModal('viewStudentModal')">&times;</button>
                    </div>
                    <div class="modal-body" id="viewStudentModalBody" style="gap: 0.85rem;">
                        <!-- Content populated dynamically -->
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary"
                            onclick="closeModal('viewStudentModal')">Close</button>
                    </div>
                </div>
            </div>

            <!-- Student Modal (Add/Edit) -->
            <div class="modal-backdrop" id="studentModal">
                <div class="modal-card" style="max-width: 580px;">
                    <div class="modal-header">
                        <h4 id="studentModalTitle">Add New Student</h4>
                        <button type="button" class="modal-close-btn"
                            onclick="closeModal('studentModal')">&times;</button>
                    </div>
                    <form onsubmit="saveStudentForm(event)" id="adminStudentForm">
                        <input type="hidden" id="mStudentId">
                        <div class="modal-body" style="max-height: 70vh; overflow-y: auto;">
                            <div class="form-group" style="grid-column: span 2;">
                                <label>Gender *</label>
                                <div style="display: flex; gap: 1.5rem; align-items: center; padding: 0.35rem 0;">
                                    <label
                                        style="display: flex; align-items: center; gap: 0.4rem; cursor: pointer; font-size: 0.875rem; font-weight: 500;">
                                        <input type="radio" name="mStudentGender" value="Male" checked> Male
                                    </label>
                                    <label
                                        style="display: flex; align-items: center; gap: 0.4rem; cursor: pointer; font-size: 0.875rem; font-weight: 500;">
                                        <input type="radio" name="mStudentGender" value="Female"> Female
                                    </label>
                                    <label
                                        style="display: flex; align-items: center; gap: 0.4rem; cursor: pointer; font-size: 0.875rem; font-weight: 500;">
                                        <input type="radio" name="mStudentGender" value="Other"> Other
                                    </label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Full Name</label>
                                <input type="text" id="mStudentFullName" placeholder="Enter full name" required>
                            </div>
                            <div class="form-group">
                                <label>Username</label>
                                <input type="text" id="mStudentUsername" placeholder="Enter username" required>
                            </div>
                            <div class="form-group">
                                <label>Email Address</label>
                                <input type="email" id="mStudentEmail" placeholder="Enter email address" required>
                            </div>
                            <div class="form-group">
                                <label>Roll Number</label>
                                <input type="text" id="mRollNo" placeholder="Enter roll number" required>
                            </div>
                            <div class="form-group">
                                <label>Phone</label>
                                <input type="tel" id="mStudentPhone" placeholder="Enter phone number">
                            </div>
                            <div class="form-group">
                                <label>Course</label>
                                <select id="mStudentCourse">
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
                                <select id="mStudentDepartment">
                                    <option value="Computer Engineering">Computer Engineering</option>
                                    <option value="Information Technology">Information Technology</option>
                                    <option value="Mechanical Engineering">Mechanical Engineering</option>
                                    <option value="Electrical Engineering">Electrical Engineering</option>
                                    <option value="Civil Engineering">Civil Engineering</option>
                                    <option value="Electronics & Telecommunication">Electronics & Telecommunication
                                    </option>
                                    <option value="Electronics Engineering">Electronics Engineering</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Semester</label>
                                <select id="mStudentSem">
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
                                <select id="mStudentYear">
                                    <option value="First Year">First Year</option>
                                    <option value="Second Year">Second Year</option>
                                    <option value="Third Year">Third Year</option>
                                    <option value="Fourth Year">Fourth Year</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline"
                                onclick="closeModal('studentModal')">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save Student</button>
                        </div>
                    </form>
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
                            <h4 style="color:#991B1B; margin:0; font-size:1.05rem; font-weight:800;">Confirm Student
                                Deletion</h4>
                        </div>
                        <button class="modal-close-btn" onclick="closeModal('deleteModal')"
                            style="color:#991B1B;">&times;</button>
                    </div>
                    <div class="modal-body" style="padding: 1.5rem; text-align: center;">
                        <p style="font-size: 0.95rem; color: #1E293B; margin-bottom: 0.75rem; line-height: 1.5;"
                            id="deleteModalText">
                            Are you sure you want to remove student <strong id="deleteStudentName"
                                style="color:#DC2626; font-weight:800;">this student</strong>?
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

                // Demo Data Array
                let studentsData = [];
                let targetDeleteId = null;

                function formatGender(g) {
                    return g ? String(g).trim() : 'Male';
                }

                function fetchStudentsFromDB() {
                    fetch('${pageContext.request.contextPath}/api/admin/students')
                        .then(res => res.json())
                        .then(data => {
                            studentsData = data || [];
                            filterTable();
                        })
                        .catch(err => {
                            console.error("Failed to load students from DB:", err);
                            studentsData = [];
                            filterTable();
                        });
                }

                function renderStudentsTable(data = studentsData) {
                    const tbody = document.getElementById('studentTableBody');
                    if (!tbody) return;
                    tbody.innerHTML = '';

                    if (!data || data.length === 0) {
                        tbody.innerHTML = `<tr><td colspan="11" style="text-align:center; padding: 2rem; color: var(--text-muted);">No student records found matching the filters.</td></tr>`;
                        return;
                    }

                    data.forEach((s, index) => {
                        const tr = document.createElement('tr');
                        const sDept = s.dept || s.department || '--';
                        const sSem = s.sem || s.semester || '--';
                        const sYear = s.year || '--';

                        tr.innerHTML =
                            '<td style="font-weight:700; color: var(--primary-navy);">' + (index + 1) + '</td>' +
                            '<td><strong>' + (s.name || '--') + '</strong></td>' +
                            '<td><span class="badge" style="background:#F1F5F9; color:#334155; font-weight:700;">' + formatGender(s.gender) + '</span></td>' +
                            '<td style="font-weight:700; color: var(--text-main);">' + (s.rollNo || '--') + '</td>' +
                            '<td>' + (s.username || '--') + '</td>' +
                            '<td>' + (s.email || '--') + '</td>' +
                            '<td>' + (s.phone || '--') + '</td>' +
                            '<td><span class="badge badge-success">' + (s.course || '--') + '</span></td>' +
                            '<td>' + sDept + '</td>' +
                            '<td>' + sSem + '</td>' +
                            '<td>' + sYear + '</td>' +
                            '<td>' +
                            '<div style="display:flex; gap:0.35rem;">' +
                            '<button class="btn btn-outline" style="padding:0.3rem 0.5rem; font-size:0.75rem; color: var(--primary-blue);" onclick="openStudentModal(\'edit\', ' + s.id + ')">Edit</button>' +
                            '<button class="btn btn-danger" style="padding:0.3rem 0.5rem; font-size:0.75rem;" onclick="openDeleteModal(' + s.id + ')">Delete</button>' +
                            '</div>' +
                            '</td>';
                        tbody.appendChild(tr);
                    });
                }

                function filterTable() {
                    const query = document.getElementById('searchInput').value.toLowerCase();
                    const course = document.getElementById('courseFilter').value.toLowerCase();
                    const dept = document.getElementById('deptFilter').value.toLowerCase();
                    const sem = document.getElementById('semFilter').value.toLowerCase();
                    const year = document.getElementById('yearFilter').value.toLowerCase();

                    const filtered = studentsData.filter(s => {
                        const matchText = (s.name || '').toLowerCase().includes(query) ||
                            (s.rollNo || '').toLowerCase().includes(query) ||
                            (s.username || '').toLowerCase().includes(query) ||
                            (s.email || '').toLowerCase().includes(query);
                        const matchCourse = !course || (s.course && s.course.toLowerCase() === course);
                        const matchDept = !dept || (s.dept && s.dept.toLowerCase() === dept);
                        const matchSem = !sem || (s.sem && s.sem.toLowerCase() === sem);
                        const matchYear = !year || (s.year && s.year.toLowerCase() === year);
                        return matchText && matchCourse && matchDept && matchSem && matchYear;
                    });

                    renderStudentsTable(filtered);
                }

                function openModal(id) {
                    const el = document.getElementById(id);
                    if (el) el.classList.add('open');
                }
                function closeModal(id) {
                    const el = document.getElementById(id);
                    if (el) el.classList.remove('open');
                }

                function viewStudentModal(id) {
                    const s = studentsData.find(st => st.id === id);
                    if (!s) return;

                    const body = document.getElementById('viewStudentModalBody');
                    body.innerHTML =
                        '<div style="text-align:center; padding-bottom: 0.5rem; border-bottom: 1px solid var(--border);">' +
                        '<div style="width:50px; height:50px; border-radius:50%; background: var(--primary-navy); color:#fff; display:flex; align-items:center; justify-content:center; font-weight:800; font-size:1.2rem; margin:0 auto 0.5rem;">' + (s.name ? s.name.charAt(0) : 'S') + '</div>' +
                        '<h3 style="color: var(--primary-navy); font-weight:800;">' + (s.name || 'N/A') + '</h3>' +
                        '<p style="color: var(--text-main); font-size:0.85rem; font-weight:700;">Roll No: ' + (s.rollNo || '--') + '</p>' +
                        '</div>' +
                        '<div style="display:grid; grid-template-columns: 1fr 1fr; gap:0.75rem; font-size:0.875rem; margin-top:0.75rem;">' +
                        '<div><strong>Student ID:</strong> ' + s.id + '</div>' +
                        '<div><strong>Gender:</strong> ' + formatGender(s.gender) + '</div>' +
                        '<div><strong>Username:</strong> ' + (s.username || '--') + '</div>' +
                        '<div><strong>Email:</strong> ' + (s.email || '--') + '</div>' +
                        '<div><strong>Phone:</strong> ' + (s.phone || '--') + '</div>' +
                        '<div><strong>Course:</strong> ' + (s.course || 'BTech') + '</div>' +
                        '<div><strong>Department:</strong> ' + (s.dept || '--') + '</div>' +
                        '<div><strong>Semester:</strong> ' + (s.sem || '--') + '</div>' +
                        '<div><strong>Academic Year:</strong> ' + (s.year || '--') + '</div>' +
                        '</div>';
                    openModal('viewStudentModal');
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

                function openStudentModal(mode, id = null) {
                    const titleEl = document.getElementById('studentModalTitle');
                    const form = document.getElementById('adminStudentForm');

                    if (mode === 'add') {
                        titleEl.innerText = 'Add New Student';
                        document.getElementById('mStudentId').value = '';
                        form.reset();
                        const maleRadio = document.querySelector('input[name="mStudentGender"][value="Male"]');
                        if (maleRadio) maleRadio.checked = true;
                    } else {
                        titleEl.innerText = 'Edit Student Details';
                        const s = studentsData.find(st => st.id === id);
                        if (s) {
                            document.getElementById('mStudentId').value = s.id;
                            document.getElementById('mStudentFullName').value = s.name || '';
                            document.getElementById('mStudentUsername').value = s.username || '';
                            document.getElementById('mStudentEmail').value = s.email || '';
                            document.getElementById('mRollNo').value = s.rollNo || '';
                            document.getElementById('mStudentPhone').value = s.phone || '';

                            const gFormatted = formatGender(s.gender);
                            const gRadio = document.querySelector('input[name="mStudentGender"][value="' + gFormatted + '"]');
                            if (gRadio) gRadio.checked = true;

                            setSelectValue('mStudentCourse', s.course, 'BTech');
                            setSelectValue('mStudentDepartment', s.dept || s.department, 'Computer Engineering');
                            setSelectValue('mStudentSem', s.sem || s.semester, 'Semester 5');
                            setSelectValue('mStudentYear', s.year, 'Third Year');
                        }
                    }
                    openModal('studentModal');
                }

                function saveStudentForm(e) {
                    e.preventDefault();
                    const idVal = document.getElementById('mStudentId').value;
                    const name = document.getElementById('mStudentFullName').value;
                    const username = document.getElementById('mStudentUsername').value;
                    const email = document.getElementById('mStudentEmail').value;
                    const rollNo = document.getElementById('mRollNo').value;
                    const phone = document.getElementById('mStudentPhone').value;
                    const course = document.getElementById('mStudentCourse').value;
                    const dept = document.getElementById('mStudentDepartment').value;
                    const sem = document.getElementById('mStudentSem').value;
                    const year = document.getElementById('mStudentYear').value;
                    const genderRadio = document.querySelector('input[name="mStudentGender"]:checked');
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
                    formData.append('rollNo', rollNo);
                    formData.append('phone', phone);
                    formData.append('course', course);
                    formData.append('dept', dept);
                    formData.append('sem', sem);
                    formData.append('year', year);

                    fetch('${pageContext.request.contextPath}/api/admin/students', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: formData.toString()
                    })
                        .then(res => res.json())
                        .then(res => {
                            closeModal('studentModal');
                            fetchStudentsFromDB();
                        })
                        .catch(err => {
                            console.error('Save failed:', err);
                            closeModal('studentModal');
                            fetchStudentsFromDB();
                        });
                }

                function openDeleteModal(id) {
                    targetDeleteId = id;
                    const s = studentsData.find(st => st.id == id || String(st.id) === String(id));
                    const nameEl = document.getElementById('deleteStudentName');
                    if (nameEl) {
                        const nameStr = (s && s.name && s.name.trim() !== '') ? s.name : (s && s.username ? s.username : 'this student');
                        nameEl.textContent = nameStr;
                    }
                    openModal('deleteModal');
                }

                function confirmDeleteModal() {
                    if (targetDeleteId !== null) {
                        const formData = new URLSearchParams();
                        formData.append('action', 'delete');
                        formData.append('id', targetDeleteId);

                        fetch('${pageContext.request.contextPath}/api/admin/students', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: formData.toString()
                        })
                            .then(res => res.json())
                            .then(() => {
                                targetDeleteId = null;
                                closeModal('deleteModal');
                                fetchStudentsFromDB();
                            })
                            .catch(err => {
                                targetDeleteId = null;
                                closeModal('deleteModal');
                                fetchStudentsFromDB();
                            });
                    } else {
                        closeModal('deleteModal');
                    }
                }

                document.addEventListener('DOMContentLoaded', () => {
                    fetchStudentsFromDB();
                });
            </script>
        </body>

        </html>