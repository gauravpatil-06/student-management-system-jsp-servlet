<%@ page language = "java" contentType = "text/html; charset = UTF-8" pageEncoding = "UTF-8" import = "com.student.entity.*,com.student.service.*" %>
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
        java.util.List<com.student.entity.Teacher> jspTeachers = new com.student.service.TeacherService().getAllTeachers();
        com.student.entity.Teacher jspInitTeacher = null;
        if (jspTeachers != null)
        {
            for (com.student.entity.Teacher t : jspTeachers)
            {
                if ("Computer Engineering".equalsIgnoreCase(t.getDepartment()))
                {
                    jspInitTeacher = t;
                    break;
                }
            }
            if (jspInitTeacher == null && !jspTeachers.isEmpty())
            {
                jspInitTeacher = jspTeachers.get(0);
            }
        }
        String jspInitTeacherName = (jspInitTeacher != null) ? ((jspInitTeacher.getName() != null && !jspInitTeacher.getName().trim().isEmpty()) ? jspInitTeacher.getName() : ("Prof. " + jspInitTeacher.getUsername())) : "Select Teacher";
        String jspInitTeacherDept = (jspInitTeacher != null && jspInitTeacher.getDepartment() != null) ? jspInitTeacher.getDepartment() : "Computer Engineering";
        int jspInitTeacherId = (jspInitTeacher != null) ? jspInitTeacher.getId() : 0;
    %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Subject Assignment - Admin Dashboard</title>
            
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
                    background: rgba(15, 23, 42, 0.5);
                    backdrop-filter: blur(4px);
                    z-index: 999;
                }

                /* Main Content Wrapper */
                .main-wrapper {
                    margin-left: var(--sidebar-width);
                    flex: 1;
                    display: flex;
                    flex-direction: column;
                    min-width: 0;
                }

                /* Top Header */
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

                .user-profile-menu {
                    display: flex;
                    align-items: center;
                    gap: 1rem;
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
                }

                .content-card {
                    background: var(--card-bg);
                    border: 1px solid var(--border);
                    border-radius: var(--radius-md);
                    padding: 1.5rem;
                    box-shadow: var(--shadow-sm);
                    margin-bottom: 1.5rem;
                }

                .card-header-row {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    margin-bottom: 1.25rem;
                }

                .card-header-row h3 {
                    font-size: 1.1rem;
                    font-weight: 800;
                    color: var(--primary-navy);
                }

                .form-group {
                    display: flex;
                    flex-direction: column;
                }

                .form-label {
                    font-size: 0.8rem;
                    font-weight: 700;
                    color: var(--text-main);
                    margin-bottom: 0.35rem;
                }

                .form-control {
                    width: 100%;
                    padding: 0.7rem 0.9rem;
                    border: 1.5px solid var(--border);
                    border-radius: var(--radius-sm);
                    font-size: 0.9rem;
                    font-family: inherit;
                    outline: none;
                    background: #FFFFFF;
                }

                .btn {
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    gap: 0.5rem;
                    padding: 0.65rem 1.25rem;
                    border-radius: var(--radius-sm);
                    font-size: 0.875rem;
                    font-weight: 700;
                    cursor: pointer;
                    transition: var(--transition);
                    border: none;
                }

                .btn-primary {
                    background: var(--primary-blue);
                    color: #FFFFFF;
                }

                .btn-primary:hover {
                    background: var(--primary-blue-hover);
                }

                .btn-outline {
                    background: transparent;
                    border: 1.5px solid var(--border);
                    color: var(--text-main);
                }

                .btn-outline:hover {
                    background: var(--bg-main);
                }

                .btn-danger {
                    background: #FEF2F2;
                    color: #DC2626;
                    border: 1px solid #FCA5A5;
                }

                .btn-danger:hover {
                    background: #DC2626;
                    color: #FFFFFF;
                    border-color: #DC2626;
                }

                .btn-sm {
                    padding: 0.4rem 0.8rem;
                    font-size: 0.8rem;
                }

                .custom-table {
                    width: 100%;
                    border-collapse: separate;
                    border-spacing: 0;
                }

                .custom-table th {
                    background: var(--bg-main);
                    padding: 0.85rem 1rem;
                    font-size: 0.775rem;
                    font-weight: 800;
                    color: var(--text-muted);
                    text-transform: uppercase;
                    letter-spacing: 0.05em;
                    text-align: left;
                    border-bottom: 1.5px solid var(--border);
                    white-space: nowrap;
                }

                .custom-table td {
                    padding: 1rem;
                    font-size: 0.875rem;
                    color: var(--text-main);
                    border-bottom: 1px solid var(--border);
                    vertical-align: middle;
                    white-space: nowrap;
                }

                .custom-table tbody tr:last-child td {
                    border-bottom: none;
                }

                .custom-table tbody tr:hover td {
                    background: rgba(248, 250, 252, 0.7);
                }

                .badge {
                    display: inline-flex;
                    align-items: center;
                    padding: 0.25rem 0.65rem;
                    border-radius: 50px;
                    font-size: 0.75rem;
                    font-weight: 700;
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
                    max-width: 960px;
                    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
                    border: 1px solid var(--border);
                    overflow: hidden;
                }

                .table-responsive {
                    width: 100%;
                    overflow-x: auto;
                    -webkit-overflow-scrolling: touch;
                    padding-bottom: 0.5rem;
                }

                .table-responsive::-webkit-scrollbar,
                #availableSubjectsList::-webkit-scrollbar {
                    height: 4px;
                    width: 4px;
                }

                .table-responsive::-webkit-scrollbar-track,
                #availableSubjectsList::-webkit-scrollbar-track {
                    background: #F1F5F9;
                    border-radius: 10px;
                }

                .table-responsive::-webkit-scrollbar-thumb,
                #availableSubjectsList::-webkit-scrollbar-thumb {
                    background: #CBD5E1;
                    border-radius: 10px;
                }

                .table-responsive::-webkit-scrollbar-thumb:hover,
                #availableSubjectsList::-webkit-scrollbar-thumb:hover {
                    background: #94A3B8;
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

                .modal-footer {
                    padding: 1rem 1.5rem;
                    background: var(--bg-main);
                    border-top: 1px solid var(--border);
                    display: flex;
                    align-items: center;
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
                    <li class="nav-item"><a href="teachers.jsp"><svg viewBox="0 0 24 24" fill="none"
                                stroke="currentColor">
                                <rect x="2" y="7" width="20" height="14" rx="2" />
                                <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                            </svg><span>Teacher Management</span></a></li>
                    <li class="nav-item active"><a href="subject-assignment.jsp"><svg viewBox="0 0 24 24" fill="none"
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
                        <h1 class="header-title" id="headerTitle">Subject Assignment</h1>
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
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 1.5rem;">

                        <!-- Step 1: Select Department & Teacher Card -->
                        <div class="content-card">
                            <div class="card-header-row" style="margin-bottom: 1rem;">
                                <h3 style="display: flex; align-items: center; gap: 0.5rem;">
                                    <span
                                        style="background: var(--primary-blue); color: #fff; width: 26px; height: 26px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 800;">1</span>
                                    Select Department & Teacher
                                </h3>
                            </div>

                            <div style="display: flex; flex-direction: column; gap: 1rem;">
                                <div class="form-group">
                                    <label class="form-label" style="font-weight:700;">Select Department</label>
                                    <select class="form-control" id="assignDeptSelect" onchange="onAssignDeptChange()">
                                        <option value="Computer Engineering">Computer Engineering</option>
                                        <option value="Information Technology">Information Technology</option>
                                        <option value="Mechanical Engineering">Mechanical Engineering</option>
                                        <option value="Civil Engineering">Civil Engineering</option>
                                        <option value="Electronics Engineering">Electronics Engineering</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" style="font-weight:700;">Select Teacher</label>
                                    <select class="form-control" id="assignTeacherSelect"
                                        onchange="onAssignTeacherChange()">
                                        <%
                                            if (jspTeachers != null && !jspTeachers.isEmpty())
                                            {
                                                boolean foundOption = false;
                                                for (com.student.entity.Teacher t : jspTeachers)
                                                {
                                                    if (jspInitTeacherDept.equalsIgnoreCase(t.getDepartment()))
                                                    {
                                                        foundOption = true;
                                                        String tName = (t.getName() != null && !t.getName().trim().isEmpty()) ? t.getName() : ("Prof. " + t.getUsername());
                                        %>
                                            <option value=" <%= t.getId() %>" <%= (t.getId()==jspInitTeacherId)
                                                ? "selected" : "" %>><%= tName %>
                                                    </option>
                                                    <%
                                                        }
                                                        }
                                                        if (!foundOption)
                                                        {
                                                    %>
                                                        <option value="">Select Teacher</option>
                                                        <%
                                                            }
                                                            }
                                                            else
                                                            {
                                                        %>
                                                            <option value="">Select Teacher</option>
                                                            <%
                                                                }
                                                            %>
                                    </select>
                                </div>

                                <!-- Teacher Quick Info -->
                                <div style="background: #EFF6FF; padding: 1rem 1.25rem; border-radius: var(--radius-sm); border: 1px solid #BFDBFE; margin-top: 1rem;"
                                    id="teacherDetailBox">
                                    <div id="teacherDetailName"
                                        style="font-size: 1.1rem; font-weight: 800; color: var(--primary-navy);">
                                        <%= jspInitTeacherName %>
                                    </div>
                                    <div style="font-size: 0.85rem; color: var(--text-muted); margin-top: 0.2rem; font-weight: 600;"
                                        id="teacherDetailMeta">
                                        Department: <span id="teacherDetailDept"
                                            style="font-weight: 700; color: var(--text-main);">
                                            <%= jspInitTeacherDept %>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Step 2: Assign Subject to Teacher -->
                        <div class="content-card">
                            <div class="card-header-row" style="margin-bottom: 1rem;">
                                <h3 style="display: flex; align-items: center; gap: 0.5rem;">
                                    <span
                                        style="background: var(--primary-blue); color: #fff; width: 26px; height: 26px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 800;">2</span>
                                    Available Subjects for Department
                                </h3>
                            </div>

                            <div style="display: flex; flex-direction: column; gap: 0.85rem;">
                                <p style="font-size: 0.85rem; color: var(--text-muted);">Select one or multiple subjects
                                    to assign to <strong id="assignTeacherLabel">
                                        <%= jspInitTeacherName %>
                                    </strong>:</p>

                                <div id="availableSubjectsList"
                                    style="display: flex; flex-direction: column; gap: 0.6rem; max-height: 180px; overflow-y: auto; padding-right: 0.5rem;">
                                    <!-- Rendered dynamically -->
                                </div>

                                <button class="btn btn-primary"
                                    style="margin-top: 0.5rem; width: 100%; font-weight: 700;"
                                    onclick="assignSelectedSubjectsToTeacher()">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2.5" style="margin-right: 0.4rem;">
                                        <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                    Assign Subject
                                </button>
                                <div id="assignMsgText"
                                    style="display:none; text-align:center; font-size:0.775rem; font-weight:700; margin-top:0.4rem; color:#16A34A; transition: opacity 0.3s ease;">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Step 3: Assigned Subjects Table Card -->
                    <div class="content-card">
                        <div class="card-header-row">
                            <div>
                                <h3>Assigned Subjects Overview</h3>
                                <p style="font-size: 0.825rem; color: var(--text-muted); margin-top: 0.2rem;">
                                    Currently assigned subjects and allocated student counts for <strong
                                        id="assignedOverviewTeacher">
                                        <%= jspInitTeacherName %>
                                    </strong>
                                </p>
                            </div>
                            <span class="badge"
                                style="background: #EFF6FF; color: #2563EB; font-weight: 700; padding: 0.4rem 0.9rem; border-radius: 50px; border: 1px solid #BFDBFE;">Teacher:
                                <span id="assignedTeacherBadgeName">
                                    <%= jspInitTeacherName %>
                                </span></span>
                        </div>

                        <div class="table-responsive">
                            <table class="custom-table" id="assignedSubjectsTable" style="min-width: 1050px;">
                                <thead>
                                    <tr>
                                        <th>Sr. No.</th>
                                        <th>Subject Name</th>
                                        <th>Course</th>
                                        <th>Department</th>
                                        <th>Semester</th>
                                        <th>Assigned Students</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody id="assignedSubjectsTbody">
                                    <!-- Rendered dynamically -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </main>
            </div>

            <!-- Modal: Manage Eligible Students -->
            <div class="modal-overlay" id="assignStudentsModal">
                <div class="modal-card" style="max-width: 950px;">
                    <div class="modal-header">
                        <div>
                            <h4 id="assignStudentsModalTitle">Manage Assigned Students</h4>
                            <div style="font-size:0.8rem; color:var(--text-muted); margin-top:0.2rem;"
                                id="modalFilterCriteria">
                                BTech | Computer Engineering | Semester 5 | Third Year
                            </div>
                        </div>
                        <button class="modal-close-btn" onclick="closeModal('assignStudentsModal')">&times;</button>
                    </div>
                    <div class="modal-body">
                        <div
                            style="display:flex; justify-content:space-between; align-items:center; background:var(--bg-main); padding:0.75rem 1rem; border-radius:var(--radius-sm); border:1px solid var(--border);">
                            <div style="font-size:0.85rem; font-weight:700; color:var(--primary-navy);">
                                Eligible Students List
                            </div>
                            <div style="display:flex; align-items:center; gap:0.75rem;">
                                <label
                                    style="font-size:0.8rem; font-weight:700; color:var(--text-muted); display:flex; align-items:center; gap:0.35rem;">
                                    Year:
                                    <select id="modalYearSelect" class="form-control" onchange="onModalYearChange()"
                                        style="padding:0.3rem 0.6rem; font-size:0.8rem; width:auto;">
                                        <option value="First Year">First Year</option>
                                        <option value="Second Year">Second Year</option>
                                        <option value="Third Year" selected>Third Year</option>
                                        <option value="Fourth Year">Fourth Year</option>
                                    </select>
                                </label>
                                <span class="badge" style="background:#EFF6FF; color:#2563EB; font-weight:700;"
                                    id="selectedStudentsCountBadge">
                                    Selected Students: 0
                                </span>
                            </div>
                        </div>

                        <div class="table-responsive" style="max-height: 320px; overflow-x: auto; overflow-y: auto;">
                            <table class="custom-table">
                                <thead>
                                    <tr>
                                        <th style="width:40px; text-align:center;">
                                            <input type="checkbox" id="selectAllStudentsCheckbox"
                                                onchange="toggleSelectAllStudents(this)" title="Select All Students"
                                                style="width:18px; height:18px; accent-color:var(--primary-blue); cursor:pointer;">
                                        </th>
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
                                <tbody id="eligibleStudentsTbody">
                                    <!-- Rendered dynamically -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline"
                            onclick="closeModal('assignStudentsModal')">Cancel</button>
                        <button type="button" class="btn btn-primary" onclick="confirmAssignStudents()">Assign Selected
                            Students</button>
                    </div>
                </div>
            </div>

            <!-- Delete Confirmation Modal -->
            <div class="modal-overlay" id="deleteAssignmentModal">
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
                        <button class="modal-close-btn" onclick="closeModal('deleteAssignmentModal')"
                            style="color:#991B1B;">&times;</button>
                    </div>
                    <div class="modal-body" style="padding: 1.5rem; text-align: center;">
                        <p style="font-size: 0.95rem; color: #1E293B; margin-bottom: 0.75rem; line-height: 1.5;"
                            id="deleteAssignmentModalText">
                            Are you sure you want to remove this subject assignment?
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
                            onclick="closeModal('deleteAssignmentModal')">Cancel</button>
                        <button class="btn"
                            style="padding:0.55rem 1.25rem; font-weight:800; background:#FEE2E2; color:#991B1B; border:1.5px solid #FCA5A5; border-radius:8px; cursor:pointer; font-size:0.875rem; transition:all 0.2s;"
                            onclick="executeDeleteAssignment()"
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

                let dbTeachers = [];
                let dbSubjects = [];
                let dbStudents = [];
                let dbAssignments = [];
                let activeStudentAssignContext = null;
                let pendingDeleteAssignment = null;

                function openModal(id) {
                    const el = document.getElementById(id);
                    if (el) el.classList.add('active');
                }
                function closeModal(id) {
                    const el = document.getElementById(id);
                    if (el) el.classList.remove('active');
                }

                async function fetchAllAssignmentData() {
                    try {
                        const [tRes, sRes, stRes, aRes] = await Promise.all([
                            fetch('${pageContext.request.contextPath}/api/admin/teachers'),
                            fetch('${pageContext.request.contextPath}/api/admin/subjects'),
                            fetch('${pageContext.request.contextPath}/api/admin/students'),
                            fetch('${pageContext.request.contextPath}/api/admin/teacher-subjects')
                        ]);

                        if (tRes.ok) dbTeachers = await tRes.json();
                        if (sRes.ok) dbSubjects = await sRes.json();
                        if (stRes.ok) dbStudents = await stRes.json();
                        if (aRes.ok) dbAssignments = await aRes.json();

                        onAssignDeptChange();
                    } catch (e) {
                        console.error('Error fetching assignment data from server:', e);
                        onAssignDeptChange();
                    }
                }

                function onAssignDeptChange() {
                    const selectedDept = document.getElementById('assignDeptSelect') ? document.getElementById('assignDeptSelect').value.trim().toLowerCase() : 'computer engineering';
                    const sel = document.getElementById('assignTeacherSelect');
                    if (!sel) return;

                    const filtered = dbTeachers.filter(t => {
                        const d = (t.department || t.dept || '').trim().toLowerCase();
                        return d === selectedDept;
                    });

                    sel.innerHTML = '';

                    const rawSelectedDept = document.getElementById('assignDeptSelect') ? document.getElementById('assignDeptSelect').value : 'Computer Engineering';

                    if (filtered.length === 0) {
                        sel.innerHTML = '<option value="">No teachers in ' + rawSelectedDept + '</option>';
                    } else {
                        filtered.forEach(t => {
                            const opt = document.createElement('option');
                            opt.value = t.id;
                            opt.innerText = t.name || ('Prof. ' + (t.username || t.id));
                            sel.appendChild(opt);
                        });
                    }

                    onAssignTeacherChange();
                }

                function onAssignTeacherChange() {
                    const sel = document.getElementById('assignTeacherSelect');
                    const selectedDept = document.getElementById('assignDeptSelect') ? document.getElementById('assignDeptSelect').value : 'Computer Engineering';
                    const teacherIdVal = sel ? sel.value : '';

                    const t = dbTeachers.find(x => String(x.id) === String(teacherIdVal));

                    const tName = t ? (t.name || ('Prof. ' + (t.username || t.id))) : (teacherIdVal ? 'Select Teacher' : 'No Teacher Selected');
                    const tDept = t ? (t.department || t.dept || selectedDept) : selectedDept;

                    document.getElementById('teacherDetailName').innerText = tName;
                    document.getElementById('teacherDetailDept').innerText = tDept;
                    document.getElementById('assignTeacherLabel').innerText = t ? tName : '--';
                    document.getElementById('assignedOverviewTeacher').innerText = t ? tName : '--';
                    document.getElementById('assignedTeacherBadgeName').innerText = t ? tName : '--';

                    renderAvailableSubjectsForTeacher(t);
                    renderAssignedSubjectsTable(teacherIdVal);
                }

                function renderAvailableSubjectsForTeacher(teacherObj) {
                    const container = document.getElementById('availableSubjectsList');
                    if (!container) return;
                    container.innerHTML = '';

                    const rawSelectedDept = document.getElementById('assignDeptSelect') ? document.getElementById('assignDeptSelect').value.trim() : '';
                    const selectedDept = rawSelectedDept.toLowerCase();

                    if (!selectedDept) {
                        container.innerHTML = '<div style="font-size:0.85rem; color:var(--text-muted); font-style:italic;">Select a department to view available subjects.</div>';
                        return;
                    }

                    // Currently assigned subject IDs for this teacher (if selected)
                    const assignedSubjectIds = (teacherObj && dbAssignments) ? dbAssignments
                        .filter(a => String(a.teacherId) === String(teacherObj.id))
                        .map(a => String(a.subjectId)) : [];

                    const matchingSubjects = dbSubjects.filter(s => {
                        const sDept = (s.department || s.dept || '').trim().toLowerCase();
                        const matchesDept = !selectedDept || sDept === selectedDept;
                        const notAssigned = !assignedSubjectIds.includes(String(s.id));
                        return matchesDept && notAssigned;
                    });

                    if (matchingSubjects.length === 0) {
                        container.innerHTML = '<div style="font-size:0.85rem; color:var(--text-muted); font-style:italic;">No unassigned subjects available for ' + rawSelectedDept + '.</div>';
                        return;
                    }

                    matchingSubjects.forEach(s => {
                        const semVal = s.semester || s.sem || 'Semester 5';
                        const semDisplay = String(semVal).toLowerCase().includes('semester') ? semVal : 'Semester ' + semVal;
                        const lbl = document.createElement('label');
                        lbl.style.cssText = 'display:flex; align-items:center; gap:0.75rem; padding:0.65rem 0.85rem; background:#FFFFFF; border:1.5px solid var(--border); border-radius:var(--radius-sm); font-size:0.875rem; cursor:pointer;';
                        lbl.innerHTML =
                            '<input type="checkbox" class="subject-assign-checkbox" value="' + s.id + '" data-name="' + (s.subjectName || s.name) + '" data-course="' + (s.course || 'BTech') + '" data-dept="' + (s.department || s.dept) + '" data-sem="' + semDisplay + '" style="accent-color:var(--primary-blue); width:18px; height:18px; cursor:pointer;">' +
                            '<div>' +
                            '<strong style="color:var(--primary-navy); font-size:0.925rem;">' + (s.subjectName || s.name) + ' (' + (s.subjectCode || s.code || '') + ')</strong>' +
                            '<div style="font-size:0.775rem; color:var(--text-muted); margin-top:0.15rem;">' + (s.course || 'BTech') + ' &bull; ' + (s.department || s.dept) + ' &bull; ' + semDisplay + '</div>' +
                            '</div>';
                        container.appendChild(lbl);
                    });
                }

                async function assignSelectedSubjectsToTeacher() {
                    const selTeacherId = document.getElementById('assignTeacherSelect').value;
                    if (!selTeacherId) {
                        showAssignMessage('Please select a valid teacher first.', true);
                        return;
                    }

                    const checkedBoxes = document.querySelectorAll('.subject-assign-checkbox:checked');
                    if (checkedBoxes.length === 0) {
                        showAssignMessage('Please select at least one subject to assign.', true);
                        return;
                    }

                    const selectedSubjectIds = Array.from(checkedBoxes).map(cb => cb.value);

                    try {
                        const formData = new URLSearchParams();
                        formData.append('teacherId', selTeacherId);
                        formData.append('subjectId', selectedSubjectIds.join(','));

                        const res = await fetch('${pageContext.request.contextPath}/api/admin/teacher-subjects', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                            body: formData.toString()
                        });

                        const result = await res.json();
                        if (result.status === 'success') {
                            showToast('Subject(s) assigned successfully!', 'success');
                            const aRes = await fetch('${pageContext.request.contextPath}/api/admin/teacher-subjects');
                            if (aRes.ok) dbAssignments = await aRes.json();
                            onAssignTeacherChange();
                        } else {
                            showToast(result.message || 'Error assigning subject.', 'error');
                            showAssignMessage(result.message || 'Error assigning subject.', true);
                        }
                    } catch (e) {
                        console.error('Error assigning subject:', e);
                        showToast('Server error occurred during assignment.', 'error');
                        showAssignMessage('Server error occurred during assignment.', true);
                    }
                }

                function renderAssignedSubjectsTable(teacherIdVal) {
                    const tbody = document.getElementById('assignedSubjectsTbody');
                    if (!tbody) return;
                    tbody.innerHTML = '';

                    if (!teacherIdVal) {
                        tbody.innerHTML = '<tr><td colspan="7" style="text-align:center; padding:1.5rem; color:var(--text-muted); font-style:italic;">Please select a teacher to view assigned subjects.</td></tr>';
                        return;
                    }

                    const teacherAssignments = dbAssignments.filter(a => String(a.teacherId) === String(teacherIdVal));

                    if (teacherAssignments.length === 0) {
                        tbody.innerHTML = '<tr><td colspan="7" style="text-align:center; padding:1.5rem; color:var(--text-muted); font-style:italic;">No subjects currently assigned to this teacher. Select subjects above to assign.</td></tr>';
                        return;
                    }

                    tbody.innerHTML = teacherAssignments.map((a, index) => {
                        const assignmentId = a.id;
                        const tId = a.teacherId;
                        const sId = a.subjectId;
                        const subjName = a.subjectName || (a.subject ? a.subject.subjectName : 'N/A');
                        const course = a.course || (a.subject ? a.subject.course : 'BTech');
                        const dept = a.department || (a.subject ? a.subject.department : 'Computer Engineering');
                        const semVal = a.semester || (a.subject ? a.subject.semester : 'Semester 5');
                        const semDisplay = String(semVal).toLowerCase().includes('semester') ? semVal : 'Semester ' + semVal;
                        const year = formatYearName(a.year, semVal);
                        const count = a.studentCount !== undefined ? a.studentCount : 0;

                        return '<tr>' +
                            '<td style="font-weight:700; color:var(--primary-blue);">' + (index + 1) + '</td>' +
                            '<td><strong style="color:var(--primary-navy);">' + subjName + '</strong></td>' +
                            '<td><span class="badge" style="background:#EFF6FF; color:#2563EB; font-weight:700;">' + course + '</span></td>' +
                            '<td>' + dept + '</td>' +
                            '<td>' + semDisplay + '</td>' +
                            '<td><span class="badge" style="background:#F1F5F9; color:#1E293B; font-weight:700;">' + count + ' Students</span></td>' +
                            '<td style="display:flex; gap:0.4rem; align-items:center;">' +
                            '<button class="btn btn-primary btn-sm" onclick="openAssignStudentsModalForSubject(' + tId + ', ' + sId + ', \'' + escapeJsString(subjName) + '\', \'' + escapeJsString(course) + '\', \'' + escapeJsString(dept) + '\', \'' + escapeJsString(semDisplay) + '\', \'' + escapeJsString(year) + '\')">' +
                            '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right:0.3rem;"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="16" y1="11" x2="22" y2="11"/></svg>' +
                            'Manage Students' +
                            '</button>' +
                            '<button class="btn btn-danger btn-sm" style="padding:0.4rem 0.55rem; background:#FEF2F2; color:#DC2626; border:1px solid #FCA5A5; border-radius:var(--radius-sm); cursor:pointer; display:inline-flex; align-items:center; justify-content:center;" title="Remove Subject Assignment" onclick="promptRemoveTeacherSubjectAssignment(' + assignmentId + ')">' +
                            '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>' +
                            '</button>' +
                            '</td>' +
                            '</tr>';
                    }).join('');
                }

                function escapeJsString(str) {
                    if (!str) return '';
                    return String(str).replace(/'/g, "\\'").replace(/"/g, '&quot;');
                }

                function showAssignMessage(msg, isError = false) {
                    const el = document.getElementById('assignMsgText');
                    if (!el) return;
                    el.innerText = msg;
                    el.style.color = isError ? '#DC2626' : '#16A34A';
                    el.style.display = 'block';
                    el.style.opacity = '1';

                    if (window.assignMsgTimer) clearTimeout(window.assignMsgTimer);
                    window.assignMsgTimer = setTimeout(() => {
                        el.style.opacity = '0';
                        setTimeout(() => {
                            el.style.display = 'none';
                        }, 300);
                    }, 3000);
                }

                function promptRemoveTeacherSubjectAssignment(assignmentId) {
                    const selTeacherId = document.getElementById('assignTeacherSelect') ? document.getElementById('assignTeacherSelect').value : '';
                    pendingDeleteAssignment = { id: assignmentId, teacherIdVal: selTeacherId };
                    let subjDisplay = 'this subject';

                    const a = dbAssignments.find(x => x.id == assignmentId);
                    if (a) {
                        subjDisplay = a.subjectName || (a.subject ? a.subject.subjectName : 'this subject');
                    }

                    const textEl = document.getElementById('deleteAssignmentModalText');
                    if (textEl) {
                        textEl.innerHTML = 'Are you sure you want to delete subject <span style="color:#DC2626; font-weight:700;">&quot;' + subjDisplay + '&quot;</span>?';
                    }
                    openModal('deleteAssignmentModal');
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

                async function executeDeleteAssignment() {
                    if (!pendingDeleteAssignment) return;
                    const { id, teacherIdVal } = pendingDeleteAssignment;
                    closeModal('deleteAssignmentModal');

                    try {
                        const formData = new URLSearchParams();
                        formData.append('action', 'delete');
                        formData.append('id', id);

                        const res = await fetch('${pageContext.request.contextPath}/api/admin/teacher-subjects', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                            body: formData.toString()
                        });

                        const result = await res.json();
                        if (result.status === 'success') {
                            showToast('Subject assignment deleted successfully!', 'success');
                            const aRes = await fetch('${pageContext.request.contextPath}/api/admin/teacher-subjects');
                            if (aRes.ok) dbAssignments = await aRes.json();
                            onAssignTeacherChange();
                        } else {
                            showToast(result.message || 'Error removing assignment.', 'error');
                        }
                    } catch (e) {
                        showToast('Server error occurred.', 'error');
                    }
                }

                function formatYearName(yVal, semVal) {
                    if (yVal) {
                        const yStr = String(yVal).trim();
                        if (yStr === '1' || yStr === 'First Year') return 'First Year';
                        if (yStr === '2' || yStr === 'Second Year') return 'Second Year';
                        if (yStr === '3' || yStr === 'Third Year') return 'Third Year';
                        if (yStr === '4' || yStr === 'Fourth Year') return 'Fourth Year';
                    }
                    if (semVal) {
                        const s = parseInt(String(semVal).replace(/[^0-9]/g, '')) || 5;
                        if (s <= 2) return 'First Year';
                        if (s <= 4) return 'Second Year';
                        if (s <= 6) return 'Third Year';
                        return 'Fourth Year';
                    }
                    return 'Third Year';
                }

                async function openAssignStudentsModalForSubject(teacherId, subjectId, subjName, course, dept, sem, year) {
                    const formattedYear = formatYearName(year, sem);
                    activeStudentAssignContext = { teacherId, subjectId, subjName, course, dept, sem, year: formattedYear };

                    document.getElementById('assignStudentsModalTitle').innerText = 'Manage Assigned Students: ' + subjName;
                    document.getElementById('modalYearSelect').value = formattedYear;

                    let assignedStudentIds = [];
                    try {
                        const res = await fetch('${pageContext.request.contextPath}/api/admin/student-subject-assignments?teacherId=' + teacherId + '&subjectId=' + subjectId);
                        if (res.ok) {
                            const allocations = await res.json();
                            assignedStudentIds = allocations.map(a => a.studentId);
                        }
                    } catch (e) {
                        console.error('Error fetching student assignments:', e);
                    }

                    renderModalStudentsList(assignedStudentIds);
                    openModal('assignStudentsModal');
                }

                function onModalYearChange() {
                    if (!activeStudentAssignContext) return;
                    activeStudentAssignContext.year = document.getElementById('modalYearSelect').value;
                    renderModalStudentsList([]);
                }

                function renderModalStudentsList(assignedStudentIds = []) {
                    if (!activeStudentAssignContext) return;
                    const { course, dept, sem, year } = activeStudentAssignContext;
                    const formattedYearHeader = formatYearName(year, sem);

                    const semDisplay = String(sem).toLowerCase().includes('semester') ? sem : 'Semester ' + sem;
                    document.getElementById('modalFilterCriteria').innerText = course + ' | ' + dept + ' | ' + semDisplay + ' | ' + formattedYearHeader;

                    const tbody = document.getElementById('eligibleStudentsTbody');

                    // Filter eligible students strictly by course, department, semester, year
                    const eligible = dbStudents.filter(st => {
                        const stDept = (st.department || st.dept || '').trim().toLowerCase();
                        const stCourse = (st.course || '').trim().toLowerCase();
                        const stSem = String(st.semester || st.sem || '').trim().toLowerCase();
                        const stYear = formatYearName(st.year, stSem).trim().toLowerCase();

                        const targetDept = (dept || '').trim().toLowerCase();
                        const targetCourse = (course || '').trim().toLowerCase();
                        const targetSem = String(sem || '').trim().toLowerCase();
                        const targetYear = (formattedYearHeader || '').trim().toLowerCase();

                        const matchDept = !targetDept || stDept === targetDept;
                        const matchCourse = !targetCourse || stCourse === targetCourse;
                        const matchSem = !targetSem || stSem === targetSem || (targetSem !== '' && stSem !== '' && targetSem.replace(/[^0-9]/g, '') === stSem.replace(/[^0-9]/g, ''));
                        const matchYear = !targetYear || stYear === targetYear;

                        return matchDept && matchCourse && matchSem && matchYear;
                    });

                    if (eligible.length === 0) {
                        tbody.innerHTML = '<tr><td colspan="9" style="text-align:center; padding:1.5rem; color:var(--text-muted); font-style:italic;">No matching eligible students found in database for criteria (' + course + ' • ' + dept + ' • ' + semDisplay + ' • ' + formattedYearHeader + ').</td></tr>';
                    } else {
                        tbody.innerHTML = eligible.map(st => {
                            const yearDisplay = formatYearName(st.year || year, st.semester || st.sem || sem);
                            const stSemDisplay = String(st.semester || st.sem || '').toLowerCase().includes('semester') ? (st.semester || st.sem) : 'Semester ' + (st.semester || st.sem || '--');
                            const isChecked = assignedStudentIds.includes(st.id) ? 'checked' : '';

                            return '<tr>' +
                                '<td style="text-align:center;">' +
                                '<input type="checkbox" class="eligible-student-checkbox" value="' + st.id + '" ' + isChecked + ' onchange="updateSelectedStudentsCount()" style="width:18px; height:18px; accent-color:var(--primary-blue); cursor:pointer;">' +
                                '</td>' +
                                '<td style="font-weight:700; color:var(--primary-blue);">' + (st.rollNo || st.id || '--') + '</td>' +
                                '<td><strong style="color:var(--primary-navy);">' + (st.name || '--') + '</strong></td>' +
                                '<td>' + (st.username || 'N/A') + '</td>' +
                                '<td>' + (st.email || '--') + '</td>' +
                                '<td>' + (st.course || 'BTech') + '</td>' +
                                '<td>' + (st.department || st.dept || '--') + '</td>' +
                                '<td>' + stSemDisplay + '</td>' +
                                '<td>' + yearDisplay + '</td>' +
                                '</tr>';
                        }).join('');
                    }

                    document.getElementById('selectAllStudentsCheckbox').checked = false;
                    updateSelectedStudentsCount();
                }

                function toggleSelectAllStudents(masterCb) {
                    const checkboxes = document.querySelectorAll('.eligible-student-checkbox');
                    checkboxes.forEach(cb => cb.checked = masterCb.checked);
                    updateSelectedStudentsCount();
                }

                function updateSelectedStudentsCount() {
                    const count = document.querySelectorAll('.eligible-student-checkbox:checked').length;
                    document.getElementById('selectedStudentsCountBadge').innerText = 'Selected Students: ' + count;
                }

                async function confirmAssignStudents() {
                    if (!activeStudentAssignContext) return;
                    const { teacherId, subjectId } = activeStudentAssignContext;

                    const checkedBoxes = document.querySelectorAll('.eligible-student-checkbox:checked');
                    const selectedStudentIds = Array.from(checkedBoxes).map(cb => cb.value);

                    try {
                        const formData = new URLSearchParams();
                        formData.append('teacherId', teacherId);
                        formData.append('subjectId', subjectId);
                        formData.append('studentIds', selectedStudentIds.join(','));

                        const res = await fetch('${pageContext.request.contextPath}/api/admin/student-subject-assignments', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                            body: formData.toString()
                        });

                        const result = await res.json();
                        if (result.status === 'success') {
                            showToast(selectedStudentIds.length + ' students allocated successfully!', 'success');
                            // Refetch teacher subject assignments to update student counts
                            const aRes = await fetch('${pageContext.request.contextPath}/api/admin/teacher-subjects');
                            if (aRes.ok) dbAssignments = await aRes.json();
                            renderAssignedSubjectsTable(teacherId);

                            closeModal('assignStudentsModal');
                        } else {
                            showToast('Error updating student allocation: ' + (result.message || 'Server error'), 'error');
                        }
                    } catch (e) {
                        console.error('Error saving student assignments:', e);
                        showToast('Server error occurred while saving student allocations.', 'error');
                    }
                }

                document.addEventListener('DOMContentLoaded', () => {
                    fetchAllAssignmentData();
                });
            </script>
        </body>

        </html>