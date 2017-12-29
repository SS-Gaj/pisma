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
#   div_all_page = doc.css("div[class=inner-container]")
    div_all_page = doc.css("div[class=renderable]")
    @div_article_header = div_all_page.css("div[class=ArticleHeader_content-container_3Ma9y] h1").text
    @div_date = div_all_page.css("div[class=ArticleHeader_content-container_3Ma9y]").css("div[class=ArticleHeader_date_V9eGk]").text
#   article = div_all_page.css("div[class=ArticleBody_body_2ECha] p")
    article = div_all_page.css("div[class=StandardArticleBody_body_1gnLA] p")
    mas_glob = []
    article.each do |elem|
      mas_glob.push(elem.text.gsub("\n", " "))
    end
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
      #col_old = 1948
    #col_new = 1980
    #col_new = Band.count
    col_new = db.first.id
    while db.exists?(col_new)
      col_new += 1
    end
    col_new = col_new - 1
    col_old = col_new - 50
    #col_old = 1
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
    if id_name = url_article =~ /id/
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
  
end
