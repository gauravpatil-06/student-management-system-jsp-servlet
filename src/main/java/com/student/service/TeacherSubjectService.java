package com.student.service;

import java.util.List;

import com.student.dao.TeacherSubjectDAO;
import com.student.entity.TeacherSubject;

public class TeacherSubjectService
{

    private TeacherSubjectDAO teacherSubjectDAO = new TeacherSubjectDAO();

    public void saveTeacherSubject(TeacherSubject teacherSubject)
    {
        teacherSubjectDAO.saveTeacherSubject(teacherSubject);
    }

    public List<TeacherSubject> getAllTeacherSubjects()
    {
        return teacherSubjectDAO.getAllTeacherSubjects();
    }

    public List<TeacherSubject> getTeacherSubjectsByTeacherId(int teacherId)
    {
        return teacherSubjectDAO.getTeacherSubjectsByTeacherId(teacherId);
    }

    public TeacherSubject getByTeacherAndSubject(int teacherId, int subjectId)
    {
        return teacherSubjectDAO.getByTeacherAndSubject(teacherId, subjectId);
    }

    public void deleteTeacherSubject(int id)
    {
        teacherSubjectDAO.deleteTeacherSubject(id);
    }
}
