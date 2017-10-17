class OverlooksController < ApplicationController

def new
byebug
end

def edit	# из цепочки "Обработать"
#init_myvar(@div_article_header, @div_date, @overlook, @mas_p)
  doc_obrab = File.open(@overlook.lk_file) { |f| Nokogiri::XML(f) }
  div_all_page = doc_obrab.css("html")
  article = div_all_page.css("h3")
  @div_article_header = article.first.text
  @div_date = article.last.text
  article = div_all_page.css("p")
  mas_glob = []
  article.each do |elem|
    mas_glob.push(elem.text.gsub("\n", " "))
  end
  @mas_p = mas_glob
	#target_date = Date.today
  target_date = Date.new(@overlooks.lk_date)
	name_file = dir_save_file(target_date) + name_save_file(target_date)  #def dir_save_file и def name_save_file locate in application_controller.rb
	unless File.exist?(name_file)
		f = File.new(name_file, 'w')
	  f << "Обзор за " + target_date.strftime("%y%m%d") + "\n"

	  f << @div_article_header + "\n"
#debug
	  f << @mas_p[10] + "\n"
		f.close
	end # unless File.exist?(name_file)

	#render body: "raw"
	#render layout: false
  redirect_to bands_path	#bands#index
	#redirect_back(fallback_location: root_path)
end #edit

#private

end	#class
