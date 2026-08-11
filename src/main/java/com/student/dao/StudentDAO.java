package com.student.dao;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.student.entity.Student;
import com.student.util.HibernateUtil;

public class StudentDAO
{
    // Save student record to the database
    public void saveStudent(Student student)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = session.beginTransaction();

        session.save(student);

        transaction.commit();
        session.close();
    }

    public Student getStudentByUsernameOrEmail(String login)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();

        Student student = session.createQuery(
                "from Student where username = :login or email = :login",
                Student.class)
                .setParameter("login", login)
                .uniqueResult();

        session.close();
        return student;
    }

    // Fetch all student records from the database
    public java.util.List<Student> getAllStudents()
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        java.util.List<Student> list = session.createQuery("from Student", Student.class).list();
        session.close();
        return list;
    }

    public long getStudentCount()
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Long count = session.createQuery("select count(s.id) from Student s", Long.class).uniqueResult();
        session.close();
        return count != null ? count : 0;
    }

    // Fetch student details by ID from the database
    public Student getStudentById(int id)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Student student = session.get(Student.class, id);
        session.close();
        return student;
    }

    // Update student details in the database
    public void updateStudent(Student student)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = session.beginTransaction();
        session.update(student);
        transaction.commit();
        session.close();
    }

    // Delete student record from the database
    public void deleteStudent(int id)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = session.beginTransaction();
        Student student = session.get(Student.class, id);
        if (student != null)
        {
            session.delete(student);
        }
        transaction.commit();
        session.close();
    }
}