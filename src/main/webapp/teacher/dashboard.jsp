<%@ page language = "java" contentType = "text/html; charset = UTF-8" pageEncoding = "UTF-8" import = "com.student.entity.*,com.student.service.*,com.student.dto.*" %>
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
        TeacherService teacherService = new TeacherService();
        java.util.List<com.student.entity.TeacherSubject> myTeacherSubjects = new java.util.ArrayList<>();
        java.util.Map<Long, Long> assignedCounts = ssaService.getAssignedCountsByTeacher(loggedInTeacher.getId());
        TeacherDashboardSummaryDTO dashboardSummary = new TeacherDashboardSummaryDTO();
        if (loggedInTeacher != null)
        {
            myTeacherSubjects = teacherSubjectService.getTeacherSubjectsByTeacherId(loggedInTeacher.getId());
            dashboardSummary = teacherService.getDashboardSummary(loggedInTeacher.getId());
        }
    %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Teacher Dashboard - Student Management System</title>
                    
                    <link rel="preconnect" href="https://fonts.googleapis.com">
                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
                        rel="stylesheet">

                    <style>
                        /* ==========================================================================
           1. CSS VARIABLES & BASE RESETS
           ========================================================================== */
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

                        /* ==========================================================================
           2. SIDEBAR NAVIGATION
           ========================================================================== */
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

                        /* Sidebar Overlay for Mobile */
                        .sidebar-overlay {
                            display: none;
                            position: fixed;
                            inset: 0;
                            background: rgba(15, 23, 42, 0.6);
                            backdrop-filter: blur(4px);
                            z-index: 999;
                        }

                        /* ==========================================================================
           3. MAIN LAYOUT & TOPBAR
           ========================================================================== */
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

                        .icon-btn {
                            background: none;
                            border: 1px solid var(--border);
                            width: 38px;
                            height: 38px;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: var(--text-muted);
                            cursor: pointer;
                            transition: var(--transition);
                        }

                        .icon-btn:hover {
                            border-color: var(--primary-blue);
                            color: var(--primary-blue);
                            background: var(--light-blue);
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

                        /* ==========================================================================
           4. DASHBOARD CONTENT & CARDS
           ========================================================================== */
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

                        /* Welcome Card */
                        .welcome-card {
                            background: linear-gradient(135deg, var(--primary-navy) 0%, var(--primary-navy-dark) 100%);
                            border-radius: var(--radius-lg);
                            padding: 2.25rem 2.5rem;
                            color: #FFFFFF;
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            position: relative;
                            overflow: hidden;
                            box-shadow: var(--shadow-md);
                        }

                        .welcome-card::after {
                            content: '';
                            position: absolute;
                            top: -50%;
                            right: -10%;
                            width: 300px;
                            height: 300px;
                            background: radial-gradient(circle, rgba(37, 99, 235, 0.25) 0%, transparent 70%);
                            border-radius: 50%;
                            pointer-events: none;
                        }

                        .welcome-text {
                            max-width: 650px;
                            position: relative;
                            z-index: 1;
                        }

                        .welcome-badge {
                            display: inline-block;
                            padding: 0.3rem 0.8rem;
                            background: rgba(255, 255, 255, 0.1);
                            border-radius: 50px;
                            font-size: 0.75rem;
                            font-weight: 700;
                            letter-spacing: 0.05em;
                            margin-bottom: 0.75rem;
                            color: #93C5FD;
                        }

                        .welcome-text h2 {
                            font-size: 1.85rem;
                            font-weight: 800;
                            margin-bottom: 0.5rem;
                            letter-spacing: -0.02em;
                        }

                        .welcome-text p {
                            font-size: 0.95rem;
                            color: #CBD5E1;
                            line-height: 1.6;
                        }

                        .welcome-visual {
                            width: 70px;
                            height: 70px;
                            background: rgba(255, 255, 255, 0.08);
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: #60A5FA;
                            position: relative;
                            z-index: 1;
                        }

                        /* Summary Stats Grid */
                        .summary-grid {
                            display: grid;
                            grid-template-columns: repeat(4, 1fr);
                            gap: 1.25rem;
                        }

                        .stat-card {
                            background: var(--card-bg);
                            border: 1px solid var(--border);
                            border-radius: var(--radius-md);
                            padding: 1.5rem;
                            box-shadow: var(--shadow-sm);
                            transition: var(--transition);
                            display: flex;
                            flex-direction: column;
                            justify-content: space-between;
                        }

                        .stat-card:hover {
                            transform: translateY(-4px);
                            box-shadow: var(--shadow-hover);
                            border-color: var(--primary-blue);
                        }

                        .stat-top {
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            margin-bottom: 1rem;
                        }

                        .stat-icon-wrap {
                            width: 44px;
                            height: 44px;
                            border-radius: var(--radius-sm);
                            background: var(--light-blue);
                            color: var(--primary-blue);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                        }

                        .stat-title {
                            font-size: 0.85rem;
                            font-weight: 600;
                            color: var(--text-muted);
                        }

                        .stat-val {
                            font-size: 1.75rem;
                            font-weight: 800;
                            color: var(--primary-navy);
                            letter-spacing: -0.02em;
                            margin-bottom: 0.25rem;
                        }

                        .stat-desc {
                            font-size: 0.775rem;
                            color: var(--text-muted);
                        }

                        /* Two-Column Mid Section */
                        .mid-grid {
                            display: grid;
                            grid-template-columns: 2fr 1fr;
                            gap: 1.5rem;
                        }

                        /* CCE Cards Grid */
                        .cce-grid {
                            display: grid;
                            grid-template-columns: repeat(5, 1fr);
                            gap: 1rem;
                        }

                        .cce-item-card {
                            background: var(--bg-main);
                            border: 1px solid var(--border);
                            border-radius: var(--radius-sm);
                            padding: 1.15rem 0.85rem;
                            text-align: center;
                            transition: var(--transition);
                        }

                        .cce-item-card:hover {
                            border-color: var(--primary-blue);
                            background: #FFFFFF;
                        }

                        .cce-tag {
                            font-size: 0.8rem;
                            font-weight: 700;
                            color: var(--text-muted);
                            margin-bottom: 0.5rem;
                            display: block;
                        }

                        .cce-marks {
                            font-size: 1.25rem;
                            font-weight: 800;
                            color: var(--primary-navy);
                            margin-bottom: 0.75rem;
                        }

                        .cce-progress-bar {
                            width: 100%;
                            height: 6px;
                            background: var(--border);
                            border-radius: 10px;
                            overflow: hidden;
                        }

                        .cce-progress-fill {
                            height: 100%;
                            width: 0%;
                            background: var(--primary-blue);
                            border-radius: 10px;
                        }

                        /* Circular Attendance Card */
                        .attendance-center {
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            justify-content: center;
                            padding: 1rem 0;
                            text-align: center;
                        }

                        .circular-progress-wrap {
                            position: relative;
                            width: 120px;
                            height: 120px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            margin-bottom: 1rem;
                        }

                        .circular-progress-wrap svg {
                            width: 100%;
                            height: 100%;
                            transform: rotate(-90deg);
                        }

                        .circle-bg {
                            fill: none;
                            stroke: var(--border);
                            stroke-width: 3.5;
                        }

                        .circle-bar {
                            fill: none;
                            stroke: var(--primary-blue);
                            stroke-width: 3.5;
                            stroke-dasharray: 100;
                            stroke-dashoffset: 100;
                        }

                        .circle-val {
                            position: absolute;
                            font-size: 1.4rem;
                            font-weight: 800;
                            color: var(--primary-navy);
                        }

                        /* Universal Content Card */
                        .content-card {
                            background: var(--card-bg);
                            border: 1px solid var(--border);
                            border-radius: var(--radius-md);
                            padding: 1.75rem;
                            box-shadow: var(--shadow-sm);
                        }

                        .card-header-row {
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            margin-bottom: 1.5rem;
                            padding-bottom: 0.85rem;
                            border-bottom: 1px solid var(--border);
                        }

                        .card-header-row h3 {
                            font-size: 1.15rem;
                            font-weight: 800;
                            color: var(--primary-navy);
                        }

                        /* Buttons */
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
                            transform: translateY(-1px);
                        }

                        .btn-sm {
                            padding: 0.45rem 0.9rem;
                            font-size: 0.825rem;
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

                        /* Table Design */
                        .table-responsive {
                            width: 100%;
                            overflow-x: auto;
                        }

                        .custom-table {
                            width: 100%;
                            border-collapse: collapse;
                            text-align: left;
                        }

                        .custom-table th {
                            padding: 0.85rem 1rem;
                            font-size: 0.8rem;
                            font-weight: 700;
                            color: var(--text-muted);
                            text-transform: uppercase;
                            letter-spacing: 0.04em;
                            background: var(--bg-main);
                            border-bottom: 1px solid var(--border);
                        }

                        .custom-table td {
                            padding: 1rem;
                            font-size: 0.9rem;
                            color: var(--text-main);
                            border-bottom: 1px solid var(--border);
                        }

                        .custom-table tr:hover td {
                            background: #FAFAFA;
                        }

                        /* Form Elements for CCE Marks */
                        .form-grid-cce {
                            display: grid;
                            grid-template-columns: repeat(3, 1fr);
                            gap: 1.25rem;
                            margin-bottom: 1.5rem;
                        }

                        .form-group {
                            display: flex;
                            flex-direction: column;
                            gap: 0.35rem;
                        }

                        .form-group.col-span-3 {
                            grid-column: span 3;
                        }

                        .form-label {
                            font-size: 0.825rem;
                            font-weight: 600;
                            color: var(--text-main);
                        }

                        .form-control {
                            width: 100%;
                            padding: 0.75rem 0.9rem;
                            border: 1.5px solid var(--border);
                            border-radius: var(--radius-sm);
                            font-size: 0.9rem;
                            color: var(--text-main);
                            background-color: #FFFFFF;
                            font-family: inherit;
                            outline: none;
                            transition: var(--transition);
                        }

                        .form-control:focus {
                            border-color: var(--primary-blue);
                            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
                        }

                        select.form-control {
                            appearance: none;
                            -webkit-appearance: none;
                            -moz-appearance: none;
                            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%2364748B' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
                            background-repeat: no-repeat;
                            background-position: right 0.85rem center;
                            background-size: 14px;
                            cursor: pointer;
                            padding-right: 2.25rem;
                        }

                        /* Two-Column Bottom Grid (Result & Profile) */
                        .bottom-grid {
                            display: grid;
                            grid-template-columns: 1fr 1fr;
                            gap: 1.5rem;
                        }

                        .meta-list {
                            display: grid;
                            grid-template-columns: 1fr 1fr;
                            gap: 1.25rem 1rem;
                            margin-bottom: 1.5rem;
                        }

                        .meta-item label {
                            font-size: 0.775rem;
                            font-weight: 600;
                            color: var(--text-muted);
                            display: block;
                            margin-bottom: 0.2rem;
                            text-transform: uppercase;
                            letter-spacing: 0.04em;
                        }

                        .meta-item span {
                            font-size: 1rem;
                            font-weight: 700;
                            color: var(--primary-navy);
                        }

                        /* ==========================================================================
           5. RESPONSIVE BREAKPOINTS
           ========================================================================== */
                        @media (max-width: 1100px) {
                            .summary-grid {
                                grid-template-columns: repeat(2, 1fr);
                            }

                            .form-grid-cce {
                                grid-template-columns: repeat(2, 1fr);
                            }

                            .form-group.col-span-3 {
                                grid-column: span 2;
                            }

                            .bottom-grid {
                                grid-template-columns: 1fr;
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

                            .content-area {
                                padding: 1.25rem;
                            }

                            .welcome-card {
                                padding: 1.75rem 1.5rem;
                            }

                            .welcome-visual {
                                display: none;
                            }
                        }

                        @media (max-width: 600px) {
                            .summary-grid {
                                grid-template-columns: 1fr;
                            }

                            .form-grid-cce {
                                grid-template-columns: 1fr;
                            }

                            .form-group.col-span-3 {
                                grid-column: span 1;
                            }

                            .meta-list {
                                grid-template-columns: 1fr;
                            }

                            .top-navbar {
                                padding: 0 1rem;
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
                            <li class="nav-item active">
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
                                    stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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
                                <h1 class="page-title">Teacher Dashboard</h1>
                            </div>

                            <div class="top-right">
                                <button class="icon-btn" aria-label="Notifications">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" />
                                        <path d="M13.73 21a2 2 0 0 1-3.46 0" />
                                    </svg>
                                </button>

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

                                <!-- Welcome Banner -->
                                <section class="welcome-card">
                                    <div class="welcome-text">
                                        <h2>Welcome, <%= teacherFirstName %>!</h2>
                                        <p>Welcome to Teacher Dashboard. Manage students, enter CCE marks, track
                                            attendance,
                                            and monitor academic results
                                            efficiently.</p>
                                    </div>
                                    <div class="welcome-visual">
                                        <svg width="34" height="34" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <rect x="2" y="7" width="20" height="14" rx="2" ry="2" />
                                            <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                                        </svg>
                                    </div>
                                </section>

                                <!-- 4. Summary Cards -->
                                <section class="summary-grid">
                                    <div class="stat-card">
                                        <div class="stat-top">
                                            <span class="stat-title">My Subjects</span>
                                            <div class="stat-icon-wrap">
                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                    <path
                                                        d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                </svg>
                                            </div>
                                        </div>
                                        <div class="stat-val" id="statAcceptedVal">
                                            <%= dashboardSummary.getSubjectCount() %>
                                        </div>
                                        <span class="stat-desc">Active Assigned Subjects</span>
                                    </div>

                                    <div class="stat-card">
                                        <div class="stat-top">
                                            <span class="stat-title">Assigned Students</span>
                                            <div class="stat-icon-wrap">
                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                    <circle cx="9" cy="7" r="4" />
                                                </svg>
                                            </div>
                                        </div>
                                        <div class="stat-val">
                                            <%= dashboardSummary.getAssignedStudentCount() %>
                                        </div>
                                        <span class="stat-desc">Enrolled Student Intake</span>
                                    </div>

                                    <div class="stat-card">
                                        <div class="stat-top">
                                            <span class="stat-title">Average Performance</span>
                                            <div class="stat-icon-wrap">
                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <polyline points="23 6 13.5 15.5 8.5 10.5 1 18" />
                                                    <polyline points="17 6 23 6 23 12" />
                                                </svg>
                                            </div>
                                        </div>
                                        <div class="stat-val">
                                            <%= dashboardSummary.getAveragePerformanceFormatted() %>
                                        </div>
                                        <span class="stat-desc">Overall Student Average</span>
                                    </div>

                                    <div class="stat-card">
                                        <div class="stat-top">
                                            <span class="stat-title">Attendance</span>
                                            <div class="stat-icon-wrap">
                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
                                                    <line x1="16" y1="2" x2="16" y2="6" />
                                                    <line x1="8" y1="2" x2="8" y2="6" />
                                                    <line x1="3" y1="10" x2="21" y2="10" />
                                                </svg>
                                            </div>
                                        </div>
                                        <div class="stat-val">
                                            <%= dashboardSummary.getAverageAttendanceFormatted() %>
                                        </div>
                                        <span class="stat-desc">Average Student Attendance</span>
                                    </div>
                                </section>

                                <!-- 5. Assigned Courses & Teacher Actions Section -->
                                <section class="content-card">
                                    <div class="card-header-row"
                                        style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
                                        <div>
                                            <h3 style="margin: 0; font-size: 1.1rem; color: var(--primary-navy);">
                                                Assigned
                                                Courses & CCE Management</h3>
                                            <span style="font-size: 0.8rem; color: var(--text-muted);">Academic Subjects
                                                Assigned for Evaluation</span>
                                        </div>
                                        <a href="cce-marks.jsp" class="btn btn-primary btn-sm"
                                            style="font-weight: 600;">Enter
                                            CCE Marks &rarr;</a>
                                    </div>

                                    <div class="table-responsive">
                                        <table class="custom-table">
                                            <thead>
                                                <tr>
                                                    <th style="text-align: center;">Subject Code</th>
                                                    <th style="text-align: left;">Subject Name</th>
                                                    <th style="text-align: center;">Credits</th>
                                                    <th style="text-align: center;">Enrolled Students</th>
                                                    <th style="text-align: center;">CCE Status</th>
                                                    <th style="text-align: center;">Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    if (!myTeacherSubjects.isEmpty())
                                                    {
                                                        for (com.student.entity.TeacherSubject ts : myTeacherSubjects)
                                                        {
                                                            com.student.entity.Subject sub = ts.getSubject();
                                                            long count = assignedCounts != null ? assignedCounts.getOrDefault((long) sub.getId(), 0L) : 0L;
                                                            String code = (sub.getSubjectCode() != null && !sub.getSubjectCode().trim().isEmpty()) ? sub.getSubjectCode().trim() : "SUB-" + sub.getId();
                                                %>
                                                    <tr>
                                                        <td
                                                            style="text-align: center; font-weight: 700; color: var(--primary-blue);">
                                                            <%= code %>
                                                        </td>
                                                        <td style="text-align: left; font-weight: 600;">
                                                            <%= sub.getSubjectName() %>
                                                        </td>
                                                        <td style="text-align: center; font-weight: 700;">
                                                            <%= (sub.getCredit() !=null ? sub.getCredit() : "--" ) %>
                                                        </td>
                                                        <td style="text-align: center;">
                                                            <%= count %>
                                                        </td>
                                                        <td style="text-align: center;">
                                                            <span
                                                                style="background: rgba(16, 185, 129, 0.1); color: #10B981; padding: 0.25rem 0.6rem; border-radius: 20px; font-size: 0.75rem; font-weight: 700;">Active</span>
                                                        </td>
                                                        <td style="text-align: center;">
                                                            <a href="cce-marks.jsp" class="btn btn-outline btn-sm"
                                                                style="padding: 0.25rem 0.6rem; font-size: 0.775rem;">Marks</a>
                                                            <a href="results.jsp" class="btn btn-outline btn-sm"
                                                                style="padding: 0.25rem 0.6rem; font-size: 0.775rem;">Result</a>
                                                        </td>
                                                    </tr>
                                                    <%
                                                        }
                                                        }
                                                        else
                                                        {
                                                    %>
                                                        <tr>
                                                            <td colspan="6"
                                                                style="text-align: center; color: var(--text-muted); padding: 1.5rem;">
                                                                No active assigned subjects found for your profile.</td>
                                                        </tr>
                                                        <%
                                                            }
                                                        %>
                                            </tbody>
                                        </table>
                                    </div>
                                </section>

                            </div>
                        </main>
                    </div>

                    <!-- Toast Notification Container -->
                    <div id="toastContainer"
                        style="position:fixed; bottom:24px; right:24px; z-index:9999; display:flex; flex-direction:column; gap:8px;">
                    </div>

                    <!-- Minimal Vanilla JS -->
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

                        document.querySelectorAll('.sidebar-menu a').forEach(link => {
                            link.addEventListener('click', () => {
                                if (window.innerWidth <= 860) {
                                    toggleSidebar();
                                }
                            });
                        });

                        function showToast(message, type = 'success') {
                            const toast = document.createElement('div');
                            const bg = (type === 'success') ? '#1E293B' : '#7F1D1D';
                            toast.style.cssText =
                                'padding: 0.85rem 1.25rem;' +
                                'border-radius: 10px;' +
                                'background: ' + bg + ';' +
                                'color: #FFFFFF;' +
                                'font-size: 0.875rem;' +
                                'font-weight: 600;' +
                                'box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);' +
                                'display: flex;' +
                                'align-items: center;' +
                                'gap: 0.6rem;' +
                                'animation: slideUp 0.3s ease;';
                            toast.textContent = message;
                            const container = document.getElementById('toastContainer');
                            if (container) {
                                container.appendChild(toast);
                                setTimeout(() => {
                                    toast.style.opacity = '0';
                                    toast.style.transition = 'opacity 0.3s ease';
                                    setTimeout(() => toast.remove(), 300);
                                }, 3500);
                            }
                        }
                    </script>
                    <jsp:include page="/logout-modal.jsp" />
                </body>

                </html>