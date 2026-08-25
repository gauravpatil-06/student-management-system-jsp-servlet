package com.student.dao;

import java.util.Collections;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.student.entity.Student;
import com.student.entity.StudentSubjectAssignment;
import com.student.entity.Subject;
import com.student.entity.Teacher;
import com.student.util.HibernateUtil;

public class StudentSubjectAssignmentDAO
{

    public List<StudentSubjectAssignment> getAssignmentsByTeacherAndSubject(int teacherId, int subjectId)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try
        {
            return session.createQuery(
                    "from StudentSubjectAssignment ssa " +
                            "join fetch ssa.student " +
                            "join fetch ssa.subject " +
                            "join fetch ssa.teacher " +
                            "where ssa.teacher.id = :teacherId and ssa.subject.id = :subjectId",
                    StudentSubjectAssignment.class)
                    .setParameter("teacherId", teacherId)
                    .setParameter("subjectId", subjectId)
                    .getResultList();
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return Collections.emptyList();
        }
        finally
        {
            session.close();
        }
    }

    public List<StudentSubjectAssignment> getAssignmentsByTeacher(int teacherId)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try
        {
            return session.createQuery(
                    "from StudentSubjectAssignment ssa " +
                            "join fetch ssa.student " +
                            "join fetch ssa.subject " +
                            "join fetch ssa.teacher " +
                            "where ssa.teacher.id = :teacherId",
                    StudentSubjectAssignment.class)
                    .setParameter("teacherId", teacherId)
                    .getResultList();
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return Collections.emptyList();
        }
        finally
        {
            session.close();
        }
    }

    public List<StudentSubjectAssignment> getAssignmentsByStudent(int studentId)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try
        {
            return session.createQuery(
                    "from StudentSubjectAssignment ssa " +
                            "left join fetch ssa.student " +
                            "left join fetch ssa.subject " +
                            "left join fetch ssa.teacher " +
                            "where ssa.student.id = :studentId",
                    StudentSubjectAssignment.class)
                    .setParameter("studentId", studentId)
                    .getResultList();
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return Collections.emptyList();
        }
        finally
        {
            session.close();
        }
    }

    public long getAssignedCount(int teacherId, int subjectId)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try
        {
            Long count = session.createQuery(
                    "select count(ssa.id) from StudentSubjectAssignment ssa " +
                            "where ssa.teacher.id = :teacherId and ssa.subject.id = :subjectId",
                    Long.class)
                    .setParameter("teacherId", teacherId)
                    .setParameter("subjectId", subjectId)
                    .uniqueResult();
            return count != null ? count : 0L;
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return 0L;
        }
        finally
        {
            session.close();
        }
    }

    // New method to retrieve counts per subject for a teacher in a single query
    public java.util.List<Object[]> getAssignedCountsByTeacher(int teacherId)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try
        {
            return session.createQuery(
                    "select ssa.subject.id, count(ssa.id) from StudentSubjectAssignment ssa " +
                            "where ssa.teacher.id = :teacherId group by ssa.subject.id",
                    Object[].class)
                    .setParameter("teacherId", teacherId)
                    .getResultList();
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return java.util.Collections.emptyList();
        }
        finally
        {
            session.close();
        }
    }

    public long getUniqueStudentCountByTeacher(int teacherId)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try
        {
            Long count = session.createQuery(
                    "select count(distinct ssa.student.id) from StudentSubjectAssignment ssa " +
                            "where ssa.teacher.id = :teacherId",
                    Long.class)
                    .setParameter("teacherId", teacherId)
                    .uniqueResult();
            return count != null ? count : 0L;
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return 0L;
        }
        finally
        {
            session.close();
        }
    }

    public void save(StudentSubjectAssignment ssa)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try
        {
            tx = session.beginTransaction();
            session.save(ssa);
            tx.commit();
        }
        catch (Exception e)
        {
            if (tx != null && tx.isActive())
                tx.rollback();
            e.printStackTrace();
        }
        finally
        {
            session.close();
        }
    }

    public void deleteByTeacherAndSubject(int teacherId, int subjectId)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try
        {
            tx = session.beginTransaction();
            session.createNativeQuery(
                    "DELETE FROM student_subject_assignment WHERE teacher_id = :tId AND subject_id = :sId")
                    .setParameter("tId", teacherId)
                    .setParameter("sId", subjectId)
                    .executeUpdate();
            tx.commit();
        }
        catch (Exception e)
        {
            if (tx != null && tx.isActive())
                tx.rollback();
            e.printStackTrace();
        }
        finally
        {
            session.close();
        }
    }

    public void deleteByTeacherId(int teacherId)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try
        {
            tx = session.beginTransaction();
            session.createNativeQuery("DELETE FROM student_subject_assignment WHERE teacher_id = :tId")
                    .setParameter("tId", teacherId)
                    .executeUpdate();
            tx.commit();
        }
        catch (Exception e)
        {
            if (tx != null && tx.isActive())
                tx.rollback();
            e.printStackTrace();
        }
        finally
        {
            session.close();
        }
    }

    public void syncStudentAssignments(int teacherId, int subjectId, List<Integer> targetStudentIds)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try
        {
            tx = session.beginTransaction();

            List<StudentSubjectAssignment> current = session.createQuery(
                    "from StudentSubjectAssignment ssa " +
                            "where ssa.teacher.id = :tId and ssa.subject.id = :sId",
                    StudentSubjectAssignment.class)
                    .setParameter("tId", teacherId)
                    .setParameter("sId", subjectId)
                    .getResultList();

            for (StudentSubjectAssignment ssa : current)
            {
                if (!targetStudentIds.contains(ssa.getStudent().getId()))
                {
                    session.delete(ssa);
                }
            }

            Teacher teacher = session.get(Teacher.class, teacherId);
            Subject subject = session.get(Subject.class, subjectId);

            for (Integer studentId : targetStudentIds)
            {
                boolean exists = current.stream().anyMatch(ssa -> ssa.getStudent().getId() == studentId);
                if (!exists)
                {
                    Student student = session.get(Student.class, studentId);
                    if (student != null && teacher != null && subject != null)
                    {
                        StudentSubjectAssignment newSsa = new StudentSubjectAssignment(student, subject, teacher);
                        session.save(newSsa);
                    }
                }
            }

            tx.commit();
        }
        catch (Exception e)
        {
            if (tx != null && tx.isActive())
                tx.rollback();
            e.printStackTrace();
        }
        finally
        {
            session.close();
        }
    }
}
