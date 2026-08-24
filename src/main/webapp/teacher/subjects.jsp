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
        com.student.entity.Teacher loggedInTeacher = (com.student.entity.Teacher) session.getAttribute("teacher");
        String teacherFirstName = "Teacher" ;
        String teacherInitial = "T" ;
        if (loggedInTeacher != null && loggedInTeacher.getName() != null && !loggedInTeacher.getName().trim().isEmpty())
        {
            teacherFirstName = loggedInTeacher.getName().trim();
            if (!teacherFirstName.isEmpty())
            {
                teacherInitial = String.valueOf(teacherFirstName.charAt(0)).toUpperCase();
            }
        }
        TeacherSubjectService teacherSubjectService = new TeacherSubjectService();
        StudentSubjectAssignmentService ssaService = new StudentSubjectAssignmentService();
        java.util.List<com.student.entity.TeacherSubject> myTeacherSubjects = new java.util.ArrayList<>();
        if (loggedInTeacher != null)
        {
            java.util.List<com.student.entity.TeacherSubject> allTS = teacherSubjectService.getAllTeacherSubjects();
            for (com.student.entity.TeacherSubject ts : allTS)
            {
                if (ts.getTeacher() != null && ts.getTeacher().getId() == loggedInTeacher.getId())
                {
                    myTeacherSubjects.add(ts);
                }
            }
        }
        int acceptedCount = myTeacherSubjects.size();
    %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>My Subjects - Student Management System</title>
                    
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
                            --success: #16A34A;
                            --error: #DC2626;
                            --warning: #F59E0B;

                            --sidebar-width: 275px;
                            --topbar-height: 70px;

                            --radius-sm: 8px;
                            --radius-md: 14px;
                            --radius-lg: 20px;

                            --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.04);
                            --shadow-md: 0 10px 25px -5px rgba(30, 58, 95, 0.06), 0 8px 10px -6px rgba(30, 58, 95, 0.02);
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
                            overflow-y: auto;
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

                        /* Main Layout & Topbar */
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
                            padding: 0.4rem 0.75rem;
                            border-radius: 50px;
                            background: var(--bg-main);
                            border: 1px solid var(--border);
                        }

                        .user-avatar {
                            width: 34px;
                            height: 34px;
                            border-radius: 50%;
                            background: var(--primary-navy);
                            color: #FFFFFF;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-weight: 700;
                            font-size: 0.9rem;
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

                        .dashboard-container {
                            max-width: 1200px;
                            margin: 0 auto;
                            display: flex;
                            flex-direction: column;
                            gap: 2rem;
                        }

                        .content-card {
                            background: var(--card-bg);
                            border: 1px solid var(--border);
                            border-radius: var(--radius-md);
                            padding: 1.75rem;
                            box-shadow: var(--shadow-sm);
                        }

                        .btn {
                            display: inline-flex;
                            align-items: center;
                            justify-content: center;
                            padding: 0.75rem 1.5rem;
                            border-radius: var(--radius-sm);
                            font-size: 0.9rem;
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

                            .content-area {
                                padding: 1.25rem;
                            }
                        }
                    </style>
                </head>

                <body>

                    <div class="sidebar-overlay" id="sidebarOverlay"></div>

                    <!-- Sidebar -->
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
                            <li class="nav-item active">
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
                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                                    </svg>
                                    <span>Assigned Students</span>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="cce-marks.jsp">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                        <polyline points="14 2 14 8 20 8" />
                                        <line x1="16" y1="13" x2="8" y2="13" />
                                        <line x1="16" y1="17" x2="8" y2="17" />
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

                    <!-- Main Wrapper -->
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
                                <h1 class="page-title">Assigned Subjects</h1>
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
                            <div class="dashboard-container">

                                <!-- Hero Header Card -->
                                <section class="content-card">
                                    <div
                                        style="display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:1rem;">
                                        <div>
                                            <h2
                                                style="font-size:1.4rem; font-weight:800; color:var(--primary-navy); margin-bottom:0.25rem;">
                                                Accepted Academic Curriculum</h2>
                                            <p style="font-size:0.9rem; color:var(--text-muted); margin:0;">Overview of
                                                subjects you have accepted for instruction and evaluation.</p>
                                        </div>
                                        <span id="acceptedBadge"
                                            style="background:#ECFDF5; color:#047857; border:1px solid #A7F3D0; font-size:0.85rem; font-weight:800; padding:0.4rem 1rem; border-radius:50px;">
                                            Accepted Subjects: <%= acceptedCount %>
                                        </span>
                                    </div>
                                </section>

                                <!-- Subjects Cards Grid -->
                                <section class="content-card">
                                    <div id="acceptedCardsContainer"
                                        style="display:grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap:1.25rem;">
                                        <%
                                            if (myTeacherSubjects != null && !myTeacherSubjects.isEmpty())
                                            {
                                                for (com.student.entity.TeacherSubject ts : myTeacherSubjects)
                                                {
                                                    com.student.entity.Subject sub = ts.getSubject();
                                                    long stCount = ssaService.getAssignedCount(loggedInTeacher.getId(), sub.getId());
                                                    int sem = 5;
                                                    try
                                                    {
                                                        if (sub.getSemester() != null) sem = Integer.parseInt(sub.getSemester().replaceAll("[^0-9]", "" ));
                                                    }
                                                    catch (Exception ignored)
                                                    {
                                                    }
                                        %>
                                            <div
                                                style="background:#FFFFFF; border: 1.5px solid #E2E8F0; border-radius: 14px; padding: 1.35rem; display: flex; flex-direction: column; justify-content: space-between; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.03); transition: var(--transition);">
                                                <div>
                                                    <div
                                                        style="display:flex; align-items:center; justify-content:space-between; margin-bottom:0.85rem;">
                                                        <span
                                                            style="font-size:0.75rem; font-weight:800; background:#ECFDF5; color:#047857; border:1px solid #A7F3D0; padding:0.25rem 0.65rem; border-radius:50px;">ACCEPTED</span>
                                                        <div
                                                            style="display:flex; flex-direction:column; align-items:flex-end; gap:0.15rem;">
                                                            <span
                                                                style="font-size:0.75rem; font-weight:600; color:#64748B;">Students:
                                                                <strong>
                                                                    <%= stCount %>
                                                                </strong></span>
                                                            <span
                                                                style="font-size:0.75rem; font-weight:600; color:#64748B;">Credit:
                                                                <strong>
                                                                    <%= (sub.getCredit() !=null ? sub.getCredit() : "--"
                                                                        ) %>
                                                                </strong></span>
                                                        </div>
                                                    </div>
                                                    <h3
                                                        style="font-size:1.25rem; font-weight:800; color:var(--primary-navy); margin-bottom:0.6rem;">
                                                        <%= sub.getSubjectName() %>
                                                    </h3>
                                                    <div
                                                        style="display:flex; flex-wrap:wrap; gap:0.4rem; margin-bottom:1.25rem;">
                                                        <span
                                                            style="font-size:0.75rem; font-weight:700; padding:0.2rem 0.65rem; border-radius:20px; background:#F1F5F9; color:#1E293B;">
                                                            <%= sub.getCourse() !=null ? sub.getCourse() : "BTech" %>
                                                        </span>
                                                        <span
                                                            style="font-size:0.75rem; font-weight:700; padding:0.2rem 0.65rem; border-radius:20px; background:#EFF6FF; color:#1D4ED8;">
                                                            <%= sub.getDepartment() !=null ? sub.getDepartment()
                                                                : "Engineering" %>
                                                        </span>
                                                        <span
                                                            style="font-size:0.75rem; font-weight:700; padding:0.2rem 0.65rem; border-radius:20px; background:#FEF3C7; color:#B45309;">Semester
                                                            <%= sem %>
                                                        </span>
                                                    </div>
                                                </div>
                                                <a href="students.jsp?subjectId=<%= sub.getId() %>"
                                                    class="btn btn-outline"
                                                    style="width:100%; font-size:0.85rem; font-weight:700; padding:0.6rem; display:flex; align-items:center; justify-content:center; gap:0.4rem;">
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                        <circle cx="9" cy="7" r="4" />
                                                    </svg>
                                                    View Students
                                                </a>
                                            </div>
                                            <%
                                                }
                                                }
                                                else
                                                {
                                            %>
                                                <div
                                                    style="grid-column: 1 / -1; padding: 3rem 1.5rem; text-align: center; background: #F8FAFC; border: 1.5px dashed #CBD5E1; border-radius: 14px;">
                                                    <svg width="42" height="42" viewBox="0 0 24 24" fill="none"
                                                        stroke="#64748B" stroke-width="1.8"
                                                        style="margin-bottom:0.75rem;">
                                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                        <path
                                                            d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                    </svg>
                                                    <h3
                                                        style="font-size: 1.1rem; font-weight: 800; color: var(--primary-navy); margin-bottom: 0.35rem;">
                                                        No Subjects Accepted Yet</h3>
                                                    <p
                                                        style="font-size: 0.875rem; color: var(--text-muted); margin-bottom: 1.25rem;">
                                                        Pending subject assignments will appear here once accepted from
                                                        the Dashboard.</p>
                                                    <a href="dashboard.jsp" class="btn btn-primary btn-sm"
                                                        style="padding:0.65rem 1.25rem; font-weight:700;">Go to
                                                        Dashboard &rarr;</a>
                                                </div>
                                                <%
                                                    }
                                                %>
                                    </div>
                                </section>

                            </div>
                        </main>
                    </div>

                    <!-- Vanilla JS Script -->
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
                    </script>
                    <jsp:include page="/logout-modal.jsp" />
                </body>

                </html>