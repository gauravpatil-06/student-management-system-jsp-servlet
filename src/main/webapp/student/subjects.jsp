<%@ page language = "java" contentType = "text/html; charset = UTF-8" pageEncoding = "UTF-8" import = "com.student.entity.*,com.student.service.*,java.util.*" %>
    <%!
        public String escapeJsonStr(String str)
        {
            if (str == null) return "" ;
            return str.replace("\\", "\\\\" ) .replace("\"", "\\\"") .replace(" \r", "\\r" ) .replace("\n", "\\n" ) .replace("\t", "\\t" );
        }
    %>
        <%
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
            response.setHeader("Pragma", "no-cache" );
            response.setDateHeader("Expires", 0);
            Student currentStudent = (Student) session.getAttribute("student");
            if (session == null || currentStudent == null)
            {
                response.sendRedirect(request.getContextPath() + "/login.jsp" );
                return;
            }
            try
            {
                StudentService studentService = new StudentService();
                Student freshStudent = studentService.getStudentByUsernameOrEmail(currentStudent.getUsername());
                if (freshStudent != null)
                {
                    session.setAttribute("student", freshStudent);
                    currentStudent = freshStudent;
                }
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }
            String studentFirstName = "Student" ;
            String studentInitial = "S" ;
            if (currentStudent != null)
            {
                String rawName = currentStudent.getName();
                if (rawName == null || rawName.trim().isEmpty())
                {
                    rawName = currentStudent.getUsername();
                }
                if (rawName != null && !rawName.trim().isEmpty())
                {
                    studentFirstName = rawName.trim();
                    studentInitial = String.valueOf(studentFirstName.charAt(0)).toUpperCase();
                }
            }
            StudentSubjectAssignmentService assignmentService = new StudentSubjectAssignmentService();
            StudentSubjectMarksService marksService = new StudentSubjectMarksService();
            TeacherSubjectService teacherSubjectService = new TeacherSubjectService();
            SubjectService subjectService = new SubjectService();
            List<StudentSubjectAssignment> assignments = null;
            Object reqAttr = request.getAttribute("assignments");
            if (reqAttr == null) reqAttr = request.getAttribute("studentSubjectAssignments");
            if (reqAttr == null) reqAttr = session.getAttribute("assignments");
            if (reqAttr instanceof List)
            {
                assignments = (List<StudentSubjectAssignment>) reqAttr;
            }
            else
            {
                assignments = assignmentService.getAssignmentsByStudent(currentStudent.getId());
            }
            Map<Integer, Subject> subjectMap = new LinkedHashMap<>();
            Map<Integer, Teacher> teacherMap = new LinkedHashMap<>();
            if (assignments != null && !assignments.isEmpty())
            {
                for (StudentSubjectAssignment ssa : assignments)
                {
                    if (ssa.getSubject() != null)
                    {
                        subjectMap.put(ssa.getSubject().getId(), ssa.getSubject());
                        teacherMap.put(ssa.getSubject().getId(), ssa.getTeacher());
                    }
                }
            }
            else
            {
                List<Subject> allSubs = subjectService.getAllSubjects();
                for (Subject sub : allSubs)
                {
                    boolean matchCourse = (currentStudent.getCourse() == null || sub.getCourse() == null || currentStudent.getCourse().equalsIgnoreCase(sub.getCourse()));
                    boolean matchDept = (currentStudent.getDepartment() == null || sub.getDepartment() == null || currentStudent.getDepartment().equalsIgnoreCase(sub.getDepartment()));
                    boolean matchSem = (currentStudent.getSemester() == null || sub.getSemester() == null || String.valueOf(currentStudent.getSemester()).equalsIgnoreCase(String.valueOf(sub.getSemester())));
                    if (matchCourse && matchDept && matchSem)
                    {
                        subjectMap.put(sub.getId(), sub);
                        List<TeacherSubject> tsList = teacherSubjectService.getAllTeacherSubjects();
                        for (TeacherSubject ts : tsList)
                        {
                            if (ts.getSubject() != null && ts.getSubject().getId() == sub.getId())
                            {
                                teacherMap.put(sub.getId(), ts.getTeacher());
                                break;
                            }
                        }
                    }
                }
            }
            StringBuilder jsonArray = new StringBuilder("[");
            boolean first = true;
            for (Subject sub : subjectMap.values())
            {
                Teacher t = teacherMap.get(sub.getId());
                String teacherName = (t != null && t.getName() != null && !t.getName().trim().isEmpty()) ? t.getName() : "Unassigned";
                if (!teacherName.startsWith("Prof.") && !teacherName.equals("Unassigned"))
                {
                    teacherName = "Prof. " + teacherName;
                }
                StudentSubjectMarks marks = marksService.getMarksByStudentAndSubject(currentStudent.getId(), sub.getId());
                double cce1Exam = marks != null ? marks.getCce1Marks() : 0;
                double cce1Att = marks != null ? marks.getAttendance1Marks() : 0;
                double cce1Total = marksService.getCce1Total(marks);
                double cce1AttPct = (cce1Att / 2.0) * 100;
                double cce2Exam = marks != null ? marks.getCce2Marks() : 0;
                double cce2Att = marks != null ? marks.getAttendance2Marks() : 0;
                double cce2Total = marksService.getCce2Total(marks);
                double cce2AttPct = (cce2Att / 2.0) * 100;
                double cce3Exam = marks != null ? marks.getCce3Marks() : 0;
                double cce3Att = marks != null ? marks.getAttendance3Marks() : 0;
                double cce3Total = marksService.getCce3Total(marks);
                double cce3AttPct = (cce3Att / 2.0) * 100;
                double cce4Exam = marks != null ? marks.getCce4Marks() : 0;
                double cce4Att = marks != null ? marks.getAttendance4Marks() : 0;
                double cce4Total = marksService.getCce4Total(marks);
                double cce4AttPct = (cce4Att / 2.0) * 100;
                double cce5Exam = marks != null ? marks.getCce5Marks() : 0;
                double cce5Att = marks != null ? marks.getAttendance5Marks() : 0;
                double cce5Total = marksService.getCce5Total(marks);
                double cce5AttPct = (cce5Att / 2.0) * 100;
                double internalTotal = marks != null ? marks.getInternalMarks() : (cce1Total + cce2Total + cce3Total + cce4Total + cce5Total);
                double endSem = marks != null ? marks.getEndSemesterMarks() : 0;
                double finalTotal = marks != null ? marks.getTotalMarks() : (internalTotal + endSem);
                String grade = (marks != null && marks.getGrade() != null) ? marks.getGrade() : "--";
                String resultStatus = (marks != null && marks.getResultStatus() != null) ? marks.getResultStatus() : "--";
                int creditVal = (sub.getCredit() != null) ? sub.getCredit() : 4;
                if (!first) jsonArray.append(",");
                first = false;
                jsonArray.append("{") .append("\"id\":").append(sub.getId()).append(",") .append("\"studentId\":").append(currentStudent.getId()).append(",") .append("\"subjectId\":").append(sub.getId()).append(",") .append("\"subjectCode\":\"").append(escapeJsonStr(sub.getSubjectCode())).append("\",") .append("\"subjectName\":\"").append(escapeJsonStr(sub.getSubjectName())).append("\",") .append("\"course\":\"").append(escapeJsonStr(sub.getCourse())).append("\",") .append("\"department\":\"").append(escapeJsonStr(sub.getDepartment())).append("\",") .append("\"semester\":\"").append(escapeJsonStr(sub.getSemester() != null ? sub.getSemester() : "0")).append("\",") .append("\"year\":\"").append(escapeJsonStr(sub.getYear())).append("\",") .append("\"credit\":").append(creditVal).append(",") .append("\"teacherName\":\"").append(escapeJsonStr(teacherName)).append("\",") .append("\"status\":\"ACTIVE\",") .append("\"cce1\":{\"exam\":").append(cce1Exam).append(",\"att\":").append(cce1Att).append(",\"total\":").append(cce1Total).append(",\"attPct\":").append(cce1AttPct).append("},") .append("\"cce2\":{\"exam\":").append(cce2Exam).append(",\"att\":").append(cce2Att).append(",\"total\":").append(cce2Total).append(",\"attPct\":").append(cce2AttPct).append("},") .append("\"cce3\":{\"exam\":").append(cce3Exam).append(",\"att\":").append(cce3Att).append(",\"total\":").append(cce3Total).append(",\"attPct\":").append(cce3AttPct).append("},") .append("\"cce4\":{\"exam\":").append(cce4Exam).append(",\"att\":").append(cce4Att).append(",\"total\":").append(cce4Total).append(",\"attPct\":").append(cce4AttPct).append("},") .append("\"cce5\":{\"exam\":").append(cce5Exam).append(",\"att\":").append(cce5Att).append(",\"total\":").append(cce5Total).append(",\"attPct\":").append(cce5AttPct).append("},") .append("\"internalTotal\":").append(internalTotal).append(",") .append("\"endSem\":").append(endSem).append(",") .append("\"finalTotal\":").append(finalTotal).append(",") .append("\"grade\":\"").append(escapeJsonStr(grade)).append("\",") .append("\"resultStatus\":\"").append(escapeJsonStr(resultStatus)).append("\"") .append("}");
            }
            jsonArray.append("]");
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

                                                /* Main Layout */
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
                                                    gap: 1.75rem;
                                                }

                                                /* Student Identity Banner */
                                                .student-profile-banner {
                                                    background: #FFFFFF;
                                                    border: 1px solid var(--border);
                                                    border-radius: var(--radius-md);
                                                    padding: 1.25rem 1.75rem;
                                                    display: flex;
                                                    align-items: center;
                                                    justify-content: space-between;
                                                    flex-wrap: wrap;
                                                    gap: 1rem;
                                                    box-shadow: var(--shadow-sm);
                                                }

                                                .student-meta-group {
                                                    display: flex;
                                                    align-items: center;
                                                    gap: 1.5rem;
                                                    flex-wrap: wrap;
                                                }

                                                .meta-chip {
                                                    display: flex;
                                                    flex-direction: column;
                                                }

                                                .chip-label {
                                                    font-size: 0.725rem;
                                                    font-weight: 700;
                                                    color: var(--text-muted);
                                                    text-transform: uppercase;
                                                    letter-spacing: 0.05em;
                                                }

                                                .chip-val {
                                                    font-size: 0.95rem;
                                                    font-weight: 800;
                                                    color: var(--primary-navy);
                                                }

                                                /* Grid Layout for Subjects Cards */
                                                .subject-grid {
                                                    display: grid;
                                                    grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
                                                    gap: 1.5rem;
                                                }

                                                .subject-card {
                                                    background: #FFFFFF;
                                                    border: 1px solid var(--border);
                                                    border-radius: var(--radius-md);
                                                    padding: 1.5rem;
                                                    box-shadow: var(--shadow-sm);
                                                    transition: var(--transition);
                                                    display: flex;
                                                    flex-direction: column;
                                                    justify-content: space-between;
                                                }

                                                .subject-card:hover {
                                                    transform: translateY(-4px);
                                                    box-shadow: var(--shadow-hover);
                                                    border-color: var(--primary-blue);
                                                }

                                                .card-top {
                                                    display: flex;
                                                    justify-content: space-between;
                                                    align-items: flex-start;
                                                    margin-bottom: 0.85rem;
                                                }

                                                .subj-badge-code {
                                                    background: var(--light-blue);
                                                    color: var(--primary-blue);
                                                    font-weight: 800;
                                                    font-size: 0.775rem;
                                                    padding: 0.25rem 0.6rem;
                                                    border-radius: 6px;
                                                }

                                                .subj-title {
                                                    font-size: 1.2rem;
                                                    font-weight: 800;
                                                    color: var(--primary-navy);
                                                    margin-bottom: 0.35rem;
                                                    line-height: 1.3;
                                                }

                                                .subj-academic-info {
                                                    font-size: 0.825rem;
                                                    color: var(--text-muted);
                                                    font-weight: 600;
                                                    margin-bottom: 1.25rem;
                                                    display: flex;
                                                    flex-wrap: wrap;
                                                    gap: 0.4rem 0.8rem;
                                                }

                                                /* Allocated Teacher Box inside Card */
                                                .allocated-teacher-box {
                                                    background: #F8FAFC;
                                                    border: 1px solid #E2E8F0;
                                                    border-radius: var(--radius-sm);
                                                    padding: 0.85rem 1rem;
                                                    margin-bottom: 1.25rem;
                                                    display: flex;
                                                    align-items: center;
                                                    gap: 0.85rem;
                                                }

                                                .teacher-avatar-icon {
                                                    width: 38px;
                                                    height: 38px;
                                                    border-radius: 50%;
                                                    background: #EFF6FF;
                                                    color: var(--primary-blue);
                                                    display: flex;
                                                    align-items: center;
                                                    justify-content: center;
                                                    font-weight: 800;
                                                    flex-shrink: 0;
                                                }

                                                .teacher-details {
                                                    display: flex;
                                                    flex-direction: column;
                                                }

                                                .teacher-name {
                                                    font-size: 0.925rem;
                                                    font-weight: 800;
                                                    color: var(--primary-navy);
                                                }

                                                .teacher-uname {
                                                    font-size: 0.775rem;
                                                    color: var(--text-muted);
                                                    font-weight: 600;
                                                }

                                                .card-footer {
                                                    display: flex;
                                                    align-items: center;
                                                    justify-content: space-between;
                                                    padding-top: 1rem;
                                                    border-top: 1px solid var(--border);
                                                }

                                                .status-badge {
                                                    display: inline-flex;
                                                    align-items: center;
                                                    gap: 0.35rem;
                                                    padding: 0.3rem 0.75rem;
                                                    border-radius: 50px;
                                                    font-size: 0.75rem;
                                                    font-weight: 800;
                                                }

                                                .status-active {
                                                    background: #DCFCE7;
                                                    color: #15803D;
                                                }

                                                .btn-view-subject {
                                                    background: var(--primary-blue);
                                                    color: #FFFFFF;
                                                    border: none;
                                                    padding: 0.55rem 1.15rem;
                                                    border-radius: var(--radius-sm);
                                                    font-size: 0.85rem;
                                                    font-weight: 700;
                                                    cursor: pointer;
                                                    transition: var(--transition);
                                                    display: inline-flex;
                                                    align-items: center;
                                                    gap: 0.4rem;
                                                }

                                                .btn-view-subject:hover {
                                                    background: var(--primary-blue-hover);
                                                }

                                                /* Modal Overlay */
                                                .modal-backdrop {
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

                                                .modal-backdrop.open {
                                                    display: flex;
                                                }

                                                .modal-card {
                                                    background: #FFFFFF;
                                                    border-radius: var(--radius-md);
                                                    width: 100%;
                                                    max-width: 680px;
                                                    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
                                                    border: 1px solid var(--border);
                                                    overflow: hidden;
                                                    max-height: 90vh;
                                                    display: flex;
                                                    flex-direction: column;
                                                }

                                                .modal-header {
                                                    padding: 1.25rem 1.5rem;
                                                    background: #F8FAFC;
                                                    border-bottom: 1px solid var(--border);
                                                    display: flex;
                                                    align-items: center;
                                                    justify-content: space-between;
                                                }

                                                .modal-body {
                                                    padding: 1.5rem;
                                                    overflow-y: auto;
                                                    display: flex;
                                                    flex-direction: column;
                                                    gap: 1.25rem;
                                                }

                                                .modal-footer {
                                                    padding: 1rem 1.5rem;
                                                    background: #F8FAFC;
                                                    border-top: 1px solid var(--border);
                                                    display: flex;
                                                    justify-content: flex-end;
                                                }

                                                /* Table Styling */
                                                .cce-detail-table {
                                                    width: 100%;
                                                    border-collapse: collapse;
                                                    font-size: 0.875rem;
                                                }

                                                .cce-detail-table th {
                                                    background: #F1F5F9;
                                                    padding: 0.65rem 0.85rem;
                                                    text-align: center;
                                                    font-weight: 700;
                                                    color: var(--text-muted);
                                                    font-size: 0.75rem;
                                                    text-transform: uppercase;
                                                    border-bottom: 1px solid var(--border);
                                                }

                                                .cce-detail-table td {
                                                    padding: 0.75rem 0.85rem;
                                                    text-align: center;
                                                    border-bottom: 1px solid var(--border);
                                                    font-weight: 600;
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

                                                    .subject-grid {
                                                        grid-template-columns: 1fr;
                                                    }
                                                }
                                            </style>
                                        </head>

                                        <body>
                                            <div class="sidebar-overlay" id="sidebarOverlay"></div>

                                            <!-- Left Sidebar -->
                                            <aside class="sidebar" id="sidebar">
                                                <div class="sidebar-brand">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2.5">
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
                                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                                                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
                                                                <path
                                                                    d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" />
                                                            </svg>
                                                            <span>My Subjects</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="cce-marks.jsp">
                                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
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
                                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                                                <polygon
                                                                    points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                                                            </svg>
                                                            <span>My Results</span>
                                                        </a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="profile.jsp">
                                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
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
                                                            stroke="currentColor" stroke-width="2">
                                                            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                                                            <polyline points="16 17 21 12 16 7" />
                                                            <line x1="21" y1="12" x2="9" y2="12" />
                                                        </svg>
                                                        <span>Logout</span>
                                                    </a>
                                                </div>
                                            </aside>

                                            <!-- Main Content Wrapper -->
                                            <div class="main-wrapper">
                                                <header class="top-navbar">
                                                    <div class="top-left">
                                                        <button class="menu-toggle-btn" id="menuToggleBtn"
                                                            aria-label="Toggle menu">
                                                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <line x1="3" y1="12" x2="21" y2="12" />
                                                                <line x1="3" y1="6" x2="21" y2="6" />
                                                                <line x1="3" y1="18" x2="21" y2="18" />
                                                            </svg>
                                                        </button>
                                                        <h1 class="page-title">My Subjects</h1>
                                                    </div>

                                                    <div class="top-right">
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

                                                        <!-- Subjects Grid Section -->
                                                        <div>
                                                            <div
                                                                style="display:flex; align-items:center; justify-content:space-between; margin-bottom:1rem;">
                                                                <h3
                                                                    style="font-size:1.1rem; font-weight:800; color:var(--primary-navy); margin:0;">
                                                                    Enrolled Academic Subjects</h3>
                                                                <span
                                                                    style="font-size:0.8rem; font-weight:700; color:var(--text-muted);"
                                                                    id="subjectCounter">-- Active Subjects</span>
                                                            </div>

                                                            <div class="subject-grid" id="studentSubjectsContainer">
                                                                <!-- Dynamic Subject Cards rendered by JS -->
                                                            </div>
                                                        </div>

                                                    </div>
                                                </main>
                                            </div>

                                            <!-- View Subject Detail Modal -->
                                            <div class="modal-backdrop" id="viewSubjectModal">
                                                <div class="modal-card">
                                                    <div class="modal-header">
                                                        <div>
                                                            <h3 style="font-size:1.1rem; font-weight:800; color:var(--primary-navy); margin:0;"
                                                                id="mSubModalTitle">Subject Name</h3>
                                                            <span
                                                                style="font-size:0.8rem; color:var(--text-muted); font-weight:600;"
                                                                id="mSubModalSubtitle">Course • Dept • Semester</span>
                                                        </div>
                                                        <button onclick="closeSubjectModal()"
                                                            style="background:none; border:none; font-size:1.5rem; cursor:pointer; color:var(--text-muted);">&times;</button>
                                                    </div>
                                                    <div class="modal-body">

                                                        <!-- Allocated Teacher Banner -->
                                                        <div
                                                            style="background:#EFF6FF; border:1px solid #BFDBFE; border-radius:10px; padding:1rem 1.25rem; display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:0.75rem;">
                                                            <div style="display:flex; align-items:center; gap:0.85rem;">
                                                                <div
                                                                    style="width:42px; height:42px; border-radius:50%; background:#2563EB; color:#FFF; display:flex; align-items:center; justify-content:center; font-weight:800; font-size:1.1rem;">
                                                                    T
                                                                </div>
                                                                <div>
                                                                    <span
                                                                        style="font-size:0.725rem; font-weight:700; color:#1D4ED8; text-transform:uppercase; letter-spacing:0.04em;">Allocated
                                                                        Teacher</span>
                                                                    <div style="font-size:1rem; font-weight:800; color:#1E3A5F;"
                                                                        id="mSubModalTeacherName">Prof. Patil</div>
                                                                </div>
                                                            </div>
                                                            <div style="display:flex; align-items:center; gap:1.5rem;">
                                                                <div>
                                                                    <span
                                                                        style="font-size:0.725rem; font-weight:700; color:#1D4ED8; text-transform:uppercase; letter-spacing:0.04em; display:block;">Credit</span>
                                                                    <span
                                                                        style="font-size:1rem; font-weight:800; color:#1E3A5F;"
                                                                        id="mSubModalCredit">4</span>
                                                                </div>
                                                                <div>
                                                                    <span class="status-badge status-active"
                                                                        id="mSubModalStatus">ACTIVE</span>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- CCE Academic Performance -->
                                                        <div>
                                                            <h4
                                                                style="font-size:0.95rem; font-weight:800; color:var(--primary-navy); margin-bottom:0.75rem;">
                                                                Continuous Comprehensive Evaluation (CCE) Breakdown</h4>
                                                            <div
                                                                style="overflow-x:auto; border:1px solid var(--border); border-radius:10px;">
                                                                <table class="cce-detail-table">
                                                                    <thead>
                                                                        <tr>
                                                                            <th>Assessment</th>
                                                                            <th>Written Exam</th>
                                                                            <th>Attendance</th>
                                                                            <th>Total Marks</th>
                                                                            <th>Attendance Ratio</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody id="mSubModalCceBody">
                                                                        <!-- CCE 1-5 Rows dynamically injected -->
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>

                                                        <!-- Final Assessment & Results (5 boxes in 1 row) -->
                                                        <div
                                                            style="background:#F8FAFC; border:1px solid var(--border); border-radius:10px; padding:1.25rem;">
                                                            <div
                                                                style="display:grid; grid-template-columns:repeat(5, 1fr); gap:0.75rem; text-align:center;">
                                                                <div
                                                                    style="background:#FFF; padding:0.75rem 0.5rem; border-radius:8px; border:1px solid var(--border);">
                                                                    <span
                                                                        style="font-size:0.7rem; font-weight:700; color:var(--text-muted); display:block; text-transform:uppercase; white-space:nowrap;">Internal
                                                                        Total</span>
                                                                    <span
                                                                        style="font-size:1.1rem; font-weight:800; color:var(--primary-blue);"
                                                                        id="mSubInternalVal">48 / 50</span>
                                                                </div>
                                                                <div
                                                                    style="background:#FFF; padding:0.75rem 0.5rem; border-radius:8px; border:1px solid var(--border);">
                                                                    <span
                                                                        style="font-size:0.7rem; font-weight:700; color:var(--text-muted); display:block; text-transform:uppercase; white-space:nowrap;">End
                                                                        Semester</span>
                                                                    <span
                                                                        style="font-size:1.1rem; font-weight:800; color:var(--primary-navy);"
                                                                        id="mSubEndSemVal">44 / 50</span>
                                                                </div>
                                                                <div
                                                                    style="background:#FFF; padding:0.75rem 0.5rem; border-radius:8px; border:1px solid var(--border);">
                                                                    <span
                                                                        style="font-size:0.7rem; font-weight:700; color:var(--text-muted); display:block; text-transform:uppercase; white-space:nowrap;">Final
                                                                        Marks</span>
                                                                    <span
                                                                        style="font-size:1.1rem; font-weight:800; color:#16A34A;"
                                                                        id="mSubFinalTotalVal">92 / 100</span>
                                                                </div>
                                                                <div
                                                                    style="background:#FFF; padding:0.75rem 0.5rem; border-radius:8px; border:1px solid var(--border);">
                                                                    <span
                                                                        style="font-size:0.7rem; font-weight:700; color:var(--text-muted); display:block; text-transform:uppercase; white-space:nowrap;">Grade</span>
                                                                    <span
                                                                        style="font-size:1.1rem; font-weight:800; color:#2563EB;"
                                                                        id="mSubGradeVal">O</span>
                                                                </div>
                                                                <div
                                                                    style="background:#FFF; padding:0.75rem 0.5rem; border-radius:8px; border:1px solid var(--border);">
                                                                    <span
                                                                        style="font-size:0.7rem; font-weight:700; color:var(--text-muted); display:block; text-transform:uppercase; white-space:nowrap;">Result
                                                                        Status</span>
                                                                    <span
                                                                        style="font-size:1.1rem; font-weight:800; color:#16A34A;"
                                                                        id="mSubResultVal">Pass</span>
                                                                </div>
                                                            </div>
                                                        </div>

                                                    </div>
                                                    <div class="modal-footer">
                                                        <button onclick="closeSubjectModal()" class="btn-view-subject"
                                                            style="background:#64748B;">Close</button>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- JavaScript Logic -->
                                            <script>
                                                // Demo Student Metadata
                                                const currentStudentData = {
                                                    name: "<%= (currentStudent != null && currentStudent.getName() != null) ? escapeJsonStr(currentStudent.getName()) : "" %>",
                                                    rollNo: "<%= (currentStudent != null && currentStudent.getRollNo() != null) ? escapeJsonStr(currentStudent.getRollNo()) : "" %>",
                                                    course: "<%= (currentStudent != null && currentStudent.getCourse() != null) ? escapeJsonStr(currentStudent.getCourse()) : "" %>",
                                                    department: "<%= (currentStudent != null && currentStudent.getDepartment() != null) ? escapeJsonStr(currentStudent.getDepartment()) : "" %>",
                                                    semester: "<%= (currentStudent != null && currentStudent.getSemester() != null) ? escapeJsonStr(currentStudent.getSemester()) : "0" %>",
                                                    year: "<%= (currentStudent != null && currentStudent.getYear() != null) ? escapeJsonStr(currentStudent.getYear()) : "" %>"
                                                };

                                                const studentSubjectsData = <%= jsonArray.toString() %>;

                                                function renderStudentSubjects() {
                                                    const container = document.getElementById('studentSubjectsContainer');
                                                    const counter = document.getElementById('subjectCounter');

                                                    const eligible = studentSubjectsData;

                                                    if (counter) counter.textContent = eligible.length + ' Active Subjects';

                                                    if (!eligible || eligible.length === 0) {
                                                        container.innerHTML = `
                            <div style="grid-column: 1 / -1; background:#FFFFFF; border:1px solid var(--border); border-radius:12px; padding:3rem; text-align:center;">
                                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#94A3B8" stroke-width="2" style="margin-bottom:1rem;"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                                <h3 style="font-size:1.1rem; font-weight:800; color:var(--primary-navy); margin-bottom:0.5rem;">No Subjects Assigned Yet</h3>
                                <p style="font-size:0.9rem; color:var(--text-muted);">No active subjects have been assigned to your profile yet.</p>
                            </div>
                        `;
                                                        return;
                                                    }

                                                    container.innerHTML = eligible.map(function (sub) {
                                                        var code = sub.subjectCode || '';
                                                        var name = sub.subjectName || '';
                                                        var course = sub.course || '';
                                                        var dept = sub.department || '';
                                                        var semVal = sub.semester != null ? String(sub.semester).trim() : '';
                                                        var semText = semVal.toLowerCase().startsWith('semester') ? semVal : ('Semester ' + semVal);
                                                        var credit = sub.credit != null ? sub.credit : '--';
                                                        var teacher = sub.teacherName || 'Unassigned';
                                                        var initial = (teacher.replace('Prof. ', '').charAt(0) || 'T').toUpperCase();

                                                        return '<div class="subject-card">' +
                                                            '<div>' +
                                                            '<div class="card-top">' +
                                                            '<div style="display:flex; align-items:center; gap:0.5rem; flex-wrap:wrap;">' +
                                                            '<span class="subj-badge-code">' + code + '</span>' +
                                                            '<span style="font-size:0.75rem; font-weight:800; color:#1D4ED8; background:#EFF6FF; border:1px solid #BFDBFE; padding:0.2rem 0.6rem; border-radius:6px;">Credit: ' + credit + '</span>' +
                                                            '</div>' +
                                                            '<span class="status-badge status-active"><span style="width:6px; height:6px; border-radius:50%; background:#16A34A; display:inline-block; margin-right:4px;"></span>ACTIVE</span>' +
                                                            '</div>' +
                                                            '<h3 class="subj-title" style="margin-top:0.6rem;">' + name + '</h3>' +
                                                            '<div class="subj-academic-info">' +
                                                            '<span>' + course + '</span> • <span>' + dept + '</span> • <span>' + semText + '</span>' +
                                                            '</div>' +
                                                            '<div class="allocated-teacher-box">' +
                                                            '<div class="teacher-avatar-icon">' + initial + '</div>' +
                                                            '<div class="teacher-details">' +
                                                            '<span style="font-size:0.7rem; font-weight:700; color:var(--text-muted); text-transform:uppercase; letter-spacing:0.03em;">Allocated Teacher</span>' +
                                                            '<span class="teacher-name">' + teacher + '</span>' +
                                                            '</div>' +
                                                            '</div>' +
                                                            '</div>' +
                                                            '<div class="card-footer" style="padding-top:0.85rem; border-top:1px solid #F1F5F9; display:flex; justify-content:flex-end;">' +
                                                            '<button class="btn-view-subject" style="width:100%; justify-content:center;" onclick="openSubjectModal(' + sub.id + ')">' +
                                                            '<span>View Marks</span>' +
                                                            '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 18 15 12 9 6"/></svg>' +
                                                            '</button>' +
                                                            '</div>' +
                                                            '</div>';
                                                    }).join('');
                                                }

                                                function openSubjectModal(subjectId) {
                                                    const sub = studentSubjectsData.find(s => s.id === subjectId);
                                                    if (!sub) return;

                                                    var semValM = sub.semester != null ? String(sub.semester).trim() : '';
                                                    var semTextM = semValM.toLowerCase().startsWith('semester') ? semValM : ('Semester ' + semValM);

                                                    document.getElementById('mSubModalTitle').textContent = sub.subjectName + ' (' + sub.subjectCode + ')';
                                                    document.getElementById('mSubModalSubtitle').textContent = sub.course + ' • ' + sub.department + ' • ' + semTextM;
                                                    document.getElementById('mSubModalTeacherName').textContent = sub.teacherName;
                                                    const avatarElem = document.getElementById('mSubModalTeacherAvatar');
                                                    if (avatarElem) avatarElem.textContent = (sub.teacherName || 'T').replace('Prof. ', '').charAt(0).toUpperCase();
                                                    const creditElem = document.getElementById('mSubModalCredit');
                                                    if (creditElem) creditElem.textContent = sub.credit != null ? sub.credit : '--';
                                                    document.getElementById('mSubModalStatus').textContent = sub.status;

                                                    // Populate CCE 1 to CCE 5 Rows
                                                    const cceBody = document.getElementById('mSubModalCceBody');
                                                    const cces = [
                                                        { name: "CCE 1", data: sub.cce1 },
                                                        { name: "CCE 2", data: sub.cce2 },
                                                        { name: "CCE 3", data: sub.cce3 },
                                                        { name: "CCE 4", data: sub.cce4 },
                                                        { name: "CCE 5", data: sub.cce5 }
                                                    ];

                                                    cceBody.innerHTML = cces.map(function (c) {
                                                        return '<tr>' +
                                                            '<td style="font-weight:800; color:var(--primary-navy);">' + c.name + '</td>' +
                                                            '<td>' + c.data.exam + ' / 8</td>' +
                                                            '<td>' + c.data.att + ' / 2</td>' +
                                                            '<td style="font-weight:800; color:var(--primary-blue);">' + c.data.total + ' / 10</td>' +
                                                            '<td style="color:var(--success); font-weight:700;">' + c.data.attPct + '%</td>' +
                                                            '</tr>';
                                                    }).join('');

                                                    document.getElementById('mSubInternalVal').textContent = sub.internalTotal + ' / 50';
                                                    document.getElementById('mSubEndSemVal').textContent = sub.endSem + ' / 50';
                                                    document.getElementById('mSubFinalTotalVal').textContent = sub.finalTotal + ' / 100';
                                                    document.getElementById('mSubGradeVal').textContent = sub.grade;
                                                    document.getElementById('mSubResultVal').textContent = sub.resultStatus;

                                                    document.getElementById('viewSubjectModal').classList.add('open');
                                                }

                                                function closeSubjectModal() {
                                                    document.getElementById('viewSubjectModal').classList.remove('open');
                                                }

                                                // Sidebar Toggle logic
                                                const menuToggleBtn = document.getElementById('menuToggleBtn');
                                                const sidebar = document.getElementById('sidebar');
                                                const sidebarOverlay = document.getElementById('sidebarOverlay');

                                                function toggleSidebar() {
                                                    sidebar.classList.toggle('open');
                                                    sidebarOverlay.classList.toggle('active');
                                                }

                                                if (menuToggleBtn) menuToggleBtn.addEventListener('click', toggleSidebar);
                                                if (sidebarOverlay) sidebarOverlay.addEventListener('click', toggleSidebar);

                                                document.addEventListener('DOMContentLoaded', () => {
                                                    renderStudentSubjects();
                                                });
                                            </script>
                                            <jsp:include page="/logout-modal.jsp" />
                                        </body>

                                        </html>