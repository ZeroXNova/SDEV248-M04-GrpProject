extends CharacterBody2D

var player_in_range = null
var sword_given = false
var dialog_ui = null
var dialog_label = null

func _ready():
	dialog_ui = get_tree().get_first_node_in_group("dialog_ui")
	dialog_label = dialog_ui.get_node("Panel/Label")

func _process(delta):
	if player_in_range != null:
		if Input.is_action_just_pressed("interact"):
			if not sword_given:
				show_dialog("It's dangerous to go alone! Take this.")
				give_sword()
			else:
				show_dialog("Use that sword wisely.")

func give_sword():
	if player_in_range == null or sword_given:
		return

	sword_given = true
	player_in_range.collect_sword()

func show_dialog(text):
	dialog_ui.visible = true
	dialog_label.text = text
	await get_tree().create_timer(2.0).timeout
	if player_in_range == null:
		hide_dialog()

func hide_dialog():
	dialog_ui.visible = false
	dialog_label.text = ""
	
func _on_area_2d_body_entered(body):
	if body.has_method("collect_sword"):
		player_in_range = body
		show_dialog("Press E to talk")

func _on_area_2d_body_exited(body):
	if body == player_in_range:
		player_in_range = null
		hide_dialog()
