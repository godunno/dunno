#= require_self
#= require app/core/config.module
#= require app/agenda/config.module
#= require app/courses/config.module
#= require app/lesson-plan/config.module
#= require app/join/config.module
#= require app/profile/config.module
#= require app/users/config.module
angular
  .module 'app', [
    'app.agenda',
    'app.courses',
    'app.lessonPlan',
    'app.join',
    'app.profile',
    'app.users',
    'app.system-notifications',
    'app.templates']
