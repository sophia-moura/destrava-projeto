USE destrava;

-- Tabela USUARIO
-- Cada usuário possui um perfil: ALUNO ou ADMINISTRADOR
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT,
    primeiro_nome VARCHAR(50) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    dt_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_perfil VARCHAR(20) NOT NULL,

    CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuario_email UNIQUE (email),
    CONSTRAINT ck_usuario_perfil
        CHECK (tipo_perfil IN ('ALUNO', 'ADMINISTRADOR'))
);

-- Tabela TRILHA
CREATE TABLE trilha (
    id_trilha INT AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    faixa_etaria_min INT NOT NULL,
    faixa_etaria_max INT NOT NULL,

    CONSTRAINT pk_trilha PRIMARY KEY (id_trilha),
    CONSTRAINT ck_trilha_faixa_etaria
        CHECK (faixa_etaria_min <= faixa_etaria_max)
);

-- Tabela NIVEL
CREATE TABLE nivel (
    id_nivel INT AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    ordem INT NOT NULL,
    id_nivel_prerequisito INT,

    CONSTRAINT pk_nivel PRIMARY KEY (id_nivel),
    CONSTRAINT uq_nivel_nome UNIQUE (nome),
    CONSTRAINT uq_nivel_ordem UNIQUE (ordem),

    CONSTRAINT fk_nivel_prerequisito
        FOREIGN KEY (id_nivel_prerequisito)
        REFERENCES nivel (id_nivel)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Tabela CONQUISTA
CREATE TABLE conquista (
    id_conquista INT AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    criterio_desbloqueio VARCHAR(255) NOT NULL,

    CONSTRAINT pk_conquista PRIMARY KEY (id_conquista)
);

-- Tabela ALUNO
-- Cada aluno também é um usuário cadastrado
CREATE TABLE aluno (
    id_usuario INT NOT NULL,
    dt_nascimento DATE NOT NULL,

    CONSTRAINT pk_aluno PRIMARY KEY (id_usuario),

    CONSTRAINT fk_aluno_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Tabela AULA
CREATE TABLE aula (
    id_aula INT AUTO_INCREMENT,
    titulo VARCHAR(150) NOT NULL,
    conteudo TEXT NOT NULL,
    status VARCHAR(30) NOT NULL,
    id_trilha INT NOT NULL,
    id_nivel INT NOT NULL,

    CONSTRAINT pk_aula PRIMARY KEY (id_aula),

    CONSTRAINT ck_aula_status
        CHECK (status IN ('NAO_INICIADA', 'EM_ANDAMENTO', 'CONCLUIDA')),

    CONSTRAINT fk_aula_trilha
        FOREIGN KEY (id_trilha)
        REFERENCES trilha (id_trilha)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_aula_nivel
        FOREIGN KEY (id_nivel)
        REFERENCES nivel (id_nivel)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Tabela PROGRESSO
-- Cada aluno possui no máximo um registro por aula
CREATE TABLE progresso (
    id_progresso INT AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_aula INT NOT NULL,
    situacao VARCHAR(30) NOT NULL,
    data_conclusao DATETIME,

    CONSTRAINT pk_progresso PRIMARY KEY (id_progresso),

    CONSTRAINT uq_progresso_aluno_aula
        UNIQUE (id_usuario, id_aula),

    CONSTRAINT ck_progresso_situacao
        CHECK (situacao IN ('NAO_INICIADO', 'EM_ANDAMENTO', 'CONCLUIDO')),

    CONSTRAINT ck_progresso_data
        CHECK (
            (situacao = 'CONCLUIDO' AND data_conclusao IS NOT NULL)
            OR
            (situacao <> 'CONCLUIDO' AND data_conclusao IS NULL)
        ),

    CONSTRAINT fk_progresso_aluno
        FOREIGN KEY (id_usuario)
        REFERENCES aluno (id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_progresso_aula
        FOREIGN KEY (id_aula)
        REFERENCES aula (id_aula)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Tabela ALUNO_CONQUISTA
CREATE TABLE aluno_conquista (
    id_usuario INT NOT NULL,
    id_conquista INT NOT NULL,
    data_conquista DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_aluno_conquista
        PRIMARY KEY (id_usuario, id_conquista),

    CONSTRAINT fk_aluno_conquista_aluno
        FOREIGN KEY (id_usuario)
        REFERENCES aluno (id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_aluno_conquista_conquista
        FOREIGN KEY (id_conquista)
        REFERENCES conquista (id_conquista)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Tabela ADMINISTRADOR
CREATE TABLE administrador (
    id_usuario INT NOT NULL,
    cargo VARCHAR(100) NOT NULL,

    CONSTRAINT pk_administrador PRIMARY KEY (id_usuario),

    CONSTRAINT fk_administrador_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Tabela CHAMADO
CREATE TABLE chamado (
    id_chamado INT AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    assunto VARCHAR(150) NOT NULL,
    descricao TEXT NULL,
    status VARCHAR(30) NOT NULL,
    data_abertura DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_chamado PRIMARY KEY (id_chamado),

    CONSTRAINT ck_chamado_status
        CHECK (status IN ('ABERTO', 'EM_ATENDIMENTO', 'ENCERRADO')),

    CONSTRAINT fk_chamado_aluno
        FOREIGN KEY (id_usuario)
        REFERENCES aluno (id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Tabela MENSAGEM_CHAMADO
CREATE TABLE mensagem_chamado (
    id_mensagem INT AUTO_INCREMENT,
    id_chamado INT NOT NULL,
    id_usuario INT NOT NULL,
    mensagem TEXT NOT NULL,
    data_envio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_mensagem_chamado PRIMARY KEY (id_mensagem),

    CONSTRAINT fk_mensagem_chamado_chamado
        FOREIGN KEY (id_chamado)
        REFERENCES chamado (id_chamado)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_mensagem_chamado_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Conferência das tabelas existentes
SHOW TABLES;