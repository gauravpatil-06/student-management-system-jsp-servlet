package com.student.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "student_subject_marks")
@Getter
@Setter
public class StudentSubjectMarks
{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    public StudentSubjectMarks()
    {
    }

    @ManyToOne
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @ManyToOne
    @JoinColumn(name = "subject_id", nullable = false)
    private Subject subject;

    @ManyToOne
    @JoinColumn(name = "teacher_id", nullable = false)
    private Teacher teacher;

    private double cce1Marks;
    private double cce2Marks;
    private double cce3Marks;
    private double cce4Marks;
    private double cce5Marks;

    private double attendance1Marks;
    private double attendance2Marks;
    private double attendance3Marks;
    private double attendance4Marks;
    private double attendance5Marks;

    private double internalMarks;
    private double endSemesterMarks;
    private double totalMarks;
    private double percentage;
    private String grade;
    private String resultStatus;

    public int getId()
    {
        return id;
    }

    public void setId(int id)
    {
        this.id = id;
    }

    public Student getStudent()
    {
        return student;
    }

    public void setStudent(Student student)
    {
        this.student = student;
    }

    public Subject getSubject()
    {
        return subject;
    }

    public void setSubject(Subject subject)
    {
        this.subject = subject;
    }

    public Teacher getTeacher()
    {
        return teacher;
    }

    public void setTeacher(Teacher teacher)
    {
        this.teacher = teacher;
    }

    public double getCce1Marks()
    {
        return cce1Marks;
    }

    public void setCce1Marks(double cce1Marks)
    {
        this.cce1Marks = cce1Marks;
    }

    public double getCce2Marks()
    {
        return cce2Marks;
    }

    public void setCce2Marks(double cce2Marks)
    {
        this.cce2Marks = cce2Marks;
    }

    public double getCce3Marks()
    {
        return cce3Marks;
    }

    public void setCce3Marks(double cce3Marks)
    {
        this.cce3Marks = cce3Marks;
    }

    public double getCce4Marks()
    {
        return cce4Marks;
    }

    public void setCce4Marks(double cce4Marks)
    {
        this.cce4Marks = cce4Marks;
    }

    public double getCce5Marks()
    {
        return cce5Marks;
    }

    public void setCce5Marks(double cce5Marks)
    {
        this.cce5Marks = cce5Marks;
    }

    public double getAttendance1Marks()
    {
        return attendance1Marks;
    }

    public void setAttendance1Marks(double attendance1Marks)
    {
        this.attendance1Marks = attendance1Marks;
    }

    public double getAttendance2Marks()
    {
        return attendance2Marks;
    }

    public void setAttendance2Marks(double attendance2Marks)
    {
        this.attendance2Marks = attendance2Marks;
    }

    public double getAttendance3Marks()
    {
        return attendance3Marks;
    }

    public void setAttendance3Marks(double attendance3Marks)
    {
        this.attendance3Marks = attendance3Marks;
    }

    public double getAttendance4Marks()
    {
        return attendance4Marks;
    }

    public void setAttendance4Marks(double attendance4Marks)
    {
        this.attendance4Marks = attendance4Marks;
    }

    public double getAttendance5Marks()
    {
        return attendance5Marks;
    }

    public void setAttendance5Marks(double attendance5Marks)
    {
        this.attendance5Marks = attendance5Marks;
    }

    public double getInternalMarks()
    {
        return internalMarks;
    }

    public void setInternalMarks(double internalMarks)
    {
        this.internalMarks = internalMarks;
    }

    public double getEndSemesterMarks()
    {
        return endSemesterMarks;
    }

    public void setEndSemesterMarks(double endSemesterMarks)
    {
        this.endSemesterMarks = endSemesterMarks;
    }

    public double getTotalMarks()
    {
        return totalMarks;
    }

    public void setTotalMarks(double totalMarks)
    {
        this.totalMarks = totalMarks;
    }

    public double getPercentage()
    {
        return percentage;
    }

    public void setPercentage(double percentage)
    {
        this.percentage = percentage;
    }

    public String getGrade()
    {
        return grade;
    }

    public void setGrade(String grade)
    {
        this.grade = grade;
    }

    public String getResultStatus()
    {
        return resultStatus;
    }

    public void setResultStatus(String resultStatus)
    {
        this.resultStatus = resultStatus;
    }
}