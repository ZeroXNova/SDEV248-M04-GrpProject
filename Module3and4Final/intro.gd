extends CanvasLayer

@onready var label: RichTextLabel = $Panel/RichTextLabel
@onready var text_beep: AudioStreamPlayer2D = $AudioStreamPlayer2D

var typing_speed = 15.0
var char_progress = 0.0
var intro_finished = false

signal typing_finished

func _ready():
	label.text = """	You've just returned home from delivering goods to a far-off village. While there, you heard tale of a dark shadow creeping down from the peak of Sawtooth Mountain.

	At first, your weary eyes relish the sight of your village a few miles in the distance. Suddenly you realize that something looks.... off.

	The homes and shops look a little different and they're silhouetted by a faint, orange glow. Then you see the smoke.

	You immediately break into a sprint, hoping you're wrong.

	Running through the now broken gate, you see the bodies. And the flames. Your eyes fall on the door to your home, and you see a pool of blood originating from somehwere just out of sight. Your worst fears have been realized.

	Then you notice the faint squelch of something recently alive being chewed on. The chattering of very dry bones. The cackles of something relishing in the death and destruction it's caused.

	You look around and notice the mountain. It HAS been cloaked in shadow, all seeming to stem from it's snowy, jagged peak.

	Then you realize the sounds are getting closer...."""
	label.visible_characters = 0.0
	char_progress = 0.0

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		# If text still typing → reveal instantly
		if not intro_finished:
			label.visible_characters = label.get_total_character_count()
			intro_finished = true
			return
		else:
			# If already finished → load game
			get_tree().change_scene_to_file("res://main.tscn")
			return

	if intro_finished:
		return
	char_progress += typing_speed * delta
	var new_visible := int(char_progress)
	
	if new_visible > label.visible_characters:
		label.visible_characters = new_visible
		
		var current_char = label.text[label.visible_characters - 1]
		if current_char != " " and current_char != "\n":
			text_beep.play()
		
		if label.visible_characters >= label.get_total_character_count():
			label.visible_characters = label.get_total_character_count()
			emit_signal("typing_finished")
			get_tree().change_scene_to_file("res://main.tscn")
