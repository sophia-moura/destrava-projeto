USE destrava;

DESCRIBE chamado;

SHOW INDEX FROM chamado;

EXPLAIN
SELECT *
FROM chamado
WHERE status = 'ABERTO';

EXPLAIN ANALYZE
SELECT *
FROM chamado
WHERE status = 'ABERTO';

SELECT status, COUNT(*) AS quantidade
FROM chamado
GROUP BY status;

CREATE INDEX idx_chamado_status
ON chamado(status);

EXPLAIN
SELECT *
FROM chamado
WHERE status = 'ABERTO';

EXPLAIN ANALYZE
SELECT *
FROM chamado
WHERE status = 'ABERTO';