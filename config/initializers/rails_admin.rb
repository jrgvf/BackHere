RailsAdmin.config do |config|

  config.main_app_name { ['BackHere', 'Admin'] }

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration
  
  # For support Paginate and show list of sessions in Rails_Admin
  # MongoidStore::Session.send(:include, Kaminari::MongoidExtension::Document)
  # MongoidStore::Session.send(:include, RailsAdmin::Adapters::Mongoid::Extension)
  
  # config.included_models << "MongoidStore::Session"

  config.included_models = [
    "Account", "Permission", "SocialInfo", "User", "HomeMessage", "Platform", "Magento",
    "Notification", "Customer", "Order", "Survey", "Message", "Task", "DelayerTask"
  ]

  config.included_models << TaskFactory::TASKS.map(&:to_s)

  config.navigation_static_label = "Outros Links"
  config.navigation_static_links = {
    'Sidekiq' => '/sidekiq'
  }

  config.model 'Platform' do
    navigation_label 'Plataformas'
    weight 1
  end

  config.model 'Task' do
    navigation_label 'Tarefas'
    weight 1
  end

  config.model 'DelayerTask' do
    navigation_label 'Tarefas'
    weight 2
  end

  config.model 'Order' do
    object_label_method do
      :internal_code
    end
  end

  config.model 'User' do
    navigation_icon 'icon-user'
    field :name
    field :position
    field :email
    field :password
    field :password_confirmation
    edit do
      field :avatar do
        delete_method :delete_avatar
      end
    end
  end

  config.model 'HomeMessage' do
    field :created_at
    field :name
    field :email
    field :fone
    field :message
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete 
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
