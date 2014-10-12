class TimelineMessage < ActiveRecord::Base
  include HasUuid
  belongs_to :student
  has_one :timeline_interaction, as: :interaction
  has_one :timeline, through: :timeline_interaction

  acts_as_votable

  validates :content, :student, presence: true

  #TODO add tests
  def vote_direction_by(voter)
    vote = votes_for.where(voter_id: voter.id, voter_type: "Student").first
    if vote
      vote.vote_flag ? "up" : "down"
    end
  end
end
