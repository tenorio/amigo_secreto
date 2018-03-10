require 'rails_helper'
require 'helpers/json_helper'

RSpec.describe MembersController, type: :controller do
  include Devise::Test::ControllerHelpers
  include Requests::JsonHelpers

  before(:each) do
    request.env["HTTP_ACCEPT"] = 'application/json'
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = FactoryBot.create(:user)

    sign_in @current_user
  end

  describe "POST #create" do
    before(:each) do
      @campaign = FactoryBot.create(:campaign)
      @member_attributes = attributes_for(:member, campaign_id: @campaign.id)
      # pp @member_attributes
      post :create, params: {member: @member_attributes}
    end

    context "New member" do
      it "should respond with JSON" do
        # pp json
        expect(response).to be_success
        expect(json.length).to eq(8)
        expect(response.body).to match /"#{ @member_attributes[:name] }"/
        expect(response.body).to match /"#{ @member_attributes[:email] }"/
        expect(response.body).to match @member_attributes[:campaign_id].to_s
      end
    end
  end

  describe "DELETE #destroy" do
    context "User is the campaign owner" do
      before(:each) do
        campaign = create(:campaign, user: @current_user)
        # pp @current_user
        # pp campaign
        @member = create(:member, campaign: campaign)
        # pp member
      end

      it "should return 'success' status" do
        delete :destroy, params: {id: @member.id}
        expect(response).to have_http_status(:success)
      end
    end

    context "User is not the campaign owner" do
      before(:each) do
        user = create(:user)
        # pp user
        campaign = create(:campaign, user: user)
        # pp campaign
        @member = create(:member, campaign: campaign)
        # pp @member
      end

      it "should return 'forbidden' status" do
        delete :destroy, params: {id: @member.id}
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PUT #update" do
    before(:each) do
      @new_member_attributes = attributes_for(:member)
    end

    context "User is the campaign owner" do
      before(:each) do
        @campaign = create(:campaign, user: @current_user)
        @member   = create(:member, campaign: @campaign)
        # pp campaign
        # pp @member
      end

      it "Updates members attributes successfully" do
        # pp @member.id
        # pp @new_member_attributes
        put :update, params: { id: @member.id, member: @new_member_attributes}
        expect(response).to have_http_status(:success)
      end
    end

    context "User is not the campaign owner" do
      before(:each) do
        user = create(:user)
        @campaign = create(:campaign, user: user)
        @member = create(:member, campaign: @campaign)
      end

      it "Should return 'forbidden' status and not update member" do
        put :update, params: { id: @member.id, member: @new_member_attributes }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "Generates member token" do
    before(:each) do
      campaign = create(:campaign, user: @current_user)
      @member  = create(:member, campaign: campaign)
    end

    it "Make sure token is unique" do
      @member.set_pixel

      expect(@member.open).to be false
      expect(Member.where(token: @member.token.to_s).count).to be 1
    end
  end
end
