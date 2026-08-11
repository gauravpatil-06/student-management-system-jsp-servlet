package com.student.util;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtil
{
    private static SessionFactory sessionFactory;

    static
    {
        try
        {
            String dbUrl = System.getenv("DB_URL");
            String dbUsername = System.getenv("DB_USERNAME");
            String dbPassword = System.getenv("DB_PASSWORD");

            if (dbUrl == null || dbUrl.trim().isEmpty())
            {
                throw new IllegalStateException("DB_URL environment variable is not set.");
            }

            if (dbUsername == null || dbUsername.trim().isEmpty())
            {
                throw new IllegalStateException("DB_USERNAME environment variable is not set.");
            }

            if (dbPassword == null || dbPassword.trim().isEmpty())
            {
                throw new IllegalStateException("DB_PASSWORD environment variable is not set.");
            }

            dbUrl = dbUrl.trim();

            if (dbUrl.startsWith("mysql://"))
            {
                dbUrl = "jdbc:" + dbUrl;
            }
            else if (!dbUrl.startsWith("jdbc:"))
            {
                dbUrl = "jdbc:mysql://" + dbUrl;
            }

            Configuration configuration = new Configuration();

            configuration.setProperty("hibernate.connection.driver_class", "com.mysql.cj.jdbc.Driver");
            configuration.setProperty("hibernate.connection.url", dbUrl);
            configuration.setProperty("hibernate.connection.username", dbUsername);
            configuration.setProperty("hibernate.connection.password", dbPassword);
            configuration.setProperty("hibernate.connection.allowPublicKeyRetrieval", "true");
            configuration.setProperty("hibernate.dialect", "org.hibernate.dialect.MySQLDialect");
            configuration.setProperty("hibernate.hbm2ddl.auto", "update");
            configuration.setProperty("hibernate.show_sql", "false");
            configuration.setProperty("hibernate.format_sql", "false");

            configuration.addAnnotatedClass(com.student.entity.Admin.class);
            configuration.addAnnotatedClass(com.student.entity.Teacher.class);
            configuration.addAnnotatedClass(com.student.entity.Student.class);
            configuration.addAnnotatedClass(com.student.entity.Subject.class);
            configuration.addAnnotatedClass(com.student.entity.TeacherSubject.class);
            configuration.addAnnotatedClass(com.student.entity.StudentSubjectMarks.class);
            configuration.addAnnotatedClass(com.student.entity.StudentSubjectAssignment.class);
            configuration.addAnnotatedClass(com.student.entity.StudentResultSummary.class);

            sessionFactory = configuration.buildSessionFactory();
        }
        catch (Throwable ex)
        {
            System.err.println("Initial SessionFactory creation failed: " + ex);
            ex.printStackTrace();

            throw new ExceptionInInitializerError(ex);
        }
    }

    public static SessionFactory getSessionFactory()
    {
        if (sessionFactory == null)
        {
            throw new IllegalStateException("Hibernate SessionFactory is not initialized.");
        }

        return sessionFactory;
    }
}