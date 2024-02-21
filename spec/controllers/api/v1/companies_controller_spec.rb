require 'rails_helper'

describe Api::V1::CompaniesController do
  let(:parsed_response) { JSON.parse response.body }

  shared_examples 'has successful response' do
    it { is_expected.to have_http_status :ok }

    it 'has parseable response' do
      request

      expect { parsed_response }.not_to raise_error
    end
  end

  let(:company_name) {Faker::Company.name}

  let(:company_industry) {Faker::Company.industry}

  let(:company_employee_count) {rand(10..1000)}

  let(:company) do
    Company.create(
      name: company_name,
      industry: company_industry,
      employee_count: company_employee_count,
    )
  end

  let!(:deal) do
    statuses = ['pending', 'won', 'lost']

      Deal.create(
        name: "Deal",
        status: statuses.sample,
        amount: rand(10..1000),
        company_id: company.id,
      )
  end

  describe 'GET index' do
    subject(:request) { get :index }

    before do
      subject
    end

    let(:expected_result) do
      hash_including(
        {
          'id' => company.id,
          'name' => company_name,
          'industry' => company_industry,
          'employee_count' => company_employee_count,
          'deals' => [
            hash_including(
              'id' => deal.id,
              'name' => deal.name,
              'status' => deal.status,
              'amount' => deal.amount,
              'company_id' => company.id
            )
          ]
        }
      )
    end

    it 'returns a list of companies with expected attributes and associated deals' do
      expect(parsed_response).to include(expected_result)
    end
  end
end
