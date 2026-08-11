package com.student.dao;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.student.entity.Teacher;
import com.student.util.HibernateUtil;

public class TeacherDAO
{
    // Save teacher record to the database
    public void saveTeacher(Teacher teacher)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = session.beginTransaction();

        session.save(teacher);

        transaction.commit();
        session.close();
    }

    public Teacher getTeacherByUsernameOrEmail(String login)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();

        Teacher teacher = session.createQuery(
                "from Teacher where username = :login or email = :login",
                Teacher.class)
                .setParameter("login", login)
                .uniqueResult();

        session.close();

        return teacher;
    }

    // Fetch all teacher records from the database
    public java.util.List<Teacher> getAllTeachers()
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        java.util.List<Teacher> list = session.createQuery("from Teacher", Teacher.class).list();
        session.close();
        return list;
    }

    public long getTeacherCount()
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Long count = session.createQuery("select count(t.id) from Teacher t", Long.class).uniqueResult();
        session.close();
        return count != null ? count : 0;
    }

    // Fetch teacher details by ID from the database
    public Teacher getTeacherById(int id)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Teacher teacher = session.get(Teacher.class, id);
        session.close();
        return teacher;
    }

    // Update teacher details in the database
    public void updateTeacher(Teacher teacher)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = session.beginTransaction();
        session.update(teacher);
        transaction.commit();
        session.close();
    }

    // Delete teacher record from the database
    public void deleteTeacher(int id)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = null;
        try
        {
            transaction = session.beginTransaction();
            session.createNativeQuery("DELETE FROM student_subject_assignment WHERE teacher_id = :tId")
                    .setParameter("tId", id)
                    .executeUpdate();
            session.createNativeQuery("DELETE FROM teacher_subject WHERE teacher_id = :tId")
                    .setParameter("tId", id)
                    .executeUpdate();
            Teacher teacher = session.get(Teacher.class, id);
            if (teacher != null)
            {
                session.delete(teacher);
            }
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
}