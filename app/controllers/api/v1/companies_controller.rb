class Api::V1::CompaniesController < ApplicationController
  def index
    companies = Company.order(created_at: :desc)
    render json: companies.as_json(include: :deals)
  end
end
