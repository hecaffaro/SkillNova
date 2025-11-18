-- SkillNova PL/SQL Procedures
-- Rotinas para automação de processos

-- 1. Procedure para registrar sessão de estudo
CREATE OR REPLACE PROCEDURE registrar_sessao_estudo(
    p_id_usuario IN NUMBER,
    p_id_modulo IN NUMBER,
    p_tempo_gasto IN NUMBER,
    p_progresso IN NUMBER DEFAULT 100
) AS
    v_pontos_modulo NUMBER;
    v_id_trilha NUMBER;
BEGIN
    -- Inserir sessão de estudo
    INSERT INTO SESSAO_ESTUDO (
        id_sessao, id_usuario, id_modulo, data_inicio, data_fim,
        tempo_gasto_minutos, progresso_percentual, status_conclusao
    ) VALUES (
        seq_sessao.NEXTVAL, p_id_usuario, p_id_modulo, SYSDATE, SYSDATE,
        p_tempo_gasto, p_progresso, 
        CASE WHEN p_progresso >= 100 THEN 'CONCLUIDO' ELSE 'EM_ANDAMENTO' END
    );

    -- Se módulo foi concluído, atualizar pontos
    IF p_progresso >= 100 THEN
        SELECT pontos_modulo, id_trilha 
        INTO v_pontos_modulo, v_id_trilha
        FROM MODULO 
        WHERE id_modulo = p_id_modulo;

        -- Atualizar pontos do usuário
        UPDATE USUARIO 
        SET pontos_totais = pontos_totais + v_pontos_modulo,
            data_ultimo_acesso = SYSDATE
        WHERE id_usuario = p_id_usuario;

        -- Atualizar métricas diárias
        atualizar_metricas_diarias(p_id_usuario, p_tempo_gasto, 1, v_pontos_modulo);

        -- Verificar progresso da trilha
        atualizar_progresso_trilha(p_id_usuario, v_id_trilha);
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- 2. Procedure para atualizar métricas diárias
CREATE OR REPLACE PROCEDURE atualizar_metricas_diarias(
    p_id_usuario IN NUMBER,
    p_tempo_estudo IN NUMBER DEFAULT 0,
    p_modulos_concluidos IN NUMBER DEFAULT 0,
    p_pontos_ganhos IN NUMBER DEFAULT 0,
    p_trilhas_iniciadas IN NUMBER DEFAULT 0
) AS
    v_count NUMBER;
BEGIN
    -- Verificar se já existe registro para hoje
    SELECT COUNT(*) INTO v_count
    FROM METRICA_DIARIA
    WHERE id_usuario = p_id_usuario 
    AND data_metrica = TRUNC(SYSDATE);

    IF v_count > 0 THEN
        -- Atualizar registro existente
        UPDATE METRICA_DIARIA
        SET tempo_estudo_minutos = tempo_estudo_minutos + p_tempo_estudo,
            modulos_concluidos = modulos_concluidos + p_modulos_concluidos,
            pontos_ganhos = pontos_ganhos + p_pontos_ganhos,
            trilhas_iniciadas = trilhas_iniciadas + p_trilhas_iniciadas
        WHERE id_usuario = p_id_usuario 
        AND data_metrica = TRUNC(SYSDATE);
    ELSE
        -- Criar novo registro
        INSERT INTO METRICA_DIARIA (
            id_metrica, id_usuario, data_metrica, tempo_estudo_minutos,
            modulos_concluidos, pontos_ganhos, trilhas_iniciadas
        ) VALUES (
            seq_metrica.NEXTVAL, p_id_usuario, TRUNC(SYSDATE),
            p_tempo_estudo, p_modulos_concluidos, p_pontos_ganhos, p_trilhas_iniciadas
        );
    END IF;
END;
/

-- 3. Procedure para atualizar progresso da trilha
CREATE OR REPLACE PROCEDURE atualizar_progresso_trilha(
    p_id_usuario IN NUMBER,
    p_id_trilha IN NUMBER
) AS
    v_total_modulos NUMBER;
    v_modulos_concluidos NUMBER;
    v_progresso NUMBER;
    v_pontos_trilha NUMBER;
