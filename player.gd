extends CharacterBody2D

@export var speed: float = 200.0

@onready var sprite = $Sprite2D

var facing_direction = Vector2.DOWN
var is_attacking = false
var is_hurt = false

var has_sword = false
var attack_power = 1

var hearts = 3
var invincible = false

func _physics_process(delta):
	# Stop movement while attacking or hurt
	if is_attacking or is_hurt:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input_dir = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	velocity = input_dir * speed

	if input_dir != Vector2.ZERO:
		facing_direction = input_dir.normalized()

	move_and_slide()

	handle_actions()
	update_sprite_direction()
	
func handle_actions():
	if Input.is_action_just_pressed("attack"):
		attack()
		
func attack():
	if not has_sword:
		print("No sword yet")
		return

	if is_attacking:
		return

	is_attacking = true
	print("ATTACK POWER:", attack_power)

	await get_tree().create_timer(0.25).timeout
	is_attacking = false
	
func hurt():
	take_damage(1)
		

	is_hurt = true
	print("HURT")

	await get_tree().create_timer(0.4).timeout
	is_hurt = false
	
func update_sprite_direction():
	if facing_direction.x < 0:
		sprite.flip_h = true
	elif facing_direction.x > 0:
		sprite.flip_h = false
		
func collect_sword():
	has_sword = true
	attack_power += 5
	print("Sword collected! Attack =", attack_power)
	
func take_damage(amount: int = 1):
	if invincible:
		return

	hearts -= amount
	print("Player hearts:", hearts)

	is_hurt = true
	invincible = true

	if hearts <= 0:
		die()
		return

	await get_tree().create_timer(0.5).timeout
	is_hurt = false

	await get_tree().create_timer(1.0).timeout
	invincible = false

func die():
	print("Player is dead")
	queue_free()
