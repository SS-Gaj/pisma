require 'spec_helper'

describe "reviews/index" do
  before(:each) do
    assign(:reviews, [
      stub_model(Review,
        :rw_file => "Rw File"
      ),
      stub_model(Review,
        :rw_file => "Rw File"
      )
    ])
  end

  it "renders a list of reviews" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Rw File".to_s, :count => 2
  end
end
