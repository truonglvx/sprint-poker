Reflux     = require 'reflux'
_          = require 'lodash'
{ Router } = require 'react-router'
{ Socket } = require 'phoenix'
UserMixin  = require './UserMixin'
GameMixin  = require './GameMixin'
AuthMixin  = require './AuthMixin'
DeckMixin  = require './DeckMixin'
TicketMixin  = require './TicketMixin'

Actions = Reflux.createActions _.merge
  connect: {}
  join: {}
  setCurrentGame: {}
  UserMixin.actions
  GameMixin.actions
  TicketMixin.actions

Store = Reflux.createStore
  mixins: [
    UserMixin
    GameMixin
    AuthMixin
    DeckMixin
    TicketMixin
  ]

  listenables: [ Actions ]

  init: ->
    @socket = new Socket("/ws")
    @currentGame = null

  getInitialState: ->
    @getState()

  getState: ->
    user: @user
    game: @game
    decks: @decks
    currentGame: @currentGame
    newTicket: @newTicket

  emit: ->
    @trigger @getState()

  onJoin: (channel, gameId) ->
    @channel = @socket.channel(channel, {game_id: gameId})
    @channel.join()
    event() for event in @channelEvents

  onSetCurrentGame: (id) ->
    @currentGame = id
    @emit()

module.exports = Store
module.exports.Actions = Actions
