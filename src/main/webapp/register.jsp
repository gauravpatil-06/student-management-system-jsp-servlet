<%@ page language="java" contentType="text/html; charset = UTF-8" pageEncoding="UTF-8" import="com.student.entity.*" %>
    <%-- Validate active user session and redirect if authenticated --%>
        <% if (session !=null) { com.student.entity.Student currentStudent=(com.student.entity.Student)
            session.getAttribute("student"); com.student.entity.Teacher currentTeacher=(com.student.entity.Teacher)
            session.getAttribute("teacher"); if (currentStudent !=null) { response.sendRedirect(request.getContextPath()
            + "/student/dashboard.jsp" ); return; } else if (currentTeacher !=null) {
            response.sendRedirect(request.getContextPath() + "/teacher/dashboard.jsp" ); return; } } %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Register - Student Management System</title>

                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">

                <style>
                    :root {
                        --primary-navy: #1E3A5F;
                        --primary-blue: #2563EB;
                        --primary-blue-hover: #1D4ED8;
                        --light-blue: #EFF6FF;
                        --bg-main: #F8FAFC;
                        --card-bg: #FFFFFF;
                        --text-main: #1E293B;
                        --text-muted: #64748B;
                        --success: #16A34A;
                        --error: #DC2626;
                        --border: #E2E8F0;
                        --radius-sm: 8px;
                        --radius-md: 14px;
                        --shadow: 0 10px 25px -5px rgba(30, 58, 95, 0.08), 0 8px 10px -6px rgba(30, 58, 95, 0.04);
                        --transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
                    }

                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }

                    body {
                        font-family: 'Plus Jakarta Sans', sans-serif;
                        background-color: var(--bg-main);
                        color: var(--text-main);
                        min-height: 100vh;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        padding: 2rem 1rem;
                        line-height: 1.6;
                    }

                    .auth-container {
                        width: 100%;
                        max-width: 1040px;
                        background: var(--card-bg);
                        border-radius: var(--radius-md);
                        border: 1px solid var(--border);
                        box-shadow: var(--shadow);
                        display: grid;
                        grid-template-columns: 380px 1fr;
                        overflow: hidden;
                    }

                    /* Left Side Branding Section */
                    .auth-banner {
                        background: linear-gradient(145deg, var(--primary-navy) 0%, #16345A 100%);
                        color: #FFFFFF;
                        padding: 3.5rem 2.25rem;
                        display: flex;
                        flex-direction: column;
                        justify-content: space-between;
                        position: relative;
                        overflow: hidden;
                    }

                    .auth-banner::before {
                        content: '';
                        position: absolute;
                        top: -50px;
                        left: -50px;
                        width: 220px;
                        height: 220px;
                        background: rgba(37, 99, 235, 0.25);
                        border-radius: 50%;
                        filter: blur(50px);
                        pointer-events: none;
                    }

                    .banner-logo {
                        display: flex;
                        align-items: center;
                        gap: 0.75rem;
                        font-size: 1.15rem;
                        font-weight: 800;
                        color: #FFFFFF;
                        text-decoration: none;
                        position: relative;
                        z-index: 1;
                    }

                    .banner-logo svg {
                        width: 28px;
                        height: 28px;
                        color: #60A5FA;
                    }

                    .banner-content {
                        position: relative;
                        z-index: 1;
                        margin: 2rem 0;
                    }

                    .banner-badge {
                        display: inline-block;
                        background: rgba(239, 246, 255, 0.12);
                        border: 1px solid rgba(255, 255, 255, 0.15);
                        color: #60A5FA;
                        font-size: 0.725rem;
                        font-weight: 800;
                        letter-spacing: 0.05em;
                        padding: 0.3rem 0.75rem;
                        border-radius: 50px;
                        margin-bottom: 1.25rem;
                    }

                    .banner-content h2 {
                        font-size: 1.75rem;
                        font-weight: 800;
                        line-height: 1.25;
                        margin-bottom: 0.75rem;
                        letter-spacing: -0.02em;
                    }

                    .banner-content p {
                        font-size: 0.9rem;
                        color: #94A3B8;
                        line-height: 1.6;
                        margin-bottom: 1.75rem;
                    }

                    /* Banner Feature Bullets */
                    .banner-features {
                        display: flex;
                        flex-direction: column;
                        gap: 0.85rem;
                        margin-bottom: 1.75rem;
                    }

                    .banner-feature-item {
                        display: flex;
                        align-items: flex-start;
                        gap: 0.75rem;
                        font-size: 0.875rem;
                        color: #E2E8F0;
                    }

                    .feature-check-icon {
                        width: 20px;
                        height: 20px;
                        border-radius: 50%;
                        background: rgba(37, 99, 235, 0.3);
                        color: #60A5FA;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 0.75rem;
                        font-weight: 800;
                        flex-shrink: 0;
                        margin-top: 2px;
                    }

                    /* Mini Status Card */
                    .banner-status-card {
                        background: rgba(255, 255, 255, 0.06);
                        border: 1px solid rgba(255, 255, 255, 0.12);
                        backdrop-filter: blur(10px);
                        border-radius: var(--radius-sm);
                        padding: 0.85rem 1rem;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        font-size: 0.8rem;
                    }

                    .status-dot {
                        width: 8px;
                        height: 8px;
                        border-radius: 50%;
                        background: #4ADE80;
                        display: inline-block;
                        margin-right: 6px;
                        box-shadow: 0 0 8px #4ADE80;
                    }

                    .banner-footer {
                        font-size: 0.8rem;
                        color: #64748B;
                        position: relative;
                        z-index: 1;
                    }

                    /* Right Side Form Section */
                    .auth-form-area {
                        padding: 2.5rem 2.25rem;
                        display: flex;
                        flex-direction: column;
                        justify-content: flex-start;
                        max-height: 85vh;
                        overflow-y: auto;
                    }

                    .auth-form-area::-webkit-scrollbar {
                        width: 6px;
                    }

                    .auth-form-area::-webkit-scrollbar-track {
                        background: #F1F5F9;
                        border-radius: 10px;
                    }

                    .auth-form-area::-webkit-scrollbar-thumb {
                        background: #CBD5E1;
                        border-radius: 10px;
                    }

                    .auth-form-area::-webkit-scrollbar-thumb:hover {
                        background: #94A3B8;
                    }

                    .form-header {
                        margin-bottom: 1.75rem;
                    }

                    .form-header h1 {
                        font-size: 1.75rem;
                        font-weight: 800;
                        color: var(--primary-navy);
                        margin-bottom: 0.35rem;
                        letter-spacing: -0.02em;
                    }

                    .form-header p {
                        font-size: 0.9rem;
                        color: var(--text-muted);
                    }

                    /* Form Grid Layout */
                    .form-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 1rem 1.25rem;
                    }

                    .form-grid.full-width {
                        grid-template-columns: 1fr;
                    }

                    .form-group {
                        margin-bottom: 1rem;
                    }

                    .form-group.col-span-2 {
                        grid-column: span 2;
                    }

                    .form-label {
                        display: block;
                        font-size: 0.825rem;
                        font-weight: 600;
                        color: var(--text-main);
                        margin-bottom: 0.35rem;
                    }

                    .input-wrapper {
                        position: relative;
                        display: flex;
                        align-items: center;
                    }

                    .form-control {
                        width: 100%;
                        padding: 0.75rem 0.9rem;
                        border: 1.5px solid var(--border);
                        border-radius: var(--radius-sm);
                        font-size: 0.9rem;
                        color: var(--text-main);
                        background-color: #FFFFFF;
                        font-family: inherit;
                        outline: none;
                        transition: var(--transition);
                    }

                    .form-control::placeholder {
                        color: #94A3B8;
                        font-size: 0.85rem;
                    }

                    .form-control:focus {
                        border-color: var(--primary-blue);
                        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
                    }

                    .form-control.input-error {
                        border-color: var(--error);
                        box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1);
                    }

                    /* Password input specific padding */
                    .input-wrapper .form-control {
                        padding-right: 2.75rem;
                    }

                    .toggle-password-btn {
                        position: absolute;
                        right: 10px;
                        background: none;
                        border: none;
                        color: #64748B;
                        cursor: pointer;
                        padding: 0.35rem;
                        display: none;
                        align-items: center;
                        justify-content: center;
                        border-radius: 4px;
                        transition: var(--transition);
                    }

                    .toggle-password-btn.visible {
                        display: flex;
                    }

                    .toggle-password-btn:hover {
                        color: var(--primary-blue);
                    }

                    .toggle-password-btn svg {
                        width: 16px;
                        height: 16px;
                    }

                    .icon-hidden {
                        display: none;
                    }

                    /* Select Dropdown */
                    select.form-control {
                        appearance: none;
                        -webkit-appearance: none;
                        -moz-appearance: none;
                        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%2364748B' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
                        background-repeat: no-repeat;
                        background-position: right 0.85rem center;
                        background-size: 14px;
                        cursor: pointer;
                        padding-right: 2.25rem;
                    }

                    /* Validation Error Notice */
                    .validation-msg {
                        font-size: 0.775rem;
                        color: var(--error);
                        margin-top: 0.25rem;
                        display: none;
                        font-weight: 500;
                    }

                    /* Dynamic Role Containers */
                    .role-section {
                        border-top: 1px solid var(--border);
                        padding-top: 1.25rem;
                        margin-top: 0.5rem;
                        display: none;
                        animation: fadeIn 0.3s ease-in-out;
                    }

                    .section-tag {
                        font-size: 0.8rem;
                        font-weight: 700;
                        color: var(--primary-navy);
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                        margin-bottom: 0.85rem;
                        display: block;
                    }

                    @keyframes fadeIn {
                        from {
                            opacity: 0;
                            transform: translateY(-4px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    /* Submit Button */
                    .btn-submit {
                        width: 100%;
                        padding: 0.85rem 1.5rem;
                        background: var(--primary-blue);
                        color: #FFFFFF;
                        border: none;
                        border-radius: var(--radius-sm);
                        font-size: 0.975rem;
                        font-weight: 600;
                        font-family: inherit;
                        cursor: pointer;
                        transition: var(--transition);
                        margin-top: 1rem;
                        box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
                    }

                    .btn-submit:hover {
                        background: var(--primary-blue-hover);
                        transform: translateY(-1px);
                        box-shadow: 0 6px 16px rgba(37, 99, 235, 0.3);
                    }

                    .btn-submit:active {
                        transform: translateY(0);
                    }

                    /* Footer Links */
                    .auth-footer-links {
                        margin-top: 1.5rem;
                        text-align: center;
                    }

                    .login-text {
                        font-size: 0.875rem;
                        color: var(--text-muted);
                        margin-bottom: 0.5rem;
                    }

                    .login-text a {
                        color: var(--primary-blue);
                        font-weight: 600;
                        text-decoration: none;
                        transition: var(--transition);
                    }

                    .login-text a:hover {
                        color: var(--primary-blue-hover);
                        text-decoration: underline;
                    }

                    .back-home-link {
                        display: inline-block;
                        font-size: 0.85rem;
                        font-weight: 500;
                        color: var(--text-muted);
                        text-decoration: none;
                        transition: var(--transition);
                    }

                    .back-home-link:hover {
                        color: var(--primary-navy);
                    }

                    /* Alert Messages */
                    .alert {
                        padding: 0.75rem 1rem;
                        border-radius: var(--radius-sm);
                        font-size: 0.875rem;
                        font-weight: 500;
                        margin-bottom: 1.25rem;
                        display: flex;
                        align-items: center;
                        gap: 0.6rem;
                        line-height: 1.4;
                    }

                    .alert-error {
                        background-color: #FEF2F2;
                        color: var(--error);
                        border: 1px solid #FCA5A5;
                    }

                    .alert-success {
                        background-color: #F0FDF4;
                        color: var(--success);
                        border: 1px solid #86EFAC;
                    }

                    /* Responsive */
                    @media (max-width: 860px) {
                        .auth-container {
                            grid-template-columns: 1fr;
                            max-width: 520px;
                        }

                        .auth-banner {
                            display: none;
                        }

                        .auth-form-area {
                            padding: 2.5rem 1.5rem;
                            max-height: none;
                        }

                        .form-grid {
                            grid-template-columns: 1fr;
                        }

                        .form-group.col-span-2 {
                            grid-column: span 1;
                        }
                    }
                </style>
            </head>

            <body>

                <div class="auth-container">
                    <!-- Left Side: Branding -->
                    <div class="auth-banner">
                        <a href="index.jsp" class="banner-logo">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                                stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
                                <path d="M6 12v5c3 3 9 3 12 0v-5" />
                            </svg>
                            <span>Student Management System</span>
                        </a>

                        <div class="banner-content">
                            <h2>Account Registration</h2>
                            <p>Create your account to access the Student Management System.</p>

                            <div class="banner-features">
                                <div class="banner-feature-item">
                                    <div class="feature-check-icon">✓</div>
                                    <span><strong>Centralized Records</strong> - Unified student & teacher data</span>
                                </div>
                                <div class="banner-feature-item">
                                    <div class="feature-check-icon">✓</div>
                                    <span><strong>CCE Marks Entry</strong> - Continuous evaluations</span>
                                </div>
                                <div class="banner-feature-item">
                                    <div class="feature-check-icon">✓</div>
                                    <span><strong>Attendance & Results</strong> - Real-time tracking</span>
                                </div>
                                <div class="banner-feature-item">
                                    <div class="feature-check-icon">✓</div>
                                    <span><strong>Role-Based Access</strong> - Dedicated portals</span>
                                </div>
                            </div>

                            <div class="banner-status-card">
                                <span style="color: #94A3B8;">System Status</span>
                                <span style="color: #FFFFFF; font-weight: 700;"><span class="status-dot"></span>Online &
                                    Synced</span>
                            </div>
                        </div>
                    </div>

                    <!-- Right Side: Registration Form -->
                    <div class="auth-form-area">
                        <% String error=request.getParameter("error"); String msg=request.getParameter("msg"); if (error
                            !=null && !error.trim().isEmpty()) { %>
                            <div class="alert alert-error">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <circle cx="12" cy="12" r="10" />
                                    <line x1="12" y1="8" x2="12" y2="12" />
                                    <line x1="12" y1="16" x2="12.01" y2="16" />
                                </svg>
                                <span>
                                    <%= error %>
                                </span>
                            </div>
                            <% } else if (msg !=null && !msg.trim().isEmpty()) { %>
                                <div class="alert alert-success">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                                        <polyline points="22 4 12 14.01 9 11.01" />
                                    </svg>
                                    <span>
                                        <%= msg %>
                                    </span>
                                </div>
                                <% } %>
                                    <div class="form-header">
                                        <h1>Create Your Account</h1>
                                        <p>Register to access the Student Management System.</p>
                                    </div>

                                    <form action="${pageContext.request.contextPath}/register" method="post"
                                        id="registerForm">
                                        <!-- COMMON FIELDS -->
                                        <div class="form-grid">
                                            <div class="form-group col-span-2">
                                                <label class="form-label" for="fullName">Full Name</label>
                                                <input type="text" id="fullName" name="fullName" class="form-control"
                                                    placeholder="Enter your full name" required>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label" for="username">Username</label>
                                                <input type="text" id="username" name="username" class="form-control"
                                                    placeholder="Enter username" required autocomplete="username">
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label" for="email">Email Address</label>
                                                <input type="email" id="email" name="email" class="form-control"
                                                    placeholder="Enter email address" required autocomplete="email">
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label" for="password">Password</label>
                                                <div class="input-wrapper">
                                                    <input type="password" id="password" name="password"
                                                        class="form-control" placeholder="Create password" required
                                                        autocomplete="new-password">
                                                    <button type="button" class="toggle-password-btn"
                                                        id="togglePasswordBtn" aria-label="Toggle password visibility">
                                                        <svg class="eye-open" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round">
                                                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z">
                                                            </path>
                                                            <circle cx="12" cy="12" r="3"></circle>
                                                        </svg>
                                                        <svg class="eye-off icon-hidden" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round">
                                                            <path
                                                                d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24">
                                                            </path>
                                                            <line x1="1" y1="1" x2="23" y2="23"></line>
                                                        </svg>
                                                    </button>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label" for="confirmPassword">Confirm Password</label>
                                                <div class="input-wrapper">
                                                    <input type="password" id="confirmPassword" name="confirmPassword"
                                                        class="form-control" placeholder="Confirm password" required
                                                        autocomplete="new-password">
                                                    <button type="button" class="toggle-password-btn"
                                                        id="toggleConfirmPasswordBtn"
                                                        aria-label="Toggle password visibility">
                                                        <svg class="eye-open" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round">
                                                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z">
                                                            </path>
                                                            <circle cx="12" cy="12" r="3"></circle>
                                                        </svg>
                                                        <svg class="eye-off icon-hidden" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="2"
                                                            stroke-linecap="round" stroke-linejoin="round">
                                                            <path
                                                                d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24">
                                                            </path>
                                                            <line x1="1" y1="1" x2="23" y2="23"></line>
                                                        </svg>
                                                    </button>
                                                </div>
                                                <span class="validation-msg" id="passwordMatchMsg">Passwords do not
                                                    match</span>
                                            </div>

                                            <div class="form-group col-span-2">
                                                <label class="form-label">Gender *</label>
                                                <div
                                                    style="display: flex; gap: 1.5rem; align-items: center; padding: 0.4rem 0;">
                                                    <label
                                                        style="display: flex; align-items: center; gap: 0.4rem; cursor: pointer; font-size: 0.9rem; font-weight: 500;">
                                                        <input type="radio" name="gender" value="Male" checked required>
                                                        Male
                                                    </label>
                                                    <label
                                                        style="display: flex; align-items: center; gap: 0.4rem; cursor: pointer; font-size: 0.9rem; font-weight: 500;">
                                                        <input type="radio" name="gender" value="Female" required>
                                                        Female
                                                    </label>
                                                    <label
                                                        style="display: flex; align-items: center; gap: 0.4rem; cursor: pointer; font-size: 0.9rem; font-weight: 500;">
                                                        <input type="radio" name="gender" value="Other" required> Other
                                                    </label>
                                                </div>
                                            </div>

                                            <div class="form-group col-span-2">
                                                <label class="form-label" for="roleSelect">Role</label>
                                                <select id="roleSelect" name="role" class="form-control" required>
                                                    <option value="" disabled selected>Select Role</option>
                                                    <option value="Student">Student</option>
                                                    <option value="Teacher">Teacher</option>
                                                </select>
                                            </div>
                                        </div>

                                        <!-- STUDENT REGISTRATION FIELDS (Conditional) -->
                                        <div class="role-section" id="studentFields">
                                            <span class="section-tag">Student Details</span>
                                            <div class="form-grid">
                                                <div class="form-group">
                                                    <label class="form-label" for="rollNumber">Roll Number</label>
                                                    <input type="text" id="rollNumber" name="rollNumber"
                                                        class="form-control" placeholder="Enter roll number">
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label" for="studentPhone">Phone</label>
                                                    <input type="tel" id="studentPhone" name="phone"
                                                        class="form-control" placeholder="Enter phone number">
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label" for="course">Course</label>
                                                    <select id="course" name="course" class="form-control">
                                                        <option value="" disabled selected>Select Course</option>
                                                        <option value="Diploma">Diploma</option>
                                                        <option value="BTech">BTech</option>
                                                        <option value="BE">BE</option>
                                                        <option value="BSc">BSc</option>
                                                        <option value="BCA">BCA</option>
                                                        <option value="BCS">BCS</option>
                                                        <option value="MSc">MSc</option>
                                                        <option value="MCA">MCA</option>
                                                        <option value="MBA">MBA</option>
                                                        <option value="MTech">MTech</option>
                                                        <option value="ME">ME</option>
                                                        <option value="MCom">MCom</option>
                                                        <option value="MA">MA</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label" for="studentDepartment">Department</label>
                                                    <select id="studentDepartment" name="department"
                                                        class="form-control">
                                                        <option value="" disabled selected>Select Department</option>
                                                        <option value="Computer Engineering">Computer Engineering
                                                        </option>
                                                        <option value="Information Technology">Information Technology
                                                        </option>
                                                        <option value="Mechanical Engineering">Mechanical Engineering
                                                        </option>
                                                        <option value="Electrical Engineering">Electrical Engineering
                                                        </option>
                                                        <option value="Civil Engineering">Civil Engineering</option>
                                                        <option value="Electronics & Telecommunication">Electronics &
                                                            Telecommunication</option>
                                                        <option value="Electronics Engineering">Electronics Engineering
                                                        </option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label" for="semester">Semester</label>
                                                    <select id="semester" name="semester" class="form-control">
                                                        <option value="" disabled selected>Select Semester</option>
                                                        <option value="Semester 1">Semester 1</option>
                                                        <option value="Semester 2">Semester 2</option>
                                                        <option value="Semester 3">Semester 3</option>
                                                        <option value="Semester 4">Semester 4</option>
                                                        <option value="Semester 5">Semester 5</option>
                                                        <option value="Semester 6">Semester 6</option>
                                                        <option value="Semester 7">Semester 7</option>
                                                        <option value="Semester 8">Semester 8</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label" for="year">Year</label>
                                                    <select id="year" name="year" class="form-control">
                                                        <option value="" disabled selected>Select Year</option>
                                                        <option value="First Year">First Year</option>
                                                        <option value="Second Year">Second Year</option>
                                                        <option value="Third Year">Third Year</option>
                                                        <option value="Fourth Year">Fourth Year</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- TEACHER REGISTRATION FIELDS (Conditional) -->
                                        <div class="role-section" id="teacherFields">
                                            <span class="section-tag">Teacher Details</span>
                                            <div class="form-grid">
                                                <div class="form-group">
                                                    <label class="form-label" for="teacherPhone">Phone</label>
                                                    <input type="tel" id="teacherPhone" name="teacherPhone"
                                                        class="form-control" placeholder="Enter phone number">
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label" for="teacherDepartment">Department</label>
                                                    <select id="teacherDepartment" name="teacherDepartment"
                                                        class="form-control">
                                                        <option value="" disabled selected>Select Department</option>
                                                        <option value="Computer Engineering">Computer Engineering
                                                        </option>
                                                        <option value="Information Technology">Information Technology
                                                        </option>
                                                        <option value="Mechanical Engineering">Mechanical Engineering
                                                        </option>
                                                        <option value="Electrical Engineering">Electrical Engineering
                                                        </option>
                                                        <option value="Civil Engineering">Civil Engineering</option>
                                                        <option value="Electronics & Telecommunication">Electronics &
                                                            Telecommunication</option>
                                                        <option value="Electronics Engineering">Electronics Engineering
                                                        </option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Submit Button -->
                                        <button type="submit" class="btn-submit" id="submitBtn">Create Account</button>


                                        <div class="auth-footer-links">
                                            <p class="login-text">
                                                Already have an account? <a href="login.jsp">Login</a>
                                            </p>
                                            <a href="index.jsp" class="back-home-link">← Back to Home</a>
                                        </div>
                                    </form>
                    </div>
                </div>

                <!-- Client-Side Role Switching & Password Logic -->
                <script>
                    // 1. Role-based Dynamic Field Switcher
                    const roleSelect = document.getElementById('roleSelect');
                    const studentFields = document.getElementById('studentFields');
                    const teacherFields = document.getElementById('teacherFields');

                    roleSelect.addEventListener('change', () => {
                        const role = roleSelect.value ? roleSelect.value.toLowerCase() : '';
                        if (role === 'student') {
                            studentFields.style.display = 'block';
                            teacherFields.style.display = 'none';
                            setFieldsRequired(studentFields, true);
                            setFieldsRequired(teacherFields, false);
                        } else if (role === 'teacher') {
                            studentFields.style.display = 'none';
                            teacherFields.style.display = 'block';
                            setFieldsRequired(studentFields, false);
                            setFieldsRequired(teacherFields, true);
                        } else {
                            studentFields.style.display = 'none';
                            teacherFields.style.display = 'none';
                            setFieldsRequired(studentFields, false);
                            setFieldsRequired(teacherFields, false);
                        }
                    });

                    function setFieldsRequired(container, isReq) {
                        const inputs = container.querySelectorAll('input, select');
                        inputs.forEach(input => {
                            if (isReq) {
                                input.setAttribute('required', 'required');
                            } else {
                                input.removeAttribute('required');
                            }
                        });
                    }

                    // 2. Password Visibility Toggles
                    function setupPasswordToggle(btnId, inputId) {
                        const btn = document.getElementById(btnId);
                        const input = document.getElementById(inputId);
                        if (!btn || !input) return;

                        const openIcon = btn.querySelector('.eye-open');
                        const offIcon = btn.querySelector('.eye-off');

                        function checkVisibility() {
                            if (input.value.length > 0) {
                                btn.classList.add('visible');
                            } else {
                                btn.classList.remove('visible');
                                input.type = 'password';
                                if (openIcon && offIcon) {
                                    openIcon.classList.remove('icon-hidden');
                                    offIcon.classList.add('icon-hidden');
                                }
                            }
                        }

                        input.addEventListener('input', checkVisibility);

                        btn.addEventListener('click', () => {
                            const isPassword = input.type === 'password';
                            input.type = isPassword ? 'text' : 'password';
                            if (openIcon && offIcon) {
                                openIcon.classList.toggle('icon-hidden', isPassword);
                                offIcon.classList.toggle('icon-hidden', !isPassword);
                            }
                        });

                        checkVisibility();
                    }

                    setupPasswordToggle('togglePasswordBtn', 'password');
                    setupPasswordToggle('toggleConfirmPasswordBtn', 'confirmPassword');

                    // 3. Client-Side Confirm Password Matching
                    const registerForm = document.getElementById('registerForm');
                    const password = document.getElementById('password');
                    const confirmPassword = document.getElementById('confirmPassword');
                    const passwordMatchMsg = document.getElementById('passwordMatchMsg');

                    function checkPasswords() {
                        if (confirmPassword.value && password.value !== confirmPassword.value) {
                            confirmPassword.classList.add('input-error');
                            passwordMatchMsg.style.display = 'block';
                            return false;
                        } else {
                            confirmPassword.classList.remove('input-error');
                            passwordMatchMsg.style.display = 'none';
                            return true;
                        }
                    }

                    password.addEventListener('input', () => {
                        if (confirmPassword.value) checkPasswords();
                    });
                    confirmPassword.addEventListener('input', checkPasswords);

                    registerForm.addEventListener('submit', (e) => {
                        if (!checkPasswords()) {
                            e.preventDefault();
                            confirmPassword.focus();
                        }
                    });
                </script>
            </body>

            </html>