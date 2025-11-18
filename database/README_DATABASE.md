# SkillNova Database Documentation

## 📊 Estrutura do Banco de Dados

### Arquivos Principais

1. **`DER_MER_SkillNova.md`** - Documentação do modelo de dados
2. **`create_tables.sql`** - Script de criação das tabelas
3. **`plsql_procedures.sql`** - Procedures e functions PL/SQL
4. **`sample_data.sql`** - Dados de exemplo para teste
5. **`test_procedures.sql`** - Scripts de teste das procedures

## 🗃️ Entidades Principais

### Core Entities
- **USUARIO** - Dados dos usuários da plataforma
- **TRILHA_APRENDIZADO** - Cursos/trilhas disponíveis
- **MODULO** - Módulos individuais de cada trilha
- **SESSAO_ESTUDO** - Registro de atividades de estudo

### Support Entities
- **HABILIDADE** - Catálogo de habilidades
- **CONQUISTA** - Sistema de gamificação
- **METRICA_DIARIA** - Analytics e métricas

### Relationship Tables
- **USUARIO_TRILHA** - Progresso do usuário nas trilhas
- **USUARIO_HABILIDADE** - Habilidades do usuário
- **USUARIO_CONQUISTA** - Conquistas obtidas

## 🔧 Procedures PL/SQL Implementadas

### 1. `registrar_sessao_estudo`
**Função**: Registra uma sessão de estudo do usuário
**Parâmetros**:
- `p_id_usuario` - ID do usuário
- `p_id_modulo` - ID do módulo estudado
- `p_tempo_gasto` - Tempo em minutos
- `p_progresso` - Percentual de progresso (0-100)

**Automações**:
- Atualiza pontos do usuário
- Atualiza métricas diárias
- Verifica progresso da trilha
- Concede conquistas automaticamente

### 2. `atualizar_metricas_diarias`
**Função**: Atualiza ou cria métricas do dia atual
**Parâmetros**:
- `p_id_usuario` - ID do usuário
- `p_tempo_estudo` - Tempo estudado
- `p_modulos_concluidos` - Módulos finalizados
- `p_pontos_ganhos` - Pontos obtidos
- `p_trilhas_iniciadas` - Novas trilhas iniciadas

### 3. `atualizar_progresso_trilha`
**Função**: Calcula e atualiza progresso da trilha
**Automações**:
- Calcula percentual de conclusão
- Atualiza status da trilha
- Concede pontos de recompensa
- Verifica conquistas

### 4. `verificar_conquistas`
**Função**: Verifica e concede conquistas baseadas em critérios
**Tipos de Conquista**:
- **PONTOS** - Baseado em pontuação total
- **TRILHAS** - Baseado em trilhas concluídas
- **TEMPO** - Baseado em tempo de estudo

### 5. `calcular_completude_perfil`
**Função**: Calcula percentual de completude do perfil
**Critérios**:
- Nome/Email: 20% (base)
- Cargo atual: +15%
- Habilidades: +20%
- Experiência: +15%
- Educação: +15%
- Trilhas iniciadas: +15%

### 6. `gerar_relatorio_desempenho`
**Função**: Gera relatório de desempenho do usuário
**Métricas**:
- Tempo total de estudo
- Módulos concluídos
- Pontos ganhos
- Trilhas ativas

## 🚀 Como Usar

### 1. Instalação
```sql
-- 1. Executar criação das tabelas
@create_tables.sql

-- 2. Instalar procedures
@plsql_procedures.sql

-- 3. Inserir dados de exemplo
@sample_data.sql
```

### 2. Teste das Funcionalidades
```sql
-- Executar testes
@test_procedures.sql
```

### 3. Exemplos de Uso

#### Registrar Sessão de Estudo
```sql
BEGIN
    registrar_sessao_estudo(
        p_id_usuario => 1,
        p_id_modulo => 2,
        p_tempo_gasto => 60,
        p_progresso => 100
    );
END;
/
```

#### Gerar Relatório
```sql
BEGIN
    gerar_relatorio_desempenho(
        p_id_usuario => 1,
        p_data_inicio => SYSDATE - 30,
        p_data_fim => SYSDATE
    );
END;
/
```

## 📈 Automações Implementadas

### Triggers Automáticos
- **`trg_atualizar_completude`** - Atualiza completude do perfil automaticamente

### Processos Automatizados
1. **Pontuação**: Automática ao completar módulos
2. **Progresso**: Calculado automaticamente por trilha
3. **Conquistas**: Verificação automática após ações
4. **Métricas**: Consolidação diária automática
5. **Completude**: Recálculo automático do perfil

### Integridade de Dados
- Foreign Keys para relacionamentos
- Constraints de validação
- Sequences para PKs
- Índices para performance

## 🔍 Consultas Úteis

### Dashboard do Usuário
```sql
SELECT 
    u.nome,
    u.pontos_totais,
    u.percentual_completude,
    COUNT(DISTINCT ut.id_trilha) as trilhas_ativas,
    COUNT(DISTINCT uc.id_conquista) as conquistas
FROM USUARIO u
LEFT JOIN USUARIO_TRILHA ut ON u.id_usuario = ut.id_usuario
LEFT JOIN USUARIO_CONQUISTA uc ON u.id_usuario = uc.id_usuario
WHERE u.id_usuario = :user_id
GROUP BY u.nome, u.pontos_totais, u.percentual_completude;
```

### Métricas Semanais
```sql
SELECT 
    data_metrica,
    tempo_estudo_minutos,
    modulos_concluidos,
    pontos_ganhos
FROM METRICA_DIARIA
WHERE id_usuario = :user_id
AND data_metrica >= SYSDATE - 7
ORDER BY data_metrica;
```

### Ranking de Usuários
```sql
SELECT 
    nome,
    pontos_totais,
    RANK() OVER (ORDER BY pontos_totais DESC) as ranking
FROM USUARIO
WHERE status_ativo = 'S'
ORDER BY pontos_totais DESC;
```

## 🎯 Benefícios da Implementação

1. **Automação Completa**: Processos manuais eliminados
2. **Integridade**: Dados sempre consistentes
3. **Performance**: Índices otimizados
4. **Escalabilidade**: Estrutura preparada para crescimento
5. **Analytics**: Métricas detalhadas para insights
6. **Gamificação**: Sistema de conquistas automático
7. **Auditoria**: Histórico completo de atividades