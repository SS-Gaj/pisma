class BandsController < ApplicationController

  def index
		@bands = Band.paginate(page: params[:page])
  end

  def new #"Обновить" здесь читается сайт reuters по заданным разделам - rtrs_url, и извлекаются анонсы, у которых url содержит шаблон из my_file.
    #Эти анонсы добавляются в БД Band и образуют ленту новостей, которая выводится по пункту меню "Новости" 
    #REUTERS_HOME = 'http://www.reuters.com/'
@bands_last = Band.first
    rtrs_url = ["http://www.reuters.com/news/archive/marketsNews", "http://www.reuters.com/news/archive/hotStocksNews", "http://www.reuters.com/news/archive/businessNews", "http://www.reuters.com/news/archive/ousivMolt", "http://www.reuters.com/news/archive/hongkongMktRpt", "http://www.reuters.com/news/archive/londonMktRpt"]
    rtrs_url.each do |my_url|
      #1 обрабатываем 1-ю страницу
      #pastday = Date.today
pastday = DateTime.parse('2017-08-18T04:05:06+03:00')   #просто init
      agent = Mechanize.new
      #page = agent.get("http://www.reuters.com/news/archive/marketsNews")
      page = agent.get(my_url)
      doc = Nokogiri::HTML(page.body)
      div_block_article = doc.css("div[class=story-content]")
      div_block_article.each do |link|
        href_view = link.css("a").first['href']
        name_view = link.css("h3").first.text.strip
        time_view = link.css("time[class=article-time]").css("span[class=timestamp]").first.text
        content_view = link.css("p").first.text.strip
        if my_file(href_view)
          band = Band.new(bn_head: name_view, novelty: content_view, 
          bn_date: time_view, bn_url: href_view)
          band.save
        end #if my_file(href_view)
      pastday = DateTime.parse(time_view)
      end #div_block_article.each do |link|
      ##1

      #2 цикл для обработки последующих страниц
      target_date = DateTime.now - 1  # сутки назад

#target_date = DateTime.parse('2017-01-01T00:00:00+03:00')   #просто init
      #target_date = @bands_last.bn_date
      link_next = page.links.find { |l| l.text =~ /Earlier/ }
      until pastday < target_date
        page = link_next.click
        doc = Nokogiri::HTML(page.body)
        div_block_article = doc.css("div[class=story-content]")
        div_block_article.each do |link|
          href_view = link.css("a").first['href']
          name_view = link.css("h3").first.text.strip
          time_view = link.css("time[class=article-time]").css("span[class=timestamp]").first.text
          content_view = link.css("p").first.text.strip
          if my_file(href_view)
            band = Band.new(bn_head: name_view, novelty: content_view, 
            bn_date: time_view, bn_url: href_view)
            band.save
          end
          pastday = DateTime.parse(time_view)
        end
        link_next = page.links.find { |l| l.text =~ /Earlier/ }
        break if link_next == nil
      end # until pastday < target_date
      ##2
    end #rtrs_url.each do |my_url|
    redirect_to bands_path	#bands#index
  end # def new

  def edit	#"Обработать"
target_date = DateTime.parse('2017-09-23T04:05:06+03:00')   #просто init
	  @band = Band.find(params[:id])
	  # start scrabing
    agent = Mechanize.new
    page = agent.get("http://www.reuters.com"+@band.bn_url)
    doc = Nokogiri::HTML(page.body)
    div_all_page = doc.css("div[class=inner-container]")
    @div_article_header = div_all_page.css("div[class=ArticleHeader_content-container_3Ma9y] h1").text
    @div_date = div_all_page.css("div[class=ArticleHeader_content-container_3Ma9y]").css("div[class=ArticleHeader_date_V9eGk]").text
    target_date = Date.new(DateTime.parse(@div_date).year, DateTime.parse(@div_date).mon, DateTime.parse(@div_date).day)
    name_file = dir_save_file(target_date)
    Dir.mkdir('obrab') unless File.directory?('obrab')
	  Dir.chdir('obrab')
    name_file = name_file + '/obrab'
    if id_name = @band.bn_url =~ /id/
      name_file = name_file + '/' + @band.bn_url[id_name, @band.bn_url.length-id_name]
    else
      name_file = name_file + '/id_no'    
    end 
    name_file = name_file + '.html'
  unless File.exist?(name_file)
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
    article = div_all_page.css("div[class=ArticleBody_body_2ECha] p")
    article.each do |elem|
	    f << "<p>" + elem.text.gsub("\n", " ") + "</p>"
    end # article.each do |elem|
    f << "</body>"
    f << "</html>"
	  # start save file
		f.close
  end # unless File.exist?(name_file)
	  # end save file
    #obrab_now = Obrab.new(name_file)
    Obrab.new(name_file)
