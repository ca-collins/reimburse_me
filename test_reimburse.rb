require 'yaml'
require 'minitest/autorun'
require_relative 'reimburse'

class TestReimburse < Minitest::Test
  def setup
    @project_sets = YAML.load_file('test_project_sets.yml')
    @reimbursement_rates = YAML.load_file('test_reimbursement_rates.yml')
  end

  def test_calculate_reimbursements
    expected_output = [165, 590, 445, 215]
    actual_output = calculate_reimbursements(@project_sets, @reimbursement_rates)
    assert_equal expected_output, actual_output
  end
end