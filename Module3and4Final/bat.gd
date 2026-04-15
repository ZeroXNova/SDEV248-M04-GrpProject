extends CharacterBody2D

@export var circle_radius: float = 30.0
@export var circle_speed: float = 2.0
@export var move_speed: float = 60.0
@export var chase_range: float = 180.0
@export var chase_speed_multiplier: float = 2.0

@onready var sprite = $Sprite2D

var player = null
var center_position: Vector2
var angle: float = 0.0

func _ready():
	player = get_parent().get_node("Player")
	center_position = global_position

func _physics_process(delta):
	if player == null:
		return

	var distance_to_player = global_position.distance_to(player.global_position)

	if distance_to_player <= chase_range:
		chase_player()
	else:
		fly_in_circle(delta)

	move_and_slide()

func fly_in_circle(delta):
	angle += circle_speed * delta

	var target_position = center_position + Vector2(
		cos(angle),
		sin(angle)
	) * circle_radius

	velocity = (target_position - global_position) * 5.0
	flip_sprite(velocity)

func chase_player():
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * move_speed * chase_speed_multiplier
	flip_sprite(direction)

func flip_sprite(direction: Vector2):
	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false
		
func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(1)		
		print("Bat Damage")
