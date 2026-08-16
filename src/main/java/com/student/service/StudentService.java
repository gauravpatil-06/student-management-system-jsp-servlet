package com.student.service;

import com.student.dao.StudentDAO;
import com.student.entity.Student;

public class StudentService
{
    private StudentDAO studentDAO = new StudentDAO();

    public void saveStudent(Student student)
    {
        studentDAO.saveStudent(student);
    }

    public Student getStudentByUsernameOrEmail(String login)
    {
        return studentDAO.getStudentByUsernameOrEmail(login);
    }

    public java.util.List<Student> getAllStudents()
    {
        return studentDAO.getAllStudents();
    }

    public long getStudentCount()
    {
        return studentDAO.getStudentCount();
    }

    public Student getStudentById(int id)
    {
        return studentDAO.getStudentById(id);
    }

    public void updateStudent(Student student)
    {
        studentDAO.updateStudent(student);
    }

    public void deleteStudent(int id)
    {
        studentDAO.deleteStudent(id);
    }
}