USE destrava;

-- Inserir usuários
INSERT INTO usuario
(primeiro_nome, sobrenome, email, senha, tipo_perfil)
VALUES
('Ana', 'Souza', 'ana.souza@exemplo.com', 'senha123', 'ALUNO'),
('Bruno', 'Oliveira', 'bruno.oliveira@exemplo.com', 'senha456', 'ALUNO'),
('Carla', 'Santos', 'carla.santos@exemplo.com', 'senha789', 'ALUNO'),
('Diego', 'Lima', 'diego.lima@exemplo.com', 'senha321', 'ADMINISTRADOR'),
('Marina', 'Costa', 'marina.costa@exemplo.com', 'senha654', 'ADMINISTRADOR');

-- Inserir trilhas
INSERT INTO trilha
(nome, descricao, faixa_etaria_min, faixa_etaria_max)
VALUES
('Informática Básica', 'Conteúdos básicos para iniciar no uso do computador.', 10, 13),
('Tecnologia no Dia a Dia', 'Conteúdos de informática para situações do cotidiano.', 14, 17),
('Informática Avançada', 'Conteúdos para aprofundar conhecimentos em informática.', 18, 99);

-- Inserir níveis
INSERT INTO nivel (nome, ordem, id_nivel_prerequisito)
VALUES
('Iniciante', 1, NULL),
('Intermediário', 2, 1),
('Avançado', 3, 2);

-- Inserir conquistas
INSERT INTO conquista (nome, descricao, criterio_desbloqueio)
VALUES
('Primeiros Passos', 'Conquista por iniciar a jornada na plataforma.', 'Concluir a primeira aula.'),
('Aluno Dedicado', 'Conquista por completar todas as aulas de um nível.', 'Concluir todas as aulas do nível.'),
('Mestre da Informática', 'Conquista por concluir a trilha de aprendizagem.', 'Concluir todas as aulas da trilha.');

-- Inserir alunos
INSERT INTO aluno (id_usuario, dt_nascimento)
VALUES
(1, '2012-05-14'),
(2, '2009-08-22'),
(3, '2006-11-03');

-- Inserir administradores
INSERT INTO administrador (id_usuario, cargo)
VALUES
(4, 'Administrador da plataforma'),
(5, 'Responsável pelo suporte');

-- Inserir aulas
INSERT INTO aula (titulo, conteudo, status, id_trilha, id_nivel)
VALUES
('Conhecendo o computador', 'Introdução às partes básicas do computador.', 'CONCLUIDA', 1, 1),
('Usando o teclado e o mouse', 'Aprendendo as funções básicas do teclado e do mouse.', 'EM_ANDAMENTO', 1, 1),
('Navegação na internet', 'Noções básicas para acessar e navegar na internet.', 'NAO_INICIADA', 2, 2),
('Segurança na internet', 'Cuidados básicos para utilizar a internet com segurança.', 'NAO_INICIADA', 2, 2),
('Ferramentas digitais', 'Uso de ferramentas digitais para atividades do dia a dia.', 'NAO_INICIADA', 3, 3),
('Organização de arquivos', 'Como criar, organizar e localizar arquivos no computador.', 'NAO_INICIADA', 3, 3);

-- Inserir progresso dos alunos
INSERT INTO progresso
(id_usuario, id_aula, situacao, data_conclusao)
VALUES
(1, 1, 'CONCLUIDO', '2026-09-10 10:30:00'),
(1, 2, 'EM_ANDAMENTO', NULL),
(2, 1, 'CONCLUIDO', '2026-09-11 14:20:00'),
(2, 2, 'CONCLUIDO', '2026-09-12 15:10:00'),
(2, 3, 'EM_ANDAMENTO', NULL),
(3, 1, 'CONCLUIDO', '2026-09-13 09:40:00');

-- Inserir conquistas dos alunos
INSERT INTO aluno_conquista
(id_usuario, id_conquista, data_conquista)
VALUES
(1, 1, '2026-09-10 10:35:00'),
(2, 1, '2026-09-11 14:25:00'),
(2, 2, '2026-09-12 15:15:00'),
(3, 1, '2026-09-13 09:45:00');

-- Inserir chamados
INSERT INTO chamado (id_usuario, assunto, status, data_abertura)
VALUES
(1, 'Dúvida sobre uma aula', 'ENCERRADO', '2026-09-10 11:00:00'),
(2, 'Problema para acessar a aula', 'EM_ATENDIMENTO', '2026-09-12 14:30:00'),
(3, 'Dúvida sobre o conteúdo', 'ABERTO', '2026-09-14 09:15:00');

-- Inserir mensagens dos chamados
INSERT INTO mensagem_chamado
(id_chamado, id_usuario, mensagem, data_envio)
VALUES
(1, 1, 'Gostaria de saber mais sobre o conteúdo da aula.', '2026-09-10 11:05:00'),
(1, 4, 'Olá! Vamos verificar sua dúvida e responder em breve.', '2026-09-10 11:20:00'),
(2, 2, 'Estou com dificuldade para acessar a aula.', '2026-09-12 14:35:00'),
(2, 4, 'Olá! Seu acesso está sendo verificado.', '2026-09-12 14:50:00'),
(3, 3, 'Não entendi uma parte do conteúdo.', '2026-09-14 09:20:00');

-- Consultas para conferir os registros
SELECT * FROM usuario;
SELECT * FROM trilha;
SELECT * FROM nivel;
SELECT * FROM conquista;
SELECT * FROM aluno;
SELECT * FROM administrador;
SELECT * FROM aula;
SELECT * FROM progresso;
SELECT * FROM aluno_conquista;
SELECT * FROM chamado;
SELECT * FROM mensagem_chamado;