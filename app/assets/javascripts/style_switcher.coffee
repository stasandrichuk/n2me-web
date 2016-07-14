$ ->
  $switcher = $('#style_switcher')
  $switcher_toggle = $('#style_switcher_toggle')
  $theme_switcher = $('#theme_switcher')
  $mini_sidebar_toggle = $('#style_sidebar_mini')
  $boxed_layout_toggle = $('#style_layout_boxed')
  $accordion_mode_toggle = $('#accordion_mode_main_menu')
  $body = $('body')
  $switcher_toggle.click (e) ->
    e.preventDefault()
    $switcher.toggleClass 'switcher_active'
    return
  $theme_switcher.children('li').click (e) ->
    e.preventDefault()
    $this = $(this)
    this_theme = $this.attr('data-app-theme')
    $theme_switcher.children('li').removeClass 'active_theme'
    $(this).addClass 'active_theme'
    $body.removeClass('app_theme_a app_theme_b app_theme_c app_theme_d app_theme_e app_theme_f app_theme_g app_theme_h app_theme_i').addClass this_theme
    if this_theme == ''
      localStorage.removeItem 'altair_theme'
    else
      localStorage.setItem 'altair_theme', this_theme
    return
  # hide style switcher
  $document.on 'click keyup', (e) ->
    if $switcher.hasClass('switcher_active')
      if !$(e.target).closest($switcher).length or e.keyCode == 27
        $switcher.removeClass 'switcher_active'
    return
  # get theme from local storage
  if localStorage.getItem('altair_theme') != null
    $theme_switcher.children('li[data-app-theme=' + localStorage.getItem('altair_theme') + ']').click()
  # toggle mini sidebar
  # change input's state to checked if mini sidebar is active
  if localStorage.getItem('altair_sidebar_mini') != null and localStorage.getItem('altair_sidebar_mini') == '1' or $body.hasClass('sidebar_mini')
    $mini_sidebar_toggle.iCheck 'check'
  $mini_sidebar_toggle.on('ifChecked', (event) ->
    $switcher.removeClass 'switcher_active'
    localStorage.setItem 'altair_sidebar_mini', '1'
    location.reload true
    return
  ).on 'ifUnchecked', (event) ->
    $switcher.removeClass 'switcher_active'
    localStorage.removeItem 'altair_sidebar_mini'
    location.reload true
    return
  # toggle boxed layout
  if localStorage.getItem('altair_layout') != null and localStorage.getItem('altair_layout') == 'boxed' or $body.hasClass('boxed_layout')
    $boxed_layout_toggle.iCheck 'check'
    $body.addClass 'boxed_layout'
    $(window).resize()
  $boxed_layout_toggle.on('ifChecked', (event) ->
    $switcher.removeClass 'switcher_active'
    localStorage.setItem 'altair_layout', 'boxed'
    location.reload true
    return
  ).on 'ifUnchecked', (event) ->
    $switcher.removeClass 'switcher_active'
    localStorage.removeItem 'altair_layout'
    location.reload true
    return
  # main menu accordion mode
  if $sidebar_main.hasClass('accordion_mode')
    $accordion_mode_toggle.iCheck 'check'
  $accordion_mode_toggle.on('ifChecked', ->
    $sidebar_main.addClass 'accordion_mode'
    return
  ).on 'ifUnchecked', ->
    $sidebar_main.removeClass 'accordion_mode'
    return
  return
