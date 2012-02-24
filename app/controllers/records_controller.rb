class RecordsController < ApplicationController
  #before_filter :authenticate_user!

  def index
    @records = Record.all

    if current_user
      desc = ""
      desc = "id:#{params[:id]}" if params[:id]
      AuditLog.create(requester_info: current_user.email, event: "record_list_access", description: desc)
    end
    respond_to do |wants|
      wants.atom {}
      wants.html{}
    end
  end
  
  def root
    
  end
  
  def create
    xml_file = request.body
    doc = Nokogiri::XML(xml_file)
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    patient_data = HealthDataStandards::Import::C32::PatientImporter.instance.parse_c32(doc)
    patient_data.save!

    response['Location'] = record_url(id: patient_data.medical_record_number)
    render :text => 'success', :status => 201
  end
  
  def show
    desc = ""
    desc = "id:#{params[:id]}" if params[:id]
    if current_user
      AuditLog.create(requester_info: current_user.email, event: "c32_access", description: desc)
      AuditLog.doc(current_user.email, "c32_access", desc, @record, @record.version)
    end

    respond_to do |wants|
      wants.atom {}
      wants.html {}
    end
  end

  def breadcrumbs
    super << breadcrumb('Patient Index')
  end
end
