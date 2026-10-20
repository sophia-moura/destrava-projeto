USE destrava;

/* 1) Pergunta de negócio:
Quais são o nome completo, e-mail e data de cadastro de todos os
usuários com perfil de Administrador?
(Demonstra: PROJEÇÃO + SELEÇÃO com WHERE) */

SELECT
    primeiro_nome,
    sobrenome,
    email,
    dt_cadastro
FROM usuario
WHERE tipo_perfil = 'ADMINISTRADOR';

/* 2) Pergunta de negócio:
Quais alunos estão cadastrados na plataforma, ordenados do mais
novo para o mais velho?
(Demonstra: ORDENAÇÃO — ORDER BY) */

SELECT
    u.primeiro_nome,
    u.sobrenome,
    a.dt_nascimento
FROM aluno a
JOIN usuario u ON a.id_usuario = u.id_usuario
ORDER BY a.dt_nascimento DESC;

/* 3) Pergunta de negócio:
Quais aulas têm relação com o tema "internet" em seu título?
(Demonstra: uso de LIKE) */

SELECT
    titulo,
    conteudo
FROM aula
WHERE titulo LIKE '%internet%';


/* 4) Pergunta de negócio:
Quais trilhas de aprendizagem são voltadas para alunos cuja idade
mínima de entrada esteja entre 6 e 10 anos?
(Demonstra: uso de BETWEEN) */

SELECT
    nome,
    faixa_etaria_min,
    faixa_etaria_max
FROM trilha
WHERE faixa_etaria_min BETWEEN 6 AND 10;

/* 5) Pergunta de negócio:
Quais registros de progresso estão "não iniciados" ou "em
andamento", aulas que o aluno ainda não concluiu e que,
por isso, ainda não possuem data de conclusão preenchida?
(Demonstra: uso de IN + tratamento de NULL com IS NULL) */

SELECT
    p.id_usuario,
    p.id_aula,
    p.situacao,
    p.data_conclusao
FROM progresso p
WHERE p.situacao IN ('NAO_INICIADO', 'EM_ANDAMENTO')
  AND p.data_conclusao IS NULL;

/* 6) Pergunta de negócio:
Para cada registro de progresso, qual é o nome do aluno, o título
da aula e a trilha à qual essa aula pertence?
(Demonstra: JUNÇÃO envolvendo mais de três tabelas) */

SELECT
    u.primeiro_nome,
    u.sobrenome,
    au.titulo AS aula,
    t.nome AS trilha,
    p.situacao
FROM progresso p
JOIN aluno al ON p.id_usuario = al.id_usuario
JOIN usuario u ON al.id_usuario = u.id_usuario
JOIN aula au ON p.id_aula = au.id_aula
JOIN trilha t ON au.id_trilha = t.id_trilha;

/* 7) Pergunta de negócio:
Quais alunos ainda não abriram nenhum chamado de suporte?
(Demonstra: LEFT JOIN) */

SELECT
    u.primeiro_nome,
    u.sobrenome,
    c.id_chamado
FROM aluno al
JOIN usuario u ON al.id_usuario = u.id_usuario
LEFT JOIN chamado c ON al.id_usuario = c.id_usuario
WHERE c.id_chamado IS NULL;

/* 8) Pergunta de negócio:
Quais alunos já concluíram mais de uma aula na plataforma?
(Demonstra: GROUP BY + HAVING) */

SELECT
    p.id_usuario,
    COUNT(*) AS aulas_concluidas
FROM progresso p
WHERE p.situacao = 'CONCLUIDO'
GROUP BY p.id_usuario
HAVING COUNT(*) > 1;

/* 9) Pergunta de negócio:
Quantas aulas existem cadastradas em cada trilha de aprendizagem?
(Demonstra: LEFT JOIN + agregação com GROUP BY) */

SELECT
    t.nome AS trilha,
    COUNT(au.id_aula) AS total_aulas
FROM trilha t
LEFT JOIN aula au ON t.id_trilha = au.id_trilha
GROUP BY t.id_trilha, t.nome;

/* 10) Pergunta de negócio:
Quantas conquistas cada aluno já obteve na plataforma?
(Demonstra: LEFT JOIN + GROUP BY) */

