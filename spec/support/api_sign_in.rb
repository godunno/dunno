
def auth_params(student = nil)
  student ||= create(:student)
  { student_email: student.email, student_token: student.authentication_token }
end
