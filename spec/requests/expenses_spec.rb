require "rails_helper"

RSpec.describe "Expenses", type: :request do
  let(:user) { create(:user) }
  let(:headers) { { "Content-Type" => "application/json" } }

  before do
    post "/login", params: { email: user.email, password: "123456" }
  end

  describe "GET /expenses" do
    context "sem filtros" do
      before do
        create(:expense, user: user, description: "Uber", category: "Transporte", expense_date: "2025-03-01")
        create(:expense, user: user, description: "Mercado", category: "Alimentação", expense_date: "2025-03-10")
        create(:expense, user: user, description: "Cinema", category: "Lazer", expense_date: "2025-04-01")
      end

      it "retorna todas as despesas do usuário logado" do
        get "/expenses", headers: { "Accept" => "application/json" }

        expect(response).to have_http_status(:ok)
        descriptions = response.parsed_body["data"].map { |e| e["description"] }
        expect(descriptions).to contain_exactly("Uber", "Mercado", "Cinema")
      end
    end

    context "quando filtrado por intervalo de datas" do
      before do
        create(:expense, user: user, description: "Uber", expense_date: "2025-03-01")
        create(:expense, user: user, description: "Mercado", expense_date: "2025-03-10")
        create(:expense, user: user, description: "Cinema", expense_date: "2025-04-01")
      end

      it "retorna apenas despesas dentro do intervalo" do
        get "/expenses", params: { start_date: "2025-03-01", end_date: "2025-03-31" }, headers: { "Accept" => "application/json" }

        expect(response).to have_http_status(:ok)
        descriptions = response.parsed_body["data"].map { |e| e["description"] }
        expect(descriptions).to contain_exactly("Uber", "Mercado")
      end
    end

    context "quando filtrado por categoria" do
      before do
        create(:expense, user: user, description: "Uber", category: "Transporte")
        create(:expense, user: user, description: "Cinema", category: "Lazer")
      end

      it "retorna apenas despesas da categoria informada" do
        get "/expenses", params: { category: "Transporte" }, headers: { "Accept" => "application/json" }

        expect(response).to have_http_status(:ok)
        descriptions = response.parsed_body["data"].map { |e| e["description"] }
        expect(descriptions).to contain_exactly("Uber")
      end
    end

    context "quando filtrado por mês" do
      before do
        create(:expense, user: user, description: "Aluguel", expense_date: "2025-03-05")
        create(:expense, user: user, description: "Cafeteria", expense_date: "2025-04-01")
        create(:expense, user: user, description: "Mercado", expense_date: "2025-03-20")
      end

      it "retorna apenas despesas do mês especificado" do
        get "/expenses", params: { month: "2025-03" }, headers: { "Accept" => "application/json" }

        expect(response).to have_http_status(:ok)
        descriptions = response.parsed_body["data"].map { |e| e["description"] }
        expect(descriptions).to contain_exactly("Aluguel", "Mercado")
      end
    end
  end

  describe "POST /expenses" do
    let(:valid_params) do
      {
        description: "Academia",
        amount: 99.90,
        category: "Saúde",
        expense_date: Date.today
      }.to_json
    end

    it "cria uma nova despesa para o usuário logado" do
      expect {
        post "/expenses", params: valid_params, headers: headers
      }.to change(Expense, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(response.parsed_body["description"]).to eq("Academia")
    end
  end

  describe "PATCH /expenses/:id" do
    let!(:expense) { create(:expense, user: user, description: "Academia") }

    let(:update_params) do
      {
        description: "Academia mensal",
        amount: 120.00
      }.to_json
    end

    it "atualiza a despesa do usuário logado" do
      patch "/expenses/#{expense.id}", params: update_params, headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["description"]).to eq("Academia mensal")
      expect(response.parsed_body["amount"]).to eq("120.0")
    end
  end

  describe "DELETE /expenses/:id" do
    let!(:expense) { create(:expense, user: user) }

    it "remove a despesa do usuário logado" do
      expect {
        delete "/expenses/#{expense.id}", headers: headers
      }.to change(Expense, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