BEGIN
    -- Contar total de módulos da trilha
    SELECT COUNT(*) INTO v_total_modulos
    FROM MODULO
    WHERE id_trilha = p_id_trilha;

    -- Contar módulos concluídos pelo usuário
    SELECT COUNT(*) INTO v_modulos_concluidos
    FROM SESSAO_ESTUDO s
    JOIN MODULO m ON s.id_modulo = m.id_modulo
    WHERE s.id_usuario = p_id_usuario
    AND m.id_trilha = p_id_trilha
    AND s.status_conclusao = 'CONCLUIDO';

    -- Calcular progresso
    v_progresso := ROUND((v_modulos_concluidos / v_total_modulos) * 100, 2);

    -- Atualizar progresso na tabela USUARIO_TRILHA
    UPDATE USUARIO_TRILHA
    SET progresso_percentual = v_progresso,
        status = CASE 
            WHEN v_progresso >= 100 THEN 'CONCLUIDA'
            WHEN v_progresso > 0 THEN 'EM_ANDAMENTO'
            ELSE 'INICIADA'
        END,
        data_conclusao = CASE WHEN v_progresso >= 100 THEN SYSDATE ELSE NULL END
    WHERE id_usuario = p_id_usuario AND id_trilha = p_id_trilha;

    -- Se trilha foi concluída, dar pontos de recompensa
    IF v_progresso >= 100 THEN
        SELECT pontos_recompensa INTO v_pontos_trilha
        FROM TRILHA_APRENDIZADO
        WHERE id_trilha = p_id_trilha;

        UPDATE USUARIO
        SET pontos_totais = pontos_totais + v_pontos_trilha
        WHERE id_usuario = p_id_usuario;

        -- Verificar conquistas
        verificar_conquistas(p_id_usuario);
    END IF;
END;
/

-- 4. Procedure para verificar e conceder conquistas
CREATE OR REPLACE PROCEDURE verificar_conquistas(
    p_id_usuario IN NUMBER
) AS
    CURSOR c_conquistas IS
        SELECT c.id_conquista, c.titulo, c.pontos_necessarios, c.tipo_conquista
        FROM CONQUISTA c
        WHERE c.id_conquista NOT IN (
            SELECT uc.id_conquista 
            FROM USUARIO_CONQUISTA uc 
            WHERE uc.id_usuario = p_id_usuario
        );

    v_pontos_usuario NUMBER;
    v_trilhas_concluidas NUMBER;
    v_tempo_total NUMBER;
BEGIN
    -- Buscar dados do usuário
    SELECT pontos_totais INTO v_pontos_usuario
    FROM USUARIO WHERE id_usuario = p_id_usuario;

    SELECT COUNT(*) INTO v_trilhas_concluidas
    FROM USUARIO_TRILHA
    WHERE id_usuario = p_id_usuario AND status = 'CONCLUIDA';

    SELECT NVL(SUM(tempo_estudo_minutos), 0) INTO v_tempo_total
    FROM METRICA_DIARIA
    WHERE id_usuario = p_id_usuario;

    -- Verificar cada conquista
    FOR rec IN c_conquistas LOOP
        CASE rec.tipo_conquista
            WHEN 'PONTOS' THEN
                IF v_pontos_usuario >= rec.pontos_necessarios THEN
                    conceder_conquista(p_id_usuario, rec.id_conquista);
                END IF;
            
            WHEN 'TRILHAS' THEN
                IF v_trilhas_concluidas >= rec.pontos_necessarios THEN
                    conceder_conquista(p_id_usuario, rec.id_conquista);
                END IF;
            
            WHEN 'TEMPO' THEN
                IF v_tempo_total >= rec.pontos_necessarios THEN
                    conceder_conquista(p_id_usuario, rec.id_conquista);
                END IF;
        END CASE;
    END LOOP;
END;
/

-- 5. Procedure para conceder conquista
CREATE OR REPLACE PROCEDURE conceder_conquista(
    p_id_usuario IN NUMBER,
    p_id_conquista IN NUMBER
) AS
BEGIN
    INSERT INTO USUARIO_CONQUISTA (
        id_usuario_conquista, id_usuario, id_conquista, data_obtencao
    ) VALUES (
        seq_usuario_conquista.NEXTVAL, p_id_usuario, p_id_conquista, SYSDATE
    );
