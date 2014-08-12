
start = Time.now()

site_id = DdeSite.where(code: CONFIG['site_code']).first.id

migration_stats = Hash.new

@total_number_national_ids = DdeNationalPatientIdentifier.count
migration_stats["total_number_national_ids"] = @total_number_national_ids
puts migration_stats.inspect
@total_number_national_ids_allocated_to_site =  DdeNationalPatientIdentifier.where(assigner_site_id: site_id).count
migration_stats["total_number_national_ids_allocated_to_site"] = @total_number_national_ids_allocated_to_site
puts migration_stats.inspect
@total_number_national_ids_assigned_to_people = DdeNationalPatientIdentifier.where("person_id is not null").count
migration_stats["total_number_national_ids_assigned_to_people"] = @total_number_national_ids_assigned_to_people
puts migration_stats.inspect
@total_number_national_ids_assigned_to_people_on_site = DdeNationalPatientIdentifier.where("person_id is not null and assigner_site_id = #{site_id}").count
migration_stats["total_number_national_ids_assigned_to_people_on_site"] = @total_number_national_ids_assigned_to_people_on_site
puts migration_stats.inspect


@total_number_of_people_created = DdePerson.count
migration_stats["total_number_of_people_created"] = @total_number_of_people_created
puts migration_stats.inspect
@total_number_of_people_created_on_site = DdePerson.find_by_sql("SELECT * FROM people p INNER JOIN national_patient_identifiers n ON p.id = n.person_id WHERE n.assigner_site_id = #{site_id}").count
migration_stats["total_number_of_people_created_on_site"] = @total_number_of_people_created_on_site
puts migration_stats.inspect

@total_number_of_people_created_from_other_site = DdePerson.find_by_sql("SELECT * FROM people p INNER JOIN national_patient_identifiers n ON p.id = n.person_id WHERE n.assigner_site_id != #{site_id}").count
migration_stats["total_number_of_people_created_from_other_site"] = @total_number_of_people_created_from_other_site
puts migration_stats.inspect

@total_number_of_male_people = DdePerson.where(gender: "M").count
migration_stats["total_number_of_male_people"] = @total_number_of_male_people
puts migration_stats.inspect
@total_number_of_female_people = DdePerson.where(gender: "F").count
migration_stats["total_number_of_female_people"] = @total_number_of_female_people
puts migration_stats.inspect
@total_number_of_people_without_gender = DdePerson.where("gender is null").count rescue 0
migration_stats["total_number_of_people_without_gender"] = @total_number_of_people_without_gender
puts migration_stats.inspect
@total_number_of_male_people_on_site = DdePerson.where(creator_site_id: site_id,gender: "M").count rescue 0
migration_stats["total_number_of_male_people_on_site"] = @total_number_of_male_people_on_site
puts migration_stats.inspect
@total_number_of_female_people_on_site = DdePerson.where(creator_site_id: site_id,gender: "F").count rescue 0
migration_stats["total_number_of_female_people_on_site"] =  @total_number_of_female_people_on_site
puts migration_stats.inspect

@total_number_of_duplicate_idenfifiers = DdeNationalPatientIdentifier.find_by_sql("SELECT value FROM national_patient_identifiers GROUP BY value HAVING COUNT(value) > 1").count
migration_stats["total_number_of_duplicate_idenfifiers"] = @total_number_of_duplicate_idenfifiers
puts migration_stats.inspect
@total_number_of_duplicate_idenfifiers_on_site = DdeNationalPatientIdentifier.find_by_sql("SELECT value FROM national_patient_identifiers WHERE assigner_site_id = #{site_id} GROUP BY value HAVING COUNT(value) > 1").count
migration_stats["total_number_of_duplicate_idenfifiers_on_site"] = @total_number_of_duplicate_idenfifiers_on_site
puts migration_stats.inspect
@total_number_of_duplicate_idenfifiers_assigned = DdeNationalPatientIdentifier.find_by_sql("SELECT value FROM national_patient_identifiers WHERE person_id IS NOT NULL GROUP BY value HAVING COUNT(value) > 1").count
migration_stats["total_number_of_duplicate_idenfifiers_assigned"] = @total_number_of_duplicate_idenfifiers_assigned
puts migration_stats.inspect
@total_number_of_duplicate_idenfifiers_on_site_unassigned = DdeNationalPatientIdentifier.find_by_sql("SELECT value FROM national_patient_identifiers WHERE assigner_site_id = #{site_id} AND person_id IS NULL GROUP BY value HAVING COUNT(value) > 1").count
migration_stats["total_number_of_duplicate_idenfifiers_on_site_unassigned"] = @total_number_of_duplicate_idenfifiers_on_site_unassigned
puts migration_stats.inspect

