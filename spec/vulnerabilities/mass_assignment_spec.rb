# frozen_string_literal: true
require "spec_helper"

feature "mass assignment" do
  let(:normal_user) { UserFixture.normal_user }

  before do
    UserFixture.reset_all_users
    page.driver.browser.clear_cookies
    pending unless verifying_fixed?
  end

  scenario "attack one" do
    expect(normal_user.admin).to be_falsey
    login(normal_user)

    params = { user: { admin: "t",
                        id: normal_user.id,
                        password: normal_user.clear_password,
                        password_confirmation: normal_user.clear_password }}

    page.driver.put "/users/#{normal_user.id}.json", params

    expect(normal_user.reload.admin).to be_falsy
  end

  scenario "attack two, Tutorial: https://github.medpeer.co.jp/akira-sannoh/railsgoat/wiki/R4-Extras-Mass-Assignment-Admin-Role" do
    params = { user: {  admin: "t",
                        email: "hackety@h4x0rs.c0m",
                        first_name: "hackety",
                        last_name: "hax",
                        password: "Foobarewe100%",
                        password_confirmation: "Foobarewe100%" }}

    page.driver.post "/users", params

    expect(User.find_by(email: "hackety@h4x0rs.c0m").admin).to be_falsey
  end
end
