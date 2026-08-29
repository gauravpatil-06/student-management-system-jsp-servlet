package com.student.service;

import java.util.List;

import com.student.dao.StudentDAO;
import com.student.dao.StudentSubjectMarksDAO;
import com.student.dao.SubjectDAO;
import com.student.dao.TeacherDAO;
import com.student.entity.Student;
import com.student.entity.StudentSubjectMarks;
import com.student.entity.Subject;
import com.student.entity.Teacher;

public class StudentSubjectMarksService
{

    private StudentSubjectMarksDAO marksDAO = new StudentSubjectMarksDAO();
    private StudentDAO studentDAO = new StudentDAO();
    private SubjectDAO subjectDAO = new SubjectDAO();
    private TeacherDAO teacherDAO = new TeacherDAO();

    public StudentSubjectMarks getMarksByStudentSubjectTeacher(int studentId, int subjectId, int teacherId)
    {
        return marksDAO.getMarksByStudentSubjectTeacher(studentId, subjectId, teacherId);
    }

    public List<StudentSubjectMarks> getMarksByTeacherAndSubject(int teacherId, int subjectId)
    {
        return marksDAO.getMarksByTeacherAndSubject(teacherId, subjectId);
    }

    public StudentSubjectMarks getMarksByStudentAndSubject(int studentId, int subjectId)
    {
        return marksDAO.getMarksByStudentAndSubject(studentId, subjectId);
    }

    public List<StudentSubjectMarks> getMarksByStudent(int studentId)
    {
        return marksDAO.getMarksByStudent(studentId);
    }

    public Double getAveragePerformanceByTeacher(int teacherId)
    {
        return marksDAO.getAveragePerformanceByTeacher(teacherId);
    }

    public Double getAverageAttendanceByTeacher(int teacherId)
    {
        return marksDAO.getAverageAttendanceByTeacher(teacherId);
    }

    // Save CCE evaluation marks and recalculate student results
    public void saveCCEMarks(int studentId, int subjectId, int teacherId,
            double cce1Exam, double cce1Att,
            double cce2Exam, double cce2Att,
            double cce3Exam, double cce3Att,
            double cce4Exam, double cce4Att,
            double cce5Exam, double cce5Att)
    {

        StudentSubjectMarks mark = marksDAO.getMarksByStudentSubjectTeacher(studentId, subjectId, teacherId);
        if (mark == null)
        {
            mark = new StudentSubjectMarks();
            Student student = studentDAO.getStudentById(studentId);
            Subject subject = subjectDAO.getSubjectById(subjectId);
            Teacher teacher = teacherDAO.getTeacherById(teacherId);

            if (student == null || subject == null || teacher == null)
            {
                return;
            }

            mark.setStudent(student);
            mark.setSubject(subject);
            mark.setTeacher(teacher);
        }

        mark.setCce1Marks(cce1Exam);
        mark.setAttendance1Marks(cce1Att);

        mark.setCce2Marks(cce2Exam);
        mark.setAttendance2Marks(cce2Att);

        mark.setCce3Marks(cce3Exam);
        mark.setAttendance3Marks(cce3Att);

        mark.setCce4Marks(cce4Exam);
        mark.setAttendance4Marks(cce4Att);

        mark.setCce5Marks(cce5Exam);
        mark.setAttendance5Marks(cce5Att);

        // Calculate marks in Service Layer
        calculateInternalMarks(mark);
        calculateTotalMarks(mark);

        // Save via DAO
        marksDAO.saveOrUpdateMarks(mark);

        // Recalculate Student Result Summary
        try
        {
            new StudentResultSummaryService().calculateAndSaveSummary(studentId,
                    mark.getStudent() != null ? mark.getStudent().getSemester() : null);
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    // Save End-Semester examination marks and recalculate student results
    public void saveEndSemMarks(int studentId, int subjectId, int teacherId, double endSemMarks)
    {
        StudentSubjectMarks mark = marksDAO.getMarksByStudentSubjectTeacher(studentId, subjectId, teacherId);
        if (mark == null)
        {
            mark = new StudentSubjectMarks();
            Student student = studentDAO.getStudentById(studentId);
            Subject subject = subjectDAO.getSubjectById(subjectId);
            Teacher teacher = teacherDAO.getTeacherById(teacherId);

            if (student == null || subject == null || teacher == null)
            {
                return;
            }

            mark.setStudent(student);
            mark.setSubject(subject);
            mark.setTeacher(teacher);
        }

        mark.setEndSemesterMarks(endSemMarks);

        // Calculate total marks, percentage, grade, and status in Service Layer
        calculateTotalMarks(mark);

        // Save via DAO
        marksDAO.saveOrUpdateMarks(mark);

        // Recalculate Student Result Summary
        try
        {
            new StudentResultSummaryService().calculateAndSaveSummary(studentId,
                    mark.getStudent() != null ? mark.getStudent().getSemester() : null);
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    public double getCce1Total(StudentSubjectMarks mark)
    {
        return mark != null ? mark.getCce1Marks() + mark.getAttendance1Marks() : 0.0;
    }

    public double getCce2Total(StudentSubjectMarks mark)
    {
        return mark != null ? mark.getCce2Marks() + mark.getAttendance2Marks() : 0.0;
    }

    public double getCce3Total(StudentSubjectMarks mark)
    {
        return mark != null ? mark.getCce3Marks() + mark.getAttendance3Marks() : 0.0;
    }

    public double getCce4Total(StudentSubjectMarks mark)
    {
        return mark != null ? mark.getCce4Marks() + mark.getAttendance4Marks() : 0.0;
    }

    public double getCce5Total(StudentSubjectMarks mark)
    {
        return mark != null ? mark.getCce5Marks() + mark.getAttendance5Marks() : 0.0;
    }

    public void calculateInternalMarks(StudentSubjectMarks mark)
    {
        if (mark == null)
            return;
        double cce1Total = getCce1Total(mark);
        double cce2Total = getCce2Total(mark);
        double cce3Total = getCce3Total(mark);
        double cce4Total = getCce4Total(mark);
        double cce5Total = getCce5Total(mark);

        double internal = cce1Total + cce2Total + cce3Total + cce4Total + cce5Total;
        mark.setInternalMarks(internal);

        if (internal >= 20.0)
        {
            mark.setResultStatus("Pass");
        }
        else
        {
            mark.setResultStatus("Fail");
        }
    }

    public void calculateTotalMarks(StudentSubjectMarks mark)
    {
        if (mark == null)
            return;
        calculateInternalMarks(mark);
        double total = mark.getInternalMarks() + mark.getEndSemesterMarks();
        mark.setTotalMarks(total);

        double percentage = (total / 100.0) * 100.0;
        mark.setPercentage(percentage);

        if (percentage >= 90.0)
        {
            mark.setGrade("O");
        }
        else if (percentage >= 80.0)
        {
            mark.setGrade("A+");
        }
        else if (percentage >= 70.0)
        {
            mark.setGrade("A");
        }
        else if (percentage >= 60.0)
        {
            mark.setGrade("B+");
        }
        else if (percentage >= 50.0)
        {
            mark.setGrade("B");
        }
        else if (percentage >= 40.0)
        {
            mark.setGrade("C");
        }
        else if (percentage >= 35.0)
        {
            mark.setGrade("D");
        }
        else
        {
            mark.setGrade("F");
        }

        if (mark.getInternalMarks() >= 20.0 && (mark.getEndSemesterMarks() >= 20.0 || total >= 40.0))
        {
            mark.setResultStatus("Pass");
        }
        else
        {
            mark.setResultStatus("Fail");
        }
    }
}
