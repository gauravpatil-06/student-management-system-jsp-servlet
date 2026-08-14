package com.student.service;

import com.student.dao.AdminDAO;
import com.student.entity.Admin;

public class AdminService
{
    private AdminDAO adminDAO = new AdminDAO();

    public Admin getAdminByUsernameOrEmail(String login)
    {
        return adminDAO.getAdminByUsernameOrEmail(login);
    }
}