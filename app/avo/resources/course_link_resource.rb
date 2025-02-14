class CourseLinkResource < Avo::BaseResource
  self.title = :link
  self.includes = [:course]
  self.description = 'Demo resource to illustrate Avo\'s nested (namespaced) model support (the model represented here is Course::Link)'
  self.model_class = ::Course::Link
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], link_cont: params[:q], m: "or").result(distinct: false)
  end

  self.ordering = {
    display_inline: true,
    visible_on: :index, # :index or :association
    actions: {
      higher: -> { record.move_higher }, # has access to record, resource, options, params
      lower: -> { record.move_lower },
      to_top: -> { record.move_to_top },
      to_bottom: -> { record.move_to_bottom }
    }
  }

  field :id, as: :id
  field :link, as: :text, help: "Hehe. Something helpful."
  field :enable_course, as: :boolean, only_on: :forms, html: {
    edit: {
      input: {
        data: {
          action: "resource-edit#disable",
          resource_edit_disable_target_param: "courseBelongsToWrapper"
        }
      }
    }
  }
  field :course, as: :belongs_to, searchable: true
end
