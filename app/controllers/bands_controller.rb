class BandsController < ApplicationController

  def index
		@bands = Band.paginate(page: params[:page])
  end

  def new #"Обновить" здесь читается сайт reuters по заданным разделам - rtrs_url, и извлекаются анонсы, у которых url содержит шаблон из my_file.
    #Эти анонсы добавляются в БД Band и образуют ленту новостей, которая выводится по пункту меню "Новости" 
    #REUTERS_HOME = 'http://www.reuters.com/'
@bands_last = Band.first
    rtrs_url = [
"http://www.reuters.com/news/archive/marketsNews", 
"http://www.reuters.com/news/archive/hotStocksNews", 
"http://www.reuters.com/news/archive/businessNews", 
"http://www.reuters.com/news/archive/ousivMolt", 
"http://www.reuters.com/news/archive/hongkongMktRpt", 
"http://www.reuters.com/news/archive/londonMktRpt", 
'https://www.reuters.com/news/archive/RCOMUS_Fintech'
]

    rtrs_url.each do |my_url|
      #1 обрабатываем 1-ю страницу
      pastday = DateTime.parse('2017-08-18T04:05:06+03:00')   #просто init
      agent = Mechanize.new
      page = agent.get(my_url)
      pastday = rss_new(page)
      ##1

      #2 цикл для обработки последующих страниц
      target_date = DateTime.now - 1  # сутки назад
      link_next = page.links.find { |l| l.text =~ /Earlier/ }
      until pastday < target_date # если неправда, что время статьи меньше заданного (т.е.если неправда, что статья напечатана раньше, чем заданное время)
        page = link_next.click
        pastday = rss_new(page)
        link_next = page.links.find { |l| l.text =~ /Earlier/ }
        break if link_next == nil
      end # until pastday < target_date
      ##2
    end #rtrs_url.each do |my_url|
    redirect_to bands_path	#bands#index
  end # def new

  def edit	#"Обработать"
	  @band = Band.find(params[:id])
    Obrab.new(editor(@band.bn_url))
   #byebug
    redirect_to new_overlook_path	#overlooks#new
  end	#def edit	#"Обработать"

  def editfact	#"Цифры_и_факты" из "Просмотреть" 
	  @band = Band.find(params[:id])
    # Obrab.new(toobrab(@band.bn_url, 'fact', @mas_p))
    Obrab.new(editor(@band.bn_url))
   #byebug
    redirect_to newband_new_fact_path	#facts#newband 
  end	#def edit	#"Обработать"

  def show	#"Просмотреть"
	  @band = Band.find(params[:id])
	  @mas_p = reader(@band.bn_url)
  end

  def destroy #"Удалить" 
  	  @band = Band.find(params[:id])
  	  @band.destroy
  	  redirect_to bands_path	#bands#index
  end # def destroy

  def corect #"Корр.время" 
  	  @band = Band.find(params[:id])
   	  @band.bn_date = @band.bn_date - 86400
  	  @band.save
  	  redirect_to bands_path	#bands#index
  end # def destroy

  def savefile	#“Save-file-txt”
 	  @band = Band.find(params[:id])
    wrieter(@band.bn_url)      
    redirect_to bands_path	#bands#index
  end	#def savefile	#“Save-file-txt”

  def double #удаление задвоенных статей - кнопка "Раздуплить"
    doubler(Band)
    #doubler(Bitcoin, btc_head, btc_date)
    #doubler(Band, bn_head, bn_date)
    redirect_to bands_path	#bands#index
  end #def double

  private

	  def my_file (mas)
      need_file = false
      @btc_file = false      
	    if mas =~ /usa-stocks/
	      need_file = true
	    elsif mas =~ /global-markets/
	      need_file = true
	    elsif mas =~ /japan-stocks/
	      need_file = true
	    elsif mas =~ /stocks-hongkong/
	      need_file = true
	    elsif mas =~ /china-stocks-close/
	      need_file = true
	    elsif mas =~ /china-stocks-midday/
	      need_file = true
	    elsif mas =~ /europe-stocks/
	      need_file = true
	    elsif mas =~ /bitcoin/
	      need_file = true
	      @btc_file = true
	    elsif mas =~ /virtual-currenc/
	      need_file = true
	      @btc_file = true
	    elsif mas =~ /blockchain/
	      need_file = true
	      @btc_file = true
	    elsif mas =~ /opec|oil/
	      need_file = true
	    else
	    end
	    return need_file
	  end # def my_file (mas)

    def rss_new(page)
      doc = Nokogiri::HTML(page.body)
      div_block_article = doc.css("div[class=story-content]")
      div_block_article.each do |link|
        href_view = link.css("a").first['href']
        name_view = link.css("h3").first.text.strip
        @time_view = link.css("time[class=article-time]").css("span[class=timestamp]").first.text
        content_view = link.css("p").first.text.strip
        if my_file(href_view)
          if @btc_file == true
            bitcoin = Bitcoin.new(btc_head: name_view, btc_novelty: content_view, 
            btc_date: @time_view, btc_url: href_view)
            bitcoin.save
          else
            band = Band.new(bn_head: name_view, novelty: content_view, 
            bn_date: @time_view, bn_url: href_view)
            band.save
          end
        end #if my_file(href_view)
      end #div_block_article.each do |link|
      return DateTime.parse(@time_view)   
    end #rss_new
end
