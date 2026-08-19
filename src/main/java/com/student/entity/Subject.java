package com.student.entity;

import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "subject")
@Getter
@Setter
public class Subject
{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String subjectCode;

    private String subjectName;

    private String course;

    private String department;

    private String semester;

    private String year;

    @Column(name = "credit")
    private Integer credit;

    @OneToMany(mappedBy = "subject", cascade = CascadeType.ALL)
    private List<TeacherSubject> teachers;

    @OneToMany(mappedBy = "subject")
    private List<StudentSubjectMarks> studentMarks;

    public Subject()
    {
    }

    // Existing constructor - kept unchanged
    public Subject(String subjectCode, String subjectName, String course,
            String department, String semester, String year)
    {

        this.subjectCode = subjectCode;
        this.subjectName = subjectName;
        this.course = course;
        this.department = department;
        this.semester = semester;
        this.year = year;
    }

    // New constructor with credit
    public Subject(String subjectCode, String subjectName, String course,
            String department, String semester, String year,
            Integer credit)
    {

        this.subjectCode = subjectCode;
        this.subjectName = subjectName;
        this.course = course;
        this.department = department;
        this.semester = semester;
        this.year = year;
        this.credit = credit;
    }

    public int getId()
    {
        return id;
    }

    public void setId(int id)
    {
        this.id = id;
    }

    public String getSubjectCode()
    {
        return subjectCode;
    }

    public void setSubjectCode(String subjectCode)
    {
        this.subjectCode = subjectCode;
    }

    public String getSubjectName()
    {
        return subjectName;
    }

    public void setSubjectName(String subjectName)
    {
        this.subjectName = subjectName;
    }

    // Course
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

    // Year
    public String getYear()
    {
        return year;
    }

    public void setYear(String year)
    {
        this.year = year;
    }

    // Credit
    public Integer getCredit()
    {
        return credit;
    }

    public void setCredit(Integer credit)
    {
        this.credit = credit;
    }

    // Teachers
    public List<TeacherSubject> getTeachers()
    {
        return teachers;
    }

    public void setTeachers(List<TeacherSubject> teachers)
    {
        this.teachers = teachers;
    }

    // Student Marks
    public List<StudentSubjectMarks> getStudentMarks()
    {
        return studentMarks;
    }

    public void setStudentMarks(List<StudentSubjectMarks> studentMarks)
    {
        this.studentMarks = studentMarks;
    }
}