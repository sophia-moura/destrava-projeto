/* ==========================================================
   auth.js — Controle de sessão do protótipo Destrava
   ------------------------------------------------------------
   Este projeto é um front-end estático (sem servidor/back-end),
   então este "login" NÃO é uma autenticação real e segura —
   ele apenas simula sessão de Aluno/Administrador usando o
   localStorage do navegador, para permitir testar a separação
   de áreas no protótipo. Em um sistema real, essa checagem
   precisaria acontecer no servidor.
   ========================================================== */

const Destrava = {
    SESSION_KEY: "destrava_session",

    // Salva a sessão atual (role: "aluno" ou "admin")
    login(role, nome) {
        const session = {
            role: role,
            nome: nome || (role === "admin" ? "Administrador" : "Aluno")
        };
        localStorage.setItem(this.SESSION_KEY, JSON.stringify(session));
        return session;
    },

    // Lê a sessão atual (ou null se não houver ninguém logado)
    getSession() {
        try {
            const raw = localStorage.getItem(this.SESSION_KEY);
            return raw ? JSON.parse(raw) : null;
        } catch (erro) {
            return null;
        }
    },

    // Encerra a sessão e volta para a home
    logout() {
        localStorage.removeItem(this.SESSION_KEY);
        window.location.href = "indexPaginaInicial.html";
    },

    // Bloqueia a página caso não haja sessão do papel exigido.
    // Deve ser chamada o quanto antes no <body>, antes do conteúdo,
    // para minimizar o "flash" de conteúdo protegido.
    requireRole(role) {
        const session = this.getSession();
        if (!session || session.role !== role) {
            window.location.href = "Login.html";
            return null;
        }
        return session;
    },

    // Preenche o nome do usuário logado em qualquer elemento com
    // o atributo data-user-name, se ele existir na página.
    renderUserName() {
        const session = this.getSession();
        if (!session) return;
        document.querySelectorAll("[data-user-name]").forEach(function (el) {
            el.textContent = session.nome;
        });
    }
};
