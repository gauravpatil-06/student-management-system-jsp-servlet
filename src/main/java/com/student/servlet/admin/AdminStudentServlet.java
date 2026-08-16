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
import com.student.entity.Student;
import com.student.service.StudentService;

@WebServlet("/api/admin/students")
public class AdminStudentServlet extends HttpServlet
{
    private StudentService studentService = new StudentService();

    // GET - Fetch all students directly from DB
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

        List<Student> students = studentService.getAllStudents();
        StringBuilder json = new StringBuilder("[");

        for (int i = 0; i < students.size(); i++)
        {
            Student s = students.get(i);
            String dept = s.getDepartment() != null ? s.getDepartment() : "";
            String sem = s.getSemester() != null ? s.getSemester() : "Semester 5";
            String year = s.getYear() != null ? s.getYear() : "Third Year";

            json.append("{");
            json.append("\"id\":").append(s.getId()).append(",");
            json.append("\"name\":\"").append(clean(s.getName())).append("\",");
            json.append("\"gender\":\"").append(clean(s.getGender() != null ? s.getGender() : "")).append("\",");
            json.append("\"rollNo\":\"").append(clean(s.getRollNo())).append("\",");
            json.append("\"username\":\"").append(clean(s.getUsername())).append("\",");
            json.append("\"email\":\"").append(clean(s.getEmail())).append("\",");
            json.append("\"phone\":\"").append(clean(s.getPhone())).append("\",");
            json.append("\"course\":\"").append(clean(s.getCourse())).append("\",");
            json.append("\"dept\":\"").append(clean(dept)).append("\",");
            json.append("\"department\":\"").append(clean(dept)).append("\",");
            json.append("\"sem\":\"").append(clean(sem)).append("\",");
            json.append("\"semester\":\"").append(clean(sem)).append("\",");
            json.append("\"year\":\"").append(clean(year)).append("\"");
            json.append("}");

            if (i < students.size() - 1)
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
            studentService.deleteStudent(id);
            response.getWriter().print("{\"status\":\"success\",\"message\":\"Student deleted\"}");
            return;
        }

        String dept = request.getParameter("department");
        if (dept == null || dept.isEmpty())
        {
            dept = request.getParameter("dept");
        }

        String semVal = request.getParameter("sem");
        if (semVal == null || semVal.trim().isEmpty())
        {
            semVal = request.getParameter("semester");
        }
        if (semVal == null || semVal.trim().isEmpty())
        {
            semVal = "Semester 5";
        }

        String yearVal = request.getParameter("year");
        if (yearVal == null || yearVal.trim().isEmpty())
        {
            yearVal = "Third Year";
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
            Student student = studentService.getStudentById(id);

            student.setName(request.getParameter("name"));
            student.setGender(gender);
            student.setRollNo(request.getParameter("rollNo"));
            student.setUsername(request.getParameter("username"));
            student.setEmail(request.getParameter("email"));
            student.setPhone(request.getParameter("phone"));
            student.setCourse(request.getParameter("course"));
            student.setDepartment(dept);
            student.setSemester(semVal);
            student.setYear(yearVal);

            studentService.updateStudent(student);
            response.getWriter().print("{\"status\":\"success\",\"message\":\"Student updated\"}");
            return;
        }

        // ADD
        if ("add".equals(action))
        {
            Student student = new Student();
            student.setName(request.getParameter("name"));
            student.setGender(gender);
            student.setRollNo(request.getParameter("rollNo"));
            student.setUsername(request.getParameter("username"));
            student.setPassword("123");
            student.setEmail(request.getParameter("email"));
            student.setPhone(request.getParameter("phone"));
            student.setCourse(request.getParameter("course"));
            student.setDepartment(dept);
            student.setSemester(semVal);
            student.setYear(yearVal);

            studentService.saveStudent(student);
            response.getWriter().print("{\"status\":\"success\",\"message\":\"Student added\"}");
        }
    }

    private String clean(String val)
    {
        if (val == null)
            return "";
        return val.replace("\"", "\\\"");
    }
}