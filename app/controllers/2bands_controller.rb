class BandsController < ApplicationController

  def index
		@bands = Band.paginate(page: params[:page])
  end

  def create
	  agent = Mechanize.new
    page = agent.get("http://www.reuters.com/news/archive/marketsNews")
    doc = Nokogiri::HTML(page.body)
    div_block_article = doc.css("div[class=story-content]")
    href_view = div_block_article[0].css("a").first['href']
    name_view = div_block_article[0].css("h3").first.text.strip
    time_view = div_block_article[0].css("time[class=article-time]").css("span[class=timestamp]").text
    content_view = div_block_article[0].css("p").first.text.strip

	  band = Band.new(bn_head: name_view, novelty: content_view, 
    bn_date: time_view, bn_url: href_view)
	  band.save
  end

  def destroy
  end
end
