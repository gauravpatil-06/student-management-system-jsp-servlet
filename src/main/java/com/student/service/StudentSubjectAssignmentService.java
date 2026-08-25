package com.student.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.student.dao.StudentSubjectAssignmentDAO;
import com.student.entity.StudentSubjectAssignment;

public class StudentSubjectAssignmentService
{

    private StudentSubjectAssignmentDAO dao = new StudentSubjectAssignmentDAO();

    public List<StudentSubjectAssignment> getAssignmentsByTeacherAndSubject(int teacherId, int subjectId)
    {
        return dao.getAssignmentsByTeacherAndSubject(teacherId, subjectId);
    }

    public List<StudentSubjectAssignment> getAssignmentsByTeacher(int teacherId)
    {
        return dao.getAssignmentsByTeacher(teacherId);
    }

    public List<StudentSubjectAssignment> getAssignmentsByStudent(int studentId)
    {
        return dao.getAssignmentsByStudent(studentId);
    }

    public long getAssignedCount(int teacherId, int subjectId)
    {
        return dao.getAssignedCount(teacherId, subjectId);
    }

    public long getUniqueStudentCountByTeacher(int teacherId)
    {
        return dao.getUniqueStudentCountByTeacher(teacherId);
    }

    public void save(StudentSubjectAssignment ssa)
    {
        dao.save(ssa);
    }

    public void deleteByTeacherAndSubject(int teacherId, int subjectId)
    {
        dao.deleteByTeacherAndSubject(teacherId, subjectId);
    }

    public void deleteByTeacherId(int teacherId)
    {
        dao.deleteByTeacherId(teacherId);
    }

    // Retrieve assignment counts per subject for a teacher as a Map<Long, Long>
    // (subjectId -> count)
    public Map<Long, Long> getAssignedCountsByTeacher(int teacherId)
    {
        List<Object[]> rawList = dao.getAssignedCountsByTeacher(teacherId);
        Map<Long, Long> countsMap = new HashMap<>();
        if (rawList != null)
        {
            for (Object[] row : rawList)
            {
                if (row != null && row.length >= 2 && row[0] != null && row[1] != null)
                {
                    Long subjectId = ((Number) row[0]).longValue();
                    Long count = ((Number) row[1]).longValue();
                    countsMap.put(subjectId, count);
                }
            }
        }
        return countsMap;
    }

    public void syncStudentAssignments(int teacherId, int subjectId, List<Integer> studentIds)
    {
        dao.syncStudentAssignments(teacherId, subjectId, studentIds);
    }
}