#byebug
  redirect_to new_overlook_path	#overlooks#new
  # redirect_to bands_path	#bands#index
  end	#def edit	#"Обработать"

  def show	#"Просмотреть"
	  @band = Band.find(params[:id])
    agent = Mechanize.new
    page = agent.get("http://www.reuters.com"+@band.bn_url)
    doc = Nokogiri::HTML(page.body)
    div_all_page = doc.css("div[class=inner-container]")
    @div_article_header = div_all_page.css("div[class=ArticleHeader_content-container_3Ma9y] h1").text
    @div_date = div_all_page.css("div[class=ArticleHeader_content-container_3Ma9y]").css("div[class=ArticleHeader_date_V9eGk]").text
    article = div_all_page.css("div[class=ArticleBody_body_2ECha] p")
    mas_glob = []
    article.each do |elem|
      mas_glob.push(elem.text.gsub("\n", " "))
    end
    @mas_p = mas_glob
  end

  def destroy #"Раздуплить"
  	  @band = Band.find(params[:id])
  	  @band.destroy
  	  redirect_to bands_path	#bands#index
  end # def destroy

  def savefile	#“Save-file-txt”
target_date = DateTime.parse('2017-09-23T04:05:06+03:00')   #просто init
	  @band = Band.find(params[:id])
	  # start scrabing
    agent = Mechanize.new
    page = agent.get("http://www.reuters.com"+@band.bn_url)
    doc = Nokogiri::HTML(page.body)
    div_all_page = doc.css("div[class=inner-container]")
    @div_article_header = div_all_page.css("div[class=ArticleHeader_content-container_3Ma9y] h1").text
    @div_date = div_all_page.css("div[class=ArticleHeader_content-container_3Ma9y]").css("div[class=ArticleHeader_date_V9eGk]").text
    target_date = Date.new(DateTime.parse(@div_date).year, DateTime.parse(@div_date).mon, DateTime.parse(@div_date).day)
    name_file = dir_save_file(target_date) + name_save_file(@band.bn_url, @div_date)  #def name_save_file locate down; def dir_save_file in application_controller.rb
  unless File.exist?(name_file)
		f = File.new(name_file, 'w')
	  f << @div_article_header + "\n"
	  f << @div_date + "\n"
#debug
    article = div_all_page.css("div[class=ArticleBody_body_2ECha] p")
    article.each do |elem|
	    f << elem.text.gsub("\n", " ") + "\n"
    end # article.each do |elem|
	  # start save file
		f.close

	end # unless File.exist?(name_file)
	  # end save file
	#render layout: false
  redirect_to bands_path	#bands#index
	#redirect_back(fallback_location: root_path)
  #render body: "raw"
  end	#def savefile	#“Save-file-txt”

  def double #удаление задвоенных статей - кнопка "Раздуплить"
    #col_old = 1948
    #col_new = 1980
    #col_new = Band.count
    col_new = Band.first.id
    col_old = col_new - 50

    while col_new > col_old - 1
  #byebug
      record_id = col_new
      if Band.exists?(record_id)
        isx_record = Band.find(record_id)
        isx_head = isx_record.bn_head
        isx_date = isx_record.bn_date
        while record_id > col_old - 1 do
          yes_no = false
          record_id -= 1
          if Band.exists?(record_id)
            tek_record = Band.find(record_id)
            tek_head = tek_record.bn_head
            tek_date = tek_record.bn_date
            if tek_head.include? isx_head
              yes_no = true
            elsif isx_head.include? tek_head
              yes_no = true
            end #if tek_head.include? isx_head
            if yes_no = true
              if isx_date > tek_date
                tek_record.destroy
              else
                new_isx_record = tek_record
                isx_record.destroy
                isx_record = new_isx_record
                isx_head = new_isx_record.bn_head
                isx_date = new_isx_record.bn_date
              end #if isx_date < tek_date
            end #if yes_no = true
          end #if Band.exists?(record_id)
        end #while record_id > col_old
      end #if Band.exists?(record_id)
      col_new -= 1
    end #while col_new > col_old
  ####
    redirect_to bands_path	#bands#index
  end #def double

  private

	  def my_file (mas)
	    if mas =~ /usa-stocks/
	      name_file = true
	    elsif mas =~ /global-markets/
	      name_file = true
	    elsif mas =~ /japan-stocks/
	      name_file = true
	    elsif mas =~ /stocks-hongkong/
	      name_file = true
	    elsif mas =~ /china-stocks-close/
	      name_file = true
	    elsif mas =~ /china-stocks-midday/
	      name_file = true
	    elsif mas =~ /europe-stocks/
	      name_file = true
	    elsif mas =~ /opec|oil/
	      name_file = true
	    else
	      name_file = false
	    end
	     return name_file
	  end # def my_file (mas)

    def name_save_file (url, url_date) # used hier
      if url =~ /usa-stocks/
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
    end	#name_save_file

end
