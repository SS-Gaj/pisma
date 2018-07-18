class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include OverlooksHelper
  @reuters_dir = '/home/ss/reuters'
  
  def dir_save_file (date_prezent)  # used in overlooks_controller.rb
  # puts "REUTERS_DIR = #{REUTERS_DIR}"
	  dir_year = date_prezent.year.to_s
	  dir_mon = date_prezent.mon.to_s
	  dir_day = date_prezent.day.to_s
	  #Dir.chdir(REUTERS_DIR)
	  #REUTERS_DIR = '/home/ss/Documents/Reuters/index'
	  #Dir.chdir('/home/ss/Documents/Reuters')
    Dir.chdir('/home/ss/reuters')
	  Dir.mkdir(dir_year) unless File.directory?(dir_year)
	  Dir.chdir(dir_year)
	  Dir.mkdir(dir_mon) unless File.directory?(dir_mon)
	  Dir.chdir(dir_mon)
	  Dir.mkdir(dir_day) unless File.directory?(dir_day)
	  Dir.chdir(dir_day)
	  return Dir.pwd
  end	#my_dir

  def name_save_file (date_prezent, prefix, type) # used in overlooks_controller.rb and reviews_controller.rb
    return  prefix + date_prezent.strftime("%y%m%d") + type #'/lk-' '.xml'
  end	#my_file
  
  def reader(url_article) #для "Просмотреть"
    agent = Mechanize.new
    page = agent.get("http://www.reuters.com" + url_article)    #@band.bn_url
    doc = Nokogiri::HTML(page.body)
    ##div_all_page = doc.css("div[class=renderable]")
    #div_all_page = doc.css("div[class=inner-container_1LBl0]")
    div_all_page = doc.css("div[class=StandardArticle_inner-container]")
    
    ##@div_article_header = div_all_page.css("div[class=ArticleHeader_content-container_3Ma9y] h1").text
    #@div_article_header = div_all_page.css("div[class=content-container_3Ma9y] h1").text
    @div_article_header = div_all_page.css("div[class=ArticleHeader_content-container] h1").text
    
    ##@div_date = div_all_page.css("div[class=ArticleHeader_content-container_3Ma9y]").css("div[class=ArticleHeader_date_V9eGk]").text
    #@div_date = div_all_page.css("div[class=content-container_3Ma9y]").css("div[class=date_V9eGk]").text
    @div_date = div_all_page.css("div[class=ArticleHeader_content-container]").css("div[class=ArticleHeader_date]").text
    unless url_article =~ /live-markets/
      ##article = div_all_page.css("div[class=StandardArticleBody_body_1gnLA] p")
      #article = div_all_page.css("div[class=body_1gnLA] p")
      article = div_all_page.css("div[class=StandardArticleBody_body] p")
      
      # @div_first = div_all_page.css("div[class=body_1gnLA]").css("p[class=first-p_2htdt]").text # class=first-p убрали на Рейтерсе
    #byebug
    else
      article = div_all_page.css("div [class=StandardArticleBody_body_1gnLA] pre")
    end    
    mas_glob = []
    article.each do |elem|
     mas_glob.push(elem.text.gsub("\n", " "))
    end
    #byebug
    mas_glob.each do |first|
      if first =~ /\(Reuters\)/
        @div_first = first
        break
      end # if first =~ /\(Reuters\)/
    end   # mas_glob.each do |first|
    mas_glob.each do |first|
      if first =~ /percent(,*)\s(\w*\s)*(\d)+,\d\d\d.\d/
        @div_percent = first
        break
      end # if first =~ /\(Reuters\)/
    end   # mas_glob.each do |first|
    mas_glob.each do |first|
      if first =~ /STOXX/ and first =~ /percent/
        @div_percent = first
        break
      end # if first =~ /\(Reuters\)/
    end   # mas_glob.each do |first|
    if @div_first == nil
      @div_first = " "
    else
    ### для "китайцев" НАЧАЛО
    if @div_first.include? "**"
      mas = @div_first.split('**')
      mas.each do |first|
       if first =~ /\(Reuters\)/
        @div_first = first
        break
       end
      end   #mas.each do |first|
    end # if @div_first.include? "**"
    @div_first = @div_first + " /" + @div_date +"/"
    end # if @div_first.include? "**"
    #@div_percent = " " if @div_percent == nil    
    if @div_percent == nil
      @div_percent = " "
    else
      if @div_percent.include? "**"
        mas = @div_percent.split('**')
        mas.each do |first|
         if first =~ /percent(,*)\s(\w*\s)*(\d)+,\d\d\d.\d/
          @div_percent = first
          break
         end
        end   #mas.each do |first|
      end # if @div_first.include? "**"
    end   # if @div_percent == nil
