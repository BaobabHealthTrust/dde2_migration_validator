class PeopleController < ApplicationController
  def index
    site = DdeSite.where(code: CONFIG['site_code']).first
   	site_id = site.id
  	@site_name = site.name
    @dde2_people_count = Person.count   
    line_num=0
		text=File.open(Rails.root.join('log','site_log.log')).read
		text.gsub!(/\r\n?/, "\n")
		text.each_line do |line|
			line_num += 1
		end

    @dde_people_count = line_num
    
    national_id = params[:npid] 
   
    site_id = DdeSite.find_by_code(CONFIG['site_code']).id
    unless national_id.blank?
      
    	dde2_person = Person.find(national_id) rescue nil
      dde_person = DdeNationalPatientIdentifier.find_by_value(national_id).person rescue nil
      if !dde2_person.blank? && !dde_person.blank?
       @dde2_person = dde2_person
       @dde_person = dde_person
      elsif dde2_person.blank? and dde_person.blank?  
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

  def premigration
    	site = DdeSite.where(code: CONFIG['site_code']).first
   		site_id = site.id
  	  @site_name = site.name
			@migration_stats = Hash.new
      #NPIDS
			@total_number_npids = DdeNationalPatientIdentifier.count
			@migration_stats["total_number_of_npids"] = @total_number_npids
			@total_number_npids_allocated_to_site =  DdeNationalPatientIdentifier.where(assigner_site_id: site_id).count
			@migration_stats["total_number_of_npids_allocated_to_site"] = @total_number_npids_allocated_to_site
			@total_number_npids_assigned_to_patients = DdeNationalPatientIdentifier.where("person_id is not null").count
			@migration_stats["total_number_of_npids_assigned_to_patients"] = @total_number_npids_assigned_to_patients
			@total_number_npids_assigned_to_patients_on_site = DdeNationalPatientIdentifier.where("person_id is not null and assigner_site_id = #{site_id}").count
      @migration_stats["total_number_of_npids_assigned_to_patients_on_site"] = @total_number_npids_assigned_to_patients_on_site


      @total_number_of_duplicate_npids = DdeNationalPatientIdentifier.find_by_sql("SELECT value FROM national_patient_identifiers GROUP BY value HAVING COUNT(value) > 1").count
			@migration_stats["total_number_of_duplicate_npids"] = @total_number_of_duplicate_npids
			@total_number_of_duplicate_npids_on_site = DdeNationalPatientIdentifier.find_by_sql("SELECT value FROM national_patient_identifiers WHERE assigner_site_id = #{site_id} GROUP BY value HAVING COUNT(value) > 1").count
			@migration_stats["total_number_of_duplicate_npids_on_site"] = @total_number_of_duplicate_npids_on_site
			@total_number_of_duplicate_npids_assigned = DdeNationalPatientIdentifier.find_by_sql("SELECT value FROM national_patient_identifiers WHERE person_id IS NOT NULL GROUP BY value HAVING COUNT(value) > 1").count
			@migration_stats["total_number_of_duplicate_npids_assigned"] = @total_number_of_duplicate_npids_assigned
			@total_number_of_duplicate_npids_on_site_unassigned = DdeNationalPatientIdentifier.find_by_sql("SELECT value FROM national_patient_identifiers WHERE assigner_site_id = #{site_id} AND person_id IS NULL GROUP BY value HAVING COUNT(value) > 1").count
			@migration_stats["total_number_of_duplicate_npids_on_site_unassigned"] = @total_number_of_duplicate_npids_on_site_unassigned
       
      @total_assigned_npids_with_no_patient_record = DdeNationalPatientIdentifier.where("assigned_at IS NOT NULL AND person_id IS NULL AND voided = 0").count
			@migration_stats["total_assigned_npids_with_no_patient_record"] = @total_assigned_npids_with_no_patient_record
			@total_assigned_npids_with_no_patient_record_on_site = DdeNationalPatientIdentifier.where("assigned_at IS NOT NULL AND person_id IS NULL AND assigner_site_id = #{site_id} AND voided = 0").count
			@migration_stats["total_assigned_npids_with_no_patient_record_on_site"] = @total_assigned_npids_with_no_patient_record_on_site

      @total_voided_npids = DdeNationalPatientIdentifier.where("voided = 1").count
			@migration_stats["total_voided_npids"] = @total_voided_npids
			@total_voided_npids_on_site = DdeNationalPatientIdentifier.where("assigner_site_id = #{site_id} AND voided = 1").count
			@migration_stats["total_voided_npids_on_site"] = @total_voided_npids_on_site

      @total_voided_but_assigned_npids = DdeNationalPatientIdentifier.where("person_id IS NOT NULL AND voided = 1").count
			@migration_stats["total_voided_but_assigned_npids"] = @total_voided_but_assigned_npids
			@total_voided_but_assigned_npids_on_site = DdeNationalPatientIdentifier.where("person_id IS NOT NULL AND assigner_site_id = #{site_id} AND voided = 1").count
			@migration_stats["total_voided_but_assigned_npids_on_site"] = @total_voided_but_assigned_npids_on_site

      #Patients

			@total_number_of_patients_created = DdePerson.count
			@migration_stats["total_number_of_patients_created"] = @total_number_of_patients_created
			@total_number_of_patients_created_on_site = DdePerson.find_by_sql("SELECT * FROM people p INNER JOIN national_patient_identifiers n ON p.id = n.person_id WHERE n.assigner_site_id = #{site_id}").count
			@migration_stats["total_number_of_patients_created_on_site"] = @total_number_of_patients_created_on_site
			@total_number_of_patients_created_from_other_site = DdePerson.find_by_sql("SELECT * FROM people p INNER JOIN national_patient_identifiers n ON p.id = n.person_id WHERE n.assigner_site_id != #{site_id}").count
			@migration_stats["total_number_of_patients_created_from_other_site"] = @total_number_of_patients_created_from_other_site
			@total_number_of_male_patients = DdePerson.where(gender: "M").count
			@migration_stats["total_number_of_male_patients"] = @total_number_of_male_patients
      @total_number_of_male_patients_on_site = DdePerson.where(creator_site_id: site_id,gender: "M").count rescue 0
			@migration_stats["total_number_of_male_patients_on_site"] = @total_number_of_male_patients_on_site
			@total_number_of_female_patients = DdePerson.where(gender: "F").count
			@migration_stats["total_number_of_female_patients"] = @total_number_of_female_patients
			
			@total_number_of_female_patients_on_site = DdePerson.where(creator_site_id: site_id,gender: "F").count rescue 0
			@migration_stats["total_number_of_female_patients_on_site"] =  @total_number_of_female_patients_on_site
      @total_number_of_patients_without_gender = DdePerson.where("gender is null or gender = ''").count rescue 0
			@migration_stats["total_number_of_patients_without_gender"] = @total_number_of_patients_without_gender

			@total_number_of_patients_with_null_first_names = DdePerson.where("given_name IS NULL or given_name = ''").count
			@migration_stats["total_number_of_patients_with_null_first_names"] = @total_number_of_patients_with_null_first_names
			@total_number_of_patients_with_null_last_names = DdePerson.where("family_name IS NULL or family_name = ''").count
			@migration_stats["total_number_of_patients_with_null_last_names"] = @total_number_of_patients_with_null_last_names
			@total_number_of_patients_with_null_names = DdePerson.where("(given_name IS NULL or given_name = '') AND (family_name IS NULL or family_name = '')").count
			@migration_stats["total_number_of_patients_with_null_names"] = @total_number_of_patients_with_null_names 
			@total_number_of_patients_with_null_first_names_on_site = DdePerson.where("(given_name IS NULL OR given_name = '') AND creator_site_id = #{site_id}").count
			@migration_stats["total_number_of_patients_with_null_first_names_on_site"] = @total_number_of_patients_with_null_first_names_on_site
			@total_number_of_patients_with_null_last_names_on_site = DdePerson.where("(family_name IS NULL or family_name ='') AND creator_site_id = #{site_id}").count
			@migration_stats["total_number_of_patients_with_null_last_names_on_site"] = @total_number_of_patients_with_null_last_names_on_site
			@total_number_of_patients_with_null_names_on_site = DdePerson.where("(given_name IS NULL  or given_name = '') AND family_name IS NULL AND creator_site_id = #{site_id}").count
			@migration_stats["total_number_of_patients_with_null_names_on_site"] = @total_number_of_patients_with_null_names_on_site

			@total_number_of_patients_with_null_birthdates = DdePerson.where("birthdate IS NULL or birthdate = ''").count
			@migration_stats["total_number_of_patients_with_null_birthdates"] = @total_number_of_patients_with_null_birthdates
			@total_number_of_patients_with_null_birthdates_on_site = DdePerson.where("(birthdate IS NULL OR birthdate = '') AND creator_site_id = #{site_id}").count
			@migration_stats["total_number_of_patients_with_null_birthdates_on_site"] = @total_number_of_patients_with_null_birthdates_on_site
			
			@npids = DdeNationalPatientIdentifier.where("person_id IS NOT NULL AND voided = 0").collect{|person| person.person_id.to_i }
      @people = DdePerson.all.collect{|person| person.id }
      @total_patients_without_npids = @people - @npids
			@migration_stats["total_patients_without_npids"] =  @total_patients_without_npids.length

			@npids_on_site = DdeNationalPatientIdentifier.where("person_id IS NOT NULL AND assigner_site_id = #{site_id} AND voided = 0").collect{|person| person.person_id.to_i }
      @people_on_site = DdePerson.where("creator_site_id = #{site_id}").collect{|person| person.id }
      @total_patients_without_npids_on_site = @people_on_site - @npids_on_site
			@migration_stats["total_patients_without_npids_on_site"] = @total_patients_without_npids_on_site.length

  end

  def postmigration
   
      @migration_stats_multiple = []
      @total_number_npids = []
			@total_number_npids_allocated_to_site = []
			@total_number_npids_assigned_to_patients = []
			@total_number_npids_assigned_to_patients_on_site = []
     
      #Patients
			@total_number_of_patients_created = []
      @total_number_of_patients_created_on_site = []
      @total_number_of_patients_created_from_other_site = []
      @total_number_of_male_patients = []
      @total_number_of_male_patients_on_site = []
      @total_number_of_female_patients = []
			@total_number_of_female_patients_on_site = []
      @total_number_of_patients_without_gender = []
      @total_number_of_patients_without_gender_on_site = []

      @sites = CONFIG['sites'].split
      @sites_count = @sites.length
		  @migration_stats = Hash.new
      @sites.each do |site_m|
      site = DdeSite.where(code: site_m).first
   		site_id = site.id
  	  @site_name = site.name
      #NPIDS
			
      @total_number_npids << Npid.count
			@migration_stats["total_number_of_npids"] = @total_number_npids
			@total_number_npids_allocated_to_site <<  Npid.by_site_code.keys([site.code]).rows.count
			@migration_stats["total_number_of_npids_allocated_to_site"] = @total_number_npids_allocated_to_site
			@total_number_npids_assigned_to_patients << Npid.by_assigned.keys([true]).rows.count
			@migration_stats["total_number_of_npids_assigned_to_patients"] = @total_number_npids_assigned_to_patients
			@total_number_npids_assigned_to_patients_on_site << Npid.by_site_code_and_assigned.keys([[site.code,true]]).rows.count
      @migration_stats["total_number_of_npids_assigned_to_patients_on_site"] = @total_number_npids_assigned_to_patients_on_site
     
      #Patients
  
			@total_number_of_patients_created << Person.count
			@migration_stats["total_number_of_patients_created"] = @total_number_of_patients_created    
      @total_number_of_patients_created_on_site << Person.by_assigned_site.keys([site.code]).rows.count
			@migration_stats["total_number_of_patients_created_on_site"] = @total_number_of_patients_created_on_site

      @total_number_of_male_patients << Person.by_gender.keys(["M"]).rows.count
			@migration_stats["total_number_of_male_patients"] = @total_number_of_male_patients
      @total_number_of_male_patients_on_site << Person.by_gender_and_assigned_site.keys([["M",site.code]]).rows.count
			@migration_stats["total_number_of_male_patients_on_site"] = @total_number_of_male_patients_on_site
      @total_number_of_female_patients << Person.by_gender.keys(["F"]).rows.count
			@migration_stats["total_number_of_female_patients"] = @total_number_of_female_patients
			@total_number_of_female_patients_on_site << Person.by_gender_and_assigned_site.keys([["F",site.code]]).rows.count
			@migration_stats["total_number_of_female_patients_on_site"] =  @total_number_of_female_patients_on_site
      @total_number_of_patients_without_gender << Person.by_gender.keys([""]).rows.count
			@migration_stats["total_number_of_patients_without_gender"] = @total_number_of_patients_without_gender
      @total_number_of_patients_without_gender_on_site << Person.by_gender_and_assigned_site.keys([["",site.code]]).rows.count
			@migration_stats["total_number_of_patients_without_gender_on_site"] = @total_number_of_patients_without_gender_on_site
   end   

		   @total_number_of_npids =  @migration_stats["total_number_of_npids"].first
		   @migration_stats.delete("total_number_of_npids")
		   @total_number_npids_assigned_to_patients = @migration_stats["total_number_of_npids_assigned_to_patients"].first
		   @migration_stats.delete("total_number_of_npids_assigned_to_patients")
		   @total_number_of_patients_created = @migration_stats["total_number_of_patients_created"].first
		   @migration_stats.delete("total_number_of_patients_created")
		   @total_number_of_male_patients  = @migration_stats["total_number_of_male_patients"].first
		   @migration_stats.delete("total_number_of_male_patients")
		   @total_number_of_female_patients = @migration_stats["total_number_of_female_patients"].first
		   @migration_stats.delete("total_number_of_female_patients")
		   @total_number_of_patients_without_gender = @migration_stats["total_number_of_patients_without_gender"].first
		   @migration_stats.delete("total_number_of_patients_without_gender") 
		 
  end
  
  def random_search
    site = DdeSite.find_by_code(CONFIG['site_code'])
    site_id = site.id
    @site_name = site.name
    @national_ids = []
    unless params[:random_count].blank?
      random_count = params[:random_count] 
      command_string = "SELECT value FROM national_patient_identifiers WHERE assigned_at IS NOT NULL ORDER BY RAND() LIMIT #{random_count}"
      random_npids = DdeNationalPatientIdentifier.find_by_sql(command_string)
      npids = random_npids.map {|npid| npid.value }
      
      npids.each do |npid|
         dde2_person = Person.find(npid) rescue nil
         dde_person = DdeNationalPatientIdentifier.find_by_value(npid).person rescue nil
         if !dde2_person.blank? and !dde_person.blank?
           national_id_mismatch =  dde_person.national_patient_identifier.value.to_s != dde2_person.national_id.to_s ? true : nil
    			 site_code_mismatch =  dde_person.national_patient_identifier.assigner_site.code.to_s != dde2_person.assigned_site.to_s ? true : nil
           given_name_mismatch = dde_person.given_name.to_s != dde2_person.names.given_name.to_s ? true : nil
           family_name_mismatch = dde_person.family_name.to_s != dde2_person.names.family_name.to_s ? true : nil
           gender_mismatch =  dde_person.gender.to_s != dde2_person.gender.to_s ? true : nil
           birthdate_mismatch = dde_person.birthdate.to_s != dde2_person.birthdate.to_s ? true : nil
           birthdate_estimated_mismatch = dde_person.birthdate_estimated.to_s != dde2_person.birthdate_estimated.to_s ? true : nil

     			if national_id_mismatch || site_code_mismatch || given_name_mismatch || family_name_mismatch || gender_mismatch || birthdate_mismatch   || birthdate_estimated_mismatch
     					mismatch = true
     			else
     					mismatch = false 
    			end 
             person = Hash.new
             value  = dde_person.national_patient_identifier.value.to_s rescue ''
             site = dde_person.national_patient_identifier.assigner_site.code.to_s rescue ''
             person = {"person_dde" => dde_person,
                       "person_dde_value" => value,
                       "person_dde_site" => site,  
                       "person_dde2" => dde2_person, 
                       "mismatch" => mismatch }
             @national_ids << person
         end       
      end
   end
 end
end
