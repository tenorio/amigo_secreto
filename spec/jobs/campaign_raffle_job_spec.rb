require 'rails_helper'

RSpec.describe CampaignRaffleJob, type: :job do
  # Sidekiq::Worker.clear_all # make sure jobs don't linger between requests.
  before(:each) do
    # byebug
    @user     = FactoryBot.create(:user)
    @campaign = create(:campaign, user: @user)

    2.times { @member = create(:member, campaign: @campaign) }

    @campaign.reload
  end

  context 'Setup' do
    it "should 'subject' be the CampaignRaffleJob class itself" do
      expect(subject).to be_an(CampaignRaffleJob)
    end

    it 'should make sure we are running fake tests' do
      expect(Sidekiq::Testing.fake?).to be true
    end
  end

  describe '#perform' do
    context 'successfully' do
      it { is_expected.to be_processed_in :emails }
      # it { is_expected.to be_retryable 5 }
      # it { is_expected.to be_unique }
      # it { is_expected.to be_expired_in 1.hour }

      it 'should enqueue job' do
        #TODO: fix Sidekiq enqueue test
        # expect {
        #   subject.perform @campaign
        # }.to change(Sidekiq::Worker.jobs, :size).by(1)

        ActiveJob::Base.queue_adapter = :test
        expect {
          CampaignRaffleJob.perform_later
        }.to have_enqueued_job(CampaignRaffleJob)
      end
    end

    context 'unsuccessfully' do
      it 'should raise ArgumentError if no param was passed' do
        expect {subject.perform()}.to raise_error(ArgumentError)
      end
    end
  end
end
