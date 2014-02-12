class Dashboard::ApplicationController < ApplicationController
  before_filter :authenticate_teacher!
end
