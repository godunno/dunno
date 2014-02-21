
def auth_params
  student = create(:student)
  { student_email: student.email, student_token: student.authentication_token }
end
