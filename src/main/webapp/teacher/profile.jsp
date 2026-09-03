<%@ page language = "java" contentType = "text/html; charset = UTF-8" pageEncoding = "UTF-8" import = "com.student.entity.*,com.student.service.*" %>
    <%
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
        response.setHeader("Pragma", "no-cache" );
        response.setDateHeader("Expires", 0);
        if (session == null || session.getAttribute("teacher") == null)
        {
            response.sendRedirect(request.getContextPath() + "/login.jsp" );
            return;
        }
        com.student.entity.Teacher currentTeacher = (com.student.entity.Teacher) session.getAttribute("teacher");
        /* Refresh teacher entity from DB on each request */
        try
        {
            TeacherService teacherService = new TeacherService();
            com.student.entity.Teacher freshTeacher = teacherService.getTeacherByUsernameOrEmail(currentTeacher.getUsername());
            if (freshTeacher != null)
            {
                session.setAttribute("teacher", freshTeacher);
                currentTeacher = freshTeacher;
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        String teacherName = "Teacher" ;
        String teacherInitial = "T" ;
        String bannerInitials = "T" ;
        if (currentTeacher != null && currentTeacher.getName() != null && !currentTeacher.getName().trim().isEmpty())
        {
            teacherName = currentTeacher.getName().trim();
            teacherInitial = String.valueOf(teacherName.charAt(0)).toUpperCase();
            String[] nameParts = teacherName.split("\\s+");
            if (nameParts.length>= 2)
            {
                bannerInitials = (String.valueOf(nameParts[0].charAt(0)) + String.valueOf(nameParts[nameParts.length - 1].charAt(0))).toUpperCase();
            }
            else
            {
                bannerInitials = String.valueOf(teacherName.charAt(0)).toUpperCase();
            }
        }
        String dispName = (currentTeacher != null && currentTeacher.getName() != null && !currentTeacher.getName().trim().isEmpty()) ? currentTeacher.getName().trim() : "--";
        String dispGender = (currentTeacher != null && currentTeacher.getGender() != null && !currentTeacher.getGender().trim().isEmpty()) ? currentTeacher.getGender().trim() : "--";
        String dispUsername = (currentTeacher != null && currentTeacher.getUsername() != null && !currentTeacher.getUsername().trim().isEmpty()) ? currentTeacher.getUsername().trim() : "--";
        String dispEmail = (currentTeacher != null && currentTeacher.getEmail() != null && !currentTeacher.getEmail().trim().isEmpty()) ? currentTeacher.getEmail().trim() : "--";
        String dispPhone = (currentTeacher != null && currentTeacher.getPhone() != null && !currentTeacher.getPhone().trim().isEmpty()) ? currentTeacher.getPhone().trim() : "--";
        String dispDept = (currentTeacher != null && currentTeacher.getDepartment() != null && !currentTeacher.getDepartment().trim().isEmpty()) ? currentTeacher.getDepartment().trim() : "--";
    %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Faculty Profile - Student Management System</title>
            
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
                    --bg-main: #F8FAFC;
                    --card-bg: #FFFFFF;
                    --text-main: #1E293B;
                    --text-muted: #64748B;
                    --border: #E2E8F0;

                    --sidebar-width: 275px;
                    --topbar-height: 70px;

                    --radius-sm: 8px;
                    --radius-md: 14px;
                    --radius-lg: 20px;

                    --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.04);
                    --shadow-md: 0 4px 20px -2px rgba(15, 23, 42, 0.08);

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

                /* Sidebar Styling */
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
                    transition: transform 0.3s ease;
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

                .logout-link svg {
                    width: 20px;
                    height: 20px;
                    stroke-width: 2;
                    flex-shrink: 0;
                }

                .logout-link:hover {
                    background: rgba(220, 38, 38, 0.1);
                    color: #EF4444;
                }

                /* Mobile Overlay */
                .sidebar-overlay {
                    display: none;
                    position: fixed;
                    inset: 0;
                    background: rgba(15, 23, 42, 0.5);
                    backdrop-filter: blur(4px);
                    z-index: 999;
                }

                .sidebar-overlay.active {
                    display: block;
                }

                /* Main Content Layout */
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

                .navbar-left {
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

                .menu-toggle-btn svg {
                    width: 24px;
                    height: 24px;
                }

                .page-title {
                    font-size: 1.35rem;
                    font-weight: 800;
                    color: var(--text-main);
                }

                .user-profile-badge {
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                    padding: 0.35rem 0.85rem 0.35rem 0.35rem;
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
                    font-size: 0.85rem;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .user-info-text {
                    display: flex;
                    flex-direction: column;
                    line-height: 1.2;
                }

                .user-name {
                    font-size: 0.85rem;
                    font-weight: 700;
                    color: var(--text-main);
                }

                .user-role-label {
                    font-size: 0.725rem;
                    font-weight: 600;
                    color: var(--text-muted);
                }

                .content-area {
                    padding: 1.75rem 2rem;
                    flex: 1;
                }

                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    display: flex;
                    flex-direction: column;
                    gap: 1.75rem;
                }

                /* Profile Banner Hero Card */
                .profile-banner-card {
                    background: linear-gradient(135deg, #1E3A5F 0%, #0F172A 100%);
                    border-radius: var(--radius-lg);
                    padding: 2.25rem 2rem;
                    color: #FFFFFF;
                    display: flex;
                    align-items: center;
                    gap: 2rem;
                    box-shadow: var(--shadow-md);
                    position: relative;
                    overflow: hidden;
                }

                .profile-banner-card::before {
                    content: '';
                    position: absolute;
                    top: -50px;
                    right: -50px;
                    width: 220px;
                    height: 220px;
                    background: rgba(37, 99, 235, 0.15);
                    border-radius: 50%;
                    pointer-events: none;
                }

                .banner-avatar-wrapper {
                    position: relative;
                    flex-shrink: 0;
                }

                .banner-avatar {
                    width: 90px;
                    height: 90px;
                    border-radius: 50%;
                    background: linear-gradient(135deg, #2563EB 0%, #1D4ED8 100%);
                    color: #FFFFFF;
                    font-size: 2rem;
                    font-weight: 800;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    border: 4px solid rgba(255, 255, 255, 0.2);
                    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
                }

                .status-dot {
                    position: absolute;
                    bottom: 4px;
                    right: 4px;
                    width: 18px;
                    height: 18px;
                    background: #10B981;
                    border: 3px solid #0F172A;
                    border-radius: 50%;
                }

                .banner-info {
                    flex: 1;
                    min-width: 0;
                }

                .banner-info h2 {
                    font-size: 1.6rem;
                    font-weight: 800;
                    margin-bottom: 0.4rem;
                    letter-spacing: -0.3px;
                    line-height: 1.2;
                }

                .banner-role-tag {
                    display: inline-flex;
                    align-items: center;
                    gap: 0.5rem;
                    padding: 0.35rem 0.9rem;
                    background: rgba(255, 255, 255, 0.12);
                    backdrop-filter: blur(8px);
                    border: 1px solid rgba(255, 255, 255, 0.15);
                    border-radius: 20px;
                    font-size: 0.825rem;
                    font-weight: 600;
                    color: #93C5FD;
                }

                /* Information Card Grid */
                .content-card {
                    background: var(--card-bg);
                    border-radius: var(--radius-md);
                    padding: 2rem;
                    border: 1px solid var(--border);
                    box-shadow: var(--shadow-sm);
                }

                .card-header-row {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    margin-bottom: 1.5rem;
                    padding-bottom: 1rem;
                    border-bottom: 1px solid var(--border);
                }

                .card-header-row h3 {
                    font-size: 1.1rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                    display: flex;
                    align-items: center;
                    gap: 0.6rem;
                }

                .card-header-row h3 svg {
                    width: 22px;
                    height: 22px;
                    color: var(--primary-blue);
                }

                .profile-grid {
                    display: grid;
                    grid-template-columns: repeat(3, 1fr);
                    gap: 1.25rem;
                }

                .detail-box {
                    background: var(--bg-main);
                    border: 1px solid var(--border);
                    border-radius: var(--radius-md);
                    padding: 1.15rem 1.35rem;
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                    transition: var(--transition);
                }

                .detail-box:hover {
                    border-color: #BFDBFE;
                    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.05);
                    background: #FFFFFF;
                }

                .icon-circle {
                    width: 42px;
                    height: 42px;
                    border-radius: 12px;
                    background: var(--light-blue);
                    color: var(--primary-blue);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    flex-shrink: 0;
                }

                .icon-circle svg {
                    width: 20px;
                    height: 20px;
                    stroke-width: 2;
                }

                .detail-content {
                    flex: 1;
                    min-width: 0;
                }

                .detail-label {
                    font-size: 0.725rem;
                    font-weight: 700;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                    color: var(--text-muted);
                    margin-bottom: 0.2rem;
                }

                .detail-value {
                    font-size: 1rem;
                    font-weight: 700;
                    color: var(--text-main);
                    word-break: break-word;
                }

                /* Responsive Breakpoints */
                @media (max-width: 992px) {
                    .profile-grid {
                        grid-template-columns: repeat(2, 1fr);
                    }
                }

                @media (max-width: 860px) {
                    .sidebar {
                        transform: translateX(-100%);
                    }

                    .sidebar.open {
                        transform: translateX(0);
                    }

                    .main-wrapper {
                        margin-left: 0;
                        width: 100%;
                    }

                    .menu-toggle-btn {
                        display: block;
                    }

                    .top-navbar {
                        padding: 0 1.25rem;
                    }

                    .content-area {
                        padding: 1.25rem;
                    }

                    .profile-banner-card {
                        flex-direction: column;
                        text-align: center;
                        padding: 1.75rem 1.25rem;
                        gap: 1.25rem;
                    }
                }

                @media (max-width: 640px) {
                    .profile-grid {
                        grid-template-columns: 1fr;
                    }
                }
            </style>
        </head>

        <body>
            <jsp:include page="/logout-modal.jsp" />

            
            <div class="sidebar-overlay" id="sidebarOverlay"></div>

            <!-- Sidebar Navigation -->
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
                    <li class="nav-item">
                        <a href="dashboard.jsp">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                <rect x="3" y="3" width="7" height="7" />
                                <rect x="14" y="3" width="7" height="7" />
                                <rect x="14" y="14" width="7" height="7" />
                                <rect x="3" y="14" width="7" height="7" />
                            </svg>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="subjects.jsp">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path
                                    d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                            </svg>
                            <span>Assigned Subjects</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="students.jsp">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                <circle cx="9" cy="7" r="4" />
                            </svg>
                            <span>Assigned Students</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="cce-marks.jsp">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                <polyline points="14 2 14 8 20 8" />
                            </svg>
                            <span>CCE Marks</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="end-sem-marks.jsp">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                <path d="M9 11l3 3L22 4" />
                                <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11" />
                            </svg>
                            <span>End Sem Marks</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="results.jsp">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                <polygon
                                    points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                            </svg>
                            <span>View Results</span>
                        </a>
                    </li>
                    <li class="nav-item active">
                        <a href="profile.jsp">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                <circle cx="12" cy="7" r="4" />
                            </svg>
                            <span>Profile</span>
                        </a>
                    </li>
                </ul>

                <div class="sidebar-footer">
                    <a href="${pageContext.request.contextPath}/logout" class="logout-link"
                        onclick="return openLogoutModal(event)">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                            <polyline points="16 17 21 12 16 7" />
                            <line x1="21" y1="12" x2="9" y2="12" />
                        </svg>
                        <span>Logout</span>
                    </a>
                </div>
            </aside>

            <!-- Main Layout -->
            <div class="main-wrapper">
                <header class="top-navbar">
                    <div class="navbar-left">
                        <button class="menu-toggle-btn" id="menuToggleBtn" title="Toggle Sidebar">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <line x1="3" y1="12" x2="21" y2="12" />
                                <line x1="3" y1="6" x2="21" y2="6" />
                                <line x1="3" y1="18" x2="21" y2="18" />
                            </svg>
                        </button>
                        <h1 class="page-title">Faculty Profile</h1>
                    </div>
                    <div class="user-profile-badge">
                        <div class="user-avatar">
                            <%= teacherInitial %>
                        </div>
                        <div class="user-info-text">
                            <span class="user-name">
                                <%= teacherName %>
                            </span>
                            <span class="user-role-label">Teacher</span>
                        </div>
                    </div>
                </header>

                <main class="content-area">
                    <div class="container">
                        <!-- Profile Banner Hero -->
                        <div class="profile-banner-card">
                            <div class="banner-avatar-wrapper">
                                <div class="banner-avatar">
                                    <%= bannerInitials %>
                                </div>
                                <div class="status-dot" title="Active Faculty Status"></div>
                            </div>
                            <div class="banner-info">
                                <h2>
                                    <%= dispName %>
                                </h2>
                                <div class="banner-role-tag">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.5">
                                        <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
                                        <path d="M6 12v5c3 3 9 3 12 0v-5" />
                                    </svg>
                                    <span>Faculty Member &bull; <%= dispDept %></span>
                                </div>
                            </div>
                        </div>

                        <!-- Detailed Information Grid Card -->
                        <div class="content-card">
                            <div class="card-header-row">
                                <h3>
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                        <circle cx="12" cy="7" r="4" />
                                    </svg>
                                    Faculty Profile Information
                                </h3>
                            </div>

                            <div class="profile-grid">
                                
                                <div class="detail-box">
                                    <div class="icon-circle">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                            <circle cx="12" cy="7" r="4" />
                                        </svg>
                                    </div>
                                    <div class="detail-content">
                                        <div class="detail-label">Full Name</div>
                                        <div class="detail-value">
                                            <%= dispName %>
                                        </div>
                                    </div>
                                </div>

                                
                                <div class="detail-box">
                                    <div class="icon-circle">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                            <path
                                                d="M12 2a5 5 0 1 0 5 5 5 5 0 0 0-5-5zm0 8a3 3 0 1 1 3-3 3 3 0 0 1-3 3z" />
                                            <path d="M12 14a7 7 0 0 0-7 7h14a7 7 0 0 0-7-7z" />
                                        </svg>
                                    </div>
                                    <div class="detail-content">
                                        <div class="detail-label">Gender</div>
                                        <div class="detail-value">
                                            <%= dispGender %>
                                        </div>
                                    </div>
                                </div>

                                
                                <div class="detail-box">
                                    <div class="icon-circle">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                            <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                            <circle cx="8.5" cy="7" r="4" />
                                            <polyline points="17 11 19 13 23 9" />
                                        </svg>
                                    </div>
                                    <div class="detail-content">
                                        <div class="detail-label">Username</div>
                                        <div class="detail-value">
                                            <%= dispUsername %>
                                        </div>
                                    </div>
                                </div>

                                
                                <div class="detail-box">
                                    <div class="icon-circle">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                            <path
                                                d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" />
                                            <polyline points="22,6 12,13 2,6" />
                                        </svg>
                                    </div>
                                    <div class="detail-content">
                                        <div class="detail-label">Email Address</div>
                                        <div class="detail-value">
                                            <%= dispEmail %>
                                        </div>
                                    </div>
                                </div>

                                
                                <div class="detail-box">
                                    <div class="icon-circle">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                            <path
                                                d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z" />
                                        </svg>
                                    </div>
                                    <div class="detail-content">
                                        <div class="detail-label">Contact Number</div>
                                        <div class="detail-value">
                                            <%= dispPhone %>
                                        </div>
                                    </div>
                                </div>

                                
                                <div class="detail-box">
                                    <div class="icon-circle">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                            <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
                                            <polyline points="9 22 9 12 15 12 15 22" />
                                        </svg>
                                    </div>
                                    <div class="detail-content">
                                        <div class="detail-label">Department</div>
                                        <div class="detail-value">
                                            <%= dispDept %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
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

                // Auto-close sidebar on mobile item click
                document.querySelectorAll('.sidebar-menu a').forEach(link => {
                    link.addEventListener('click', () => {
                        if (window.innerWidth <= 860) {
                            toggleSidebar();
                        }
                    });
                });
            </script>
        </body>

        </html>