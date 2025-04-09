require "csv"

class ExpensesController < ApplicationController
  before_action :require_login
  before_action :set_expense, only: %i[update destroy]

  def index
    expenses = current_user.expenses

    if params[:month].present?
      begin
        parsed_date = Date.strptime(params[:month], "%Y-%m")
        expenses = expenses.where(expense_date: parsed_date.beginning_of_month..parsed_date.end_of_month)
      rescue ArgumentError
        return render json: { error: "Formato de mês inválido. Use YYYY-MM." }, status: :bad_request
      end
    end

    if params[:start_date].present? && params[:end_date].present?
      expenses = expenses.where(expense_date: params[:start_date]..params[:end_date])
    end

    if params[:category].present?
      expenses = expenses.where(category: params[:category])
    end

    expenses = expenses.order(expense_date: :desc)

    respond_to do |format|
      format.json do
        pagy, paginated_expenses = pagy(expenses, items: params[:per_page] || 10)
        render json: {
          data: paginated_expenses,
          meta: {
            current_page: pagy.page,
            per_page: pagy.vars[:items],
            total_count: pagy.count,
            total_pages: pagy.pages
          }
        }
      end

      format.csv do
        Rails.logger.debug "[DEBUG] Entrou no format.csv"

        headers["Content-Disposition"] = "attachment; filename=despesas.csv"
        headers["Content-Type"] ||= "text/csv"
        render plain: expenses_to_csv(expenses)
      end
    end
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

  def expenses_to_csv(expenses)
    CSV.generate(headers: true) do |csv|
      csv << [ "Descrição", "Valor", "Categoria", "Data" ]

      expenses.each do |expense|
        csv << [
          expense.description,
          expense.amount,
          expense.category,
          expense.expense_date
        ]
      end
    end
  end
end
