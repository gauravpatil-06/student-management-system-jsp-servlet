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
        StudentService studentService = new StudentService();
        TeacherService teacherService = new TeacherService();
        SubjectService subjectService = new SubjectService();
        java.util.List<com.student.entity.Student> dbStudents = studentService.getAllStudents();
        java.util.List<com.student.entity.Teacher> dbTeachers = teacherService.getAllTeachers();
        java.util.List<com.student.entity.Subject> dbSubjects = subjectService.getAllSubjects();
        long totalStudentsCount = studentService.getStudentCount();
        long totalTeachersCount = teacherService.getTeacherCount();
        long totalSubjectsCount = subjectService.getSubjectCount();
        java.util.Set<String> departmentsSet = new java.util.HashSet<>();
        if (dbStudents != null)
        {
            for (com.student.entity.Student s : dbStudents)
            {
                if (s.getDepartment() != null && !s.getDepartment().trim().isEmpty())
                {
                    departmentsSet.add(s.getDepartment().trim());
                }
            }
        }
        if (dbTeachers != null)
        {
            for (com.student.entity.Teacher t : dbTeachers)
            {
                if (t.getDepartment() != null && !t.getDepartment().trim().isEmpty())
                {
                    departmentsSet.add(t.getDepartment().trim());
                }
            }
        }
        if (dbSubjects != null)
        {
            for (com.student.entity.Subject sub : dbSubjects)
            {
                if (sub.getDepartment() != null && !sub.getDepartment().trim().isEmpty())
                {
                    departmentsSet.add(sub.getDepartment().trim());
                }
            }
        }
        int totalDepartmentsCount = departmentsSet.isEmpty() ? 5 : departmentsSet.size();
    %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Admin Dashboard - Student Management System</title>

                            
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
                                    overflow-y: auto;
                                }

                                .nav-item a {
                                    display: flex;
                                    align-items: center;
                                    gap: 0.9rem;
                                    padding: 0.85rem 1.1rem;
                                    border-radius: var(--radius-sm);
                                    color: #94A3B8;
                                    font-size: 0.925rem;
                                    font-weight: 600;
                                    transition: var(--transition);
                                    cursor: pointer;
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
                                    padding: 0.4rem 0.85rem;
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

                                /* Dashboard Content */
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

                                .section-pane {
                                    display: none;
                                    flex-direction: column;
                                    gap: 2rem;
                                    animation: fadeIn 0.3s ease-in-out;
                                }

                                .section-pane.active-pane {
                                    display: flex;
                                }

                                @keyframes fadeIn {
                                    from {
                                        opacity: 0;
                                        transform: translateY(6px);
                                    }

                                    to {
                                        opacity: 1;
                                        transform: translateY(0);
                                    }
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
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                }

                                .stat-icon-students {
                                    background: var(--light-blue);
                                    color: var(--primary-blue);
                                }

                                .stat-icon-teachers {
                                    background: rgba(30, 58, 95, 0.1);
                                    color: var(--primary-navy);
                                }

                                .stat-icon-subjects {
                                    background: rgba(245, 158, 11, 0.1);
                                    color: var(--warning);
                                }

                                .stat-icon-depts {
                                    background: rgba(22, 163, 74, 0.1);
                                    color: var(--success);
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

                                /* Content Card */
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
                                    flex-wrap: wrap;
                                    gap: 1rem;
                                }

                                .card-header-row h3 {
                                    font-size: 1.15rem;
                                    font-weight: 800;
                                    color: var(--primary-navy);
                                }

                                /* Action Cards Grid */
                                .action-cards-grid {
                                    display: grid;
                                    grid-template-columns: repeat(4, 1fr);
                                    gap: 1.25rem;
                                    margin-bottom: 1.5rem;
                                }

                                .action-card {
                                    background: var(--bg-main);
                                    border: 1px solid var(--border);
                                    border-radius: var(--radius-md);
                                    padding: 1.25rem;
                                    display: flex;
                                    flex-direction: column;
                                    gap: 0.75rem;
                                    transition: var(--transition);
                                    cursor: pointer;
                                }

                                .action-card:hover {
                                    background: var(--card-bg);
                                    border-color: var(--primary-blue);
                                    transform: translateY(-3px);
                                    box-shadow: var(--shadow-hover);
                                }

                                .action-icon {
                                    width: 40px;
                                    height: 40px;
                                    border-radius: var(--radius-sm);
                                    background: var(--light-blue);
                                    color: var(--primary-blue);
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                }

                                .action-card:hover .action-icon {
                                    background: var(--primary-blue);
                                    color: #FFFFFF;
                                }

                                .action-title {
                                    font-size: 0.95rem;
                                    font-weight: 700;
                                    color: var(--primary-navy);
                                }

                                .action-desc {
                                    font-size: 0.775rem;
                                    color: var(--text-muted);
                                }

                                /* Search & Filter Toolbar */
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
                                    transition: var(--transition);
                                }

                                .filter-select:focus {
                                    border-color: var(--primary-blue);
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

                                /* Tables */
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
                                    min-width: 1100px;
                                    border-collapse: collapse;
                                    text-align: left;
                                    white-space: nowrap;
                                }

                                .custom-table th {
                                    padding: 0.85rem 1rem;
                                    font-size: 0.775rem;
                                    font-weight: 700;
                                    color: var(--text-muted);
                                    text-transform: uppercase;
                                    letter-spacing: 0.04em;
                                    background: var(--bg-main);
                                    border-bottom: 1px solid var(--border);
                                }

                                .custom-table td {
                                    padding: 0.95rem 1rem;
                                    font-size: 0.9rem;
                                    font-weight: 500;
                                    border-bottom: 1px solid var(--border);
                                }

                                .custom-table tr:hover td {
                                    background: var(--light-blue);
                                }

                                /* Badges */
                                .badge {
                                    display: inline-block;
                                    padding: 0.25rem 0.65rem;
                                    border-radius: 50px;
                                    font-size: 0.75rem;
                                    font-weight: 700;
                                    text-transform: uppercase;
                                    letter-spacing: 0.03em;
                                }

                                .badge-success {
                                    background: #DCFCE7;
                                    color: #15803D;
                                }

                                .badge-info {
                                    background: #E0F2FE;
                                    color: #0369A1;
                                }

                                /* Profile Details Grid */
                                .profile-grid {
                                    display: grid;
                                    grid-template-columns: repeat(2, 1fr);
                                    gap: 1.5rem;
                                }

                                .profile-field {
                                    background: var(--bg-main);
                                    padding: 1.15rem 1.25rem;
                                    border-radius: var(--radius-sm);
                                    border: 1px solid var(--border);
                                }

                                .profile-field label {
                                    display: block;
                                    font-size: 0.75rem;
                                    font-weight: 700;
                                    color: var(--text-muted);
                                    text-transform: uppercase;
                                    letter-spacing: 0.04em;
                                    margin-bottom: 0.35rem;
                                }

                                .profile-field span {
                                    font-size: 1rem;
                                    font-weight: 700;
                                    color: var(--primary-navy);
                                }

                                /* Modal Overlay & Card */
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
                                    animation: fadeIn 0.25s ease-out;
                                }

                                .modal-card {
                                    background: #FFFFFF;
                                    border-radius: var(--radius-md);
                                    width: 100%;
                                    max-width: 520px;
                                    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
                                    overflow: hidden;
                                    border: 1px solid var(--border);
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

                                .modal-close-btn:hover {
                                    color: var(--error);
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

                                .form-group input:focus,
                                .form-group select:focus {
                                    border-color: var(--primary-blue);
                                    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
                                }

                                .modal-footer {
                                    padding: 1rem 1.5rem;
                                    background: var(--bg-main);
                                    border-top: 1px solid var(--border);
                                    display: flex;
                                    justify-content: flex-end;
                                    gap: 0.75rem;
                                }

                                /* Responsive Breakpoints */
                                @media (max-width: 1024px) {

                                    .summary-grid,
                                    .action-cards-grid {
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

                                    .welcome-card {
                                        flex-direction: column;
                                        align-items: flex-start;
                                        gap: 1rem;
                                    }

                                    .welcome-visual {
                                        display: none;
                                    }

                                    .profile-grid {
                                        grid-template-columns: 1fr;
                                    }
                                }

                                @media (max-width: 580px) {

                                    .summary-grid,
                                    .action-cards-grid {
                                        grid-template-columns: 1fr;
                                    }

                                    .content-area {
                                        padding: 1rem;
                                    }
                                }
                            </style>
                        </head>

                        <body>
                            <jsp:include page="/logout-modal.jsp" />
                            <!-- Mobile Sidebar Backdrop Overlay -->
                            <div class="sidebar-overlay" id="sidebarOverlay"></div>

                            <!-- 1. Left Sidebar Navigation -->
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
                                        <a href="students.jsp">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                <circle cx="9" cy="7" r="4" />
                                                <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                                                <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                                            </svg>
                                            <span>Student Management</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="teachers.jsp">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                                <rect x="2" y="7" width="20" height="14" rx="2" ry="2" />
                                                <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                                            </svg>
                                            <span>Teacher Management</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="subject-assignment.jsp">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                <path
                                                    d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                <line x1="9" y1="7" x2="15" y2="7" />
                                                <line x1="9" y1="11" x2="15" y2="11" />
                                            </svg>
                                            <span>Subject Assignment</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="subjects.jsp">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path
                                                    d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                                            </svg>
                                            <span>Subject Management</span>
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
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                            stroke-linejoin="round">
                                            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                                            <polyline points="16 17 21 12 16 7" />
                                            <line x1="21" y1="12" x2="9" y2="12" />
                                        </svg>
                                        <span>Logout</span>
                                    </a>
                                </div>
                            </aside>

                            <!-- 2. Main Content Wrapper -->
                            <div class="main-wrapper">
                                <header class="top-navbar">
                                    <div class="top-left">
                                        <button class="menu-toggle-btn" id="menuToggleBtn" aria-label="Toggle menu">
                                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <line x1="3" y1="12" x2="21" y2="12" />
                                                <line x1="3" y1="6" x2="21" y2="6" />
                                                <line x1="3" y1="18" x2="21" y2="18" />
                                            </svg>
                                        </button>
                                        <h1 class="page-title" id="headerTitle">Admin Dashboard</h1>
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
                                    <div class="dashboard-container">

                                        <%
                                            if (request.getParameter("success") != null)
                                            {
                                        %>
                                            <div id="alertBanner"
                                                style="background-color: #DCFCE7; color: #15803D; padding: 0.85rem 1.25rem; border-radius: 10px; margin-bottom: 1.5rem; font-weight: 700; border: 1px solid #BBF7D0; display: flex; align-items: center; gap: 0.5rem; transition: opacity 0.5s ease, transform 0.5s ease;">
                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2.5">
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

                                                        <!-- SECTION 1: DASHBOARD OVERVIEW -->
                                                        <div class="section-pane active-pane" id="dashboardSection">
                                                            <section class="welcome-card">
                                                                <div class="welcome-text">
                                                                    <h2>Welcome, Administrator</h2>
                                                                    <p>Manage your entire academic ecosystem including
                                                                        student records,
                                                                        faculty
                                                                        operations, course subjects, and departmental
                                                                        statistics.</p>
                                                                </div>
                                                                <div class="welcome-visual">
                                                                    <svg width="34" height="34" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path
                                                                            d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                                                                    </svg>
                                                                </div>
                                                            </section>

                                                            <!-- Summary Grid: Exactly 4 Statistics Cards -->
                                                            <section class="summary-grid">
                                                                <div class="stat-card">
                                                                    <div class="stat-top">
                                                                        <span class="stat-title">Total Students</span>
                                                                        <div class="stat-icon-wrap stat-icon-students">
                                                                            <svg width="20" height="20"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
                                                                                <path
                                                                                    d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                                                <circle cx="9" cy="7" r="4" />
                                                                            </svg>
                                                                        </div>
                                                                    </div>
                                                                    <div class="stat-val">
                                                                        <%= totalStudentsCount %>
                                                                    </div>
                                                                    <span class="stat-desc">Active Enrolled
                                                                        Profiles</span>
                                                                </div>

                                                                <div class="stat-card">
                                                                    <div class="stat-top">
                                                                        <span class="stat-title">Total Teachers</span>
                                                                        <div class="stat-icon-wrap stat-icon-teachers">
                                                                            <svg width="20" height="20"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
                                                                                <rect x="2" y="7" width="20" height="14"
                                                                                    rx="2" ry="2" />
                                                                                <path
                                                                                    d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                                                                            </svg>
                                                                        </div>
                                                                    </div>
                                                                    <div class="stat-val">
                                                                        <%= totalTeachersCount %>
                                                                    </div>
                                                                    <span class="stat-desc">Faculty Members</span>
                                                                </div>

                                                                <div class="stat-card">
                                                                    <div class="stat-top">
                                                                        <span class="stat-title">Total Subjects</span>
                                                                        <div class="stat-icon-wrap stat-icon-subjects">
                                                                            <svg width="20" height="20"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
                                                                                <path
                                                                                    d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                                                <path
                                                                                    d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                                            </svg>
                                                                        </div>
                                                                    </div>
                                                                    <div class="stat-val">
                                                                        <%= totalSubjectsCount %>
                                                                    </div>
                                                                    <span class="stat-desc">Curriculum Courses</span>
                                                                </div>

                                                                <div class="stat-card">
                                                                    <div class="stat-top">
                                                                        <span class="stat-title">Total
                                                                            Departments</span>
                                                                        <div class="stat-icon-wrap stat-icon-depts">
                                                                            <svg width="20" height="20"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
                                                                                <path d="M3 21h18" />
                                                                                <path d="M9 8h1" />
                                                                                <path d="M9 12h1" />
                                                                                <path d="M9 16h1" />
                                                                                <path d="M14 8h1" />
                                                                                <path d="M14 12h1" />
                                                                                <path d="M14 16h1" />
                                                                                <path
                                                                                    d="M5 21V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v16" />
                                                                            </svg>
                                                                        </div>
                                                                    </div>
                                                                    <div class="stat-val">
                                                                        <%= totalDepartmentsCount %>
                                                                    </div>
                                                                    <span class="stat-desc">Academic Wings</span>
                                                                </div>
                                                            </section>

                                                            <!-- Quick Overview Controls Card -->
                                                            <div class="content-card">
                                                                <div class="card-header-row">
                                                                    <h3>Quick Administrative Actions</h3>
                                                                </div>
                                                                <div class="action-cards-grid">
                                                                    <div class="action-card"
                                                                        onclick="openStudentModal('add')">
                                                                        <div class="action-icon">
                                                                            <svg width="20" height="20"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
                                                                                <line x1="12" y1="5" x2="12" y2="19" />
                                                                                <line x1="5" y1="12" x2="19" y2="12" />
                                                                            </svg>
                                                                        </div>
                                                                        <div class="action-title">Add Student</div>
                                                                        <div class="action-desc">Register new student
                                                                        </div>
                                                                    </div>

                                                                    <div class="action-card"
                                                                        onclick="switchTab('studentMgmtSection', document.querySelectorAll('.nav-item')[1])">
                                                                        <div class="action-icon">
                                                                            <svg width="20" height="20"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
                                                                                <path
                                                                                    d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                                                                <circle cx="12" cy="12" r="3" />
                                                                            </svg>
                                                                        </div>
                                                                        <div class="action-title">View Students</div>
                                                                        <div class="action-desc">Browse students</div>
                                                                    </div>

                                                                    <div class="action-card"
                                                                        onclick="openTeacherModal('add')">
                                                                        <div class="action-icon">
                                                                            <svg width="20" height="20"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
                                                                                <path
                                                                                    d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                                                <circle cx="9" cy="7" r="4" />
                                                                                <line x1="19" y1="8" x2="19" y2="14" />
                                                                                <line x1="22" y1="11" x2="16" y2="11" />
                                                                            </svg>
                                                                        </div>
                                                                        <div class="action-title">Add Teacher</div>
                                                                        <div class="action-desc">Register faculty</div>
                                                                    </div>

                                                                    <div class="action-card"
                                                                        onclick="switchTab('teacherMgmtSection', document.querySelectorAll('.nav-item')[2])">
                                                                        <div class="action-icon">
                                                                            <svg width="20" height="20"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
                                                                                <rect x="2" y="7" width="20" height="14"
                                                                                    rx="2" ry="2" />
                                                                                <path
                                                                                    d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                                                                            </svg>
                                                                        </div>
                                                                        <div class="action-title">View Teachers</div>
                                                                        <div class="action-desc">Browse staff list</div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- SECTION 2: STUDENT MANAGEMENT -->
                                                        <div class="section-pane" id="studentMgmtSection">
                                                            <div class="content-card">
                                                                <div class="card-header-row">
                                                                    <div>
                                                                        <h3>Student Records</h3>
                                                                        <p
                                                                            style="font-size: 0.85rem; color: var(--text-muted);">
                                                                            Manage
                                                                            all student
                                                                            records, course allocations, and academic
                                                                            profiles.</p>
                                                                    </div>
                                                                    <button class="btn btn-primary"
                                                                        onclick="openStudentModal('add')">
                                                                        <svg width="16" height="16" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <line x1="12" y1="5" x2="12" y2="19" />
                                                                            <line x1="5" y1="12" x2="19" y2="12" />
                                                                        </svg>
                                                                        <span>Add Student</span>
                                                                    </button>
                                                                </div>

                                                                <!-- Search & Filter Toolbar -->
                                                                <div class="table-toolbar">
                                                                    <div class="search-box">
                                                                        <svg class="search-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <circle cx="11" cy="11" r="8" />
                                                                            <line x1="21" y1="21" x2="16.65"
                                                                                y2="16.65" />
                                                                        </svg>
                                                                        <input type="text" id="studentSearchInput"
                                                                            placeholder="Search by name, roll no, or email..."
                                                                            onkeyup="filterStudentTable()">
                                                                    </div>
                                                                    <select class="filter-select"
                                                                        id="studentCourseFilter"
                                                                        onchange="filterStudentTable()">
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
                                                                    </select>
                                                                    <select class="filter-select" id="studentDeptFilter"
                                                                        onchange="filterStudentTable()">
                                                                        <option value="">All Departments</option>
                                                                        <option value="Computer Engineering">Computer
                                                                            Engineering
                                                                        </option>
                                                                        <option value="Information Technology">
                                                                            Information Technology
                                                                        </option>
                                                                        <option value="Mechanical Engineering">
                                                                            Mechanical Engineering
                                                                        </option>
                                                                        <option value="Civil Engineering">Civil
                                                                            Engineering</option>
                                                                        <option value="Electronics Engineering">
                                                                            Electronics Engineering
                                                                        </option>
                                                                    </select>
                                                                </div>

                                                                <!-- Table View -->
                                                                <div class="table-responsive">
                                                                    <table class="custom-table" id="studentsTable">
                                                                        <thead>
                                                                            <tr>
                                                                                <th>Full Name</th>
                                                                                <th>Username</th>
                                                                                <th>Email</th>
                                                                                <th>Roll No</th>
                                                                                <th>Phone</th>
                                                                                <th>Course</th>
                                                                                <th>Department</th>
                                                                                <th>Semester</th>
                                                                                <th>Year</th>
                                                                                <th>Actions</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <tr>
                                                                                <td><strong>John Doe</strong></td>
                                                                                <td>johndoe</td>
                                                                                <td>john@example.com</td>
                                                                                <td
                                                                                    style="font-weight: 700; color: var(--primary-navy);">
                                                                                    101</td>
                                                                                <td>9876543210</td>
                                                                                <td>BTech</td>
                                                                                <td>Computer Engineering</td>
                                                                                <td>Semester 6</td>
                                                                                <td>Third Year</td>
                                                                                <td>
                                                                                    <div
                                                                                        style="display:flex; gap:0.5rem;">
                                                                                        <button class="btn btn-outline"
                                                                                            style="padding:0.3rem 0.6rem; font-size:0.775rem;"
                                                                                            onclick="openStudentModal('edit', '101', 'John Doe', 'john@example.com', 'BTech', 'Semester 6')">Edit</button>
                                                                                        <button class="btn btn-danger"
                                                                                            style="padding:0.3rem 0.6rem; font-size:0.775rem;"
                                                                                            onclick="openDeleteModal('Student', 'John Doe')">Delete</button>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><strong>Jane Smith</strong></td>
                                                                                <td>janesmith</td>
                                                                                <td>jane@example.com</td>
                                                                                <td
                                                                                    style="font-weight: 700; color: var(--primary-navy);">
                                                                                    102</td>
                                                                                <td>9876543211</td>
                                                                                <td>BTech</td>
                                                                                <td>Information Technology</td>
                                                                                <td>Semester 6</td>
                                                                                <td>Third Year</td>
                                                                                <td>
                                                                                    <div
                                                                                        style="display:flex; gap:0.5rem;">
                                                                                        <button class="btn btn-outline"
                                                                                            style="padding:0.3rem 0.6rem; font-size:0.775rem;"
                                                                                            onclick="openStudentModal('edit', '102', 'Jane Smith', 'jane@example.com', 'BTech', 'Semester 6')">Edit</button>
                                                                                        <button class="btn btn-danger"
                                                                                            style="padding:0.3rem 0.6rem; font-size:0.775rem;"
                                                                                            onclick="openDeleteModal('Student', 'Jane Smith')">Delete</button>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><strong>Amit Sharma</strong></td>
                                                                                <td>amitsharma</td>
                                                                                <td>amit@example.com</td>
                                                                                <td
                                                                                    style="font-weight: 700; color: var(--primary-navy);">
                                                                                    103</td>
                                                                                <td>9876543212</td>
                                                                                <td>BCA</td>
                                                                                <td>Computer Engineering</td>
                                                                                <td>Semester 4</td>
                                                                                <td>Second Year</td>
                                                                                <td>
                                                                                    <div
                                                                                        style="display:flex; gap:0.5rem;">
                                                                                        <button class="btn btn-outline"
                                                                                            style="padding:0.3rem 0.6rem; font-size:0.775rem;"
                                                                                            onclick="openStudentModal('edit', '103', 'Amit Sharma', 'amit@example.com', 'BCA', 'Semester 4')">Edit</button>
                                                                                        <button class="btn btn-danger"
                                                                                            style="padding:0.3rem 0.6rem; font-size:0.775rem;"
                                                                                            onclick="openDeleteModal('Student', 'Amit Sharma')">Delete</button>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- SECTION 3: TEACHER MANAGEMENT -->
                                                        <div class="section-pane" id="teacherMgmtSection">
                                                            <div class="content-card">
                                                                <div class="card-header-row">
                                                                    <div>
                                                                        <h3>Teacher Records</h3>
                                                                        <p
                                                                            style="font-size: 0.85rem; color: var(--text-muted);">
                                                                            Manage
                                                                            faculty
                                                                            profiles, department assignments, and staff
                                                                            roles.</p>
                                                                    </div>
                                                                    <button class="btn btn-primary"
                                                                        onclick="openTeacherModal('add')">
                                                                        <svg width="16" height="16" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <line x1="12" y1="5" x2="12" y2="19" />
                                                                            <line x1="5" y1="12" x2="19" y2="12" />
                                                                        </svg>
                                                                        <span>Add Teacher</span>
                                                                    </button>
                                                                </div>

                                                                <!-- Search & Filter Toolbar -->
                                                                <div class="table-toolbar">
                                                                    <div class="search-box">
                                                                        <svg class="search-icon" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <circle cx="11" cy="11" r="8" />
                                                                            <line x1="21" y1="21" x2="16.65"
                                                                                y2="16.65" />
                                                                        </svg>
                                                                        <input type="text" id="teacherSearchInput"
                                                                            placeholder="Search teacher name, email, or department..."
                                                                            onkeyup="filterTeacherTable()">
                                                                    </div>
                                                                    <select class="filter-select" id="teacherDeptFilter"
                                                                        onchange="filterTeacherTable()">
                                                                        <option value="">All Departments</option>
                                                                        <option value="Computer Engineering">Computer
                                                                            Engineering
                                                                        </option>
                                                                        <option value="Information Technology">
                                                                            Information Technology
                                                                        </option>
                                                                        <option value="Mechanical Engineering">
                                                                            Mechanical Engineering
                                                                        </option>
                                                                        <option value="Civil Engineering">Civil
                                                                            Engineering</option>
                                                                        <option value="Electronics Engineering">
                                                                            Electronics Engineering
                                                                        </option>
                                                                    </select>
                                                                </div>

                                                                <!-- Table View -->
                                                                <div class="table-responsive">
                                                                    <table class="custom-table" id="teachersTable">
                                                                        <thead>
                                                                            <tr>
                                                                                <th>Full Name</th>
                                                                                <th>Username</th>
                                                                                <th>Email</th>
                                                                                <th>Phone</th>
                                                                                <th>Department</th>
                                                                                <th>Actions</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <tr>
                                                                                <td><strong>Prof. Robert Vance</strong>
                                                                                </td>
                                                                                <td>robertvance</td>
                                                                                <td>robert@example.com</td>
                                                                                <td>9876543220</td>
                                                                                <td>Computer Engineering</td>
                                                                                <td>
                                                                                    <div
                                                                                        style="display:flex; gap:0.5rem;">
                                                                                        <button class="btn btn-outline"
                                                                                            style="padding:0.3rem 0.6rem; font-size:0.775rem;"
                                                                                            onclick="openTeacherModal('edit', 'T-01', 'Prof. Robert Vance', 'robert@example.com', 'Computer Engineering', 'HOD / Professor')">Edit</button>
                                                                                        <button class="btn btn-danger"
                                                                                            style="padding:0.3rem 0.6rem; font-size:0.775rem;"
                                                                                            onclick="openDeleteModal('Teacher', 'Prof. Robert Vance')">Delete</button>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><strong>Dr. Sarah Connor</strong>
                                                                                </td>
                                                                                <td>sarahconnor</td>
                                                                                <td>sarah@example.com</td>
                                                                                <td>9876543221</td>
                                                                                <td>Computer Engineering</td>
                                                                                <td>
                                                                                    <div
                                                                                        style="display:flex; gap:0.5rem;">
                                                                                        <button class="btn btn-outline"
                                                                                            style="padding:0.3rem 0.6rem; font-size:0.775rem;"
                                                                                            onclick="openTeacherModal('edit', 'T-02', 'Dr. Sarah Connor', 'sarah@example.com', 'Computer Engineering', 'Associate Professor')">Edit</button>
                                                                                        <button class="btn btn-danger"
                                                                                            style="padding:0.3rem 0.6rem; font-size:0.775rem;"
                                                                                            onclick="openDeleteModal('Teacher', 'Dr. Sarah Connor')">Delete</button>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- SECTION 4: DEDICATED SUBJECT ASSIGNMENT -->
                                                        <div class="section-pane" id="subjectAssignSection">
                                                            <!-- Step 1 & Step 2 Card Grid -->
                                                            <div
                                                                style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 1.5rem;">
                                                                <!-- Step 1: Select Department & Teacher -->
                                                                <div class="content-card">
                                                                    <div class="card-header-row"
                                                                        style="margin-bottom: 1rem;">
                                                                        <h3
                                                                            style="display: flex; align-items: center; gap: 0.5rem;">
                                                                            <span
                                                                                style="background: var(--primary-blue); color: #fff; width: 26px; height: 26px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 800;">1</span>
                                                                            Select Department & Teacher
                                                                        </h3>
                                                                    </div>

                                                                    <div
                                                                        style="display: flex; flex-direction: column; gap: 1rem;">
                                                                        <div class="form-group">
                                                                            <label class="form-label"
                                                                                style="font-weight:700;">Select
                                                                                Department</label>
                                                                            <select class="form-control"
                                                                                id="assignDeptSelect"
                                                                                onchange="onAssignDeptChange()">
                                                                                <option value="Computer Engineering">
                                                                                    Computer
                                                                                    Engineering</option>
                                                                                <option value="Information Technology">
                                                                                    Information
                                                                                    Technology</option>
                                                                                <option value="Mechanical Engineering">
                                                                                    Mechanical
                                                                                    Engineering</option>
                                                                                <option value="Civil Engineering">Civil
                                                                                    Engineering
                                                                                </option>
                                                                                <option value="Electronics Engineering">
                                                                                    Electronics
                                                                                    Engineering</option>
                                                                            </select>
                                                                        </div>

                                                                        <div class="form-group">
                                                                            <label class="form-label"
                                                                                style="font-weight:700;">Select
                                                                                Teacher</label>
                                                                            <select class="form-control"
                                                                                id="assignTeacherSelect"
                                                                                onchange="onAssignTeacherChange()">
                                                                                <option value="patil">Prof. Patil
                                                                                </option>
                                                                            </select>
                                                                        </div>

                                                                        <!-- Teacher Quick Info -->
                                                                        <div id="teacherDetailBox"
                                                                            style="background: var(--bg-main); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 1rem;">
                                                                            <div
                                                                                style="font-size: 0.75rem; font-weight: 800; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em;">
                                                                                Selected Faculty Details</div>
                                                                            <div id="teacherDetailName"
                                                                                style="font-size: 1.1rem; font-weight: 800; color: var(--primary-navy); margin-top: 0.2rem;">
                                                                                Prof. Patil</div>
                                                                            <div style="font-size: 0.85rem; color: var(--text-muted); margin-top: 0.25rem;"
                                                                                id="teacherDetailMeta">
                                                                                Username: <span
                                                                                    id="teacherDetailUsername"
                                                                                    style="font-weight: 700; color: var(--text-main);">patil</span>
                                                                                &bull;
                                                                                Dept: <span id="teacherDetailDept"
                                                                                    style="font-weight: 700; color: var(--text-main);">Computer
                                                                                    Engineering</span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <!-- Step 2: Assign Subject to Teacher -->
                                                                <div class="content-card">
                                                                    <div class="card-header-row"
                                                                        style="margin-bottom: 1rem;">
                                                                        <h3
                                                                            style="display: flex; align-items: center; gap: 0.5rem;">
                                                                            <span
                                                                                style="background: var(--primary-blue); color: #fff; width: 26px; height: 26px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 800;">2</span>
                                                                            Available Subjects for Department
                                                                        </h3>
                                                                    </div>

                                                                    <div
                                                                        style="display: flex; flex-direction: column; gap: 0.85rem;">
                                                                        <p
                                                                            style="font-size: 0.85rem; color: var(--text-muted);">
                                                                            Select
                                                                            one or multiple subjects to assign to
                                                                            <strong id="assignTeacherLabel">Prof.
                                                                                Patil</strong>:
                                                                        </p>

                                                                        <div id="availableSubjectsList"
                                                                            style="display: flex; flex-direction: column; gap: 0.6rem; max-height: 180px; overflow-y: auto; padding-right: 0.5rem;">
                                                                            <label
                                                                                style="display:flex; align-items:center; gap:0.75rem; padding:0.65rem 0.85rem; background:#FFFFFF; border:1.5px solid var(--border); border-radius:var(--radius-sm); font-size:0.875rem; cursor:pointer;">
                                                                                <input type="checkbox"
                                                                                    class="subject-assign-checkbox"
                                                                                    value="Java" data-course="BTech"
                                                                                    data-dept="Computer Engineering"
                                                                                    data-sem="5"
                                                                                    style="accent-color:var(--primary-blue); width:18px; height:18px; cursor:pointer;">
                                                                                <div>
                                                                                    <strong
                                                                                        style="color:var(--primary-navy); font-size:0.925rem;">Java</strong>
                                                                                    <div
                                                                                        style="font-size:0.775rem; color:var(--text-muted); margin-top:0.15rem;">
                                                                                        BTech &bull; Computer
                                                                                        Engineering &bull;
                                                                                        Semester 5</div>
                                                                                </div>
                                                                            </label>
                                                                            <label
                                                                                style="display:flex; align-items:center; gap:0.75rem; padding:0.65rem 0.85rem; background:#FFFFFF; border:1.5px solid var(--border); border-radius:var(--radius-sm); font-size:0.875rem; cursor:pointer;">
                                                                                <input type="checkbox"
                                                                                    class="subject-assign-checkbox"
                                                                                    value="DBMS" data-course="BTech"
                                                                                    data-dept="Computer Engineering"
                                                                                    data-sem="5"
                                                                                    style="accent-color:var(--primary-blue); width:18px; height:18px; cursor:pointer;">
                                                                                <div>
                                                                                    <strong
                                                                                        style="color:var(--primary-navy); font-size:0.925rem;">DBMS</strong>
                                                                                    <div
                                                                                        style="font-size:0.775rem; color:var(--text-muted); margin-top:0.15rem;">
                                                                                        BTech &bull; Computer
                                                                                        Engineering &bull;
                                                                                        Semester 5</div>
                                                                                </div>
                                                                            </label>
                                                                            <label
                                                                                style="display:flex; align-items:center; gap:0.75rem; padding:0.65rem 0.85rem; background:#FFFFFF; border:1.5px solid var(--border); border-radius:var(--radius-sm); font-size:0.875rem; cursor:pointer;">
                                                                                <input type="checkbox"
                                                                                    class="subject-assign-checkbox"
                                                                                    value="Computer Networks"
                                                                                    data-course="BTech"
                                                                                    data-dept="Computer Engineering"
                                                                                    data-sem="5"
                                                                                    style="accent-color:var(--primary-blue); width:18px; height:18px; cursor:pointer;">
                                                                                <div>
                                                                                    <strong
                                                                                        style="color:var(--primary-navy); font-size:0.925rem;">Computer
                                                                                        Networks</strong>
                                                                                    <div
                                                                                        style="font-size:0.775rem; color:var(--text-muted); margin-top:0.15rem;">
                                                                                        BTech &bull; Computer
                                                                                        Engineering &bull;
                                                                                        Semester 5</div>
                                                                                </div>
                                                                            </label>
                                                                            <label
                                                                                style="display:flex; align-items:center; gap:0.75rem; padding:0.65rem 0.85rem; background:#FFFFFF; border:1.5px solid var(--border); border-radius:var(--radius-sm); font-size:0.875rem; cursor:pointer;">
                                                                                <input type="checkbox"
                                                                                    class="subject-assign-checkbox"
                                                                                    value="Operating System"
                                                                                    data-course="BTech"
                                                                                    data-dept="Computer Engineering"
                                                                                    data-sem="5"
                                                                                    style="accent-color:var(--primary-blue); width:18px; height:18px; cursor:pointer;">
                                                                                <div>
                                                                                    <strong
                                                                                        style="color:var(--primary-navy); font-size:0.925rem;">Operating
                                                                                        System</strong>
                                                                                    <div
                                                                                        style="font-size:0.775rem; color:var(--text-muted); margin-top:0.15rem;">
                                                                                        BTech &bull; Computer
                                                                                        Engineering &bull;
                                                                                        Semester 5</div>
                                                                                </div>
                                                                            </label>
                                                                        </div>

                                                                        <button class="btn btn-primary"
                                                                            style="margin-top: 0.5rem; width: 100%; font-weight: 700;"
                                                                            onclick="assignSelectedSubjectsToTeacher()">
                                                                            <svg width="16" height="16"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2.5"
                                                                                style="margin-right: 0.4rem;">
                                                                                <polyline points="20 6 9 17 4 12" />
                                                                            </svg>
                                                                            Assign Subject
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <!-- Step 3: Assigned Subjects Table Card -->
                                                            <div class="content-card">
                                                                <div class="card-header-row">
                                                                    <div>
                                                                        <h3>Assigned Subjects Overview</h3>
                                                                        <p
                                                                            style="font-size: 0.825rem; color: var(--text-muted); margin-top: 0.2rem;">
                                                                            Currently assigned subjects and allocated
                                                                            student counts for
                                                                            <strong id="assignedOverviewTeacher">Prof.
                                                                                Patil</strong>
                                                                        </p>
                                                                    </div>
                                                                    <span class="badge"
                                                                        style="background: #EFF6FF; color: #2563EB; font-weight: 700; padding: 0.4rem 0.9rem; border-radius: 50px; border: 1px solid #BFDBFE;">Teacher:
                                                                        <span id="assignedTeacherBadgeName">Prof.
                                                                            Patil</span></span>
                                                                </div>

                                                                <div class="table-responsive" style="overflow-x: auto;">
                                                                    <table class="custom-table"
                                                                        id="assignedSubjectsTable"
                                                                        style="min-width: 900px;">
                                                                        <thead>
                                                                            <tr>
                                                                                <th>Subject Name</th>
                                                                                <th>Course</th>
                                                                                <th>Department</th>
                                                                                <th>Semester</th>
                                                                                <th>Assigned Students</th>
                                                                                <th>Action</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody id="assignedSubjectsTbody">
                                                                            <tr>
                                                                                <td><strong
                                                                                        style="color:var(--primary-navy);">Java</strong>
                                                                                </td>
                                                                                <td><span class="badge"
                                                                                        style="background:#EFF6FF; color:#2563EB; font-weight:700;">BTech</span>
                                                                                </td>
                                                                                <td>Computer Engineering</td>
                                                                                <td>Semester 5</td>
                                                                                <td><span class="badge"
                                                                                        style="background:#F1F5F9; color:#1E293B; font-weight:700;">0
                                                                                        Students</span></td>
                                                                                <td>
                                                                                    <button
                                                                                        class="btn btn-primary btn-sm"
                                                                                        onclick="openAssignStudentsModalForSubject('patil', 'Java', 'BTech', 'Computer Engineering', 5, 'Third Year')">
                                                                                        <svg width="14" height="14"
                                                                                            viewBox="0 0 24 24"
                                                                                            fill="none"
                                                                                            stroke="currentColor"
                                                                                            stroke-width="2"
                                                                                            style="margin-right:0.3rem;">
                                                                                            <path
                                                                                                d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                                                            <circle cx="9" cy="7"
                                                                                                r="4" />
                                                                                            <line x1="19" y1="8" x2="19"
                                                                                                y2="14" />
                                                                                            <line x1="16" y1="11"
                                                                                                x2="22" y2="11" />
                                                                                        </svg>
                                                                                        Manage Students
                                                                                    </button>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><strong
                                                                                        style="color:var(--primary-navy);">DBMS</strong>
                                                                                </td>
                                                                                <td><span class="badge"
                                                                                        style="background:#EFF6FF; color:#2563EB; font-weight:700;">BTech</span>
                                                                                </td>
                                                                                <td>Computer Engineering</td>
                                                                                <td>Semester 5</td>
                                                                                <td><span class="badge"
                                                                                        style="background:#F1F5F9; color:#1E293B; font-weight:700;">0
                                                                                        Students</span></td>
                                                                                <td>
                                                                                    <button
                                                                                        class="btn btn-primary btn-sm"
                                                                                        onclick="openAssignStudentsModalForSubject('patil', 'DBMS', 'BTech', 'Computer Engineering', 5, 'Third Year')">
                                                                                        <svg width="14" height="14"
                                                                                            viewBox="0 0 24 24"
                                                                                            fill="none"
                                                                                            stroke="currentColor"
                                                                                            stroke-width="2"
                                                                                            style="margin-right:0.3rem;">
                                                                                            <path
                                                                                                d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                                                            <circle cx="9" cy="7"
                                                                                                r="4" />
                                                                                            <line x1="19" y1="8" x2="19"
                                                                                                y2="14" />
                                                                                            <line x1="16" y1="11"
                                                                                                x2="22" y2="11" />
                                                                                        </svg>
                                                                                        Manage Students
                                                                                    </button>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- SECTION 5: PROFILE -->
                                                        <div class="section-pane" id="profileSection">
                                                            <div
                                                                style="background: linear-gradient(135deg, #1E3A5F 0%, #0F172A 100%); border-radius: var(--radius-md); padding: 2rem; color: #FFFFFF; display: flex; align-items: center; gap: 1.5rem; margin-bottom: 1.75rem; box-shadow: var(--shadow-sm); position: relative; overflow: hidden;">
                                                                <div style="position: relative;">
                                                                    <div
                                                                        style="width: 80px; height: 80px; border-radius: 50%; background: linear-gradient(135deg, #2563EB 0%, #1D4ED8 100%); color: #FFFFFF; font-size: 1.85rem; font-weight: 800; display: flex; align-items: center; justify-content: center; border: 3px solid rgba(255, 255, 255, 0.2);">
                                                                        GP
                                                                    </div>
                                                                    <div
                                                                        style="position: absolute; bottom: 2px; right: 2px; width: 14px; height: 14px; background: #10B981; border: 2px solid #0F172A; border-radius: 50%;">
                                                                    </div>
                                                                </div>
                                                                <div>
                                                                    <h2
                                                                        style="font-size: 1.4rem; font-weight: 800; margin-bottom: 0.25rem;">
                                                                        ${sessionScope.admin != null ?
                                                                        sessionScope.admin.name : 'Gaurav
                                                                        Patil'}
                                                                    </h2>
                                                                    <div
                                                                        style="display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.25rem 0.75rem; background: rgba(255, 255, 255, 0.12); border-radius: 20px; font-size: 0.8rem; font-weight: 600; color: #93C5FD;">
                                                                        <svg width="14" height="14" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2.5">
                                                                            <path
                                                                                d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                                                                        </svg>
                                                                        <span>Super Administrator • Full Access</span>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <div class="content-card">
                                                                <div class="card-header-row">
                                                                    <h3>
                                                                        <svg viewBox="0 0 24 24" fill="none"
                                                                            stroke="currentColor" stroke-width="2"
                                                                            style="width:20px; height:20px; color:var(--primary-blue); vertical-align:middle; margin-right:0.4rem;">
                                                                            <path
                                                                                d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                                                            <circle cx="12" cy="7" r="4" />
                                                                        </svg>
                                                                        Admin Profile Information
                                                                    </h3>
                                                                </div>
                                                                <div class="profile-grid">
                                                                    <div class="profile-field">
                                                                        <label>Admin Name</label>
                                                                        <span>${sessionScope.admin != null ?
                                                                            sessionScope.admin.name :
                                                                            'Gaurav
                                                                            Patil'}</span>
                                                                    </div>
                                                                    <div class="profile-field">
                                                                        <label>Username</label>
                                                                        <span>${sessionScope.admin != null ?
                                                                            sessionScope.admin.username
                                                                            :
                                                                            'gauravPatilAdmin'}</span>
                                                                    </div>
                                                                    <div class="profile-field">
                                                                        <label>Email Address</label>
                                                                        <span>${sessionScope.admin != null ?
                                                                            sessionScope.admin.email :
                                                                            'admin@email.com'}</span>
                                                                    </div>
                                                                    <div class="profile-field">
                                                                        <label>Phone</label>
                                                                        <span>${sessionScope.admin != null &&
                                                                            sessionScope.admin.phone
                                                                            != null ?
                                                                            sessionScope.admin.phone :
                                                                            '7875335539'}</span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                    </div>
                                </main>
                            </div>

                            <!-- Student Modal (Add/Edit) -->
                            <div class="modal-backdrop" id="studentModal">
                                <div class="modal-card" style="max-width: 580px;">
                                    <div class="modal-header">
                                        <h4 id="studentModalTitle">Add New Student</h4>
                                        <button type="button" class="modal-close-btn"
                                            onclick="closeModal('studentModal')">&times;</button>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/register" method="post"
                                        id="adminStudentForm">
                                        <input type="hidden" name="role" value="Student">
                                        <input type="hidden" name="redirectUrl"
                                            value="${pageContext.request.contextPath}/admin/dashboard.jsp?tab=student">
                                        <div class="modal-body" style="max-height: 70vh; overflow-y: auto;">
                                            <div class="form-group" style="grid-column: span 2;">
                                                <label>Gender *</label>
                                                <div
                                                    style="display: flex; gap: 1.5rem; align-items: center; padding: 0.35rem 0;">
                                                    <label
                                                        style="display: flex; align-items: center; gap: 0.4rem; cursor: pointer; font-size: 0.875rem; font-weight: 500;">
                                                        <input type="radio" name="gender" value="Male" checked> Male
                                                    </label>
                                                    <label
                                                        style="display: flex; align-items: center; gap: 0.4rem; cursor: pointer; font-size: 0.875rem; font-weight: 500;">
                                                        <input type="radio" name="gender" value="Female"> Female
                                                    </label>
                                                    <label
                                                        style="display: flex; align-items: center; gap: 0.4rem; cursor: pointer; font-size: 0.875rem; font-weight: 500;">
                                                        <input type="radio" name="gender" value="Other"> Other
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label>Full Name</label>
                                                <input type="text" id="mStudentFullName" name="fullName"
                                                    placeholder="Enter full name" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Username</label>
                                                <input type="text" id="mStudentUsername" name="username"
                                                    placeholder="Enter username" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Email Address</label>
                                                <input type="email" id="mStudentEmail" name="email"
                                                    placeholder="Enter email address" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Password</label>
                                                <input type="password" id="mStudentPassword" name="password"
                                                    placeholder="Create password" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Confirm Password</label>
                                                <input type="password" id="mStudentConfirmPassword"
                                                    name="confirmPassword" placeholder="Confirm password" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Roll Number</label>
                                                <input type="text" id="mRollNo" name="rollNumber"
                                                    placeholder="Enter roll number">
                                            </div>
                                            <div class="form-group">
                                                <label>Phone</label>
                                                <input type="tel" id="mStudentPhone" name="phone"
                                                    placeholder="Enter phone number">
                                            </div>
                                            <div class="form-group">
                                                <label>Course</label>
                                                <select id="mStudentCourse" name="course">
                                                    <option value="" disabled selected>Select Course</option>
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
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label>Department</label>
                                                <select id="mStudentDepartment" name="department">
                                                    <option value="" disabled selected>Select Department</option>
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
                                            <div class="form-group">
                                                <label>Semester</label>
                                                <select id="mStudentSem" name="semester">
                                                    <option value="" disabled selected>Select Semester</option>
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
                                                <select id="mStudentYear" name="year">
                                                    <option value="" disabled selected>Select Year</option>
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

                            <!-- Teacher Modal (Add/Edit) -->
                            <div class="modal-backdrop" id="teacherModal">
                                <div class="modal-card" style="max-width: 540px;">
                                    <div class="modal-header">
                                        <h4 id="teacherModalTitle">Add New Faculty Member</h4>
                                        <button type="button" class="modal-close-btn"
                                            onclick="closeModal('teacherModal')">&times;</button>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/register" method="post"
                                        id="adminTeacherForm">
                                        <input type="hidden" name="role" value="Teacher">
                                        <input type="hidden" name="redirectUrl"
                                            value="${pageContext.request.contextPath}/admin/dashboard.jsp?tab=teacher">
                                        <div class="modal-body" style="max-height: 70vh; overflow-y: auto;">
                                            <div class="form-group" style="grid-column: span 2;">
                                                <label>Gender *</label>
                                                <div
                                                    style="display: flex; gap: 1.5rem; align-items: center; padding: 0.35rem 0;">
                                                    <label
                                                        style="display: flex; align-items: center; gap: 0.4rem; cursor: pointer; font-size: 0.875rem; font-weight: 500;">
                                                        <input type="radio" name="gender" value="Male" checked> Male
                                                    </label>
                                                    <label
                                                        style="display: flex; align-items: center; gap: 0.4rem; cursor: pointer; font-size: 0.875rem; font-weight: 500;">
                                                        <input type="radio" name="gender" value="Female"> Female
                                                    </label>
                                                    <label
                                                        style="display: flex; align-items: center; gap: 0.4rem; cursor: pointer; font-size: 0.875rem; font-weight: 500;">
                                                        <input type="radio" name="gender" value="Other"> Other
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label>Full Name</label>
                                                <input type="text" id="mTeacherFullName" name="fullName"
                                                    placeholder="Enter full name" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Username</label>
                                                <input type="text" id="mTeacherUsername" name="username"
                                                    placeholder="Enter username" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Email Address</label>
                                                <input type="email" id="mTeacherEmail" name="email"
                                                    placeholder="Enter email address" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Password</label>
                                                <input type="password" id="mTeacherPassword" name="password"
                                                    placeholder="Create password" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Confirm Password</label>
                                                <input type="password" id="mTeacherConfirmPassword"
                                                    name="confirmPassword" placeholder="Confirm password" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Phone</label>
                                                <input type="tel" id="mTeacherPhone" name="teacherPhone"
                                                    placeholder="Enter phone number">
                                            </div>
                                            <div class="form-group">
                                                <label>Department</label>
                                                <select id="mTeacherDept" name="teacherDepartment">
                                                    <option value="" disabled selected>Select Department</option>
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
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-outline"
                                                onclick="closeModal('teacherModal')">Cancel</button>
                                            <button type="submit" class="btn btn-primary">Save Faculty</button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- Universal Delete Modal -->
                            <div class="modal-backdrop" id="deleteModal">
                                <div class="modal-card" style="max-width: 420px;">
                                    <div class="modal-header">
                                        <h4 style="color: var(--error);">Confirm Deletion</h4>
                                        <button class="modal-close-btn"
                                            onclick="closeModal('deleteModal')">&times;</button>
                                    </div>
                                    <div class="modal-body" style="text-align: center;">
                                        <p style="font-size: 0.95rem; color: var(--text-main); margin-bottom: 0.5rem;"
                                            id="deleteModalText">
                                            Are you sure you want to remove this record?
                                        </p>
                                        <p style="font-size: 0.8rem; color: var(--text-muted);">This action cannot be
                                            undone.</p>
                                    </div>
                                    <div class="modal-footer" style="justify-content: center;">
                                        <button class="btn btn-outline"
                                            onclick="closeModal('deleteModal')">Cancel</button>
                                        <button class="btn btn-danger" onclick="confirmDeleteModal()">Yes,
                                            Delete</button>
                                    </div>
                                    <!-- STEP 4: STUDENT ASSIGNMENT MODAL -->
                                    <div class="modal-overlay" id="assignStudentsModal">
                                        <div class="modal-container" style="max-width: 850px; width: 95%;">
                                            <div class="modal-header"
                                                style="background: linear-gradient(135deg, #1E3A5F 0%, #12253E 100%); color: #fff;">
                                                <div>
                                                    <h3 style="color:#fff; margin-bottom: 0.25rem;"
                                                        id="modalAssignTitle">Manage
                                                        Students for Subject</h3>
                                                    <div style="font-size: 0.825rem; color: #94A3B8;"
                                                        id="modalAssignSub">Teacher: Prof.
                                                        Patil | Subject: Java</div>
                                                </div>
                                                <button class="modal-close-btn"
                                                    onclick="closeModal('assignStudentsModal')"
                                                    style="color:#fff;">&times;</button>
                                            </div>

                                            <div class="modal-body" style="padding: 1.5rem;">
                                                <!-- Criteria Badge Banner -->
                                                <div
                                                    style="background: #EFF6FF; border: 1px solid #BFDBFE; border-radius: var(--radius-sm); padding: 0.85rem 1rem; margin-bottom: 1.25rem; font-size: 0.85rem; color: #1E3A5F; display: flex; align-items: center; gap: 0.6rem;">
                                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                        stroke="#2563EB" stroke-width="2">
                                                        <circle cx="12" cy="12" r="10" />
                                                        <line x1="12" y1="16" x2="12" y2="12" />
                                                        <line x1="12" y1="8" x2="12.01" y2="8" />
                                                    </svg>
                                                    <span>Displaying <strong>eligible students</strong> strictly
                                                        matching criteria:
                                                        <strong id="modalFilterCriteria">BTech | Computer Engineering |
                                                            Semester 5 |
                                                            Third Year</strong></span>
                                                </div>

                                                <!-- Toolbar with Select All, Year Filter and Live Counter -->
                                                <div
                                                    style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem; flex-wrap: wrap; gap: 0.75rem;">
                                                    <div style="display: flex; align-items: center; gap: 1.25rem;">
                                                        <label
                                                            style="display: flex; align-items: center; gap: 0.5rem; font-size: 0.9rem; font-weight: 700; cursor: pointer; color: var(--primary-navy);">
                                                            <input type="checkbox" id="selectAllStudentsCheckbox"
                                                                onchange="toggleSelectAllStudents(this)"
                                                                style="width: 18px; height: 18px; accent-color: var(--primary-blue); cursor: pointer;">
                                                            Select All Eligible Students
                                                        </label>

                                                        <div style="display: flex; align-items: center; gap: 0.4rem;">
                                                            <label
                                                                style="font-size: 0.825rem; font-weight: 700; color: var(--text-muted);">Year:</label>
                                                            <select id="modalYearSelect" onchange="onModalYearChange()"
                                                                style="padding: 0.35rem 0.65rem; border: 1.5px solid var(--border); border-radius: var(--radius-sm); font-size: 0.825rem; font-weight: 600; background: #fff; color: var(--text-main); cursor: pointer; outline: none;">
                                                                <option value="First Year">First Year</option>
                                                                <option value="Second Year">Second Year</option>
                                                                <option value="Third Year" selected>Third Year</option>
                                                                <option value="Fourth Year">Fourth Year</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <span class="badge"
                                                        style="background: var(--primary-navy); color: #fff; padding: 0.35rem 0.85rem; border-radius: 50px; font-weight: 700; font-size: 0.825rem;"
                                                        id="selectedStudentsCountBadge">Selected Students: 0</span>
                                                </div>

                                                <!-- Table of Eligible Students -->
                                                <div class="table-responsive"
                                                    style="max-height: 280px; overflow-y: auto; border: 1px solid var(--border); border-radius: var(--radius-sm);">
                                                    <table class="custom-table">
                                                        <thead>
                                                            <tr>
                                                                <th style="width: 50px; text-align: center;">Select</th>
                                                                <th>Student Name</th>
                                                                <th>Roll Number</th>
                                                                <th>Username</th>
                                                                <th>Course</th>
                                                                <th>Department</th>
                                                                <th>Sem / Year</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody id="eligibleStudentsTbody">
                                                            <!-- Rendered dynamically by JS -->
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>

                                            <div class="modal-footer"
                                                style="padding: 1rem 1.5rem; background: var(--bg-main); border-top: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between;">
                                                <button class="btn btn-outline"
                                                    onclick="closeModal('assignStudentsModal')">Cancel</button>
                                                <button class="btn btn-primary" onclick="confirmAssignStudents()"
                                                    style="font-weight: 700;">
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2.5"
                                                        style="margin-right: 0.4rem;">
                                                        <polyline points="20 6 9 17 4 12" />
                                                    </svg>
                                                    Assign Selected Students
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Client-Side JavaScript Logic -->
                                    <script>
                                        const menuToggleBtn = document.getElementById('menuToggleBtn');
                                        const sidebar = document.getElementById('sidebar');
                                        const sidebarOverlay = document.getElementById('sidebarOverlay');
                                        const headerTitle = document.getElementById('headerTitle');

                                        /* Subject Assignment Data & Engine - Complete 15-Phase Implementation */
                                        const mockTeachersByDept = {
                                            'Computer Engineering': [
                                                { id: 1, name: 'Prof. Patil', username: 'patil', email: 'patil@gmail.com', phone: '9876543213', department: 'Computer Engineering' }
                                            ],
                                            'Information Technology': [
                                                { id: 2, name: 'Prof. Rahul Kulkarni', username: 'rahulk', email: 'rahulk@gmail.com', phone: '9876543214', department: 'Information Technology' }
                                            ],
                                            'Mechanical Engineering': [
                                                { id: 3, name: 'Prof. Amit Joshi', username: 'amitjoshi', email: 'amit@gmail.com', phone: '9876543215', department: 'Mechanical Engineering' }
                                            ],
                                            'Civil Engineering': [
                                                { id: 4, name: 'Prof. Sneha Deshmukh', username: 'snehad', email: 'snehad@gmail.com', phone: '9876543216', department: 'Civil Engineering' }
                                            ],
                                            'Electronics Engineering': [
                                                { id: 5, name: 'Prof. Neha Patil', username: 'nehapatil', email: 'nehapatil@gmail.com', phone: '9876543217', department: 'Electronics Engineering' }
                                            ]
                                        };

                                        const mockAvailableSubjects = {
                                            'Computer Engineering': [
                                                { id: 1, subjectName: 'Java', name: 'Java', course: 'BTech', department: 'Computer Engineering', dept: 'Computer Engineering', semester: 5, sem: 5 },
                                                { id: 2, subjectName: 'DBMS', name: 'DBMS', course: 'BTech', department: 'Computer Engineering', dept: 'Computer Engineering', semester: 5, sem: 5 },
                                                { id: 3, subjectName: 'Computer Networks', name: 'Computer Networks', course: 'BTech', department: 'Computer Engineering', dept: 'Computer Engineering', semester: 5, sem: 5 },
                                                { id: 4, subjectName: 'Operating System', name: 'Operating System', course: 'BTech', department: 'Computer Engineering', dept: 'Computer Engineering', semester: 5, sem: 5 }
                                            ],
                                            'Information Technology': [
                                                { id: 5, subjectName: 'Web Technology', name: 'Web Technology', course: 'BTech', department: 'Information Technology', dept: 'Information Technology', semester: 5, sem: 5 },
                                                { id: 6, subjectName: 'Software Engineering', name: 'Software Engineering', course: 'BTech', department: 'Information Technology', dept: 'Information Technology', semester: 5, sem: 5 },
                                                { id: 7, subjectName: 'Data Mining', name: 'Data Mining', course: 'BTech', department: 'Information Technology', dept: 'Information Technology', semester: 6, sem: 6 }
                                            ],
                                            'Mechanical Engineering': [
                                                { id: 8, subjectName: 'Thermodynamics', name: 'Thermodynamics', course: 'BTech', department: 'Mechanical Engineering', dept: 'Mechanical Engineering', semester: 5, sem: 5 },
                                                { id: 9, subjectName: 'Manufacturing Process', name: 'Manufacturing Process', course: 'BTech', department: 'Mechanical Engineering', dept: 'Mechanical Engineering', semester: 5, sem: 5 }
                                            ],
                                            'Civil Engineering': [
                                                { id: 10, subjectName: 'Structural Engineering', name: 'Structural Engineering', course: 'BTech', department: 'Civil Engineering', dept: 'Civil Engineering', semester: 5, sem: 5 },
                                                { id: 11, subjectName: 'Construction Management', name: 'Construction Management', course: 'BTech', department: 'Civil Engineering', dept: 'Civil Engineering', semester: 6, sem: 6 }
                                            ],
                                            'Electronics Engineering': [
                                                { id: 12, subjectName: 'Digital Electronics', name: 'Digital Electronics', course: 'BTech', department: 'Electronics Engineering', dept: 'Electronics Engineering', semester: 5, sem: 5 },
                                                { id: 13, subjectName: 'Microprocessor', name: 'Microprocessor', course: 'BTech', department: 'Electronics Engineering', dept: 'Electronics Engineering', semester: 5, sem: 5 }
                                            ]
                                        };

                                        const teacherAssignedState = {
                                            'patil': [
                                                { id: 1, subjectName: 'Java', name: 'Java', course: 'BTech', department: 'Computer Engineering', dept: 'Computer Engineering', semester: 5, sem: 5, year: 'Third Year', studentCount: 0 },
                                                { id: 2, subjectName: 'DBMS', name: 'DBMS', course: 'BTech', department: 'Computer Engineering', dept: 'Computer Engineering', semester: 5, sem: 5, year: 'Third Year', studentCount: 0 },
                                                { id: 3, subjectName: 'Computer Networks', name: 'Computer Networks', course: 'BTech', department: 'Computer Engineering', dept: 'Computer Engineering', semester: 5, sem: 5, year: 'Third Year', studentCount: 0 }
                                            ]
                                        };

                                        const mockEligibleStudents = [
                                            // Computer Engineering - Sem 5 - Third Year
                                            { id: 1, name: 'Gaurav Patil', rollNo: 'TY2627COC055', username: 'gauravpatil', email: 'gauravpatil@gmail.com', phone: '9876543210', course: 'BTech', department: 'Computer Engineering', dept: 'Computer Engineering', semester: 5, sem: 5, year: 'Third Year' },
                                            { id: 2, name: 'Rahul Sharma', rollNo: 'TY2627COC056', username: 'rahulsharma', email: 'rahul@gmail.com', phone: '9876543211', course: 'BTech', department: 'Computer Engineering', dept: 'Computer Engineering', semester: 5, sem: 5, year: 'Third Year' },
                                            { id: 3, name: 'Amit Jadhav', rollNo: 'TY2627COC057', username: 'amitjadhav', email: 'amit@gmail.com', phone: '9876543212', course: 'BTech', department: 'Computer Engineering', dept: 'Computer Engineering', semester: 5, sem: 5, year: 'Third Year' },
                                            { id: 4, name: 'Sneha Patil', rollNo: 'TY2627COC058', username: 'snehapatil', email: 'sneha@gmail.com', phone: '9876543213', course: 'BTech', department: 'Computer Engineering', dept: 'Computer Engineering', semester: 5, sem: 5, year: 'Third Year' },
                                            { id: 5, name: 'Akash More', rollNo: 'TY2627COC059', username: 'akashmore', email: 'akash@gmail.com', phone: '9876543214', course: 'BTech', department: 'Computer Engineering', dept: 'Computer Engineering', semester: 5, sem: 5, year: 'Third Year' },
                                            // Computer Engineering - Sem 3 - Second Year
                                            { id: 6, name: 'Pooja Kulkarni', rollNo: 'SY2627COC012', username: 'poojak', email: 'pooja@gmail.com', phone: '9876543215', course: 'BTech', department: 'Computer Engineering', dept: 'Computer Engineering', semester: 3, sem: 3, year: 'Second Year' },
                                            { id: 7, name: 'Rohan Shinde', rollNo: 'SY2627COC013', username: 'rohans', email: 'rohan@gmail.com', phone: '9876543216', course: 'BTech', department: 'Computer Engineering', dept: 'Computer Engineering', semester: 3, sem: 3, year: 'Second Year' },
                                            // Information Technology - Sem 5 - Third Year
                                            { id: 8, name: 'Priya Verma', rollNo: 'TY2627ITC020', username: 'priyav', email: 'priya@gmail.com', phone: '9876543217', course: 'BTech', department: 'Information Technology', dept: 'Information Technology', semester: 5, sem: 5, year: 'Third Year' },
                                            { id: 9, name: 'Sameer Joshi', rollNo: 'TY2627ITC021', username: 'sameerj', email: 'sameer@gmail.com', phone: '9876543218', course: 'BTech', department: 'Information Technology', dept: 'Information Technology', semester: 5, sem: 5, year: 'Third Year' },
                                            { id: 10, name: 'Aniket Deshmukh', rollNo: 'TY2627ITC022', username: 'aniketd', email: 'aniket@gmail.com', phone: '9876543219', course: 'BTech', department: 'Information Technology', dept: 'Information Technology', semester: 5, sem: 5, year: 'Third Year' },
                                            // Mechanical Engineering - Sem 5 - Third Year
                                            { id: 11, name: 'Vikas Shinde', rollNo: 'TY2627MEC033', username: 'vikass', email: 'vikas@gmail.com', phone: '9876543220', course: 'BTech', department: 'Mechanical Engineering', dept: 'Mechanical Engineering', semester: 5, sem: 5, year: 'Third Year' },
                                            { id: 12, name: 'Karan Pawar', rollNo: 'TY2627MEC034', username: 'karanp', email: 'karan@gmail.com', phone: '9876543221', course: 'BTech', department: 'Mechanical Engineering', dept: 'Mechanical Engineering', semester: 5, sem: 5, year: 'Third Year' },
                                            // Civil Engineering - Sem 5 - Third Year
                                            { id: 13, name: 'Tanvi Gadgil', rollNo: 'TY2627CEC040', username: 'tanvig', email: 'tanvi@gmail.com', phone: '9876543222', course: 'BTech', department: 'Civil Engineering', dept: 'Civil Engineering', semester: 5, sem: 5, year: 'Third Year' },
                                            { id: 14, name: 'Nikhil Rane', rollNo: 'TY2627CEC041', username: 'nikhilr', email: 'nikhil@gmail.com', phone: '9876543223', course: 'BTech', department: 'Civil Engineering', dept: 'Civil Engineering', semester: 5, sem: 5, year: 'Third Year' },
                                            // Electronics Engineering - Sem 5 - Third Year
                                            { id: 15, name: 'Swati Kadam', rollNo: 'TY2627EXC050', username: 'swatik', email: 'swati@gmail.com', phone: '9876543224', course: 'BTech', department: 'Electronics Engineering', dept: 'Electronics Engineering', semester: 5, sem: 5, year: 'Third Year' },
                                            { id: 16, name: 'Omkar Bhosale', rollNo: 'TY2627EXC051', username: 'omkarb', email: 'omkar@gmail.com', phone: '9876543225', course: 'BTech', department: 'Electronics Engineering', dept: 'Electronics Engineering', semester: 5, sem: 5, year: 'Third Year' }
                                        ];

                                        let activeSubjectForStudentAssign = null;

                                        function onAssignDeptChange() {
                                            const deptSelect = document.getElementById('assignDeptSelect');
                                            const teacherSelect = document.getElementById('assignTeacherSelect');
                                            if (!deptSelect || !teacherSelect) return;
                                            const dept = deptSelect.value;
                                            const teachers = mockTeachersByDept[dept] || [];

                                            teacherSelect.innerHTML = teachers.map(t => `<option value="${t.username}">${t.name}</option>`).join('');
                                            onAssignTeacherChange();
                                        }

                                        function onAssignTeacherChange() {
                                            const deptSelect = document.getElementById('assignDeptSelect');
                                            const teacherSelect = document.getElementById('assignTeacherSelect');
                                            if (!deptSelect || !teacherSelect) return;
                                            const dept = deptSelect.value;
                                            const username = teacherSelect.value;
                                            const teachers = mockTeachersByDept[dept] || [];
                                            const teacher = teachers.find(t => t.username === username) || teachers[0] || { name: 'Prof. Patil', username: 'patil', department: dept, dept: dept, course: 'BTech' };

                                            const teacherDept = teacher.department || teacher.dept || dept;
                                            document.getElementById('teacherDetailName').innerText = teacher.name;
                                            document.getElementById('teacherDetailUsername').innerText = teacher.username;
                                            document.getElementById('teacherDetailDept').innerText = teacherDept;
                                            document.getElementById('assignTeacherLabel').innerText = teacher.name;
                                            document.getElementById('assignedOverviewTeacher').innerText = teacher.name;
                                            document.getElementById('assignedTeacherBadgeName').innerText = teacher.name;

                                            renderAvailableSubjects(teacherDept);
                                            renderAssignedSubjectsTable(teacher.username);
                                        }

                                        function renderAvailableSubjects(dept) {
                                            const listEl = document.getElementById('availableSubjectsList');
                                            if (!listEl) return;
                                            const subjects = mockAvailableSubjects[dept] || [];
                                            if (subjects.length === 0) {
                                                listEl.innerHTML = `<div style="font-size:0.85rem; color:var(--text-muted); font-style:italic;">No available subjects for this department.</div>`;
                                                return;
                                            }
                                            listEl.innerHTML = subjects.map(s => {
                                                const subjName = s.subjectName || s.name;
                                                const course = s.course || 'BTech';
                                                const subjectDept = s.department || s.dept || dept;
                                                const sem = s.semester || s.sem || 5;
                                                return `
                        <label style="display:flex; align-items:center; gap:0.75rem; padding:0.65rem 0.85rem; background:#FFFFFF; border:1.5px solid var(--border); border-radius:var(--radius-sm); font-size:0.875rem; cursor:pointer;">
                            <input type="checkbox" class="subject-assign-checkbox" value="${subjName}" data-course="${course}" data-dept="${subjectDept}" data-sem="${sem}" style="accent-color:var(--primary-blue); width:18px; height:18px; cursor:pointer;">
                            <div>
                                <strong style="color:var(--primary-navy); font-size:0.925rem;">${subjName}</strong> 
                                <div style="font-size:0.775rem; color:var(--text-muted); margin-top:0.15rem;">${course} &bull; ${subjectDept} &bull; Semester ${sem}</div>
                            </div>
                        </label>
                    `;
                                            }).join('');
                                        }

                                        function renderAssignedSubjectsTable(username) {
                                            const tbody = document.getElementById('assignedSubjectsTbody');
                                            if (!tbody) return;
                                            const assigned = teacherAssignedState[username] || [];
                                            if (assigned.length === 0) {
                                                tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; padding:1.5rem; color:var(--text-muted); font-style:italic;">No subjects assigned to this teacher yet.</td></tr>`;
                                                return;
                                            }
                                            tbody.innerHTML = assigned.map(s => {
                                                const subjName = s.subjectName || s.name || 'N/A';
                                                const course = s.course || 'BTech';
                                                const dept = s.department || s.dept || 'Computer Engineering';
                                                const sem = s.semester || s.sem || 5;
                                                const year = s.year || (sem <= 2 ? 'First Year' : sem <= 4 ? 'Second Year' : sem <= 6 ? 'Third Year' : 'Fourth Year');
                                                const count = s.studentCount !== undefined ? s.studentCount : 0;
                                                return `
                        <tr>
                            <td><strong style="color:var(--primary-navy);">${subjName}</strong></td>
                            <td><span class="badge" style="background:#EFF6FF; color:#2563EB; font-weight:700;">${course}</span></td>
                            <td>${dept}</td>
                            <td>Semester ${sem}</td>
                            <td><span class="badge" style="background:#F1F5F9; color:#1E293B; font-weight:700;">${count} Students</span></td>
                            <td>
                                <button class="btn btn-primary btn-sm" onclick="openAssignStudentsModalForSubject('${username}', '${subjName}', '${course}', '${dept}', ${sem}, '${year}')">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right:0.3rem;"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="16" y1="11" x2="22" y2="11"/></svg>
                                    Manage Students
                                </button>
                            </td>
                        </tr>`;
                                            }).join('');
                                        }

                                        function assignSelectedSubjectsToTeacher() {
                                            const teacherSelect = document.getElementById('assignTeacherSelect');
                                            if (!teacherSelect) return;
                                            const username = teacherSelect.value;
                                            const deptSelect = document.getElementById('assignDeptSelect').value;
                                            const checkboxes = document.querySelectorAll('.subject-assign-checkbox:checked');
                                            if (checkboxes.length === 0) {
                                                return;
                                            }
                                            if (!teacherAssignedState[username]) teacherAssignedState[username] = [];

                                            checkboxes.forEach(cb => {
                                                const subjName = cb.value;
                                                const course = cb.getAttribute('data-course') || 'BTech';
                                                const dept = cb.getAttribute('data-dept') || deptSelect;
                                                const sem = parseInt(cb.getAttribute('data-sem')) || 5;
                                                if (!teacherAssignedState[username].some(s => (s.subjectName || s.name) === subjName)) {
                                                    teacherAssignedState[username].push({
                                                        id: Date.now(),
                                                        subjectName: subjName,
                                                        name: subjName,
                                                        course: course,
                                                        department: dept,
                                                        dept: dept,
                                                        semester: sem,
                                                        sem: sem,
                                                        year: sem <= 2 ? 'First Year' : sem <= 4 ? 'Second Year' : sem <= 6 ? 'Third Year' : 'Fourth Year',
                                                        studentCount: 0
                                                    });
                                                }
                                            });

                                            renderAssignedSubjectsTable(username);
                                        };

                                        function openAssignStudentsModalForSubject(username, subjName, course, dept, sem, year) {
                                            activeSubjectForStudentAssign = { username, subjName, course, dept, sem, year };

                                            let teacherName = username;
                                            Object.values(mockTeachersByDept).forEach(arr => {
                                                const found = arr.find(t => t.username === username);
                                                if (found) teacherName = found.name;
                                            });

                                            document.getElementById('modalAssignTitle').innerText = `Manage Students for "${subjName}"`;
                                            document.getElementById('modalAssignSub').innerText = `Teacher: ${teacherName} | Subject: ${subjName}`;

                                            const yearSelect = document.getElementById('modalYearSelect');
                                            if (yearSelect) yearSelect.value = year || 'Third Year';

                                            renderModalStudentsList();
                                            openModal('assignStudentsModal');
                                        }

                                        function onModalYearChange() {
                                            if (!activeSubjectForStudentAssign) return;
                                            const yearSelect = document.getElementById('modalYearSelect');
                                            if (yearSelect) {
                                                activeSubjectForStudentAssign.year = yearSelect.value;
                                            }
                                            renderModalStudentsList();
                                        }

                                        function renderModalStudentsList() {
                                            if (!activeSubjectForStudentAssign) return;
                                            const { course, dept, sem, year } = activeSubjectForStudentAssign;

                                            document.getElementById('modalFilterCriteria').innerText = `${course} | ${dept} | Semester ${sem} | ${year}`;

                                            const tbody = document.getElementById('eligibleStudentsTbody');
                                            const eligible = mockEligibleStudents.filter(st =>
                                                (st.department === dept || st.dept === dept) &&
                                                st.course === course &&
                                                (st.semester === sem || st.sem === sem) &&
                                                st.year === year
                                            );

                                            if (eligible.length === 0) {
                                                tbody.innerHTML = `<tr><td colspan="7" style="text-align:center; padding:1.5rem; color:var(--text-muted); font-style:italic;">No matching eligible students found for criteria (${course} • ${dept} • Semester ${sem} • ${year}).</td></tr>`;
                                            } else {
                                                tbody.innerHTML = eligible.map(st => `
                        <tr>
                            <td style="text-align:center;">
                                <input type="checkbox" class="eligible-student-checkbox" onchange="updateSelectedStudentsCount()" style="width:18px; height:18px; accent-color:var(--primary-blue); cursor:pointer;">
                            </td>
                            <td><strong style="color:var(--primary-navy);">${st.name}</strong></td>
                            <td><code>${st.rollNo}</code></td>
                            <td>${st.username}</td>
                            <td>${st.course}</td>
                            <td>${st.department || st.dept}</td>
                            <td>Semester ${st.semester || st.sem} (${st.year})</td>
                        </tr>
                    `).join('');
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
                                            document.getElementById('selectedStudentsCountBadge').innerText = `Selected Students: ${count}`;
                                        }

                                        function confirmAssignStudents() {
                                            const count = document.querySelectorAll('.eligible-student-checkbox:checked').length;
                                            if (activeSubjectForStudentAssign && teacherAssignedState[activeSubjectForStudentAssign.username]) {
                                                const item = teacherAssignedState[activeSubjectForStudentAssign.username].find(s => (s.subjectName || s.name) === activeSubjectForStudentAssign.subjName);
                                                if (item) {
                                                    item.studentCount = count;
                                                }
                                                renderAssignedSubjectsTable(activeSubjectForStudentAssign.username);
                                            }
                                            closeModal('assignStudentsModal');
                                        }

                                        function toggleSidebar() {
                                            sidebar.classList.toggle('open');
                                            sidebarOverlay.classList.toggle('active');
                                        }

                                        if (menuToggleBtn) menuToggleBtn.addEventListener('click', toggleSidebar);
                                        if (sidebarOverlay) sidebarOverlay.addEventListener('click', toggleSidebar);

                                        function switchTab(sectionId, clickedElement) {
                                            if (sectionId === 'studentMgmtSection') { window.location.href = 'students.jsp'; return; }
                                            if (sectionId === 'teacherMgmtSection') { window.location.href = 'teachers.jsp'; return; }
                                            if (sectionId === 'subjectAssignSection') { window.location.href = 'subject-assignment.jsp'; return; }
                                            if (sectionId === 'profileSection') { window.location.href = 'profile.jsp'; return; }

                                            document.querySelectorAll('.section-pane').forEach(pane => {
                                                pane.classList.remove('active-pane');
                                            });

                                            const targetPane = document.getElementById(sectionId);
                                            if (targetPane) {
                                                targetPane.classList.add('active-pane');
                                            }

                                            document.querySelectorAll('.sidebar-menu .nav-item').forEach(item => {
                                                item.classList.remove('active');
                                            });

                                            const navItem = clickedElement ? clickedElement.closest('.nav-item') : null;
                                            if (navItem) {
                                                navItem.classList.add('active');
                                            }

                                            const titles = {
                                                'dashboardSection': 'Admin Dashboard',
                                                'studentMgmtSection': 'Student Management',
                                                'teacherMgmtSection': 'Teacher Management',
                                                'subjectAssignSection': 'Subject Assignment',
                                                'profileSection': 'Admin Profile'
                                            };
                                            if (headerTitle && titles[sectionId]) {
                                                headerTitle.innerText = titles[sectionId];
                                            }

                                            if (sectionId === 'subjectAssignSection') {
                                                onAssignDeptChange();
                                            }

                                            if (window.innerWidth <= 860 && sidebar.classList.contains('open')) {
                                                toggleSidebar();
                                            }
                                        }

                                        /* Filter Functions */
                                        function filterStudentTable() {
                                            const query = document.getElementById('studentSearchInput').value.toLowerCase();
                                            const courseEl = document.getElementById('studentCourseFilter');
                                            const course = courseEl ? courseEl.value.toLowerCase() : '';
                                            const deptEl = document.getElementById('studentDeptFilter');
                                            const dept = deptEl ? deptEl.value.toLowerCase() : '';
                                            const rows = document.querySelectorAll('#studentsTable tbody tr');

                                            rows.forEach(row => {
                                                const text = row.innerText.toLowerCase();
                                                const matchesQuery = text.includes(query);
                                                const matchesCourse = course === '' || text.includes(course);
                                                const matchesDept = dept === '' || text.includes(dept);
                                                row.style.display = matchesQuery && matchesCourse && matchesDept ? '' : 'none';
                                            });
                                        }

                                        function filterTeacherTable() {
                                            const query = document.getElementById('teacherSearchInput').value.toLowerCase();
                                            const dept = document.getElementById('teacherDeptFilter').value.toLowerCase();
                                            const rows = document.querySelectorAll('#teachersTable tbody tr');

                                            rows.forEach(row => {
                                                const text = row.innerText.toLowerCase();
                                                const matchesQuery = text.includes(query);
                                                const matchesDept = dept === '' || text.includes(dept);
                                                row.style.display = matchesQuery && matchesDept ? '' : 'none';
                                            });
                                        }

                                        /* Modal Helpers */
                                        function openModal(id) {
                                            const el = document.getElementById(id);
                                            if (el) el.classList.add('open');
                                        }
                                        function closeModal(id) {
                                            const el = document.getElementById(id);
                                            if (el) el.classList.remove('open');
                                        }

                                        function openStudentModal(type, roll = '', name = '', email = '', course = '', sem = '') {
                                            const titleEl = document.getElementById('studentModalTitle');
                                            if (titleEl) titleEl.innerText = type === 'add' ? 'Add New Student' : 'Edit Student Details';

                                            const rollEl = document.getElementById('mRollNo');
                                            if (rollEl) rollEl.value = roll;

                                            const nameEl = document.getElementById('mStudentFullName');
                                            if (nameEl) nameEl.value = name;

                                            const emailEl = document.getElementById('mStudentEmail');
                                            if (emailEl) emailEl.value = email;

                                            const courseEl = document.getElementById('mStudentCourse');
                                            if (courseEl && course) courseEl.value = course;

                                            const semEl = document.getElementById('mStudentSem');
                                            if (semEl && sem) semEl.value = sem;

                                            openModal('studentModal');
                                        }

                                        function openTeacherModal(type, id = '', name = '', email = '', dept = '') {
                                            const titleEl = document.getElementById('teacherModalTitle');
                                            if (titleEl) titleEl.innerText = type === 'add' ? 'Add New Faculty Member' : 'Edit Faculty Member';

                                            const nameEl = document.getElementById('mTeacherFullName');
                                            if (nameEl) nameEl.value = name;

                                            const emailEl = document.getElementById('mTeacherEmail');
                                            if (emailEl) emailEl.value = email;

                                            const deptEl = document.getElementById('mTeacherDept');
                                            if (deptEl && dept) deptEl.value = dept;

                                            openModal('teacherModal');
                                        }

                                        function openDeleteModal(role, name) {
                                            document.getElementById('deleteModalText').innerText = `Are you sure you want to remove ${role} "${name}"?`;
                                            openModal('deleteModal');
                                        }

                                        function confirmDeleteModal() {
                                            closeModal('deleteModal');
                                        }

                                        document.addEventListener('DOMContentLoaded', () => {
                                            onAssignDeptChange();

                                            const urlParams = new URLSearchParams(window.location.search);
                                            const tab = urlParams.get('tab');
                                            if (tab === 'student' || tab === 'studentMgmtSection') {
                                                window.location.href = 'students.jsp';
                                            } else if (tab === 'teacher' || tab === 'teacherMgmtSection') {
                                                window.location.href = 'teachers.jsp';
                                            } else if (tab === 'subject' || tab === 'subjectAssignSection') {
                                                window.location.href = 'subject-assignment.jsp';
                                            }

                                            const alertBanner = document.getElementById('alertBanner');
                                            if (alertBanner) {
                                                setTimeout(() => {
                                                    alertBanner.style.opacity = '0';
                                                    alertBanner.style.transform = 'translateY(-10px)';
                                                    setTimeout(() => alertBanner.remove(), 500);
                                                }, 3000);
                                            }

                                            if (window.history && window.history.replaceState) {
                                                const url = new URL(window.location.href);
                                                if (url.searchParams.has('success') || url.searchParams.has('error')) {
                                                    url.searchParams.delete('success');
                                                    url.searchParams.delete('error');
                                                    window.history.replaceState({}, document.title, url.pathname + (url.searchParams.toString() ? '?' + url.searchParams.toString() : ''));
                                                }
                                            }
                                        });
                                    </script>
                        </body>

                        </html>