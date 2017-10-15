class OverlooksController < ApplicationController

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
		f = File.new(name_lk, 'w')
	  f << "Обзор за " + target_date.strftime("%y%m%d") + "\n"
  else
    f = File.open(name_lk, 'a+')
	end # unless File.exist?(name_lk)
  	  f << @div_article_header + "\n"
    f << @div_date + "\n\n"
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
    f << @mas_p[params[:id].to_i] + "\n\n"
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

#private

end	#class
