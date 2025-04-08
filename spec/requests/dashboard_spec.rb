require "rails_helper"

RSpec.describe "Dashboard", type: :request do
  let(:user) { create(:user) }

  before do
    post "/login", params: { email: user.email, password: "123456" }
  end

  describe "GET /dashboard" do
    before do
      create(:expense, user: user, amount: 100, category: "Mercado", expense_date: Date.today)
      create(:expense, user: user, amount: 50, category: "Transporte", expense_date: Date.today)
      create(:expense, user: user, amount: 150, category: "Mercado", expense_date: Date.today.beginning_of_month)
    end

    it "retorna resumo das despesas do mês atual" do
      get "/dashboard"

      expect(response).to have_http_status(:ok)
      body = response.parsed_body

      expect(body["total"]).to eq("300.0")
      expect(body["por_categoria"]["Mercado"]).to eq("250.0")
      expect(body["por_categoria"]["Transporte"]).to eq("50.0")
    end
  end
end
