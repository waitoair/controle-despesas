class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      render json: { message: "Login realizado com sucesso" }, status: :ok
    else
      render json: { error: "E-mail ou senha inválidos" }, status: :unauthorized
    end
  end

  def show
    if current_user
      render json: { id: current_user.id, name: current_user.name, email: current_user.email }, status: :ok
    else
      render json: { error: "Não autenticado" }, status: :unauthorized
    end
  end

  def destroy
    session.delete(:user_id)
    render json: { message: "Logout realizado com sucesso" }, status: :ok
  end
end
