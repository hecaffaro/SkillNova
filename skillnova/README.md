# SkillNova - Plataforma de Requalificação Profissional

Uma plataforma Flutter de upskilling e reskilling baseada em IA que conecta pessoas a novas oportunidades através de requalificação personalizada e contínua.

## 🚀 Funcionalidades Implementadas

### ✅ Sistema de Avaliação Inteligente
- Dashboard visual de competências atuais
- Análise de perfil do usuário
- Métricas de completude do perfil

### ✅ Motor de Recomendação Personalizada
- Trilhas de aprendizado personalizadas
- Mapa visual da jornada de aprendizado
- Estimativas de tempo e progresso

### ✅ Módulo de Aprendizado Adaptativo
- Biblioteca de trilhas categorizadas
- Sistema de módulos com diferentes tipos de conteúdo
- Acompanhamento de progresso individual

### ✅ Assistente Virtual Especializado
- Chatbot para orientação de carreira
- Respostas contextuais baseadas no perfil
- Interface conversacional intuitiva

### ✅ Gamificação para Engajamento
- Sistema de pontos e conquistas
- Visualização clara de progresso
- Elementos motivacionais

### ✅ Analytics Personalizados
- Gráficos de progresso semanal
- Métricas de engajamento
- Dashboard com indicadores visuais

## 🛠️ Tecnologias Utilizadas

- **Flutter 3.10+** - Framework principal
- **Provider** - Gerenciamento de estado
- **FL Chart** - Gráficos e visualizações
- **Google Fonts** - Tipografia
- **HTTP** - Comunicação com APIs
- **Shared Preferences** - Armazenamento local

## 📱 Estrutura do App

```
lib/
├── main.dart                 # Ponto de entrada
├── models/                   # Modelos de dados
│   ├── user_model.dart
│   └── learning_path_model.dart
├── providers/                # Gerenciamento de estado
│   ├── user_provider.dart
│   └── learning_provider.dart
├── screens/                  # Telas principais
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── learning_paths_screen.dart
│   ├── chat_screen.dart
│   └── profile_screen.dart
├── widgets/                  # Componentes reutilizáveis
│   ├── dashboard_card.dart
│   ├── learning_path_card.dart
│   └── progress_chart.dart
└── services/                 # Serviços e APIs
    └── api_service.dart
```

## 🎯 Funcionalidades por Tela

### Dashboard
- Visão geral do progresso do usuário
- Cards informativos com métricas
- Gráfico de progresso semanal
- Trilhas recomendadas

### Trilhas de Aprendizado
- Lista completa de trilhas disponíveis
- Filtros por categoria
- Detalhes de cada trilha com módulos
- Sistema de início/continuação

### Assistente IA
- Chat interativo com respostas contextuais
- Orientação personalizada de carreira
- Sugestões baseadas no perfil do usuário

### Perfil
- Informações completas do usuário
- Indicador de completude do perfil
- Habilidades e conquistas
- Edição de dados pessoais

## 🚀 Como Executar

1. **Pré-requisitos:**
   - Flutter SDK 3.10+
   - Dart SDK
   - Android Studio / VS Code

2. **Instalação:**
   ```bash
   # Clone o repositório
   git clone <repository-url>
   cd skillnova

   # Instale as dependências
   flutter pub get

   # Execute o app
   flutter run
   ```

3. **Build para produção:**
   ```bash
   # Android
   flutter build apk --release

   # iOS
   flutter build ios --release
   ```

## 🎨 Design System

- **Cores Primárias:** Azul (#2196F3)
- **Tipografia:** Poppins (Google Fonts)
- **Componentes:** Material Design 3
- **Ícones:** Material Icons

## 📊 Métricas de Sucesso (Implementadas)

- ✅ Sistema de pontuação gamificado
- ✅ Tracking de progresso de trilhas
- ✅ Métricas de completude de perfil
- ✅ Visualização de engajamento semanal

## 🔮 Próximos Passos

1. **Integração com APIs reais**
2. **Sistema de notificações push**
3. **Modo offline com sincronização**
4. **Análise avançada com ML**
5. **Integração com plataformas de emprego**
6. **Sistema de mentoria**
7. **Certificações digitais**

## 🤝 Contribuição

Este é um protótipo funcional desenvolvido para demonstrar as funcionalidades core da plataforma SkillNova. Para contribuir:

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.