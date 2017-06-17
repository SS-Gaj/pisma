require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do
    it "should have the content 'home'" do
			visit '/static_pages/home'
			expect(page).to have_content('home')
    end
  end
  describe "Help page" do
    it "should have the content 'help'" do
			visit '/static_pages/help'
			expect(page).to have_content('help')
    end
  end
  describe "Страницы Статьи" do
    it "should have the content 'Статьи'" do
			visit '/static_pages/article'
			expect(page).to have_content('Статьи')
    end
  end
end
