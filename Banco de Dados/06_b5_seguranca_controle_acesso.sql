-- ============================================================
-- PROJETO DESTRAVA | B5 - SEGURANÇA E CONTROLE DE ACESSO
-- Banco: MySQL 8.0+ ou MariaDB 10.4+
--
-- Requisitos contemplados:
-- 1. Três perfis distintos com GRANT e REVOKE (menor privilégio).
-- 2. View para restringir as colunas visíveis a um perfil.
-- 3. Senhas armazenadas com hash e salt (feitos no MySQL por
--    05_b5_senhas_hash_salt.sql).
-- 4. Registro dos dados pessoais e dos cuidados adotados.
--
-- ORDEM DE EXECUÇÃO (banco do zero):
--   01_ddl -> 05_b5_senhas_hash_salt -> 02_dml -> 03_views
--   -> 06_b5_seguranca_controle_acesso (este) -> 07_b5_testes
--
-- PRÉ-REQUISITOS:
-- - Execute como uma conta administrativa do MySQL.
-- - 03_views.sql e 05_b5_senhas_hash_salt.sql já executados.
-- - O script pode ser executado de novo: ele recria as roles
--   (as contas de teste precisam receber as roles outra vez).
-- ============================================================

USE destrava;

-- ------------------------------------------------------------
-- 1. TRÊS PERFIS DE ACESSO (roles)
-- ------------------------------------------------------------

DROP ROLE IF EXISTS 'perfil_aluno', 'perfil_administrador', 'perfil_consulta';
CREATE ROLE 'perfil_aluno';
CREATE ROLE 'perfil_administrador';
CREATE ROLE 'perfil_consulta';


-- ------------------------------------------------------------
-- 2. PERFIL ALUNO
-- Consulta conteúdos e dados cadastrais limitados (sem senha_hash,
-- senha_salt e tipo_perfil). Registra e atualiza progresso.
-- Autentica e troca a própria senha apenas pelas procedures.
-- ------------------------------------------------------------

GRANT SELECT ON destrava.trilha    TO 'perfil_aluno';
GRANT SELECT ON destrava.nivel     TO 'perfil_aluno';
GRANT SELECT ON destrava.aula      TO 'perfil_aluno';
GRANT SELECT ON destrava.conquista TO 'perfil_aluno';

GRANT SELECT (
    id_usuario,
    primeiro_nome,
    sobrenome,
    email,
    dt_cadastro
) ON destrava.usuario TO 'perfil_aluno';

GRANT SELECT, INSERT, UPDATE
ON destrava.progresso TO 'perfil_aluno';

GRANT EXECUTE ON PROCEDURE destrava.sp_autenticar_usuario TO 'perfil_aluno';
GRANT EXECUTE ON PROCEDURE destrava.sp_alterar_senha      TO 'perfil_aluno';


-- ------------------------------------------------------------
-- 3. PERFIL ADMINISTRADOR
-- Gerencia os dados das tabelas do projeto, sem privilégio global
-- (não é root) e SEM acesso às colunas senha_hash e senha_salt.
-- Novos usuários são criados apenas por sp_cadastrar_usuario.
-- ------------------------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON destrava.trilha           TO 'perfil_administrador';
GRANT SELECT, INSERT, UPDATE, DELETE ON destrava.nivel            TO 'perfil_administrador';
GRANT SELECT, INSERT, UPDATE, DELETE ON destrava.aula             TO 'perfil_administrador';
GRANT SELECT, INSERT, UPDATE, DELETE ON destrava.conquista        TO 'perfil_administrador';
GRANT SELECT, INSERT, UPDATE, DELETE ON destrava.aluno            TO 'perfil_administrador';
GRANT SELECT, INSERT, UPDATE, DELETE ON destrava.administrador    TO 'perfil_administrador';
GRANT SELECT, INSERT, UPDATE, DELETE ON destrava.progresso        TO 'perfil_administrador';
GRANT SELECT, INSERT, UPDATE, DELETE ON destrava.aluno_conquista  TO 'perfil_administrador';
GRANT SELECT, INSERT, UPDATE, DELETE ON destrava.chamado          TO 'perfil_administrador';
GRANT SELECT, INSERT, UPDATE, DELETE ON destrava.mensagem_chamado TO 'perfil_administrador';

-- usuario: só colunas de cadastro; hash e salt ficam de fora.
GRANT SELECT (
    id_usuario, primeiro_nome, sobrenome, email, dt_cadastro, tipo_perfil
) ON destrava.usuario TO 'perfil_administrador';

GRANT UPDATE (
    primeiro_nome, sobrenome, email, tipo_perfil
) ON destrava.usuario TO 'perfil_administrador';

GRANT DELETE ON destrava.usuario TO 'perfil_administrador';

GRANT EXECUTE ON PROCEDURE destrava.sp_cadastrar_usuario  TO 'perfil_administrador';
GRANT EXECUTE ON PROCEDURE destrava.sp_autenticar_usuario TO 'perfil_administrador';
GRANT EXECUTE ON PROCEDURE destrava.sp_alterar_senha      TO 'perfil_administrador';


-- ------------------------------------------------------------
-- 4. VIEW COM COLUNAS LIMITADAS PARA O PERFIL CONSULTA
-- Mostra só o necessário ao relatório de aulas. Não expõe e-mail,
-- senha, data de nascimento ou chamados.
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW destrava.vw_relatorio_aulas_publico AS
SELECT
    t.nome AS trilha,
    n.nome AS nivel,
    a.titulo AS aula,
    a.status AS status_aula
FROM destrava.aula AS a
INNER JOIN destrava.trilha AS t
    ON a.id_trilha = t.id_trilha
