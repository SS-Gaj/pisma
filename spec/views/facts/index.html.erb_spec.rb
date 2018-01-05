require 'spec_helper'

describe "facts/index" do
  before(:each) do
    assign(:facts, [
      stub_model(Fact,
        :fc_range => "Fc Range",
        :fc_fact => "Fc Fact",
        :fc_myurl => "Fc Myurl",
        :fc_idurl => 1
      ),
      stub_model(Fact,
        :fc_range => "Fc Range",
        :fc_fact => "Fc Fact",
        :fc_myurl => "Fc Myurl",
        :fc_idurl => 1
      )
    ])
  end

  it "renders a list of facts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Fc Range".to_s, :count => 2
    assert_select "tr>td", :text => "Fc Fact".to_s, :count => 2
    assert_select "tr>td", :text => "Fc Myurl".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
