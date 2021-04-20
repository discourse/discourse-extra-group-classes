# frozen_string_literal: true

# name: discourse-extra-group-classes
# about: Adds the ability to add extra css classes to primary groups
# version: 0.1
# authors: Jeff Wong
# url: https://github.com/discourse/discourse-extra-group-class

after_initialize do
  Discourse::Application.routes.append do
    namespace :admin, constraints: AdminConstraint.new do
      put "groups/:id/extra_classes" => "groups#update_extra_group_classes", constraints: { id: /\d+/ }
    end
  end

  register_group_custom_field_type("extra_group_classes", :text)

end
