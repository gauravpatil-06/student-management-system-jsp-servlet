package com.student.dao;

import java.util.Collections;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.student.entity.Subject;
import com.student.util.HibernateUtil;

public class SubjectDAO
{
    // Save subject entity to the database
    public void saveSubject(Subject subject)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = null;

        try
        {
            transaction = session.beginTransaction();

            session.save(subject);

            transaction.commit();

            System.out.println("Subject saved successfully: "
                    + subject.getSubjectCode());
        }
        catch (Exception e)
        {
            if (transaction != null && transaction.isActive())
            {
                transaction.rollback();
            }

            e.printStackTrace();
        }
        finally
        {
            session.close();
        }
    }

    // Fetch all subjects from the database
    public List<Subject> getAllSubjects()
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = null;

        try
        {
            transaction = session.beginTransaction();

            List<Subject> subjects = session
                    .createQuery("from Subject order by id asc", Subject.class)
                    .list();

            transaction.commit();

            return subjects;
        }
        catch (Exception e)
        {
            if (transaction != null && transaction.isActive())
            {
                transaction.rollback();
            }

            e.printStackTrace();

            return Collections.emptyList();
        }
        finally
        {
            session.close();
        }
    }

    public long getSubjectCount()
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try
        {
            Long count = session.createQuery("select count(s.id) from Subject s", Long.class).uniqueResult();
            return count != null ? count : 0;
        }
        finally
        {
            session.close();
        }
    }

    // Fetch subject details by ID from the database
    public Subject getSubjectById(int id)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();

        try
        {
            return session.get(Subject.class, id);
        }
        finally
        {
            session.close();
        }
    }

    // Update subject details in the database
    public void updateSubject(Subject subject)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = null;

        try
        {
            transaction = session.beginTransaction();

            session.update(subject);

            transaction.commit();

            System.out.println("Subject updated successfully: "
                    + subject.getId());
        }
        catch (Exception e)
        {
            if (transaction != null && transaction.isActive())
            {
                transaction.rollback();
            }

            e.printStackTrace();
        }
        finally
        {
            session.close();
        }
    }

    // Delete subject entity from the database
    public void deleteSubject(int id)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = null;

        try
        {
            transaction = session.beginTransaction();

            // Delete Teacher-Subject relationship
            session.createQuery(
                    "delete from TeacherSubject where subject.id = :sid")
                    .setParameter("sid", id)
                    .executeUpdate();

            // Delete Student-Subject relationship
            session.createQuery(
                    "delete from StudentSubjectMarks where subject.id = :sid")
                    .setParameter("sid", id)
                    .executeUpdate();

            Subject subject = session.get(Subject.class, id);

            // Delete Subject
            if (subject != null)
            {
                session.delete(subject);
            }

            transaction.commit();

            System.out.println("Subject deleted successfully: " + id);
        }
        catch (Exception e)
        {
            if (transaction != null && transaction.isActive())
            {
                transaction.rollback();
            }

            e.printStackTrace();
        }
        finally
        {
            session.close();
        }
    }
}