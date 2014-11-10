User = (config, game, platforms, cursors, user_group) ->
  x = game.world.randomX
  y = game.world.randomY

  this.game = game
  this.platforms = platforms
  this.cursors = cursors
  # this.player = game.add.sprite(x, 20, 'dude')
  this.player = user_group.create(x, y, 'seacreatures', 'octopus0000')
  this.player.anchor.setTo(0.2, 0.2)
  this.id = config.id
  this.score = config.score
  this.last_updated = new Date(config.last_action.timestamp)

  #  We need to enable physics on the player
  game.physics.arcade.enable this.player

  #  Player physics properties. Give the little guy a slight bounce.
  this.player.body.bounce.y = .8
  this.player.body.bounce.x = .8
  # this.player.body.gravity.y = 300
  this.player.body.collideWorldBounds = true

  this.player.body.velocity.x = this.game.rnd.integerInRange(-200, 200)
  this.player.body.velocity.y = this.game.rnd.integerInRange(-200, 200)

  # this.player.body.angularVelocity = this.game.rnd.integerInRange(-200, 200)

  frameNames = Phaser.Animation.generateFrameNames('octopus', 0, 24, '', 4);

  this.player.animations.add 'swimocto', frameNames, 30, true, false
  this.player.animations.play 'swimocto'

  frameNames = Phaser.Animation.generateFrameNames('blueJellyfish', 0, 32, '', 4);

  this.player.animations.add 'swimjelly', frameNames, 30, true, false
  this.player.animations.play 'swimjelly'

  frameNames = Phaser.Animation.generateFrameNames('crab1', 0, 32, '', 4);

  this.player.animations.add 'crab1', frameNames, 30, true, false
  this.player.animations.play 'crab1'

  frameNames = Phaser.Animation.generateFrameNames('purpleFish', 0, 20, '', 4);

  this.player.animations.add 'pfish', frameNames, 30, true, false
  this.player.animations.play 'pfish'

  this.style =
    font: "12px Arial"
    fill: "#000000"
    align: "center"

  this.score_text = this.game.add.text(this.player.body.position.x, this.player.body.position.y, this.score, this.style)

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

  this.score_text.position.x = this.player.body.position.x + 30
  this.score_text.position.y = this.player.body.position.y + 30

  if this.score > 50 && this.score < 100
    this.player.animations.play 'pfish'
  else if this.score > 100 && this.score < 200
    # this.player.tint = 0xFF0000
    this.player.animations.play 'swimocto'
  else if this.score > 200
    # this.player.tint = 0xFF0000
    this.player.animations.play 'crab1'

  else
    this.player.animations.play 'swimjelly'


  if this.last_updated  < Date.now() - (300 * 1000)
    this.player.alpha = .2
  else
    this.player.alpha = 1

  if this.last_updated  < Date.now() - (500 * 1000)
    this.player.kill()
    this.score_text.destroy()
  else if not this.player.alive
    this.player.revive()
    this.score_text = this.game.add.text(this.player.body.position.x, this.player.body.position.y, this.score, this.style)


  # if this.player.body.velocity.x > 0
  #   this.player.animations.play 'right'
  # else if this.player.body.velocity.x < 0
  #   this.player.animations.play 'left'
  # else
  #   this.player.frame = 4

window.User = User
