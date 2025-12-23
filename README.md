# BarberGo

Sistema de gerenciamento para barbearias com app mobile (Flutter) e API backend (Go).

![Go](https://img.shields.io/badge/Go-00ADD8?style=flat-square&logo=go&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)

---

## Funcionalidades

- **Autenticacao** - Login, cadastro e recuperacao de senha
- **Agendamentos** - Criar, visualizar, editar e cancelar
- **Servicos** - Gerenciar servicos oferecidos
- **Clientes** - Historico e informacoes de clientes
- **Dashboard** - Visao geral do negocio

---

## Tech Stack

### Mobile App (`/app`)
- **Flutter 3.x** - Framework multiplataforma
- **Dart** - Linguagem
- **Provider** - State management
- **HTTP** - API client

### Backend API (`/api`)
- **Go 1.21+** - Linguagem
- **Gin** - Framework web
- **GORM** - ORM
- **JWT** - Autenticacao
- **PostgreSQL** - Banco de dados

### Infraestrutura
- **Docker** - Containerizacao
- **Docker Compose** - Orquestracao

---

## Estrutura do Projeto

```
barbergo/
├── app/                  # Flutter mobile app
│   ├── lib/
│   │   ├── models/       # Data models
│   │   ├── screens/      # UI screens
│   │   ├── services/     # API services
│   │   └── widgets/      # Reusable widgets
│   └── pubspec.yaml
│
├── api/                  # Go backend
│   ├── config/           # Configuration
│   ├── controllers/      # Request handlers
│   ├── middleware/       # Auth middleware
│   ├── models/           # Database models
│   ├── utils/            # Utilities
│   └── main.go
│
└── docker-compose.yml
```

---

## Quick Start

### Com Docker

```bash
# Subir todos os servicos
docker-compose up -d

# API disponivel em http://localhost:8080
```

### Desenvolvimento Manual

#### Backend (Go)
```bash
cd api
go mod tidy
go run main.go
```

#### Mobile (Flutter)
```bash
cd app
flutter pub get
flutter run
```

---

## API Endpoints

### Autenticacao
| Metodo | Endpoint | Descricao |
|--------|----------|-----------|
| POST | `/auth/login` | Login |
| POST | `/auth/register` | Cadastro |
| POST | `/auth/forgot-password` | Recuperar senha |

### Agendamentos
| Metodo | Endpoint | Descricao |
|--------|----------|-----------|
| GET | `/appointments` | Listar agendamentos |
| POST | `/appointments` | Criar agendamento |
| PUT | `/appointments/:id` | Atualizar |
| DELETE | `/appointments/:id` | Cancelar |

### Servicos
| Metodo | Endpoint | Descricao |
|--------|----------|-----------|
| GET | `/services` | Listar servicos |
| POST | `/services` | Criar servico |
| PUT | `/services/:id` | Atualizar |
| DELETE | `/services/:id` | Remover |

---

## Screenshots

> Em breve

---

## Roadmap

- [ ] Notificacoes push
- [ ] Pagamento integrado
- [ ] Relatorios financeiros
- [ ] Versao web admin
- [ ] Multi-idioma

---

## Autor

**Italo da Silva Costa**
- GitHub: [@italosilva18](https://github.com/italosilva18)
- LinkedIn: [i-s-c](https://linkedin.com/in/i-s-c)

---

## Licenca

MIT
