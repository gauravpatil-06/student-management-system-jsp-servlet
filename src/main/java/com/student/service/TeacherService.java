package com.student.service;

import com.student.dao.TeacherDAO;
import com.student.entity.Teacher;

public class TeacherService
{
    private TeacherDAO teacherDAO = new TeacherDAO();

    public void saveTeacher(Teacher teacher)
    {
        teacherDAO.saveTeacher(teacher);
    }

    public Teacher getTeacherByUsernameOrEmail(String login)
    {
        return teacherDAO.getTeacherByUsernameOrEmail(login);
    }

    public java.util.List<Teacher> getAllTeachers()
    {
        return teacherDAO.getAllTeachers();
    }

    public long getTeacherCount()
    {
        return teacherDAO.getTeacherCount();
    }

    public Teacher getTeacherById(int id)
    {
        return teacherDAO.getTeacherById(id);
    }

    public void updateTeacher(Teacher teacher)
    {
        teacherDAO.updateTeacher(teacher);
    }

    public void deleteTeacher(int id)
    {
        teacherDAO.deleteTeacher(id);
    }

    public com.student.dto.TeacherDashboardSummaryDTO getDashboardSummary(int teacherId)
    {
        TeacherSubjectService tsService = new TeacherSubjectService();
        StudentSubjectAssignmentService ssaService = new StudentSubjectAssignmentService();
        StudentSubjectMarksService marksService = new StudentSubjectMarksService();

        int subjectCount = tsService.getTeacherSubjectsByTeacherId(teacherId).size();
        long assignedStudentCount = ssaService.getUniqueStudentCountByTeacher(teacherId);
        Double averagePerformance = marksService.getAveragePerformanceByTeacher(teacherId);
        Double averageAttendance = marksService.getAverageAttendanceByTeacher(teacherId);

        return new com.student.dto.TeacherDashboardSummaryDTO(
                subjectCount,
                assignedStudentCount,
                averagePerformance,
                averageAttendance);
    }
}
