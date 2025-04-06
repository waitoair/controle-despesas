require "rails_helper"

RSpec.describe "Expenses", type: :request do
  let(:user) { create(:user) }
  let(:headers) { { "Content-Type" => "application/json" } }

  before do
    post "/login", params: { email: user.email, password: "123456" }
  end

  describe "GET /expenses" do
    let!(:expense1) { create(:expense, user: user, description: "Mercado") }
    let!(:expense2) { create(:expense, user: user, description: "Transporte") }

    it "retorna as despesas do usuário logado" do
      get "/expenses", headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.size).to eq(2)
      expect(response.parsed_body.map { |e| e["description"] }).to include("Mercado", "Transporte")
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
