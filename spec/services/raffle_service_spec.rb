require 'rails_helper'

describe RaffleService do

  before :each do
    @campaign = create(:campaign, status: :pending)
  end

  describe '#call' do
    context "when has more than two members" do
      before(:each) do
        3.times { create(:member, campaign: @campaign) }
        @campaign.reload
        @results = RaffleService.new(@campaign).call
      end

      it "results is a hash" do
        expect(@results.class).to eq(Hash)
      end

      it "Hash can't be empty" do
        expect(@results).not_to be_empty
      end

      it "all members are in results as a member" do
        result_members = @results.map {|r| r.first}
        expect(result_members.sort).to eq(@campaign.members.sort)
      end

      it "all member are in results as a friend" do
        result_friends = @results.map {|r| r.last}
        expect(result_friends.sort).to eq(@campaign.members.sort)
      end

      it "a member don't get yourself" do
        @results.each do |r|
          expect(r.first).not_to eq(r.last)
        end
      end

      it "a member x don't get a member y that get the member x" do
        # byebug
        @results.each do |x|
          member_x = x.first
          member_y = x.last

          @results.each do |y|
            if y.first == member_y
              expect(y.last).not_to eql(member_x)
              break
            end
          end
        end
      end

    end

    context "when doesn't have more than two members" do
      before(:each) do
        create(:member, campaign: @campaign)
        @campaign.reload

        @response = RaffleService.new(@campaign).call
      end

      it "returns false" do
        expect(@response).to eql(false)
      end
    end
  end
end
