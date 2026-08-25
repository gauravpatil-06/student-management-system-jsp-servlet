package com.student.servlet.admin;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.http.HttpSession;

import com.student.entity.Admin;
import com.student.entity.StudentSubjectAssignment;
import com.student.service.StudentSubjectAssignmentService;

@WebServlet("/api/admin/student-subject-assignments")
public class AdminStudentSubjectAssignmentServlet extends HttpServlet
{

    private StudentSubjectAssignmentService assignmentService = new StudentSubjectAssignmentService();

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
            String teacherIdParam = request.getParameter("teacherId");
            String subjectIdParam = request.getParameter("subjectId");

            if (teacherIdParam != null && !teacherIdParam.isEmpty() &&
                    subjectIdParam != null && !subjectIdParam.isEmpty())
            {

                int teacherId = Integer.parseInt(teacherIdParam);
                int subjectId = Integer.parseInt(subjectIdParam);

                List<StudentSubjectAssignment> list = assignmentService.getAssignmentsByTeacherAndSubject(teacherId,
                        subjectId);

                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < list.size(); i++)
                {
                    StudentSubjectAssignment ssa = list.get(i);
                    if (i > 0)
                        json.append(",");
                    json.append("{")
                            .append("\"id\":").append(ssa.getId()).append(",")
                            .append("\"studentId\":").append(ssa.getStudent().getId()).append(",")
                            .append("\"subjectId\":").append(ssa.getSubject().getId()).append(",")
                            .append("\"teacherId\":").append(ssa.getTeacher().getId())
                            .append("}");
                }
                json.append("]");

                response.getWriter().print(json.toString());
                return;
            }

            response.getWriter().print("[]");

        }
        catch (Exception e)
        {
            e.printStackTrace();
            response.getWriter().print("[]");
        }
    }

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
            String teacherIdParam = request.getParameter("teacherId");
            String subjectIdParam = request.getParameter("subjectId");
            String studentIdsParam = request.getParameter("studentIds");

            if (teacherIdParam == null || teacherIdParam.isEmpty() ||
                    subjectIdParam == null || subjectIdParam.isEmpty())
            {
                response.getWriter()
                        .print("{\"status\":\"error\",\"message\":\"teacherId and subjectId are required.\"}");
                return;
            }

            int teacherId = Integer.parseInt(teacherIdParam);
            int subjectId = Integer.parseInt(subjectIdParam);

            List<Integer> studentIds = new ArrayList<>();
            if (studentIdsParam != null && !studentIdsParam.trim().isEmpty())
            {
                String[] parts = studentIdsParam.split(",");
                for (String part : parts)
                {
                    if (part != null && !part.trim().isEmpty())
                    {
                        try
                        {
                            studentIds.add(Integer.parseInt(part.trim()));
                        }
                        catch (NumberFormatException ignored)
                        {
                        }
                    }
                }
            }

            assignmentService.syncStudentAssignments(teacherId, subjectId, studentIds);
            long newCount = assignmentService.getAssignedCount(teacherId, subjectId);

            response.getWriter().print(
                    "{\"status\":\"success\",\"message\":\"Student allocation updated successfully\",\"assignedCount\":"
                            + newCount + "}");

        }
        catch (Exception e)
        {
            e.printStackTrace();
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Server error: " + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
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
            String teacherIdParam = request.getParameter("teacherId");
            String subjectIdParam = request.getParameter("subjectId");

            if (teacherIdParam != null && !teacherIdParam.isEmpty() &&
                    subjectIdParam != null && !subjectIdParam.isEmpty())
            {

                int teacherId = Integer.parseInt(teacherIdParam);
                int subjectId = Integer.parseInt(subjectIdParam);

                assignmentService.deleteByTeacherAndSubject(teacherId, subjectId);
                response.getWriter().print("{\"status\":\"success\",\"message\":\"Student allocations deleted\"}");
                return;
            }

            response.getWriter()
                    .print("{\"status\":\"error\",\"message\":\"teacherId and subjectId required for delete\"}");
        }
        catch (Exception e)
        {
            e.printStackTrace();
            response.getWriter().print("{\"status\":\"error\",\"message\":\"Server error: " + e.getMessage() + "\"}");
        }
    }
}
