const {
    criarMensagem,
    listarMensagens,
    atualizarMensagem,
    excluirMensagem,
    limparMensagens
} = require("./crudSAC");


// Antes de cada teste, limpa as mensagens
beforeEach(() => {
    limparMensagens();
});

// TESTE 1 - CREATE

test("T-01 - deve criar uma nova mensagem", () => {

    const mensagem = criarMensagem(
        "Maria Silva",
        "maria@email.com",
        "Dúvida sobre o curso",
        "Gostaria de saber como acessar o curso."
    );

    expect(mensagem.nome).toBe("Maria Silva");
    expect(mensagem.email).toBe("maria@email.com");
    expect(mensagem.assunto).toBe("Dúvida sobre o curso");
    expect(mensagem.texto).toBe(
        "Gostaria de saber como acessar o curso."
    );

    expect(listarMensagens()).toHaveLength(1);
});


// TESTE 2 - READ

test("T-02 - deve listar as mensagens cadastradas", () => {

    criarMensagem(
        "Maria Silva",
        "maria@email.com",
        "Dúvida",
        "Tenho uma dúvida."
    );

    const mensagens = listarMensagens();

    expect(mensagens).toHaveLength(1);
    expect(mensagens[0].nome).toBe("Maria Silva");
    expect(mensagens[0].assunto).toBe("Dúvida");
});


// TESTE 3 - UPDATE

test("T-03 - deve atualizar uma mensagem existente", () => {

    const mensagem = criarMensagem(
        "Maria Silva",
        "maria@email.com",
        "Dúvida",
        "Tenho uma dúvida."
    );

    atualizarMensagem(
        mensagem.id,
        "Maria Souza",
        "maria.souza@email.com",
        "Dúvida sobre o curso",
        "Agora minha dúvida é sobre o curso."
    );

    const mensagens = listarMensagens();

    expect(mensagens[0].nome).toBe("Maria Souza");
    expect(mensagens[0].email).toBe(
        "maria.souza@email.com"
    );
    expect(mensagens[0].assunto).toBe(
        "Dúvida sobre o curso"
    );
    expect(mensagens[0].texto).toBe(
        "Agora minha dúvida é sobre o curso."
    );
});


// TESTE 4 - DELETE

test("T-04 - deve excluir uma mensagem existente", () => {

    const mensagem = criarMensagem(
        "Maria Silva",
        "maria@email.com",
        "Dúvida",
        "Tenho uma dúvida."
    );

    expect(listarMensagens()).toHaveLength(1);

    excluirMensagem(mensagem.id);

    expect(listarMensagens()).toHaveLength(0);
});