<%@ page language="java" contentType="text/html; charset = UTF-8" pageEncoding="UTF-8"
    import="java.util.*, com.student.entity.*, com.student.service.*" %>
    <% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
        response.setHeader("Pragma", "no-cache" ); response.setDateHeader("Expires", 0); if (session==null ||
        session.getAttribute("student")==null) { response.sendRedirect(request.getContextPath() + "/login.jsp" );
        return; } Student currentStudent=(Student) session.getAttribute("student"); String studentName=(currentStudent
        !=null && currentStudent.getName() !=null && !currentStudent.getName().trim().isEmpty()) ?
        currentStudent.getName().trim() : ((currentStudent !=null && currentStudent.getUsername() !=null) ?
        currentStudent.getUsername().trim() : "Student" ); String studentInitial=(studentName.length()> 0) ?
        String.valueOf(studentName.charAt(0)).toUpperCase() : "S";
        String rollNo = (currentStudent != null && currentStudent.getRollNo() != null &&
        !currentStudent.getRollNo().trim().isEmpty()) ? currentStudent.getRollNo().trim() : "--";
        String course = (currentStudent != null && currentStudent.getCourse() != null &&
        !currentStudent.getCourse().trim().isEmpty()) ? currentStudent.getCourse().trim() : "--";
        String dept = (currentStudent != null && currentStudent.getDepartment() != null &&
        !currentStudent.getDepartment().trim().isEmpty()) ? currentStudent.getDepartment().trim() : "--";
        String rawSem = (currentStudent != null && currentStudent.getSemester() != null) ?
        currentStudent.getSemester().trim() : "";
        String semText = rawSem.isEmpty() ? "--" : (rawSem.toLowerCase().startsWith("semester") ? rawSem : ("Semester "
        + rawSem));
        String year = (currentStudent != null && currentStudent.getYear() != null &&
        !currentStudent.getYear().trim().isEmpty()) ? currentStudent.getYear().trim() : "--";
        String academicYearStr = (year != null && year.matches(".*\\d{4}.*")) ? year : "2026-2027";
        String pdfFileName = (rollNo.equals("--") ? "STUDENT" : rollNo) + "_" + academicYearStr + "-Marksheet";
        // 1. Fetch Enrolled Subjects for logged-in student
        StudentSubjectAssignmentService assignmentService = new StudentSubjectAssignmentService();
        List<StudentSubjectAssignment> assignments = assignmentService.getAssignmentsByStudent(currentStudent.getId());
            if (assignments == null)
            {
            assignments = new ArrayList<>();
                }
                // 2. Fetch Marks for logged-in student
                StudentSubjectMarksService marksService = new StudentSubjectMarksService();
                List<StudentSubjectMarks> allMarksList = marksService.getMarksByStudent(currentStudent.getId());
                    Map<Integer, StudentSubjectMarks> marksMap = new HashMap<>();
                            if (allMarksList != null)
                            {
                            for (StudentSubjectMarks m : allMarksList)
                            {
                            if (m != null && m.getSubject() != null)
                            {
                            marksMap.put(m.getSubject().getId(), m);
                            }
                            }
                            }
                            // 3. Dynamic Calculation & Persistence via StudentResultSummaryService
                            StudentResultSummaryService summaryService = new StudentResultSummaryService();
                            StudentResultSummary summary =
                            summaryService.calculateAndSaveSummary(currentStudent.getId(),
                            currentStudent.getSemester());
                            int totalEnrolledSubjects = assignments.size();
                            double totalSemesterCreditsDouble = 0.0;
                            List<Map<String, Object>> resultRows = new ArrayList<>();
                                    for (StudentSubjectAssignment assign : assignments)
                                    {
                                    if (assign == null || assign.getSubject() == null) continue;
                                    Subject sub = assign.getSubject();
                                    int credit = sub.getCredit();
                                    totalSemesterCreditsDouble += credit;
                                    StudentSubjectMarks m = marksMap.get(sub.getId());
                                    Map<String, Object> row = new HashMap<>();
                                            row.put("code", sub.getSubjectCode() != null ? sub.getSubjectCode() : "--");
                                            row.put("name", sub.getSubjectName() != null ? sub.getSubjectName() : "--");
                                            row.put("credit", credit);
                                            boolean hasValidMarks = (m != null && (m.getTotalMarks() > 0 ||
                                            (m.getGrade() != null && !m.getGrade().trim().isEmpty() &&
                                            !m.getGrade().equalsIgnoreCase("N/A")) || (m.getResultStatus() != null &&
                                            !m.getResultStatus().trim().isEmpty() &&
                                            !m.getResultStatus().equalsIgnoreCase("PENDING"))));
                                            if (hasValidMarks)
                                            {
                                            row.put("hasMarks", true);
                                            row.put("internal", String.format("%.0f", m.getInternalMarks()));
                                            row.put("external", String.format("%.0f", m.getEndSemesterMarks()));
                                            row.put("total", String.format("%.0f", m.getTotalMarks()));
                                            String g = (m.getGrade() != null && !m.getGrade().trim().isEmpty() &&
                                            !m.getGrade().equalsIgnoreCase("N/A")) ? m.getGrade().trim() :
                                            StudentResultSummaryService.calculateGrade(m.getTotalMarks());
                                            row.put("grade", g);
                                            String status = (m.getResultStatus() != null &&
                                            !m.getResultStatus().trim().isEmpty()) ? m.getResultStatus().trim() :
                                            ("F".equalsIgnoreCase(g) ? "FAIL" : "PASS");
                                            row.put("status", status);
                                            }
                                            else
                                            {
                                            row.put("hasMarks", false);
                                            row.put("internal", "--");
                                            row.put("external", "--");
                                            row.put("total", "--");
                                            row.put("grade", "--");
                                            row.put("status", "PENDING");
                                            }
                                            resultRows.add(row);
                                            }
                                            int totalSemesterCredits = (int) totalSemesterCreditsDouble;
                                            String totalMarksSecuredStr;
                                            String percentageStr;
                                            String sgpaStr;
                                            String cgpaStr;
                                            String finalGradeStr;
                                            String finalStandingStr;
                                            String finalStandingClass;
                                            if (summary != null)
                                            {
                                            if (summary.getMaxMarks() > 0 && summary.getTotalMarks() > 0)
                                            {
                                            totalMarksSecuredStr = String.format("%.0f / %.0f", summary.getTotalMarks(),
                                            summary.getMaxMarks());
                                            }
                                            else if (summary.getMaxMarks() > 0)
                                            {
                                            totalMarksSecuredStr = String.format("0 / %.0f", summary.getMaxMarks());
                                            }
                                            else
                                            {
                                            totalMarksSecuredStr = "-- / --";
                                            }
                                            percentageStr = (summary.getPercentage() > 0 || (summary.getMaxMarks() > 0
                                            && summary.getTotalMarks() > 0)) ? String.format("%.2f%%",
                                            summary.getPercentage()) : "--";
                                            if (summary.getSgpa() > 0)
                                            {
                                            sgpaStr = String.format("%.2f / 10.00", summary.getSgpa());
                                            }
                                            else
                                            {
                                            sgpaStr = "--";
                                            }
                                            if (summary.getCgpa() > 0)
                                            {
                                            cgpaStr = String.format("%.2f / 10.00", summary.getCgpa());
                                            }
                                            else
                                            {
                                            cgpaStr = "--";
                                            }
                                            finalGradeStr = (summary.getFinalGrade() != null &&
                                            !summary.getFinalGrade().trim().isEmpty()) ? summary.getFinalGrade().trim()
                                            : "--";
                                            finalStandingStr = summary.getResultStatus() != null ?
                                            summary.getResultStatus() : "Pending";
                                            if ("PASS".equalsIgnoreCase(finalStandingStr) ||
                                            "PASSED".equalsIgnoreCase(finalStandingStr))
                                            {
                                            finalStandingStr = "Pass";
                                            finalStandingClass = "text-success";
                                            }
                                            else if ("FAIL".equalsIgnoreCase(finalStandingStr) ||
                                            "FAILED".equalsIgnoreCase(finalStandingStr))
                                            {
                                            finalStandingStr = "Fail";
                                            finalStandingClass = "text-danger";
                                            }
                                            else if ("PARTIAL / PENDING".equalsIgnoreCase(finalStandingStr) ||
                                            "PARTIAL/PENDING".equalsIgnoreCase(finalStandingStr))
                                            {
                                            finalStandingStr = "Partial / Pending";
                                            finalStandingClass = "text-muted";
                                            }
                                            else if ("PENDING".equalsIgnoreCase(finalStandingStr))
                                            {
                                            finalStandingStr = "Pending";
                                            finalStandingClass = "text-muted";
                                            }
                                            else
                                            {
                                            finalStandingClass = "text-muted";
                                            }
                                            }
                                            else
                                            {
                                            totalMarksSecuredStr = "-- / --";
                                            percentageStr = "--";
                                            sgpaStr = "--";
                                            cgpaStr = "--";
                                            finalGradeStr = "--";
                                            finalStandingStr = "Pending";
                                            finalStandingClass = "";
                                            }
                                            %>
                                            <!DOCTYPE html>
                                            <html lang="en">

                                            <head>
                                                <meta charset="UTF-8">
                                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                                <title>My Result - Student Management System</title>

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
                                                        --warning: #D97706;

                                                        --sidebar-width: 275px;
                                                        --topbar-height: 70px;

                                                        --radius-sm: 8px;
                                                        --radius-md: 14px;
                                                        --radius-lg: 20px;

                                                        --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.04);
                                                        --shadow-md: 0 10px 25px -5px rgba(30, 58, 95, 0.06), 0 8px 10px -6px rgba(30, 58, 95, 0.02);
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

                                                    /* Main Wrapper */
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
                                                        padding: 0.25rem;
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

                                                    /* Content Area */
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

                                                    /* Summary Result Card */
                                                    .result-summary-grid {
                                                        display: grid;
                                                        grid-template-columns: repeat(5, 1fr);
                                                        gap: 1.25rem;
                                                    }

                                                    @media (max-width: 1024px) {
                                                        .result-summary-grid {
                                                            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                                                        }
                                                    }

                                                    .res-card {
                                                        background: var(--card-bg);
                                                        border-radius: var(--radius-md);
                                                        padding: 1.5rem;
                                                        border: 1px solid var(--border);
                                                        box-shadow: var(--shadow-sm);
                                                        display: flex;
                                                        flex-direction: column;
                                                        gap: 0.35rem;
                                                        transition: var(--transition);
                                                    }

                                                    .res-card:hover {
                                                        transform: translateY(-3px);
                                                        box-shadow: var(--shadow-md);
                                                        border-color: #BFDBFE;
                                                    }

                                                    .res-card label {
                                                        font-size: 0.75rem;
                                                        font-weight: 700;
                                                        color: var(--text-muted);
                                                        text-transform: uppercase;
                                                        letter-spacing: 0.04em;
                                                    }

                                                    .res-card span {
                                                        font-size: 1.65rem;
                                                        font-weight: 800;
                                                        color: var(--text-main);
                                                    }

                                                    /* Table Card */
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
                                                        font-weight: 800;
                                                        color: var(--primary-navy);
                                                    }

                                                    .table-responsive {
                                                        width: 100%;
                                                        overflow-x: auto;
                                                    }

                                                    .data-table {
                                                        width: 100%;
                                                        border-collapse: collapse;
                                                        text-align: center;
                                                        font-size: 0.9rem;
                                                    }

                                                    .data-table th {
                                                        background: #F8FAFC;
                                                        padding: 0.85rem 1rem;
                                                        font-weight: 700;
                                                        color: var(--text-muted);
                                                        text-transform: uppercase;
                                                        font-size: 0.75rem;
                                                        letter-spacing: 0.05em;
                                                        border-bottom: 1px solid var(--border);
                                                        text-align: center;
                                                    }

                                                    .data-table td {
                                                        padding: 1rem;
                                                        border-bottom: 1px solid var(--border);
                                                        color: var(--text-main);
                                                        font-weight: 600;
                                                        text-align: center;
                                                    }

                                                    .data-table td:nth-child(2) {
                                                        text-align: left;
                                                    }

                                                    .data-table tr:hover td {
                                                        background: var(--light-blue);
                                                    }

                                                    .btn-print {
                                                        padding: 0.65rem 1.35rem;
                                                        background: var(--primary-blue);
                                                        color: #FFFFFF;
                                                        border: none;
                                                        border-radius: var(--radius-sm);
                                                        font-weight: 700;
                                                        font-size: 0.875rem;
                                                        cursor: pointer;
                                                        transition: var(--transition);
                                                        display: inline-flex;
                                                        align-items: center;
                                                        gap: 0.5rem;
                                                    }

                                                    .btn-print:hover {
                                                        background: var(--primary-blue-hover);
                                                    }

                                                    /* Status Badges */
                                                    .status-badge-pill {
                                                        display: inline-flex;
                                                        align-items: center;
                                                        gap: 0.35rem;
                                                        padding: 0.25rem 0.75rem;
                                                        border-radius: 50px;
                                                        font-size: 0.75rem;
                                                        font-weight: 800;
                                                        text-transform: uppercase;
                                                    }

                                                    .status-passed-badge {
                                                        background: #DCFCE7;
                                                        color: #15803D;
                                                        border: 1px solid #BBF7D0;
                                                    }

                                                    .status-failed-badge {
                                                        background: #FEE2E2;
                                                        color: #B91C1C;
                                                        border: 1px solid #FECACA;
                                                    }

                                                    .status-pending-badge {
                                                        background: #FEF3C7;
                                                        color: #B45309;
                                                        border: 1px solid #FDE68A;
                                                    }

                                                    .status-muted-badge {
                                                        background: #F1F5F9;
                                                        color: #64748B;
                                                        border: 1px solid #E2E8F0;
                                                    }

                                                    .badge-grade-pill {
                                                        background: #EFF6FF;
                                                        color: #1D4ED8;
                                                        padding: 0.2rem 0.55rem;
                                                        border-radius: 6px;
                                                        font-weight: 800;
                                                        font-size: 0.825rem;
                                                        border: 1px solid #BFDBFE;
                                                        display: inline-block;
                                                    }

                                                    /* Student Profile Card (Screen UI) */
                                                    .student-profile-card {
                                                        background: linear-gradient(135deg, #FFFFFF 0%, #F8FAFC 100%);
                                                        border: 1px solid var(--border);
                                                        border-radius: var(--radius-md);
                                                        padding: 1.25rem 1.5rem;
                                                        box-shadow: var(--shadow-sm);
                                                        margin-bottom: 1.25rem;
                                                    }

                                                    .student-profile-wrapper {
                                                        display: flex;
                                                        align-items: center;
                                                        gap: 1.25rem;
                                                    }

                                                    .student-avatar-large {
                                                        width: 58px;
                                                        height: 58px;
                                                        border-radius: 50%;
                                                        background: var(--gradient-primary);
                                                        color: #FFFFFF;
                                                        font-size: 1.5rem;
                                                        font-weight: 800;
                                                        display: flex;
                                                        align-items: center;
                                                        justify-content: center;
                                                        box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
                                                        flex-shrink: 0;
                                                    }

                                                    .student-info-meta {
                                                        flex: 1;
                                                    }

                                                    .student-name-title {
                                                        font-size: 1.25rem;
                                                        font-weight: 800;
                                                        color: var(--primary-navy);
                                                        margin: 0 0 0.25rem 0;
                                                        display: flex;
                                                        align-items: center;
                                                        gap: 0.75rem;
                                                        flex-wrap: wrap;
                                                    }

                                                    .student-roll-badge {
                                                        display: inline-block;
                                                        background: var(--light-blue);
                                                        color: var(--primary-blue);
                                                        padding: 0.2rem 0.65rem;
                                                        border-radius: 6px;
                                                        font-size: 0.8rem;
                                                        font-weight: 700;
                                                    }

                                                    .student-meta-grid {
                                                        display: grid;
                                                        grid-template-columns: repeat(4, 1fr);
                                                        gap: 1rem;
                                                        margin-top: 0.75rem;
                                                        padding-top: 0.75rem;
                                                        border-top: 1px dashed var(--border);
                                                    }

                                                    .meta-item {
                                                        display: flex;
                                                        flex-direction: column;
                                                    }

                                                    .meta-label {
                                                        font-size: 0.7rem;
                                                        font-weight: 700;
                                                        color: var(--text-muted);
                                                        text-transform: uppercase;
                                                        letter-spacing: 0.04em;
                                                        margin-bottom: 0.15rem;
                                                    }

                                                    .meta-value {
                                                        font-size: 0.9rem;
                                                        font-weight: 700;
                                                        color: var(--text-main);
                                                    }

                                                    /* Print Only Elements (Hidden on screen) */
                                                    .print-only-header {
                                                        display: none;
                                                    }

                                                    .academic-summary-card {
                                                        display: block;
                                                        margin-top: 1.25rem;
                                                        background: #FFFFFF;
                                                        border: 1px solid var(--border);
                                                        border-radius: var(--radius-md);
                                                        box-shadow: var(--shadow-sm);
                                                        overflow: hidden;
                                                    }

                                                    .academic-summary-card .print-summary-header {
                                                        background: #F1F5F9;
                                                        color: var(--primary-navy);
                                                        font-weight: 800;
                                                        font-size: 0.85rem;
                                                        padding: 0.75rem 1.25rem;
                                                        text-transform: uppercase;
                                                        letter-spacing: 0.5px;
                                                        border-bottom: 1px solid var(--border);
                                                    }

                                                    .academic-summary-card .print-summary-table {
                                                        width: 100%;
                                                        border-collapse: collapse;
                                                        font-size: 0.9rem;
                                                    }

                                                    .academic-summary-card .print-summary-table td {
                                                        padding: 0.75rem 1.25rem;
                                                        border: 1px solid var(--border);
                                                        color: var(--text-main);
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

                                                        .student-profile-wrapper {
                                                            flex-direction: column;
                                                            align-items: flex-start;
                                                            gap: 1rem;
                                                        }

                                                        .student-meta-grid {
                                                            grid-template-columns: repeat(2, 1fr);
                                                        }
                                                    }

                                                    /* Print Optimization (@media print) */
                                                    @media print {
                                                        @page {
                                                            size: A4 portrait;
                                                            margin: 10mm 12mm;
                                                        }

                                                        body {
                                                            background: #FFFFFF !important;
                                                            color: #000000 !important;
                                                            font-size: 9.5pt !important;
                                                            display: block !important;
                                                            -webkit-print-color-adjust: exact !important;
                                                            print-color-adjust: exact !important;
                                                        }

                                                        .sidebar,
                                                        .top-navbar,
                                                        .btn-print,
                                                        .menu-toggle-btn,
                                                        .sidebar-overlay,
                                                        .user-profile-badge,
                                                        .student-profile-card,
                                                        .result-summary-grid {
                                                            display: none !important;
                                                        }

                                                        .print-only-header,
                                                        .print-only-summary {
                                                            display: block !important;
                                                        }

                                                        .print-only-summary {
                                                            margin-top: 1rem;
                                                            border: 1px solid #CBD5E1;
                                                            border-radius: 6px;
                                                            overflow: hidden;
                                                            page-break-inside: avoid;
                                                        }

                                                        .print-summary-header {
                                                            background: #E2E8F0;
                                                            color: #0F172A;
                                                            font-weight: 800;
                                                            font-size: 8.5pt;
                                                            padding: 0.4rem 0.75rem;
                                                            text-transform: uppercase;
                                                            letter-spacing: 0.5px;
                                                            border-bottom: 1px solid #CBD5E1;
                                                        }

                                                        .print-summary-table {
                                                            width: 100%;
                                                            border-collapse: collapse;
                                                            font-size: 8.5pt;
                                                        }

                                                        .print-summary-table td {
                                                            padding: 0.45rem 0.75rem;
                                                            border: 1px solid #CBD5E1;
                                                        }

                                                        .main-wrapper {
                                                            margin-left: 0 !important;
                                                            width: 100% !important;
                                                            min-height: auto !important;
                                                        }

                                                        .content-area {
                                                            padding: 0 !important;
                                                        }

                                                        .container {
                                                            max-width: 100% !important;
                                                            gap: 1rem !important;
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
                                                            letter-spacing: 0.5px;
                                                            margin-bottom: 0.2rem;
                                                            text-transform: uppercase;
                                                        }

                                                        .print-header-sub {
                                                            font-size: 0.85rem;
                                                            font-weight: 700;
                                                            color: #2563EB;
                                                            text-transform: uppercase;
                                                            letter-spacing: 1px;
                                                            margin-bottom: 0.4rem;
                                                        }

                                                        .print-header-meta {
                                                            font-size: 0.75rem;
                                                            color: #475569;
                                                        }

                                                        .student-info-print-table {
                                                            width: 100%;
                                                            margin-top: 0.75rem;
                                                            border-collapse: collapse;
                                                            font-size: 8.5pt;
                                                        }

                                                        .student-info-print-table td {
                                                            padding: 0.4rem 0.6rem;
                                                            border: 1px solid #CBD5E1;
                                                        }

                                                        .student-info-print-table td strong {
                                                            color: #1E3A5F;
                                                        }

                                                        .content-card {
                                                            border: 1px solid #CBD5E1 !important;
                                                            box-shadow: none !important;
                                                            padding: 1rem !important;
                                                            border-radius: 6px !important;
                                                            page-break-inside: avoid !important;
                                                        }

                                                        .card-header-row {
                                                            margin-bottom: 0.5rem !important;
                                                            padding-bottom: 0.5rem !important;
                                                        }

                                                        .card-header-row h3 {
                                                            font-size: 1rem !important;
                                                        }

                                                        .data-table {
                                                            font-size: 8.5pt !important;
                                                            text-align: center !important;
                                                        }

                                                        .data-table th {
                                                            background: #E2E8F0 !important;
                                                            color: #0F172A !important;
                                                            padding: 0.5rem !important;
                                                            border: 1px solid #CBD5E1 !important;
                                                            text-align: center !important;
                                                        }

                                                        .data-table td {
                                                            padding: 0.5rem !important;
                                                            border: 1px solid #CBD5E1 !important;
                                                            text-align: center !important;
                                                        }

                                                        .data-table td:nth-child(2) {
                                                            text-align: left !important;
                                                        }
                                                    }
                                                </style>
                                            </head>

                                            <body>
                                                <jsp:include page="/logout-modal.jsp" />
                                                <div class="sidebar-overlay" id="sidebarOverlay"></div>

                                                <aside class="sidebar" id="sidebar">
                                                    <div class="sidebar-brand">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2.5" stroke-linecap="round"
                                                            stroke-linejoin="round">
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
                                                                <svg viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor">
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
                                                                <svg viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor">
                                                                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                                    <path
                                                                        d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                                </svg>
                                                                <span>My Subjects</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="cce-marks.jsp">
                                                                <svg viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor">
                                                                    <path
                                                                        d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                                                    <polyline points="14 2 14 8 20 8" />
                                                                    <line x1="16" y1="13" x2="8" y2="13" />
                                                                    <line x1="16" y1="17" x2="8" y2="17" />
                                                                </svg>
                                                                <span>CCE Marks</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item active">
                                                            <a href="result.jsp">
                                                                <svg viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor">
                                                                    <polygon
                                                                        points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                                                                </svg>
                                                                <span>My Results</span>
                                                            </a>
                                                        </li>
                                                        <li class="nav-item">
                                                            <a href="profile.jsp">
                                                                <svg viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor">
                                                                    <path
                                                                        d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                                                    <circle cx="12" cy="7" r="4" />
                                                                </svg>
                                                                <span>My Profile</span>
                                                            </a>
                                                        </li>
                                                    </ul>

                                                    <div class="sidebar-footer">
                                                        <a href="${pageContext.request.contextPath}/logout"
                                                            class="logout-link" onclick="return openLogoutModal(event)">
                                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2"
                                                                stroke-linecap="round" stroke-linejoin="round">
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
                                                            <button class="menu-toggle-btn" id="menuToggleBtn"
                                                                aria-label="Toggle menu">
                                                                <svg width="24" height="24" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2">
                                                                    <line x1="3" y1="12" x2="21" y2="12" />
                                                                    <line x1="3" y1="6" x2="21" y2="6" />
                                                                    <line x1="3" y1="18" x2="21" y2="18" />
                                                                </svg>
                                                            </button>
                                                            <h1 class="page-title">My Result</h1>
                                                        </div>

                                                        <div class="top-right">
                                                            <div class="user-profile-badge">
                                                                <div class="user-avatar">
                                                                    <%= studentInitial %>
                                                                </div>
                                                                <div class="user-info-text">
                                                                    <span class="user-name">
                                                                        <%= studentName %>
                                                                    </span>
                                                                    <span class="user-role-label">Student</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </header>

                                                    <main class="content-area">
                                                        <div class="container">

                                                            <!-- Official College Header (Visible only when Printing) -->
                                                            <div class="print-only-header">
                                                                <div class="print-header-title">Student Management
                                                                    System</div>
                                                                <div class="print-header-sub">Official Academic
                                                                    Semester Marksheet Report</div>
                                                                <div class="print-header-meta">Department of <%= dept %>
                                                                        | Academic Year <%= academicYearStr %>
                                                                </div>

                                                                <table class="student-info-print-table">
                                                                    <tr>
                                                                        <td><strong>Student Name:</strong>
                                                                            <%= studentName %>
                                                                        </td>
                                                                        <td><strong>Roll Number:</strong>
                                                                            <%= rollNo %>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><strong>Course / Branch:</strong>
                                                                            <%= course %> (<%= dept %>)
                                                                        </td>
                                                                        <td><strong>Semester / Term:</strong>
                                                                            <%= semText %> (<%= year %>)
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>

                                                            <!-- Result Overview Cards (5 Columns in 1 Row) -->
                                                            <div class="result-summary-grid">
                                                                <div class="res-card">
                                                                    <label>Total Marks Secured</label>
                                                                    <span>
                                                                        <%= totalMarksSecuredStr %>
                                                                    </span>
                                                                    <small
                                                                        style="font-size: 0.725rem; color: var(--text-muted); font-weight: 600;">(Enrolled
                                                                        Subjects × 100 Marks)</small>
                                                                </div>
                                                                <div class="res-card">
                                                                    <label>Percentage</label>
                                                                    <span>
                                                                        <%= percentageStr %>
                                                                    </span>
                                                                    <small
                                                                        style="font-size: 0.725rem; color: var(--text-muted); font-weight: 600;">Overall
                                                                        Marks Percentage</small>
                                                                </div>
                                                                <div class="res-card">
                                                                    <label>Enrolled Subjects</label>
                                                                    <span style="font-size: 1.5rem;">
                                                                        <%= totalEnrolledSubjects %> Subjects
                                                                    </span>
                                                                    <small
                                                                        style="font-size: 0.725rem; color: var(--primary-blue); font-weight: 700;">
                                                                        <%= totalSemesterCredits %> Total Semester
                                                                            Credits
                                                                    </small>
                                                                </div>
                                                                <div class="res-card">
                                                                    <label>CGPA</label>
                                                                    <span>
                                                                        <%= cgpaStr %>
                                                                    </span>
                                                                    <small
                                                                        style="font-size: 0.725rem; color: var(--text-muted); font-weight: 600;">Cumulative
                                                                        Grade Point Average</small>
                                                                </div>
                                                                <div class="res-card">
                                                                    <label>Final Standing</label>
                                                                    <span class="<%= finalStandingClass %>"
                                                                        style="font-size:1.35rem; margin-top:0.2rem;">
                                                                        <%= finalStandingStr %>
                                                                    </span>
                                                                    <small
                                                                        style="font-size: 0.725rem; color: var(--text-muted); font-weight: 600;">Academic
                                                                        Status</small>
                                                                </div>
                                                            </div>

                                                            <!-- Detailed Marksheet Table -->
                                                            <div class="content-card">
                                                                <div class="card-header-row">
                                                                    <h3>Semester Marksheet Report</h3>
                                                                    <button type="button" class="btn-print"
                                                                        onclick="printMarksheet()">
                                                                        <svg width="18" height="18" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <polyline points="6 9 6 2 18 2 18 9" />
                                                                            <path
                                                                                d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2" />
                                                                            <rect x="6" y="14" width="12" height="8" />
                                                                        </svg>
                                                                        Print Marksheet
                                                                    </button>
                                                                </div>
                                                                <div class="table-responsive">
                                                                    <table class="data-table">
                                                                        <thead>
                                                                            <tr>
                                                                                <th>Subject Code</th>
                                                                                <th>Subject Name</th>
                                                                                <th>Credits</th>
                                                                                <th>Internal CCE (/50)</th>
                                                                                <th>External Theory (/50)</th>
                                                                                <th>Total Marks (/100)</th>
                                                                                <th>Grade</th>
                                                                                <th>Result</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <% if (resultRows.isEmpty()) { %>
                                                                                <tr>
                                                                                    <td colspan="8"
                                                                                        style="padding: 2.5rem 1rem; color: var(--text-muted); font-weight: 600;">
                                                                                        No enrolled subjects found
                                                                                        for this student.
                                                                                    </td>
                                                                                </tr>
                                                                                <% } else { for (Map<String, Object> r :
                                                                                    resultRows)
                                                                                    {
                                                                                    boolean hasMarks = (Boolean)
                                                                                    r.get("hasMarks");
                                                                                    String status = (String)
                                                                                    r.get("status");
                                                                                    %>
                                                                                    <tr>
                                                                                        <td><strong>
                                                                                                <%= r.get("code") %>
                                                                                            </strong></td>
                                                                                        <td>
                                                                                            <%= r.get("name") %>
                                                                                        </td>
                                                                                        <td>
                                                                                            <%= r.get("credit") %>
                                                                                        </td>
                                                                                        <td>
                                                                                            <%= r.get("internal") %>
                                                                                        </td>
                                                                                        <td>
                                                                                            <%= r.get("external") %>
                                                                                        </td>
                                                                                        <td><strong>
                                                                                                <%= r.get("total") %>
                                                                                            </strong></td>
                                                                                        <td>
                                                                                            <% if (hasMarks) { %>
                                                                                                <strong>
                                                                                                    <%= r.get("grade")
                                                                                                        %>
                                                                                                </strong>
                                                                                                <% } else { %>
                                                                                                    <span
                                                                                                        style="color: var(--text-muted);">--</span>
                                                                                                    <% } %>
                                                                                        </td>
                                                                                        <td>
                                                                                            <% if
                                                                                                ("PASS".equalsIgnoreCase(status)
                                                                                                || "PASSED"
                                                                                                .equalsIgnoreCase(status))
                                                                                                { %>
                                                                                                <strong
                                                                                                    style="color: var(--success);">Pass</strong>
                                                                                                <% } else if
                                                                                                    ("FAIL".equalsIgnoreCase(status)
                                                                                                    || "FAILED"
                                                                                                    .equalsIgnoreCase(status))
                                                                                                    { %>
                                                                                                    <strong
                                                                                                        style="color: var(--error);">Fail</strong>
                                                                                                    <% } else { %>
                                                                                                        <span
                                                                                                            style="color: var(--text-muted); font-weight: 600;">Pending</span>
                                                                                                        <% } %>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <% } } %>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </div>

                                                            <!-- Official Semester Academic Performance Summary (Bottom of Page) -->
                                                            <div class="academic-summary-card">
                                                                <div class="print-summary-header">SEMESTER ACADEMIC
                                                                    PERFORMANCE SUMMARY</div>
                                                                <table class="print-summary-table">
                                                                    <tr>
                                                                        <td><strong>Total Credits:</strong>
                                                                            <%= totalSemesterCredits %>
                                                                        </td>
                                                                        <td><strong>Total Marks Secured:</strong>
                                                                            <%= totalMarksSecuredStr %>
                                                                        </td>
                                                                        <td><strong>Overall Percentage:</strong>
                                                                            <%= percentageStr %>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><strong>SGPA:</strong>
                                                                            <%= sgpaStr %>
                                                                        </td>
                                                                        <td><strong>CGPA:</strong>
                                                                            <%= cgpaStr %>
                                                                        </td>
                                                                        <td><strong>Final Grade:</strong>
                                                                            <%= finalGradeStr %>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="3"
                                                                            style="text-align: center; background: #F8FAFC; font-weight: 700;">
                                                                            <strong>ACADEMIC RESULT STATUS:</strong>
                                                                            <%= finalStandingStr %>
                                                                        </td>
                                                                    </tr>
                                                                </table>
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

                                                    const printPdfFileName = "<%= pdfFileName %>";
                                                    let defaultPageTitle = document.title;

                                                    function printMarksheet() {
                                                        defaultPageTitle = document.title;
                                                        document.title = printPdfFileName;
                                                        window.print();
                                                        setTimeout(() => {
                                                            document.title = defaultPageTitle;
                                                        }, 1000);
                                                    }

                                                    window.addEventListener('beforeprint', () => {
                                                        defaultPageTitle = document.title;
                                                        document.title = printPdfFileName;
                                                    });

                                                    window.addEventListener('afterprint', () => {
                                                        document.title = defaultPageTitle;
                                                    });
                                                </script>
                                            </body>

                                            </html>