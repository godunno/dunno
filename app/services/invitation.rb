class Invitation
  EXPIRE_AFTER = 10.days

  def initialize(user)
    @user = user
  end

  def invite!
    fail AlreadyInvitedError if @user.invitation_token.present?
    send_invite
  end

  def reinvite!
    send_invite
  end

  class AlreadyInvitedError < StandardError; end

  def expired?
    return true if @user.invitation_sent_at.nil?
    Time.zone.now > @user.invitation_sent_at + EXPIRE_AFTER
  end

  private

  def generate_token
    loop do
      token = Devise.friendly_token
      return token unless User.exists?(invitation_token: token)
    end
  end

  def send_invite
    @user.invitation_token = generate_token
    @user.invitation_sent_at = Time.zone.now
    @user.save!
  end
end
