require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards).dependent(:nullify) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:second_question) { build(:question) }
  let(:answer) { create(:answer, question: question, user: author) }

  context 'is the author for his question and answer' do
    subject { author }
    it { is_expected.to be_author(question) }
    it { is_expected.to be_author(answer) }
  end

  context 'is not the author of the question and answer of another user' do
    subject { user }
    it { is_expected.not_to be_author(question) }
    it { is_expected.not_to be_author(answer) }
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: 123_456) }
    let(:service) { double 'FindForOauthService' }

    it 'calls service FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#create_subscription' do
    it 'created new subscription' do
      expect { question }.to change(Subscription, :count).by(1)
    end

    it 'created new subscription for question' do
      expect { second_question.save }.to change(second_question.subscriptions, :count).by(1)
    end
  end

  describe '#subscribed?' do
    context 'is subscribed to his question' do
      subject { author }
      it { is_expected.to be_subscribed(question) }
    end

    context 'is not subscribed to the question of another user' do
      subject { user }
      it { is_expected.not_to be_subscribed(question) }
    end
  end
end