@total_number_of_people_with_null_first_names = DdePerson.where("given_name IS NULL").count
migration_stats["total_number_of_people_with_null_first_names"] = @total_number_of_people_with_null_first_names
puts migration_stats.inspect
@total_number_of_people_with_null_last_names = DdePerson.where("family_name IS NULL").count
migration_stats["total_number_of_people_with_null_last_names"] = @total_number_of_people_with_null_last_names
puts migration_stats.inspect
@total_number_of_people_with_null_names = DdePerson.where("given_name IS NULL AND family_name IS NULL").count
migration_stats["total_number_of_people_with_null_names"] = @total_number_of_people_with_null_names 
puts migration_stats.inspect
@total_number_of_people_with_null_first_names_on_site = DdePerson.where("given_name IS NULL AND creator_site_id = #{site_id}").count
migration_stats["total_number_of_people_with_null_first_names_on_site"] = @total_number_of_people_with_null_first_names_on_site
puts migration_stats.inspect
@total_number_of_people_with_null_last_names_on_site = DdePerson.where("family_name IS NULL AND creator_site_id = #{site_id}").count
migration_stats["total_number_of_people_with_null_last_names_on_site"] = @total_number_of_people_with_null_last_names_on_site
puts migration_stats.inspect
@total_number_of_people_with_null_names_on_site = DdePerson.where("given_name IS NULL AND family_name IS NULL AND creator_site_id = #{site_id}").count
migration_stats["total_number_of_people_with_null_names_on_site"] = @total_number_of_people_with_null_names_on_site
puts migration_stats.inspect

@total_number_of_people_with_null_birthdates = DdePerson.where("birthdate IS NULL").count
migration_stats["total_number_of_people_with_null_birthdates"] = @total_number_of_people_with_null_birthdates
puts migration_stats.inspect
@total_number_of_people_with_null_birthdates_on_site = DdePerson.where("birthdate IS NULL AND creator_site_id = #{site_id}").count
migration_stats["total_number_of_people_with_null_birthdates_on_site"] = @total_number_of_people_with_null_birthdates_on_site
puts migration_stats.inspect
@total_assigned_npids_with_no_patient_record = DdeNationalPatientIdentifier.where("assigned_at IS NOT NULL AND person_id IS NULL").count
migration_stats["total_assigned_npids_with_no_patient_record"] = @total_assigned_npids_with_no_patient_record
puts migration_stats.inspect
@total_assigned_npids_with_no_patient_record_on_site = DdeNationalPatientIdentifier.where("assigned_at IS NOT NULL AND person_id IS NULL AND assigner_site_id = #{site_id}").count
migration_stats["total_assigned_npids_with_no_patient_record_on_site"] = @total_assigned_npids_with_no_patient_record_on_site
puts migration_stats.inspect
@total_person_records_with_no_national_ids = DdeNationalPatientIdentifier.find_by_sql("SELECT p.id FROM people p LEFT JOIN national_patient_identifiers n
ON p.id = n.person_id
WHERE n.person_id IS NULL").count
migration_stats["total_person_records_with_no_national_ids"] = @total_person_records_with_no_national_ids
puts migration_stats.inspect
@total_person_records_with_no_national_ids_on_site = DdeNationalPatientIdentifier.find_by_sql("SELECT p.id FROM people p LEFT JOIN national_patient_identifiers n
ON p.id = n.person_id
WHERE n.person_id IS NULL AND p.creator_site_id = #{site_id}").count

migration_stats["total_person_records_with_no_national_ids_on_site"] = @total_person_records_with_no_national_ids_on_site
puts migration_stats.inspect

migration_stats.each do |k,v|
 puts k.to_s + " : " +  v.to_s
end
puts "Started at: #{start.strftime("%Y-%m-%d %H:%M:%S")} ########## finished at:#{Time.now().strftime("%Y-%m-%d %H:%M:%S")}"
