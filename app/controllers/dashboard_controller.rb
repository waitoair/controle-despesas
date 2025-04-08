class DashboardController < ApplicationController
  before_action :require_login

  def show
    expenses = current_user.expenses
      .where(expense_date: Date.current.beginning_of_month..Date.current.end_of_month)

    total = expenses.sum(:amount)

    por_categoria = expenses
      .group(:category)
      .sum(:amount)
      .transform_keys(&:to_s)

    render json: {
      total: total,
      por_categoria: por_categoria
    }, status: :ok
  end
end
