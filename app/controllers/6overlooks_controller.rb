class OverlooksController < ApplicationController

  def index
    @overlooks = Overlook.paginate(page: params[:page])
  end

def new #переход из ленты новостей (Биржи) после нажатия "Обработать"
# создание нового файла "Обзор за ..." или вход в созданный ранее
# + записывание заголовка "Обрабатываемой" статьи и времени публикации
    texttocopy  #/app/controllers/application_controller.rb
  #формирование имени файла "Обзор за ..."
  target_date = Date.new(DateTime.parse(@div_date).year, DateTime.parse(@div_date).mon, DateTime.parse(@div_date).day)
  name_lk = dir_save_file(target_date) + name_save_file(target_date, '/lk-', '.xml')  #def dir_save_file и def name_save_file locate in 
#byebug
	unless File.exist?(name_lk)
	  unless Overlook.exists?(lk_date: target_date)
      overlook = Overlook.new(lk_date: target_date, lk_file: name_lk)
    else
      overlook = Overlook.find_by lk_date: target_date
      overlook.lk_file  = name_lk
    end #unless Overlook.exists?(lk_date: target_date)
    overlook.save
		f = File.new(name_lk, 'w')
		@doc_f = Nokogiri::HTML::Document.parse <<-EOHTML
        <root>
          <day>Обзор за </day>
        </root>
    EOHTML
    day = @doc_f.at_css "day"
    day.content = "Обзор за " + target_date.strftime("%Y%m%d")
    #nodes = @doc_f.css "h1"
    #nodes.wrap("<div class='container'></div>")
    f << @doc_f
    f.close
	end # unless File.exist?(name_lk)
#byebug
   @doc_f = File.open(name_lk) { |f| Nokogiri::XML(f) }
   #f = File.open(name_lk, 'a+')
   f = File.new(name_lk, 'w')
    nodes = @doc_f.css "day, ahead, atime, p"       # ЯтД, это я ищу 
    ahead = Nokogiri::XML::Node.new "ahead", @doc_f # ЯтД, это я создаю
    ahead.content = @div_article_header
    nodes.last.add_next_sibling(ahead)

    nodes = @doc_f.css "day, ahead, atime, p"
    atime = Nokogiri::XML::Node.new "atime", @doc_f # ЯтД, это я создаю
    atime.content = @div_date
    nodes.last.add_next_sibling(atime)

    #nodes = @doc_f.css "day, ahead, atime, p"    
    nodes = @doc_f.css "day, article"
    article = Nokogiri::XML::Node.new "article", @doc_f   # ЯтД, это я создаю пустой узел для будущего содержания <p>
    article.content = ""
    nodes.last.add_next_sibling(article)
# h1.parent = div  # div становится "родителем" h1
    ahead.parent = article
    atime.parent = article
     f << @doc_f
#debug
		f.close
end #def new #переход из ленты новостей после нажатия "Обработать"

def edit	# при нажатии "Copy"
# "Обработываемый" файл открываеся по-новой и считывается в Nokogiri
#номер нужного абзаца выбирается как :id из полученного запроса	
  texttocopy  #  /app/helpers/overlooks_helper.rb
  add_p('/lk-')
	render "new"
  #redirect_to :back
end #edit

def editall	# при нажатии "Copy all"
# "Обработываемый" файл открываеся по-новой и считывается в Nokogiri
# копируются все <p>
  @file_obrab = Obrab.file_obrab  # Obrab создано в bands_controller.rb
  doc_obrab = File.open(@file_obrab) { |f| Nokogiri::XML(f) }
  div_all_page = doc_obrab.css("html")
  article = div_all_page.css("h3")
  @div_article_header = article.first.text
  @div_date = article.last.text
  article = div_all_page.css("p")  
  #target_date = Date.today
  target_date = Date.new(DateTime.parse(@div_date).year, DateTime.parse(@div_date).mon, DateTime.parse(@div_date).day)
  name_lk = dir_save_file(target_date) + name_save_file(target_date, '/lk-', '.xml')  #def dir_save_file и def name_save_file locate in 
	if File.exist?(name_lk)
   @doc_f = File.open(name_lk) { |f| Nokogiri::XML(f) }
   f = File.new(name_lk, 'w')
    article.each do |elem|
      nodes = @doc_f.css "ahead, atime, p"
      p = Nokogiri::XML::Node.new "p", @doc_f
      p.content = elem.text.gsub("\n", " ")
      nodes.last.add_next_sibling(p)    
    end  #article.each do |elem|
    f << @doc_f   
