USE destrava;

-- Criação da tabela de auditoria
CREATE TABLE tb_auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    tabela_afetada VARCHAR(50) NOT NULL,
    operacao VARCHAR(10) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    data_hora DATETIME NOT NULL,
    dados_antigos TEXT,
    dados_novos TEXT
);

DELIMITER //

-- Gatilho 1 USUARIO
CREATE TRIGGER trg_auditoria_usuario_update
AFTER UPDATE ON usuario
FOR EACH ROW
BEGIN
    INSERT INTO tb_auditoria (tabela_afetada, operacao, autor, data_hora, dados_antigos, dados_novos)
    VALUES (
        'usuario',
        'UPDATE',
        USER(),
        NOW(),
        CONCAT('ID: ', OLD.id_usuario, ' | Email: ', OLD.email, ' | Perfil: ', OLD.tipo_perfil),
        CONCAT('ID: ', NEW.id_usuario, ' | Email: ', NEW.email, ' | Perfil: ', NEW.tipo_perfil)
    );
END //

-- Gatilho 2 CHAMADOS
CREATE TRIGGER trg_auditoria_chamado_update
AFTER UPDATE ON chamado
FOR EACH ROW
BEGIN
    INSERT INTO tb_auditoria (tabela_afetada, operacao, autor, data_hora, dados_antigos, dados_novos)
    VALUES (
        'chamado',
        'UPDATE',
        USER(),
        NOW(),
        CONCAT('ID Chamado: ', OLD.id_chamado, ' | Status Antigo: ', OLD.status),
        CONCAT('ID Chamado: ', NEW.id_chamado, ' | Status Novo: ', NEW.status)
    );
END //

DELIMITER ;