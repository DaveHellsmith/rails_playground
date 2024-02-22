class Api::V1::CompaniesController < ApplicationController
  def index
    filtered_deals = Deal.group(:company_id).select(:company_id).having('SUM(amount) >= ?', params[:deal_amount] || 0)

    companies = Company.order(created_at: :desc).includes(:deals).where(id: filtered_deals).references(:deals)

    companies = companies.where(name: params[:name]) if params[:name].present?
    companies = companies.where(industry: params[:industry]) if params[:industry].present?
    companies = companies.where('employee_count >= ?', params[:employee_count]) if params[:employee_count].present?

    render json: companies.as_json(include: :deals)
  end
end
