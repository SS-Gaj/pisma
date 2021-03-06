class Band < ActiveRecord::Base
	#default_scope -> { order('created_at DESC') }
	default_scope -> { order('bn_date DESC') }
	validates :bn_head, presence: true
	validates :novelty, presence: true
	validates :bn_date, presence: true
	validates :bn_url, presence: true, uniqueness: true
end