#debug
		f.close
	end # if File.exist?(name_lk)
#byebg
  redirect_to bands_path	#bands#index
end #editall

def editallbtc	# при нажатии "Copy all"
# "Обработываемый" файл открываеся по-новой и считывается в Nokogiri
# копируются все <p>
  @file_obrab = Obrabbtc.file_obrabbtc  # Obrabbtc создано в bands_controller.rb
  doc_obrab = File.open(@file_obrab) { |f| Nokogiri::XML(f) }
  div_all_page = doc_obrab.css("html")
  article = div_all_page.css("h3")
  @div_article_header = article.first.text
  @div_date = article.last.text
  article = div_all_page.css("p")  
  #target_date = Date.today
  target_date = Date.new(DateTime.parse(@div_date).year, DateTime.parse(@div_date).mon, DateTime.parse(@div_date).day)
  name_lk = dir_save_file(target_date) + name_save_file(target_date, '/lk_btc-', '.xml')  #def dir_save_file и def name_save_file locate in 
	if File.exist?(name_lk)
   @doc_f = File.open(name_lk) { |f| Nokogiri::XML(f) }
   f = File.new(name_lk, 'w')
    article.each do |elem|
      nodes = @doc_f.css "ahead, atime, p"
      p = Nokogiri::XML::Node.new "p", @doc_f
      p.content = elem.text.gsub("\n", " ")
      nodes.last.add_next_sibling(p)    
    end  #article.each do |elem|
    f << @doc_f   
#debug
		f.close
	end # if File.exist?(name_lk)
#byebg
  redirect_to bitcoins_path	#overlook#index
end #editallbtc



  def show  #кнопка "Просмотреть" из страницы "Обзор за..."
    @overlook = Overlook.find(params[:id])
    name_lk = @overlook.lk_file
    if File.exist?(name_lk)
      @doc_f = File.open(name_lk) { |f| Nokogiri::XML(f) }
      @article_mas = @doc_f.css "article"
    end # if File.exist?(name_lk)
  end

  def btcshow  #кнопка "Просмотреть" из страницы "Обзор за..."
    @overlook = Overlook.find(params[:id])
    name_lk = @overlook.lk_btcfile
    if File.exist?(name_lk)
      @doc_f = File.open(name_lk) { |f| Nokogiri::XML(f) }
      @article_mas = @doc_f.css "article"
    end # if File.exist?(name_lk)
    render "show"
  end

def btcnew #переход из ленты новостей после нажатия "Обработать"
# создание нового файла "Обзор за ..." или вход в созданный ранее
# + записывание заголовка "Обрабатываемой" статьи и времени публикации

    texttocopy  #/app/controllers/application_controller.rb


  #формирование имени файла "Обзор за ..."
  target_date = Date.new(DateTime.parse(@div_date).year, DateTime.parse(@div_date).mon, DateTime.parse(@div_date).day)
  name_lk = dir_save_file(target_date) + name_save_file(target_date, '/lk_btc-', '.xml')  #def dir_save_file и def name_save_file locate in 
