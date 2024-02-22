class Company::Filter
  def initialize(name:, industry:, min_employee_count:, min_deal_amount_sum:)
    @name = name
    @industry = industry
    @min_employee_count = min_employee_count || 0
    @min_deal_amount_sum = min_deal_amount_sum || 0
  end

  def call(params)
    filtered_deals = Deal.group(:company_id).select(:company_id).having('SUM(amount) >= ?', @min_deal_amount_sum)

    companies = Company.order(created_at: :desc).includes(:deals).where(id: filtered_deals).references(:deals)

    companies = companies.where(name: params[:name]) if @name.present?
    companies = companies.where(industry: params[:industry]) if @industry.present?
    companies = companies.where('employee_count >= ?', @min_employee_count) if @min_employee_count.present?

    companies.as_json(include: :deals)
  end
end
