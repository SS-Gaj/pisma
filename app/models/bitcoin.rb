class Bitcoin < ActiveRecord::Base
	default_scope -> { order('btc_date DESC') }
	validates :btc_head, presence: true
	validates :btc_novelty, presence: true
	validates :btc_date, presence: true
	validates :btc_url, presence: true, uniqueness: true
end
