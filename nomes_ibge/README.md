# 📊 Analisador de Tendências de Nomes no Brasil - Flutter + IBGE API

Este projeto é uma aplicação Flutter que consome a **API de Nomes do IBGE** para realizar **análises de tendências de nomes próprios no Brasil**, com base em dados históricos desde a década de 1930.  
A aplicação segue os princípios da **Arquitetura Orientada a Serviços (SOA)**, com separação clara de responsabilidades entre os componentes.

---

## 🚀 Funcionalidades

1. **Evolução de um nome por décadas**

   - O usuário informa um nome e define um intervalo de décadas (ex: 1970 a 2000).
   - A aplicação exibe um **gráfico de linha** com a variação da frequência do nome nesse período.

2. **Top 3 nomes por localidade**

   - O usuário escolhe uma UF ou município.
   - A aplicação mostra uma **tabela com os 3 nomes mais populares por década** nessa localidade.

3. **Comparação de dois nomes**
   - O usuário insere dois nomes.
   - A aplicação exibe um **gráfico comparativo** da frequência dos nomes ao longo das décadas no Brasil.

---

## 🛠 Tecnologias Utilizadas

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [IBGE API de Nomes](https://servicodados.ibge.gov.br/api/docs/nomes?versao=2)
- [`http`](https://pub.dev/packages/http) – para requisições REST
- [`fl_chart`](https://pub.dev/packages/fl_chart) – para gráficos

---

## 📂 Estrutura do Projeto (SOA)

```plaintext
lib/
├── models/
│   ├── locality_ranking_model.dart
│   ├── name_data_model.dart
│   ├── name_ranking_data_model.dart
│   └── name_record_model.dart
├── screens/
│   ├── comparison_screen.dart
│   ├── home_screen.dart
│   ├── locality_names_screen.dart
│   └── name_evolution_screen.dart
├── services/
│   └── ibge_api_service.dart
└── widgets/
    ├── line_chart_widget.dart
    └── main.dart
```

- models/: Contém os modelos de dados para ranking de localidades, dados de nomes e registros
- screens/: Telas da aplicação incluindo comparação, home, localidades e evolução de nomes
- services/: Serviço de API do IBGE para consumo de dados
- widgets/: Componentes reutilizáveis como gráficos de linha e arquivo principal da aplicação

---

## ▶️ Como Executar o Projeto

### Pré-requisitos

- Flutter SDK instalado ([instalar Flutter](https://flutter.dev/docs/get-started/install))
- Android Studio, VS Code ou outro editor compatível com Flutter

### Passos

```bash
git clone https://github.com/rhayssaandretto/arquitetura_software.git
cd nomes_ibge
flutter pub get
flutter run -d chrome
```

## ✍️ Autores

- Rhayssa Justino Andretto RA: 211631272
- Yves Morello RA: 220140552 ඞ
