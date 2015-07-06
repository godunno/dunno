#= require jquery
#= require foundation/foundation
#= require foundation/foundation.topbar
#= require foundation/foundation.reveal
#= require greensock
#= require greensock/plugins/ScrollToPlugin
#= require scrollmagic
#= require scrollmagic/plugins/animation.gsap
#= require_tree ./home

$ ->
  $(document).foundation
    topbar:
      start_offset: 140
      sticky_on: 'medium, large'
