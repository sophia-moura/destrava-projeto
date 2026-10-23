-- ============================================================
-- PROJETO DESTRAVA | B5 - SENHAS COM HASH E SALT (MySQL 8.0+ ou MariaDB 10.4+)
--
-- ORDEM PARA CRIAR O BANCO DO ZERO:
--   01_ddl.sql -> 05_b5_senhas_hash_salt.sql (este) -> 02_dml.sql
--   -> 03_views.sql -> 06_b5_seguranca_controle_acesso.sql
--   -> 07_b5_testes.sql
--
-- BANCO JÁ POPULADO (com senhas em texto claro): execute este
-- arquivo UMA vez; a seção 3 converte as senhas existentes.
-- Depois rode 06 e 07 (o 06 recria as roles com as novas regras).
--
-- O que este script faz:
-- 1. Adiciona senha_salt e senha_hash em usuario.
-- 2. Cria fn_hash_senha (SHA-512 com salt, 10.000 rodadas) e
--    fn_gerar_salt (salt único por usuário).
-- 3. Migra as senhas existentes e remove a coluna senha.
-- 4. Cria as procedures de cadastro, autenticação e troca de senha.
-- ============================================================

USE destrava;

-- ------------------------------------------------------------
-- 1. COLUNAS PARA SALT E HASH
-- ------------------------------------------------------------

ALTER TABLE usuario
    ADD COLUMN senha_salt VARBINARY(16) NULL,
    ADD COLUMN senha_hash CHAR(128)     NULL;


-- ------------------------------------------------------------
-- 2. FUNÇÃO DE HASH (salt + senha, várias rodadas)
-- ------------------------------------------------------------

-- (Sem DROP FUNCTION IF EXISTS: em alguns servidores esse comando
-- consulta a tabela mysql.func e falha com o erro 1017.)

DELIMITER $$

CREATE FUNCTION fn_hash_senha(
    p_senha VARCHAR(255),
    p_salt  VARBINARY(16)
)
RETURNS CHAR(128)
DETERMINISTIC
BEGIN
    DECLARE v_hash CHAR(128);
    DECLARE v_i    INT DEFAULT 0;

    SET v_hash = SHA2(CONCAT(HEX(p_salt), p_senha), 512);

    WHILE v_i < 10000 DO
        SET v_hash = SHA2(CONCAT(v_hash, HEX(p_salt), p_senha), 512);
        SET v_i = v_i + 1;
    END WHILE;

    RETURN v_hash;
END$$

DELIMITER ;


-- ------------------------------------------------------------
-- 2B. FUNÇÃO QUE GERA O SALT
-- Usa UUID() e RAND(), que existem no MySQL e no MariaDB 10.4
-- (RANDOM_BYTES não existe no MariaDB 10.4). O salt precisa ser
-- único por usuário; ele não é segredo.
-- ------------------------------------------------------------

DELIMITER $$

CREATE FUNCTION fn_gerar_salt()
RETURNS VARBINARY(16)
NOT DETERMINISTIC
NO SQL
BEGIN
    RETURN UNHEX(LEFT(SHA2(CONCAT(UUID(), RAND(), UUID()), 256), 32));
END$$

DELIMITER ;


-- ------------------------------------------------------------
-- 3. MIGRAÇÃO DAS SENHAS EXISTENTES (texto claro -> hash)
-- Em banco vazio, estes comandos não alteram nenhuma linha.
-- ------------------------------------------------------------

-- id_usuario > 0 evita o erro 1175 (modo de atualização segura do Workbench).
UPDATE usuario
SET senha_salt = fn_gerar_salt()
WHERE id_usuario > 0
  AND senha_salt IS NULL;

UPDATE usuario
SET senha_hash = fn_hash_senha(senha, senha_salt)
WHERE id_usuario > 0
  AND senha_hash IS NULL;

ALTER TABLE usuario
    MODIFY senha_salt VARBINARY(16) NOT NULL,
    MODIFY senha_hash CHAR(128)     NOT NULL;

-- Remove a senha em texto claro (a coluna era NOT NULL no 01_ddl.sql).
ALTER TABLE usuario DROP COLUMN senha;


-- ------------------------------------------------------------
-- 4. PROCEDURES
-- ------------------------------------------------------------

DROP PROCEDURE IF EXISTS sp_cadastrar_usuario;
DROP PROCEDURE IF EXISTS sp_autenticar_usuario;
DROP PROCEDURE IF EXISTS sp_alterar_senha;

DELIMITER $$

-- Cadastro: gera o salt, calcula o hash e grava. Devolve o id novo em
-- p_id_usuario, para uso na inserção em aluno ou administrador.
-- tipo_perfil é validado pelo CHECK ck_usuario_perfil do DDL.
CREATE PROCEDURE sp_cadastrar_usuario(
    IN  p_primeiro_nome VARCHAR(50),
    IN  p_sobrenome     VARCHAR(100),
    IN  p_email         VARCHAR(150),
    IN  p_senha         VARCHAR(255),
    IN  p_tipo_perfil   VARCHAR(20),
    OUT p_id_usuario    INT
)
BEGIN
    DECLARE v_salt VARBINARY(16);

    IF CHAR_LENGTH(p_senha) < 8 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A senha deve ter no mínimo 8 caracteres.';
    END IF;

    SET v_salt = fn_gerar_salt();

    INSERT INTO usuario
        (primeiro_nome, sobrenome, email, senha_salt, senha_hash, tipo_perfil)
    VALUES
        (p_primeiro_nome, p_sobrenome, p_email,
         v_salt, fn_hash_senha(p_senha, v_salt), p_tipo_perfil);

    SET p_id_usuario = LAST_INSERT_ID();
END$$

-- Autenticação: devolve id_usuario e tipo_perfil se e-mail e senha
-- conferem; caso contrário, zero linhas.
CREATE PROCEDURE sp_autenticar_usuario(
    IN p_email VARCHAR(150),
    IN p_senha VARCHAR(255)
)
BEGIN
    SELECT u.id_usuario, u.tipo_perfil
    FROM usuario AS u
    WHERE u.email = p_email
      AND u.senha_hash = fn_hash_senha(p_senha, u.senha_salt);
END$$

-- Troca de senha: confere a atual e grava novo salt + novo hash.
CREATE PROCEDURE sp_alterar_senha(
    IN p_id_usuario  INT,
    IN p_senha_atual VARCHAR(255),
    IN p_senha_nova  VARCHAR(255)
)
BEGIN
    DECLARE v_salt VARBINARY(16);

    IF CHAR_LENGTH(p_senha_nova) < 8 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A senha deve ter no mínimo 8 caracteres.';
    END IF;

    SET v_salt = fn_gerar_salt();

    UPDATE usuario
    SET senha_salt = v_salt,
        senha_hash = fn_hash_senha(p_senha_nova, v_salt)
    WHERE id_usuario = p_id_usuario
      AND senha_hash = fn_hash_senha(p_senha_atual, senha_salt);

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Usuário ou senha atual inválidos.';
    END IF;
END$$

DELIMITER ;