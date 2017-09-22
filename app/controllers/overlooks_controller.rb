class OverlooksController < ApplicationController

def new
	target_date = Date.today
	name_file = dir_save_file(target_date) + name_save_file(target_date)  #def dir_save_file и def name_save_file locate in application_controller.rb
	unless File.exist?(name_file)
		f = File.new(name_file, 'w')
	  f << "Обзор за " + target_date.strftime("%y%m%d") + "\n"
	  #f << @div_article_header + "\n"
#debug
		# f << @mas_p[10] + "\n"
    f << @@para1 + "\n"
		f.close

	end # unless File.exist?(name_file)
	#render body: "raw"
	#render layout: false
    redirect_to bands_path	#bands#index
	#redirect_back(fallback_location: root_path)
end #new

#private

end	#class
