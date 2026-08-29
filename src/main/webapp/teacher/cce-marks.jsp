<%@ page language = "java" contentType = "text/html; charset = UTF-8" pageEncoding = "UTF-8" %>
    <%@ page import = "java.util.List, java.util.Collections" %>
        <%@ page import = "com.student.entity.*, com.student.service.*" %>
            <%
                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
                response.setHeader("Pragma", "no-cache" );
                response.setDateHeader("Expires", 0);
                if (session == null || session.getAttribute("teacher") == null)
                {
                    response.sendRedirect(request.getContextPath() + "/login.jsp" );
                    return;
                }
                Teacher loggedInTeacher = (Teacher) session.getAttribute("teacher");
                String teacherFirstName = "Teacher" ;
                String teacherInitial = "T" ;
                int teacherId = 0;
                if (loggedInTeacher != null)
                {
                    teacherId = loggedInTeacher.getId();
                    if (loggedInTeacher.getName() != null && !loggedInTeacher.getName().trim().isEmpty())
                    {
                        teacherFirstName = loggedInTeacher.getName().trim();
                        if (!teacherFirstName.isEmpty())
                        {
                            teacherInitial = String.valueOf(teacherFirstName.charAt(0)).toUpperCase();
                        }
                    }
                }
                TeacherSubjectService tsService = new TeacherSubjectService();
                StudentSubjectAssignmentService ssaService = new StudentSubjectAssignmentService();
                StudentSubjectMarksService marksService = new StudentSubjectMarksService();
                List<TeacherSubject> teacherAssignedSubjects = (teacherId > 0) ? tsService.getTeacherSubjectsByTeacherId(teacherId) : Collections.emptyList();
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
                String activeSubjectName = "No Assigned Subject";
                if (teacherAssignedSubjects != null && !teacherAssignedSubjects.isEmpty())
                {
                    for (TeacherSubject ts : teacherAssignedSubjects)
                    {
                        if (ts.getSubject() != null && ts.getSubject().getId() == selectedSubjectId)
                        {
                            activeSubjectName = ts.getSubject().getSubjectCode() + " - " + ts.getSubject().getSubjectName();
                            break;
                        }
                    }
                    if ("No Assigned Subject".equals(activeSubjectName) && !teacherAssignedSubjects.isEmpty() && teacherAssignedSubjects.get(0) != null && teacherAssignedSubjects.get(0).getSubject() != null)
                    {
                        Subject s0 = teacherAssignedSubjects.get(0).getSubject();
                        activeSubjectName = s0.getSubjectCode() + " - " + s0.getSubjectName();
                    }
                }
                List<StudentSubjectAssignment> assignedStudents = (teacherId > 0 && selectedSubjectId > 0) ? ssaService.getAssignmentsByTeacherAndSubject(teacherId, selectedSubjectId) : Collections.emptyList();
            %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>CCE Marks - Teacher Dashboard</title>
                        
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
                                color: var(--text-main);
                                cursor: pointer;
                            }

                            .page-title {
                                font-size: 1.35rem;
                                font-weight: 700;
                                color: var(--text-main);
                            }

                            .top-right {
                                display: flex;
                                align-items: center;
                                gap: 1.25rem;
                            }

                            .icon-btn {
                                background: var(--bg-main);
                                border: 1px solid var(--border);
                                width: 40px;
                                height: 40px;
                                border-radius: 50%;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                color: var(--text-muted);
                                cursor: pointer;
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
                                padding: 2rem;
                                flex: 1;
                            }

                            .container {
                                max-width: 1250px;
                                margin: 0 auto;
                                display: flex;
                                flex-direction: column;
                                gap: 1.5rem;
                            }

                            /* Stats Summary Grid */
                            .stats-grid {
                                display: grid;
                                grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                                gap: 1.25rem;
                            }

                            .stat-card {
                                background: var(--card-bg);
                                border-radius: var(--radius-md);
                                padding: 1.25rem 1.5rem;
                                border: 1px solid var(--border);
                                box-shadow: var(--shadow-sm);
                                display: flex;
                                align-items: center;
                                justify-content: space-between;
                            }

                            .stat-info h4 {
                                font-size: 0.775rem;
                                font-weight: 700;
                                color: var(--text-muted);
                                text-transform: uppercase;
                                letter-spacing: 0.05em;
                                margin-bottom: 0.35rem;
                            }

                            .stat-info div {
                                font-size: 1.25rem;
                                font-weight: 800;
                                color: var(--primary-navy);
                            }

                            .stat-icon-wrap {
                                width: 44px;
                                height: 44px;
                                border-radius: 12px;
                                background: var(--light-blue);
                                color: var(--primary-blue);
                                display: flex;
                                align-items: center;
                                justify-content: center;
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
                                flex-wrap: wrap;
                                gap: 1rem;
                                margin-bottom: 1.25rem;
                                padding-bottom: 1rem;
                                border-bottom: 1px solid var(--border);
                            }

                            .card-header-row h3 {
                                font-size: 1.15rem;
                                font-weight: 700;
                                color: var(--primary-navy);
                                display: flex;
                                align-items: center;
                                gap: 0.5rem;
                            }

                            .subject-selector {
                                padding: 0.65rem 1rem;
                                border-radius: var(--radius-sm);
                                border: 1.5px solid var(--border);
                                font-size: 0.875rem;
                                font-weight: 500;
                                background: #FFFFFF;
                                color: var(--text-main);
                                cursor: pointer;
                                outline: none;
                                transition: var(--transition);
                            }

                            .subject-selector:focus {
                                border-color: var(--primary-blue);
                                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
                            }

                            .table-responsive {
                                width: 100%;
                                overflow-x: auto;
                            }

                            .data-table {
                                width: 100%;
                                border-collapse: collapse;
                                text-align: left;
                                font-size: 0.875rem;
                            }

                            .data-table th {
                                background: var(--bg-main);
                                padding: 0.85rem 0.75rem;
                                font-weight: 700;
                                color: var(--text-muted);
                                text-transform: uppercase;
                                font-size: 0.725rem;
                                letter-spacing: 0.05em;
                                border-bottom: 1px solid var(--border);
                            }

                            .data-table td {
                                padding: 0.85rem 0.75rem;
                                border-bottom: 1px solid var(--border);
                                color: var(--text-main);
                                font-weight: 500;
                                vertical-align: middle;
                            }

                            .data-table tr:hover td {
                                background: var(--light-blue);
                            }

                            .student-profile-cell {
                                display: flex;
                                align-items: center;
                                gap: 0.75rem;
                            }

                            .student-avatar-circle {
                                width: 34px;
                                height: 34px;
                                border-radius: 50%;
                                background: linear-gradient(135deg, #2563EB, #1E3A5F);
                                color: #FFFFFF;
                                font-weight: 700;
                                font-size: 0.825rem;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                flex-shrink: 0;
                            }

                            /* Dual Input Cell Box - Vertical Stack Layout */
                            .cce-input-cell {
                                display: flex;
                                flex-direction: column;
                                align-items: center;
                                justify-content: center;
                                gap: 0.25rem;
                            }

                            .cce-inputs-row {
                                display: flex;
                                align-items: center;
                                gap: 0.2rem;
                            }

                            .input-marks {
                                width: 38px;
                                padding: 0.3rem 0.15rem;
                                border: 1px solid var(--border);
                                border-radius: 6px;
                                font-weight: 700;
                                font-size: 0.825rem;
                                text-align: center;
                                color: var(--primary-navy);
                                background: var(--card-bg);
                                outline: none;
                                transition: var(--transition);
                            }

                            .input-marks:focus {
                                border-color: var(--primary-blue);
                                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
                            }

                            .input-plus {
                                font-size: 0.775rem;
                                font-weight: 700;
                                color: var(--text-muted);
                            }

                            .att-badge {
                                font-size: 0.65rem;
                                font-weight: 700;
                                padding: 0.15rem 0.35rem;
                                border-radius: 12px;
                                white-space: nowrap;
                            }

                            .att-100 {
                                background: rgba(16, 185, 129, 0.1);
                                color: var(--success);
                            }

                            .att-50 {
                                background: rgba(245, 158, 11, 0.1);
                                color: var(--warning);
                            }

                            .att-0 {
                                background: rgba(239, 68, 68, 0.1);
                                color: #EF4444;
                            }

                            .total-marks-badge {
                                font-size: 0.875rem;
                                font-weight: 800;
                                color: var(--primary-navy);
                                background: rgba(37, 99, 235, 0.08);
                                padding: 0.35rem 0.65rem;
                                border-radius: 8px;
                                display: inline-block;
                                border: 1px solid rgba(37, 99, 235, 0.2);
                                white-space: nowrap;
                            }

                            .status-pill {
                                font-size: 0.75rem;
                                font-weight: 700;
                                padding: 0.2rem 0.6rem;
                                border-radius: 12px;
                                display: inline-block;
                                white-space: nowrap;
                            }

                            .status-pass {
                                background: rgba(16, 185, 129, 0.1);
                                color: var(--success);
                            }

                            .status-fail {
                                background: rgba(239, 68, 68, 0.1);
                                color: #EF4444;
                            }

                            .data-table th {
                                background: var(--bg-main);
                                padding: 0.85rem 1rem;
                                font-weight: 700;
                                color: var(--text-muted);
                                text-transform: uppercase;
                                font-size: 0.725rem;
                                letter-spacing: 0.05em;
                                border-bottom: 1px solid var(--border);
                                white-space: nowrap;
                            }

                            .data-table td {
                                padding: 0.85rem 0.75rem;
                                border-bottom: 1px solid var(--border);
                                color: var(--text-main);
                                font-weight: 500;
                                vertical-align: middle;
                                white-space: nowrap;
                            }

                            .total-marks-badge {
                                background: transparent;
                                color: var(--primary-navy);
                                padding: 0.25rem 0.5rem;
                                border-radius: 6px;
                                font-weight: 800;
                                font-size: 0.95rem;
                                display: inline-block;
                                white-space: nowrap;
                            }

                            .btn-save-all {
                                padding: 0.55rem 1.25rem;
                                background: var(--primary-blue);
                                color: #FFFFFF;
                                border: none;
                                border-radius: var(--radius-sm);
                                font-weight: 700;
                                font-size: 0.875rem;
                                cursor: pointer;
                                display: flex;
                                align-items: center;
                                gap: 0.5rem;
                                transition: var(--transition);
                                box-shadow: 0 2px 8px rgba(37, 99, 235, 0.25);
                            }

                            .btn-save-all:hover {
                                background: var(--primary-blue-hover);
                            }

                            .btn-print {
                                padding: 0.55rem 1.1rem;
                                background: var(--primary-navy);
                                color: #FFFFFF;
                                border: none;
                                border-radius: var(--radius-sm);
                                font-weight: 700;
                                font-size: 0.875rem;
                                cursor: pointer;
                                display: flex;
                                align-items: center;
                                gap: 0.5rem;
                                transition: var(--transition);
                                box-shadow: 0 2px 8px rgba(30, 58, 95, 0.2);
                            }

                            /* Custom Horizontal Scrollbar */
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

                            @media print {
                                @page {
                                    size: A4 landscape;
                                    margin: 10mm;
                                }

                                body {
                                    background: #FFFFFF !important;
                                    color: #000000 !important;
                                }

                                .sidebar,
                                .top-navbar,
                                .btn-save-all,
                                .btn-print,
                                .subject-selector,
                                .menu-toggle-btn,
                                .sidebar-overlay,
                                .icon-btn,
                                .user-profile-badge {
                                    display: none !important;
                                }

                                .main-wrapper {
                                    margin-left: 0 !important;
                                    width: 100% !important;
                                }

                                .content-area {
                                    padding: 0 !important;
                                }

                                .container {
                                    max-width: 100% !important;
                                }

                                .print-only-header {
                                    display: block !important;
                                    margin-bottom: 1.25rem;
                                    padding-bottom: 0.75rem;
                                    border-bottom: 2px solid #1E3A5F;
                                    text-align: center;
                                }

                                .print-header-title {
                                    font-size: 1.4rem;
                                    font-weight: 800;
                                    color: #1E3A5F;
                                    text-transform: uppercase;
                                }

                                .print-header-sub {
                                    font-size: 0.9rem;
                                    font-weight: 700;
                                    color: #2563EB;
                                }

                                .content-card {
                                    border: 1px solid #CBD5E1 !important;
                                    box-shadow: none !important;
                                    padding: 1rem !important;
                                }

                                .input-marks {
                                    border: none !important;
                                    background: transparent !important;
                                }
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
                                        <span>My Subjects</span>
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
                                        <span>Students</span>
                                    </a>
                                </li>
                                <li class="nav-item active">
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

                        <div class="main-wrapper">
                            <header class="top-navbar">
                                <div class="top-left">
                                    <button class="menu-toggle-btn" id="menuToggleBtn"><svg width="24" height="24"
                                            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <line x1="3" y1="12" x2="21" y2="12" />
                                            <line x1="3" y1="6" x2="21" y2="6" />
                                            <line x1="3" y1="18" x2="21" y2="18" />
                                        </svg></button>
                                    <h1 class="page-title">CCE Marks</h1>
                                </div>

                                <div class="top-right">
                                    <button class="icon-btn"><svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" />
                                            <path d="M13.73 21a2 2 0 0 1-3.46 0" />
                                        </svg></button>
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
                                    <!-- Overview Stat Cards -->
                                    <div class="stats-grid">
                                        <div class="stat-card">
                                            <div class="stat-info">
                                                <h4>Active Subject</h4>
                                                <div id="activeSubjectStat">
                                                    <%= activeSubjectName %>
                                                </div>
                                            </div>
                                            <div class="stat-icon-wrap">
                                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                    <path
                                                        d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                </svg>
                                            </div>
                                        </div>
                                        <div class="stat-card">
                                            <div class="stat-info">
                                                <h4>Internal Weightage</h4>
                                                <div>50 Total Marks</div>
                                            </div>
                                            <div class="stat-icon-wrap">
                                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <polygon
                                                        points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                                                </svg>
                                            </div>
                                        </div>
                                        <div class="stat-card">
                                            <div class="stat-info">
                                                <h4>CCE Structure</h4>
                                                <div>5 CCEs (Exam 8 + Att 2)</div>
                                            </div>
                                            <div class="stat-icon-wrap">
                                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path
                                                        d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                                    <polyline points="14 2 14 8 20 8" />
                                                </svg>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- CCE Marks Entry Card -->
                                    <form action="${pageContext.request.contextPath}/teacher/save-cce-marks"
                                        method="post">
                                        <input type="hidden" name="subjectId" value="<%= selectedSubjectId %>">
                                        <div class="content-card">
                                            <div class="card-header-row">
                                                <div>
                                                    <h3>
                                                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2"
                                                            style="color: var(--primary-blue);">
                                                            <path
                                                                d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                                            <polyline points="14 2 14 8 20 8" />
                                                            <line x1="16" y1="13" x2="8" y2="13" />
                                                            <line x1="16" y1="17" x2="8" y2="17" />
                                                        </svg>
                                                        CCE Marks Entry Form
                                                    </h3>
                                                    <p
                                                        style="font-size: 0.8rem; color: var(--text-muted); margin-top: 0.25rem;">
                                                        Select Subject & enter Exam (max 8) + Attendance (max 2)
                                                        marks
                                                        per CCE.
                                                    </p>
                                                </div>
                                                <div
                                                    style="display: flex; align-items: center; gap: 0.75rem; flex-wrap: wrap;">
                                                    <select class="subject-selector" id="subjectSelector"
                                                        name="subjectId"
                                                        onchange="location.href='cce-marks.jsp?subjectId=' + this.value;">
                                                        <%
                                                            if (teacherAssignedSubjects != null && !teacherAssignedSubjects.isEmpty())
                                                            {
                                                        %>
                                                            <%
                                                                for (TeacherSubject ts : teacherAssignedSubjects)
                                                                {
                                                                    Subject sub = ts.getSubject();
                                                                    boolean isSel = (sub.getId() == selectedSubjectId);
                                                            %>
                                                                <option value="<%= sub.getId() %>" <%= isSel ? "selected"
                                                                    : "" %>><%= sub.getSubjectCode() %>
                                                                        - <%= sub.getSubjectName() %>
                                                                </option>
                                                                <%
                                                                    }
                                                                %>
                                                                    <%
                                                                        }
                                                                        else
                                                                        {
                                                                    %>
                                                                        <option value="">No Assigned Subject</option>
                                                                        <%
                                                                            }
                                                                        %>
                                                    </select>
                                                    <select class="subject-selector" id="yearSelector"
                                                        onchange="filterStudents()">
                                                        <option value="All" selected>All Years</option>
                                                        <option value="First Year">First Year (FE)</option>
                                                        <option value="Second Year">Second Year (SE)</option>
                                                        <option value="Third Year">Third Year (TE)</option>
                                                        <option value="Final Year">Final Year (BE)</option>
                                                    </select>
                                                    <select class="subject-selector" id="semesterSelector"
                                                        onchange="filterStudents()">
                                                        <option value="All" selected>All Semesters</option>
                                                        <option value="Semester 1">Semester 1</option>
                                                        <option value="Semester 2">Semester 2</option>
                                                        <option value="Semester 3">Semester 3</option>
                                                        <option value="Semester 4">Semester 4</option>
                                                        <option value="Semester 5">Semester 5</option>
                                                        <option value="Semester 6">Semester 6</option>
                                                        <option value="Semester 7">Semester 7</option>
                                                        <option value="Semester 8">Semester 8</option>
                                                    </select>
                                                    <button type="submit" class="btn-save-all">
                                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2.5">
                                                            <polyline points="20 6 9 17 4 12" />
                                                        </svg>
                                                        <span>Save All Marks</span>
                                                    </button>
                                                </div>
                                            </div>

                                            <div class="table-responsive">
                                                <table class="data-table">
                                                    <thead>
                                                        <tr>
                                                            <th style="text-align: center;">Sr No</th>
                                                            <th style="text-align: center;">Roll No</th>
                                                            <th style="text-align: left;">Student Name</th>
                                                            <th style="text-align: left;">Email ID</th>
                                                            <th style="text-align: center;">Year</th>
                                                            <th style="text-align: center;">Semester</th>
                                                            <th style="text-align: center;">CCE 1 (Exam/8 + Att/2)
                                                            </th>
                                                            <th style="text-align: center;">CCE 2 (Exam/8 + Att/2)
                                                            </th>
                                                            <th style="text-align: center;">CCE 3 (Exam/8 + Att/2)
                                                            </th>
                                                            <th style="text-align: center;">CCE 4 (Exam/8 + Att/2)
                                                            </th>
                                                            <th style="text-align: center;">CCE 5 (Exam/8 + Att/2)
                                                            </th>
                                                            <th style="text-align: center;">Total (/50)</th>
                                                            <th style="text-align: center;">Status</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <%
                                                            if (assignedStudents != null && !assignedStudents.isEmpty())
                                                            {
                                                        %>
                                                            <% int stIdx = 1; %>
                                                                <%
                                                                    for (StudentSubjectAssignment ssa : assignedStudents)
                                                                    {
                                                                        Student student = ssa.getStudent();
                                                                        if (student == null) continue;
                                                                        StudentSubjectMarks mark = marksService.getMarksByStudentSubjectTeacher(student.getId(), selectedSubjectId, teacherId);
                                                                        int cce1E = (mark != null) ? (int)mark.getCce1Marks() : 0;
                                                                        int cce1A = (mark != null) ? (int)mark.getAttendance1Marks() : 0;
                                                                        int cce2E = (mark != null) ? (int)mark.getCce2Marks() : 0;
                                                                        int cce2A = (mark != null) ? (int)mark.getAttendance2Marks() : 0;
                                                                        int cce3E = (mark != null) ? (int)mark.getCce3Marks() : 0;
                                                                        int cce3A = (mark != null) ? (int)mark.getAttendance3Marks() : 0;
                                                                        int cce4E = (mark != null) ? (int)mark.getCce4Marks() : 0;
                                                                        int cce4A = (mark != null) ? (int)mark.getAttendance4Marks() : 0;
                                                                        int cce5E = (mark != null) ? (int)mark.getCce5Marks() : 0;
                                                                        int cce5A = (mark != null) ? (int)mark.getAttendance5Marks() : 0;
                                                                        int totalInt = (mark != null) ? (int)mark.getInternalMarks() : (cce1E+cce1A+cce2E+cce2A+cce3E+cce3A+cce4E+cce4A+cce5E+cce5A);
                                                                        String status = (mark != null && mark.getResultStatus() != null) ? mark.getResultStatus() : (totalInt>= 20 ? "Pass" : "Fail");
                                                                        String studentYear = (student.getYear() != null && !student.getYear().trim().isEmpty()) ? student.getYear().trim() : "Third Year";
                                                                        String studentSemester = (student.getSemester() != null && !student.getSemester().trim().isEmpty()) ? student.getSemester().trim() : "Semester 5";
                                                                        String att1Class = (cce1A == 2) ? "att-100" : ((cce1A == 1) ? "att-50" : "att-0");
                                                                        String att1Text = (cce1A == 2) ? "100%" : ((cce1A == 1) ? "50%" : "0%");
                                                                        String att2Class = (cce2A == 2) ? "att-100" : ((cce2A == 1) ? "att-50" : "att-0");
                                                                        String att2Text = (cce2A == 2) ? "100%" : ((cce2A == 1) ? "50%" : "0%");
                                                                        String att3Class = (cce3A == 2) ? "att-100" : ((cce3A == 1) ? "att-50" : "att-0");
                                                                        String att3Text = (cce3A == 2) ? "100%" : ((cce3A == 1) ? "50%" : "0%");
                                                                        String att4Class = (cce4A == 2) ? "att-100" : ((cce4A == 1) ? "att-50" : "att-0");
                                                                        String att4Text = (cce4A == 2) ? "100%" : ((cce4A == 1) ? "50%" : "0%");
                                                                        String att5Class = (cce5A == 2) ? "att-100" : ((cce5A == 1) ? "att-50" : "att-0");
                                                                        String att5Text = (cce5A == 2) ? "100%" : ((cce5A == 1) ? "50%" : "0%");
                                                                        String statusClass = "Pass".equalsIgnoreCase(status) ? "status-pass" : "status-fail";
                                                                %>
                                                                    <tr data-year="<%= studentYear %>"
                                                                        data-semester="<%= studentSemester %>">
                                                                        <td
                                                                            style="text-align: center; font-weight: 700; color: var(--text-muted);">
                                                                            <%= stIdx++ %>
                                                                        </td>
                                                                        <td
                                                                            style="text-align: center; font-weight: 700; color: var(--primary-blue);">
                                                                            <%= student.getRollNo() !=null ?
                                                                                student.getRollNo() : student.getId() %>
                                                                        </td>
                                                                        <td
                                                                            style="text-align: left; font-weight: 700; color: var(--text-main);">
                                                                            <%= student.getName() %>
                                                                        </td>
                                                                        <td
                                                                            style="text-align: left; font-weight: 600; color: var(--text-main);">
                                                                            <%= student.getEmail() !=null ?
                                                                                student.getEmail() : "-" %>
                                                                        </td>
                                                                        <td
                                                                            style="text-align: center; font-weight: 600; color: var(--primary-navy);">
                                                                            <%= studentYear %>
                                                                        </td>
                                                                        <td
                                                                            style="text-align: center; font-weight: 600; color: var(--primary-navy);">
                                                                            <%= studentSemester %>
                                                                        </td>

                                                                        <td style="text-align: center;">
                                                                            <div class="cce-input-cell">
                                                                                <div class="cce-inputs-row">
                                                                                    <input type="number"
                                                                                        name="cce1_exam_<%= student.getId() %>"
                                                                                        class="input-marks"
                                                                                        value="<%= cce1E %>" max="8"
                                                                                        min="0"
                                                                                        title="Exam Marks (max 8)">
                                                                                    <span class="input-plus">+</span>
                                                                                    <input type="number"
                                                                                        name="cce1_att_<%= student.getId() %>"
                                                                                        class="input-marks"
                                                                                        value="<%= cce1A %>" max="2"
                                                                                        min="0"
                                                                                        title="Attendance Marks (max 2)">
                                                                                </div>
                                                                                <span
                                                                                    class="att-badge <%= att1Class %>">Att:
                                                                                    <%= att1Text %>
                                                                                </span>
                                                                            </div>
                                                                        </td>

                                                                        <td style="text-align: center;">
                                                                            <div class="cce-input-cell">
                                                                                <div class="cce-inputs-row">
                                                                                    <input type="number"
                                                                                        name="cce2_exam_<%= student.getId() %>"
                                                                                        class="input-marks"
                                                                                        value="<%= cce2E %>" max="8"
                                                                                        min="0"
                                                                                        title="Exam Marks (max 8)">
                                                                                    <span class="input-plus">+</span>
                                                                                    <input type="number"
                                                                                        name="cce2_att_<%= student.getId() %>"
                                                                                        class="input-marks"
                                                                                        value="<%= cce2A %>" max="2"
                                                                                        min="0"
                                                                                        title="Attendance Marks (max 2)">
                                                                                </div>
                                                                                <span
                                                                                    class="att-badge <%= att2Class %>">Att:
                                                                                    <%= att2Text %>
                                                                                </span>
                                                                            </div>
                                                                        </td>

                                                                        <td style="text-align: center;">
                                                                            <div class="cce-input-cell">
                                                                                <div class="cce-inputs-row">
                                                                                    <input type="number"
                                                                                        name="cce3_exam_<%= student.getId() %>"
                                                                                        class="input-marks"
                                                                                        value="<%= cce3E %>" max="8"
                                                                                        min="0"
                                                                                        title="Exam Marks (max 8)">
                                                                                    <span class="input-plus">+</span>
                                                                                    <input type="number"
                                                                                        name="cce3_att_<%= student.getId() %>"
                                                                                        class="input-marks"
                                                                                        value="<%= cce3A %>" max="2"
                                                                                        min="0"
                                                                                        title="Attendance Marks (max 2)">
                                                                                </div>
                                                                                <span
                                                                                    class="att-badge <%= att3Class %>">Att:
                                                                                    <%= att3Text %>
                                                                                </span>
                                                                            </div>
                                                                        </td>

                                                                        <td style="text-align: center;">
                                                                            <div class="cce-input-cell">
                                                                                <div class="cce-inputs-row">
                                                                                    <input type="number"
                                                                                        name="cce4_exam_<%= student.getId() %>"
                                                                                        class="input-marks"
                                                                                        value="<%= cce4E %>" max="8"
                                                                                        min="0"
                                                                                        title="Exam Marks (max 8)">
                                                                                    <span class="input-plus">+</span>
                                                                                    <input type="number"
                                                                                        name="cce4_att_<%= student.getId() %>"
                                                                                        class="input-marks"
                                                                                        value="<%= cce4A %>" max="2"
                                                                                        min="0"
                                                                                        title="Attendance Marks (max 2)">
                                                                                </div>
                                                                                <span
                                                                                    class="att-badge <%= att4Class %>">Att:
                                                                                    <%= att4Text %>
                                                                                </span>
                                                                            </div>
                                                                        </td>

                                                                        <td style="text-align: center;">
                                                                            <div class="cce-input-cell">
                                                                                <div class="cce-inputs-row">
                                                                                    <input type="number"
                                                                                        name="cce5_exam_<%= student.getId() %>"
                                                                                        class="input-marks"
                                                                                        value="<%= cce5E %>" max="8"
                                                                                        min="0"
                                                                                        title="Exam Marks (max 8)">
                                                                                    <span class="input-plus">+</span>
                                                                                    <input type="number"
                                                                                        name="cce5_att_<%= student.getId() %>"
                                                                                        class="input-marks"
                                                                                        value="<%= cce5A %>" max="2"
                                                                                        min="0"
                                                                                        title="Attendance Marks (max 2)">
                                                                                </div>
                                                                                <span
                                                                                    class="att-badge <%= att5Class %>">Att:
                                                                                    <%= att5Text %>
                                                                                </span>
                                                                            </div>
                                                                        </td>

                                                                        <td style="text-align: center;">
                                                                            <span class="total-marks-badge">
                                                                                <%= totalInt %> / 50
                                                                            </span>
                                                                        </td>
                                                                        <td style="text-align: center;">
                                                                            <span
                                                                                class="status-pill <%= statusClass %>">
                                                                                <%= status %>
                                                                            </span>
                                                                        </td>
                                                                    </tr>
                                                                    <%
                                                                        }
                                                                    %>
                                                                        <%
                                                                            }
                                                                            else
                                                                            {
                                                                        %>
                                                                            <tr>
                                                                                <td colspan="13"
                                                                                    style="text-align: center; color: var(--text-muted); padding: 30px; font-weight: 500;">
                                                                                    No assigned students found for the
                                                                                    selected subject.
                                                                                </td>
                                                                            </tr>
                                                                            <%
                                                                                }
                                                                            %>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </main>
                        </div>

                        <script>
                            const menuToggleBtn = document.getElementById('menuToggleBtn');
                            const sidebar = document.getElementById('sidebar');
                            const sidebarOverlay = document.getElementById('sidebarOverlay');
                            function toggleSidebar() { sidebar.classList.toggle('open'); sidebarOverlay.classList.toggle('active'); }
                            if (menuToggleBtn) menuToggleBtn.addEventListener('click', toggleSidebar);
                            if (sidebarOverlay) sidebarOverlay.addEventListener('click', toggleSidebar);

                            function recalculateRowMarks(row) {
                                const markInputs = row.querySelectorAll('.input-marks');
                                let rowTotal = 0;

                                // Iterate in pairs (Exam mark, Attendance mark)
                                for (let i = 0; i < markInputs.length; i += 2) {
                                    const examInput = markInputs[i];
                                    const attInput = markInputs[i + 1];

                                    let examVal = parseInt(examInput.value) || 0;
                                    let attVal = parseInt(attInput.value) || 0;

                                    // Validation clamp
                                    if (examVal > 8) examVal = 8;
                                    if (examVal < 0) examVal = 0;
                                    examInput.value = examVal;

                                    if (attVal > 2) attVal = 2;
                                    if (attVal < 0) attVal = 0;
                                    attInput.value = attVal;

                                    rowTotal += (examVal + attVal);

                                    // Update attendance badge in cell
                                    const cceCell = examInput.closest('.cce-input-cell');
                                    if (cceCell) {
                                        const attBadge = cceCell.querySelector('.att-badge');
                                        if (attBadge) {
                                            if (attVal === 2) {
                                                attBadge.innerText = 'Att: 100%';
                                                attBadge.className = 'att-badge att-100';
                                            } else if (attVal === 1) {
                                                attBadge.innerText = 'Att: 50%';
                                                attBadge.className = 'att-badge att-50';
                                            } else {
                                                attBadge.innerText = 'Att: 0%';
                                                attBadge.className = 'att-badge att-0';
                                            }
                                        }
                                    }
                                }

                                // Update Total Badge
                                const totalBadge = row.querySelector('.total-marks-badge');
                                if (totalBadge) {
                                    totalBadge.innerText = `${rowTotal} / 50`;
                                }

                                // Update Status Pill (Passing threshold: 20/50 for CCE)
                                const statusPill = row.querySelector('.status-pill');
                                if (statusPill) {
                                    if (rowTotal >= 20) {
                                        statusPill.className = 'status-pill status-pass';
                                        statusPill.innerText = 'Pass';
                                    } else {
                                        statusPill.className = 'status-pill status-fail';
                                        statusPill.innerText = 'Fail';
                                    }
                                }
                            }

                            function filterStudents() {
                                const yearSel = document.getElementById('yearSelector');
                                const semSel = document.getElementById('semesterSelector');
                                const selectedYear = yearSel ? yearSel.value : 'All';
                                const selectedSem = semSel ? semSel.value : 'All';
                                const rows = document.querySelectorAll('.data-table tbody tr');
                                let count = 1;
                                rows.forEach(row => {
                                    const rowYear = row.getAttribute('data-year');
                                    const rowSem = row.getAttribute('data-semester');
                                    const yearMatch = (!rowYear || selectedYear === 'All' || rowYear === selectedYear);
                                    const semMatch = (!rowSem || selectedSem === 'All' || rowSem === selectedSem);
                                    if (yearMatch && semMatch) {
                                        row.style.display = '';
                                        if (row.children[0]) {
                                            row.children[0].innerText = count++;
                                        }
                                    } else {
                                        row.style.display = 'none';
                                    }
                                });
                            }

                            document.addEventListener('DOMContentLoaded', () => {
                                const yearSel = document.getElementById('yearSelector');
                                if (yearSel) {
                                    filterStudents();
                                }

                                const rows = document.querySelectorAll('.data-table tbody tr');
                                rows.forEach(row => {
                                    const inputs = row.querySelectorAll('.input-marks');
                                    inputs.forEach(input => {
                                        input.addEventListener('input', () => recalculateRowMarks(row));
                                    });
                                });

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

                                const saveBtn = document.querySelector('.btn-save-all');
                                if (saveBtn) {
                                    saveBtn.addEventListener('click', () => {
                                        showToast('CCE marks for all students saved successfully!', 'success');
                                    });
                                }
                            });
                        </script>
                        <jsp:include page="/logout-modal.jsp" />
                    </body>

                    </html>