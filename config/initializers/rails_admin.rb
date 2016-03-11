RailsAdmin.config do |config|

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

  config.included_models = ["Account", "Permission", "Seller", "User", "HomeMessage", "Platform", "Magento"]

  config.navigation_static_links = {
    'Sidekiq' => '../../../backhere/sidekiq'
  }
  
  # For support Paginate and show list of sessions in Rails_Admin
  # MongoidStore::Session.send(:include, Kaminari::MongoidExtension::Document)
  # MongoidStore::Session.send(:include, RailsAdmin::Adapters::Mongoid::Extension)
  
  # config.included_models << "MongoidStore::Session"

  config.model 'Seller' do
    field :account do
      read_only true
    end
    field :name
    field :position
    field :email
    field :password
    field :password_confirmation
    edit do
      field :avatar
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
