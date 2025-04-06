class Expense < ApplicationRecord
  belongs_to :user

  validates :description, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true
  validates :expense_date, presence: true
end
