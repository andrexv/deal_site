module DealsHelper
	def entertainment_title(deal)
		"Entertainment #{deal.advertiser.publisher.name} Deal of the Day"		
	end
end
