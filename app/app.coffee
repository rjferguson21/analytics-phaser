player = undefined
platforms = undefined
cursors = undefined
stars = undefined
users = {}
user_group = undefined
window.update_queue = []

preload = ->
  game.load.image "sky", "assets/sky.png"
  game.load.image "ground", "assets/platform.png"
  game.load.image "star", "assets/star.png"
  game.load.spritesheet "baddie", "assets/baddie.png", 32, 32
  game.load.spritesheet "dude", "assets/dude.png", 32, 48
  game.load.spritesheet "blue_fish", "assets/blue_fish.png", 21, 21
  game.load.spritesheet "fish", "assets/fish.png", 64, 64
  game.load.spritesheet "jellyfish", "assets/jellyfish.png", 30, 64

  game.load.atlas('seacreatures', 'assets/seacreatures_json.png', 'assets/seacreatures_json.json')

  return
create = ->

  #  We're going to be using physics, so enable the Arcade Physics system
  game.physics.startSystem Phaser.Physics.ARCADE

  #  A simple background for our game
  game.add.sprite 0, 0, "sky"

  #  The platforms group contains the ground and the 2 ledges we can jump on
  platforms = game.add.group()

  user_group = game.add.group()

  #  We will enable physics for any object that is created in this group
  platforms.enableBody = true

  # Here we create the ground.
  ground = platforms.create(0, game.world.height - 64, "ground")

  #  Scale it to fit the width of the game (the original sprite is 400x32 in size)
  ground.scale.setTo 2, 2

  #  This stops it from falling away when you jump on it
  ground.body.immovable = true

  #  Now let's create two ledges
  # ledge = platforms.create(400, 400, "ground")
  # ledge.body.immovable = true
  # ledge = platforms.create(-150, 250, "ground")
  # ledge.body.immovable = true

  #  Our controls.
  cursors = game.input.keyboard.createCursorKeys()

  socket = io 'http://api.nxt-games.nxtgd.net:80'

  socket.on 'update', (data) ->
    console.log 'update', data
    if users[data.id]?
      users[data.id].receive_update(data)
    else
      users[data.id] = new User(data, game, platforms, cursors, user_group)


  socket.on 'users', (users_list) ->
    console.log 'users', users_list
    for user in users_list
      users[user.id] = new User(user, game, platforms, cursors, user_group)

  return

update = ->
  for key,value of users
    #  Collide the player and the stars with the platforms
    value.update()

  game.physics.arcade.collide user_group

  return

game = new Phaser.Game(800, 600, Phaser.AUTO, "",
  preload: preload
  create: create
  update: update
)
