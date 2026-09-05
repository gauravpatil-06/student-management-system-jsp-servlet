<p align="center">
  <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/hibernate/hibernate-original.svg" width="80" alt="Hibernate Logo"/>
</p>

<h1 align="center">Student Management System – 2026</h1>

<p align="center">
  🎓 <b>Hibernate ORM & Java Web Application Practice Repository</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Language-Java_21-orange?style=for-the-badge&logo=java" alt="Java 21"/>
  <img src="https://img.shields.io/badge/ORM-Hibernate_6.6-59666C?style=for-the-badge&logo=hibernate" alt="Hibernate ORM"/>
  <img src="https://img.shields.io/badge/Web-Jakarta_Servlets_%26_JSP-red?style=for-the-badge&logo=jakarta" alt="Servlets & JSP"/>
  <img src="https://img.shields.io/badge/Database-MySQL_8.4-blue?style=for-the-badge&logo=mysql" alt="MySQL"/>
  <img src="https://img.shields.io/badge/Server-Apache_Tomcat_v10.1-red?style=for-the-badge&logo=apachetomcat" alt="Apache Tomcat"/>
  <img src="https://img.shields.io/badge/Build-Maven-C71A36?style=for-the-badge&logo=apachemaven" alt="Maven"/>
  <img src="https://img.shields.io/badge/IDE-Eclipse_Enterprise-purple?style=for-the-badge&logo=eclipseide" alt="Eclipse IDE"/>
  <img src="https://img.shields.io/badge/VCS-Git_%26_GitHub-black?style=for-the-badge&logo=github" alt="Git & GitHub"/>
</p>

---

## 📘 About This Repository

This repository contains a **Student Management System Web Application** built using **Java 21, Hibernate 6.6 ORM, Jakarta Servlets 6.0, JSP 3.1, JSTL 3.0, and MySQL Database**.

The application provides a **role-based academic management portal** for **Admins, Teachers, and Students** to manage and access student records, teacher records, subjects, subject assignments, CCE marks, End-Semester examination marks, and student results.

### Key Highlights

- **Admin Module:** Manages students, teachers, subjects, and teacher/student subject assignments.
- **Teacher Module:** Views assigned subjects and students, manages CCE and End-Semester marks, and views student academic performance.
- **Student Module:** Views personal information, assigned subjects, CCE marks, and academic results.
- **Hibernate ORM:** Handles object-relational mapping and database persistence.
- **Layered MVC Architecture:** Separates presentation, request handling, business logic, and database access.
- **Role-Based Access Control:** Provides separate access and functionality for Admin, Teacher, and Student users through session-based authentication.
- **Result Management:** Manages CCE marks, End-Semester marks, total marks, percentage, grade, and result status.
  
---

## 🚀 Key Features & Modules

### 1. 🔑 Authentication & Role-Based Security

- Multi-role authentication supporting **Admin, Teacher, and Student** access.
- User registration and secure login functionality.
- Session-based authentication and logout handling.
- Role-based access control to provide appropriate functionality for each user type.

### 2. 🛡️ Admin Module

- **Dashboard Overview:** System-wide overview of students, teachers, subjects, and academic assignments.
- **Teacher Management:** Add, update, view, and manage teacher information.
- **Student Management:** Add, update, view, and manage student academic and personal information.
- **Subject Management:** Create and manage academic subjects with subject codes and credits.
- **Teacher-Subject Assignment:** Assign subjects to teachers according to their academic responsibilities.
- **Student-Subject Assignment:** Assign students to their respective academic subjects.

### 3. 👨‍🏫 Teacher Module

- **Dashboard Overview:** View assigned subjects and enrolled students.
- **Assigned Subjects:** View subjects assigned to the teacher.
- **Assigned Students:** View students enrolled in the teacher's assigned subjects.
- **CCE Marks Management:** Enter and manage Continuous and Comprehensive Evaluation (CCE) marks.
- **End-Semester Marks Management:** Enter and manage semester-end examination marks.
- **Results Management:** View student academic performance including marks, percentage, grade, and result status.
- **Student Performance:** Review academic performance of students for assigned subjects.

### 4. 🎓 Student Module

- **Dashboard Overview:** View a personalized academic overview.
- **Profile:** View personal and academic information.
- **My Subjects:** View subjects assigned to the student.
- **CCE Marks:** View CCE and internal assessment marks.
- **My Results:** View CCE marks, End-Semester marks, total marks, percentage, grade, and result status.

