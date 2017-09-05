class OverlooksController < ApplicationController

def new
	target_date = Date.today
	name_file = my_dir(target_date) + my_file(target_date)
	unless File.exist?(name_file)
		f = File.new(name_file, 'w')
	  f << "Обзор за " + target_date.strftime("%y%m%d") + "\n"
		#f << @div_article_header + "\n"
		#f << @para + "\n"
		f.close

	end # unless File.exist?(name_file)
	#render body: "raw"
	#render layout: false
    redirect_to bands_path	#bands#index
	#redirect_back(fallback_location: root_path)
end #new

private

def my_dir (date_prezent)
# puts "REUTERS_DIR = #{REUTERS_DIR}"
	dir_year = date_prezent.year.to_s
	dir_mon = date_prezent.mon.to_s
	dir_day = date_prezent.day.to_s
	#Dir.chdir(REUTERS_DIR)
	#REUTERS_DIR = '/home/ss/Documents/Reuters/index'
	Dir.chdir('/home/ss/Documents/Reuters')
	Dir.mkdir(dir_year) unless File.directory?(dir_year)
	Dir.chdir(dir_year)
	Dir.mkdir(dir_mon) unless File.directory?(dir_mon)
	Dir.chdir(dir_mon)
	Dir.mkdir(dir_day) unless File.directory?(dir_day)
	Dir.chdir(dir_day)
	return Dir.pwd
end	#my_dir

def my_file (date_prezent)
   return '/lk-' + date_prezent.strftime("%y%m%d") + '.html'
end	#my_file

end	#class
