package com.student.servlet.admin;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.http.HttpSession;

import com.student.entity.Admin;
import com.student.entity.Subject;
import com.student.entity.Teacher;
import com.student.entity.TeacherSubject;
import com.student.service.StudentSubjectAssignmentService;
import com.student.service.SubjectService;
import com.student.service.TeacherService;
import com.student.service.TeacherSubjectService;

@WebServlet("/api/admin/teacher-subjects")
public class AdminTeacherSubjectServlet extends HttpServlet
{

    private TeacherSubjectService teacherSubjectService = new TeacherSubjectService();
    private TeacherService teacherService = new TeacherService();
    private SubjectService subjectService = new SubjectService();
    private StudentSubjectAssignmentService studentAssignmentService = new StudentSubjectAssignmentService();

    private String clean(String val)
    {
        if (val == null)
            return "";
        return val.replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
    }

    // GET - Show all assignments
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
            {

        HttpSession session = request.getSession(false);
        Admin loggedAdmin = session != null ? (Admin) session.getAttribute("admin") : null;
        if (loggedAdmin == null)
        {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Unauthorized\"}");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try
        {
            List<TeacherSubject> list = teacherSubjectService.getAllTeacherSubjects();

            StringBuilder json = new StringBuilder("[");
            boolean first = true;

            for (TeacherSubject ts : list)
            {
                Teacher teacher = ts.getTeacher();
                Subject subject = ts.getSubject();

                if (teacher == null || subject == null)
                    continue;

                if (!first)
                {
                    json.append(",");
                }
                first = false;

                int sem = 5;
                try
                {
                    String semStr = subject.getSemester() != null ? subject.getSemester().replaceAll("[^0-9]", "")
                            : "5";
                    sem = Integer.parseInt(semStr);
                } catch (Exception ignored)
                {
                }

                String year = subject.getYear() != null ? subject.getYear()
                        : (sem <= 2 ? "First Year"
                                : sem <= 4 ? "Second Year" : sem <= 6 ? "Third Year" : "Fourth Year");

                long studentCount = studentAssignmentService.getAssignedCount(teacher.getId(), subject.getId());

                json.append("{");
                json.append("\"id\":").append(ts.getId()).append(",");
                json.append("\"teacherId\":").append(teacher.getId()).append(",");
                json.append("\"teacherName\":\"").append(clean(teacher.getName())).append("\",");
                json.append("\"teacherUsername\":\"").append(clean(teacher.getUsername())).append("\",");
                json.append("\"teacherDept\":\"").append(clean(teacher.getDepartment())).append("\",");
                json.append("\"subjectId\":").append(subject.getId()).append(",");
                json.append("\"subjectCode\":\"").append(clean(subject.getSubjectCode())).append("\",");
                json.append("\"subjectName\":\"").append(clean(subject.getSubjectName())).append("\",");
                json.append("\"course\":\"").append(clean(subject.getCourse())).append("\",");
                json.append("\"department\":\"").append(clean(subject.getDepartment())).append("\",");
                json.append("\"semester\":").append(sem).append(",");
                json.append("\"year\":\"").append(clean(year)).append("\",");
                json.append("\"studentCount\":").append(studentCount);
                json.append("}");
            }

            json.append("]");
            response.getWriter().print(json.toString());
        } catch (Exception e)
        {
            e.printStackTrace();
            response.getWriter().print("[]");
        }
    }

