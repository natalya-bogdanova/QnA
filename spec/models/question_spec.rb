require 'rails_helper'

RSpec.describe Question, type: :model do
  include_examples 'link association'

  it_behaves_like 'votable' do
    let!(:votable) { create(:question, user: author) }
  end

  it { should belong_to(:user) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_one(:award).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