END;
/

-- 6. Function para calcular completude do perfil
CREATE OR REPLACE FUNCTION calcular_completude_perfil(
    p_id_usuario IN NUMBER
) RETURN NUMBER AS
    v_completude NUMBER := 20; -- Base: nome e email
    v_count NUMBER;
BEGIN
    -- Verificar cargo atual
    SELECT COUNT(*) INTO v_count
    FROM USUARIO
    WHERE id_usuario = p_id_usuario AND cargo_atual IS NOT NULL;
    IF v_count > 0 THEN v_completude := v_completude + 15; END IF;

    -- Verificar habilidades
    SELECT COUNT(*) INTO v_count
    FROM USUARIO_HABILIDADE
    WHERE id_usuario = p_id_usuario;
    IF v_count > 0 THEN v_completude := v_completude + 20; END IF;

    -- Verificar anos de experiência
    SELECT COUNT(*) INTO v_count
    FROM USUARIO
    WHERE id_usuario = p_id_usuario AND anos_experiencia > 0;
    IF v_count > 0 THEN v_completude := v_completude + 15; END IF;

    -- Verificar nível de educação
    SELECT COUNT(*) INTO v_count
    FROM USUARIO
    WHERE id_usuario = p_id_usuario AND nivel_educacao IS NOT NULL;
    IF v_count > 0 THEN v_completude := v_completude + 15; END IF;

    -- Verificar trilhas iniciadas
    SELECT COUNT(*) INTO v_count
    FROM USUARIO_TRILHA
    WHERE id_usuario = p_id_usuario;
    IF v_count > 0 THEN v_completude := v_completude + 15; END IF;

    RETURN LEAST(v_completude, 100);
END;
/

-- 7. Trigger para atualizar completude automaticamente
CREATE OR REPLACE TRIGGER trg_atualizar_completude
    AFTER INSERT OR UPDATE ON USUARIO
    FOR EACH ROW
BEGIN
    UPDATE USUARIO
    SET percentual_completude = calcular_completude_perfil(:NEW.id_usuario)
    WHERE id_usuario = :NEW.id_usuario;
END;
/

-- 8. Procedure para gerar relatório de desempenho
CREATE OR REPLACE PROCEDURE gerar_relatorio_desempenho(
    p_id_usuario IN NUMBER,
    p_data_inicio IN DATE DEFAULT SYSDATE - 30,
    p_data_fim IN DATE DEFAULT SYSDATE
) AS
    v_tempo_total NUMBER;
    v_modulos_concluidos NUMBER;
    v_pontos_ganhos NUMBER;
    v_trilhas_ativas NUMBER;
BEGIN
    -- Calcular métricas do período
    SELECT 
        NVL(SUM(tempo_estudo_minutos), 0),
        NVL(SUM(modulos_concluidos), 0),
        NVL(SUM(pontos_ganhos), 0)
    INTO v_tempo_total, v_modulos_concluidos, v_pontos_ganhos
    FROM METRICA_DIARIA
    WHERE id_usuario = p_id_usuario
    AND data_metrica BETWEEN p_data_inicio AND p_data_fim;

    -- Contar trilhas ativas
    SELECT COUNT(*) INTO v_trilhas_ativas
    FROM USUARIO_TRILHA
    WHERE id_usuario = p_id_usuario
    AND status IN ('INICIADA', 'EM_ANDAMENTO');

    -- Exibir relatório
    DBMS_OUTPUT.PUT_LINE('=== RELATÓRIO DE DESEMPENHO ===');
    DBMS_OUTPUT.PUT_LINE('Período: ' || TO_CHAR(p_data_inicio, 'DD/MM/YYYY') || 
                        ' a ' || TO_CHAR(p_data_fim, 'DD/MM/YYYY'));
    DBMS_OUTPUT.PUT_LINE('Tempo total de estudo: ' || v_tempo_total || ' minutos');
    DBMS_OUTPUT.PUT_LINE('Módulos concluídos: ' || v_modulos_concluidos);
    DBMS_OUTPUT.PUT_LINE('Pontos ganhos: ' || v_pontos_ganhos);
    DBMS_OUTPUT.PUT_LINE('Trilhas ativas: ' || v_trilhas_ativas);
END;
/