class BandsController < ApplicationController

  def index
		@bands = Band.paginate(page: params[:page])
  end

  def new
    #REUTERS_HOME = 'http://www.reuters.com/'
    rtrs_url = ["http://www.reuters.com/news/archive/marketsNews", "http://www.reuters.com/news/archive/hotStocksNews", "http://www.reuters.com/news/archive/businessNews", "http://www.reuters.com/news/archive/ousivMolt", "http://www.reuters.com/news/archive/hongkongMktRpt"]
    rtrs_url.each do |my_url|
      #1 обрабатываем 1-ю страницу
      pastday = Date.today
      agent = Mechanize.new
      #page = agent.get("http://www.reuters.com/news/archive/marketsNews")
      page = agent.get(my_url)
      doc = Nokogiri::HTML(page.body)
      div_block_article = doc.css("div[class=story-content]")
      div_block_article.each do |link|
        href_view = link.css("a").first['href']
        name_view = link.css("h3").first.text.strip
        time_view = link.css("time[class=article-time]").css("span[class=timestamp]").text
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
      target_date = Date.today
      link_next = page.links.find { |l| l.text =~ /Earlier/ }
      until pastday < target_date
        page = link_next.click
        doc = Nokogiri::HTML(page.body)
        div_block_article = doc.css("div[class=story-content]")
        div_block_article.each do |link|
          href_view = link.css("a").first['href']
          name_view = link.css("h3").first.text.strip
          time_view = link.css("time[class=article-time]").css("span[class=timestamp]").text
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
    redirect_to bands_path
  end # def new

  def show
	  @band = Band.find(params[:id])
    agent = Mechanize.new
    page = agent.get("http://www.reuters.com"+@band.bn_url)
    doc = Nokogiri::HTML(page.body)
    div_all_page = doc.css("div[class=inner-container]")
    @div_article_header = div_all_page.css("div[class=ArticleHeader_content-container_3Ma9y] h1").text
  end

  def destroy
  end

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
end