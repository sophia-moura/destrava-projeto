USE destrava;

SHOW TABLES;

SELECT 'usuario' AS tabela, COUNT(*) AS quantidade FROM usuario
UNION ALL
SELECT 'administrador', COUNT(*) FROM administrador
UNION ALL
SELECT 'aluno', COUNT(*) FROM aluno
UNION ALL
SELECT 'aluno_conquista', COUNT(*) FROM aluno_conquista
UNION ALL
SELECT 'aula', COUNT(*) FROM aula
UNION ALL
SELECT 'chamado', COUNT(*) FROM chamado
UNION ALL
SELECT 'conquista', COUNT(*) FROM conquista
UNION ALL
SELECT 'mensagem_chamado', COUNT(*) FROM mensagem_chamado
UNION ALL
SELECT 'nivel', COUNT(*) FROM nivel
UNION ALL
SELECT 'progresso', COUNT(*) FROM progresso
UNION ALL
SELECT 'trilha', COUNT(*) FROM trilha;

SHOW INDEX FROM aula;

-- B4 - Consulta 1: aulas por status
-- EXPLAIN tradicional antes da otimização
EXPLAIN
SELECT *
FROM aula
WHERE status = 'NAO_INICIADA';

-- B4 - Consulta 1: tempo antes da otimização
EXPLAIN ANALYZE
SELECT *
FROM aula
WHERE status = 'NAO_INICIADA';

-- B4 - Consulta 1: índice para filtrar aulas por status
CREATE INDEX idx_aula_status ON aula(status);

-- B4 - Consulta 1: EXPLAIN depois da otimização
EXPLAIN
SELECT *
FROM aula
WHERE status = 'NAO_INICIADA';

-- B4 - Consulta 1: tempo depois da otimização
EXPLAIN ANALYZE
SELECT *
FROM aula
WHERE status = 'NAO_INICIADA';