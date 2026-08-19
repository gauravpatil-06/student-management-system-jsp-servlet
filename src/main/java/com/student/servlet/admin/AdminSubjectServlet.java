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
import com.student.service.SubjectService;

@WebServlet("/api/admin/subjects")
public class AdminSubjectServlet extends HttpServlet
{
    private SubjectService subjectService = new SubjectService();

    // GET - Fetch all subjects
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
            List<Subject> subjects = subjectService.getAllSubjects();

            StringBuilder json = new StringBuilder("[");

            for (int i = 0; i < subjects.size(); i++)
            {
                Subject s = subjects.get(i);

                json.append("{");
                json.append("\"id\":").append(s.getId()).append(",");
                json.append("\"code\":\"").append(clean(s.getSubjectCode())).append("\",");
                json.append("\"subjectCode\":\"").append(clean(s.getSubjectCode())).append("\",");
                json.append("\"name\":\"").append(clean(s.getSubjectName())).append("\",");
                json.append("\"subjectName\":\"").append(clean(s.getSubjectName())).append("\",");
                json.append("\"course\":\"").append(clean(s.getCourse())).append("\",");
                json.append("\"dept\":\"").append(clean(s.getDepartment())).append("\",");
                json.append("\"department\":\"").append(clean(s.getDepartment())).append("\",");
                json.append("\"sem\":\"").append(clean(s.getSemester())).append("\",");
                json.append("\"semester\":\"").append(clean(s.getSemester())).append("\",");
                json.append("\"year\":\"").append(clean(s.getYear())).append("\",");
                json.append("\"credit\":").append(s.getCredit() != null ? s.getCredit() : "null");
                json.append("}");

                if (i < subjects.size() - 1)
                {
                    json.append(",");
                }
            }

            json.append("]");

            response.getWriter().print(json.toString());
        }
        catch (Exception e)
        {
            e.printStackTrace();
            response.getWriter().print("[]");
        }
    }

    // POST - Add / Edit / Delete
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

            if ("delete".equals(action))
            {
                int id = Integer.parseInt(request.getParameter("id"));

                subjectService.deleteSubject(id);

                response.getWriter().print(
                        "{\"status\":\"success\",\"message\":\"Subject deleted\"}");

                return;
            }

            String code = request.getParameter("code");

            if (code == null || code.isEmpty())
            {
                code = request.getParameter("subjectCode");
            }

            String name = request.getParameter("name");

            if (name == null || name.isEmpty())
            {
                name = request.getParameter("subjectName");
            }

            String course = request.getParameter("course");

            String department = request.getParameter("department");

            if (department == null || department.isEmpty())
            {
                department = request.getParameter("dept");
            }

            String semester = request.getParameter("semester");

            if (semester == null || semester.isEmpty())
            {
                semester = request.getParameter("sem");
            }

            String year = request.getParameter("year");

            String creditStr = request.getParameter("credit");
            Integer credit = null;

            if (creditStr != null && !creditStr.trim().isEmpty())
            {
                try
                {
                    credit = Integer.parseInt(creditStr.trim());

                    if (credit < 1 || credit > 10)
                    {
                        response.getWriter().print(
                                "{\"status\":\"error\",\"message\":\"Credit must be between 1 and 10\"}");
                        return;
                    }
                }
                catch (NumberFormatException e)
                {
                    response.getWriter().print(
                            "{\"status\":\"error\",\"message\":\"Credit must be a valid number between 1 and 10\"}");
                    return;
                }
            }

            // ADD
            if ("add".equals(action))
            {
                Subject subject = new Subject(
                        code,
                        name,
                        course,
                        department,
                        semester,
                        year,
                        credit);

                subjectService.saveSubject(subject);

                response.getWriter().print(
                        "{\"status\":\"success\",\"message\":\"Subject added\"}");

                return;
            }

            // EDIT / UPDATE
            if ("update".equals(action) || "edit".equals(action))
            {
                int id = Integer.parseInt(request.getParameter("id"));

                Subject subject = subjectService.getSubjectById(id);

                if (subject != null)
                {
                    subject.setSubjectCode(code);
                    subject.setSubjectName(name);
                    subject.setCourse(course);
                    subject.setDepartment(department);
                    subject.setSemester(semester);
                    subject.setYear(year);
                    subject.setCredit(credit);

                    subjectService.updateSubject(subject);

                    response.getWriter().print(
                            "{\"status\":\"success\",\"message\":\"Subject updated successfully\"}");
                }
                else
                {
                    response.getWriter().print(
                            "{\"status\":\"error\",\"message\":\"Subject not found with ID: " + id + "\"}");
                }

                return;
            }

            response.getWriter().print(
                    "{\"status\":\"error\",\"message\":\"Invalid action\"}");
        }
        catch (Exception e)
        {
            e.printStackTrace();

            response.getWriter().print(
                    "{\"status\":\"error\",\"message\":\"Operation failed\"}");
        }
    }

    // Clean JSON value
    private String clean(String value)
    {
        if (value == null)
        {
            return "";
        }

        return value.replace("\"", "\\\"");
    }
}