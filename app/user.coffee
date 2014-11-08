User = (game, platforms, cursors) ->
  x = game.world.randomX
  y = game.world.randomY

  this.game = game
  this.platforms = platforms
  this.cursors = cursors
  this.player = game.add.sprite(x, 20, 'dude')

  #  We need to enable physics on the player
  game.physics.arcade.enable this.player

  #  Player physics properties. Give the little guy a slight bounce.
  this.player.body.bounce.y = 0.2
  this.player.body.gravity.y = 300
  this.player.body.collideWorldBounds = true

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

  return this

User::update = ->
  this.game.physics.arcade.collide this.player, this.platforms

  this.player.body.velocity.x = 0
  if this.cursors.left.isDown
    #  Move to the left
    this.player.body.velocity.x = -150
    this.player.animations.play "left"
  else if this.cursors.right.isDown
    #  Move to the right
    this.player.body.velocity.x = 150
    this.player.animations.play "right"
  else
    #  Stand still
    this.player.animations.stop()
    this.player.frame = 4

  #  Allow the player to jump if they are touching the ground.
  this.player.body.velocity.y = -700  if this.cursors.up.isDown and this.player.body.touching.down

window.User = User
