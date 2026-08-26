<%@ page language = "java" contentType = "text/html; charset = UTF-8" pageEncoding = "UTF-8" %>
    <%@ page import = "java.util.List" %>
        <%@ page import = "java.util.Map" %>
            <%@ page import = "java.util.LinkedHashMap" %>
                <%@ page import = "java.util.ArrayList" %>
                    <%@ page import = "com.student.service.StudentSubjectAssignmentService" %>
                        <%@ page import = "com.student.service.TeacherSubjectService" %>
                            <%@ page import = "com.student.entity.StudentSubjectAssignment" %>
                                <%@ page import = "com.student.entity.TeacherSubject" %>
                                    <%@ page import = "com.student.entity.Student" %>
                                        <%@ page import = "com.student.entity.Subject" %>
                                            <%@ page import = "com.student.entity.Teacher" %>
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
                                                    if (loggedInTeacher.getName() != null && !loggedInTeacher.getName().trim().isEmpty())
                                                    {
                                                        teacherFirstName = loggedInTeacher.getName().trim();
                                                        teacherInitial = String.valueOf(teacherFirstName.charAt(0)).toUpperCase();
                                                    }
                                                    int teacherId = loggedInTeacher.getId();
                                                    String subjectParam = request.getParameter("subjectId");
                                                    int filterSubjectId = 0;
                                                    if (subjectParam != null && !subjectParam.trim().isEmpty())
                                                    {
                                                        try
                                                        {
                                                            filterSubjectId = Integer.parseInt(subjectParam);
                                                        }
                                                        catch (Exception e)
                                                        {
                                                        }
                                                    }
                                                    TeacherSubjectService tsService = new TeacherSubjectService();
                                                    List<TeacherSubject> teacherSubjects = tsService.getTeacherSubjectsByTeacherId(teacherId);
                                                    StudentSubjectAssignmentService ssaService = new StudentSubjectAssignmentService();
                                                    List<StudentSubjectAssignment> allAssignments = ssaService.getAssignmentsByTeacher(teacherId);
                                                    Map<Integer, Subject> assignedSubjectsMap = new LinkedHashMap<> ();
                                                    if (teacherSubjects != null)
                                                    {
                                                        for (TeacherSubject ts : teacherSubjects)
                                                        {
                                                            if (ts != null && ts.getSubject() != null)
                                                            {
                                                                assignedSubjectsMap.put(ts.getSubject().getId(), ts.getSubject());
                                                            }
                                                        }
                                                    }
                                                    if (allAssignments != null)
                                                    {
                                                        for (StudentSubjectAssignment ssa : allAssignments)
                                                        {
                                                            if (ssa != null && ssa.getSubject() != null)
                                                            {
                                                                assignedSubjectsMap.put(ssa.getSubject().getId(), ssa.getSubject());
                                                            }
                                                        }
                                                    }
                                                    List<Subject> assignedSubjectsList = new ArrayList<> (assignedSubjectsMap.values());
                                                %>
                                                                        <!DOCTYPE html>
                                                                        <html lang="en">

                                                                        <head>
                                                                            <meta charset="UTF-8">
                                                                            <meta name="viewport"
                                                                                content="width=device-width, initial-scale=1.0">
                                                                            <title>Assigned Students - Teacher Dashboard
                                                                            </title>
                                                                            
                                                                            <link rel="preconnect"
                                                                                href="https://fonts.googleapis.com">
                                                                            <link rel="preconnect"
                                                                                href="https://fonts.gstatic.com"
                                                                                crossorigin>
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
                                                                            <div class="sidebar-overlay"
                                                                                id="sidebarOverlay"></div>

                                                                            <aside class="sidebar" id="sidebar">
                                                                                <div class="sidebar-brand">
                                                                                    <svg viewBox="0 0 24 24" fill="none"
                                                                                        stroke="currentColor"
                                                                                        stroke-width="2.5">
                                                                                        <path
                                                                                            d="M22 10v6M2 10l10-5 10 5-10 5z" />
                                                                                        <path
                                                                                            d="M6 12v5c3 3 9 3 12 0v-5" />
                                                                                    </svg>
                                                                                    <div class="brand-text">
                                                                                        <span
                                                                                            class="brand-line1">Student
                                                                                            Management</span>
                                                                                        <span
                                                                                            class="brand-line2">System</span>
                                                                                    </div>
                                                                                </div>
                                                                                <ul class="sidebar-menu">
                                                                                    <li class="nav-item"><a
                                                                                            href="dashboard.jsp"><svg
                                                                                                viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor">
                                                                                                <rect x="3" y="3"
                                                                                                    width="7"
                                                                                                    height="7" />
                                                                                                <rect x="14" y="3"
                                                                                                    width="7"
                                                                                                    height="7" />
                                                                                                <rect x="14" y="14"
                                                                                                    width="7"
                                                                                                    height="7" />
                                                                                                <rect x="3" y="14"
                                                                                                    width="7"
                                                                                                    height="7" />
                                                                                            </svg><span>Dashboard</span></a>
                                                                                    </li>
                                                                                    <li class="nav-item"><a
                                                                                            href="subjects.jsp"><svg
                                                                                                viewBox="0 0 24 24" <li
                                                                                                class="nav-item"><a
                                                                                                    href="subjects.jsp"><svg
                                                                                                        viewBox="0 0 24 24"
                                                                                                        fill="none"
                                                                                                        stroke="currentColor"
                                                                                                        stroke-width="2">
                                                                                                        <path
                                                                                                            d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                                                                        <path
                                                                                                            d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                                                                    </svg><span>Assigned
                                                                                                        Subjects</span></a>
                                                                                    </li>
                                                                                    <li class="nav-item active"><a
                                                                                            href="students.jsp"><svg
                                                                                                viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor">
                                                                                                <path
                                                                                                    d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                                                                <circle cx="9" cy="7"
                                                                                                    r="4" />
                                                                                            </svg><span>Assigned
                                                                                                Students</span></a></li>
                                                                                    <li class="nav-item"><a
                                                                                            href="cce-marks.jsp"><svg
                                                                                                viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor"
                                                                                                stroke-width="2">
                                                                                                <path
                                                                                                    d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                                                                <path
                                                                                                    d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                                                            </svg><span>CCE
                                                                                                Marks</span></a></li>
                                                                                    <li class="nav-item"><a
                                                                                            href="end-sem-marks.jsp"><svg
                                                                                                viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor"
                                                                                                stroke-width="2">
                                                                                                <path
                                                                                                    d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                                                                                <polyline
                                                                                                    points="14 2 14 8 20 8" />
                                                                                                <line x1="16" y1="13"
                                                                                                    x2="8" y2="13" />
                                                                                                <line x1="16" y1="17"
                                                                                                    x2="8" y2="17" />
                                                                                            </svg><span>End Sem
                                                                                                Marks</span></a></li>
                                                                                    <li class="nav-item"><a
                                                                                            href="results.jsp"><svg
                                                                                                viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor"
                                                                                                stroke-width="2">
                                                                                                <path
                                                                                                    d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                                                                                                <polyline
                                                                                                    points="22 4 12 14.01 9 11.01" />
                                                                                            </svg><span>View
                                                                                                Results</span></a></li>
                                                                                    <li class="nav-item"><a
                                                                                            href="profile.jsp"><svg
                                                                                                viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor">
                                                                                                <path
                                                                                                    d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                                                                                <circle cx="12" cy="7"
                                                                                                    r="4" />
                                                                                            </svg><span>Profile</span></a>
                                                                                    </li>
                                                                                </ul>
                                                                                <div class="sidebar-footer">
                                                                                    <a href="${pageContext.request.contextPath}/logout"
                                                                                        class="logout-link"
                                                                                        onclick="return openLogoutModal(event)">
                                                                                        <svg width="20" height="20"
                                                                                            viewBox="0 0 24 24"
                                                                                            fill="none"
                                                                                            stroke="currentColor"
                                                                                            stroke-width="2">
                                                                                            <path
                                                                                                d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                                                                                            <polyline
                                                                                                points="16 17 21 12 16 7" />
                                                                                            <line x1="21" y1="12" x2="9"
                                                                                                y2="12" />
                                                                                        </svg>
                                                                                        <span>Logout</span>
                                                                                    </a>
                                                                                </div>
                                                                            </aside>

                                                                            <div class="main-wrapper">
                                                                                <header class="top-navbar">
                                                                                    <div class="top-left">
                                                                                        <button class="menu-toggle-btn"
                                                                                            id="menuToggleBtn"
                                                                                            aria-label="Toggle menu">
                                                                                            <svg width="24" height="24"
                                                                                                viewBox="0 0 24 24"
                                                                                                fill="none"
                                                                                                stroke="currentColor"
                                                                                                stroke-width="2">
                                                                                                <line x1="3" y1="12"
                                                                                                    x2="21" y2="12" />
                                                                                                <line x1="3" y1="6"
                                                                                                    x2="21" y2="6" />
                                                                                                <line x1="3" y1="18"
                                                                                                    x2="21" y2="18" />
                                                                                            </svg>
                                                                                        </button>
                                                                                        <h1 class="page-title">Assigned
                                                                                            Students</h1>
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
                                                                                                <span
                                                                                                    class="user-role-label">Teacher</span>
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
                                                                                                style="background-color: #DCFCE7; color: #15803D; padding: 0.85rem 1.25rem; border-radius: 10px; margin-bottom: 1.5rem; font-weight: 700; border: 1px solid #BBF7D0; display: flex; align-items: center; gap: 0.5rem;">
                                                                                                <svg width="20"
                                                                                                    height="20"
                                                                                                    viewBox="0 0 24 24"
                                                                                                    fill="none"
                                                                                                    stroke="currentColor"
                                                                                                    stroke-width="2.5">
                                                                                                    <polyline
                                                                                                        points="20 6 9 17 4 12" />
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
                                                                                                        style="background-color: #FEE2E2; color: #DC2626; padding: 0.85rem 1.25rem; border-radius: 10px; margin-bottom: 1.5rem; font-weight: 700; border: 1px solid #FCA5A5; display: flex; align-items: center; gap: 0.5rem;">
                                                                                                        <svg width="20"
                                                                                                            height="20"
                                                                                                            viewBox="0 0 24 24"
                                                                                                            fill="none"
                                                                                                            stroke="currentColor"
                                                                                                            stroke-width="2.5">
                                                                                                            <circle
                                                                                                                cx="12"
                                                                                                                cy="12"
                                                                                                                r="10" />
                                                                                                            <line
                                                                                                                x1="12"
                                                                                                                y1="8"
                                                                                                                x2="12"
                                                                                                                y2="12" />
                                                                                                            <line
                                                                                                                x1="12"
                                                                                                                y1="16"
                                                                                                                x2="12.01"
                                                                                                                y2="16" />
                                                                                                        </svg>
                                                                                                        <span>
                                                                                                            <%= request.getParameter("error") %>
                                                                                                        </span>
                                                                                                    </div>
                                                                                                    <%
                                                                                                        }
                                                                                                    %>

                                                                                                        <div
                                                                                                            class="content-card">
                                                                                                            <div
                                                                                                                class="card-header-row">
                                                                                                                <div>
                                                                                                                    <h3>Assigned
                                                                                                                        Student
                                                                                                                        Records
                                                                                                                    </h3>
                                                                                                                    <p
                                                                                                                        style="font-size: 0.85rem; color: var(--text-muted);">
                                                                                                                        Overview
                                                                                                                        of
                                                                                                                        students
                                                                                                                        enrolled
                                                                                                                        in
                                                                                                                        your
                                                                                                                        assigned
                                                                                                                        subjects.
                                                                                                                    </p>
                                                                                                                </div>
                                                                                                            </div>

                                                                                                            <!-- Search & Filter Toolbar -->
                                                                                                            <div
                                                                                                                class="table-toolbar">
                                                                                                                <div
                                                                                                                    class="search-box">
                                                                                                                    <svg class="search-icon"
                                                                                                                        viewBox="0 0 24 24"
                                                                                                                        fill="none"
                                                                                                                        stroke="currentColor"
                                                                                                                        stroke-width="2">
                                                                                                                        <circle
                                                                                                                            cx="11"
                                                                                                                            cy="11"
                                                                                                                            r="8" />
                                                                                                                        <line
                                                                                                                            x1="21"
                                                                                                                            y1="21"
                                                                                                                            x2="16.65"
                                                                                                                            y2="16.65" />
                                                                                                                    </svg>
                                                                                                                    <input
                                                                                                                        type="text"
                                                                                                                        id="searchInput"
                                                                                                                        placeholder="Search student name or roll no..."
                                                                                                                        onkeyup="filterTable()">
                                                                                                                </div>
                                                                                                                <select
                                                                                                                    class="filter-select"
                                                                                                                    id="subjectFilter"
                                                                                                                    onchange="filterTable()">
                                                                                                                    <option
                                                                                                                        value="">
                                                                                                                        All
                                                                                                                        Subjects
                                                                                                                    </option>
                                                                                                                    <%
                                                                                                                        if (assignedSubjectsList != null && !assignedSubjectsList.isEmpty())
                                                                                                                        {
                                                                                                                            for (Subject subObj : assignedSubjectsList)
                                                                                                                            {
                                                                                                                                boolean isSelected = filterSubjectId == subObj.getId();
                                                                                                                    %>
                                                                                                                        <option
                                                                                                                            value="<%= subObj.getId() %>"
                                                                                                                            <%= isSelected
                                                                                                                            ? "selected"
                                                                                                                            : "" %>
                                                                                                                            >
                                                                                                                            <%= subObj.getSubjectName() %>
                                                                                                                        </option>
                                                                                                                        <%
                                                                                                                            }
                                                                                                                            }
                                                                                                                        %>
                                                                                                                </select>
                                                                                                                <select
                                                                                                                    class="filter-select"
                                                                                                                    id="semFilter"
                                                                                                                    onchange="filterTable()">
                                                                                                                    <option
                                                                                                                        value="">
                                                                                                                        All
                                                                                                                        Semesters
                                                                                                                    </option>
                                                                                                                    <option
                                                                                                                        value="Semester 1">
                                                                                                                        Semester
                                                                                                                        1
                                                                                                                    </option>
                                                                                                                    <option
                                                                                                                        value="Semester 2">
                                                                                                                        Semester
                                                                                                                        2
                                                                                                                    </option>
                                                                                                                    <option
                                                                                                                        value="Semester 3">
                                                                                                                        Semester
                                                                                                                        3
                                                                                                                    </option>
                                                                                                                    <option
                                                                                                                        value="Semester 4">
                                                                                                                        Semester
                                                                                                                        4
                                                                                                                    </option>
                                                                                                                    <option
                                                                                                                        value="Semester 5">
                                                                                                                        Semester
                                                                                                                        5
                                                                                                                    </option>
                                                                                                                    <option
                                                                                                                        value="Semester 6">
                                                                                                                        Semester
                                                                                                                        6
                                                                                                                    </option>
                                                                                                                    <option
                                                                                                                        value="Semester 7">
                                                                                                                        Semester
                                                                                                                        7
                                                                                                                    </option>
                                                                                                                    <option
                                                                                                                        value="Semester 8">
                                                                                                                        Semester
                                                                                                                        8
                                                                                                                    </option>
                                                                                                                </select>
                                                                                                                <select
                                                                                                                    class="filter-select"
                                                                                                                    id="yearFilter"
                                                                                                                    onchange="filterTable()">
                                                                                                                    <option
                                                                                                                        value="">
                                                                                                                        All
                                                                                                                        Years
                                                                                                                    </option>
                                                                                                                    <option
                                                                                                                        value="First Year">
                                                                                                                        First
                                                                                                                        Year
                                                                                                                    </option>
                                                                                                                    <option
                                                                                                                        value="Second Year">
                                                                                                                        Second
                                                                                                                        Year
                                                                                                                    </option>
                                                                                                                    <option
                                                                                                                        value="Third Year">
                                                                                                                        Third
                                                                                                                        Year
                                                                                                                    </option>
                                                                                                                    <option
                                                                                                                        value="Fourth Year">
                                                                                                                        Fourth
                                                                                                                        Year
                                                                                                                    </option>
                                                                                                                </select>
                                                                                                            </div>

                                                                                                            <div
                                                                                                                class="table-responsive">
                                                                                                                <table
                                                                                                                    class="data-table"
                                                                                                                    id="studentsTable">
                                                                                                                    <thead>
                                                                                                                        <tr>
                                                                                                                            <th>Sr.
                                                                                                                                No.
                                                                                                                            </th>
                                                                                                                            <th>Full
                                                                                                                                Name
                                                                                                                            </th>
                                                                                                                            <th>Gender
                                                                                                                            </th>
                                                                                                                            <th>Roll
                                                                                                                                No
                                                                                                                            </th>
                                                                                                                            <th>Username
                                                                                                                            </th>
                                                                                                                            <th>Email
                                                                                                                            </th>
                                                                                                                            <th>Phone
                                                                                                                            </th>
                                                                                                                            <th>Subject
                                                                                                                            </th>
                                                                                                                            <th>Course
                                                                                                                            </th>
                                                                                                                            <th>Department
                                                                                                                            </th>
                                                                                                                            <th>Semester
                                                                                                                            </th>
                                                                                                                            <th>Year
                                                                                                                            </th>
                                                                                                                            <th>Actions
                                                                                                                            </th>
                                                                                                                        </tr>
                                                                                                                    </thead>
                                                                                                                    <tbody
                                                                                                                        id="studentTableBody">
                                                                                                                        <!-- Dynamic rows rendered by JS -->
                                                                                                                    </tbody>
                                                                                                                </table>
                                                                                                            </div>
                                                                                                        </div>
                                                                                    </div>
                                                                                </main>
                                                                            </div>

                                                                            <!-- View Modal -->
                                                                            <div class="modal-backdrop"
                                                                                id="viewStudentModal">
                                                                                <div class="modal-card"
                                                                                    style="max-width: 520px;">
                                                                                    <div class="modal-header">
                                                                                        <h4>Student Details</h4>
                                                                                        <button type="button"
                                                                                            class="modal-close-btn"
                                                                                            onclick="closeModal('viewStudentModal')">&times;</button>
                                                                                    </div>
                                                                                    <div class="modal-body"
                                                                                        id="viewStudentModalBody"
                                                                                        style="gap: 0.85rem;">
                                                                                        <!-- Content populated dynamically -->
                                                                                    </div>
                                                                                    <div class="modal-footer">
                                                                                        <button type="button"
                                                                                            class="btn btn-primary"
                                                                                            onclick="closeModal('viewStudentModal')">Close</button>
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

                                                                                // Data array populated from database
                                                                                let studentsData = [
<%
    if (allAssignments != null && !allAssignments.isEmpty())
    {
        for (int i = 0; i < allAssignments.size(); i++)
        {
            StudentSubjectAssignment ssa = allAssignments.get(i);
            if (ssa == null) continue;
            Student st = ssa.getStudent();
            Subject sub = ssa.getSubject();
            if (st == null) continue;
            int sId = st.getId();
            String name = st.getName() != null ? st.getName().replace("\\", "\\\\").replace("\"", "\\\"") : "";
            String gender = st.getGender() != null ? st.getGender() : "Male";
            String rollNo = st.getRollNo() != null ? st.getRollNo() : String.valueOf(st.getId());
            String username = st.getUsername() != null ? st.getUsername().replace("\\", "\\\\").replace("\"", "\\\"") : "";
            String email = st.getEmail() != null ? st.getEmail().replace("\\", "\\\\").replace("\"", "\\\"") : "";
            String phone = st.getPhone() != null ? st.getPhone().replace("\\", "\\\\").replace("\"", "\\\"") : "";
            String course = st.getCourse() != null ? st.getCourse().replace("\\", "\\\\").replace("\"", "\\\"") : "BTech";
            String dept = st.getDepartment() != null ? st.getDepartment().replace("\\", "\\\\").replace("\"", "\\\"") : "Computer Engineering";
            String sem = st.getSemester() != null ? st.getSemester() : "Semester 5";
            String year = st.getYear() != null ? st.getYear() : "Third Year";
            int subId = sub != null ? sub.getId() : 0;
            String subName = sub != null && sub.getSubjectName() != null ? sub.getSubjectName().replace("\\", "\\\\").replace("\"", "\\\"") : "General";
%>
                                                                                            {
                                                                                                id: <%= sId %>,
                                                                                            name: "<%= name %>",
                                                                                                gender: "<%= gender %>",
                                                                                                    rollNo: "<%= rollNo %>",
                                                                                                        username: "<%= username %>",
                                                                                                            email: "<%= email %>",
                                                                                                                phone: "<%= phone %>",
                                                                                                                    course: "<%= course %>",
                                                                                                                        dept: "<%= dept %>",
                                                                                                                            sem: "<%= sem %>",
                                                                                                                                year: "<%= year %>",
                                                                                                                                    subjectId: <%= subId %>,
                                                                                                                                        subjectName: "<%= subName %>"
                                                                                    }<%= (i < allAssignments.size() - 1) ? "," : "" %>
<%
    }
    }
%>
        ];

                                                                                function formatGender(g) {
                                                                                    return g ? String(g).trim() : 'Male';
                                                                                }

                                                                                function renderStudentsTable(data = studentsData) {
                                                                                    const tbody = document.getElementById('studentTableBody');
                                                                                    if (!tbody) return;
                                                                                    tbody.innerHTML = '';

                                                                                    if (!data || data.length === 0) {
                                                                                        tbody.innerHTML = `<tr><td colspan="13" style="text-align:center; padding: 2rem; color: var(--text-muted);">No student records found matching the filters.</td></tr>`;
                                                                                        return;
                                                                                    }

                                                                                    data.forEach((s, index) => {
                                                                                        const tr = document.createElement('tr');
                                                                                        const sSem = s.sem || '--';
                                                                                        const sYear = s.year || '--';

                                                                                        tr.innerHTML =
                                                                                            '<td style="font-weight:700; color: var(--primary-navy);">' + (index + 1) + '</td>' +
                                                                                            '<td><strong>' + (s.name || '--') + '</strong></td>' +
                                                                                            '<td><span class="badge" style="background:#F1F5F9; color:#334155; font-weight:700;">' + formatGender(s.gender) + '</span></td>' +
                                                                                            '<td style="font-weight:700; color: var(--text-main);">' + (s.rollNo || '--') + '</td>' +
                                                                                            '<td>' + (s.username || '--') + '</td>' +
                                                                                            '<td>' + (s.email || '--') + '</td>' +
                                                                                            '<td>' + (s.phone || '--') + '</td>' +
                                                                                            '<td><span style="font-weight:700; color: var(--primary-blue);">' + (s.subjectName || '--') + '</span></td>' +
                                                                                            '<td>' + (s.course || '--') + '</td>' +
                                                                                            '<td>' + (s.dept || '--') + '</td>' +
                                                                                            '<td>' + sSem + '</td>' +
                                                                                            '<td>' + sYear + '</td>' +
                                                                                            '<td>' +
                                                                                            '<a href="cce-marks.jsp" class="btn" style="background:#EFF6FF; color:#2563EB; border:1px solid #BFDBFE; padding:0.35rem 0.75rem; font-size:0.75rem; font-weight:700; border-radius:6px; text-decoration:none; display:inline-flex; align-items:center; gap:0.35rem; transition:all 0.2s ease;">' +
                                                                                            '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>' +
                                                                                            'Enter Marks</a>' +
                                                                                            '</td>';
                                                                                        tbody.appendChild(tr);
                                                                                    });
                                                                                }

                                                                                function filterTable() {
                                                                                    const query = document.getElementById('searchInput').value.toLowerCase();
                                                                                    const subjectId = document.getElementById('subjectFilter').value;
                                                                                    const sem = document.getElementById('semFilter').value.toLowerCase();
                                                                                    const year = document.getElementById('yearFilter').value.toLowerCase();

                                                                                    const filtered = studentsData.filter(s => {
                                                                                        const matchText = (s.name || '').toLowerCase().includes(query) ||
                                                                                            (s.rollNo || '').toLowerCase().includes(query) ||
                                                                                            (s.username || '').toLowerCase().includes(query) ||
                                                                                            (s.email || '').toLowerCase().includes(query);
                                                                                        const matchSubject = !subjectId || String(s.subjectId) === String(subjectId);
                                                                                        const matchSem = !sem || (s.sem && s.sem.toLowerCase() === sem);
                                                                                        const matchYear = !year || (s.year && s.year.toLowerCase() === year);
                                                                                        return matchText && matchSubject && matchSem && matchYear;
                                                                                    });

                                                                                    renderStudentsTable(filtered);
                                                                                }

                                                                                function viewStudentDetails(studentId, subjectId) {
                                                                                    const s = studentsData.find(item => item.id === studentId && item.subjectId === subjectId) || studentsData.find(item => item.id === studentId);
                                                                                    if (!s) return;

                                                                                    const modalBody = document.getElementById('viewStudentModalBody');
                                                                                    modalBody.innerHTML = `
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap:0.85rem; font-size:0.875rem;">
                    <div><span style="color:var(--text-muted); font-weight:600;">Full Name:</span><br><strong>\${s.name || '--'}</strong></div>
                    <div><span style="color:var(--text-muted); font-weight:600;">Roll No:</span><br><strong>\${s.rollNo || '--'}</strong></div>
                    <div><span style="color:var(--text-muted); font-weight:600;">Gender:</span><br><strong>\${formatGender(s.gender)}</strong></div>
                    <div><span style="color:var(--text-muted); font-weight:600;">Username:</span><br><strong>\${s.username || '--'}</strong></div>
                    <div><span style="color:var(--text-muted); font-weight:600;">Email:</span><br><strong>\${s.email || '--'}</strong></div>
                    <div><span style="color:var(--text-muted); font-weight:600;">Phone:</span><br><strong>\${s.phone || '--'}</strong></div>
                    <div><span style="color:var(--text-muted); font-weight:600;">Course:</span><br><strong>\${s.course || '--'}</strong></div>
                    <div><span style="color:var(--text-muted); font-weight:600;">Department:</span><br><strong>\${s.dept || '--'}</strong></div>
                    <div><span style="color:var(--text-muted); font-weight:600;">Semester:</span><br><strong>\${s.sem || '--'}</strong></div>
                    <div><span style="color:var(--text-muted); font-weight:600;">Year:</span><br><strong>\${s.year || '--'}</strong></div>
                    <div style="grid-column: span 2;"><span style="color:var(--text-muted); font-weight:600;">Subject:</span><br><strong style="color:var(--primary-blue);">\${s.subjectName || '--'}</strong></div>
                </div>
            `;
                                                                                    openModal('viewStudentModal');
                                                                                }

                                                                                function openModal(id) {
                                                                                    const el = document.getElementById(id);
                                                                                    if (el) el.classList.add('open');
                                                                                }

                                                                                function closeModal(id) {
                                                                                    const el = document.getElementById(id);
                                                                                    if (el) el.classList.remove('open');
                                                                                }

                                                                                document.addEventListener('DOMContentLoaded', () => {
                                                                                    filterTable();
                                                                                });
                                                                            </script>
                                                                        </body>

                                                                        </html>