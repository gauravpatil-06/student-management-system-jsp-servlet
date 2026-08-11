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
                <title>Login - Student Management System</title>

                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">

                <style>
                    :root {
                        --primary-navy: #1E3A5F;
                        --dark-navy: #16345A;
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
                        padding: 1.5rem;
                        line-height: 1.6;
                    }

                    .auth-container {
                        width: 100%;
                        max-width: 960px;
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

                    .form-group {
                        margin-bottom: 1.25rem;
                    }

                    .form-label {
                        display: block;
                        font-size: 0.85rem;
                        font-weight: 700;
                        color: var(--primary-navy);
                        margin-bottom: 0.4rem;
                    }

                    .input-wrapper {
                        position: relative;
                        display: flex;
                        align-items: center;
                    }

                    .form-control {
                        width: 100%;
                        padding: 0.75rem 1rem;
                        border: 1.5px solid var(--border);
                        border-radius: var(--radius-sm);
                        font-size: 0.925rem;
                        color: var(--text-main);
                        background-color: #FFFFFF;
                        font-family: inherit;
                        outline: none;
                        transition: var(--transition);
                    }

                    .form-control::placeholder {
                        color: #94A3B8;
                        font-size: 0.875rem;
                    }

                    .form-control:focus {
                        border-color: var(--primary-blue);
                        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
                    }

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

                    /* Select Dropdown Styling */
                    select.form-control {
                        appearance: none;
                        -webkit-appearance: none;
                        -moz-appearance: none;
                        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%2364748B' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
                        background-repeat: no-repeat;
                        background-position: right 1rem center;
                        background-size: 16px;
                        cursor: pointer;
                        padding-right: 2.5rem;
                    }

                    /* Submit Button */
                    .btn-submit {
                        width: 100%;
                        padding: 0.85rem 1.5rem;
                        background: var(--primary-blue);
                        color: #FFFFFF;
                        border: none;
                        border-radius: var(--radius-sm);
                        font-size: 0.95rem;
                        font-weight: 700;
                        font-family: inherit;
                        cursor: pointer;
                        transition: var(--transition);
                        margin-top: 0.5rem;
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

                    .register-text {
                        font-size: 0.875rem;
                        color: var(--text-muted);
                        margin-bottom: 0.75rem;
                    }

                    .register-text a {
                        color: var(--primary-blue);
                        font-weight: 700;
                        text-decoration: none;
                        transition: var(--transition);
                    }

                    .register-text a:hover {
                        color: var(--primary-blue-hover);
                        text-decoration: underline;
                    }

                    .back-home-link {
                        display: inline-block;
                        font-size: 0.85rem;
                        font-weight: 600;
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

                    /* Responsive Breakpoints */
                    @media (max-width: 820px) {
                        .auth-container {
                            grid-template-columns: 1fr;
                            max-width: 480px;
                        }

                        .auth-banner {
                            display: none;
                        }

                        .auth-form-area {
                            padding: 2.5rem 1.75rem;
                        }
                    }
                </style>
            </head>

            <body>

                <div class="auth-container">

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
                            <h2>Account Access</h2>
                            <p>Log in using your assigned credentials to access examination assessments, student
                                records,
                                and
                                performance metrics.</p>

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


                    <div class="auth-form-area">
                        <% String error=request.getParameter("error"); String success=request.getParameter("success");
                            if (success==null || success.trim().isEmpty()) { success=request.getParameter("msg"); } if
                            (error !=null && !error.trim().isEmpty()) { %>
                            <div class="alert alert-error">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <circle cx="12" cy="12" r="10" />
                                    <line x1="12" y1="8" x2="12" />
                                    <line x1="12" y1="16" x2="12.01" y2="16" />
                                </svg>
                                <span>
                                    <%= error %>
                                </span>
                            </div>
                            <% } else if (success !=null && !success.trim().isEmpty()) { %>
                                <div class="alert alert-success">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                                        <polyline points="22 4 12 14.01 9 11.01" />
                                    </svg>
                                    <span>
                                        <%= success %>
                                    </span>
                                </div>
                                <% } %>
                                    <div class="form-header">
                                        <h1>Welcome Back</h1>
                                        <p>Login to your Student Management System account.</p>
                                    </div>


                                    <form action="${pageContext.request.contextPath}/login" method="post">

                                        <div class="form-group">
                                            <label class="form-label" for="username">Username / Email</label>
                                            <input type="text" id="username" name="username" class="form-control"
                                                placeholder="Enter username or email" required autocomplete="username">
                                        </div>


                                        <div class="form-group">
                                            <label class="form-label" for="password">Password</label>
                                            <div class="input-wrapper">
                                                <input type="password" id="password" name="password"
                                                    class="form-control" placeholder="Enter your password" required
                                                    autocomplete="current-password">
                                                <button type="button" class="toggle-password-btn" id="togglePasswordBtn"
                                                    aria-label="Toggle password visibility">
                                                    <svg class="eye-open" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                                        stroke-linejoin="round">
                                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                                        <circle cx="12" cy="12" r="3"></circle>
                                                    </svg>
                                                    <svg class="eye-off icon-hidden" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                                        stroke-linejoin="round">
                                                        <path
                                                            d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24">
                                                        </path>
                                                        <line x1="1" y1="1" x2="23" y2="23"></line>
                                                    </svg>
                                                </button>
                                            </div>
                                        </div>


                                        <div class="form-group">
                                            <label class="form-label" for="role">Login As</label>
                                            <select id="role" name="role" class="form-control" required>
                                                <option value="">Select Role</option>
                                                <option value="Student">Student</option>
                                                <option value="Teacher">Teacher</option>
                                                <option value="Admin">Admin</option>
                                            </select>
                                        </div>


                                        <button type="submit" class="btn-submit">Login</button>


                                        <div class="auth-footer-links">
                                            <p class="register-text">
                                                Don't have an account? <a href="register.jsp">Register</a>
                                            </p>
                                            <a href="index.jsp" class="back-home-link">← Back to Home</a>
                                        </div>
                                    </form>
                    </div>
                </div>


                <script>
                    const togglePasswordBtn = document.getElementById('togglePasswordBtn');
                    const passwordInput = document.getElementById('password');

                    if (togglePasswordBtn && passwordInput) {
                        const eyeOpen = togglePasswordBtn.querySelector('.eye-open');
                        const eyeOff = togglePasswordBtn.querySelector('.eye-off');

                        function checkVisibility() {
                            if (passwordInput.value.length > 0) {
                                togglePasswordBtn.classList.add('visible');
                            } else {
                                togglePasswordBtn.classList.remove('visible');
                                passwordInput.type = 'password';
                                if (eyeOpen && eyeOff) {
                                    eyeOpen.classList.remove('icon-hidden');
                                    eyeOff.classList.add('icon-hidden');
                                }
                            }
                        }

                        passwordInput.addEventListener('input', checkVisibility);

                        togglePasswordBtn.addEventListener('click', () => {
                            const isPassword = passwordInput.type === 'password';
                            passwordInput.type = isPassword ? 'text' : 'password';
                            if (eyeOpen && eyeOff) {
                                eyeOpen.classList.toggle('icon-hidden', !isPassword);
                                eyeOff.classList.toggle('icon-hidden', isPassword);
                            }
                        });

                        checkVisibility();
                    }
                </script>
            </body>

            </html>