### для "китайцев" КОНЕЦ
    #byebug
    return mas_glob 
  end #def reader(url_article) #для "Прочитать"
  
  def wrieter(url_article)  #“Save-file-txt”
    target_date = DateTime.parse('2017-09-23T04:05:06+03:00')   #просто init
    article = reader(url_article)
    target_date = Date.new(DateTime.parse(@div_date).year, DateTime.parse(@div_date).mon, DateTime.parse(@div_date).day)
    name_file = dir_save_file(target_date) + '/bn-' + name_need_file(url_article) + rtdatefile(@div_date)  #def name_save_file locate down; def dir_save_file in application_controller.rb
    #name_file = '/bn-' + name_file + DateTime.parse(url_date).strftime("%y%m%d") + '-' + DateTime.parse(url_date).strftime("%H%M") + '.txt'

  unless File.exist?(name_file)
		f = File.new(name_file, 'w')
	  f << @div_article_header + "\n"
	  f << @div_date + "\n"

    article.each do |elem|
	    f << elem + "\n"
      end # article.each do |elem|
		f.close
	  end # unless File.exist?(name_file)
  end #  def wrieter(url_article)  #“Save-file-txt”
  
  def editor(url_article) #"Обработать"
    article = reader(url_article)  
    name_file = toobrab(url_article, 'obrab', article)
    return name_file
  end #editor #"Обработать"
  
  def editorbtc(url_article) #"Обработать биткоин"
    article = reader(url_article)  
    name_file = toobrab(url_article, 'bitcoin', article)
    return name_file

  end # def editorbtc(url_article) #"Обработатьбиткоин"
  
  def doubler(db)   #, db_head, db_date)
    col_new = db.first.id
    day_today = db.first.bn_date
    begin
      col_new -= 1
      while not db.exists?(col_new)
        col_new -= 1
      end    
    end until db.find(col_new).bn_date < day_today - 2*86400
    col_old = col_new - 50
    while col_new > col_old - 1
      record_id = col_new
      if db.exists?(record_id)
        isx_record = db.find(record_id)
        isx_head = isx_record.bn_head
        isx_date = isx_record.bn_date
        while record_id > col_old - 1 do
          yes_no = false
          record_id -= 1
          if db.exists?(record_id)
            tek_record = db.find(record_id)
            tek_head = tek_record.bn_head
            tek_date = tek_record.bn_date
            if tek_head.include? isx_head
              yes_no = true
            elsif isx_head.include? tek_head
              yes_no = true
            end #if tek_head.include? isx_head
            if yes_no == true
