class Api::V1::CompaniesController < ApplicationController
  def index
    companies = Company::Filter.new(
      name: params[:name],
      industry: params[:industry],
      min_employee_count: params[:employee_count],
      min_deal_amount_sum: params[:deal_amount],
    ).call

    render json: companies
  end
end
