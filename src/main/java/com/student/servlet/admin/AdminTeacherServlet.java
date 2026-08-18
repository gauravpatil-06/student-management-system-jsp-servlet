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
import com.student.entity.Teacher;
import com.student.service.TeacherService;

@WebServlet("/api/admin/teachers")
public class AdminTeacherServlet extends HttpServlet
{
    private TeacherService teacherService = new TeacherService();

    // GET - Fetch all teachers directly from DB
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

        List<Teacher> teachers = teacherService.getAllTeachers();
        StringBuilder json = new StringBuilder("[");

        for (int i = 0; i < teachers.size(); i++)
        {
            Teacher t = teachers.get(i);
            String dept = t.getDepartment() != null ? t.getDepartment() : "";

            json.append("{");
            json.append("\"id\":").append(t.getId()).append(",");
            json.append("\"name\":\"").append(t.getName() != null ? t.getName() : "").append("\",");
            json.append("\"gender\":\"").append(t.getGender() != null ? t.getGender() : "").append("\",");
            json.append("\"username\":\"").append(t.getUsername() != null ? t.getUsername() : "").append("\",");
            json.append("\"email\":\"").append(t.getEmail() != null ? t.getEmail() : "").append("\",");
            json.append("\"phone\":\"").append(t.getPhone() != null ? t.getPhone() : "").append("\",");
            json.append("\"course\":\"BTech\",");
            json.append("\"dept\":\"").append(dept).append("\",");
            json.append("\"department\":\"").append(dept).append("\"");
            json.append("}");

            if (i < teachers.size() - 1)
            {
                json.append(",");
            }
        }
        json.append("]");

        response.getWriter().print(json.toString());
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

        String action = request.getParameter("action");

        if ("delete".equals(action))
        {
            int id = Integer.parseInt(request.getParameter("id"));
            teacherService.deleteTeacher(id);
            response.getWriter().print("{\"status\":\"success\",\"message\":\"Teacher deleted\"}");
            return;
        }

        String dept = request.getParameter("department");
        if (dept == null || dept.isEmpty())
        {
            dept = request.getParameter("dept");
        }

        String gender = request.getParameter("gender");
        if (gender == null || gender.trim().isEmpty())
        {
            gender = "Male";
        }

        // EDIT
        if ("update".equals(action))
        {
            int id = Integer.parseInt(request.getParameter("id"));
            Teacher teacher = teacherService.getTeacherById(id);

            teacher.setName(request.getParameter("name"));
            teacher.setGender(gender);
            teacher.setUsername(request.getParameter("username"));
            teacher.setEmail(request.getParameter("email"));
            teacher.setPhone(request.getParameter("phone"));
            teacher.setDepartment(dept);

            teacherService.updateTeacher(teacher);
            response.getWriter().print("{\"status\":\"success\",\"message\":\"Teacher updated\"}");
            return;
        }

        // ADD
        if ("add".equals(action))
        {
            Teacher teacher = new Teacher(
                    request.getParameter("name"),
                    request.getParameter("username"),
                    "123",
                    request.getParameter("email"),
                    request.getParameter("phone"),
                    dept,
                    gender);

            teacherService.saveTeacher(teacher);
            response.getWriter().print("{\"status\":\"success\",\"message\":\"Teacher added\"}");
        }
    }
}