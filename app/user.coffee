User = (config, game, platforms, cursors, user_group) ->
  x = game.world.randomX
  y = game.world.randomY

  this.game = game
  this.platforms = platforms
  this.cursors = cursors
  # this.player = game.add.sprite(x, 20, 'dude')
  this.player = user_group.create(0, 20, 'dude')
  this.id = config.id
  this.score = config.score
  this.last_updated = new Date(config.last_action.timestamp)

  #  We need to enable physics on the player
  game.physics.arcade.enable this.player

  #  Player physics properties. Give the little guy a slight bounce.
  this.player.body.bounce.y = .8
  this.player.body.bounce.x = .8
  this.player.body.gravity.y = 300
  this.player.body.collideWorldBounds = true

  this.player.body.velocity.x = this.game.rnd.integerInRange(-200, 200)
  this.player.body.velocity.y = this.game.rnd.integerInRange(-200, 200)

  this.player.body.angularVelocity = this.game.rnd.integerInRange(-200, 200)

  #  Our two animations, walking left and right.
  this.player.animations.add "left", [
    0
    1
    2
    3
  ], 10, true
  this.player.animations.add "right", [
    5
    6
    7
    8
  ], 10, true



  style =
    font: "10px Arial"
    fill: "#ff0044"
    align: "center"

  this.score_text = this.game.add.text(this.player.body.position.x, this.player.body.position.y, this.score, style)

  return this

User::load_texture = (asset) ->
  this.player.loadTexture asset

User::receive_update = (event) ->
  # update user
  this.update_score event.score
  this.last_updated = new Date(event.last_action.timestamp)

User::update_score = (score) ->
  this.score = score
  this.score_text.text = score

User::update = ->
  this.game.physics.arcade.collide this.player, this.platforms

  this.score_text.position.x = this.player.body.position.x
  this.score_text.position.y = this.player.body.position.y

  if this.score > 20
    this.load_texture 'baddie'

  if this.last_updated  < Date.now() - (60 * 1000)
    this.player.tint = 0x000000

  if this.last_updated  < Date.now() - (120 * 1000)
    this.player.kill()
    this.score_text.destroy()

  if this.player.body.velocity.x > 0
    this.player.animations.play 'right'
  else if this.player.body.velocity.x < 0
    this.player.animations.play 'left'
  else
    this.player.frame = 4

window.User = User
