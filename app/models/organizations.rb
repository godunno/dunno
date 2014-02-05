class Organizations < ActiveRecord::Base
  validates :name, presence: true
end
