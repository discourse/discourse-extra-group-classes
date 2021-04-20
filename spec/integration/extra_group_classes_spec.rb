# frozen_string_literal: true

require "rails_helper"

describe "Extra Classes" do

  fab!(:user) { Fabricate(:user) }
  fab!(:admin) { Fabricate(:admin) }
  fab!(:group) { Fabricate(:group) }

  it "should update when updated as an admin" do
    sign_in(admin)

    put "/admin/groups/#{group.id}/extra_classes", params: {
          classes: "a|b|c"
        }

    expect(response.status).to eq(200)

    puts group.id
    puts group.reload.custom_fields

    expect(group.reload.custom_fields["extra_group_classes"]).to eq("a|b|c")
  end

end
