package com.student.dao;

import org.hibernate.Session;

import com.student.entity.Admin;
import com.student.util.HibernateUtil;

public class AdminDAO
{
    public Admin getAdminByUsernameOrEmail(String login)
    {
        Session session = HibernateUtil.getSessionFactory().openSession();

        Admin admin = session.createQuery(
                "from Admin where username = :login or email = :login",
                Admin.class)
                .setParameter("login", login)
                .uniqueResult();

        session.close();

        return admin;
    }
}