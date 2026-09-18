// SELETOR DE PERFIL (Login: Aluno / Administrador)

const roleTabs = document.querySelectorAll(".role-tab");
const loginRoleInput = document.getElementById("login-role");

if (roleTabs.length && loginRoleInput) {

    roleTabs.forEach(function (tab) {

        tab.addEventListener("click", function () {

            roleTabs.forEach(function (t) {
                t.classList.remove("active");
            });

            tab.classList.add("active");
            loginRoleInput.value = tab.dataset.role;
        });

    });

}

// LOGIN

const formLogin = document.getElementById("formLogin");

if (formLogin) {

    formLogin.addEventListener("submit", function(event) {

        event.preventDefault();

        // Pega os valores digitados
        const email = document.getElementById("login-email").value;
        const senha = document.getElementById("login-password").value;
        const role = loginRoleInput ? loginRoleInput.value : "aluno";

        // Verifica se os campos estão preenchidos
        if (email === "" || senha === "") {
            alert("Preencha todos os campos.");
            return;
        }

        // Verifica o tamanho da senha
        if (senha.length < 6) {
            alert("A senha deve ter pelo menos 6 caracteres.");
            return;
        }

        // Cria a sessão do perfil escolhido (Aluno ou Administrador)
        Destrava.login(role, email.split("@")[0]);

        alert("Login realizado com sucesso!");

        // Encaminha para o painel correspondente ao perfil
        window.location.href = role === "admin" ? "Administrador.html" : "PaginaAluno.html";
    });
}

// CADASTRO

const formCadastro = document.getElementById("formCadastro");

if (formCadastro) {

    const mensagem = document.getElementById("mensagem-cadastro");

    formCadastro.addEventListener("submit", function(event) {

    
        event.preventDefault();

        // Pega os valores digitados
        const nome = document.getElementById("reg-name").value;
        const email = document.getElementById("reg-email").value;
        const senha = document.getElementById("reg-password").value;

        // Verifica se os campos estão preenchidos
        if (nome === "" || email === "" || senha === "") {
            mensagem.textContent = "Preencha todos os campos.";
            return;
        }
        if (senha.length < 6) {
            mensagem.textContent = "A senha deve ter pelo menos 6 caracteres.";
            return;
        }

        // Cadastro sempre cria uma conta de Aluno
        Destrava.login("aluno", nome);

        mensagem.textContent = "Cadastro realizado com sucesso!";

        // Vai para a página inicial

        setTimeout(function() {
            window.location.href = "PaginaAluno.html";
        }, 2000);

    });
}
