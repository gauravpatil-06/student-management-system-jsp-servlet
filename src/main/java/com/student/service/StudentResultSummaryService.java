package com.student.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

import com.student.dao.StudentDAO;
import com.student.dao.StudentResultSummaryDAO;
import com.student.entity.Student;
import com.student.entity.StudentResultSummary;
import com.student.entity.StudentSubjectAssignment;
import com.student.entity.StudentSubjectMarks;
import com.student.entity.Subject;

public class StudentResultSummaryService
{

    private final StudentResultSummaryDAO summaryDAO = new StudentResultSummaryDAO();
    private final StudentDAO studentDAO = new StudentDAO();
    private final StudentSubjectAssignmentService assignmentService = new StudentSubjectAssignmentService();
    private final StudentSubjectMarksService marksService = new StudentSubjectMarksService();

    public static String calculateGrade(double marks)
    {
        if (marks >= 90)
            return "O";
        if (marks >= 80)
            return "A+";
        if (marks >= 70)
            return "A";
        if (marks >= 60)
            return "B+";
        if (marks >= 50)
            return "B";
        if (marks >= 40)
            return "C";
        if (marks >= 35)
            return "P";
        return "F";
    }

    public static int getGradePointFromGrade(String grade)
    {
        if (grade == null)
            return 0;
        switch (grade.trim().toUpperCase())
        {
            case "O":
                return 10;
            case "A+":
                return 9;
            case "A":
                return 8;
            case "B+":
                return 7;
            case "B":
                return 6;
            case "C":
                return 5;
            case "P":
                return 4;
            default:
                return 0;
        }
    }

    public static String getFinalGradeFromSgpa(double sgpa)
    {
        if (sgpa >= 9.0)
            return "O";
        if (sgpa >= 8.0)
            return "A+";
        if (sgpa >= 7.0)
            return "A";
        if (sgpa >= 6.0)
            return "B+";
        if (sgpa >= 5.0)
            return "B";
        if (sgpa >= 4.0)
            return "C";
        if (sgpa >= 3.5)
            return "P";
        if (sgpa > 0.0)
            return "F";
        return "--";
    }

