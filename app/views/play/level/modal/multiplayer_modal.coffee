View = require 'views/kinds/ModalView'
template = require 'templates/play/level/modal/multiplayer'
{me} = require('lib/auth')

module.exports = class MultiplayerModal extends View
  id: 'level-multiplayer-modal'
  template: template

  events:
    'click textarea': 'onClickLink'
    'change #multiplayer': 'updateLinkSection'


  constructor: (options) ->
    super(options)
    @session = options.session
    @level = options.level
    @session.on 'change:multiplayer', @updateLinkSection, @
    @playableTeams = options.playableTeams

  getRenderData: ->
    c = super()
    c.joinLink = (document.location.href.replace(/\?.*/, '').replace('#', '') +
      '?session=' +
      @session.id)
    c.multiplayer = @session.get('multiplayer')
    c.team = @session.get 'team'
    c.levelSlug = @level?.get('slug')
    c.playableTeams = @playableTeams
    c.ladderGame = @level?.get('name') is 'Project DotA' and not me.get('isAnonymous')
    c

  afterRender: ->
    super()
    @updateLinkSection()

  onClickLink: (e) ->
    e.target.select()

  updateLinkSection: ->
    multiplayer = @$el.find('#multiplayer').prop('checked')
    la = @$el.find('#link-area')
    la.toggle Boolean(multiplayer)
    true

  onHidden: ->
    multiplayer = Boolean(@$el.find('#multiplayer').prop('checked'))
    @session.set('multiplayer', multiplayer)

  destroy: ->
    @session.off 'change:multiplayer', @updateLinkSection, @
    super()
