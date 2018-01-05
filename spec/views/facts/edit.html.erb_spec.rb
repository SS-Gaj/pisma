require 'spec_helper'

describe "facts/edit" do
  before(:each) do
    @fact = assign(:fact, stub_model(Fact,
      :fc_range => "MyString",
      :fc_fact => "MyString",
      :fc_myurl => "MyString",
      :fc_idurl => 1
    ))
  end

  it "renders the edit fact form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", fact_path(@fact), "post" do
      assert_select "input#fact_fc_range[name=?]", "fact[fc_range]"
      assert_select "input#fact_fc_fact[name=?]", "fact[fc_fact]"
      assert_select "input#fact_fc_myurl[name=?]", "fact[fc_myurl]"
      assert_select "input#fact_fc_idurl[name=?]", "fact[fc_idurl]"
    end
  end
end
