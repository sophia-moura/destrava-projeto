describe('Testes E2E - Destrava', () => {
  const baseUrl = 'http://127.0.0.1:8080';

  beforeEach(() => {
    cy.clearLocalStorage();
  });

  it('E2E-01 - Login e acesso ao painel do aluno', () => {
    cy.visit(`${baseUrl}/Login.html`);

    cy.get('#login-email').type('aluno@teste.com');
    cy.get('#login-password').type('123456');
    cy.get('#formLogin').submit();

    cy.url().should('include', 'PaginaAluno.html');
    cy.contains('Minha Trilha').should('be.visible');
    cy.contains('Meus Certificados').should('be.visible');
  });

  it('E2E-02 - Acesso ao painel de aulas', () => {
    cy.visit(`${baseUrl}/Login.html`);

    cy.get('#login-email').type('aluno@teste.com');
    cy.get('#login-password').type('123456');
    cy.get('#formLogin').submit();

    cy.url().should('include', 'PaginaAluno.html');
    cy.contains('Minhas Aulas').click();

    cy.url().should('include', 'aulas.html');
    cy.contains('Iniciante').should('be.visible');
  });

  it('E2E-03 - Acesso e abertura de aula', () => {
    cy.visit(`${baseUrl}/Login.html`);

    cy.get('#login-email').type('aluno@teste.com');
    cy.get('#login-password').type('123456');
    cy.get('#formLogin').submit();

    cy.visit(`${baseUrl}/aulas.html`);
    cy.contains('Iniciante').click();

    cy.url().should('include', 'iniciante.html');
    cy.contains('Aula 1').should('be.visible');
    cy.get('iframe').should('exist');
  });

  it('E2E-04 - Abertura e envio de chamado pelo SAC', () => {
    cy.visit(`${baseUrl}/sac.html`);

    cy.get('#formSAC').submit();

    cy.get('#mensagem-sac')
      .should('contain', 'Mensagem enviada com sucesso');

    cy.get('#sac-name').should('have.value', '');
  });
});
