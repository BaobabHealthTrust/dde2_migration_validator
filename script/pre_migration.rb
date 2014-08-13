
start = Time.now()

site = DdeSite.where(code: CONFIG['site_code']).first
   		site_id = site.id
  	  @site_name = site.name
			@migration_stats = Hash.new
      #NPIDS
			@total_number_npids = DdeNationalPatientIdentifier.count
			@migration_stats["total_number_of_npids"] = @total_number_npids
      puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
			@total_number_npids_allocated_to_site =  DdeNationalPatientIdentifier.where(assigner_site_id: site_id).count
			@migration_stats["total_number_of_npids_allocated_to_site"] = @total_number_npids_allocated_to_site
      puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
			@total_number_npids_assigned_to_patients = DdeNationalPatientIdentifier.where("person_id is not null").count
			@migration_stats["total_number_of_npids_assigned_to_patients"] = @total_number_npids_assigned_to_patients
      puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
			@total_number_npids_assigned_to_patients_on_site = DdeNationalPatientIdentifier.where("person_id is not null and assigner_site_id = #{site_id}").count
      @migration_stats["total_number_of_npids_assigned_to_patients_on_site"] = @total_number_npids_assigned_to_patients_on_site
      puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize

      @total_number_of_duplicate_npids = DdeNationalPatientIdentifier.find_by_sql("SELECT value FROM national_patient_identifiers GROUP BY value HAVING COUNT(value) > 1").count
			@migration_stats["total_number_of_duplicate_npids"] = @total_number_of_duplicate_npids
      puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
			@total_number_of_duplicate_npids_on_site = DdeNationalPatientIdentifier.find_by_sql("SELECT value FROM national_patient_identifiers WHERE assigner_site_id = #{site_id} GROUP BY value HAVING COUNT(value) > 1").count
			@migration_stats["total_number_of_duplicate_npids_on_site"] = @total_number_of_duplicate_npids_on_site
      puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
			@total_number_of_duplicate_npids_assigned = DdeNationalPatientIdentifier.find_by_sql("SELECT value FROM national_patient_identifiers WHERE person_id IS NOT NULL GROUP BY value HAVING COUNT(value) > 1").count
			@migration_stats["total_number_of_duplicate_npids_assigned"] = @total_number_of_duplicate_npids_assigned
      puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
			@total_number_of_duplicate_npids_on_site_unassigned = DdeNationalPatientIdentifier.find_by_sql("SELECT value FROM national_patient_identifiers WHERE assigner_site_id = #{site_id} AND person_id IS NULL GROUP BY value HAVING COUNT(value) > 1").count
			@migration_stats["total_number_of_duplicate_npids_on_site_unassigned"] = @total_number_of_duplicate_npids_on_site_unassigned
       puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      @total_assigned_npids_with_no_patient_record = DdeNationalPatientIdentifier.where("assigned_at IS NOT NULL AND person_id IS NULL AND voided = 0").count
			@migration_stats["total_assigned_npids_with_no_patient_record"] = @total_assigned_npids_with_no_patient_record
			puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      @total_assigned_npids_with_no_patient_record_on_site = DdeNationalPatientIdentifier.where("assigned_at IS NOT NULL AND person_id IS NULL AND assigner_site_id = #{site_id} AND voided = 0").count
			@migration_stats["total_assigned_npids_with_no_patient_record_on_site"] = @total_assigned_npids_with_no_patient_record_on_site
      puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      @total_voided_npids = DdeNationalPatientIdentifier.where("voided = 1").count
			@migration_stats["total_voided_npids"] = @total_voided_npids
			puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      @total_voided_npids_on_site = DdeNationalPatientIdentifier.where("assigner_site_id = #{site_id} AND voided = 1").count
			@migration_stats["total_voided_npids_on_site"] = @total_voided_npids_on_site
      puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      @total_voided_but_assigned_npids = DdeNationalPatientIdentifier.where("person_id IS NOT NULL AND voided = 1").count
			@migration_stats["total_voided_but_assigned_npids"] = @total_voided_but_assigned_npids
			puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      @total_voided_but_assigned_npids_on_site = DdeNationalPatientIdentifier.where("person_id IS NOT NULL AND assigner_site_id = #{site_id} AND voided = 1").count
			@migration_stats["total_voided_but_assigned_npids_on_site"] = @total_voided_but_assigned_npids_on_site
      puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      #Patients

			@total_number_of_patients_created = DdePerson.count
			@migration_stats["total_number_of_patients_created"] = @total_number_of_patients_created
			puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      @total_number_of_patients_created_on_site = DdePerson.find_by_sql("SELECT * FROM people p INNER JOIN national_patient_identifiers n ON p.id = n.person_id WHERE n.assigner_site_id = #{site_id}").count
			@migration_stats["total_number_of_patients_created_on_site"] = @total_number_of_patients_created_on_site
			puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      @total_number_of_patients_created_from_other_site = DdePerson.find_by_sql("SELECT * FROM people p INNER JOIN national_patient_identifiers n ON p.id = n.person_id WHERE n.assigner_site_id != #{site_id}").count
			@migration_stats["total_number_of_patients_created_from_other_site"] = @total_number_of_patients_created_from_other_site
			puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      @total_number_of_male_patients = DdePerson.where(gender: "M").count
			@migration_stats["total_number_of_male_patients"] = @total_number_of_male_patients
      puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      @total_number_of_male_patients_on_site = DdePerson.where(creator_site_id: site_id,gender: "M").count rescue 0
			@migration_stats["total_number_of_male_patients_on_site"] = @total_number_of_male_patients_on_site
			puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      @total_number_of_female_patients = DdePerson.where(gender: "F").count
			@migration_stats["total_number_of_female_patients"] = @total_number_of_female_patients
			puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
			@total_number_of_female_patients_on_site = DdePerson.where(creator_site_id: site_id,gender: "F").count rescue 0
			@migration_stats["total_number_of_female_patients_on_site"] =  @total_number_of_female_patients_on_site
      puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      @total_number_of_patients_without_gender = DdePerson.where("gender is null").count rescue 0
			@migration_stats["total_number_of_patients_without_gender"] = @total_number_of_patients_without_gender
      puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
			@total_number_of_patients_with_null_first_names = DdePerson.where("given_name IS NULL").count
			@migration_stats["total_number_of_patients_with_null_first_names"] = @total_number_of_patients_with_null_first_names
			puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      @total_number_of_patients_with_null_last_names = DdePerson.where("family_name IS NULL").count
			@migration_stats["total_number_of_patients_with_null_last_names"] = @total_number_of_patients_with_null_last_names
			puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      @total_number_of_patients_with_null_names = DdePerson.where("given_name IS NULL AND family_name IS NULL").count
			@migration_stats["total_number_of_patients_with_null_names"] = @total_number_of_patients_with_null_names 
			puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      @total_number_of_patients_with_null_first_names_on_site = DdePerson.where("given_name IS NULL AND creator_site_id = #{site_id}").count
			@migration_stats["total_number_of_patients_with_null_first_names_on_site"] = @total_number_of_patients_with_null_first_names_on_site
			puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      @total_number_of_patients_with_null_last_names_on_site = DdePerson.where("family_name IS NULL AND creator_site_id = #{site_id}").count
			@migration_stats["total_number_of_patients_with_null_last_names_on_site"] = @total_number_of_patients_with_null_last_names_on_site
			puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
     @total_number_of_patients_with_null_names_on_site = DdePerson.where("given_name IS NULL AND family_name IS NULL AND creator_site_id = #{site_id}").count
			@migration_stats["total_number_of_patients_with_null_names_on_site"] = @total_number_of_patients_with_null_names_on_site
      puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
			@total_number_of_patients_with_null_birthdates = DdePerson.where("birthdate IS NULL").count
			@migration_stats["total_number_of_patients_with_null_birthdates"] = @total_number_of_patients_with_null_birthdates
			puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
      @total_number_of_patients_with_null_birthdates_on_site = DdePerson.where("birthdate IS NULL AND creator_site_id = #{site_id}").count
			@migration_stats["total_number_of_patients_with_null_birthdates_on_site"] = @total_number_of_patients_with_null_birthdates_on_site
      puts "Counting ::: " + @migration_stats.to_a.last.first.split("_").join(" ").humanize
=begin			
			@total_patients_without_npids = DdeNationalPatientIdentifier.find_by_sql("SELECT p.id FROM people p LEFT JOIN national_patient_identifiers n
			ON p.id = n.person_id
			WHERE n.person_id IS NULL").count
			@migration_stats["total_patients_without_npids"] = @total_patients_without_npids

			@total_patients_without_npids_on_site = DdeNationalPatientIdentifier.find_by_sql("SELECT p.id FROM people p LEFT JOIN national_patient_identifiers n
			ON p.id = n.person_id
			WHERE n.person_id IS NULL AND p.creator_site_id = #{site_id}").count

			@migration_stats["total_patients_without_npids_on_site"] = @total_patients_without_npids_on_site
=end

migration_stats.each do |k,v|
 puts k.to_s + " : " +  v.to_s
end
puts "Started at: #{start.strftime("%Y-%m-%d %H:%M:%S")} ########## finished at:#{Time.now().strftime("%Y-%m-%d %H:%M:%S")}"
