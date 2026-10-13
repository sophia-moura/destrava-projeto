USE destrava;

-- Consulta a quantidade de aulas de cada trilha
SELECT
    t.nome AS trilha,
    COUNT(a.id_aula) AS total_aulas
FROM trilha t
LEFT JOIN aula a
    ON t.id_trilha = a.id_trilha
GROUP BY t.id_trilha, t.nome
ORDER BY total_aulas DESC;