class Group < ActiveRecord::Base
  before_save :parameterize_key
  belongs_to :user
  validates_presence_of :user_id
  has_many :subscriptions, :dependent => :destroy

  has_many :items, :through => :subscriptions, :dependent => :destroy
  private

  def parameterize_key
    self.label ||= ""
    key = self.label.parameterize
    self.key = key
  end
end
