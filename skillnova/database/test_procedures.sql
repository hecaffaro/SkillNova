-- SkillNova Test Procedures
-- Scripts para testar as procedures PL/SQL

-- Teste 1: Registrar nova sessão de estudo
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TESTE 1: Registrar Sessão de Estudo ===');
    
    -- Registrar sessão do módulo 2 para usuário 1
    registrar_sessao_estudo(
        p_id_usuario => 1,
        p_id_modulo => 2,
        p_tempo_gasto => 45,
        p_progresso => 100
    );
    
    DBMS_OUTPUT.PUT_LINE('Sessão registrada com sucesso!');
END;
/

-- Teste 2: Verificar métricas atualizadas
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TESTE 2: Verificar Métricas ===');
    
    FOR rec IN (
        SELECT tempo_estudo_minutos, modulos_concluidos, pontos_ganhos
        FROM METRICA_DIARIA
        WHERE id_usuario = 1 AND data_metrica = TRUNC(SYSDATE)
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Tempo: ' || rec.tempo_estudo_minutos || ' min');
        DBMS_OUTPUT.PUT_LINE('Módulos: ' || rec.modulos_concluidos);
        DBMS_OUTPUT.PUT_LINE('Pontos: ' || rec.pontos_ganhos);
    END LOOP;
END;
/

-- Teste 3: Verificar progresso da trilha
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TESTE 3: Progresso da Trilha ===');
    
    FOR rec IN (
        SELECT progresso_percentual, status
        FROM USUARIO_TRILHA
        WHERE id_usuario = 1 AND id_trilha = 1
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Progresso: ' || rec.progresso_percentual || '%');
        DBMS_OUTPUT.PUT_LINE('Status: ' || rec.status);
    END LOOP;
END;
/

-- Teste 4: Completar trilha inteira
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TESTE 4: Completar Trilha ===');
    
    -- Completar módulo 3 (último da trilha JavaScript)
    registrar_sessao_estudo(
        p_id_usuario => 1,
        p_id_modulo => 3,
        p_tempo_gasto => 90,
        p_progresso => 100
    );
    
    DBMS_OUTPUT.PUT_LINE('Módulo final concluído!');
END;
/

-- Teste 5: Verificar conquistas obtidas
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TESTE 5: Conquistas Obtidas ===');
    
    FOR rec IN (
        SELECT c.titulo, uc.data_obtencao
        FROM USUARIO_CONQUISTA uc
        JOIN CONQUISTA c ON uc.id_conquista = c.id_conquista
        WHERE uc.id_usuario = 1
        ORDER BY uc.data_obtencao
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Conquista: ' || rec.titulo);
        DBMS_OUTPUT.PUT_LINE('Data: ' || TO_CHAR(rec.data_obtencao, 'DD/MM/YYYY HH24:MI'));
        DBMS_OUTPUT.PUT_LINE('---');
    END LOOP;
END;
/

-- Teste 6: Gerar relatório de desempenho
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TESTE 6: Relatório de Desempenho ===');
    
    gerar_relatorio_desempenho(
        p_id_usuario => 1,
        p_data_inicio => SYSDATE - 7,
        p_data_fim => SYSDATE
    );
END;
/

-- Teste 7: Verificar completude do perfil
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TESTE 7: Completude do Perfil ===');
    
    FOR rec IN (
        SELECT nome, percentual_completude, pontos_totais
        FROM USUARIO
        WHERE id_usuario = 1
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Usuário: ' || rec.nome);
        DBMS_OUTPUT.PUT_LINE('Completude: ' || rec.percentual_completude || '%');
        DBMS_OUTPUT.PUT_LINE('Pontos: ' || rec.pontos_totais);
    END LOOP;
END;
/

-- Teste 8: Simular múltiplas sessões de estudo
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TESTE 8: Múltiplas Sessões ===');
    
    -- Iniciar nova trilha (Python)
    INSERT INTO USUARIO_TRILHA (id_usuario_trilha, id_usuario, id_trilha, progresso_percentual, status) 
    VALUES (seq_usuario_trilha.NEXTVAL, 1, 2, 0, 'INICIADA');
    
    -- Atualizar métricas para trilha iniciada
    atualizar_metricas_diarias(
        p_id_usuario => 1,
        p_trilhas_iniciadas => 1
    );
    
    -- Estudar módulo Python
    registrar_sessao_estudo(
        p_id_usuario => 1,
        p_id_modulo => 4,
        p_tempo_gasto => 75,
        p_progresso => 100
    );
    
    DBMS_OUTPUT.PUT_LINE('Nova trilha iniciada e primeiro módulo concluído!');
    
    COMMIT;
END;
/

-- Consulta final: Status geral do usuário
SELECT 
    u.nome,
    u.pontos_totais,
    u.percentual_completude,
    COUNT(DISTINCT ut.id_trilha) as trilhas_ativas,
    COUNT(DISTINCT uc.id_conquista) as conquistas,
    NVL(SUM(md.tempo_estudo_minutos), 0) as tempo_total_estudo
FROM USUARIO u
LEFT JOIN USUARIO_TRILHA ut ON u.id_usuario = ut.id_usuario
LEFT JOIN USUARIO_CONQUISTA uc ON u.id_usuario = uc.id_usuario
LEFT JOIN METRICA_DIARIA md ON u.id_usuario = md.id_usuario
WHERE u.id_usuario = 1
GROUP BY u.nome, u.pontos_totais, u.percentual_completude;