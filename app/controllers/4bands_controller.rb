class BandsController < ApplicationController

  def index
		@bands = Band.paginate(page: params[:page])
  end

  def create
#REUTERS_HOME = 'http://www.reuters.com/'
    agent = Mechanize.new
    page = agent.get("http://www.reuters.com/news/archive/marketsNews")
target_date = Date.today
pastday = Date.today
#mas_glob = []   # общий массив, где накапливаются все выборки
#i = 0        
# puts "Перед циклом: pastday = #{pastday},  target_date = #{target_date}"

until pastday < target_date
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
  end
str_pastday = "2017-07-14 19:57:39"
pastday = Date.new(DateTime.parse(str_pastday).year, DateTime.parse(str_pastday).mon, DateTime.parse(str_pastday).day)

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
