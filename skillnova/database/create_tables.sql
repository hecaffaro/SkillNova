-- SkillNova Database Schema
-- Criação das tabelas principais

-- Tabela de Usuários
CREATE TABLE USUARIO (
    id_usuario NUMBER PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    email VARCHAR2(150) UNIQUE NOT NULL,
    senha_hash VARCHAR2(255) NOT NULL,
    cargo_atual VARCHAR2(100),
    anos_experiencia NUMBER DEFAULT 0,
    nivel_educacao VARCHAR2(50),
    pontos_totais NUMBER DEFAULT 0,
    percentual_completude NUMBER(5,2) DEFAULT 0,
    data_cadastro DATE DEFAULT SYSDATE,
    data_ultimo_acesso DATE DEFAULT SYSDATE,
    status_ativo CHAR(1) DEFAULT 'S'
);

-- Tabela de Trilhas de Aprendizado
CREATE TABLE TRILHA_APRENDIZADO (
    id_trilha NUMBER PRIMARY KEY,
    titulo VARCHAR2(200) NOT NULL,
    descricao CLOB,
    categoria VARCHAR2(50),
    nivel_dificuldade VARCHAR2(20),
    duracao_estimada NUMBER,
    pontos_recompensa NUMBER DEFAULT 0,
    eh_recomendada CHAR(1) DEFAULT 'N',
    data_criacao DATE DEFAULT SYSDATE,
    status_ativa CHAR(1) DEFAULT 'S'
);

-- Tabela de Módulos
CREATE TABLE MODULO (
    id_modulo NUMBER PRIMARY KEY,
    id_trilha NUMBER NOT NULL,
    titulo VARCHAR2(200) NOT NULL,
    descricao CLOB,
    tipo_conteudo VARCHAR2(50),
    duracao_minutos NUMBER,
    ordem_sequencia NUMBER,
    pontos_modulo NUMBER DEFAULT 0,
    FOREIGN KEY (id_trilha) REFERENCES TRILHA_APRENDIZADO(id_trilha)
);

-- Tabela de Habilidades
CREATE TABLE HABILIDADE (
    id_habilidade NUMBER PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    categoria VARCHAR2(50),
    descricao VARCHAR2(500)
);

-- Tabela de Conquistas
CREATE TABLE CONQUISTA (
    id_conquista NUMBER PRIMARY KEY,
    titulo VARCHAR2(100) NOT NULL,
    descricao VARCHAR2(500),
    tipo_conquista VARCHAR2(50),
    pontos_necessarios NUMBER,
    icone VARCHAR2(50)
);

-- Tabela de Sessões de Estudo
CREATE TABLE SESSAO_ESTUDO (
    id_sessao NUMBER PRIMARY KEY,
    id_usuario NUMBER NOT NULL,
    id_modulo NUMBER NOT NULL,
    data_inicio DATE DEFAULT SYSDATE,
    data_fim DATE,
    tempo_gasto_minutos NUMBER,
    progresso_percentual NUMBER(5,2),
    status_conclusao VARCHAR2(20) DEFAULT 'EM_ANDAMENTO',
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    FOREIGN KEY (id_modulo) REFERENCES MODULO(id_modulo)
);

-- Tabela de Relacionamento Usuário-Trilha
CREATE TABLE USUARIO_TRILHA (
    id_usuario_trilha NUMBER PRIMARY KEY,
    id_usuario NUMBER NOT NULL,
    id_trilha NUMBER NOT NULL,
    data_inicio DATE DEFAULT SYSDATE,
    data_conclusao DATE,
    progresso_percentual NUMBER(5,2) DEFAULT 0,
    status VARCHAR2(20) DEFAULT 'INICIADA',
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    FOREIGN KEY (id_trilha) REFERENCES TRILHA_APRENDIZADO(id_trilha)
);

-- Tabela de Relacionamento Usuário-Habilidade
CREATE TABLE USUARIO_HABILIDADE (
    id_usuario_habilidade NUMBER PRIMARY KEY,
    id_usuario NUMBER NOT NULL,
    id_habilidade NUMBER NOT NULL,
    nivel_proficiencia NUMBER(3,1) DEFAULT 1.0,
    data_adicao DATE DEFAULT SYSDATE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    FOREIGN KEY (id_habilidade) REFERENCES HABILIDADE(id_habilidade)
);

-- Tabela de Relacionamento Usuário-Conquista
CREATE TABLE USUARIO_CONQUISTA (
    id_usuario_conquista NUMBER PRIMARY KEY,
    id_usuario NUMBER NOT NULL,
    id_conquista NUMBER NOT NULL,
    data_obtencao DATE DEFAULT SYSDATE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    FOREIGN KEY (id_conquista) REFERENCES CONQUISTA(id_conquista)
);

-- Tabela de Métricas Diárias
CREATE TABLE METRICA_DIARIA (
    id_metrica NUMBER PRIMARY KEY,
    id_usuario NUMBER NOT NULL,
    data_metrica DATE DEFAULT TRUNC(SYSDATE),
    tempo_estudo_minutos NUMBER DEFAULT 0,
    modulos_concluidos NUMBER DEFAULT 0,
    pontos_ganhos NUMBER DEFAULT 0,
    trilhas_iniciadas NUMBER DEFAULT 0,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
);

-- Sequences para PKs
CREATE SEQUENCE seq_usuario START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_trilha START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_modulo START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_habilidade START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_conquista START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_sessao START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_usuario_trilha START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_usuario_habilidade START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_usuario_conquista START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_metrica START WITH 1 INCREMENT BY 1;

-- Índices para performance
CREATE INDEX idx_usuario_email ON USUARIO(email);
CREATE INDEX idx_sessao_usuario ON SESSAO_ESTUDO(id_usuario);
CREATE INDEX idx_sessao_data ON SESSAO_ESTUDO(data_inicio);
CREATE INDEX idx_metrica_usuario_data ON METRICA_DIARIA(id_usuario, data_metrica);
CREATE INDEX idx_usuario_trilha_status ON USUARIO_TRILHA(id_usuario, status);