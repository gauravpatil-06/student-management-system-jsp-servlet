package com.student.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "student_result_summary")
public class StudentResultSummary 
{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @Column(name = "semester", nullable = false)
    private String semester;

    @Column(name = "total_marks")
    private double totalMarks;

    @Column(name = "max_marks")
    private double maxMarks;

    @Column(name = "percentage")
    private double percentage;

    @Column(name = "total_credits")
    private double totalCredits;

    @Column(name = "total_credit_points")
    private double totalCreditPoints;

    @Column(name = "sgpa")
    private double sgpa;

    @Column(name = "cgpa")
    private double cgpa;

    @Column(name = "final_grade")
    private String finalGrade;

    @Column(name = "result_status")
    private String resultStatus;

    public StudentResultSummary() 
    {
    	
    }
    
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

    public String getSemester()
    {
        return semester;
    }

    public void setSemester(String semester)
    {
        this.semester = semester;
    }

    public double getTotalMarks()
    {
        return totalMarks;
    }

    public void setTotalMarks(double totalMarks)
    {
        this.totalMarks = totalMarks;
    }

    public double getMaxMarks()
    {
        return maxMarks;
    }

    public void setMaxMarks(double maxMarks)
    {
        this.maxMarks = maxMarks;
    }

    public double getPercentage()
    {
        return percentage;
    }

    public void setPercentage(double percentage)
    {
        this.percentage = percentage;
    }

    public double getTotalCredits()
    {
        return totalCredits;
    }

    public void setTotalCredits(double totalCredits)
    {
        this.totalCredits = totalCredits;
    }

    public double getTotalCreditPoints()
    {
        return totalCreditPoints;
    }

    public void setTotalCreditPoints(double totalCreditPoints)
    {
        this.totalCreditPoints = totalCreditPoints;
    }

    public double getSgpa()
    {
        return sgpa;
    }

    public void setSgpa(double sgpa)
    {
        this.sgpa = sgpa;
    }

    public double getCgpa()
    {
        return cgpa;
    }

    public void setCgpa(double cgpa)
    {
        this.cgpa = cgpa;
    }

    public String getFinalGrade()
    {
        return finalGrade;
    }

    public void setFinalGrade(String finalGrade)
    {
        this.finalGrade = finalGrade;
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
