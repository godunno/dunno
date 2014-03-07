class Answer < ActiveRecord::Base
  belongs_to :student
  belongs_to :option
end
