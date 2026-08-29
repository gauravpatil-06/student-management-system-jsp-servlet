package com.student.servlet.teacher;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.student.dao.StudentSubjectAssignmentDAO;
import com.student.entity.Student;
import com.student.entity.StudentSubjectAssignment;
import com.student.entity.Subject;
import com.student.entity.Teacher;
import com.student.service.StudentSubjectMarksService;

@WebServlet("/teacher/save-cce-marks")
public class SaveCCEMarksServlet extends HttpServlet
{
    private static final long serialVersionUID = 1L;

    private StudentSubjectAssignmentDAO ssaDAO = new StudentSubjectAssignmentDAO();
    private StudentSubjectMarksService marksService = new StudentSubjectMarksService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {

        Teacher loggedInTeacher = (Teacher) request.getSession().getAttribute("teacher");
        if (loggedInTeacher == null)
        {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String subjectIdParam = request.getParameter("subjectId");
        if (subjectIdParam == null || subjectIdParam.trim().isEmpty())
        {
            response.sendRedirect(request.getContextPath() + "/teacher/cce-marks.jsp?error=invalid_subject");
            return;
        }

        int subjectId = 0;
        try
        {
            subjectId = Integer.parseInt(subjectIdParam);
        }
        catch (NumberFormatException e)
        {
            response.sendRedirect(request.getContextPath() + "/teacher/cce-marks.jsp?error=invalid_subject");
            return;
        }

        List<StudentSubjectAssignment> assignments = ssaDAO.getAssignmentsByTeacherAndSubject(loggedInTeacher.getId(),
                subjectId);

        for (StudentSubjectAssignment ssa : assignments)
        {
            Student student = ssa.getStudent();
            Subject subject = ssa.getSubject();
            if (student == null || subject == null)
                continue;

            int studentId = student.getId();

            double cce1Exam = parseDoubleOrDefault(request.getParameter("cce1_exam_" + studentId), 0.0);
            double cce1Att = parseDoubleOrDefault(request.getParameter("cce1_att_" + studentId), 0.0);

            double cce2Exam = parseDoubleOrDefault(request.getParameter("cce2_exam_" + studentId), 0.0);
            double cce2Att = parseDoubleOrDefault(request.getParameter("cce2_att_" + studentId), 0.0);

            double cce3Exam = parseDoubleOrDefault(request.getParameter("cce3_exam_" + studentId), 0.0);
            double cce3Att = parseDoubleOrDefault(request.getParameter("cce3_att_" + studentId), 0.0);

            double cce4Exam = parseDoubleOrDefault(request.getParameter("cce4_exam_" + studentId), 0.0);
            double cce4Att = parseDoubleOrDefault(request.getParameter("cce4_att_" + studentId), 0.0);

            double cce5Exam = parseDoubleOrDefault(request.getParameter("cce5_exam_" + studentId), 0.0);
            double cce5Att = parseDoubleOrDefault(request.getParameter("cce5_att_" + studentId), 0.0);

            // Delegate all calculation and persistence to Service Layer
            marksService.saveCCEMarks(studentId, subjectId, loggedInTeacher.getId(),
                    cce1Exam, cce1Att,
                    cce2Exam, cce2Att,
                    cce3Exam, cce3Att,
                    cce4Exam, cce4Att,
                    cce5Exam, cce5Att);
        }

        response.sendRedirect(
                request.getContextPath() + "/teacher/cce-marks.jsp?subjectId=" + subjectId + "&msg=saved");
    }

    private double parseDoubleOrDefault(String valStr, double defaultVal)
    {
        if (valStr == null || valStr.trim().isEmpty())
        {
            return defaultVal;
        }
        try
        {
            return Double.parseDouble(valStr.trim());
        }
        catch (Exception e)
        {
            return defaultVal;
        }
    }
}
