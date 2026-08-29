package com.student.dao;

import java.util.Collections;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.student.entity.StudentSubjectMarks;
import com.student.util.HibernateUtil;

public class StudentSubjectMarksDAO
{

    public StudentSubjectMarks getMarksByStudentSubjectTeacher(int studentId, int subjectId, int teacherId)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try
        {
            List<StudentSubjectMarks> list = session.createQuery(
                    "from StudentSubjectMarks m " +
                            "join fetch m.student " +
                            "join fetch m.subject " +
                            "join fetch m.teacher " +
                            "where m.student.id = :stId and m.subject.id = :subId and m.teacher.id = :tId",
                    StudentSubjectMarks.class)
                    .setParameter("stId", studentId)
                    .setParameter("subId", subjectId)
                    .setParameter("tId", teacherId)
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return null;
        }
        finally
        {
            session.close();
        }
    }

    public List<StudentSubjectMarks> getMarksByTeacherAndSubject(int teacherId, int subjectId)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try
        {
            return session.createQuery(
                    "from StudentSubjectMarks m " +
                            "join fetch m.student " +
                            "join fetch m.subject " +
                            "join fetch m.teacher " +
                            "where m.teacher.id = :tId and m.subject.id = :subId",
                    StudentSubjectMarks.class)
                    .setParameter("tId", teacherId)
                    .setParameter("subId", subjectId)
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

    public StudentSubjectMarks getMarksByStudentAndSubject(int studentId, int subjectId)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try
        {
            List<StudentSubjectMarks> list = session.createQuery(
                    "from StudentSubjectMarks m " +
                            "left join fetch m.student " +
                            "left join fetch m.subject " +
                            "left join fetch m.teacher " +
                            "where m.student.id = :stId and m.subject.id = :subId",
                    StudentSubjectMarks.class)
                    .setParameter("stId", studentId)
                    .setParameter("subId", subjectId)
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return null;
        }
        finally
        {
            session.close();
        }
    }

    public List<StudentSubjectMarks> getMarksByStudent(int studentId)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try
        {
            return session.createQuery(
                    "from StudentSubjectMarks m " +
                            "left join fetch m.student " +
                            "left join fetch m.subject " +
                            "left join fetch m.teacher " +
                            "where m.student.id = :stId",
                    StudentSubjectMarks.class)
                    .setParameter("stId", studentId)
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

    public Double getAveragePerformanceByTeacher(int teacherId)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try
        {
            Double avg = session.createQuery(
                    "select avg(m.percentage) from StudentSubjectMarks m " +
                            "where m.teacher.id = :tId",
                    Double.class)
                    .setParameter("tId", teacherId)
                    .uniqueResult();
            return avg;
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return null;
        }
        finally
        {
            session.close();
        }
    }

    public Double getAverageAttendanceByTeacher(int teacherId)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try
        {
            Double avg = session.createQuery(
                    "select avg((m.attendance1Marks + m.attendance2Marks + m.attendance3Marks + m.attendance4Marks + m.attendance5Marks) / 10.0 * 100.0) "
                            +
                            "from StudentSubjectMarks m " +
                            "where m.teacher.id = :tId",
                    Double.class)
                    .setParameter("tId", teacherId)
                    .uniqueResult();
            return avg;
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return null;
        }
        finally
        {
            session.close();
        }
    }

    public void saveOrUpdateMarks(StudentSubjectMarks marks)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try
        {
            tx = session.beginTransaction();
            session.saveOrUpdate(marks);
            tx.commit();
        }
        catch (Exception e)
        {
            if (tx != null && tx.isActive())
            {
                tx.rollback();
            }
            e.printStackTrace();
        }
        finally
        {
            session.close();
        }
    }
}
