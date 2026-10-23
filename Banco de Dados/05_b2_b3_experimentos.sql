-- Scripts usados nas demonstrações de B2 (injeção de SQL) e B3 (transações e concorrência).
-- Executar um comando por vez no MySQL Workbench, com o banco destrava já populado.
USE destrava;

-- ===== B2: injeção de SQL =====
-- (A) HIPOTÉTICO: o que aconteceria com SQL montado por concatenação (retorna todas as aulas)
SELECT a.titulo, a.status FROM aula a WHERE a.status = '' OR '1'='1';

-- (B) Consulta parametrizada (prepared statement) com a mesma entrada (retorna 0 linhas)
PREPARE consulta FROM 'SELECT a.titulo, a.status FROM aula a WHERE a.status = ?';
SET @status = "' OR '1'='1";
EXECUTE consulta USING @status;
DEALLOCATE PREPARE consulta;

-- ===== B3.1: transação com COMMIT (executar uma vez: o e-mail é único) =====
START TRANSACTION;
CALL sp_cadastrar_usuario('Teste','Sucesso','sucesso@exemplo.com','SenhaTeste#1','ALUNO', @id_novo);
INSERT INTO aluno (id_usuario, dt_nascimento) VALUES (@id_novo, '2010-01-01');
COMMIT;
SELECT u.id_usuario, u.email, a.dt_nascimento
FROM usuario u JOIN aluno a ON a.id_usuario = u.id_usuario
WHERE u.email = 'sucesso@exemplo.com';

-- ===== B3.2: falha provocada e ROLLBACK =====
START TRANSACTION;
CALL sp_cadastrar_usuario('Teste','Falha','falha@exemplo.com','SenhaTeste#2','ALUNO', @id_falha);
INSERT INTO aluno (id_usuario, dt_nascimento) VALUES (1, '2010-01-01');  -- erro 1062 (chave duplicada)
ROLLBACK;
SELECT COUNT(*) FROM usuario WHERE email = 'falha@exemplo.com';           -- 0

-- ===== B3.3: concorrência (usar DUAS conexões separadas do Workbench) =====
SELECT CONNECTION_ID();
SHOW VARIABLES LIKE '%isolation%';   -- nível de isolamento em vigor

-- Conexão 1:
-- START TRANSACTION;
-- UPDATE chamado SET status = 'EM_ATENDIMENTO' WHERE id_chamado = 3;   -- sem COMMIT

-- Conexão 2 (fica aguardando a linha bloqueada):
-- START TRANSACTION;
-- UPDATE chamado SET status = 'ENCERRADO' WHERE id_chamado = 3;

-- Para liberar: COMMIT; na conexão 1. Para restaurar o valor original da carga:
-- UPDATE chamado SET status = 'ABERTO' WHERE id_chamado = 3;