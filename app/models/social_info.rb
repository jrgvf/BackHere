class SocialInfo
  include Mongoid::Document
  
  embedded_in :account

  field :url,       type: String
  field :network,   type: Symbol

  validates_presence_of :url, :network

  def name
    self[:network].to_s.capitalize
  end

  def network_enum
    [:facebook, :instagram, :twitter, :linkedin, :pinterest, :youtube, :website]
  end

end
