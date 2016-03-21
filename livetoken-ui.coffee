# set to false to skip the form asking the username
loginLiveTokenAskUsername = false
Session.setDefault 'currentLanguage', (window.navigator.userLanguage || window.navigator.language).substr(0,2).toUpperCase()

Session.setDefault 'loginLiveTokenMessage', null
Session.setDefault 'loginLiveTokenMessage_type', null
Session.setDefault 'loginLiveTokenState', 'loginLiveTokenLogin'

Tracker.autorun ->
  user = Meteor.user()
  if user
    if user.username or !loginLiveTokenAskUsername
      Session.set 'loginLiveTokenState', 'loginLiveTokenLogout'
    else
      Session.set 'loginLiveTokenState', 'loginLiveTokenAskUsername'
  return

Template.registerHelper 'loginLiveTokenMessage', ->
  Session.get 'loginLiveTokenMessage'

Template.registerHelper 'liveTokenAuthMethod', ->
  Session.get 'livetoken.authMethods'

Template.liveTokenCountrySelection.created = () ->
  lang = Session.get 'currentLanguage'
  for l in indicatives
    if l.code is lang
      Session.set 'liveTokenDialCode', l.dial_code
      break

Template.liveTokenCountrySelection.helpers
  indicatives: -> indicatives
  activeCountry: -> Session.get 'currentLanguage'
  activeDialCode: -> Session.get 'liveTokenDialCode'

Template.liveTokenCountrySelection.events
  'click li.visible': (evt, tpl) ->
    if tpl.$('li.found').is ':visible'
      tpl.$('li.found').slideUp().hide()
    else
      tpl.$('li.found').show().slideDown()

  'click li.found': (evt, tpl) ->
    element = tpl.$(evt.target).closest('li.found')
    Session.set 'currentLanguage', element.data 'code'
    Session.set 'liveTokenDialCode', element.data 'country'
    tpl.$('li.found').slideUp().hide()

Template.loginLiveToken.helpers
  loginLiveTokenState: ->
    templateName = Session.get 'loginLiveTokenState'
    [{template: Template[templateName]}]
  
  notification: -> Session.get 'loginLiveTokenMessage'
  notif_class: -> Session.get 'loginLiveTokenMessage_type'
  get_tips: ->
    if Session.get('loginLiveTokenMessage_type')
      switch Session.get('loginLiveTokenMessage_type').toLowerCase()
        when 'error'
          icon = 'fa-exclamation-triangle'
        when 'warning'
          icon = 'fa-exclamation-circle'
        when 'notify'
          icon = 'fa-info-circle'
        when 'success'
          icon = 'fa-check-circle'
        else
          icon = 'fa-question-circle'

      return icon
    else
      return null

Template.loginLiveToken.rendered = () ->
  Session.set 'loginLiveTokenMessage', null
  Session.set 'loginLiveTokenMessage_type', null

Template.loginLiveToken.created = () ->
  Session.set 'loginLiveTokenState', 'loginLiveTokenLogin'
    
Template.loginLiveTokenLogin.events 
  'submit #loginLiveTokenLogin': (evt, tpl) ->
    evt.preventDefault()
    options = {}
    options.email = $('input[name=email]').val()
    options.phone = $('input[name=phone]').val()
    options.ident = $('input[name=ident]').val()
    options.dial_code = Session.get 'liveTokenDialCode'
    button = tpl.$(evt.target).closest('.button.notify')
    button.prop 'disabled', true

    Meteor.requestToken options, (err) ->
      button.prop 'disabled', false
      if err and err.reason
        Session.set 'loginLiveTokenMessage_type', 'error'
        Session.set 'loginLiveTokenMessage', err.reason

      else
        Session.set 'loginLiveTokenMessage', null
        Session.set 'loginLiveTokenMessage_type', null
        Session.set 'loginLiveTokenState', 'loginLiveTokenVerify'


Template.loginLiveTokenVerify.events
  'submit #loginLiveTokenVerify': (evt, tpl) ->
    evt.preventDefault()
    options = {}
    options.email = $('input[name=email]').val()
    options.phone = $('input[name=phone]').val()
    options.ident = $('input[name=ident]').val()
    button = tpl.$(evt.target).closest('.button.notify')
    button.prop 'disabled', true

    Meteor.loginWithToken options, (err, res) ->
      button.prop 'disabled', false
      if err and err.reason
        Session.set 'loginLiveTokenMessage_type', 'error'
        Session.set 'loginLiveTokenMessage', err.reason
      else
        Session.set 'loginLiveTokenMessage', null
        Session.set 'loginLiveTokenMessage_type', null

        if loginLiveTokenAskUsername and not Meteor.user().username
          Session.set 'loginLiveTokenState', 'loginLiveTokenAskUsername'
        else
          Session.set 'loginLiveTokenState', 'loginLiveTokenLogout'
          Session.set 'loginLiveTokenMessage', null
          Session.set 'loginLiveTokenMessage_type', null
          Router.go 'admin'

    
  'click #loginLiveTokenVerifyBack': (evt) ->
    evt.preventDefault()
    Session.set 'loginLiveTokenMessage', null
    Session.set 'loginLiveTokenMessage_type', null
    Session.set 'loginLiveTokenState', 'loginLiveTokenLogin'
    return

Template.loginLiveTokenLogin.rendered = () ->
  Meteor.getAuthMethods()

Template.loginLiveTokenAskUsername.events
  'submit #loginLiveTokenAskUsername': (evt) ->
    evt.preventDefault()
    username = event.target.username.value
    
    Meteor.setUsername username, (err, res) ->
      
      if err and err.reason
        Session.set 'loginLiveTokenMessage_type', 'error'
        Session.set 'loginLiveTokenMessage', err.reason

      else
        Session.set 'loginLiveTokenState', 'loginLiveTokenLogout'
        Session.set 'loginLiveTokenMessage', null
        Session.set 'loginLiveTokenMessage_type', null
        Router.go 'admin'

Template.loginLiveTokenLogout.helpers 
  loginLiveTokenUserInfo: ->
    user = Meteor.user()
    if !user
      return ''
    if user.username
      user.username
    else if user.emails and user.emails.length > 0
      user.emails[0].address
    else
      user._id

Template.loginLiveTokenLogout.events
  'submit #loginLiveTokenLogout': (evt) ->
    evt.preventDefault()
    Meteor.logout (err, res) ->
      
      if err
        Session.set 'loginLiveTokenMessage_type', 'error'
        Session.set 'loginLiveTokenMessage', err.reason

      else
        Session.set 'loginLiveTokenMessage', null
        Session.set 'loginLiveTokenMessage_type', null
        Session.set 'loginLiveTokenState', 'loginLiveTokenLogin'
      