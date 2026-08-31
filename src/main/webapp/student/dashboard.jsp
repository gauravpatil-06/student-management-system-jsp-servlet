<%@ page language="java" contentType="text/html; charset = UTF-8" pageEncoding="UTF-8"
    import="java.util.*, com.student.entity.*, com.student.service.*" %>
    <% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
        response.setHeader("Pragma", "no-cache" ); response.setDateHeader("Expires", 0); if (session==null ||
        session.getAttribute("student")==null) { response.sendRedirect(request.getContextPath() + "/login.jsp" );
        return; } Student currentStudent=(Student) session.getAttribute("student"); String studentFirstName="Student" ;
        String studentInitial="S" ; if (currentStudent !=null) { String rawName=currentStudent.getName(); if
        (rawName==null || rawName.trim().isEmpty()) { rawName=currentStudent.getUsername(); } if (rawName !=null &&
        !rawName.trim().isEmpty()) { studentFirstName=rawName.trim();
        studentInitial=String.valueOf(studentFirstName.charAt(0)).toUpperCase(); } } /* 1. Fetch enrolled subjects for
        the logged-in student */ StudentSubjectAssignmentService assignmentService=new
        StudentSubjectAssignmentService(); List<StudentSubjectAssignment> assignments =
        assignmentService.getAssignmentsByStudent(currentStudent.getId());
        if (assignments == null)
        {
        assignments = new ArrayList<>();
            }
            /* 2. Fetch marks for the logged-in student */
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
                        /* 3. Dynamic calculation and persistence via StudentResultSummaryService */
                        StudentResultSummaryService summaryService = new StudentResultSummaryService();
                        StudentResultSummary summary = summaryService.calculateAndSaveSummary(currentStudent.getId(),
                        currentStudent.getSemester());
                        int totalEnrolledSubjects = assignments.size();
                        double totalSemesterCreditsDouble = 0.0;
                        List<Map<String, Object>> dashboardRows = new ArrayList<>();
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
                                        boolean hasValidMarks = (m != null && (m.getTotalMarks() > 0 || (m.getGrade() !=
                                        null && !m.getGrade().trim().isEmpty() && !m.getGrade().equalsIgnoreCase("N/A"))
                                        || (m.getResultStatus() != null && !m.getResultStatus().trim().isEmpty() &&
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
                                        dashboardRows.add(row);
                                        }
                                        int totalSemesterCredits = (int) totalSemesterCreditsDouble;
                                        String totalMarksSecuredStr;
                                        String percentageStr;
                                        String sgpaStr;
                                        String cgpaStr;
                                        String finalStandingStr;
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
                                        percentageStr = (summary.getPercentage() > 0 || (summary.getMaxMarks() > 0 &&
                                        summary.getTotalMarks() > 0)) ? String.format("%.2f%%", summary.getPercentage())
                                        : "--";
                                        if (summary.getSgpa() > 0)
                                        {
                                        sgpaStr = String.format("%.2f", summary.getSgpa());
                                        }
                                        else
                                        {
                                        sgpaStr = "--";
                                        }
                                        if (summary.getCgpa() > 0)
                                        {
                                        cgpaStr = String.format("%.2f", summary.getCgpa());
                                        }
                                        else
                                        {
                                        cgpaStr = "--";
                                        }
                                        String rawStatus = summary.getResultStatus() != null ?
                                        summary.getResultStatus().trim() : "Pending";
                                        if ("PASS".equalsIgnoreCase(rawStatus) || "PASSED".equalsIgnoreCase(rawStatus))
                                        {
                                        finalStandingStr = "Pass";
                                        }
                                        else if ("FAIL".equalsIgnoreCase(rawStatus) ||
                                        "FAILED".equalsIgnoreCase(rawStatus))
                                        {
                                        finalStandingStr = "Fail";
                                        }
                                        else if (rawStatus.toUpperCase().contains("PARTIAL") ||
                                        rawStatus.toUpperCase().contains("PENDING"))
                                        {
                                        finalStandingStr = "Partial / Pending";
                                        }
                                        else
                                        {
                                        finalStandingStr = "Pending";
                                        }
                                        }
                                        else
                                        {
                                        totalMarksSecuredStr = "-- / --";
                                        percentageStr = "--";
                                        sgpaStr = "--";
                                        cgpaStr = "--";
                                        finalStandingStr = "Pending";
                                        }
                                        /* CCE Attendance & Dynamic JS Data Dictionary for Dashboard CCE Cards */
                                        double dashTotalAttPercentageSum = 0.0;
                                        int dashAttEvaluatedCount = 0;
                                        StringBuilder dashJsDataJsonStr = new StringBuilder("{");
                                        for (int idx = 0; idx < assignments.size(); idx++) { StudentSubjectAssignment
                                            assign=assignments.get(idx); if (assign==null || assign.getSubject()==null)
                                            continue; Subject sub=assign.getSubject(); StudentSubjectMarks
                                            m=marksMap.get(sub.getId()); double c1Exam=m !=null ? m.getCce1Marks() :
                                            0.0; double c1Att=m !=null ? m.getAttendance1Marks() : 0.0; double
                                            c1Tot=c1Exam + c1Att; double c2Exam=m !=null ? m.getCce2Marks() : 0.0;
                                            double c2Att=m !=null ? m.getAttendance2Marks() : 0.0; double c2Tot=c2Exam +
                                            c2Att; double c3Exam=m !=null ? m.getCce3Marks() : 0.0; double c3Att=m
                                            !=null ? m.getAttendance3Marks() : 0.0; double c3Tot=c3Exam + c3Att; double
                                            c4Exam=m !=null ? m.getCce4Marks() : 0.0; double c4Att=m !=null ?
                                            m.getAttendance4Marks() : 0.0; double c4Tot=c4Exam + c4Att; double c5Exam=m
                                            !=null ? m.getCce5Marks() : 0.0; double c5Att=m !=null ?
                                            m.getAttendance5Marks() : 0.0; double c5Tot=c5Exam + c5Att; double
                                            att1Pct=(c1Att / 2.0) * 100.0; double att2Pct=(c2Att / 2.0) * 100.0; double
                                            att3Pct=(c3Att / 2.0) * 100.0; double att4Pct=(c4Att / 2.0) * 100.0; double
                                            att5Pct=(c5Att / 2.0) * 100.0; if (c1Tot> 0 || c1Att > 0)
                                            {
                                            dashTotalAttPercentageSum += att1Pct;
                                            dashAttEvaluatedCount++;
                                            }
                                            if (c2Tot > 0 || c2Att > 0)
                                            {
                                            dashTotalAttPercentageSum += att2Pct;
                                            dashAttEvaluatedCount++;
                                            }
                                            if (c3Tot > 0 || c3Att > 0)
                                            {
                                            dashTotalAttPercentageSum += att3Pct;
                                            dashAttEvaluatedCount++;
                                            }
                                            if (c4Tot > 0 || c4Att > 0)
                                            {
                                            dashTotalAttPercentageSum += att4Pct;
                                            dashAttEvaluatedCount++;
                                            }
                                            if (c5Tot > 0 || c5Att > 0)
                                            {
                                            dashTotalAttPercentageSum += att5Pct;
                                            dashAttEvaluatedCount++;
                                            }
                                            if (idx > 0) dashJsDataJsonStr.append(",");
                                            dashJsDataJsonStr.append("\"").append(sub.getSubjectCode() != null ?
                                            sub.getSubjectCode() : "").append("\": [");
                                            double[][] cceDataArr =
                                            {
                                            {
                                            c1Tot, c1Exam, c1Att, att1Pct
                                            }
                                            ,
                                            {
                                            c2Tot, c2Exam, c2Att, att2Pct
                                            }
                                            ,
                                            {
                                            c3Tot, c3Exam, c3Att, att3Pct
                                            }
                                            ,
                                            {
                                            c4Tot, c4Exam, c4Att, att4Pct
                                            }
                                            ,
                                            {
                                            c5Tot, c5Exam, c5Att, att5Pct
                                            }
                                            }
                                            ;
                                            for (int i = 0; i < 5; i++) { if (i> 0) dashJsDataJsonStr.append(",");
                                                boolean isEval = (m != null && (cceDataArr[i][0] > 0 || cceDataArr[i][1]
                                                > 0 || cceDataArr[i][2] > 0));
                                                String marksStr = isEval ? String.format("%.0f / 10", cceDataArr[i][0])
                                                : "-- / 10";
                                                String examStr = isEval ? String.format("%.0f/8", cceDataArr[i][1]) :
                                                "--/8";
                                                String attStr = isEval ? String.format("%.0f/2", cceDataArr[i][2]) :
                                                "--/2";
                                                String attPctStr = isEval ? String.format("%.0f%%", cceDataArr[i][3]) :
                                                "--%";
                                                String fillStr = isEval ? String.format("%.0f%%", (cceDataArr[i][0] /
                                                10.0) * 100.0) : "0%";
                                                dashJsDataJsonStr.append("{")
                                                .append("\"marks\":\"").append(marksStr).append("\",")
                                                .append("\"exam\":\"").append(examStr).append("\",")
                                                .append("\"att\":\"").append(attStr).append("\",")
                                                .append("\"attPct\":\"").append(attPctStr).append("\",")
                                                .append("\"fill\":\"").append(fillStr).append("\"") .append("}");
                                                }
                                                dashJsDataJsonStr.append("]");
                                                }
                                                dashJsDataJsonStr.append("}");
                                                double dashOverallAttPct = dashAttEvaluatedCount > 0 ?
                                                (dashTotalAttPercentageSum / dashAttEvaluatedCount) : 0.0;
                                                String dashOverallAttStr = dashAttEvaluatedCount > 0 ?
                                                (dashOverallAttPct % 1 == 0 ? String.format("%.0f%%", dashOverallAttPct)
                                                : String.format("%.1f%%", dashOverallAttPct)) : "-- %";
                                                int dashCircleDashArray = dashAttEvaluatedCount > 0 ? (int)
                                                Math.round(dashOverallAttPct) : 0;
                                                %>
                                                <!DOCTYPE html>
                                                <html lang="en">

                                                <head>
                                                    <meta charset="UTF-8">
                                                    <meta name="viewport"
                                                        content="width=device-width, initial-scale=1.0">
                                                    <title>Student Dashboard - Student Management System</title>

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

                                                        .stat-val-pass {
                                                            font-size: 1.25rem;
                                                            color: #16A34A;
                                                        }

                                                        .stat-val-fail {
                                                            font-size: 1.25rem;
                                                            color: #DC2626;
                                                        }

                                                        .stat-val-default {
                                                            font-size: 1.25rem;
                                                            color: #64748B;
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

                                                        /* Bottom Two-Column (Result & Profile) */
                                                        .bottom-grid {
                                                            display: grid;
                                                            grid-template-columns: 1fr 1fr;
                                                            gap: 1.5rem;
                                                        }

                                                        .meta-list {
                                                            display: grid;
                                                            grid-template-columns: 1fr 1fr;
                                                            gap: 1.25rem 1rem;
                                                            margin-bottom: 1.75rem;
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

                                                        .btn-view-result {
                                                            display: inline-flex;
                                                            align-items: center;
                                                            justify-content: center;
                                                            padding: 0.75rem 1.5rem;
                                                            background: var(--primary-blue);
                                                            color: #FFFFFF;
                                                            border-radius: var(--radius-sm);
                                                            font-size: 0.9rem;
                                                            font-weight: 600;
                                                            border: none;
                                                            cursor: pointer;
                                                            transition: var(--transition);
                                                            width: 100%;
                                                        }

                                                        .btn-view-result:hover {
                                                            background: var(--primary-blue-hover);
                                                        }

                                                        /* ==========================================================================
           5. RESPONSIVE BREAKPOINTS
           ========================================================================== */
                                                        @media (max-width: 1100px) {
                                                            .summary-grid {
                                                                grid-template-columns: repeat(2, 1fr);
                                                            }

                                                            .cce-grid {
                                                                grid-template-columns: repeat(3, 1fr);
                                                            }

                                                            .mid-grid,
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

                                                            .cce-grid {
                                                                grid-template-columns: 1fr;
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
                                                            <li class="nav-item active">
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
                                                            <li class="nav-item">
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
                                                                class="logout-link"
                                                                onclick="return openLogoutModal(event)">
                                                                <svg width="20" height="20" viewBox="0 0 24 24"
                                                                    fill="none" stroke="currentColor" stroke-width="2"
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
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <line x1="3" y1="12" x2="21" y2="12" />
                                                                        <line x1="3" y1="6" x2="21" y2="6" />
                                                                        <line x1="3" y1="18" x2="21" y2="18" />
                                                                    </svg>
                                                                </button>
                                                                <h1 class="page-title">Student Dashboard</h1>
                                                            </div>

                                                            <div class="top-right">
                                                                <button class="icon-btn" aria-label="Notifications">
                                                                    <svg width="18" height="18" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <path
                                                                            d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" />
                                                                        <path d="M13.73 21a2 2 0 0 1-3.46 0" />
                                                                    </svg>
                                                                </button>

                                                                <div class="user-profile-badge">
                                                                    <div class="user-avatar">
                                                                        <%= studentInitial %>
                                                                    </div>
                                                                    <div class="user-info-text">
                                                                        <span class="user-name">
                                                                            <%= studentFirstName %>
                                                                        </span>
                                                                        <span class="user-role-label">Student</span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </header>


                                                        <main class="content-area">
                                                            <div class="dashboard-container">

                                                                <!-- Welcome Banner -->
                                                                <section class="welcome-card">
                                                                    <div class="welcome-text">
                                                                        <h2>Welcome, <%= studentFirstName %>!</h2>
                                                                        <p>Welcome to Student Dashboard. View your
                                                                            academic
                                                                            performance, CCE marks, attendance,
                                                                            and result in one place.</p>
                                                                    </div>
                                                                    <div class="welcome-visual">
                                                                        <svg width="34" height="34" viewBox="0 0 24 24"
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2">
                                                                            <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
                                                                            <path d="M6 12v5c3 3 9 3 12 0v-5" />
                                                                        </svg>
                                                                    </div>
                                                                </section>

                                                                <!-- 4. Summary Cards Grid (5 Cards in 1 Row) -->
                                                                <section class="summary-grid"
                                                                    style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem; margin-bottom: 1.5rem;">
                                                                    <div class="stat-card">
                                                                        <div class="stat-top">
                                                                            <span class="stat-title">Enrolled
                                                                                Subjects</span>
                                                                            <div class="stat-icon-wrap">
                                                                                <svg width="18" height="18"
                                                                                    viewBox="0 0 24 24" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="2">
                                                                                    <path
                                                                                        d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                                                    <path
                                                                                        d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                                                </svg>
                                                                            </div>
                                                                        </div>
                                                                        <div class="stat-val">
                                                                            <%= totalEnrolledSubjects %>
                                                                        </div>
                                                                        <span class="stat-desc">Enrolled Courses</span>
                                                                    </div>

                                                                    <div class="stat-card">
                                                                        <div class="stat-top">
                                                                            <span class="stat-title">Percentage</span>
                                                                            <div class="stat-icon-wrap">
                                                                                <svg width="18" height="18"
                                                                                    viewBox="0 0 24 24" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="2">
                                                                                    <line x1="19" y1="5" x2="5"
                                                                                        y2="19" />
                                                                                    <circle cx="6.5" cy="6.5" r="2.5" />
                                                                                    <circle cx="17.5" cy="17.5"
                                                                                        r="2.5" />
                                                                                </svg>
                                                                            </div>
                                                                        </div>
                                                                        <div class="stat-val">
                                                                            <%= percentageStr %>
                                                                        </div>
                                                                        <span class="stat-desc">Semester Marks %</span>
                                                                    </div>

                                                                    <div class="stat-card">
                                                                        <div class="stat-top">
                                                                            <span class="stat-title">SGPA</span>
                                                                            <div class="stat-icon-wrap">
                                                                                <svg width="18" height="18"
                                                                                    viewBox="0 0 24 24" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="2">
                                                                                    <polygon
                                                                                        points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                                                                                </svg>
                                                                            </div>
                                                                        </div>
                                                                        <div class="stat-val">
                                                                            <%= sgpaStr %>
                                                                        </div>
                                                                        <span class="stat-desc">Semester Grade
                                                                            Point</span>
                                                                    </div>

                                                                    <div class="stat-card">
                                                                        <div class="stat-top">
                                                                            <span class="stat-title">CGPA</span>
                                                                            <div class="stat-icon-wrap">
                                                                                <svg width="18" height="18"
                                                                                    viewBox="0 0 24 24" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="2">
                                                                                    <polygon
                                                                                        points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                                                                                </svg>
                                                                            </div>
                                                                        </div>
                                                                        <div class="stat-val">
                                                                            <%= cgpaStr %>
                                                                        </div>
                                                                        <span class="stat-desc">Cumulative Grade
                                                                            Point</span>
                                                                    </div>

                                                                    <div class="stat-card">
                                                                        <div class="stat-top">
                                                                            <span class="stat-title">Result
                                                                                Status</span>
                                                                            <div class="stat-icon-wrap">
                                                                                <svg width="18" height="18"
                                                                                    viewBox="0 0 24 24" fill="none"
                                                                                    stroke="currentColor"
                                                                                    stroke-width="2">
                                                                                    <path
                                                                                        d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                                                                                    <polyline
                                                                                        points="22 4 12 14.01 9 11.01" />
                                                                                </svg>
                                                                            </div>
                                                                        </div>
                                                                        <% String resultColorClass="stat-val-default" ;
                                                                            if
                                                                            ("Pass".equalsIgnoreCase(finalStandingStr))
                                                                            { resultColorClass="stat-val-pass" ; } else
                                                                            if
                                                                            ("Fail".equalsIgnoreCase(finalStandingStr))
                                                                            { resultColorClass="stat-val-fail" ; } %>
                                                                            <div
                                                                                class="stat-val <%= resultColorClass %>">
                                                                                <%= finalStandingStr %>
                                                                            </div>
                                                                            <span class="stat-desc">Academic
                                                                                Result</span>
                                                                    </div>
                                                                </section>

                                                                <!-- 5. CCE Performance and Attendance Section (5 CCE Cards in 1 Row) -->
                                                                <section class="mid-grid"
                                                                    style="display: grid; grid-template-columns: minmax(0, 1fr) 230px; gap: 1.25rem; margin-bottom: 1.5rem;">
                                                                    <!-- CCE Performance Card -->
                                                                    <div class="content-card" id="cceSection"
                                                                        style="padding: 1.15rem 1.25rem;">
                                                                        <div class="card-header-row"
                                                                            style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 0.5rem; margin-bottom: 1rem; padding-bottom: 0.75rem;">
                                                                            <div
                                                                                style="display: flex; align-items: center; gap: 0.5rem; flex-wrap: wrap;">
                                                                                <h3
                                                                                    style="margin: 0; font-size: 1rem; font-weight: 800; color: var(--primary-navy);">
                                                                                    CCE Performance</h3>
                                                                                <select id="dashSubjectSelect"
                                                                                    class="filter-select"
                                                                                    onchange="updateDashCCECards(this.value)"
                                                                                    style="padding: 0.35rem 0.65rem; border-radius: var(--radius-sm); border: 1.5px solid var(--border); font-size: 0.8rem; font-weight: 700; background: #FFFFFF; color: var(--text-main); cursor: pointer; outline: none; transition: var(--transition);">
                                                                                    <% if (assignments !=null &&
                                                                                        !assignments.isEmpty()) { for
                                                                                        (StudentSubjectAssignment assign
                                                                                        : assignments) { if (assign
                                                                                        !=null && assign.getSubject()
                                                                                        !=null) { Subject
                                                                                        s=assign.getSubject(); %>
                                                                                        <option
                                                                                            value="<%= s.getSubjectCode() %>">
                                                                                            <%= s.getSubjectCode() %> -
                                                                                                <%= s.getSubjectName()
                                                                                                    %>
                                                                                        </option>
                                                                                        <% } } } else { %>
                                                                                            <option value="">No Enrolled
                                                                                                Subjects</option>
                                                                                            <% } %>
                                                                                </select>
                                                                            </div>
                                                                            <a href="cce-marks.jsp"
                                                                                style="font-size: 0.8rem; color: var(--primary-blue); font-weight: 700; display: inline-flex; align-items: center; gap: 0.2rem;">
                                                                                View Details &rarr;
                                                                            </a>
                                                                        </div>
                                                                        <div class="cce-grid"
                                                                            style="display: grid; grid-template-columns: repeat(5, minmax(0, 1fr)); gap: 0.5rem;">
                                                                            <div class="cce-item-card"
                                                                                style="background: var(--bg-main); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 0.6rem 0.4rem; text-align: center;">
                                                                                <span class="cce-tag"
                                                                                    style="font-size: 0.675rem; font-weight: 700; color: var(--primary-blue); background: var(--light-blue); padding: 0.15rem 0.35rem; border-radius: 4px;">CCE
                                                                                    1</span>
                                                                                <div class="cce-marks"
                                                                                    id="dash_cce1_marks"
                                                                                    style="font-size: 0.95rem; font-weight: 800; margin: 0.3rem 0 0.15rem 0;">
                                                                                    -- / 10</div>
                                                                                <div id="dash_cce1_breakdown"
                                                                                    style="font-size: 0.65rem; color: var(--text-muted); margin-bottom: 0.15rem; white-space: nowrap;">
                                                                                    Exam: --/8 | Att: --/2</div>
                                                                                <div id="dash_cce1_att"
                                                                                    style="font-size: 0.65rem; color: #10B981; font-weight: 600; margin-bottom: 0.35rem;">
                                                                                    Attendance: --%</div>
                                                                                <div class="cce-progress-bar"
                                                                                    style="height: 5px; background: var(--border); border-radius: 3px; overflow: hidden;">
                                                                                    <div class="cce-progress-fill"
                                                                                        id="dash_cce1_bar"
                                                                                        style="width: 0%; height: 100%; background: var(--primary-blue);">
                                                                                    </div>
                                                                                </div>
                                                                            </div>

                                                                            <div class="cce-item-card"
                                                                                style="background: var(--bg-main); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 0.6rem 0.4rem; text-align: center;">
                                                                                <span class="cce-tag"
                                                                                    style="font-size: 0.675rem; font-weight: 700; color: var(--primary-blue); background: var(--light-blue); padding: 0.15rem 0.35rem; border-radius: 4px;">CCE
                                                                                    2</span>
                                                                                <div class="cce-marks"
                                                                                    id="dash_cce2_marks"
                                                                                    style="font-size: 0.95rem; font-weight: 800; margin: 0.3rem 0 0.15rem 0;">
                                                                                    -- / 10</div>
                                                                                <div id="dash_cce2_breakdown"
                                                                                    style="font-size: 0.65rem; color: var(--text-muted); margin-bottom: 0.15rem; white-space: nowrap;">
                                                                                    Exam: --/8 | Att: --/2</div>
                                                                                <div id="dash_cce2_att"
                                                                                    style="font-size: 0.65rem; color: #10B981; font-weight: 600; margin-bottom: 0.35rem;">
                                                                                    Attendance: --%</div>
                                                                                <div class="cce-progress-bar"
                                                                                    style="height: 5px; background: var(--border); border-radius: 3px; overflow: hidden;">
                                                                                    <div class="cce-progress-fill"
                                                                                        id="dash_cce2_bar"
                                                                                        style="width: 0%; height: 100%; background: var(--primary-blue);">
                                                                                    </div>
                                                                                </div>
                                                                            </div>

                                                                            <div class="cce-item-card"
                                                                                style="background: var(--bg-main); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 0.6rem 0.4rem; text-align: center;">
                                                                                <span class="cce-tag"
                                                                                    style="font-size: 0.675rem; font-weight: 700; color: var(--primary-blue); background: var(--light-blue); padding: 0.15rem 0.35rem; border-radius: 4px;">CCE
                                                                                    3</span>
                                                                                <div class="cce-marks"
                                                                                    id="dash_cce3_marks"
                                                                                    style="font-size: 0.95rem; font-weight: 800; margin: 0.3rem 0 0.15rem 0;">
                                                                                    -- / 10</div>
                                                                                <div id="dash_cce3_breakdown"
                                                                                    style="font-size: 0.65rem; color: var(--text-muted); margin-bottom: 0.15rem; white-space: nowrap;">
                                                                                    Exam: --/8 | Att: --/2</div>
                                                                                <div id="dash_cce3_att"
                                                                                    style="font-size: 0.65rem; color: #10B981; font-weight: 600; margin-bottom: 0.35rem;">
                                                                                    Attendance: --%</div>
                                                                                <div class="cce-progress-bar"
                                                                                    style="height: 5px; background: var(--border); border-radius: 3px; overflow: hidden;">
                                                                                    <div class="cce-progress-fill"
                                                                                        id="dash_cce3_bar"
                                                                                        style="width: 0%; height: 100%; background: var(--primary-blue);">
                                                                                    </div>
                                                                                </div>
                                                                            </div>

                                                                            <div class="cce-item-card"
                                                                                style="background: var(--bg-main); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 0.6rem 0.4rem; text-align: center;">
                                                                                <span class="cce-tag"
                                                                                    style="font-size: 0.675rem; font-weight: 700; color: var(--primary-blue); background: var(--light-blue); padding: 0.15rem 0.35rem; border-radius: 4px;">CCE
                                                                                    4</span>
                                                                                <div class="cce-marks"
                                                                                    id="dash_cce4_marks"
                                                                                    style="font-size: 0.95rem; font-weight: 800; margin: 0.3rem 0 0.15rem 0;">
                                                                                    -- / 10</div>
                                                                                <div id="dash_cce4_breakdown"
                                                                                    style="font-size: 0.65rem; color: var(--text-muted); margin-bottom: 0.15rem; white-space: nowrap;">
                                                                                    Exam: --/8 | Att: --/2</div>
                                                                                <div id="dash_cce4_att"
                                                                                    style="font-size: 0.65rem; color: #10B981; font-weight: 600; margin-bottom: 0.35rem;">
                                                                                    Attendance: --%</div>
                                                                                <div class="cce-progress-bar"
                                                                                    style="height: 5px; background: var(--border); border-radius: 3px; overflow: hidden;">
                                                                                    <div class="cce-progress-fill"
                                                                                        id="dash_cce4_bar"
                                                                                        style="width: 0%; height: 100%; background: var(--primary-blue);">
                                                                                    </div>
                                                                                </div>
                                                                            </div>

                                                                            <div class="cce-item-card"
                                                                                style="background: var(--bg-main); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 0.6rem 0.4rem; text-align: center;">
                                                                                <span class="cce-tag"
                                                                                    style="font-size: 0.675rem; font-weight: 700; color: var(--primary-blue); background: var(--light-blue); padding: 0.15rem 0.35rem; border-radius: 4px;">CCE
                                                                                    5</span>
                                                                                <div class="cce-marks"
                                                                                    id="dash_cce5_marks"
                                                                                    style="font-size: 0.95rem; font-weight: 800; margin: 0.3rem 0 0.15rem 0;">
                                                                                    -- / 10</div>
                                                                                <div id="dash_cce5_breakdown"
                                                                                    style="font-size: 0.65rem; color: var(--text-muted); margin-bottom: 0.15rem; white-space: nowrap;">
                                                                                    Exam: --/8 | Att: --/2</div>
                                                                                <div id="dash_cce5_att"
                                                                                    style="font-size: 0.65rem; color: #10B981; font-weight: 600; margin-bottom: 0.35rem;">
                                                                                    Attendance: --%</div>
                                                                                <div class="cce-progress-bar"
                                                                                    style="height: 5px; background: var(--border); border-radius: 3px; overflow: hidden;">
                                                                                    <div class="cce-progress-fill"
                                                                                        id="dash_cce5_bar"
                                                                                        style="width: 0%; height: 100%; background: var(--primary-blue);">
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>

                                                                    <!-- CCE Attendance Card (Compact 230px Width) -->
                                                                    <div class="content-card" id="attendanceSection"
                                                                        style="padding: 1.15rem 1rem; display: flex; flex-direction: column; justify-content: space-between;">
                                                                        <div class="card-header-row"
                                                                            style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 0.75rem; padding-bottom: 0.5rem;">
                                                                            <h3
                                                                                style="margin: 0; font-size: 0.95rem; font-weight: 800; color: var(--primary-navy);">
                                                                                Attendance Ratio</h3>
                                                                            <a href="cce-marks.jsp"
                                                                                style="font-size: 0.775rem; color: var(--primary-blue); font-weight: 700;">View
                                                                                Marks &rarr;</a>
                                                                        </div>
                                                                        <div class="attendance-center"
                                                                            style="display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 0.5rem 0; text-align: center;">
                                                                            <div class="circular-progress-wrap"
                                                                                style="position: relative; width: 85px; height: 85px; display: flex; align-items: center; justify-content: center; margin-bottom: 0.4rem;">
                                                                                <svg width="85" height="85"
                                                                                    viewBox="0 0 44 44"
                                                                                    style="width: 100%; height: 100%; transform: rotate(-90deg); overflow: visible;">
                                                                                    <circle cx="22" cy="22" r="15.9155"
                                                                                        fill="none" stroke="#E2E8F0"
                                                                                        stroke-width="3.5" />
                                                                                    <circle id="dashAttCircleFill"
                                                                                        cx="22" cy="22" r="15.9155"
                                                                                        fill="none" stroke="#10B981"
                                                                                        stroke-width="3.5"
                                                                                        stroke-dasharray="<%= dashCircleDashArray %>, 100"
                                                                                        stroke-linecap="round" />
                                                                                </svg>
                                                                                <div class="circle-val"
                                                                                    style="position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; font-size: 1rem; font-weight: 800; color: var(--primary-navy); text-align: center; white-space: nowrap;">
                                                                                    <%= dashOverallAttStr %>
                                                                                </div>
                                                                            </div>
                                                                            <span class="stat-desc"
                                                                                style="font-size: 0.75rem; font-weight: 600; color: var(--text-muted);">Overall
                                                                                CCE Attendance Ratio</span>
                                                                        </div>
                                                                    </div>
                                                                </section>

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

                                                        // Dynamic Dashboard CCE Data from DB
                                                        const dashSubjectCCEData = JSON.parse('<%= dashJsDataJsonStr.toString() %>');

                                                        function updateDashCCECards(code) {
                                                            if (!code || !dashSubjectCCEData[code]) {
                                                                for (let i = 0; i < 5; i++) {
                                                                    const num = i + 1;
                                                                    document.getElementById('dash_cce' + num + '_marks').innerText = '-- / 10';
                                                                    document.getElementById('dash_cce' + num + '_breakdown').innerText = 'Exam: --/8 | Att: --/2';
                                                                    document.getElementById('dash_cce' + num + '_att').innerText = 'Attendance: --%';
                                                                    document.getElementById('dash_cce' + num + '_att').style.color = 'var(--text-muted)';
                                                                    document.getElementById('dash_cce' + num + '_bar').style.width = '0%';
                                                                }
                                                                return;
                                                            }
                                                            const data = dashSubjectCCEData[code];
                                                            for (let i = 0; i < 5; i++) {
                                                                const num = i + 1;
                                                                document.getElementById('dash_cce' + num + '_marks').innerText = data[i].marks;
                                                                document.getElementById('dash_cce' + num + '_breakdown').innerText = 'Exam: ' + data[i].exam + ' | Att: ' + data[i].att;
                                                                document.getElementById('dash_cce' + num + '_att').innerText = 'Attendance: ' + data[i].attPct;
                                                                document.getElementById('dash_cce' + num + '_att').style.color = (data[i].attPct !== '--%' && data[i].attPct !== '0%') ? '#10B981' : 'var(--text-muted)';
                                                                document.getElementById('dash_cce' + num + '_bar').style.width = data[i].fill;
                                                            }
                                                        }

                                                        document.addEventListener('DOMContentLoaded', function () {
                                                            const sel = document.getElementById('dashSubjectSelect');
                                                            if (sel && sel.value) {
                                                                updateDashCCECards(sel.value);
                                                            }
                                                        });

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