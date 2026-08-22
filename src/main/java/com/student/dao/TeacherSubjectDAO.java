package com.student.dao;

import java.util.Collections;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.student.entity.TeacherSubject;
import com.student.util.HibernateUtil;

public class TeacherSubjectDAO
{

    // Save teacher subject mapping to the database
    public void saveTeacherSubject(TeacherSubject teacherSubject)
    {

        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = null;

        try
        {
            transaction = session.beginTransaction();

            session.save(teacherSubject);

            transaction.commit();

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

    // Fetch all teacher subject mappings from the database
    public List<TeacherSubject> getAllTeacherSubjects()
    {

        Session session = HibernateUtil.getSessionFactory().openSession();

        try
        {

            return session.createQuery(
                    "from TeacherSubject ts join fetch ts.teacher join fetch ts.subject order by ts.id asc",
                    TeacherSubject.class).list();

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

    // GET BY TEACHER ID
    public List<TeacherSubject> getTeacherSubjectsByTeacherId(int teacherId)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();

        try
        {
            return session.createQuery(
                    "from TeacherSubject ts " +
                            "join fetch ts.teacher " +
                            "join fetch ts.subject " +
                            "where ts.teacher.id = :teacherId " +
                            "order by ts.id asc",
                    TeacherSubject.class)
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

    // CHECK DUPLICATE
    public TeacherSubject getByTeacherAndSubject(
            int teacherId, int subjectId)
    {

        Session session = HibernateUtil.getSessionFactory().openSession();

        try
        {

            List<TeacherSubject> results = session.createQuery(
                    "from TeacherSubject ts join fetch ts.teacher join fetch ts.subject " +
                            "where ts.teacher.id = :teacherId " +
                            "and ts.subject.id = :subjectId",
                    TeacherSubject.class)
                    .setParameter("teacherId", teacherId)
                    .setParameter("subjectId", subjectId)
                    .getResultList();

            return results.isEmpty() ? null : results.get(0);

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

    // Delete teacher subject mapping from the database
    public void deleteTeacherSubject(int id)
    {

        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = null;

        try
        {

            transaction = session.beginTransaction();

            TeacherSubject ts = session.get(TeacherSubject.class, id);
            if (ts != null)
            {
                int teacherId = ts.getTeacher().getId();
                int subjectId = ts.getSubject().getId();

                session.createNativeQuery(
                        "DELETE FROM student_subject_assignment WHERE teacher_id = :tId AND subject_id = :sId")
                        .setParameter("tId", teacherId)
                        .setParameter("sId", subjectId)
                        .executeUpdate();

                session.delete(ts);
            }
            else
            {
                session.createNativeQuery("DELETE FROM teacher_subject WHERE id = :id")
                        .setParameter("id", id)
                        .executeUpdate();
            }

            transaction.commit();
            System.out.println("[TeacherSubjectDAO] Successfully deleted record id=" + id
                    + " and related student allocations from database.");

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