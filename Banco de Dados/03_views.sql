USE destrava;

CREATE OR REPLACE VIEW vw_relatorio_aulas AS
SELECT
    t.nome AS trilha,
    n.nome AS nivel,
    a.titulo AS aula,
    a.status AS status_aula
FROM aula a
INNER JOIN trilha t ON a.id_trilha = t.id_trilha
INNER JOIN nivel n ON a.id_nivel = n.id_nivel;