#byebug
	unless File.exist?(name_lk)
		  unless Overlook.exists?(lk_date: target_date)
      overlook = Overlook.new(lk_date: target_date, lk_btcfile: name_lk)
    else
      overlook = Overlook.find_by lk_date: target_date
      overlook.lk_btcfile  = name_lk
    end #unless Overlook.exists?(lk_date: target_date)
    overlook.save
		f = File.new(name_lk, 'w')
		@doc_f = Nokogiri::HTML::Document.parse <<-EOHTML
        <root>
          <day>Обзор за </day>
        </root>
    EOHTML
    day = @doc_f.at_css "day"
    day.content = "Обзор за " + target_date.strftime("%Y%m%d")
    #nodes = @doc_f.css "h1"
    #nodes.wrap("<div class='container'></div>")
    f << @doc_f
    f.close
	end # unless File.exist?(name_lk)
#byebug
   @doc_f = File.open(name_lk) { |f| Nokogiri::XML(f) }
   #f = File.open(name_lk, 'a+')
   f = File.new(name_lk, 'w')
    nodes = @doc_f.css "day, ahead, atime, p"
    ahead = Nokogiri::XML::Node.new "ahead", @doc_f
    ahead.content = @div_article_header
    nodes.last.add_next_sibling(ahead)

    nodes = @doc_f.css "day, ahead, atime, p"
    atime = Nokogiri::XML::Node.new "atime", @doc_f
    atime.content = @div_date
    nodes.last.add_next_sibling(atime)

    #nodes = @doc_f.css "day, ahead, atime, p"    
    nodes = @doc_f.css "day, article"
    article = Nokogiri::XML::Node.new "article", @doc_f
    article.content = ""
    nodes.last.add_next_sibling(article)
# h1.parent = div  # div становится "родителем" h1
    ahead.parent = article
    atime.parent = article

    f << @doc_f
#debug
		f.close


end #def btcnew #переход из ленты новостей после нажатия "Обработать"

  def append
    @overlook = Overlook.find(params[:id])
    Obrab.new(@overlook.lk_file)
#byebug
    #redirect_to new_overlook_path	#overlooks#new
    #render "band/index"
    redirect_to bands_path	#bands#index
  end

  def btcedit	# при нажатии "Copy" 'Bitcoin'    
    texttocopy  #/app/controllers/application_controller.rb
    add_p('/lk_btc-')
	  render "btcnew"
  end #def btcedit	# при нажатии "Copy"

  def fact #копирование фактов из ленты новостей в БД 'Fact'
  #вызывается при нажатии "Цифры_и_факты" в /app/views/overlooks/new.html.erb
    texttocopy  #/app/controllers/application_controller.rb
    factsave    #сохранение абзаца в БД 'Fact'
  	render "new"
  end #def fact #копирование фактов из ленты новостей в БД 'Fact'

  def btcfact #копирование фактов из ленты новостей 'Bitcoin' в БД 'Fact'
  #вызывается при нажатии "Цифры_и_факты" в /app/views/overlooks/btcnew.html.erb
    texttocopy  #/app/controllers/application_controller.rb
    factsave    #сохранение абзаца в БД 'Fact'
  	render "btcnew"
  end #def fact #копирование фактов из ленты новостей в БД 'Fact'

  def add_p(dir_lk) #добавить вбзац
  #номер нужного абзаца выбирается как :id из полученного запроса	
    target_date = Date.new(DateTime.parse(@div_date).year, DateTime.parse(@div_date).mon, DateTime.parse(@div_date).day)
    name_lk = dir_save_file(target_date) + name_save_file(target_date, dir_lk, '.xml')  #def dir_save_file и def name_save_file locate in 
	  if File.exist?(name_lk)
     @doc_f = File.open(name_lk) { |f| Nokogiri::XML(f) }
     nodes = @doc_f.css "ahead, atime, p"
     f = File.new(name_lk, 'w')
      p = Nokogiri::XML::Node.new "p", @doc_f
      p.content = @mas_p[params[:id].to_i]
      nodes.last.add_next_sibling(p)
      f << @doc_f   
		  f.close
	  end # if File.exist?(name_lk)
  end #add_p
#X
#X
############################
end	#class
