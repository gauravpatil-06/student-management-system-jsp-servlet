package com.student.service;

import java.util.List;
import com.student.dao.SubjectDAO;
import com.student.entity.Subject;

public class SubjectService
{
    private SubjectDAO subjectDAO = new SubjectDAO();

    public void saveSubject(Subject subject)
    {
        subjectDAO.saveSubject(subject);
    }

    public List<Subject> getAllSubjects()
    {
        return subjectDAO.getAllSubjects();
    }

    public long getSubjectCount()
    {
        return subjectDAO.getSubjectCount();
    }

    public Subject getSubjectById(int id)
    {
        return subjectDAO.getSubjectById(id);
    }

    public void updateSubject(Subject subject)
    {
        subjectDAO.updateSubject(subject);
    }

    public void deleteSubject(int id)
    {
        subjectDAO.deleteSubject(id);
    }
}