    // POST - Assign / Delete
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
            {

        HttpSession session = request.getSession(false);
        Admin loggedAdmin = session != null ? (Admin) session.getAttribute("admin") : null;
        if (loggedAdmin == null)
        {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Unauthorized\"}");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try
        {
            String action = request.getParameter("action");
            String idStr = request.getParameter("id");

            if ("delete".equals(action)
                    || (idStr != null && !idStr.isEmpty() && "DELETE".equalsIgnoreCase(request.getMethod())))
                    {
                if (idStr != null && !idStr.isEmpty())
                {
                    int id = Integer.parseInt(idStr);
                    teacherSubjectService.deleteTeacherSubject(id);
                    response.getWriter()
                            .print("{\"status\":\"success\",\"message\":\"Assignment deleted successfully\"}");
                    return;
                }
            }

            // ASSIGN / ADD
            String teacherIdParam = request.getParameter("teacherId");
            String subjectIdsParam = request.getParameter("subjectId");
            if (subjectIdsParam == null || subjectIdsParam.isEmpty())
            {
                subjectIdsParam = request.getParameter("subjectIds");
            }

            if (teacherIdParam == null || teacherIdParam.isEmpty() || subjectIdsParam == null
                    || subjectIdsParam.isEmpty())
                    {
                response.getWriter()
                        .print("{\"status\":\"error\",\"message\":\"Teacher and Subject must be specified.\"}");
                return;
            }

            Teacher teacher = null;
            try
            {
                int tId = Integer.parseInt(teacherIdParam);
                teacher = teacherService.getTeacherById(tId);
            } catch (Exception e)
            {
                teacher = teacherService.getTeacherByUsernameOrEmail(teacherIdParam);
            }

            if (teacher == null)
            {
                List<Teacher> allT = teacherService.getAllTeachers();
                for (Teacher t : allT)
                {
                    if (teacherIdParam.equalsIgnoreCase(t.getUsername())
                            || String.valueOf(t.getId()).equals(teacherIdParam))
                            {
                        teacher = t;
                        break;
                    }
                }
            }

            if (teacher == null)
            {
                response.getWriter().print("{\"status\":\"error\",\"message\":\"Teacher not found\"}");
                return;
            }

            String[] subjectIdArray = subjectIdsParam.split(",");
            int addedCount = 0;
            int duplicateCount = 0;

            for (String sIdStr : subjectIdArray)
            {
                if (sIdStr == null || sIdStr.trim().isEmpty())
                    continue;
                Subject subject = null;
                try
                {
                    int sId = Integer.parseInt(sIdStr.trim());
                    subject = subjectService.getSubjectById(sId);
                } catch (Exception e)
                {
                    List<Subject> allS = subjectService.getAllSubjects();
                    for (Subject s : allS)
                    {
                        if (sIdStr.trim().equalsIgnoreCase(s.getSubjectName())
                                || sIdStr.trim().equalsIgnoreCase(s.getSubjectCode()))
                                {
                            subject = s;
                            break;
                        }
                    }
                }

                if (subject != null)
                {
                    // Department match check (Requirement 5)
                    if (teacher.getDepartment() != null && subject.getDepartment() != null &&
                            !teacher.getDepartment().trim().equalsIgnoreCase(subject.getDepartment().trim()))
                            {
                        response.getWriter().print(
                                "{\"status\":\"error\",\"message\":\"Department mismatch: Teacher department (" +
                                        clean(teacher.getDepartment()) + ") does not match subject department (" +
                                        clean(subject.getDepartment()) + ").\"}");
                        return;
                    }

                    TeacherSubject oldAssignment = teacherSubjectService.getByTeacherAndSubject(teacher.getId(),
                            subject.getId());
                    if (oldAssignment != null)
                    {
                        duplicateCount++;
                    } else
                    {
                        TeacherSubject ts = new TeacherSubject(teacher, subject);
                        teacherSubjectService.saveTeacherSubject(ts);
                        addedCount++;
                    }
                }
            }

            if (addedCount == 0 && duplicateCount > 0)
            {
                response.getWriter().print(
                        "{\"status\":\"error\",\"message\":\"Selected subject(s) are already assigned to this teacher.\"}");
            } else
            {
                response.getWriter().print("{\"status\":\"success\",\"message\":\"Subject(s) assigned successfully\"}");
            }

        } catch (Exception e)
        {
            e.printStackTrace();
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Server error: " + e.getMessage() + "\"}");
        }
    }

    // DELETE request
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
            {
        doPost(request, response);
    }
}