    public StudentResultSummary calculateAndSaveSummary(int studentId, String semester)
    {
        Student student = studentDAO.getStudentById(studentId);
        if (student == null)
        {
            return null;
        }

        if (semester == null || semester.trim().isEmpty())
        {
            semester = student.getSemester() != null ? student.getSemester().trim() : "Semester 1";
        }

        List<StudentSubjectAssignment> assignments = assignmentService.getAssignmentsByStudent(studentId);
        List<StudentSubjectMarks> allMarksList = marksService.getMarksByStudent(studentId);

        double totalMarks = 0.0;
        double maxMarks = 0.0;
        double totalCredits = 0.0;
        double totalCreditPoints = 0.0;
        int enrolledCount = 0;
        int completedCount = 0;
        int failedCount = 0;

        if (assignments != null && !assignments.isEmpty())
        {
            for (StudentSubjectAssignment assign : assignments)
            {
                if (assign == null || assign.getSubject() == null)
                    continue;
                Subject sub = assign.getSubject();

                int credit = sub.getCredit();
                totalCredits += credit;
                enrolledCount++;
                maxMarks += 100.0;

                StudentSubjectMarks marks = null;
                if (allMarksList != null)
                {
                    for (StudentSubjectMarks m : allMarksList)
                    {
                        if (m != null && m.getSubject() != null && m.getSubject().getId() == sub.getId())
                        {
                            marks = m;
                            break;
                        }
                    }
                }

                boolean hasValidMarks = (marks != null && (marks.getTotalMarks() > 0
                        || (marks.getGrade() != null && !marks.getGrade().trim().isEmpty()
                                && !marks.getGrade().equalsIgnoreCase("N/A"))
                        || (marks.getResultStatus() != null && !marks.getResultStatus().trim().isEmpty()
                                && !marks.getResultStatus().equalsIgnoreCase("PENDING"))));

                if (hasValidMarks)
                {
                    completedCount++;
                    double obtained = marks.getTotalMarks();
                    totalMarks += obtained;

                    String grade = marks.getGrade();
                    if (grade == null || grade.trim().isEmpty() || grade.equalsIgnoreCase("--"))
                    {
                        grade = calculateGrade(obtained);
                    }

                    int gradePoint = getGradePointFromGrade(grade);
                    totalCreditPoints += (credit * gradePoint);

                    String status = marks.getResultStatus();
                    if ("FAIL".equalsIgnoreCase(status) || "FAILED".equalsIgnoreCase(status)
                            || "F".equalsIgnoreCase(grade))
                            {
                        failedCount++;
                    }
                }
            }
        }

        double percentage = maxMarks > 0 ? (totalMarks / maxMarks) * 100.0 : 0.0;
        percentage = roundToTwoDecimals(percentage);

        boolean isFullyCompleted = (enrolledCount > 0 && completedCount == enrolledCount);
        double sgpa = 0.0;
        if (isFullyCompleted && totalCredits > 0)
        {
            sgpa = roundToTwoDecimals(totalCreditPoints / totalCredits);
        }

        String resultStatus;
        if (enrolledCount == 0)
        {
            resultStatus = "Pending";
        } else if (failedCount > 0)
        {
            resultStatus = "Fail";
        } else if (completedCount == 0)
        {
            resultStatus = "Pending";
        } else if (completedCount < enrolledCount)
        {
            resultStatus = "Partial / Pending";
        } else
        {
            resultStatus = "Pass";
        }

        String finalGrade = isFullyCompleted ? getFinalGradeFromSgpa(sgpa) : "--";

        // CGPA calculation using completed semesters summary
        double cgpa = calculateCgpaForStudent(studentId, semester, isFullyCompleted, totalCredits, totalCreditPoints);

        StudentResultSummary summary = summaryDAO.findByStudentAndSemester(studentId, semester);
        if (summary == null)
        {
            summary = new StudentResultSummary();
            summary.setStudent(student);
            summary.setSemester(semester);
        }

        summary.setTotalMarks(totalMarks);
        summary.setMaxMarks(maxMarks);
        summary.setPercentage(percentage);
        summary.setTotalCredits(totalCredits);
        summary.setTotalCreditPoints(totalCreditPoints);
        summary.setSgpa(sgpa);
        summary.setCgpa(cgpa);
        summary.setFinalGrade(finalGrade);
        summary.setResultStatus(resultStatus);

        summaryDAO.saveOrUpdate(summary);
        return summary;
    }

    private double calculateCgpaForStudent(int studentId, String currentSem, boolean currentSemCompleted,
            double currentCredits, double currentCreditPoints)
            {
        List<StudentResultSummary> existingSummaries = summaryDAO.findAllByStudent(studentId);
        double sumCreditPoints = 0.0;
        double sumCredits = 0.0;

        for (StudentResultSummary s : existingSummaries)
        {
            if (s.getSemester().equalsIgnoreCase(currentSem))
                continue;
            if (s.getTotalCredits() > 0 && s.getSgpa() > 0)
            {
                sumCreditPoints += s.getTotalCreditPoints();
                sumCredits += s.getTotalCredits();
            }
        }

        if (currentSemCompleted && currentCredits > 0)
        {
            sumCreditPoints += currentCreditPoints;
            sumCredits += currentCredits;
        }

        if (sumCredits > 0)
        {
            return roundToTwoDecimals(sumCreditPoints / sumCredits);
        }
        return 0.0;
    }

    public StudentResultSummary getSummaryByStudentAndSemester(int studentId, String semester)
    {
        return summaryDAO.findByStudentAndSemester(studentId, semester);
    }

    public List<StudentResultSummary> getAllSummariesByStudent(int studentId)
    {
        return summaryDAO.findAllByStudent(studentId);
    }

    private double roundToTwoDecimals(double val)
    {
        return BigDecimal.valueOf(val).setScale(2, RoundingMode.HALF_UP).doubleValue();
    }
}
