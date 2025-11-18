# DER/MER - SkillNova Platform

## Modelo Entidade-Relacionamento (MER)

### Entidades Principais

#### USUARIO
- **id_usuario** (PK)
- nome
- email (UNIQUE)
- senha_hash
- cargo_atual
- anos_experiencia
- nivel_educacao
- pontos_totais
- percentual_completude
- data_cadastro
- data_ultimo_acesso
- status_ativo

#### TRILHA_APRENDIZADO
- **id_trilha** (PK)
- titulo
- descricao
- categoria
- nivel_dificuldade
- duracao_estimada
- pontos_recompensa
- eh_recomendada
- data_criacao
- status_ativa

#### MODULO
- **id_modulo** (PK)
- id_trilha (FK)
- titulo
- descricao
- tipo_conteudo
- duracao_minutos
- ordem_sequencia
- pontos_modulo

#### HABILIDADE
- **id_habilidade** (PK)
- nome
- categoria
- descricao

#### CONQUISTA
- **id_conquista** (PK)
- titulo
- descricao
- tipo_conquista
- pontos_necessarios
- icone

#### SESSAO_ESTUDO
- **id_sessao** (PK)
- id_usuario (FK)
- id_modulo (FK)
- data_inicio
- data_fim
- tempo_gasto_minutos
- progresso_percentual
- status_conclusao

#### USUARIO_TRILHA
- **id_usuario_trilha** (PK)
- id_usuario (FK)
- id_trilha (FK)
- data_inicio
- data_conclusao
- progresso_percentual
- status

#### USUARIO_HABILIDADE
- **id_usuario_habilidade** (PK)
- id_usuario (FK)
- id_habilidade (FK)
- nivel_proficiencia
- data_adicao

#### USUARIO_CONQUISTA
- **id_usuario_conquista** (PK)
- id_usuario (FK)
- id_conquista (FK)
- data_obtencao

#### METRICA_DIARIA
- **id_metrica** (PK)
- id_usuario (FK)
- data_metrica
- tempo_estudo_minutos
- modulos_concluidos
- pontos_ganhos
- trilhas_iniciadas

### Relacionamentos

1. **USUARIO** ←→ **TRILHA_APRENDIZADO** (N:M via USUARIO_TRILHA)
2. **TRILHA_APRENDIZADO** → **MODULO** (1:N)
3. **USUARIO** ←→ **HABILIDADE** (N:M via USUARIO_HABILIDADE)
4. **USUARIO** ←→ **CONQUISTA** (N:M via USUARIO_CONQUISTA)
5. **USUARIO** → **SESSAO_ESTUDO** (1:N)
6. **MODULO** → **SESSAO_ESTUDO** (1:N)
7. **USUARIO** → **METRICA_DIARIA** (1:N)

## Diagrama Entidade-Relacionamento (DER)

```
┌─────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   USUARIO   │────│  USUARIO_TRILHA  │────│ TRILHA_APREND.  │
│             │    │                  │    │                 │
│ id_usuario  │    │ id_usuario (FK)  │    │ id_trilha       │
│ nome        │    │ id_trilha (FK)   │    │ titulo          │
│ email       │    │ data_inicio      │    │ categoria       │
│ pontos      │    │ progresso        │    │ duracao         │
└─────────────┘    └──────────────────┘    └─────────────────┘
       │                                            │
       │                                            │
       │           ┌──────────────────┐            │
       └───────────│ SESSAO_ESTUDO    │            │
                   │                  │            │
                   │ id_usuario (FK)  │            │
                   │ id_modulo (FK)   │            │
                   │ tempo_gasto      │            │
                   │ data_inicio      │            │
                   └──────────────────┘            │
                            │                      │
                            │                      │
                   ┌──────────────────┐            │
                   │     MODULO       │────────────┘
                   │                  │
                   │ id_modulo        │
                   │ id_trilha (FK)   │
                   │ titulo           │
                   │ ordem_sequencia  │
                   └──────────────────┘

┌─────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   USUARIO   │────│ USUARIO_HABILID. │────│   HABILIDADE    │
└─────────────┘    └──────────────────┘    └─────────────────┘

┌─────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   USUARIO   │────│ USUARIO_CONQUIST.│────│   CONQUISTA     │
└─────────────┘    └──────────────────┘    └─────────────────┘

┌─────────────┐    ┌──────────────────┐
│   USUARIO   │────│ METRICA_DIARIA   │
└─────────────┘    └──────────────────┘
```