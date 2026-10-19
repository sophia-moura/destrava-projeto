USE destrava;

DESCRIBE progresso;

SHOW INDEX FROM progresso;

EXPLAIN
SELECT *
FROM progresso
WHERE situacao = 'CONCLUIDA';

EXPLAIN ANALYZE
SELECT *
FROM progresso
WHERE situacao = 'CONCLUIDA';

SELECT situacao, COUNT(*) AS quantidade
FROM progresso
GROUP BY situacao;

EXPLAIN ANALYZE
SELECT *
FROM progresso
WHERE situacao = 'CONCLUIDO';

CREATE INDEX idx_progresso_situacao
ON progresso(situacao);

EXPLAIN
SELECT *
FROM progresso
WHERE situacao = 'CONCLUIDO';

EXPLAIN ANALYZE
SELECT *
FROM progresso
WHERE situacao = 'CONCLUIDO';