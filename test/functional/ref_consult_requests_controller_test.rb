require 'test_helper'

class RefConsultRequestsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @request.env["devise.mapping"] = Devise.mappings
    @user = FactoryGirl.create(:user)
    sign_in @user

    @ref_consult_request = FactoryGirl.create(:ref_consult_request)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ref_consult_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ref_consult_request" do
    r = Factory.attributes_for(:ref_consult_request)
    
    assert_difference('RefConsultRequest.count') do
      post :create, ref_consult_request: r
    end

    assert_redirected_to ref_consult_request_path(assigns(:ref_consult_request))
  end

  test "should show ref_consult_request" do
    #binding.pry
    get :show, id: @ref_consult_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ref_consult_request
    assert_response :success
  end

  test "should update ref_consult_request" do
    put :update, id: @ref_consult_request, ref_consult_request: @ref_consult_request.attributes
    assert_redirected_to ref_consult_request_path(assigns(:ref_consult_request))
  end

  test "should destroy ref_consult_request" do
    assert_difference('RefConsultRequest.count', -1) do
      delete :destroy, id: @ref_consult_request
    end

    assert_redirected_to ref_consult_requests_path
  end

   test "get a result as xml" do
    request.env['HTTP_ACCEPT'] = Mime::XML

    get :index
    doc = Nokogiri::XML::Document.parse(response.body)
    assert_response :success, "Referral Consult list is empty!"

    #binding.pry
    ## search for id
    items = doc.xpath("//_id").inspect
    id = items.split[3].scan(/(\w+)/)
    #STDOUT << "\n=====\n"
    #STDOUT << id[0]

    get :show, id: id[0]
    doc = Nokogiri::XML::Document.parse(response.body)
    assert_response :success, "Cannot find referral with id:#{id}"
    #assert_equal "result", doc.children.first.name
  end

end
