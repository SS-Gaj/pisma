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
	  # start scrabing
    agent = Mechanize.new
    page = agent.get("http://www.reuters.com"+url_article)
    doc = Nokogiri::HTML(page.body)
#    div_all_page = doc.css("div[class=inner-container]")
    div_all_page = doc.css("div[class=renderable]")
    @div_article_header = div_all_page.css("div[class=ArticleHeader_content-container_3Ma9y] h1").text
    @div_date = div_all_page.css("div[class=ArticleHeader_content-container_3Ma9y]").css("div[class=ArticleHeader_date_V9eGk]").text
    target_date = Date.new(DateTime.parse(@div_date).year, DateTime.parse(@div_date).mon, DateTime.parse(@div_date).day)
    name_file = dir_save_file(target_date) + name_need_file(url_article, @div_date)  #def name_save_file locate down; def dir_save_file in application_controller.rb
  unless File.exist?(name_file)
		f = File.new(name_file, 'w')
	  f << @div_article_header + "\n"
	  f << @div_date + "\n"
   #debug
#   article = div_all_page.css("div[class=ArticleBody_body_2ECha] p")
    article = div_all_page.css("div[class=StandardArticleBody_body_1gnLA] p")

    article.each do |elem|
	    f << elem.text.gsub("\n", " ") + "\n"
      end # article.each do |elem|
		f.close
	  end # unless File.exist?(name_file)
	  # end save file
  end #  def wrieter(url_article)  #“Save-file-txt”
  
  def editor(url_article) #"Обработать"
      target_date = DateTime.parse('2017-09-23T04:05:06+03:00')   #просто init
	  # start scrabing
    agent = Mechanize.new
    page = agent.get("http://www.reuters.com"+url_article)
    doc = Nokogiri::HTML(page.body)
#    div_all_page = doc.css("div[class=inner-container]")
    div_all_page = doc.css("div[class=renderable]")
    @div_article_header = div_all_page.css("div[class=ArticleHeader_content-container_3Ma9y] h1").text
    @div_date = div_all_page.css("div[class=ArticleHeader_content-container_3Ma9y]").css("div[class=ArticleHeader_date_V9eGk]").text
    target_date = Date.new(DateTime.parse(@div_date).year, DateTime.parse(@div_date).mon, DateTime.parse(@div_date).day)
    name_file = dir_save_file(target_date)
    Dir.mkdir('obrab') unless File.directory?('obrab')
	  Dir.chdir('obrab')
    name_file = name_file + '/obrab'
    if id_name = url_article =~ /id/
      name_file = name_file + '/' + url_article[id_name, url_article.length-id_name]
    else
      name_file = name_file + '/id_no'    
    end 
    name_file = name_file + '.html'
  #unless File.exist?(name_file)
		f = File.new(name_file, 'w')
    f << "<!DOCTYPE html>"
    f << "<html>"
    f << "<head>"
    f << "<title>Reuters | Обработать</title>"
    #f << '<%= stylesheet_link_tag    "application", media: "all", "data-turbolinks-track" => true %>'
    #f << '<%= javascript_include_tag "application", "data-turbolinks-track" => true %>'
    #f << "<%= csrf_meta_tags %>"
    f << "</head>"
    f << "<body>"
    f << "<h3>" + @div_article_header + "</h3>"
    f << "<h3>" + @div_date + "</h3>"
#   article = div_all_page.css("div[class=ArticleBody_body_2ECha] p")
    article = div_all_page.css("div[class=StandardArticleBody_body_1gnLA] p")
    article.each do |elem|
      elem_text = elem.text.gsub("\n", " ")
      mas = []
      mas = elem_text.split('**')
      mas.each do |para|
	      f << "<p>" + para + "</p>"
	    end #mas.each do |para|
    end # article.each do |elem|
    f << "</body>"
    f << "</html>"
	  # start save file
		f.close
    return name_file
  end #editor #"Обработать"
  
  def editorbtc(url_article) #"Обработать биткоин"
    target_date = DateTime.parse('2017-09-23T04:05:06+03:00')   #просто init
	  # start scrabing
    agent = Mechanize.new
    page = agent.get("http://www.reuters.com"+url_article)
    doc = Nokogiri::HTML(page.body)
#    div_all_page = doc.css("div[class=inner-container]")
    div_all_page = doc.css("div[class=renderable]")
    @div_article_header = div_all_page.css("div[class=ArticleHeader_content-container_3Ma9y] h1").text
    @div_date = div_all_page.css("div[class=ArticleHeader_content-container_3Ma9y]").css("div[class=ArticleHeader_date_V9eGk]").text
    target_date = Date.new(DateTime.parse(@div_date).year, DateTime.parse(@div_date).mon, DateTime.parse(@div_date).day)
    name_file = dir_save_file(target_date)
    Dir.mkdir('bitcoin') unless File.directory?('bitcoin')
	  Dir.chdir('bitcoin')
    name_file = name_file + '/bitcoin'
    if id_name = url_article =~ /id/
      name_file = name_file + '/' + url_article[id_name, url_article.length-id_name]
    else
      name_file = name_file + '/id_no'    
    end 
    name_file = name_file + '.html'
  #unless File.exist?(name_file)
		f = File.new(name_file, 'w')
    f << "<!DOCTYPE html>"
    f << "<html>"
    f << "<head>"
    f << "<title>Reuters | Обработать</title>"
    #f << '<%= stylesheet_link_tag    "application", media: "all", "data-turbolinks-track" => true %>'
    #f << '<%= javascript_include_tag "application", "data-turbolinks-track" => true %>'
    #f << "<%= csrf_meta_tags %>"
    f << "</head>"
    f << "<body>"
    f << "<h3>" + @div_article_header + "</h3>"
    f << "<h3>" + @div_date + "</h3>"
#   article = div_all_page.css("div[class=ArticleBody_body_2ECha] p")
    article = div_all_page.css("div[class=StandardArticleBody_body_1gnLA] p")
    article.each do |elem|
      elem_text = elem.text.gsub("\n", " ")
      mas = []
      mas = elem_text.split('**')
      mas.each do |para|
	      f << "<p>" + para + "</p>"
	    end #mas.each do |para|
    end # article.each do |elem|
    f << "</body>"
    f << "</html>"
	  # start save file
		f.close
    return name_file

  end # def editorbtc(url_article) #"Обработатьбиткоин"
  
  
      def name_need_file (url, url_date) # used hier
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
name_file = '/bn-' + name_file + DateTime.parse(url_date).strftime("%y%m%d") + '-' + DateTime.parse(url_date).strftime("%H%M") + '.txt'
      return name_file
    end	#name_need_file

end
