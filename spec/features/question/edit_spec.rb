require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
" do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Unauthenticated user can not to edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in author
      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: 'Edited question title'
        fill_in 'Body', with: 'Edited question body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edited question title'
        expect(page).to have_content 'Edited question body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors', js: true do
      sign_in author
      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question", js: true do
      sign_in user
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
