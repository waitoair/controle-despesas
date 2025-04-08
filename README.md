## Controle de Despesas

Aplicativo Ruby on Rails para gerenciamento de despesas pessoais, com foco em boas práticas de código, testes automatizados, autenticação segura e cobertura de testes com SimpleCov.

Tecnologias utilizadas

* Ruby 3.4.1

* Rails 8.0.2

* PostgreSQL

* RSpec + FactoryBot + Shoulda Matchers

* Pagy (paginação)

* SimpleCov (cobertura de testes)

* GitHub Actions (CI)

## :lock: Autenticação

* Cadastro de usuário com has_secure_password

* Login e logout via sessão (session[:user_id])

* Endpoint /me para verificar usuário autenticado

## :money_with_wings: Funcionalidades de despesas

* CRUD

    - POST /expenses: cria uma nova despesa

    - GET /expenses: lista despesas do usuário logado

    - PATCH /expenses/:id: atualiza despesa

    - DELETE /expenses/:id: remove despesa

* Filtros disponíveis

    - Intervalo de datas: ?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD

    - Categoria: ?category=...

    - Mês específico: ?month=YYYY-MM

    - Paginação: ?page=1&per_page=10 (via Pagy)

* Dashboard

    - GET /dashboard: resumo das despesas do mês atual

    - Total geral

    - Total por categoria

## :test_tube: Testes automatizados

* Cobertura com RSpec

* Cobertura monitorada com SimpleCov

## :gear: Executando localmente
```ruby
bundle install
rails db:create db:migrate
rails server
```

Rodar os testes:
```ruby
rspec
```
