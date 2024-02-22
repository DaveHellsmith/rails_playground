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

  let(:first_company_name) {Faker::Company.name}
  let(:second_company_name) {Faker::Company.name}

  let(:first_company_industry) {Faker::Company.industry}
  let(:second_company_industry) {Faker::Company.industry}

  let(:first_company_employee_count) {rand(10..1000)}
  let(:second_company_employee_count) {rand(10..1000)}

  let(:first_company) do
    Company.create(
      name: first_company_name,
      industry: first_company_industry,
      employee_count: first_company_employee_count,
    )
  end

  let(:second_company) do
    Company.create(
      name: second_company_name,
      industry: second_company_industry,
      employee_count: second_company_employee_count,
    )
  end

  let!(:first_company_deal_amounts) do
    [
      rand(10..1000),
      rand(10..1000)
    ] 
  end

  let!(:first_company_deals) do
    statuses = ['pending', 'won', 'lost']

    first_company_deal_amounts.map do |amount, i|
      Deal.create(
        name: "Deal #{i}",
        status: statuses.sample,
        amount: amount,
        company_id: first_company.id,
      )
    end
  end

  let!(:second_company_deal_amounts) do
    [
      rand(10..1000),
      rand(10..1000),
      rand(10..1000)
    ] 
  end

  let!(:second_company_deals) do
    statuses = ['pending', 'won', 'lost']

    second_company_deal_amounts.map do |amount, i|
      Deal.create(
        name: "Deal #{i}",
        status: statuses.sample,
        amount: amount,
        company_id: second_company.id,
      )
    end
  end

  describe 'GET index' do
    subject(:request) { get :index, params: params }

    let(:params) {}

    before do
      subject
    end

    let(:first_expected_result) do
      hash_including(
        {
          'id' => first_company.id,
          'name' => first_company_name,
          'industry' => first_company_industry,
          'employee_count' => first_company_employee_count,
          'deals' => first_company_deals.map do |deal| 
            hash_including(
              'id' => deal.id,
              'name' => deal.name,
              'status' => deal.status,
              'amount' => deal.amount,
              'company_id' => first_company.id
            )
          end
        }
      )
    end

    let(:second_expected_result) do
      hash_including(
        {
          'id' => second_company.id,
          'name' => second_company_name,
          'industry' => second_company_industry,
          'employee_count' => second_company_employee_count,
          'deals' => second_company_deals.map do |deal| 
            hash_including(
              'id' => deal.id,
              'name' => deal.name,
              'status' => deal.status,
              'amount' => deal.amount,
              'company_id' => second_company.id
            )
          end
        }
      )
    end

    
    let(:name) { nil }
    let(:industry) { nil }
    let(:employee_count) { nil }
    let(:deal_amount) { nil }
    
    let(:params) do 
      {
        name: name,
        industry: industry,
        employee_count: employee_count,
        deal_amount: deal_amount,
      }
    end

    context 'when none of the filter parameters are passed' do
      include_examples 'has successful response'

      it 'returns all the companies' do
        expect(parsed_response).to include(first_expected_result, second_expected_result)
      end

      it 'returns all of the companies' do
        expect(parsed_response.length).to eq(2)
      end

      it 'returns all of the deals of the first company' do
        expect(parsed_response.last['deals'].length).to eq(2)
      end
    end

    context 'when the company name is passed' do
      let(:name) { first_company_name }

      include_examples 'has successful response'

      it 'returns only that company' do
        expect(parsed_response).to include(first_expected_result)
      end

      it 'does not return the other company' do
        expect(parsed_response).not_to include(second_expected_result)
      end
    end

    context 'when the company name is passed but it does not exist' do
      let(:name) { 'Acme' }

      include_examples 'has successful response'

      it 'returns an empty list' do
        expect(parsed_response).to match([])
      end
    end

    context 'when the industry is passed' do
      let(:industry) { first_company_industry }

      include_examples 'has successful response'

      it 'returns the matching company' do
        expect(parsed_response).to include(first_expected_result)
      end

      it 'does not return the non-matching company' do
        expect(parsed_response).not_to include(second_expected_result)
      end
    end

    context 'when the industry is passed but it does not exist' do
      let(:industry) { 'Couch Potatoing' }

      include_examples 'has successful response'

      it 'returns an empty list' do
        expect(parsed_response).to match([])
      end
    end

    context 'when the employee count is passed and they both match' do
      let(:first_company_employee_count) { 10 }
      let(:second_company_employee_count) { 50 }
      let(:employee_count) { 1 }

      include_examples 'has successful response'

      it 'returns all the matching companies' do
        expect(parsed_response).to include(first_expected_result, second_expected_result)
      end

      context 'and none of them matches' do
        let(:employee_count) { 100 }
        
        it 'returns an empty list' do
          expect(parsed_response).to match([])
        end
      end
    end

    context 'when the employee count is passed and one matches' do
      let(:first_company_employee_count) { 10 }
      let(:second_company_employee_count) { 50 }
      let(:employee_count) { 20 }

      include_examples 'has successful response'

      it 'returns the matching company azaza' do
        expect(parsed_response).to include(second_expected_result)
      end

      it 'does not return the non-matching company' do
        expect(parsed_response).not_to include(first_expected_result)
      end
    end

    context 'when the minimal deal amount sum is passed' do
      let!(:first_company_deal_amounts) do
        [
          1000,
          2000,
        ] 
      end

      let!(:second_company_deal_amounts) do
        [
          500,
          500,
          2000,
        ] 
      end

      let(:deal_amount) do
        3000
      end

      include_examples 'has successful response'

      it 'returns the companies and the matching deals' do
        expect(parsed_response).to include(first_expected_result, second_expected_result)
      end

      context 'and there are no matches' do
        let(:deal_amount) do
          4000
        end
        
        it 'returns the companies and the matching deals' do
          expect(parsed_response).to eq([])
        end
      end
    end
  end
end
