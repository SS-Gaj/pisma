class OverlooksController < ApplicationController

  def index
    @overlooks = Overlook.paginate(page: params[:page])
    #@overlooks = Overlook.all
  end

def new #переход из ленты новостей
#создание нового файла "Обзор за ..." или вход в созданный ранее
# + записывание заголовка "Обрабатываемой" статьи и времени публикации
  #name_file = obrab_now.file_obrab
  name_file = Obrab.file_obrab  # Obrab создано в bands_controller.rb
  doc_obrab = File.open(name_file) { |f| Nokogiri::XML(f) }
  div_all_page = doc_obrab.css("html")
  article = div_all_page.css("h3")
  @div_article_header = article.first.text
  @div_date = article.last.text
#  byebug
	target_date = Date.today
	name_lk = dir_save_file(target_date) + name_save_file(target_date)  #def dir_save_file и def name_save_file locate in application_controller.rb
	unless File.exist?(name_lk)
    overlook = Overlook.new(lk_date: target_date, lk_file: name_file)
    overlook.save
		f = File.new(name_lk, 'w')
    f << "<!DOCTYPE html>"
    f << "<html>"
    f << "<head>"
    f << "<title>Reuters |  </title>"
    f << "</head>"
    f << "<body>"
    f << "<h1>" + "Обзор за " + target_date.strftime("%y%m%d") + "</h1>"
  else
    f = File.open(name_lk, 'a+')
	end # unless File.exist?(name_lk)
    f << "<h2>" + @div_article_header + "</h2>"
    f << "<h4>" + @div_date + "</h4>"
#debug
		f.close
  article = div_all_page.css("p")
  @mas_p = []
  article.each do |elem|
      @mas_p.push(elem.text.gsub("\n", " "))
  end
end

def edit	# вкл при нажатии "Copy"
#файл "Обзор за ..." открываеся по-новой и считывается в Nokogiri
#номер нужного абзаца выбирается как :id из полученного запроса	
  name_file = Obrab.file_obrab  # Obrab создано в bands_controller.rb
  doc_obrab = File.open(name_file) { |f| Nokogiri::XML(f) }
  div_all_page = doc_obrab.css("html")
  article = div_all_page.css("h3")
  @div_article_header = article.first.text
  @div_date = article.last.text
  article = div_all_page.css("p")
  @mas_p = []
  article.each do |elem|
      @mas_p.push(elem.text.gsub("\n", " "))
  end
  target_date = Date.today
	name_lk = dir_save_file(target_date) + name_save_file(target_date)  #def dir_save_file и def name_save_file locate in application_controller.rb
	if File.exist?(name_lk)
		f = File.open(name_lk, 'a+')
    f << "<p>" + @mas_p[params[:id].to_i] + "</p>"
#debug
		f.close
	end # if File.exist?(name_lk)
	article = div_all_page.css("p")
  @mas_p = []
  article.each do |elem|
      @mas_p.push(elem.text.gsub("\n", " "))
  end
	#byebug
	render "new"
end #edit

end	#class
