require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do
    it "should have the content 'home'" do
			visit '/static_pages/home'
			expect(page).to have_content('home')
    end
  end
end
