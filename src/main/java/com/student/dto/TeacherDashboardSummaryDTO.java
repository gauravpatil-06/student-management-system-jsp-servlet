package com.student.dto;

import java.text.DecimalFormat;

public class TeacherDashboardSummaryDTO
{
    private int subjectCount;
    private long assignedStudentCount;
    private Double averagePerformance;
    private Double averageAttendance;

    private static final DecimalFormat df = new DecimalFormat("0.0");

    public TeacherDashboardSummaryDTO()
    {
    }

    public TeacherDashboardSummaryDTO(int subjectCount, long assignedStudentCount, Double averagePerformance,
            Double averageAttendance)
    {
        this.subjectCount = subjectCount;
        this.assignedStudentCount = assignedStudentCount;
        this.averagePerformance = averagePerformance;
        this.averageAttendance = averageAttendance;
    }

    public int getSubjectCount()
    {
        return subjectCount;
    }

    public void setSubjectCount(int subjectCount)
    {
        this.subjectCount = subjectCount;
    }

    public long getAssignedStudentCount()
    {
        return assignedStudentCount;
    }

    public void setAssignedStudentCount(long assignedStudentCount)
    {
        this.assignedStudentCount = assignedStudentCount;
    }

    public Double getAveragePerformance()
    {
        return averagePerformance;
    }

    public void setAveragePerformance(Double averagePerformance)
    {
        this.averagePerformance = averagePerformance;
    }

    public Double getAverageAttendance()
    {
        return averageAttendance;
    }

    public void setAverageAttendance(Double averageAttendance)
    {
        this.averageAttendance = averageAttendance;
    }

    public String getAveragePerformanceFormatted()
    {
        if (averagePerformance == null)
        {
            return "0.0%";
        }
        return df.format(averagePerformance) + "%";
    }

    public String getAverageAttendanceFormatted()
    {
        if (averageAttendance == null)
        {
            return "0.0%";
        }
        return df.format(averageAttendance) + "%";
    }
}
