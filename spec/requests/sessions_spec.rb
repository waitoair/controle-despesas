require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "POST /login" do
    let!(:user) { create(:user, email: "luana@example.com", password: "123456", password_confirmation: "123456") }

    context "com credenciais válidas" do
      it "loga o usuário e retorna sucesso" do
        post "/login", params: {
          email: "luana@example.com",
          password: "123456"
        }

        expect(response).to have_http_status(:ok)
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context "com credenciais inválidas" do
      it "retorna erro" do
        post "/login", params: {
          email: "luana@example.com",
          password: "errada"
        }

        expect(response).to have_http_status(:unauthorized)
        expect(session[:user_id]).to be_nil
      end
    end
  end

  describe "GET /me" do
    let!(:user) { create(:user, email: "luana@example.com", password: "123456", password_confirmation: "123456") }

    context "quando logado" do
      before do
        post "/login", params: { email: "luana@example.com", password: "123456" }
      end

      it "retorna os dados do usuário" do
        get "/me"
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body["email"]).to eq("luana@example.com")
      end
    end

    context "quando não logado" do
      it "retorna erro 401" do
        get "/me"
        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["error"]).to eq("Não autenticado")
      end
    end
  end
end
