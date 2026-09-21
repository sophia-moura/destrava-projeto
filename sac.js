const formSAC = document.getElementById("formSAC");
const mensagem = document.getElementById("mensagem-sac");
const listaMensagens = document.getElementById("lista-mensagens");

// Recupera as mensagens

let mensagens = JSON.parse(localStorage.getItem("mensagensSAC")) || [];

// CREATE

formSAC.addEventListener("submit", function (event) {
    event.preventDefault();

    const nome = document.getElementById("sac-name").value;
    const email = document.getElementById("sac-email").value;
    const assunto = document.getElementById("sac-subject").value;
    const texto = document.getElementById("sac-message").value;

    const novaMensagem = {
        id: Date.now(),
        nome: nome,
        email: email,
        assunto: assunto,
        texto: texto
    };

    mensagens.push(novaMensagem);

    salvarMensagens();
    listarMensagens();

    mensagem.textContent = "Mensagem enviada com sucesso!";
    formSAC.reset();
});


// READ

function listarMensagens() {

    listaMensagens.innerHTML = "";

    if (mensagens.length === 0) {
        listaMensagens.innerHTML = "<p>Nenhuma mensagem recebida.</p>";
        return;
    }

    mensagens.forEach(function (msg) {

        const div = document.createElement("div");

        div.innerHTML = `
            <h4>${msg.assunto}</h4>

            <p><strong>Nome:</strong> ${msg.nome}</p>
            <p><strong>E-mail:</strong> ${msg.email}</p>
            <p><strong>Mensagem:</strong> ${msg.texto}</p>

            <button onclick="editarMensagem(${msg.id})">
                Editar
            </button>

            <button onclick="excluirMensagem(${msg.id})">
                Excluir
            </button>

            <hr>
        `;

        listaMensagens.appendChild(div);
    });
}


// UPDATE

function editarMensagem(id) {

    const msg = mensagens.find(function (item) {
        return item.id === id;
    });

    if (!msg) {
        return;
    }

    const novoNome = prompt("Digite o novo nome:", msg.nome);
    const novoEmail = prompt("Digite o novo e-mail:", msg.email);
    const novoAssunto = prompt("Digite o novo assunto:", msg.assunto);
    const novoTexto = prompt("Digite a nova mensagem:", msg.texto);

    if (
        novoNome === null ||
        novoEmail === null ||
        novoAssunto === null ||
        novoTexto === null
    ) {
        return;
    }

    msg.nome = novoNome;
    msg.email = novoEmail;
    msg.assunto = novoAssunto;
    msg.texto = novoTexto;

    salvarMensagens();
    listarMensagens();
}


// DELETE

function excluirMensagem(id) {

    const confirmar = confirm(
        "Tem certeza que deseja excluir esta mensagem?"
    );

    if (!confirmar) {
        return;
    }

    mensagens = mensagens.filter(function (msg) {
        return msg.id !== id;
    });

    salvarMensagens();
    listarMensagens();
}


// Salvar no localStorage

function salvarMensagens() {

    localStorage.setItem(
        "mensagensSAC",
        JSON.stringify(mensagens)
    );
}


// Carrega as mensagens

listarMensagens();
