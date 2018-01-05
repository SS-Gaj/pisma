require 'spec_helper'

describe "facts/new" do
  before(:each) do
    assign(:fact, stub_model(Fact,
      :fc_range => "MyString",
      :fc_fact => "MyString",
      :fc_myurl => "MyString",
      :fc_idurl => 1
    ).as_new_record)
  end

  it "renders new fact form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", facts_path, "post" do
      assert_select "input#fact_fc_range[name=?]", "fact[fc_range]"
      assert_select "input#fact_fc_fact[name=?]", "fact[fc_fact]"
      assert_select "input#fact_fc_myurl[name=?]", "fact[fc_myurl]"
      assert_select "input#fact_fc_idurl[name=?]", "fact[fc_idurl]"
    end
  end
end
