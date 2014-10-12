class Artifact < ActiveRecord::Base
  acts_as_predecessor exposes: :event

  belongs_to :teacher
  belongs_to :timeline

  delegate :event, to: :timeline
end
