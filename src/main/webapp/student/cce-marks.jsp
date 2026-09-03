<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.util.*, com.student.entity.*, com.student.service.*" %>
    <% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
        response.setHeader("Pragma", "no-cache" ); response.setDateHeader("Expires", 0); if (session==null ||
        session.getAttribute("student")==null) { response.sendRedirect(request.getContextPath() + "/login.jsp" );
        return; } Student currentStudent=(Student) session.getAttribute("student"); String studentFirstName="Student" ;
        String studentInitial="S" ; if (currentStudent !=null) { String rawName=currentStudent.getName(); if
        (rawName==null || rawName.trim().isEmpty()) { rawName=currentStudent.getUsername(); } if (rawName !=null &&
        !rawName.trim().isEmpty()) { studentFirstName=rawName.trim();
        studentInitial=String.valueOf(studentFirstName.charAt(0)).toUpperCase(); } } // 1. Fetch Enrolled Subjects for logged-in student
        StudentSubjectAssignmentService assignmentService=new StudentSubjectAssignmentService();
        List<StudentSubjectAssignment> assignments = assignmentService.getAssignmentsByStudent(currentStudent.getId());
        if (assignments == null)
        {
        assignments = new ArrayList<>();
            }

            // 2. Fetch CCE Marks for logged-in student
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

                        // 3. Overall CCE Attendance & Data Structure for Table and JS cards
                        double totalAttPercentageSum = 0.0;
                        int attEvaluatedCount = 0;
                        List<Subject> enrolledSubjects = new ArrayList<>();
                                List<Map<String, Object>> subjectBreakdownList = new ArrayList<>();

                                        // JS dictionary string building for dynamic subject card switching
                                        StringBuilder jsDataJsonStr = new StringBuilder("{");
                                        for (int idx = 0; idx < assignments.size(); idx++) { StudentSubjectAssignment
                                            assign=assignments.get(idx); if (assign==null || assign.getSubject()==null)
                                            { continue; } Subject sub=assign.getSubject(); enrolledSubjects.add(sub);
                                            StudentSubjectMarks m=marksMap.get(sub.getId()); double c1Exam=(m !=null) ?
                                            m.getCce1Marks() : 0.0; double c1Att=(m !=null) ? m.getAttendance1Marks() :
                                            0.0; double c1Tot=c1Exam + c1Att; double c2Exam=(m !=null) ?
                                            m.getCce2Marks() : 0.0; double c2Att=(m !=null) ? m.getAttendance2Marks() :
                                            0.0; double c2Tot=c2Exam + c2Att; double c3Exam=(m !=null) ?
                                            m.getCce3Marks() : 0.0; double c3Att=(m !=null) ? m.getAttendance3Marks() :
                                            0.0; double c3Tot=c3Exam + c3Att; double c4Exam=(m !=null) ?
                                            m.getCce4Marks() : 0.0; double c4Att=(m !=null) ? m.getAttendance4Marks() :
                                            0.0; double c4Tot=c4Exam + c4Att; double c5Exam=(m !=null) ?
                                            m.getCce5Marks() : 0.0; double c5Att=(m !=null) ? m.getAttendance5Marks() :
                                            0.0; double c5Tot=c5Exam + c5Att; double internalTot=(m !=null) ?
                                            m.getInternalMarks() : (c1Tot + c2Tot + c3Tot + c4Tot + c5Tot); boolean
                                            hasAnyMarks=(m !=null && (c1Tot> 0 || c2Tot > 0 || c3Tot > 0 || c4Tot > 0 ||
                                            c5Tot > 0 || internalTot > 0));

                                            // Attendance percentages per CCE (out of 2 marks = 100%)
                                            double att1Pct = (c1Att / 2.0) * 100.0;
                                            double att2Pct = (c2Att / 2.0) * 100.0;
                                            double att3Pct = (c3Att / 2.0) * 100.0;
                                            double att4Pct = (c4Att / 2.0) * 100.0;
                                            double att5Pct = (c5Att / 2.0) * 100.0;

                                            if (c1Tot > 0 || c1Att > 0)
                                            {
                                            totalAttPercentageSum += att1Pct;
                                            attEvaluatedCount++;
                                            }
                                            if (c2Tot > 0 || c2Att > 0)
                                            {
                                            totalAttPercentageSum += att2Pct;
                                            attEvaluatedCount++;
                                            }
                                            if (c3Tot > 0 || c3Att > 0)
                                            {
                                            totalAttPercentageSum += att3Pct;
                                            attEvaluatedCount++;
                                            }
                                            if (c4Tot > 0 || c4Att > 0)
                                            {
                                            totalAttPercentageSum += att4Pct;
                                            attEvaluatedCount++;
                                            }
                                            if (c5Tot > 0 || c5Att > 0)
                                            {
                                            totalAttPercentageSum += att5Pct;
                                            attEvaluatedCount++;
                                            }

                                            Map<String, Object> subRow = new HashMap<>();
                                                    subRow.put("code", sub.getSubjectCode() != null ?
                                                    sub.getSubjectCode() : "--");
                                                    subRow.put("name", sub.getSubjectName() != null ?
                                                    sub.getSubjectName() : "--");
                                                    subRow.put("c1", (m != null && (c1Tot > 0 || c1Exam > 0 || c1Att >
                                                    0)) ? String.format("%.0f", c1Tot) : "--");
                                                    subRow.put("c2", (m != null && (c2Tot > 0 || c2Exam > 0 || c2Att >
                                                    0)) ? String.format("%.0f", c2Tot) : "--");
                                                    subRow.put("c3", (m != null && (c3Tot > 0 || c3Exam > 0 || c3Att >
                                                    0)) ? String.format("%.0f", c3Tot) : "--");
                                                    subRow.put("c4", (m != null && (c4Tot > 0 || c4Exam > 0 || c4Att >
                                                    0)) ? String.format("%.0f", c4Tot) : "--");
                                                    subRow.put("c5", (m != null && (c5Tot > 0 || c5Exam > 0 || c5Att >
                                                    0)) ? String.format("%.0f", c5Tot) : "--");
                                                    subRow.put("internalTotal", hasAnyMarks ? String.format("%.0f / 50",
                                                    internalTot) : "-- / 50");
                                                    subRow.put("status", hasAnyMarks ? "Completed" : "Pending");
                                                    subjectBreakdownList.add(subRow);

                                                    // Build JS dictionary for dropdown changes
                                                    if (idx > 0)
                                                    {
                                                    jsDataJsonStr.append(",");
                                                    }

                                                    jsDataJsonStr.append("\"").append(sub.getSubjectCode() != null ?
                                                    sub.getSubjectCode() : "").append("\": [");
                                                    double[][] cceDataArr = {
                                                    { c1Tot, c1Exam, c1Att, att1Pct },
                                                    { c2Tot, c2Exam, c2Att, att2Pct },
                                                    { c3Tot, c3Exam, c3Att, att3Pct },
                                                    { c4Tot, c4Exam, c4Att, att4Pct },
                                                    { c5Tot, c5Exam, c5Att, att5Pct }
                                                    };

                                                    for (int i = 0; i < 5; i++) { if (i> 0)
                                                        {
                                                        jsDataJsonStr.append(",");
                                                        }
                                                        boolean isEval = (m != null && (cceDataArr[i][0] > 0 ||
                                                        cceDataArr[i][1] > 0 || cceDataArr[i][2] > 0));
                                                        String marksStr = isEval ? String.format("%.0f / 10",
                                                        cceDataArr[i][0]) : "-- / 10";
                                                        String examStr = isEval ? String.format("%.0f/8",
                                                        cceDataArr[i][1]) : "--/8";
                                                        String attStr = isEval ? String.format("%.0f/2",
                                                        cceDataArr[i][2]) : "--/2";
                                                        String attPctStr = isEval ? String.format("%.0f%%",
                                                        cceDataArr[i][3]) : "--%";
                                                        String fillStr = isEval ? String.format("%.0f%%",
                                                        (cceDataArr[i][0] / 10.0) * 100.0) : "0%";

                                                        jsDataJsonStr.append("{")
                                                        .append("\"marks\":\"").append(marksStr).append("\",")
                                                        .append("\"exam\":\"").append(examStr).append("\",")
                                                        .append("\"att\":\"").append(attStr).append("\",")
                                                        .append("\"attPct\":\"").append(attPctStr).append("\",")
                                                        .append("\"fill\":\"").append(fillStr).append("\"")
                                                        .append("}");
                                                        }
                                                        jsDataJsonStr.append("]");
                                                        }
                                                        jsDataJsonStr.append("}");

                                                        double overallAttPct = (attEvaluatedCount > 0) ?
                                                        (totalAttPercentageSum / attEvaluatedCount) : 0.0;
                                                        String overallAttStr = (attEvaluatedCount > 0) ? ((overallAttPct
                                                        % 1 == 0) ? String.format("%.0f%%", overallAttPct) :
                                                        String.format("%.1f%%", overallAttPct)) : "-- %";
                                                        int circleDashArray = (attEvaluatedCount > 0) ? (int)
                                                        Math.round(overallAttPct) : 0;
                                                        %>
                                                        <!DOCTYPE html>
                                                        <html lang="en">

                                                        <head>
                                                            <meta charset="UTF-8">
                                                            <meta name="viewport"
                                                                content="width=device-width, initial-scale=1.0">
                                                            <title>My CCE Marks - Student Management System</title>

                                                            <link rel="preconnect" href="https://fonts.googleapis.com">
                                                            <link rel="preconnect" href="https://fonts.gstatic.com"
                                                                crossorigin>
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
                                                                    flex-shrink: 0;
                                                                }

                                                                .nav-item.active a,
                                                                .nav-item a:hover {
                                                                    color: #FFFFFF;
                                                                    background: rgba(255, 255, 255, 0.08);
                                                                }

                                                                .nav-item.active a {
                                                                    background: var(--primary-blue);
                                                                    color: #FFFFFF;
                                                                    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
                                                                }

                                                                .sidebar-footer {
                                                                    padding: 1.25rem 1rem;
                                                                    border-top: 1px solid rgba(255, 255, 255, 0.08);
                                                                }

                                                                .logout-link {
                                                                    display: flex;
                                                                    align-items: center;
                                                                    gap: 0.75rem;
                                                                    padding: 0.75rem 1rem;
                                                                    color: #EF4444;
                                                                    font-weight: 600;
                                                                    font-size: 0.9rem;
                                                                    border-radius: var(--radius-sm);
                                                                    transition: var(--transition);
                                                                }

                                                                .logout-link:hover {
                                                                    background: rgba(239, 68, 68, 0.1);
                                                                }

                                                                /* Main Content Layout */
                                                                .main-wrapper {
                                                                    margin-left: var(--sidebar-width);
                                                                    flex: 1;
                                                                    display: flex;
                                                                    flex-direction: column;
                                                                    min-width: 0;
                                                                    background: var(--bg-main);
                                                                }

                                                                /* Top Navbar */
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
                                                                    z-index: 99;
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
                                                                    padding: 0.4rem;
                                                                    border-radius: var(--radius-sm);
                                                                }

                                                                .page-title {
                                                                    font-size: 1.35rem;
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
                                                                    background: var(--bg-main);
                                                                    border: 1px solid var(--border);
                                                                    color: var(--text-muted);
                                                                    width: 40px;
                                                                    height: 40px;
                                                                    border-radius: 50%;
                                                                    display: flex;
                                                                    align-items: center;
                                                                    justify-content: center;
                                                                    cursor: pointer;
                                                                    transition: var(--transition);
                                                                }

                                                                .icon-btn:hover {
                                                                    background: var(--light-blue);
                                                                    color: var(--primary-blue);
                                                                    border-color: var(--primary-blue);
                                                                }

                                                                .user-profile-badge {
                                                                    display: flex;
                                                                    align-items: center;
                                                                    gap: 0.75rem;
                                                                    padding: 0.35rem 0.75rem 0.35rem 0.35rem;
                                                                    border-radius: 30px;
                                                                    background: var(--bg-main);
                                                                    border: 1px solid var(--border);
                                                                }

                                                                .user-avatar {
                                                                    width: 34px;
                                                                    height: 34px;
                                                                    border-radius: 50%;
                                                                    background: var(--primary-blue);
                                                                    color: #FFFFFF;
                                                                    font-weight: 700;
                                                                    font-size: 0.9rem;
                                                                    display: flex;
                                                                    align-items: center;
                                                                    justify-content: center;
                                                                }

                                                                .user-info-text {
                                                                    display: flex;
                                                                    flex-direction: column;
                                                                    padding-right: 0.5rem;
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

                                                                /* CCE Cards Grid */
                                                                .cce-grid {
                                                                    display: grid;
                                                                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                                                                    gap: 1.25rem;
                                                                }

                                                                .cce-card {
                                                                    background: var(--card-bg);
                                                                    border-radius: var(--radius-md);
                                                                    padding: 1.5rem;
                                                                    border: 1px solid var(--border);
                                                                    box-shadow: var(--shadow-sm);
                                                                    transition: var(--transition);
                                                                    display: flex;
                                                                    flex-direction: column;
                                                                    gap: 0.75rem;
                                                                }

                                                                .cce-card:hover {
                                                                    box-shadow: var(--shadow-md);
                                                                    transform: translateY(-2px);
                                                                }

                                                                .cce-tag {
                                                                    display: inline-block;
                                                                    padding: 0.25rem 0.75rem;
                                                                    background: var(--light-blue);
                                                                    color: var(--primary-blue);
                                                                    border-radius: 20px;
                                                                    font-size: 0.8rem;
                                                                    font-weight: 700;
                                                                    width: fit-content;
                                                                }

                                                                .cce-marks {
                                                                    font-size: 1.75rem;
                                                                    font-weight: 800;
                                                                    color: var(--text-main);
                                                                }

                                                                .cce-bar-bg {
                                                                    height: 8px;
                                                                    background: var(--border);
                                                                    border-radius: 4px;
                                                                    overflow: hidden;
                                                                }

                                                                .cce-bar-fill {
                                                                    height: 100%;
                                                                    background: var(--primary-blue);
                                                                    border-radius: 4px;
                                                                    transition: width 0.4s ease;
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
                                                                    font-weight: 700;
                                                                    color: var(--text-main);
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
                                                                    letter-spacing: 0.05em;
                                                                    border-bottom: 1px solid var(--border);
                                                                }

                                                                .data-table td {
                                                                    padding: 1rem;
                                                                    border-bottom: 1px solid var(--border);
                                                                    color: var(--text-main);
                                                                    font-weight: 500;
                                                                }

                                                                .data-table tr:hover td {
                                                                    background: var(--light-blue);
                                                                }

                                                                .status-badge {
                                                                    display: inline-flex;
                                                                    align-items: center;
                                                                    padding: 0.3rem 0.75rem;
                                                                    border-radius: 20px;
                                                                    font-size: 0.775rem;
                                                                    font-weight: 700;
                                                                }

                                                                .status-badge.completed {
                                                                    background: rgba(22, 163, 74, 0.1);
                                                                    color: var(--success);
                                                                }

                                                                .status-badge.pending {
                                                                    background: #F1F5F9;
                                                                    color: var(--text-muted);
                                                                }

                                                                .sidebar-overlay {
                                                                    display: none;
                                                                    position: fixed;
                                                                    top: 0;
                                                                    left: 0;
                                                                    right: 0;
                                                                    bottom: 0;
                                                                    background: rgba(15, 23, 42, 0.4);
                                                                    backdrop-filter: blur(4px);
                                                                    z-index: 999;
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
                                                                    <svg viewBox="0 0 24 24" fill="none"
                                                                        stroke="currentColor" stroke-width="2.2"
                                                                        stroke-linecap="round" stroke-linejoin="round">
                                                                        <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
                                                                        <path d="M6 12v5c3 3 9 3 12 0v-5" />
                                                                    </svg>
                                                                    <div class="brand-text">
                                                                        <span class="brand-line1">Student Portal</span>
                                                                        <span class="brand-line2">Academic System</span>
                                                                    </div>
                                                                </div>

                                                                <ul class="sidebar-menu">
                                                                    <li class="nav-item">
                                                                        <a href="dashboard.jsp">
                                                                            <svg viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor">
                                                                                <rect x="3" y="3" width="7"
                                                                                    height="7" />
                                                                                <rect x="14" y="3" width="7"
                                                                                    height="7" />
                                                                                <rect x="14" y="14" width="7"
                                                                                    height="7" />
                                                                                <rect x="3" y="14" width="7"
                                                                                    height="7" />
                                                                            </svg>
                                                                            <span>Dashboard</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="subjects.jsp">
                                                                            <svg viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor">
                                                                                <path
                                                                                    d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                                                <path
                                                                                    d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                                            </svg>
                                                                            <span>My Subjects</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="nav-item active">
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
                                                                            fill="none" stroke="currentColor"
                                                                            stroke-width="2" stroke-linecap="round"
                                                                            stroke-linejoin="round">
                                                                            <path
                                                                                d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
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
                                                                        <button class="menu-toggle-btn"
                                                                            id="menuToggleBtn" aria-label="Toggle menu">
                                                                            <svg width="24" height="24"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
                                                                                <line x1="3" y1="12" x2="21" y2="12" />
                                                                                <line x1="3" y1="6" x2="21" y2="6" />
                                                                                <line x1="3" y1="18" x2="21" y2="18" />
                                                                            </svg>
                                                                        </button>
                                                                        <h1 class="page-title">My CCE Marks</h1>
                                                                    </div>

                                                                    <div class="top-right">
                                                                        <button class="icon-btn"
                                                                            aria-label="Notifications">
                                                                            <svg width="18" height="18"
                                                                                viewBox="0 0 24 24" fill="none"
                                                                                stroke="currentColor" stroke-width="2">
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
                                                                                <span
                                                                                    class="user-role-label">Student</span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </header>

                                                                <main class="content-area">
                                                                    <div class="container">
                                                                        <!-- Overall Attendance Circle Header Card -->
                                                                        <div class="content-card"
                                                                            style="padding: 1.5rem 1.75rem; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 1.5rem; background: linear-gradient(135deg, rgba(30, 58, 95, 0.03) 0%, rgba(37, 99, 235, 0.08) 100%); border: 1px solid var(--border); border-radius: var(--radius-lg);">
                                                                            <div>
                                                                                <h2
                                                                                    style="font-size: 1.3rem; font-weight: 800; color: var(--primary-navy); margin: 0 0 0.2rem 0;">
                                                                                    Overall CCE Attendance
                                                                                </h2>
                                                                                <p
                                                                                    style="font-size: 0.825rem; color: var(--text-muted); margin: 0;">
                                                                                    Verified CCE attendance ratio
                                                                                    calculated across all evaluated
                                                                                    sessions
                                                                                </p>
                                                                            </div>
                                                                            <div
                                                                                style="display: flex; align-items: center; gap: 1rem;">
                                                                                <div
                                                                                    style="position: relative; width: 90px; height: 90px; display: flex; align-items: center; justify-content: center;">
                                                                                    <svg width="90" height="90"
                                                                                        viewBox="0 0 44 44"
                                                                                        style="transform: rotate(-90deg); filter: drop-shadow(0 2px 4px rgba(0,0,0,0.05)); overflow: visible;">
                                                                                        <circle cx="22" cy="22"
                                                                                            r="15.9155" fill="none"
                                                                                            stroke="#E2E8F0"
                                                                                            stroke-width="3.5" />
                                                                                        <circle id="attCircleFill"
                                                                                            cx="22" cy="22" r="15.9155"
                                                                                            fill="none" stroke="#10B981"
                                                                                            stroke-width="3.5"
                                                                                            stroke-dasharray="<%= circleDashArray %>, 100"
                                                                                            stroke-linecap="round" />
                                                                                    </svg>
                                                                                    <div style="position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; font-size: 1.05rem; font-weight: 800; color: var(--primary-navy); text-align: center; white-space: nowrap;"
                                                                                        id="overallAttValue">
                                                                                        <%= overallAttStr %>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>

                                                                        <!-- Subject Filter Card -->
                                                                        <div class="content-card"
                                                                            style="padding: 1.25rem 1.75rem;">
                                                                            <div
                                                                                style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 1rem;">
                                                                                <div>
                                                                                    <h3
                                                                                        style="font-size: 1.1rem; font-weight: 800; color: var(--primary-navy); margin-bottom: 0.2rem; display: flex; align-items: center; gap: 0.5rem;">
                                                                                        <svg width="20" height="20"
                                                                                            viewBox="0 0 24 24"
                                                                                            fill="none"
                                                                                            stroke="currentColor"
                                                                                            stroke-width="2">
                                                                                            <path
                                                                                                d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                                                            <path
                                                                                                d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                                                        </svg>
                                                                                        Select Subject for CCE Breakdown
                                                                                    </h3>
                                                                                    <p
                                                                                        style="font-size: 0.8rem; color: var(--text-muted); margin: 0;">
                                                                                        Filter CCE 1-5 evaluation cards
                                                                                        by enrolled subject
                                                                                    </p>
                                                                                </div>
                                                                                <div>
                                                                                    <select id="subjectFilterSelect"
                                                                                        class="filter-select"
                                                                                        onchange="updateSubjectCCECards(this.value)"
                                                                                        style="padding: 0.6rem 1rem; border-radius: var(--radius-sm); border: 1.5px solid var(--border); font-weight: 700; background: #FFFFFF; color: var(--text-main); cursor: pointer; font-size: 0.875rem; outline: none;">
                                                                                        <% if
                                                                                            (enrolledSubjects.isEmpty())
                                                                                            { %>
                                                                                            <option value="">No Subjects
                                                                                                Enrolled</option>
                                                                                            <% } else { for (int i=0; i
                                                                                                <
                                                                                                enrolledSubjects.size();
                                                                                                i++) { Subject
                                                                                                sub=enrolledSubjects.get(i);
                                                                                                %>
                                                                                                <option
                                                                                                    value="<%= sub.getSubjectCode() %>"
                                                                                                    <%=i==0 ? "selected"
                                                                                                    : "" %>>
                                                                                                    <%= sub.getSubjectCode()
                                                                                                        %> - <%=
                                                                                                            sub.getSubjectName()
                                                                                                            %>
                                                                                                </option>
                                                                                                <% } } %>
                                                                                    </select>
                                                                                </div>
                                                                            </div>
                                                                        </div>

                                                                        <!-- CCE 1-5 Performance Cards Grid -->
                                                                        <div class="cce-grid" id="cceSummaryGrid">
                                                                            <div class="cce-card">
                                                                                <span class="cce-tag">CCE 1</span>
                                                                                <div class="cce-marks" id="cce1_marks">
                                                                                    -- / 10</div>
                                                                                <div class="cce-breakdown"
                                                                                    id="cce1_breakdown">Exam: --/8 |
                                                                                    Att: --/2</div>
                                                                                <div class="cce-att-pct" id="cce1_att"
                                                                                    style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600; margin-top: 4px;">
                                                                                    Attendance: --%
                                                                                </div>
                                                                                <div class="cce-bar-bg">
                                                                                    <div class="cce-bar-fill"
                                                                                        id="cce1_bar"
                                                                                        style="width: 0%;"></div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="cce-card">
                                                                                <span class="cce-tag">CCE 2</span>
                                                                                <div class="cce-marks" id="cce2_marks">
                                                                                    -- / 10</div>
                                                                                <div class="cce-breakdown"
                                                                                    id="cce2_breakdown">Exam: --/8 |
                                                                                    Att: --/2</div>
                                                                                <div class="cce-att-pct" id="cce2_att"
                                                                                    style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600; margin-top: 4px;">
                                                                                    Attendance: --%
                                                                                </div>
                                                                                <div class="cce-bar-bg">
                                                                                    <div class="cce-bar-fill"
                                                                                        id="cce2_bar"
                                                                                        style="width: 0%;"></div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="cce-card">
                                                                                <span class="cce-tag">CCE 3</span>
                                                                                <div class="cce-marks" id="cce3_marks">
                                                                                    -- / 10</div>
                                                                                <div class="cce-breakdown"
                                                                                    id="cce3_breakdown">Exam: --/8 |
                                                                                    Att: --/2</div>
                                                                                <div class="cce-att-pct" id="cce3_att"
                                                                                    style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600; margin-top: 4px;">
                                                                                    Attendance: --%
                                                                                </div>
                                                                                <div class="cce-bar-bg">
                                                                                    <div class="cce-bar-fill"
                                                                                        id="cce3_bar"
                                                                                        style="width: 0%;"></div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="cce-card">
                                                                                <span class="cce-tag">CCE 4</span>
                                                                                <div class="cce-marks" id="cce4_marks">
                                                                                    -- / 10</div>
                                                                                <div class="cce-breakdown"
                                                                                    id="cce4_breakdown">Exam: --/8 |
                                                                                    Att: --/2</div>
                                                                                <div class="cce-att-pct" id="cce4_att"
                                                                                    style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600; margin-top: 4px;">
                                                                                    Attendance: --%
                                                                                </div>
                                                                                <div class="cce-bar-bg">
                                                                                    <div class="cce-bar-fill"
                                                                                        id="cce4_bar"
                                                                                        style="width: 0%;"></div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="cce-card">
                                                                                <span class="cce-tag">CCE 5</span>
                                                                                <div class="cce-marks" id="cce5_marks">
                                                                                    -- / 10</div>
                                                                                <div class="cce-breakdown"
                                                                                    id="cce5_breakdown">Exam: --/8 |
                                                                                    Att: --/2</div>
                                                                                <div class="cce-att-pct" id="cce5_att"
                                                                                    style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600; margin-top: 4px;">
                                                                                    Attendance: --%
                                                                                </div>
                                                                                <div class="cce-bar-bg">
                                                                                    <div class="cce-bar-fill"
                                                                                        id="cce5_bar"
                                                                                        style="width: 0%;"></div>
                                                                                </div>
                                                                            </div>
                                                                        </div>

                                                                        <!-- Subject Wise Breakdown Table Card -->
                                                                        <div class="content-card">
                                                                            <div class="card-header-row">
                                                                                <div>
                                                                                    <h3>Subject-Wise CCE Marks Breakdown
                                                                                    </h3>
                                                                                    <p
                                                                                        style="font-size: 0.8rem; color: var(--text-muted); margin-top: 0.2rem;">
                                                                                        Each CCE = 10 Marks (Exam /8 +
                                                                                        Attendance /2). Total Internal =
                                                                                        50 Marks.
                                                                                    </p>
                                                                                </div>
                                                                            </div>
                                                                            <div class="table-responsive">
                                                                                <table class="data-table">
                                                                                    <thead>
                                                                                        <tr>
                                                                                            <th>Subject Code</th>
                                                                                            <th>Subject Name</th>
                                                                                            <th>CCE 1</th>
                                                                                            <th>CCE 2</th>
                                                                                            <th>CCE 3</th>
                                                                                            <th>CCE 4</th>
                                                                                            <th>CCE 5</th>
                                                                                            <th>Internal Total /50</th>
                                                                                            <th>Status</th>
                                                                                        </tr>
                                                                                    </thead>
                                                                                    <tbody>
                                                                                        <% if
                                                                                            (subjectBreakdownList.isEmpty())
                                                                                            { %>
                                                                                            <tr>
                                                                                                <td colspan="9"
                                                                                                    style="text-align: center; color: var(--text-muted); padding: 1.5rem;">
                                                                                                    No enrolled subjects
                                                                                                    or evaluation
                                                                                                    records found.
                                                                                                </td>
                                                                                            </tr>
                                                                                            <% } else { for (Map<String,
                                                                                                Object> r :
                                                                                                subjectBreakdownList)
                                                                                                {
                                                                                                String st = (String)
                                                                                                r.get("status");
                                                                                                String stClass =
                                                                                                "Completed".equalsIgnoreCase(st)
                                                                                                ? "completed" :
                                                                                                "pending";
                                                                                                %>
                                                                                                <tr>
                                                                                                    <td><strong>
                                                                                                            <%= r.get("code")
                                                                                                                %>
                                                                                                        </strong></td>
                                                                                                    <td>
                                                                                                        <%= r.get("name")
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= r.get("c1")
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= r.get("c2")
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= r.get("c3")
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= r.get("c4")
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= r.get("c5")
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td><strong>
                                                                                                            <%= r.get("internalTotal")
                                                                                                                %>
                                                                                                        </strong></td>
                                                                                                    <td>
                                                                                                        <span
                                                                                                            class="status-badge <%= stClass %>">
                                                                                                            <%= st %>
                                                                                                        </span>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <% } } %>
                                                                                    </tbody>
                                                                                </table>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </main>
                                                            </div>

                                                            <!-- JS Client Data & Interactivity -->
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

                                                                // Subject CCE Data map dynamically injected from Database
                                                                const subjectCCEData = JSON.parse('<%= jsDataJsonStr.toString() %>');

                                                                function updateSubjectCCECards(code) {
                                                                    if (!code || !subjectCCEData[code]) {
                                                                        for (let i = 0; i < 5; i++) {
                                                                            const num = i + 1;
                                                                            document.getElementById('cce' + num + '_marks').innerText = '-- / 10';
                                                                            document.getElementById('cce' + num + '_breakdown').innerText = 'Exam: --/8 | Att: --/2';
                                                                            document.getElementById('cce' + num + '_att').innerText = 'Attendance: --%';
                                                                            document.getElementById('cce' + num + '_att').style.color = 'var(--text-muted)';
                                                                            document.getElementById('cce' + num + '_bar').style.width = '0%';
                                                                        }
                                                                        return;
                                                                    }
                                                                    const data = subjectCCEData[code];
                                                                    for (let i = 0; i < 5; i++) {
                                                                        const num = i + 1;
                                                                        document.getElementById('cce' + num + '_marks').innerText = data[i].marks;
                                                                        document.getElementById('cce' + num + '_breakdown').innerText = 'Exam: ' + data[i].exam + ' | Att: ' + data[i].att;
                                                                        document.getElementById('cce' + num + '_att').innerText = 'Attendance: ' + data[i].attPct;
                                                                        document.getElementById('cce' + num + '_att').style.color = (data[i].attPct !== '--%' && data[i].attPct !== '0%') ? '#10B981' : 'var(--text-muted)';
                                                                        document.getElementById('cce' + num + '_bar').style.width = data[i].fill;
                                                                    }
                                                                }

                                                                document.addEventListener('DOMContentLoaded', function () {
                                                                    const sel = document.getElementById('subjectFilterSelect');
                                                                    if (sel && sel.value) {
                                                                        updateSubjectCCECards(sel.value);
                                                                    }
                                                                });
                                                            </script>
                                                        </body>

                                                        </html>