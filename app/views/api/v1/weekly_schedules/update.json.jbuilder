json.weekly_schedule do
  json.partial! 'api/v1/weekly_schedules/weekly_schedule', weekly_schedule: @weekly_schedule
end
