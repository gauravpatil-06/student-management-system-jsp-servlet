<%@ page language = "java" contentType = "text/html; charset = UTF-8" pageEncoding = "UTF-8" import = "com.student.entity.*" %>
    <%
        String from = request.getParameter("from");
        if (from == null || from.trim().isEmpty())
        {
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.trim().isEmpty())
            {
                from = referer;
            }
            else
            {
                from = request.getContextPath() + "/index.jsp" ;
            }
        }
        String returnUrl;
        if (from.startsWith("http://") || from.startsWith("https://"))
        {
            returnUrl = from;
        }
        else if (from.startsWith(request.getContextPath()))
        {
            returnUrl = from;
        }
        else
        {
            if (from.startsWith("/"))
            {
                returnUrl = request.getContextPath() + from;
            }
            else
            {
                returnUrl = request.getContextPath() + "/" + from;
            }
        }
    %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Logout Confirmation - Student Management System</title>
        </head>

        <body style="background: #0F172A; min-height: 100vh;">

            <jsp:include page="/logout-modal.jsp" />

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    openLogoutModal();
                    var cancelBtn = document.querySelector('.logout-modal-btn-cancel');
                    if (cancelBtn) {
                        cancelBtn.onclick = function () {
                            window.location.href = "<%= returnUrl %>";
                        };
                    }
                });
            </script>
        </body>

        </html>