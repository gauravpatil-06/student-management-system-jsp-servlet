package com.student.entity;

import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Column;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "teacher")
@Getter
@Setter
public class Teacher
{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String name;
    private String username;
    private String password;
    private String email;
    private String phone;
    private String department;

    @Column(name = "gender", length = 20)
    private String gender;

    @OneToMany(mappedBy = "teacher", cascade = CascadeType.ALL)
    private List<TeacherSubject> subjects;

    @OneToMany(mappedBy = "teacher")
    private List<StudentSubjectMarks> studentMarks;

    public Teacher()
    {
    }

    public Teacher(String name, String username, String password, String email, String phone, String department)
    {
        this.name = name;
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.department = department;
        this.gender = "Male";
    }

    public Teacher(String name, String username, String password, String email, String phone, String department,
            String gender)
    {
        this.name = name;
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.department = department;
        this.gender = (gender != null && !gender.trim().isEmpty()) ? gender : "Male";
    }

    public int getId()
    {
        return id;
    }

    public void setId(int id)
    {
        this.id = id;
    }

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getUsername()
    {
        return username;
    }

    public void setUsername(String username)
    {
        this.username = username;
    }

    public String getPassword()
    {
        return password;
    }

    public void setPassword(String password)
    {
        this.password = password;
    }

    public String getEmail()
    {
        return email;
    }

    public void setEmail(String email)
    {
        this.email = email;
    }

    public String getPhone()
    {
        return phone;
    }

    public void setPhone(String phone)
    {
        this.phone = phone;
    }

    public String getDepartment()
    {
        return department;
    }

    public void setDepartment(String department)
    {
        this.department = department;
    }

    public String getGender()
    {
        return gender != null ? gender : "Male";
    }

    public void setGender(String gender)
    {
        this.gender = gender;
    }

    public List<TeacherSubject> getSubjects()
    {
        return subjects;
    }

    public void setSubjects(List<TeacherSubject> subjects)
    {
        this.subjects = subjects;
    }

    public List<StudentSubjectMarks> getStudentMarks()
    {
        return studentMarks;
    }

    public void setStudentMarks(List<StudentSubjectMarks> studentMarks)
    {
        this.studentMarks = studentMarks;
    }
}