byebug
              if isx_date > tek_date
                tek_record.destroy
              else
                new_isx_record = tek_record
                isx_record.destroy
                isx_record = new_isx_record
                isx_head = new_isx_record.bn_head
                isx_date = new_isx_record.bn_date
              end #if isx_date < tek_date
            end #if yes_no == true
          end #if db.exists?(record_id)
        end #while record_id > col_old
      end #if db.exists?(record_id)
      col_new -= 1
    end #while col_new > col_old
  ####

  end #doubler
  
      def name_need_file (url) # used hier
      if url =~ /bitcoin/
        name_file = 'bitcoin-'
      elsif url =~ /usa-stocks/
        name_file = 'usa-'
      elsif url =~ /global-markets/
        name_file = 'global-'
      elsif url =~ /japan-stocks/
        name_file = 'japan-'
      elsif url =~ /hongkong/
        name_file = 'hongkong-'
      elsif url =~ /china/
        name_file = 'china-'
      elsif url =~ /europe-stocks/
        name_file = 'europe-'
      elsif url =~ /european-shares/
        name_file = 'europe-'
      elsif url =~ /oil-/
        name_file = 'oil-'
      else
        name_file = 'othe-'
      end
      if url =~ /midday/
        name_file = name_file + 'midday-'
      elsif url =~ /close/
        name_file = name_file + 'close-'
      else
      end
      return name_file
    end	#name_need_file

    def rtdatefile(url_date)
      return DateTime.parse(url_date).strftime("%y%m%d") + '-' + DateTime.parse(url_date).strftime("%H%M") + '.txt'           
    end

  def toobrab(url_article, sfera, article)
      target_date = DateTime.parse('2017-09-23T04:05:06+03:00')   #просто init
    target_date = Date.new(DateTime.parse(@div_date).year, DateTime.parse(@div_date).mon, DateTime.parse(@div_date).day)
    name_file = dir_save_file(target_date)
    Dir.mkdir(sfera) unless File.directory?(sfera)
	  Dir.chdir(sfera)
    name_file = name_file + '/' + sfera + '/' + name_need_file(url_article)
    if id_name = url_article =~ /id[A-Z\d]+\Z/ #/id/
      name_file = name_file + url_article[id_name, url_article.length-id_name]
    else
      name_file = name_file + 'id_no'    
    end 
    name_file = name_file + '.html'
  #unless File.exist?(name_file)
  	f = File.new(name_file, 'w') 
    f << "<!DOCTYPE html>"
    f << "<html>"
    f << "<head>"
    f << "<title>Reuters | Обработать</title>"
    f << "</head>"
    f << "<body>"
    f << "<h3>" + @div_article_header + "</h3>"
    f << "<h3>" + @div_date + "</h3>"
    f << "<h4>" + url_article + "</h4>"
    #byebug
    f << "<h5>" + @div_first + "</h5>"
    f << "<h5>" + @div_percent + "</h5>"
    article.each do |elem|
      mas = []
      mas = elem.split('**')
      mas.each do |para|
	      f << "<p>" + para + "</p>"
	    end #mas.each do |para|
    end # article.each do |elem|
    f << "</body>"
    f << "</html>"
	  # start save file
		f.close
    return name_file
  end #def toobrab (url_article, sfera, article)
  
  def texttocopy()
  # "Обработываемый" файл открываеся по-новой и считывается в Nokogiri
  #byebug
    if @_action_name =~ /btc/
      @file_obrab = Obrabbtc.file_obrabbtc  # Obrab создано в bands_controller.rb
    else
      @file_obrab = Obrab.file_obrab  # Obrab создано в bands_controller.rb
    end
    doc_obrab = File.open(@file_obrab) { |f| Nokogiri::XML(f) }
    div_all_page = doc_obrab.css("html")
    article = div_all_page.css("h3")
    @div_article_header = article.first.text
    @div_date = article.last.text
    @div_isxurl = div_all_page.css("h4").text
#    @div_first = div_all_page.css("h5").text
    div_h5 = div_all_page.css("h5")
    @div_first = div_h5.first.text
    @div_percent = div_h5.last.text
    #@div_first = " "    #это временная мера, см.п.18.1 hm-news_day-180331(console-21)
    article = div_all_page.css("p")
    @mas_p = []
    article.each do |elem|
      @mas_p.push(elem.text.gsub("\n", " "))
    end
  end # def texttocopy()
  
  def factsave()
    my_date = DateTime.new
    my_date = DateTime.parse(@div_date)
    target_date = Date.new(DateTime.parse(@div_date).year, DateTime.parse(@div_date).mon, DateTime.parse(@div_date).day)
    my_fact = @mas_p[params[:id].to_i].to_s
    if @file_obrab =~ /bitcoin/
      my_range = "bitcoin"
    elsif @file_obrab =~ /oil/
      my_range = "oil"
    else
      if my_fact =~ /B|bitcoin/
        my_range = "bitcoin"
      elsif my_fact =~ /O|oil/
        my_range = "oil"
      end
      my_range = "burse"
    end
    fact = Fact.new(fc_date: my_date, 
                    fc_range: my_range, 
                    fc_fact: @mas_p[params[:id].to_i], 
                    fc_myurl: @file_obrab, 
                    fc_isxurl: "http://www.reuters.com" + @div_isxurl             
                    )
    fact.save
  end #def factsave

end
