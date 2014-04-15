namespace :import do
	desc "Import Deals"
	# Receives the Already created Publisher ID and the Name of the script under /script/data that wil be imported
	# rake import:deals["Name of the Publisher","daily_planet_export.txt"]

	task :deals, [:publisher_name, :file_path] => :environment do |t, args|
		path = Rails.root.join("script", "data", args.file_path)
		raise ArgumentError, "File doesn't exists" unless File.exists?(path)
		raise ArgumentError, "File can't be read" unless File.readable?(path)

		publisher = Publisher.find_or_create_by_name(
						name: args.publisher_name,
						parent: Publisher.find_by_name("Entertainment")
					) 
		
		linenumber = 1
		File.open(path, 'r').each_line do |record|
			regexp = /(?<name>.+)\s+(?<start>\d{2}\/\d{1,2}\/\d{4})\s(?<end>\d{2}\/\d{1,2}\/\d{4}|\s)\s+(?<deal>.+)\s+(?<price>\d+)\s+(?<value>\d+)/
			info = record.match(regexp)
			if linenumber != 1
				if info.present?
				 	advertiser = publisher.advertisers.find_or_create_by_name(info[:name])
					deal = advertiser.deals.new({
						proposition: info[:name].squish,
						start_at: info[:start],
						end_at: info[:end].squish!.present? ? info[:end] : Date.today,
						description: info[:deal].squish,
						value: info[:value],
						price: info[:price],
						advertiser_id: 107
					})
					if deal.save
						p "Imported deal: #{deal.id}"
					else
						p "There was an error storing information on line #{linenumber}"
					end
				else
					p "There was an error importing information on line #{linenumber}"
				end
			end
			linenumber+=1
		end  
	end
end