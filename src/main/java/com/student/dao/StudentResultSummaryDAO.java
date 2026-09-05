package com.student.dao;

import java.util.Collections;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.student.entity.StudentResultSummary;
import com.student.util.HibernateUtil;

public class StudentResultSummaryDAO
{

    public boolean save(StudentResultSummary summary)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try
        {
            tx = session.beginTransaction();
            session.save(summary);
            tx.commit();
            return true;
        }
        catch (Exception e)
        {
            if (tx != null)
                tx.rollback();
            e.printStackTrace();
            return false;
        }
        finally
        {
            session.close();
        }
    }

    public boolean update(StudentResultSummary summary)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try
        {
            tx = session.beginTransaction();
            session.update(summary);
            tx.commit();
            return true;
        }
        catch (Exception e)
        {
            if (tx != null)
                tx.rollback();
            e.printStackTrace();
            return false;
        }
        finally
        {
            session.close();
        }
    }

    // Save or update student result summary in the database
    public boolean saveOrUpdate(StudentResultSummary summary)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try
        {
            tx = session.beginTransaction();
            session.saveOrUpdate(summary);
            tx.commit();
            return true;
        }
        catch (Exception e)
        {
            if (tx != null)
                tx.rollback();
            e.printStackTrace();
            return false;
        }
        finally
        {
            session.close();
        }
    }

    public StudentResultSummary findByStudentAndSemester(int studentId, String semester)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try
        {
            List<StudentResultSummary> list = session.createQuery(
                    "from StudentResultSummary s " +
                            "join fetch s.student " +
                            "where s.student.id = :stId and s.semester = :sem",
                    StudentResultSummary.class)
                    .setParameter("stId", studentId)
                    .setParameter("sem", semester)
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

    public List<StudentResultSummary> findAllByStudent(int studentId)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try
        {
            return session.createQuery(
                    "from StudentResultSummary s " +
                            "join fetch s.student " +
                            "where s.student.id = :stId",
                    StudentResultSummary.class)
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
}
