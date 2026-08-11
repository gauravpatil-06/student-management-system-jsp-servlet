<%@ page language = "java" contentType = "text/html; charset = UTF-8" pageEncoding = "UTF-8" %>
    <!-- Reusable On-Page Logout Confirmation Modal -->
    <style>
        .logout-modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(15, 23, 42, 0.65);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            display: none;
            align-items: center;
            justify-content: center;
            padding: 1.25rem;
            z-index: 999999;
            animation: logoutModalFadeIn 0.2s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .logout-modal-card {
            background: #FFFFFF;
            width: 100%;
            max-width: 420px;
            border-radius: 16px;
            padding: 2rem 1.75rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25), 0 0 0 1px rgba(0, 0, 0, 0.05);
            text-align: center;
            animation: logoutModalSlideUp 0.25s cubic-bezier(0.16, 1, 0.3, 1);
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        .logout-modal-icon {
            width: 60px;
            height: 60px;
            background: #FEF2F2;
            border: 1px solid #FEE2E2;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.25rem auto;
            color: #EF4444;
        }

        .logout-modal-icon svg {
            width: 30px;
            height: 30px;
        }

        .logout-modal-title {
            font-size: 1.3rem;
            font-weight: 800;
            color: #1E3A5F;
            margin-bottom: 0.4rem;
            line-height: 1.3;
        }

        .logout-modal-text {
            font-size: 0.925rem;
            color: #64748B;
            line-height: 1.5;
            margin-bottom: 1.75rem;
            font-weight: 500;
        }

        .logout-modal-actions {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.85rem;
        }

        .logout-modal-btn {
            padding: 0.8rem 1rem;
            border-radius: 8px;
            font-size: 0.925rem;
            font-weight: 700;
            font-family: inherit;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
            border: none;
            outline: none;
        }

        .logout-modal-btn-cancel {
            background-color: #F1F5F9;
            color: #334155;
            border: 1px solid #CBD5E1;
        }

        .logout-modal-btn-cancel:hover {
            background-color: #E2E8F0;
            color: #0F172A;
        }

        .logout-modal-btn-confirm {
            background-color: #EF4444;
            color: #FFFFFF;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.25);
        }

        .logout-modal-btn-confirm:hover {
            background-color: #DC2626;
            box-shadow: 0 6px 16px rgba(239, 68, 68, 0.35);
            transform: translateY(-1px);
        }

        @keyframes logoutModalFadeIn {
            from {
                opacity: 0;
            }

            to {
                opacity: 1;
            }
        }

        @keyframes logoutModalSlideUp {
            from {
                opacity: 0;
                transform: translateY(16px) scale(0.96);
            }

            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }
    </style>

    <div id="logoutModalContainer" class="logout-modal-overlay" onclick="handleLogoutModalBackdropClick(event)">
        <div class="logout-modal-card">
            <div class="logout-modal-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                    stroke-linejoin="round">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                    <polyline points="16 17 21 12 16 7"></polyline>
                    <line x1="21" y1="12" x2="9" y2="12"></line>
                </svg>
            </div>

            <h2 class="logout-modal-title">Logout Confirmation</h2>
            <p class="logout-modal-text">Are you sure you want to logout?</p>

            <div class="logout-modal-actions">
                <button type="button" class="logout-modal-btn logout-modal-btn-cancel"
                    onclick="closeLogoutModal()">Cancel</button>
                <a href="${pageContext.request.contextPath}/logout"
                    class="logout-modal-btn logout-modal-btn-confirm">Logout</a>
            </div>
        </div>
    </div>

    <script>
        function openLogoutModal(e) {
            if (e && e.preventDefault) e.preventDefault();
            var modal = document.getElementById('logoutModalContainer');
            if (modal) {
                modal.style.display = 'flex';
            }
            return false;
        }

        function closeLogoutModal() {
            var modal = document.getElementById('logoutModalContainer');
            if (modal) {
                modal.style.display = 'none';
            }
        }

        function handleLogoutModalBackdropClick(e) {
            if (e.target && e.target.id === 'logoutModalContainer') {
                closeLogoutModal();
            }
        }

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') {
                closeLogoutModal();
            }
        });

        function bindLogoutLinks() {
            var logoutLinks = document.querySelectorAll('.logout-link');
            logoutLinks.forEach(function (link) {
                if (!link.getAttribute('data-logout-bound')) {
                    link.setAttribute('data-logout-bound', 'true');
                    link.addEventListener('click', function (e) {
                        e.preventDefault();
                        openLogoutModal(e);
                    });
                }
            });
        }

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', bindLogoutLinks);
        } else {
            bindLogoutLinks();
        }
        window.addEventListener('load', bindLogoutLinks);
        setTimeout(bindLogoutLinks, 100);
        setTimeout(bindLogoutLinks, 500);
    </script>