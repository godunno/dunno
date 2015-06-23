class InvestorDemo
  attr_reader :teacher
  def initialize(name, email)
    User.transaction do
      user = create_user(name, email)
      @teacher = user.profile
      create_courses
      import(user)
    end
  end

  def create_user(name, email)
    User.create!(
      name: name,
      email: email,
      phone_number: "21967135534",
      password: SecureRandom.hex(4),
      profile: Profile.new
    )
  end

  def create_courses
    names = ['Matemática', 'Português', 'Física', 'Química']

    class_names = ['TR201', 'TR202', 'TR203', 'TR204']

    week_days = [1, 3, 4, 5]

    4.times do |n|
      new_course = teacher.create_course!(
        name: names[n],
        class_name: class_names[n],
        start_date: Date.current.at_beginning_of_month.next_month,
        end_date: 1.year.from_now
      )


      new_course.weekly_schedules.create!({
        start_time: "09:00",
        end_time: "12:00",
        weekday: week_days[n],
        classroom: "#{['Sala', 'Laboratório'].sample} #{n+1}"
      })

      CourseScheduler.new(new_course).schedule!
    end
  end

  def import(user)
    Invitation.new(user).invite!
  end
end
