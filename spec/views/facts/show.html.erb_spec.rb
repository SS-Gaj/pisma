require 'spec_helper'

describe "facts/show" do
  before(:each) do
    @fact = assign(:fact, stub_model(Fact,
      :fc_range => "Fc Range",
      :fc_fact => "Fc Fact",
      :fc_myurl => "Fc Myurl",
      :fc_idurl => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Fc Range/)
    rendered.should match(/Fc Fact/)
    rendered.should match(/Fc Myurl/)
    rendered.should match(/1/)
  end
end
