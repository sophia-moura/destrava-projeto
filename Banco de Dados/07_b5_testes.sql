-- ============================================================
-- PROJETO DESTRAVA | B5 - TESTES PARA O RELATÓRIO
-- Execute depois de 06_b5_seguranca_controle_acesso.sql.
-- Tire print dos resultados.
-- ============================================================

USE destrava;

-- ------------------------------------------------------------
-- 1. SENHAS COM HASH E SALT (conta administrativa)
-- ------------------------------------------------------------

-- 1.1 Nenhuma senha em texto claro: só salt e hash de 128 caracteres
SELECT id_usuario, email, HEX(senha_salt) AS salt_hex,
       senha_hash, CHAR_LENGTH(senha_hash) AS tamanho_hash
FROM usuario;

-- 1.2 Login correto com usuário da carga (retorna 1 linha)
CALL sp_autenticar_usuario('ana.souza@exemplo.com', 'senha123');

-- 1.3 Login com senha errada (retorna 0 linhas)
CALL sp_autenticar_usuario('ana.souza@exemplo.com', 'senhaErrada');

-- 1.4 Mesma senha, hashes diferentes (efeito do salt)
CALL sp_cadastrar_usuario('Teste', 'Salt1', 'teste.salt1@exemplo.com', 'SenhaForte#2026', 'ALUNO', @id1);
CALL sp_cadastrar_usuario('Teste', 'Salt2', 'teste.salt2@exemplo.com', 'SenhaForte#2026', 'ALUNO', @id2);
SELECT email, senha_hash
FROM usuario
WHERE email IN ('teste.salt1@exemplo.com', 'teste.salt2@exemplo.com');

-- 1.5 Limpeza dos usuários de teste
-- DELETE FROM usuario WHERE id_usuario IN (@id1, @id2);

-- ------------------------------------------------------------
-- 2. PERMISSÕES POR PERFIL
-- Crie as contas de teste (seção 6 do script 06) e rode cada
-- bloco conectado com a conta indicada, em outra conexão.
-- Resultado esperado entre colchetes.
-- ------------------------------------------------------------

-- Conectado como aluno_teste:
-- SELECT primeiro_nome, email FROM usuario;       -- [funciona]
-- SELECT senha_hash FROM usuario;                 -- [erro: SELECT negado na coluna]
-- SELECT * FROM chamado;                          -- [erro: SELECT negado na tabela]
-- SELECT * FROM progresso;                        -- [funciona]

-- Conectado como consulta_teste:
-- SELECT * FROM vw_relatorio_aulas_publico;       -- [funciona]
-- SELECT * FROM aula;                             -- [erro: SELECT negado na tabela]
-- SELECT * FROM usuario;                          -- [erro: SELECT negado na tabela]

-- Conectado como admin_teste:
-- SELECT * FROM chamado;                          -- [funciona]
-- SELECT senha_hash FROM usuario;                 -- [erro: SELECT negado na coluna]
-- DELETE FROM usuario WHERE id_usuario = 999;     -- [erro: DELETE negado (REVOKE)]
-- CALL sp_cadastrar_usuario('Novo','Admin','novo.admin@exemplo.com','SenhaForte#2026','ALUNO',@id);  -- [funciona]