package com.student.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.student.entity.Student;
import com.student.entity.Teacher;
import com.student.service.StudentService;
import com.student.service.TeacherService;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet
{
    private StudentService studentService = new StudentService();
    private TeacherService teacherService = new TeacherService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
            {
        response.sendRedirect(request.getContextPath() + "/register.jsp");
    }

    @Override
    // Register new user account in the database
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
            {
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");

        // Determine redirect targets based on redirectUrl parameter or admin session
        String redirectUrl = request.getParameter("redirectUrl");
        if ((redirectUrl == null || redirectUrl.trim().isEmpty())
                && request.getSession().getAttribute("admin") != null)
                {
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.isEmpty())
            {
                redirectUrl = referer;
            } else
            {
                redirectUrl = request.getContextPath() + "/admin/dashboard.jsp";
            }
        }

        boolean isCustomRedirect = (redirectUrl != null && !redirectUrl.trim().isEmpty());
        String successTarget = isCustomRedirect ? redirectUrl : request.getContextPath() + "/login.jsp";
        String errorTarget = isCustomRedirect ? redirectUrl : request.getContextPath() + "/register.jsp";

        if (fullName == null || username == null || email == null || password == null || confirmPassword == null
                || role == null)
                {
            String target = successOrErrorUrl(errorTarget, "error", "Please fill all required fields");
            response.sendRedirect(target);
            return;
        }

        if (!password.equals(confirmPassword))
        {
            String target = successOrErrorUrl(errorTarget, "error", "Passwords do not match");
            response.sendRedirect(target);
            return;
        }

        String gender = request.getParameter("gender");
        if (gender == null || gender.trim().isEmpty())
        {
            gender = "Male";
        }

        if (role.equalsIgnoreCase("Student"))
        {
            String rollNo = request.getParameter("rollNumber");
            String phone = request.getParameter("phone");
            String course = request.getParameter("course");
            String department = request.getParameter("department");
            String semester = request.getParameter("semester");
            if (semester == null || semester.trim().isEmpty())
            {
                semester = "Semester 5";
            }
            String year = request.getParameter("year");
            if (year == null || year.trim().isEmpty())
            {
                year = "Third Year";
            }

            Student student = new Student(fullName, rollNo, username, password, email, phone, course, department,
                    semester, year, gender);

            studentService.saveStudent(student);
            String target = successOrErrorUrl(successTarget, "success", "Student registered successfully");
            response.sendRedirect(target);
        } else if (role.equalsIgnoreCase("Teacher"))
        {
            String phone = request.getParameter("teacherPhone");
            String department = request.getParameter("teacherDepartment");

            Teacher teacher = new Teacher(fullName, username, password, email, phone, department, gender);

            teacherService.saveTeacher(teacher);
            String target = successOrErrorUrl(successTarget, "success", "Teacher registered successfully");
            response.sendRedirect(target);
        } else
        {
            String target = successOrErrorUrl(errorTarget, "error", "Invalid role");
            response.sendRedirect(target);
        }
    }

    private String successOrErrorUrl(String baseUrl, String paramName, String message)
    {
        String separator = baseUrl.contains("?") ? "&" : "?";
        return baseUrl + separator + paramName + "="
                + java.net.URLEncoder.encode(message, java.nio.charset.StandardCharsets.UTF_8);
    }
}