INNER JOIN destrava.nivel AS n
    ON a.id_nivel = n.id_nivel;

-- O perfil consulta recebe SELECT só na view restrita.
GRANT SELECT
ON destrava.vw_relatorio_aulas_publico TO 'perfil_consulta';

GRANT EXECUTE ON PROCEDURE destrava.sp_autenticar_usuario TO 'perfil_consulta';


-- ------------------------------------------------------------
-- 5. REVOKE (menor privilégio)
-- O administrador recebeu DELETE em usuario na seção 3. Decisão:
-- contas de usuário não são excluídas pelo perfil administrador
-- (a exclusão apagaria em cascata progresso, chamados e mensagens).
-- ------------------------------------------------------------

REVOKE DELETE ON destrava.usuario FROM 'perfil_administrador';

-- Outros exemplos (executar só quando quiser retirar o acesso):
-- REVOKE UPDATE ON destrava.progresso FROM 'perfil_aluno';
-- REVOKE SELECT ON destrava.vw_relatorio_aulas_publico
--     FROM 'perfil_consulta';


-- ------------------------------------------------------------
-- 6. CONTAS DE EXEMPLO E ASSOCIAÇÃO ÀS ROLES (OPCIONAL)
-- Remova os comentários e troque as senhas por senhas fortes
-- e exclusivas. Não reutilize as senhas de exemplo.
-- ------------------------------------------------------------

-- CREATE USER IF NOT EXISTS 'aluno_teste'@'localhost'
--     IDENTIFIED BY 'Substitua_Por_Senha_Forte_1!';
-- CREATE USER IF NOT EXISTS 'admin_teste'@'localhost'
--     IDENTIFIED BY 'Substitua_Por_Senha_Forte_2!';
-- CREATE USER IF NOT EXISTS 'consulta_teste'@'localhost'
--     IDENTIFIED BY 'Substitua_Por_Senha_Forte_3!';
--
-- GRANT 'perfil_aluno'         TO 'aluno_teste'@'localhost';
-- GRANT 'perfil_administrador' TO 'admin_teste'@'localhost';
-- GRANT 'perfil_consulta'      TO 'consulta_teste'@'localhost';
--
-- MariaDB:
-- SET DEFAULT ROLE 'perfil_aluno'         FOR 'aluno_teste'@'localhost';
-- SET DEFAULT ROLE 'perfil_administrador' FOR 'admin_teste'@'localhost';
-- SET DEFAULT ROLE 'perfil_consulta'      FOR 'consulta_teste'@'localhost';
-- MySQL 8 (a palavra muda de FOR para TO):
-- SET DEFAULT ROLE 'perfil_aluno'         TO 'aluno_teste'@'localhost';
-- SET DEFAULT ROLE 'perfil_administrador' TO 'admin_teste'@'localhost';
-- SET DEFAULT ROLE 'perfil_consulta'      TO 'consulta_teste'@'localhost';


-- ------------------------------------------------------------
-- 7. CONFERIR AS PERMISSÕES
-- ------------------------------------------------------------

SHOW GRANTS FOR 'perfil_aluno';
SHOW GRANTS FOR 'perfil_administrador';
SHOW GRANTS FOR 'perfil_consulta';


-- ============================================================
-- B5 - REGISTRO PARA O RELATÓRIO: DADOS PESSOAIS E CUIDADOS
--
-- Dados pessoais identificados nas tabelas do projeto:
-- * usuario: primeiro_nome, sobrenome, email, dt_cadastro e as
--   credenciais (senha_hash e senha_salt).
-- * aluno: dt_nascimento. As trilhas atendem a faixa de 10 a 17
--   anos; dados de crianças e adolescentes exigem cuidado
--   reforçado (LGPD, art. 14).
-- * progresso e aluno_conquista: histórico de aprendizagem
--   vinculado a uma pessoa identificável.
-- * chamado: assunto, descricao, id_usuario, data_abertura.
-- * mensagem_chamado: mensagem, id_usuario, data_envio. O texto
--   livre pode conter outros dados pessoais.
--
-- Cuidados adotados:
-- * Senhas nunca são gravadas em texto claro: o MySQL guarda
--   apenas senha_hash (SHA-512, 10.000 rodadas) e senha_salt
--   (16 bytes aleatórios por usuário), calculados por
--   fn_hash_senha dentro de sp_cadastrar_usuario e
--   sp_alterar_senha. A coluna usuario.senha foi removida.
-- * O login é conferido por sp_autenticar_usuario, que recalcula
--   o hash com o salt do usuário e compara. Nenhum perfil lê
--   senha_hash ou senha_salt diretamente.
-- * Menor privilégio com roles, GRANT e REVOKE: aluno só lê
--   colunas de cadastro e altera progresso; o administrador não
--   é root, não tem acesso às colunas de credenciais e teve o
--   DELETE em usuario retirado com REVOKE.
-- * O perfil consulta acessa apenas a view
--   vw_relatorio_aulas_publico, sem dados pessoais.
-- * Evitar exibir e-mails, datas de nascimento e conteúdo de
--   chamados em relatórios sem necessidade.
-- * Limites conhecidos: GRANT em tabela não limita linhas, então
--   a aplicação deve garantir que o aluno consulte e atualize só
--   o próprio progresso. A senha trafega como parâmetro das
--   procedures: usar conexão TLS. Em produção, o ideal é hash com
--   Argon2id, bcrypt ou scrypt na aplicação, pois o MySQL não os
--   oferece nativamente.
-- * O 02_dml.sql usa senhas de demonstração apenas como argumento
--   de sp_cadastrar_usuario; elas não ficam gravadas. Não reutilize
--   essas senhas em produção.
-- ============================================================