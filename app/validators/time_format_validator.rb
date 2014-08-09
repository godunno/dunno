class TimeFormatValidator < ActiveModel::EachValidator

  FORMAT = /\A(?<hours>\d\d):(?<minutes>\d\d)\z/

  def validate_each(record, attribute, value)
    valid = true

    result = value.try(:match, FORMAT)
    if result
      hours   = result[:hours].to_i
      minutes = result[:minutes].to_i

      valid &&= hours   >= 0 && hours   <= 23
      valid &&= minutes >= 0 && minutes <= 59
    else
      valid = false
    end

    unless valid
      record.errors.add(attribute, 'invalid time format')
    end
  end
end
