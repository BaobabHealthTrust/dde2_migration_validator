class PeopleController < ApplicationController
  def index
    @people_count = Person.count 
   
    national_id = params[:npid]
    unless national_id.blank?
    	dde2_person = Person.find(national_id) rescue nil
      dde_person = DdeNationalPatientIdentifier.find_by_value(national_id).person rescue nil
      if !dde2_person.blank? && !dde_person.blank?
       session[:dde2_person] = nil
       session[:dde_person] = nil
       @dde2_person = dde2_person
       @dde_person = dde_person  
      elsif dde2_person.blank?
        @error = "DDE2 does not have a person with a national id of : #{national_id}"
      elsif dde_person.blank?  
        @error = "DDE1 does not have a person with a national id of : #{national_id}" 
      end 
    else

    end   
    
  end
end
