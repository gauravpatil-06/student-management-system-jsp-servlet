package com.student.entity;

import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "student")
@Getter
@Setter
public class Student
{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String name;
    private String rollNo;
    private String username;
    private String password;
    private String email;
    private String phone;
    private String course;
    private String department;

    private String semester;
    private String year;

    @jakarta.persistence.Column(name = "gender", length = 20)
    private String gender;

    @OneToMany(mappedBy = "student", cascade = CascadeType.ALL)
    private List<StudentSubjectMarks> subjectMarks;

    public Student()
    {
    }

    public Student(String name, String rollNo, String username, String password,
            String email, String phone, String course, String department,
            String semester, String year)
    {

        this.name = name;
        this.rollNo = rollNo;
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.course = course;
        this.department = department;
        this.semester = semester;
        this.year = year;
        this.gender = "Male";
    }

    public Student(String name, String rollNo, String username, String password,
            String email, String phone, String course, String department,
            String semester, String year, String gender)
    {

        this.name = name;
        this.rollNo = rollNo;
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.course = course;
        this.department = department;
        this.semester = semester;
        this.year = year;
        this.gender = (gender != null && !gender.trim().isEmpty())
                ? gender
                : "Male";
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

    public String getRollNo()
    {
        return rollNo;
    }

    public void setRollNo(String rollNo)
    {
        this.rollNo = rollNo;
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

    public String getCourse()
    {
        return course;
    }

    public void setCourse(String course)
    {
        this.course = course;
    }

    public String getDepartment()
    {
        return department;
    }

    public void setDepartment(String department)
    {
        this.department = department;
    }

    public String getSemester()
    {
        return semester;
    }

    public void setSemester(String semester)
    {
        this.semester = semester;
    }

    public String getYear()
    {
        return year;
    }

    public void setYear(String year)
    {
        this.year = year;
    }

    public String getGender()
    {
        return gender != null ? gender : "Male";
    }

    public void setGender(String gender)
    {
        this.gender = gender;
    }

    public List<StudentSubjectMarks> getSubjectMarks()
    {
        return subjectMarks;
    }

    public void setSubjectMarks(List<StudentSubjectMarks> subjectMarks)
    {
        this.subjectMarks = subjectMarks;
    }
}