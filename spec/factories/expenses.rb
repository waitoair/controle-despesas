FactoryBot.define do
  factory :expense do
    description { "Compra no mercado" }
    amount { 120.50 }
    category { "Alimentação" }
    expense_date { Date.today }
    association :user
  end
end
