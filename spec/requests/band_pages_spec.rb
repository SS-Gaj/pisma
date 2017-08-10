require 'spec_helper'

describe "Band pages" do

  subject { page }

  describe "Band index-pages" do
    before { visit bands_path }

    it { should have_content('Новости') }
    it { should have_title(full_title('Новости')) }
  end

#1 Проверка именованного маршрута create_path
  describe "Band create_path" do
    before { visit create_path }

    it { should have_content('Bands') }
  end
##1

#2 Проверка ссылки "Обновить" в подвале шаблона сайта через страницу "Новости"
  it "should have the links 'create_path' on the layout" do
    visit bands_path
    click_link "Обновить"
    expect(page).to have_content('Bands')
  end
##2

end


