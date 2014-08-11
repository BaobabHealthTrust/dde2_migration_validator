class PeopleController < ApplicationController
  def index
    @dde2_people_count = Person.count
    
    line_num=0
		text=File.open(Rails.root.join('log','site_log.log')).read
		text.gsub!(/\r\n?/, "\n")
		text.each_line do |line|
			line_num += 1
		end

    @dde_people_count = line_num
    raise @dde_people_count.inspect
    national_id = params[:npid]
    site_id = DdeSite.find_by_code(CONFIG['site_code']).id
    unless national_id.blank?
      
    	dde2_person = Person.find(national_id) rescue nil
      #dde_person = DdeNationalPatientIdentifier.find_by_value_and_assigner_site_id(national_id,site_id).person rescue nil
      dde_person = DdeNationalPatientIdentifier.find_by_value(national_id).person rescue nil
      if !dde2_person.blank? && !dde_person.blank?

       
      
       @dde2_person = dde2_person
       @dde_person = dde_person
      elsif dde_person.blank? and dde_person.blank?  
        @error = "#{national_id} does not exist both in DDE and DDE2"
      elsif dde2_person.blank?
        @dde_person = dde_person
        @error = "DDE2 does not have a person with a national id of : #{national_id}"
      elsif dde_person.blank?
        @dde2_person = dde2_person
        @error = "DDE1 does not have a person with a national id of : #{national_id}" 
      end 
    else

    end   
    	
  end
end
