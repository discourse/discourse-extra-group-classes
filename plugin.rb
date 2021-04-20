# frozen_string_literal: true

# name: discourse-extra-group-classes
# about: Adds the ability to add extra css classes to primary groups
# version: 0.1
# authors: Jeff Wong
# url: https://github.com/discourse/discourse-extra-group-class

module ExtraGroupClasses
  CUSTOM_FIELD = 'extra_group_classes'
end

after_initialize do
  Discourse::Application.routes.append do
    namespace :admin, constraints: AdminConstraint.new do
      put 'groups/:id/extra_classes' => 'groups#update_extra_group_classes', constraints: { id: /\d+/ }
    end
  end

  register_group_custom_field_type(ExtraGroupClasses.CUSTOM_FIELD, :text)

  add_to_class(Admin::GroupsController, :update_extra_group_classes) do
    classes_params = params.require(:classes)

    # 20 character class words, dash separated. Each class is separated by |.
    # Regex supports up to 6 words, and up to 20 classes.
    valid_regex = /\A[a-z0-9]{1,20}([\-.]{1}[a-z0-9]{1,20}){0,5}(\|[a-z0-9]{1,20}([\-.]{1}[a-z0-9]{1,20}){0,5}){0,20}\Z/i

    return unless classes_params[:classes].match(valid_regex)

    group = Group.find(params[:id])
    group.custom_fields[ExtraGroupClasses.CUSTOM_FIELD] = classes_params[:classes]
    group.save

    render json: success_json
  end
end
