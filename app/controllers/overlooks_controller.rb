class OverlooksController < ApplicationController

  def index
    @overlooks = Overlook.paginate(page: params[:page])
    #@overlooks = Overlook.all
  end

def new #переход из ленты новостей после нажатия "Обработать"
# создание нового файла "Обзор за ..." или вход в созданный ранее
# + записывание заголовка "Обрабатываемой" статьи и времени публикации
  #name_file = obrab_now.file_obrab
  name_file = Obrab.file_obrab  # Obrab создано в bands_controller.rb
  doc_obrab = File.open(name_file) { |f| Nokogiri::XML(f) }
  div_all_page = doc_obrab.css("html")
  article = div_all_page.css("h3")
  @div_article_header = article.first.text
  @div_date = article.last.text
#  byebug
	#target_date = Date.today
  target_date = Date.new(DateTime.parse(@div_date).year, DateTime.parse(@div_date).mon, DateTime.parse(@div_date).day)
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

def edit	# при нажатии "Copy"
# "Обработываемый" файл открываеся по-новой и считывается в Nokogiri
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
  #target_date = Date.today
  target_date = Date.new(DateTime.parse(@div_date).year, DateTime.parse(@div_date).mon, DateTime.parse(@div_date).day)
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

  def show  #кнопка "Просмотреть" из страницы "Обзор за..."
    @overlook = Overlook.find(params[:id])
    #name_file = @overlook.lk_file
    #render "band/index"
    #redirect_to bands_path	#bands#index
  end

  def append
    @overlook = Overlook.find(params[:id])
    Obrab.new(@overlook.lk_file)
#byebug
    #redirect_to new_overlook_path	#overlooks#new
    #render "band/index"
    redirect_to bands_path	#bands#index
  end

end	#class