SELECT
    u.primeiro_nome,
    u.sobrenome,
    COUNT(ac.id_conquista) AS total_conquistas
FROM aluno al
JOIN usuario u ON al.id_usuario = u.id_usuario
LEFT JOIN aluno_conquista ac ON al.id_usuario = ac.id_usuario
GROUP BY al.id_usuario, u.primeiro_nome, u.sobrenome;

/* 11) Pergunta de negócio:
Quais aulas ainda não foram concluídas por nenhum aluno?
(Demonstra: subconsulta correlacionada com NOT EXISTS) */

SELECT
    au.id_aula,
    au.titulo
FROM aula au
WHERE NOT EXISTS (
    SELECT 1
    FROM progresso p
    WHERE p.id_aula = au.id_aula
      AND p.situacao = 'CONCLUIDO'
);

/* 12) Pergunta de negócio:
Quais alunos possuem pelo menos um chamado de suporte em aberto?
(Demonstra: uso de EXISTS) */

SELECT
    u.primeiro_nome,
    u.sobrenome
FROM aluno al
JOIN usuario u ON al.id_usuario = u.id_usuario
WHERE EXISTS (
    SELECT 1
    FROM chamado c
    WHERE c.id_usuario = al.id_usuario
      AND c.status = 'ABERTO'
);

/* 13) Pergunta de negócio:
Quais alunos concluíram mais aulas do que a média de aulas
concluídas por aluno na plataforma (alunos com desempenho acima da média)?
(Demonstra: subconsulta correlacionada) */

SELECT
    u.primeiro_nome,
    u.sobrenome,
    (
        SELECT COUNT(*)
        FROM progresso p
        WHERE p.id_usuario = al.id_usuario
          AND p.situacao = 'CONCLUIDO'
    ) AS aulas_concluidas
FROM aluno al
JOIN usuario u ON al.id_usuario = u.id_usuario
WHERE (
    SELECT COUNT(*)
    FROM progresso p
    WHERE p.id_usuario = al.id_usuario
      AND p.situacao = 'CONCLUIDO'
) > (
    SELECT AVG(qtd_concluidas)
    FROM (
        SELECT COUNT(*) AS qtd_concluidas
        FROM progresso
        WHERE situacao = 'CONCLUIDO'
        GROUP BY id_usuario
    ) media_por_aluno
);

/* 14) Pergunta de negócio:
Quais alunos já concluíram TODAS as aulas de nível "Iniciante"
disponíveis na trilha correspondente à sua faixa etária, estando
aptos a avançar para o nível "Intermediário"?
(Demonstra: pergunta de negócio, resolvida com duplo NOT EXISTS) */

SELECT DISTINCT
    u.primeiro_nome,
    u.sobrenome,
    t.nome AS trilha
FROM aluno al
JOIN usuario u ON al.id_usuario = u.id_usuario
JOIN trilha t
    ON TIMESTAMPDIFF(YEAR, al.dt_nascimento, CURDATE())
       BETWEEN t.faixa_etaria_min AND t.faixa_etaria_max
WHERE NOT EXISTS (
    -- existe alguma aula de nível Iniciante na trilha do aluno...
    SELECT 1
    FROM aula au
    JOIN nivel n ON au.id_nivel = n.id_nivel
    WHERE au.id_trilha = t.id_trilha
      AND n.nome = 'Iniciante'
      AND NOT EXISTS (
          -- ...que o aluno ainda não concluiu
          SELECT 1
          FROM progresso p
          WHERE p.id_usuario = al.id_usuario
            AND p.id_aula = au.id_aula
            AND p.situacao = 'CONCLUIDO'
      )
);

/* 15) Pergunta de negócio:
Quais alunos já tiveram algum chamado de suporte respondido
diretamente por um administrador?
(Demonstra: subconsulta com IN) */

SELECT
    u.primeiro_nome,
    u.sobrenome
FROM aluno al
JOIN usuario u ON al.id_usuario = u.id_usuario
WHERE al.id_usuario IN (
    SELECT c.id_usuario
    FROM chamado c
    JOIN mensagem_chamado mc ON mc.id_chamado = c.id_chamado
    JOIN usuario adm ON mc.id_usuario = adm.id_usuario
    WHERE adm.tipo_perfil = 'ADMINISTRADOR'
);