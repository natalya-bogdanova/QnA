require 'rails_helper'

feature 'Answer author can destroy the answer', "
  In order to destroy answer from a community
  As an authenticated user
  I'd like to be able to delete my answer
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author)}

  describe 'Authenticated user' do
    scenario 'deletes his answer' do
      sign_in(author)
      visit question_path(question)
      click_on 'Delete Answer'

      expect(page).to have_content 'Your answer successfully deleted.'
      expect(current_path).to eq question_path(question)
    end

    scenario "deletes another user's answer" do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_no_content 'Delete Answer'
    end
  end

  scenario 'Unauthenticated user tries to delete a question' do
    visit question_path(question)

    expect(page).to have_no_content 'Delete Answer'
  end
end
