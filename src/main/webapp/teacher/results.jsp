<%@ page language="java" contentType="text/html; charset = UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.util.*" %>
        <%@ page import="com.student.entity.*, com.student.service.*" %>
            <% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
                response.setHeader("Pragma", "no-cache" ); response.setDateHeader("Expires", 0); if (session==null ||
                session.getAttribute("teacher")==null) { response.sendRedirect(request.getContextPath() + "/login.jsp"
                ); return; } Teacher loggedInTeacher=(Teacher) session.getAttribute("teacher"); String
                teacherFirstName="Teacher" ; String teacherInitial="T" ; int teacherId=0; if (loggedInTeacher !=null) {
                teacherId=loggedInTeacher.getId(); if (loggedInTeacher.getName() !=null &&
                !loggedInTeacher.getName().trim().isEmpty()) { teacherFirstName=loggedInTeacher.getName().trim(); if
                (!teacherFirstName.isEmpty()) { teacherInitial=String.valueOf(teacherFirstName.charAt(0)).toUpperCase();
                } } } TeacherSubjectService tsService=new TeacherSubjectService(); StudentSubjectAssignmentService
                ssaService=new StudentSubjectAssignmentService(); StudentSubjectMarksService marksService=new
                StudentSubjectMarksService(); List<TeacherSubject> teacherAssignedSubjects = (teacherId > 0) ?
                tsService.getTeacherSubjectsByTeacherId(teacherId) : Collections.emptyList();
                int selectedSubjectId = 0;
                String subParam = request.getParameter("subjectId");
                if (subParam != null && !subParam.trim().isEmpty())
                {
                try
                {
                selectedSubjectId = Integer.parseInt(subParam);
                }
                catch (Exception e)
                {
                }
                }
                if (selectedSubjectId == 0 && teacherAssignedSubjects != null && !teacherAssignedSubjects.isEmpty())
                {
                for (TeacherSubject ts : teacherAssignedSubjects)
                {
                if (ts != null && ts.getSubject() != null)
                {
                selectedSubjectId = ts.getSubject().getId();
                break;
                }
                }
                }
                // Fetch all student assignments for the teacher
                List<StudentSubjectAssignment> allAssignments = Collections.emptyList();
                    if (teacherId > 0)
                    {
                    if (selectedSubjectId > 0)
                    {
                    allAssignments = ssaService.getAssignmentsByTeacherAndSubject(teacherId, selectedSubjectId);
                    }
                    else
                    {
                    allAssignments = ssaService.getAssignmentsByTeacher(teacherId);
                    }
                    }
                    // Topper Tracking Logic
                    String overallTopperName = "--";
                    String overallTopperRoll = "--";
                    double overallMaxTotal = -1.0;
                    String subjectTopperName = "--";
                    String subjectTopperRoll = "--";
                    String subjectTopperCode = "--";
                    double subjectMaxTotal = -1.0;
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Results - Teacher Dashboard</title>
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
                                --success: #10B981;
                                --warning: #F59E0B;
                                --sidebar-width: 275px;
                                --topbar-height: 70px;
                                --radius-sm: 8px;
                                --radius-md: 14px;
                                --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.04);
                                --shadow-md: 0 10px 25px -5px rgba(30, 58, 95, 0.06);
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
                                overflow-x: hidden;
                            }

                            a {
                                text-decoration: none;
                                color: inherit;
                            }

                            ul {
                                list-style: none;
                            }

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
                                border-radius: var(--radius-sm);
                                color: #EF4444;
                                font-weight: 600;
                                font-size: 0.9rem;
                                transition: var(--transition);
                            }

                            .logout-link:hover {
                                background: rgba(239, 68, 68, 0.1);
                            }

                            .main-wrapper {
                                margin-left: var(--sidebar-width);
                                flex: 1;
                                display: flex;
                                flex-direction: column;
                                min-width: 0;
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
                                z-index: 900;
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
                                color: var(--text-main);
                                cursor: pointer;
                            }

                            .page-title {
                                font-size: 1.25rem;
                                font-weight: 800;
                                color: var(--primary-navy);
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
                                background: var(--bg-main);
                                padding: 0.4rem 0.85rem 0.4rem 0.5rem;
                                border-radius: 30px;
                                border: 1px solid var(--border);
                            }

                            .user-avatar {
                                width: 34px;
                                height: 34px;
                                border-radius: 50%;
                                background: var(--primary-blue);
                                color: #FFFFFF;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                font-weight: 700;
                                font-size: 0.9rem;
                            }

                            .user-info-text {
                                display: flex;
                                flex-direction: column;
                            }

                            .user-name {
                                font-size: 0.85rem;
                                font-weight: 700;
                                color: var(--text-main);
                                line-height: 1.2;
                            }

                            .user-role-label {
                                font-size: 0.725rem;
                                color: var(--text-muted);
                                font-weight: 500;
                            }

                            .content-area {
                                padding: 2rem;
                                flex: 1;
                            }

                            .container {
                                max-width: 1400px;
                                margin: 0 auto;
                                display: flex;
                                flex-direction: column;
                                gap: 2rem;
                            }

                            .stats-grid {
                                display: grid;
                                grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
                                gap: 1.25rem;
                            }

                            .stat-card {
                                background: var(--card-bg);
                                border-radius: var(--radius-md);
                                padding: 1.5rem;
                                border: 1px solid var(--border);
                                box-shadow: var(--shadow-sm);
                                display: flex;
                                align-items: center;
                                justify-content: space-between;
                            }

                            .stat-info h4 {
                                font-size: 0.825rem;
                                font-weight: 700;
                                text-transform: uppercase;
                                letter-spacing: 0.5px;
                                color: var(--text-muted);
                                margin-bottom: 0.5rem;
                            }

                            .topper-name-row {
                                display: flex;
                                align-items: center;
                                gap: 0.75rem;
                                font-size: 1.15rem;
                                font-weight: 800;
                                color: var(--primary-navy);
                            }

                            .topper-badge {
                                font-size: 0.75rem;
                                font-weight: 700;
                                padding: 0.2rem 0.6rem;
                                border-radius: 20px;
                            }

                            .badge-gold {
                                background: rgba(245, 158, 11, 0.12);
                                color: #D97706;
                            }

                            .badge-purple {
                                background: rgba(139, 92, 246, 0.12);
                                color: #7C3AED;
                            }

                            .topper-subtext {
                                font-size: 0.8rem;
                                color: var(--text-muted);
                                margin-top: 0.35rem;
                                font-weight: 500;
                            }

                            .stat-icon-wrap {
                                width: 48px;
                                height: 48px;
                                border-radius: 12px;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                flex-shrink: 0;
                            }

                            .icon-gold {
                                background: #FEF3C7;
                                color: #D97706;
                            }

                            .icon-purple {
                                background: #F3E8FF;
                                color: #7C3AED;
                            }

                            .icon-blue {
                                background: var(--light-blue);
                                color: var(--primary-blue);
                            }

                            .content-card {
                                background: var(--card-bg);
                                border-radius: var(--radius-md);
                                border: 1px solid var(--border);
                                box-shadow: var(--shadow-sm);
                                overflow: hidden;
                            }

                            .card-header-row {
                                padding: 1.25rem 1.5rem;
                                border-bottom: 1px solid var(--border);
                                display: flex;
                                align-items: center;
                                justify-content: space-between;
                                flex-wrap: wrap;
                                gap: 1rem;
                                background: #F8FAFC;
                            }

                            .card-header-row h3 {
                                font-size: 1.05rem;
                                font-weight: 700;
                                color: var(--primary-navy);
                                display: flex;
                                align-items: center;
                                gap: 0.6rem;
                            }

                            .filter-controls-group {
                                display: flex;
                                align-items: center;
                                gap: 0.75rem;
                                flex-wrap: wrap;
                            }

                            .filter-label {
                                font-size: 0.8rem;
                                font-weight: 500;
                                color: var(--text-muted);
                            }

                            .custom-select {
                                padding: 0.45rem 0.85rem;
                                border-radius: var(--radius-sm);
                                border: 1px solid #E2E8F0;
                                background: #FFFFFF;
                                color: var(--text-main);
                                font-size: 0.825rem;
                                font-weight: 500;
                                outline: none;
                                cursor: pointer;
                                transition: var(--transition);
                                box-shadow: 0 1px 2px rgba(0, 0, 0, 0.02);
                            }

                            .custom-select:hover {
                                border-color: #CBD5E1;
                                background: #F8FAFC;
                            }

                            .custom-select:focus {
                                border-color: var(--primary-blue);
                                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
                                background: #FFFFFF;
                            }

                            .table-responsive {
                                width: 100%;
                                overflow-x: auto;
                            }

                            /* Custom Bottom Horizontal Scrollbar / Slider */
                            .table-responsive::-webkit-scrollbar {
                                height: 5px;
                                width: 5px;
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
                                border-collapse: collapse;
                                text-align: left;
                                font-size: 0.875rem;
                            }

                            .data-table th {
                                background: #F8FAFC;
                                padding: 0.85rem 1.15rem;
                                font-weight: 600;
                                font-size: 0.775rem;
                                color: var(--text-muted);
                                border-bottom: 2px solid var(--border);
                                white-space: nowrap;
                            }

                            .data-table td {
                                padding: 0.85rem 1.15rem;
                                border-bottom: 1px solid var(--border);
                                vertical-align: middle;
                                color: var(--text-main);
                                font-weight: 500;
                                white-space: nowrap;
                            }

                            .data-table tbody tr:hover {
                                background: #F1F5F9;
                            }

                            .grade-badge {
                                font-weight: 800;
                                font-size: 0.8rem;
                                padding: 0.25rem 0.65rem;
                                border-radius: 6px;
                                display: inline-block;
                            }

                            .grade-o {
                                background: #DCFCE7;
                                color: #15803D;
                            }

                            .grade-aplus {
                                background: #E0E7FF;
                                color: #4338CA;
                            }

                            .grade-a {
                                background: #EFF6FF;
                                color: #1D4ED8;
                            }

                            .grade-bplus {
                                background: #FEF3C7;
                                color: #B45309;
                            }

                            .grade-b {
                                background: #FFEDD5;
                                color: #C2410C;
                            }

                            .grade-c {
                                background: #F1F5F9;
                                color: #475569;
                            }

                            .grade-f {
                                background: #FEE2E2;
                                color: #B91C1C;
                            }

                            .status-pill {
                                font-weight: 700;
                                font-size: 0.775rem;
                                padding: 0.25rem 0.75rem;
                                border-radius: 20px;
                                display: inline-block;
                            }

                            .status-pass {
                                background: rgba(16, 185, 129, 0.12);
                                color: var(--success);
                            }

                            .status-fail {
                                background: rgba(239, 68, 68, 0.12);
                                color: #EF4444;
                            }

                            .sidebar-overlay {
                                display: none;
                                position: fixed;
                                inset: 0;
                                background: rgba(15, 23, 42, 0.5);
                                z-index: 999;
                            }

                            @media (max-width: 992px) {
                                .sidebar {
                                    transform: translateX(-100%);
                                }

                                .sidebar.open {
                                    transform: translateX(0);
                                }

                                .main-wrapper {
                                    margin-left: 0;
                                }

                                .menu-toggle-btn {
                                    display: block;
                                }

                                .sidebar-overlay.active {
                                    display: block;
                                }
                            }
                        </style>
                    </head>

                    <body>
                        <div class="sidebar-overlay" id="sidebarOverlay"></div>

                        <aside class="sidebar" id="sidebar">
                            <div class="sidebar-brand">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                                    stroke-linecap="round" stroke-linejoin="round">
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
                                            <path d="M23 21v-2a4 4 0 0 3-3.87" />
                                            <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                                        </svg>
                                        <span>Assigned Students</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="cce-marks.jsp">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 2 2h12a2 2 0 0 2 2-2V8z" />
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
                                <li class="nav-item active">
                                    <a href="results.jsp">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                            <polygon
                                                points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                                        </svg>
                                        <span>View Results</span>
                                    </a>
                                </li>
                                <li class="nav-item">
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
                                    <button class="menu-toggle-btn" id="menuToggleBtn">
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <line x1="3" y1="12" x2="21" y2="12" />
                                            <line x1="3" y1="6" x2="21" y2="6" />
                                            <line x1="3" y1="18" x2="21" y2="18" />
                                        </svg>
                                    </button>
                                    <h1 class="page-title">Class Results & Analysis</h1>
                                </div>

                                <div class="top-right">
                                    <div class="user-profile-badge">
                                        <div class="user-avatar">
                                            <%= teacherInitial %>
                                        </div>
                                        <div class="user-info-text">
                                            <span class="user-name">
                                                <%= teacherFirstName %>
                                            </span>
                                            <span class="user-role-label">Teacher</span>
                                        </div>
                                    </div>
                                </div>
                            </header>

                            <main class="content-area">
                                <div class="container">
                                    <!-- Stat Topper Cards -->
                                    <div class="stats-grid">
                                        <div class="stat-card topper-card">
                                            <div class="stat-info">
                                                <h4>Class Highest Scorer</h4>
                                                <div class="topper-name-row">
                                                    <span id="overallTopperName">--</span>
                                                    <span class="topper-badge badge-gold" id="overallTopperBadge">-- /
                                                        100</span>
                                                </div>
                                                <div class="topper-subtext" id="overallTopperSubtext">Roll No: -- &bull;
                                                    -- Marks</div>
                                            </div>
                                            <div class="stat-icon-wrap icon-gold">
                                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path
                                                        d="M6 9H4.5a2.5 2.5 0 0 1 0-5H6M18 9h1.5a2.5 2.5 0 0 0 0-5H18M4 22h16M10 14.66V17c0 .55-.45 1-1 1H7M14 14.66V17c0 .55.45 1 1 1h2" />
                                                    <path d="M18 2H6v7a6 6 0 0 0 12 0V2z" />
                                                </svg>
                                            </div>
                                        </div>

                                        <div class="stat-card subject-topper-card">
                                            <div class="stat-info">
                                                <h4>Subject Topper</h4>
                                                <div class="topper-name-row">
                                                    <span id="subjectTopperName">--</span>
                                                    <span id="subjectTopperScore" class="topper-badge badge-purple">-- /
                                                        100</span>
                                                </div>
                                                <div class="topper-subtext">Subject: <span id="subjectTopperCode"
                                                        style="font-weight: 700;">--</span> &bull; <span
                                                        id="subjectTopperRoll" style="font-weight:700;">Roll --</span>
                                                </div>
                                            </div>
                                            <div class="stat-icon-wrap icon-purple">
                                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <polygon
                                                        points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                                                </svg>
                                            </div>
                                        </div>

                                        <div class="stat-card">
                                            <div class="stat-info">
                                                <h4>Class Performance</h4>
                                                <div class="topper-name-row">
                                                    <span id="passPercentageStat">--%</span>
                                                    <span class="topper-badge badge-gold"
                                                        style="background: rgba(16, 185, 129, 0.12); color: var(--success);"
                                                        id="passCountStat">-- Passed</span>
                                                </div>
                                                <div class="topper-subtext" id="totalEvaluatedStat">Total Evaluated: --
                                                </div>
                                            </div>
                                            <div class="stat-icon-wrap icon-blue">
                                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <line x1="18" y1="20" x2="18" y2="10" />
                                                    <line x1="12" y1="20" x2="12" y2="4" />
                                                    <line x1="6" y1="20" x2="6" y2="14" />
                                                </svg>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Main Content Card with Filters & Table -->
                                    <div class="content-card">
                                        <div class="card-header-row">
                                            <h3>
                                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2"
                                                    style="color: var(--primary-blue);">
                                                    <polygon
                                                        points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                                                </svg>
                                                Detailed Student Results
                                            </h3>

                                            <!-- Filtering & Sorting Dropdowns -->
                                            <div class="filter-controls-group">
                                                <span class="filter-label">Filter Subject:</span>
                                                <select class="custom-select" id="subjectFilterSelect"
                                                    onchange="filterAndSortResults()">
                                                    <option value="ALL">All Subjects</option>
                                                    <% if (teacherAssignedSubjects !=null &&
                                                        !teacherAssignedSubjects.isEmpty()) { for (TeacherSubject ts :
                                                        teacherAssignedSubjects) { if (ts !=null && ts.getSubject()
                                                        !=null) { Subject sub=ts.getSubject(); boolean
                                                        isSel=(sub.getId()==selectedSubjectId); %>
                                                        <option value="<%= sub.getSubjectCode() %>" <%=isSel
                                                            ? "selected" : "" %>>
                                                            <%= sub.getSubjectCode() %> - <%= sub.getSubjectName() %>
                                                        </option>
                                                        <% } } } %>
                                                </select>

                                                <span class="filter-label" style="margin-left: 0.5rem;">Year:</span>
                                                <select class="custom-select" id="yearFilterSelect"
                                                    onchange="filterAndSortResults()">
                                                    <option value="ALL" selected>All Years</option>
                                                    <option value="First Year">First Year</option>
                                                    <option value="Second Year">Second Year</option>
                                                    <option value="Third Year">Third Year</option>
                                                    <option value="Final Year">Final Year</option>
                                                </select>

                                                <span class="filter-label"
                                                    style="margin-left: 0.5rem;">Department:</span>
                                                <select class="custom-select" id="deptFilterSelect"
                                                    onchange="filterAndSortResults()">
                                                    <option value="ALL" selected>All Depts</option>
                                                    <option value="Computer Engineering">Computer Engineering</option>
                                                    <option value="Information Technology">Information Technology
                                                    </option>
                                                    <option value="ENTC">ENTC</option>
                                                    <option value="Civil Engineering">Civil Engineering</option>
                                                    <option value="Mechanical Engineering">Mechanical Engineering
                                                    </option>
                                                </select>

                                                <span class="filter-label" style="margin-left: 0.5rem;">Sort By:</span>
                                                <select class="custom-select" id="sortSelect"
                                                    onchange="filterAndSortResults()">
                                                    <option value="MARKS_DESC" selected>Topper First (Highest Marks)
                                                    </option>
                                                    <option value="ROLL_ASC">Roll Number (Ascending)</option>
                                                    <option value="NAME_ASC">Student Name (A-Z)</option>
                                                    <option value="PASS_FIRST">Status (Pass First)</option>
                                                </select>
                                            </div>
                                        </div>

                                        <!-- Results Data Table -->
                                        <div class="table-responsive">
                                            <table class="data-table" id="resultsTable">
                                                <thead>
                                                    <tr>
                                                        <th style="text-align: center;">Sr No</th>
                                                        <th style="text-align: center;">Roll No</th>
                                                        <th style="text-align: left;">Student Name</th>
                                                        <th style="text-align: left;">Email ID</th>
                                                        <th style="text-align: center;">Year</th>
                                                        <th style="text-align: center;">Semester</th>
                                                        <th style="text-align: center;">CCE Internal (/50)</th>
                                                        <th style="text-align: center;">End Sem Theory (/50)</th>
                                                        <th style="text-align: center;">Subject Total (/100)</th>
                                                        <th style="text-align: center;">Subject Grade</th>
                                                        <th style="text-align: center;">Status</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="tableBody">
                                                    <% int totalEvaluated=0; int passCount=0; if (allAssignments !=null
                                                        && !allAssignments.isEmpty()) { int rowIdx=1; for
                                                        (StudentSubjectAssignment ssa : allAssignments) { if (ssa==null
                                                        || ssa.getStudent()==null || ssa.getSubject()==null) continue;
                                                        Student student=ssa.getStudent(); Subject sub=ssa.getSubject();
                                                        StudentSubjectMarks
                                                        mark=marksService.getMarksByStudentSubjectTeacher(student.getId(),
                                                        sub.getId(), teacherId); double cceInt=(mark !=null) ?
                                                        mark.getInternalMarks() : 0.0; double endSem=(mark !=null) ?
                                                        mark.getEndSemesterMarks() : 0.0; double total=(mark !=null) ?
                                                        mark.getTotalMarks() : (cceInt + endSem); String grade=(mark
                                                        !=null && mark.getGrade() !=null) ? mark.getGrade() : "F" ;
                                                        String status=(mark !=null && mark.getResultStatus() !=null) ?
                                                        mark.getResultStatus() : (total>= 40 ? "Pass" : "Fail");
                                                        String yearVal = (student.getYear() != null) ? student.getYear()
                                                        : "Third Year";
                                                        String semVal = (student.getSemester() != null) ?
                                                        student.getSemester() : "Semester 5";
                                                        String deptVal = (student.getDepartment() != null) ?
                                                        student.getDepartment() : "Computer Engineering";
                                                        String rollVal = (student.getRollNo() != null &&
                                                        !student.getRollNo().isEmpty()) ? student.getRollNo() :
                                                        String.valueOf(student.getId());
                                                        totalEvaluated++;
                                                        if ("Pass".equalsIgnoreCase(status)) passCount++;
                                                        if (total > overallMaxTotal)
                                                        {
                                                        overallMaxTotal = total;
                                                        overallTopperName = student.getName();
                                                        overallTopperRoll = rollVal;
                                                        }
                                                        if (total > subjectMaxTotal)
                                                        {
                                                        subjectMaxTotal = total;
                                                        subjectTopperName = student.getName();
                                                        subjectTopperRoll = rollVal;
                                                        subjectTopperCode = sub.getSubjectCode();
                                                        }
                                                        String gradeClass = "grade-f";
                                                        if ("O".equalsIgnoreCase(grade)) gradeClass = "grade-o";
                                                        else if ("A+".equalsIgnoreCase(grade)) gradeClass =
                                                        "grade-aplus";
                                                        else if ("A".equalsIgnoreCase(grade)) gradeClass = "grade-a";
                                                        else if ("B+".equalsIgnoreCase(grade)) gradeClass =
                                                        "grade-bplus";
                                                        else if ("B".equalsIgnoreCase(grade)) gradeClass = "grade-b";
                                                        else if ("C".equalsIgnoreCase(grade)) gradeClass = "grade-c";
                                                        String statusClass = "Pass".equalsIgnoreCase(status) ?
                                                        "status-pass" : "status-fail";
                                                        %>
                                                        <tr data-subject="<%= sub.getSubjectCode() %>"
                                                            data-year="<%= yearVal %>" data-dept="<%= deptVal %>"
                                                            data-total="<%= total %>" data-roll="<%= rollVal %>"
                                                            data-name="<%= student.getName() %>"
                                                            data-status="<%= status %>">
                                                            <td style="text-align: center; font-weight: 700; color: var(--text-muted);"
                                                                class="row-sr-no">
                                                                <%= rowIdx++ %>
                                                            </td>
                                                            <td
                                                                style="text-align: center; font-weight: 700; color: var(--primary-blue);">
                                                                <%= rollVal %>
                                                            </td>
                                                            <td
                                                                style="text-align: left; font-weight: 700; color: var(--text-main);">
                                                                <%= student.getName() %>
                                                            </td>
                                                            <td
                                                                style="text-align: left; font-weight: 600; color: var(--text-main);">
                                                                <%= student.getEmail() !=null ? student.getEmail() : "-"
                                                                    %>
                                                            </td>
                                                            <td
                                                                style="text-align: center; font-weight: 600; color: var(--primary-navy);">
                                                                <%= yearVal %>
                                                            </td>
                                                            <td
                                                                style="text-align: center; font-weight: 600; color: var(--primary-navy);">
                                                                <%= semVal %>
                                                            </td>
                                                            <td style="text-align: center; font-weight: 600;">
                                                                <%= (int) cceInt %> / 50
                                                            </td>
                                                            <td style="text-align: center; font-weight: 600;">
                                                                <%= (int) endSem %> / 50
                                                            </td>
                                                            <td
                                                                style="text-align: center; font-weight: 700; color: var(--primary-navy);">
                                                                <%= (int) total %> / 100
                                                            </td>
                                                            <td style="text-align: center;">
                                                                <span class="grade-badge <%= gradeClass %>">
                                                                    <%= grade %>
                                                                </span>
                                                            </td>
                                                            <td style="text-align: center;">
                                                                <span class="status-pill <%= statusClass %>">
                                                                    <%= status %>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <% } } else { %>
                                                            <tr id="noResultsRow">
                                                                <td colspan="11"
                                                                    style="text-align: center; color: var(--text-muted); padding: 30px; font-weight: 500;">
                                                                    No student result records found.
                                                                </td>
                                                            </tr>
                                                            <% } %>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </main>
                        </div>

                        <!-- Interactive Filter & Sort Script -->
                        <script>
                            document.addEventListener('DOMContentLoaded', function () {
                                const menuToggleBtn = document.getElementById('menuToggleBtn');
                                const sidebar = document.getElementById('sidebar');
                                const sidebarOverlay = document.getElementById('sidebarOverlay');
                                function toggleSidebar() { sidebar.classList.toggle('open'); sidebarOverlay.classList.toggle('active'); }
                                if (menuToggleBtn) {
                                    menuToggleBtn.addEventListener('click', toggleSidebar);
                                    sidebarOverlay.addEventListener('click', toggleSidebar);
                                }

                                // Populate Topper Cards dynamically from rendered data
                                updateTopperStats();
                            });

                            function filterAndSortResults() {
                                const selectedSub = document.getElementById('subjectFilterSelect').value;
                                const selectedYear = document.getElementById('yearFilterSelect').value;
                                const selectedDept = document.getElementById('deptFilterSelect').value;
                                const selectedSort = document.getElementById('sortSelect').value;

                                const tbody = document.getElementById('tableBody');
                                const rows = Array.from(tbody.querySelectorAll('tr:not(#noResultsRow)'));

                                let visibleRows = [];

                                rows.forEach(row => {
                                    const rowSub = row.getAttribute('data-subject') || '';
                                    const rowYear = row.getAttribute('data-year') || '';
                                    const rowDept = row.getAttribute('data-dept') || '';

                                    const subMatch = (selectedSub === 'ALL' || rowSub === selectedSub);
                                    const yearMatch = (selectedYear === 'ALL' || rowYear === selectedYear);
                                    const deptMatch = (selectedDept === 'ALL' || rowDept === selectedDept);

                                    if (subMatch && yearMatch && deptMatch) {
                                        row.style.display = '';
                                        visibleRows.push(row);
                                    } else {
                                        row.style.display = 'none';
                                    }
                                });

                                // Sorting visible rows
                                visibleRows.sort((a, b) => {
                                    if (selectedSort === 'MARKS_DESC') {
                                        return parseFloat(b.getAttribute('data-total')) - parseFloat(a.getAttribute('data-total'));
                                    } else if (selectedSort === 'ROLL_ASC') {
                                        return (a.getAttribute('data-roll') || '').localeCompare(b.getAttribute('data-roll') || '');
                                    } else if (selectedSort === 'NAME_ASC') {
                                        return (a.getAttribute('data-name') || '').localeCompare(b.getAttribute('data-name') || '');
                                    } else if (selectedSort === 'PASS_FIRST') {
                                        const statusA = a.getAttribute('data-status') || '';
                                        const statusB = b.getAttribute('data-status') || '';
                                        if (statusA === statusB) return 0;
                                        return statusA === 'Pass' ? -1 : 1;
                                    }
                                    return 0;
                                });

                                // Re-append sorted rows and update Sr No
                                let srNo = 1;
                                visibleRows.forEach(row => {
                                    tbody.appendChild(row);
                                    const srCell = row.querySelector('.row-sr-no');
                                    if (srCell) srCell.textContent = srNo++;
                                });

                                updateTopperStats(visibleRows);
                            }

                            function updateTopperStats(rows) {
                                if (!rows) {
                                    const tbody = document.getElementById('tableBody');
                                    rows = Array.from(tbody.querySelectorAll('tr:not(#noResultsRow)')).filter(r => r.style.display !== 'none');
                                }

                                if (rows.length === 0) {
                                    document.getElementById('overallTopperName').textContent = '--';
                                    document.getElementById('overallTopperBadge').textContent = '-- / 100';
                                    document.getElementById('overallTopperSubtext').textContent = 'Roll No: --';

                                    document.getElementById('subjectTopperName').textContent = '--';
                                    document.getElementById('subjectTopperScore').textContent = '-- / 100';
                                    document.getElementById('subjectTopperCode').textContent = '--';
                                    document.getElementById('subjectTopperRoll').textContent = 'Roll --';

                                    document.getElementById('passPercentageStat').textContent = '0%';
                                    document.getElementById('passCountStat').textContent = '0 Passed';
                                    document.getElementById('totalEvaluatedStat').textContent = 'Total Evaluated: 0';
                                    return;
                                }

                                let maxTotal = -1;
                                let topperRow = null;
                                let passCount = 0;

                                rows.forEach(r => {
                                    const total = parseFloat(r.getAttribute('data-total')) || 0;
                                    const status = r.getAttribute('data-status') || '';
                                    if (status.toLowerCase() === 'pass') passCount++;

                                    if (total > maxTotal) {
                                        maxTotal = total;
                                        topperRow = r;
                                    }
                                });

                                if (topperRow) {
                                    const name = topperRow.getAttribute('data-name');
                                    const roll = topperRow.getAttribute('data-roll');
                                    const sub = topperRow.getAttribute('data-subject');

                                    document.getElementById('overallTopperName').textContent = name;
                                    document.getElementById('overallTopperBadge').textContent = Math.round(maxTotal) + ' / 100';
                                    document.getElementById('overallTopperSubtext').textContent = 'Roll No: ' + roll;

                                    document.getElementById('subjectTopperName').textContent = name;
                                    document.getElementById('subjectTopperScore').textContent = Math.round(maxTotal) + ' / 100';
                                    document.getElementById('subjectTopperCode').textContent = sub;
                                    document.getElementById('subjectTopperRoll').textContent = 'Roll ' + roll;
                                }

                                const totalCount = rows.length;
                                const passPct = Math.round((passCount / totalCount) * 100);

                                document.getElementById('passPercentageStat').textContent = passPct + '%';
                                document.getElementById('passCountStat').textContent = passCount + ' Passed';
                                document.getElementById('totalEvaluatedStat').textContent = 'Total Evaluated: ' + totalCount;
                            }
                        </script>
                        <jsp:include page="/logout-modal.jsp" />
                    </body>

                    </html>