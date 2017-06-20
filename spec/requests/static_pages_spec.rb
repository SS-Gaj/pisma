require 'spec_helper'

describe "StaticPages" do
  describe "Страницы Новости" do
    it "should have the content 'Новости'" do
			# visit '/static_pages/news'
        visit root_path
			expect(page).to have_content('Новости')
    end
    it "should have the content 'Новости'" do
			# visit '/static_pages/news'
        visit root_path
			expect(page).to have_title('Новости')
    end
  end
  describe "Страницы Анонсы" do
    it "should have the content 'Анонсы'" do
			# visit '/static_pages/anonce'
			  visit anonce_path
			expect(page).to have_content('Анонсы')
    end
    it "should have the content 'Анонсы'" do
			# visit '/static_pages/anonce'
        visit anonce_path
			expect(page).to have_title('Анонсы')
    end
  end
  describe "Страницы Статьи" do
    it "should have the content 'Статьи'" do
			# visit '/static_pages/article'
      visit article_path
			expect(page).to have_content('Статьи')
    end
    it "should have the content 'Статьи'" do
			# visit '/static_pages/article'
        visit article_path
			expect(page).to have_title('Статьи')
    end
  end
end
