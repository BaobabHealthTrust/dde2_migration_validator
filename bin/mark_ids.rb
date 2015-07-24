logger = Logger.new(Rails.root.join("log","marked_ids.log"))

dde_ids = DdeNationalPatientIdentifier.all

dde_ids.each do |identifier|

		found_id = Npid.by_national_id.keys([identifier.value])

		if found_id.present? && found_id.assigned == false
			
			  site_code = DdeSite.find(identifier.assigner_site_id).code
			  region = Site.find(site_code).region
			  
				found_id.update_attributes(:assigned => true, 
																	 :site_code => site_code, 
																	 :region => region)
				logger.info found_id.national_id.to_s
				
				puts "Updated " + found_id.national_id.to_s
			
		end
	
end
