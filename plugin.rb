# frozen_string_literal: true

# name: discourse-extra-group-classes
# about: Adds the ability to add extra css classes to primary groups
# version: 0.1
# authors: Jeff Wong
# url: https://github.com/discourse/discourse-extra-group-class

module ExtraGroupClasses
  CUSTOM_FIELD = 'extra_classes'
  CUSTOM_USER_FIELD = 'primary_group_extra_classes'
end

after_initialize do
  Discourse::Application.routes.append do
    namespace :admin, constraints: AdminConstraint.new do
      put 'groups/:id/extra_classes' => 'groups#update_extra_group_classes', defaults: { format: :json }, constraints: { id: /\d+/ }
    end
  end

  add_preloaded_group_custom_field(ExtraGroupClasses::CUSTOM_FIELD)

  [:basic_group, :group_show].each do |s|
    add_to_serializer(s, ExtraGroupClasses::CUSTOM_FIELD.to_sym) do
      object.custom_fields[ExtraGroupClasses::CUSTOM_FIELD]
    end
  end

  add_to_serializer(:group_post, ExtraGroupClasses::CUSTOM_FIELD.to_sym) do
    g = object&.user&.primary_group
    g.custom_fields[ExtraGroupClasses::CUSTOM_FIELD] unless g.nil?
  end

  [:user, :user_card].each do |s|
    add_to_serializer(s, ExtraGroupClasses::CUSTOM_USER_FIELD.to_sym) do
      g = object&.primary_group
      g.custom_fields[ExtraGroupClasses::CUSTOM_FIELD] unless g.nil?
    end
  end

  add_to_serializer(:post, :extra_classes, false) do
    fields = object.user&.primary_group&.custom_fields
    fields[ExtraGroupClasses::CUSTOM_FIELD] unless fields.nil?
  end
  add_to_serializer(:post, :include_extra_classes?) do
    fields = object.user&.primary_group&.custom_fields
    !fields.nil? && !fields[ExtraGroupClasses::CUSTOM_FIELD].blank?
  end

  add_to_class(Admin::GroupsController, :update_extra_group_classes) do
    params.require(:extra_classes)
    params.require(:id)

    # 20 character class words, dash separated. Each class is separated by |.
    # Regex supports up to 6 words, and up to 20 classes.
    valid_regex = /\A[a-z0-9]{1,20}([\-.]{1}[a-z0-9]{1,20}){0,5}(\|[a-z0-9]{1,20}([\-.]{1}[a-z0-9]{1,20}){0,5}){0,20}\Z/i

    raise Discourse::InvalidParameters unless params[:extra_classes].match(valid_regex)

    group = Group.find(params[:id])
    group.custom_fields[ExtraGroupClasses::CUSTOM_FIELD] = params[:extra_classes]
    group.save_custom_fields

    render json: success_json
  end
end
