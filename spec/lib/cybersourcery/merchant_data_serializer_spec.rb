require 'rails_helper'

describe Cybersourcery::MerchantDataSerializer do
  let(:merchant_data) do
    {
      pdf_url1: 'http://promptworks-pdf.herokuapp.com/?url=http%3A%2F%2Fancile.s3-website-us-east-1.amazonaws.com%2F%3Fselected_value_drivers%3Dsales_enablement%252Corganizational_compliance%252Centerprise_software_adoption%252Cworkforce_management%26value_drivers%3Dsales_enablement%26value_drivers%3Dorganizational_compliance%26value_drivers%3Denterprise_software_adoption%26value_drivers%3Dworkforce_management%26annual_revenue%3D10%252C000%252C000%26employees%3D5%252C000%26sales_representatives%3D40%26average_amount_in_pipeline_per_sales_executive%3D5%252C000%26average_regulatory_fines_over_five_years%3D1001000%26average_cost_of_safety_incidents_over_five_years%3D2000000%26weeks_to_new_software_competency%3D8%26employees_trained_in_first_year_for_new_software%3D200%26average_support_tickets_closed_per_day_per_person%3D8%26support_staff%3D90%26weeks_to_competency%3D14%26employees_hired_per_year%3D100%26percent_attrition_per_year%3D3&width=1170&height=2000&delay=500&format=pdf',
      pdf_url2: 'http://promptworks-pdf.herokuapp.com/?url=http%3A%2F%2Fsumtotal.s3-website-us-east-1.amazonaws.com%2Fself_service.html%3Fselected_value_drivers%3Dresults%26product_checked_state_lm%3D%26product_checked_state_pm%3D%26product_checked_state_cm%3D%26product_checked_state_sp%3D%26value_drivers%3Ddriving_improved_performance_and_business_results%26products%3Dlm%26products%3Dpm%26products%3Dsp%26annual_revenue%3D1%252C000%252C000%252C000%26employees%3D10%252C000%26annual_attrition_rate%3D5%26managers_with_direct_reports%3D1%252C000%26annual_instructor_led_courses_per_employee%3D5%26average_annual_training_courses_per_employee%3D5%26number_of_ld_fte%3D32%26percent_time_spent_on_ld_admin%3D100%26number_of_pm_fte%3D4%26percent_time_spent_on_pm_admin%3D50%26number_of_cm_fte%3D20%26percent_time_spent_on_cm_admin%3D30%26percent_managers_time_spent_training_admin_for_reports%3D2%26cost_to_replace_top_performer%3D10000%26days_to_proficiency%3D21%26guilty_fine_value%3D500000%26annual_goals_per_employee%3D4%26percent_probability_of_fine%3D2%26top_performers_lost_per_year%3D60%26average_annual_revenue_from_opening%3D5%252C000%252C000%26annual_fines%3D500%26annual_openings%3D2&width=1200&height=2000&delay=500&format=pdf'
    }
  end

  describe '#serialize' do
    it 'serializes the data to json and breaks it into fields of 100 characters or less' do
      serializer = Cybersourcery::MerchantDataSerializer.new
      serialized_data = serializer.serialize(merchant_data)
      expect(serialized_data.size).to eq 23
      expect(serialized_data[:merchant_defined_data1]).to eq '{"pdf_url1":"http://promptworks-pdf.herokuapp.com/?url=http%3A%2F%2Fancile.s3-website-us-east-1.amaz'
      expect(serialized_data[:merchant_defined_data23]).to eq '6width=1200\u0026height=2000\u0026delay=500\u0026format=pdf"}'
    end

    it 'raises an exception if the count of merchant fields exceeds 100' do
      serializer = Cybersourcery::MerchantDataSerializer.new(90)
      expect { serializer.serialize(merchant_data) }.to raise_exception Cybersourcery::CybersourceryError
    end

    it 'raises an exception if the count of merchant fields is less than 1' do
      serializer = Cybersourcery::MerchantDataSerializer.new(0)
      expect { serializer.serialize(merchant_data) }.to raise_exception Cybersourcery::CybersourceryError
    end
  end

  describe '#deserialize' do
    it 'deserializes the merchant defined data fields back to the original hash' do
      serializer = Cybersourcery::MerchantDataSerializer.new
      serialized_data = serializer.serialize(merchant_data)
      params = {
        'access_key' => 'ACCESS_KEY',
        'profile_id' => 'pwksgem',
        'payment_method' => 'sale',
      }.merge! serialized_data

      expect(serializer.deserialize(params)).to eq merchant_data
    end
  end
end
