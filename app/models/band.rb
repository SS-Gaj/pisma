class Band < ActiveRecord::Base

	validates :bn_head, presence: true
	validates :novelty, presence: true
	validates :bn_date, presence: true
	validates :bn_url, presence: true, uniqueness: true
end
