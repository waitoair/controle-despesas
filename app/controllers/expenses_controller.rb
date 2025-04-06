class ExpensesController < ApplicationController
  before_action :require_login
  before_action :set_expense, only: %i[update destroy]

  def index
    expenses = current_user.expenses.order(expense_date: :desc)
    render json: expenses
  end

  def create
    expense = current_user.expenses.build(expense_params)

    if expense.save
      render json: expense, status: :created
    else
      render json: { errors: expense.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @expense.update(expense_params)
      render json: @expense
    else
      render json: { errors: @expense.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    head :no_content
  end

  private

  def set_expense
    @expense = current_user.expenses.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Despesa não encontrada" }, status: :not_found
  end

  def expense_params
    params.permit(:description, :amount, :category, :expense_date)
  end
end