---

## 🏗️ Architecture

The application follows a **layered MVC (Model-View-Controller) architecture**, with **Hibernate ORM** handling object-relational mapping and database persistence.

<img width="2172" height="347" alt="hibernate" src="https://github.com/user-attachments/assets/7583b885-3e33-4e62-9b3b-0c50a6eea6e3" />

---

## ⚙️ Application Workflow

The application workflow shows how the system manages academic activities from Admin setup and subject allocation to Teacher evaluation and Student result access.

<img width="1774" height="730" alt="Application Workflow" src="https://github.com/user-attachments/assets/6a482bc6-13bc-401b-83a1-0bcf2737769d" />

---

## 🔄 Complete Academic Process

The complete academic process illustrates the flow of subjects, teacher and student assignments, CCE and End-Semester marks, result generation, CGPA/SGPA calculation, and final marksheet access by the student.

<img width="1774" height="770" alt="Complete Academic Process" src="https://github.com/user-attachments/assets/12c04ea9-131b-4588-bc69-908ffbe00cfa" />

---

## 🛠️ Technologies Used

| **Technology / Tool** | **Category** | **Usage** |
|---|---|---|
| **Java 21** | Programming Language | Core backend application logic and OOP |
| **Hibernate ORM (6.6)** | ORM Framework | Object-relational mapping, database persistence, HQL queries, and transaction management |
| **JPA Annotations** | Metadata Mapping | Mapping Java entities to relational database tables |
| **Jakarta Servlets (6.0)** | Controller Layer | HTTP request processing and request handling |
| **JSP (3.1) & JSTL (3.0)** | Presentation Layer | Dynamic server-side web page rendering |
| **MySQL (8.4)** | Relational Database | Persistent storage for student, teacher, subject, marks, and academic records |
| **Apache Tomcat (10.1)** | Servlet Container | Hosting and running the web application |
| **Lombok** | Developer Utility | Reducing Java boilerplate code |
| **Maven** | Build & Dependency Management | Project build, dependency management, and lifecycle management |
| **Eclipse IDE** | Development Environment | Java web application development and Tomcat integration |
| **Git & GitHub** | Version Control | Source code version control and project history management |

---

## 🗄️ Database & Hibernate Configuration

The application uses **MySQL Database** with **Hibernate ORM** for object-relational mapping and database persistence.

### Configuration Parameters

- **Database:** MySQL
- **Database Port:** `3306` (Default)
- **JDBC Driver:** `com.mysql.cj.jdbc.Driver`
- **Hibernate ORM:** `6.6`
- **Schema Management:** `hibernate.hbm2ddl.auto` is configured as `update` to automatically synchronize database tables with the mapped entity structure.
- **Connection Configuration:** Database connection details are configured through Hibernate configuration properties.

---

## 💻 How to Import and Run in Eclipse

### Step 1: Clone the Repository

```bash
git clone https://github.com/gauravpatil-06/student-management-system-jsp-servlet.git
```

### Step 2: Open Eclipse IDE

Launch Eclipse IDE for Enterprise Java and Web Developers.

### Step 3: Import the Project
1. Go to **File** ➔ **Import...**
2. Select **Maven** ➔ **Existing Maven Projects** and click **Next**.
3. Browse to the directory where you cloned the repository.
4. Select the project and click **Finish**. Maven will automatically resolve and download the required dependencies.

### Step 4: Configure Apache Tomcat
1. Open the **Servers** tab in Eclipse.
2. Right-click ➔ **New** ➔ **Server**.
3. Select **Apache** ➔ **Tomcat v10.1 Server**.
4. Select your local Tomcat 10.1 installation directory and click **Finish**.

### Step 5: Configure MySQL Database
1. Ensure the MySQL Server is running.
2. Create the required database/schema in MySQL.
3. Configure your MySQL connection details in the Hibernate configuration according to your local environment.
4. Ensure the database username and password are correct.

### Step 6: Run the Application
1. Right-click the project in Eclipse.
2. Select **Run As** ➔ **Run on Server**.
3. Choose **Apache Tomcat v10.1 Server** and click **Finish**.
4. Open the application in your browser using the URL provided by the Tomcat server.

---

<p align="center">
  <b>Built for academic practice, interview preparation, and mastering Enterprise Java, Hibernate ORM, and web application development.</b>
</p>
