require 'rails_helper'

RSpec.describe "locations/new", type: :view do
  before(:each) do
    assign(:location, Location.new(
      :name => "MyString",
      :address => "MyString",
      :directions => "MyText",
      :organization => nil
    ))
  end

  it "renders new location form" do
    render

    assert_select "form[action=?][method=?]", locations_path, "post" do

      assert_select "input#location_name[name=?]", "location[name]"

      assert_select "input#location_address[name=?]", "location[address]"

      assert_select "textarea#location_directions[name=?]", "location[directions]"

      assert_select "input#location_organization_id[name=?]", "location[organization_id]"
    end
  end
end
