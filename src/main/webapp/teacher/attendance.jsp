<%@ page language = "java" contentType = "text/html; charset = UTF-8" pageEncoding = "UTF-8" import = "com.student.entity.*" %>
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
    %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Mark Attendance - Teacher Dashboard</title>
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
                }

                .sidebar-brand {
                    height: var(--topbar-height);
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                    padding: 0 1.5rem;
                    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
                    font-size: 1.15rem;
                    font-weight: 800;
                }

                .sidebar-brand svg {
                    width: 28px;
                    height: 28px;
                    color: #60A5FA;
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
                }

                .logout-link:hover {
                    background: rgba(220, 38, 38, 0.1);
                    color: #EF4444;
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

                .page-title {
                    font-size: 1.35rem;
                    font-weight: 700;
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
                }

                .card-header-row h3 {
                    font-size: 1.1rem;
                    font-weight: 700;
                }

                .table-responsive {
                    width: 100%;
                    overflow-x: auto;
                }

                .data-table {
                    width: 100%;
                    border-collapse: collapse;
                    text-align: left;
                    font-size: 0.925rem;
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
                    padding: 0.85rem 1rem;
                    border-bottom: 1px solid var(--border);
                    font-weight: 500;
                }

                .btn-submit {
                    padding: 0.6rem 1.25rem;
                    background: var(--primary-blue);
                    color: #FFF;
                    border: none;
                    border-radius: var(--radius-sm);
                    font-weight: 700;
                    cursor: pointer;
                }

                .btn-submit:hover {
                    background: var(--primary-blue-hover);
                }
            </style>
        </head>

        <body>
            <aside class="sidebar">
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
                    <li class="nav-item"><a href="subjects.jsp"><svg viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="2">
                                <path
                                    d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                            </svg><span>Assigned Subjects</span></a></li>
                    <li class="nav-item"><a href="students.jsp"><svg viewBox="0 0 24 24" fill="none"
                                stroke="currentColor">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                <circle cx="9" cy="7" r="4" />
                            </svg><span>Assigned Students</span></a></li>
                    <li class="nav-item"><a href="cce-marks.jsp"><svg viewBox="0 0 24 24" fill="none"
                                stroke="currentColor">
                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                <polyline points="14 2 14 8 20 8" />
                            </svg><span>CCE Marks</span></a></li>
                    <li class="nav-item"><a href="end-sem-marks.jsp"><svg viewBox="0 0 24 24" fill="none"
                                stroke="currentColor">
                                <path d="M9 11l3 3L22 4" />
                                <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11" />
                            </svg><span>End Sem Marks</span></a></li>
                    <li class="nav-item"><a href="results.jsp"><svg viewBox="0 0 24 24" fill="none"
                                stroke="currentColor">
                                <polygon
                                    points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                            </svg><span>View Results</span></a></li>
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
                        <h1 class="page-title">Mark Student Attendance</h1>
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
                        <div class="content-card">
                            <div class="card-header-row">
                                <h3>Daily Attendance Sheet</h3>
                                <button class="btn-submit">Submit Attendance</button>
                            </div>
                            <div class="table-responsive">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Roll No</th>
                                            <th>Student Name</th>
                                            <th>Subject</th>
                                            <th>Date</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>101</td>
                                            <td>John Doe</td>
                                            <td>Database Management Systems</td>
                                            <td>Today</td>
                                            <td>
                                                <select
                                                    style="padding: 0.4rem; border-radius: 6px; border: 1px solid #CBD5E1; font-weight: 600;">
                                                    <option value="PRESENT">Present</option>
                                                    <option value="ABSENT">Absent</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>102</td>
                                            <td>Jane Smith</td>
                                            <td>Database Management Systems</td>
                                            <td>Today</td>
                                            <td>
                                                <select
                                                    style="padding: 0.4rem; border-radius: 6px; border: 1px solid #CBD5E1; font-weight: 600;">
                                                    <option value="PRESENT">Present</option>
                                                    <option value="ABSENT">Absent</option>
                                                </select>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
            <jsp:include page="/logout-modal.jsp" />
        </body>

        </html>