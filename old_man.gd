extends CharacterBody2D

var player_in_range = null
var sword_given = false

func _process(delta):
	if player_in_range != null and not sword_given:
		if Input.is_action_just_pressed("attack"):
			give_sword()

func give_sword():
	if player_in_range == null or sword_given:
		return

	sword_given = true
	player_in_range.collect_sword()
	print("It's dangerous to go alone! Take this.")

func _on_area_2d_body_entered(body):
	if body.has_method("collect_sword"):
		player_in_range = body
		print("Press attack to receive sword")

func _on_area_2d_body_exited(body):
	if body == player_in_range:
		player_in_range = null
