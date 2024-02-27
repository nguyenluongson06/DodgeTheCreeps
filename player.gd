extends Area2D

signal hit
@export var speed = 400;
var screen_size;

#when game load, hide the player character & get screen_size for calculations
func _ready():
  screen_size = get_viewport_rect().size;
  hide()
  
#set starting position of player at pos (Vector2D), show player character and enable collision
func start(pos):
  position = pos
  show()
  $CollisionShape2D.disabled = false
  
func _process(delta):
  #initial velocity vector (0, 0)
  var velocity = Vector2.ZERO;
  #change velocity based on which button is currently pressed
  if Input.is_action_pressed("move_right"):
    velocity.x += 1
  if Input.is_action_pressed("move_left"):
    velocity.x -= 1
  if Input.is_action_pressed("move_up"):
    velocity.y -= 1
  if Input.is_action_pressed("move_down"):
    velocity.y += 1
  
  #trigger movement when velocity is not 0
  if velocity.length() > 0:
    #normalize velocity vector (set length to 1) to prevent player from moving diagonally faster than the intended speed
    velocity = velocity.normalized() * speed;
    #and play the current animation of the sprite
    $AnimatedSprite2D.play()
  else: 
    #stop sprite animation otherwise
    $AnimatedSprite2D.stop()
  
  #set player position through velocity vector
  position += velocity * delta;
  #prevent player from moving outside the game screen
  position = position.clamp(Vector2.ZERO, screen_size)
  
  #change animation according to the current velocity vector
  if velocity.x != 0 :
    $AnimatedSprite2D.animation = "walk"
    $AnimatedSprite2D.flip_v = false
    $AnimatedSprite2D.flip_h = velocity.x < 0
  elif velocity.y != 0:
    $AnimatedSprite2D.animation = "up"
    $AnimatedSprite2D.flip_v = velocity.y > 0
    
#fired when appropriate entity collide with the collision shape
#usually enemies
func _on_body_entered(body):
  hide()
  #emit the player.hit signal and disable the collision shape
  hit.emit()
  get_node("CollisionShape2D").set_deferred("disabled", true)
