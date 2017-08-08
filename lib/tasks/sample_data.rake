namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = Band.create!(bn_head: "GLOBAL MARKETS", 
novelty: "European stock markets open down", 
bn_date: "2017-07-14 19:57:39", 
bn_url: "http://www.reuters.com/article/global-markets-idUSL5N1KP1QZ")

    99.times do |n|
      bn_head  = "News-#{n+1}"
			novelty  = Faker::Name.name
      bn_date  = "2017-07-14 19:57:39"
      bn_url = "http://www.reuters.com/article/global-markets-idUSL5N1KP1QZ"      
      Band.create!(bn_head: bn_head,
                   novelty: novelty,
                   bn_date: bn_date,
                   bn_url: bn_url)
    end
  end
end

