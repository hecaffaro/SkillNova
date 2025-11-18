-- SkillNova Sample Data
-- Dados de exemplo para teste

-- Inserir Habilidades
INSERT INTO HABILIDADE (id_habilidade, nome, categoria, descricao) VALUES
(seq_habilidade.NEXTVAL, 'JavaScript', 'Programação', 'Linguagem de programação web');
INSERT INTO HABILIDADE (id_habilidade, nome, categoria, descricao) VALUES
(seq_habilidade.NEXTVAL, 'Python', 'Programação', 'Linguagem de programação versátil');
INSERT INTO HABILIDADE (id_habilidade, nome, categoria, descricao) VALUES
(seq_habilidade.NEXTVAL, 'React', 'Frontend', 'Biblioteca JavaScript para interfaces');
INSERT INTO HABILIDADE (id_habilidade, nome, categoria, descricao) VALUES
(seq_habilidade.NEXTVAL, 'SQL', 'Banco de Dados', 'Linguagem de consulta estruturada');
INSERT INTO HABILIDADE (id_habilidade, nome, categoria, descricao) VALUES
(seq_habilidade.NEXTVAL, 'Scrum', 'Metodologia', 'Framework ágil de desenvolvimento');

-- Inserir Conquistas
INSERT INTO CONQUISTA (id_conquista, titulo, descricao, tipo_conquista, pontos_necessarios, icone) VALUES
(seq_conquista.NEXTVAL, 'Primeiro Passo', 'Complete seu primeiro módulo', 'PONTOS', 50, 'star');
INSERT INTO CONQUISTA (id_conquista, titulo, descricao, tipo_conquista, pontos_necessarios, icone) VALUES
(seq_conquista.NEXTVAL, 'Dedicado', 'Estude por 10 horas', 'TEMPO', 600, 'clock');
INSERT INTO CONQUISTA (id_conquista, titulo, descricao, tipo_conquista, pontos_necessarios, icone) VALUES
(seq_conquista.NEXTVAL, 'Explorador', 'Complete 3 trilhas', 'TRILHAS', 3, 'map');
INSERT INTO CONQUISTA (id_conquista, titulo, descricao, tipo_conquista, pontos_necessarios, icone) VALUES
(seq_conquista.NEXTVAL, 'Mestre', 'Acumule 1000 pontos', 'PONTOS', 1000, 'crown');

-- Inserir Trilhas de Aprendizado
INSERT INTO TRILHA_APRENDIZADO (id_trilha, titulo, descricao, categoria, nivel_dificuldade, duracao_estimada, pontos_recompensa, eh_recomendada) VALUES
(seq_trilha.NEXTVAL, 'Fundamentos de JavaScript', 'Aprenda os conceitos básicos de JavaScript', 'Programação', 'Iniciante', 480, 200, 'S');

INSERT INTO TRILHA_APRENDIZADO (id_trilha, titulo, descricao, categoria, nivel_dificuldade, duracao_estimada, pontos_recompensa, eh_recomendada) VALUES
(seq_trilha.NEXTVAL, 'Python para Data Science', 'Análise de dados com Python', 'Data Science', 'Intermediário', 720, 300, 'S');

INSERT INTO TRILHA_APRENDIZADO (id_trilha, titulo, descricao, categoria, nivel_dificuldade, duracao_estimada, pontos_recompensa, eh_recomendada) VALUES
(seq_trilha.NEXTVAL, 'React Avançado', 'Desenvolvimento avançado com React', 'Frontend', 'Avançado', 600, 250, 'N');

-- Inserir Módulos para JavaScript
INSERT INTO MODULO (id_modulo, id_trilha, titulo, descricao, tipo_conteudo, duracao_minutos, ordem_sequencia, pontos_modulo) VALUES
(seq_modulo.NEXTVAL, 1, 'Introdução ao JavaScript', 'Conceitos básicos e sintaxe', 'Video', 60, 1, 50);

INSERT INTO MODULO (id_modulo, id_trilha, titulo, descricao, tipo_conteudo, duracao_minutos, ordem_sequencia, pontos_modulo) VALUES
(seq_modulo.NEXTVAL, 1, 'Variáveis e Tipos de Dados', 'Trabalhando com dados em JS', 'Video', 45, 2, 40);

INSERT INTO MODULO (id_modulo, id_trilha, titulo, descricao, tipo_conteudo, duracao_minutos, ordem_sequencia, pontos_modulo) VALUES
(seq_modulo.NEXTVAL, 1, 'Funções em JavaScript', 'Criando e usando funções', 'Exercicio', 90, 3, 60);

-- Inserir Módulos para Python
INSERT INTO MODULO (id_modulo, id_trilha, titulo, descricao, tipo_conteudo, duracao_minutos, ordem_sequencia, pontos_modulo) VALUES
(seq_modulo.NEXTVAL, 2, 'Python Básico', 'Sintaxe e estruturas básicas', 'Video', 75, 1, 55);

INSERT INTO MODULO (id_modulo, id_trilha, titulo, descricao, tipo_conteudo, duracao_minutos, ordem_sequencia, pontos_modulo) VALUES
(seq_modulo.NEXTVAL, 2, 'Pandas para Análise', 'Manipulação de dados com Pandas', 'Projeto', 120, 2, 80);

-- Inserir usuário de exemplo
INSERT INTO USUARIO (id_usuario, nome, email, senha_hash, cargo_atual, anos_experiencia, nivel_educacao, pontos_totais) VALUES
(seq_usuario.NEXTVAL, 'João Silva', 'joao@email.com', 'hash123', 'Desenvolvedor Jr', 2, 'Superior', 150);

-- Associar usuário à trilha
INSERT INTO USUARIO_TRILHA (id_usuario_trilha, id_usuario, id_trilha, progresso_percentual, status) VALUES
(seq_usuario_trilha.NEXTVAL, 1, 1, 33.33, 'EM_ANDAMENTO');

-- Adicionar habilidades ao usuário
INSERT INTO USUARIO_HABILIDADE (id_usuario_habilidade, id_usuario, id_habilidade, nivel_proficiencia) VALUES
(seq_usuario_habilidade.NEXTVAL, 1, 1, 3.5);
INSERT INTO USUARIO_HABILIDADE (id_usuario_habilidade, id_usuario, id_habilidade, nivel_proficiencia) VALUES
(seq_usuario_habilidade.NEXTVAL, 1, 4, 2.8);

-- Registrar sessão de estudo
INSERT INTO SESSAO_ESTUDO (id_sessao, id_usuario, id_modulo, tempo_gasto_minutos, progresso_percentual, status_conclusao) VALUES
(seq_sessao.NEXTVAL, 1, 1, 60, 100, 'CONCLUIDO');

-- Criar métrica diária
INSERT INTO METRICA_DIARIA (id_metrica, id_usuario, tempo_estudo_minutos, modulos_concluidos, pontos_ganhos) VALUES
(seq_metrica.NEXTVAL, 1, 60, 1, 50);

-- Conceder primeira conquista
INSERT INTO USUARIO_CONQUISTA (id_usuario_conquista, id_usuario, id_conquista) VALUES
(seq_usuario_conquista.NEXTVAL, 1, 1);

COMMIT;