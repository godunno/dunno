require 'spec_helper'
require 'selenium-webdriver'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/angular'

Capybara.default_driver = :selenium

module FeatureMacros
  def sign_in(user)
    visit root_path
    click_link('Área do Professor')
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    click_button('Entrar')
  end

  def visit_event(event)
    visit_course(event.course)
    click_link("event-#{event.uuid}")
  end

  def visit_course(course)
    click_link("course-#{course.uuid}")
  end

  def fill_in_and_submit(locator, options = {})
    options[:with] = "#{options[:with]}\n"
    fill_in(locator, options)
  end
end

module WaitforLoadingPatch
  def ready_with_loading?
    loading = page.evaluate_script("$('.cg-busy-animation:visible').length > 0")
    ready_without_loading? && !loading
  end
end

module Capybara
  module Angular
    class Waiter
      include WaitforLoadingPatch
      alias_method_chain :ready?, :loading
    end
  end
end

RSpec.configure do |config|
  config.include FeatureMacros, type: :feature
  config.include Capybara::Angular::DSL, type: :feature
end
