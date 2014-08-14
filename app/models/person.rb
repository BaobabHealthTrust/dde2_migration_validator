require 'couchrest_model'

class Person < CouchRest::Model::Base

  use_database "person"

  def national_id
    self['_id']
  end

  def national_id=(value)
    self['_id']=value
  end

  property :assigned_site, String
  property :patient_assigned, TrueClass, :default => false

  property :person_attributes  do
    property :citizenship, String
    property :occupation, String
    property :home_phone_number, String
    property :cell_phone_number, String
    property :office_phone_number, String
    property :race, String
  end

  property :gender, String

  property :names do
    property :given_name, String
    property :family_name, String
    property :middle_name, String
    property :given_name_code, String
    property :family_name_code, String
  end

  property :patient do
    property :identifiers, []
  end

  property :birthdate, String
  property :birthdate_estimated,  TrueClass, :default => false

  property :addresses do
    property :landmark, String
    property :current_residence, String
    property :current_village, String
    property :current_ta, String
    property :current_district, String
    property :home_village, String
    property :home_ta, String
    property :home_district, String
  end
   
  property :old_identification_number, String

  timestamps!


  design do
    view :by__id
    view :by_old_identification_number
    view :by_patient_assigned_and_assigned_site
    view :by_gender
    view :by_gender_and_assigned_site 
  end

  design do
    view :search,
         :map => "function(doc){
            if (doc['type'] == 'Person' ){
              emit([doc.names.given_name_code ,doc.names.family_name_code, doc.gender], null);
            }
          }"

    view :advanced_search,
         :map => "function(doc){
            if (doc['type'] == 'Person' ){
              emit([doc.names.given_name_code,doc.names.family_name_code, doc.gender, (new Date(doc.birthdate)).getFullYear(),doc.addresses.home_ta ,doc.addresses.home_district], null);
            }
          }"

    view :search_with_dob,
         :map => "function(doc){
            if (doc['type'] == 'Person' ){
              emit([doc.names.given_name_code ,doc.names.family_name_code, doc.gender, (new Date(doc.birthdate)).getFullYear()], null);
            }
          }"
    view :search_with_home_district,
         :map => "function(doc){
            if (doc['type'] == 'Person' ){
              emit([doc.names.given_name_code ,doc.names.family_name_code, doc.gender, doc.addresses.home_district], null);
            }
          }"
    view :search_with_home_ta,
         :map => "function(doc){
            if (doc['type'] == 'Person' ){
              emit([doc.names.given_name_code ,doc.names.family_name_code, doc.gender, doc.addresses.home_ta], null);
            }
          }"
    view :search_with_home_ta_district,
         :map => "function(doc){
            if (doc['type'] == 'Person' ){
              emit([doc.names.given_name_code ,doc.names.family_name_code, doc.gender, doc.addresses.home_ta, doc.addresses.home_district], null);
            }
          }"
    view :search_with_dob_home_ta,
         :map => "function(doc){
            if (doc['type'] == 'Person' ){
              emit([doc.names.given_name_code ,doc.names.family_name_code, doc.gender,(new Date(doc.birthdate)).getFullYear() ,doc.addresses.home_ta], null);
            }
          }"
    view :search_with_dob_home_district,
         :map => "function(doc){
            if (doc['type'] == 'Person' ){
              emit([doc.names.given_name_code ,doc.names.family_name_code, doc.gender, (new Date(doc.birthdate)).getFullYear(),doc.addresses.home_district], null);
            }
          }"
    view :search_by_all_identifiers,
         :map => "function(doc) {
	          if ((doc['type'] == 'Person' && doc['patient']['identifiers'].length > 0)) {
		          for(var i in doc['patient']['identifiers']){
              	  		emit(doc['patient']['identifiers'][i][Object.keys(doc['patient']['identifiers'][i])[0]], 1);
		          }		          
	          }
          }"
    view :by_assigned_site,
         :map => "function(doc){
            if (doc['type'] == 'Person' ){
              emit([doc._id, doc.assigned_site], null);
            }
          }"
    
  end

  def set_name_codes
    self.names.given_name_code = self.names.given_name.soundex unless self.names.given_name.blank?
    self.names.family_name_code = self.names.family_name.soundex unless self.names.family_name.blank?
  end

end
