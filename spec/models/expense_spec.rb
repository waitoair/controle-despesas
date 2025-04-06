require "rails_helper"

RSpec.describe Expense, type: :model do
  subject(:expense) { build(:expense) }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:expense_date) }
    it { is_expected.to validate_presence_of(:category) }
  end
end
