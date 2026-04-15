extends CharacterBody2D

@export var speed = 100.0
@export var chase_speed = 180.0
@export var chase_range = 220.0

@onready var sprite = $Sprite2D

var player = null
var wander_direction = Vector2.ZERO

func _ready():
	player = get_parent().get_node("Player")
	randomize()
	choose_new_direction()

func _physics_process(delta):
	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)

	if distance <= chase_range:
		chase_player()
	else:
		wander()

	move_and_slide()

func chase_player():
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * chase_speed
	flip_sprite(direction)

func wander():
	velocity = wander_direction * speed
	flip_sprite(wander_direction)

func choose_new_direction():
	var directions = [
		Vector2.LEFT,
		Vector2.RIGHT,
		Vector2.UP,
		Vector2.DOWN
	]

	wander_direction = directions[randi() % directions.size()]

	await get_tree().create_timer(2.0).timeout
	choose_new_direction()

func flip_sprite(direction):
	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false
		
func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(1)
		print("skeleton damage")
