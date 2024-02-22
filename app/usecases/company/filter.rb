class Company::Filter
  def initialize(name:, industry:, min_employee_count:, min_deal_amount_sum:)
    @name = name
    @industry = industry
    @min_employee_count = min_employee_count || 0
    @min_deal_amount_sum = min_deal_amount_sum || 0
  end

  def call
    filtered_deals = Deal.group(:company_id).select(:company_id).having('SUM(amount) >= ?', @min_deal_amount_sum)

    companies = filter_by_employee_count(
      filter_by_industry(
        filter_by_name(
          Company.order(created_at: :desc).includes(:deals).where(id: filtered_deals).references(:deals),
        ),
      ),
    )

    companies.as_json(include: :deals)
  end

  def filter_by_name(companies)
    @name.present? ? companies.where(name: @name) : companies
  end

  def filter_by_industry(companies)
    @industry.present? ? companies.where(industry: @industry) : companies
  end

  def filter_by_employee_count(companies)
    @min_employee_count.present? ? companies.where('employee_count >= ?', @min_employee_count) : companies
  end
end
