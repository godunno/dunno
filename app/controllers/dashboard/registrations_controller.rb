class Dashboard::RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      profile = params["user"]["profile"]
      user.profile = case profile
                     when "teacher" then Teacher.new
                     when "student" then Student.new
                     else raise "Invalid profile: #{profile}"
                     end
      user.save!
    end
  end
end
