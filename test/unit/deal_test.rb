require 'test_helper'

class DealTest < ActiveSupport::TestCase
  test "factory should be sane" do
    assert FactoryGirl.build(:deal).valid?
  end

  test "over should honor current time" do
    deal = FactoryGirl.create(:deal, :end_at => Time.zone.now + 10)
    assert !deal.over?, "Deal should not be over"
    Timecop.freeze(Time.zone.now + 10) do
      assert deal.over?, "Deal should be over"
    end
  end
end
