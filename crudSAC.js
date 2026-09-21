let mensagens = [];

// CREATE
function criarMensagem(nome, email, assunto, texto) {

    const novaMensagem = {
        id: Date.now(),
        nome: nome,
        email: email,
        assunto: assunto,
        texto: texto
    };

    mensagens.push(novaMensagem);

    return novaMensagem;
}


// READ
function listarMensagens() {
    return mensagens;
}


// UPDATE
function atualizarMensagem(id, nome, email, assunto, texto) {

    const mensagem = mensagens.find(function (msg) {
        return msg.id === id;
    });

    if (!mensagem) {
        return false;
    }

    mensagem.nome = nome;
    mensagem.email = email;
    mensagem.assunto = assunto;
    mensagem.texto = texto;

    return mensagem;
}


// DELETE
function excluirMensagem(id) {

    const tamanhoAntes = mensagens.length;

    mensagens = mensagens.filter(function (msg) {
        return msg.id !== id;
    });

    return mensagens.length < tamanhoAntes;
}


// Função para limpar os dados dos testes
function limparMensagens() {
    mensagens = [];
}


// Exportação para o Jest
module.exports = {
    criarMensagem,
    listarMensagens,
    atualizarMensagem,
    excluirMensagem,
    limparMensagens
};