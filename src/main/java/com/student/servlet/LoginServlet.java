package com.student.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.student.dao.AdminDAO;
import com.student.dao.StudentDAO;
import com.student.dao.TeacherDAO;
import com.student.entity.Admin;
import com.student.entity.Student;
import com.student.entity.Teacher;

@WebServlet("/login")
public class LoginServlet extends HttpServlet
{

        private static final long serialVersionUID = 1L;

        private StudentDAO studentDAO;
        private TeacherDAO teacherDAO;
        private AdminDAO adminDAO;

        @Override
        public void init() throws ServletException
        {
                studentDAO = new StudentDAO();
                teacherDAO = new TeacherDAO();
                adminDAO = new AdminDAO();
        }

        @Override
        protected void doGet(
                        HttpServletRequest request,
                        HttpServletResponse response)
                        throws ServletException, IOException
                        {

                response.sendRedirect(
                                request.getContextPath() + "/login.jsp");
        }

        @Override
        // Validate login credentials and create user session
        protected void doPost(
                        HttpServletRequest request,
                        HttpServletResponse response)
                        throws ServletException, IOException
                        {

                String login = request.getParameter("username");
                String password = request.getParameter("password");
                String role = request.getParameter("role");

                if (login == null ||
                                password == null ||
                                role == null ||
                                login.trim().isEmpty() ||
                                password.trim().isEmpty())
                                {

                        response.sendRedirect(
                                        request.getContextPath()
                                                        + "/login.jsp?error=Please%20fill%20all%20fields");
                        return;
                }

                login = login.trim();
                role = role.trim();

                // STUDENT LOGIN

                if (role.equalsIgnoreCase("Student"))
                {

                        Student student = studentDAO.getStudentByUsernameOrEmail(login);

                        if (student != null &&
                                        student.getPassword() != null &&
                                        student.getPassword().equals(password))
                                        {

                                HttpSession session = request.getSession(true);

                                session.setMaxInactiveInterval(86400);

                                session.setAttribute("student", student);
                                session.setAttribute("role", "Student");

                                response.sendRedirect(
                                                request.getContextPath()
                                                                + "/student/dashboard.jsp");

                        } else
                        {

                                response.sendRedirect(
                                                request.getContextPath()
                                                                + "/login.jsp?error=Invalid%20username%2Femail%20or%20password");
                        }

                        return;
                }

                // TEACHER LOGIN

                if (role.equalsIgnoreCase("Teacher"))
                {

                        Teacher teacher = teacherDAO.getTeacherByUsernameOrEmail(login);

                        if (teacher != null &&
                                        teacher.getPassword() != null &&
                                        teacher.getPassword().equals(password))
                                        {

                                HttpSession session = request.getSession(true);

                                session.setMaxInactiveInterval(86400);

                                session.setAttribute("teacher", teacher);
                                session.setAttribute("role", "Teacher");

                                response.sendRedirect(
                                                request.getContextPath()
                                                                + "/teacher/dashboard.jsp");

                        } else
                        {

                                response.sendRedirect(
                                                request.getContextPath()
                                                                + "/login.jsp?error=Invalid%20username%2Femail%20or%20password");
                        }

                        return;
                }

                // ADMIN LOGIN

                if (role.equalsIgnoreCase("Admin"))
                {

                        Admin admin = adminDAO.getAdminByUsernameOrEmail(login);

                        if (admin != null &&
                                        admin.getPassword() != null &&
                                        admin.getPassword().equals(password))
                                        {

                                HttpSession session = request.getSession(true);

                                session.setMaxInactiveInterval(86400);

                                session.setAttribute("admin", admin);
                                session.setAttribute("role", "Admin");

                                response.sendRedirect(
                                                request.getContextPath()
                                                                + "/admin/dashboard.jsp");

                        } else
                        {

                                response.sendRedirect(
                                                request.getContextPath()
                                                                + "/login.jsp?error=Invalid%20username%2Femail%20or%20password");
                        }

                        return;
                }

                // INVALID ROLE

                response.sendRedirect(
                                request.getContextPath()
                                                + "/login.jsp?error=Invalid%20role");
        }
}