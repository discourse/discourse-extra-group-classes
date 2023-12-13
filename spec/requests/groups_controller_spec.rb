# frozen_string_literal: true

require "rails_helper"

describe "Groups Controller" do
  fab!(:user) { Fabricate(:user) }
  fab!(:admin) { Fabricate(:admin) }
  fab!(:group) { Fabricate(:group) }

  it "should update when updated as an admin" do
    sign_in(admin)
    put "/admin/groups/#{group.id}/extra_classes", params: { extra_classes: "a|b|c" }

    expect(response.status).to eq(200)
    expect(group.reload.custom_fields["extra_classes"]).to eq("a|b|c")
  end

  it "should error when the class list is too long" do
    sign_in(admin)
    put "/admin/groups/#{group.id}/extra_classes",
        params: {
          extra_classes: "something-with-wayyyyyy-too-many-words-here",
        }
    expect(response.status).to eq(400)

    put "/admin/groups/#{group.id}/extra_classes",
        params: {
          extra_classes: "areallyreallyreallylongwordherethisistoolongwaywaytoolong",
        }
    expect(response.status).to eq(400)

    put "/admin/groups/#{group.id}/extra_classes",
        params: {
          extra_classes: "way|too|may|classes|here|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s",
        }
    expect(response.status).to eq(400)

    expect(group.reload.custom_fields["extra_classes"]).to be_nil
  end

  it "should 404 for a normal user" do
    sign_in(user)
    put "/admin/groups/#{group.id}/extra_classes", params: { extra_classes: "a|b|c" }

    expect(response.status).to eq(404)
    expect(group.reload.custom_fields["extra_classes"]).to be_nil
  end
end
