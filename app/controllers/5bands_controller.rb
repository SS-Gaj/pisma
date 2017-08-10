class BandsController < ApplicationController

  def index
		@bands = Band.paginate(page: params[:page])
  end

  def create
#REUTERS_HOME = 'http://www.reuters.com/'
#1 обрабатываем 1-ю страницу
    pastday = Date.today
    agent = Mechanize.new
    page = agent.get("http://www.reuters.com/news/archive/marketsNews")
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
end

  def destroy
  end

  private

def my_file (mas)
#  p mas
  
  if mas =~ /usa-stocks/
    name_file = true
  elsif mas =~ /global-markets/
    name_file = true
  elsif mas =~ /japan-stocks/
    name_file = true
  elsif mas =~ /hongkong/
    name_file = true
  elsif mas =~ /china/
    name_file = true
  elsif mas =~ /europe-stocks/
    name_file = true
  elsif mas =~ /germany/
    name_file = true
  else
    name_file = false
  end
   return name_file
end

end
