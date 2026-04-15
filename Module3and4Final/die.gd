extends CanvasLayer

@onready var label: RichTextLabel = $Panel/RichTextLabel
@onready var text_beep: AudioStreamPlayer2D = $AudioStreamPlayer2D

var typing_speed = 15.0
var char_progress = 0.0
signal typing_finished

func _ready():
	label.text = """	Despite your best efforts and the seething need for revenge, you've fallen to the forces of shadow.
	
	Maybe in another world, another timeline, you were able to succeed...
	"""
	label.visible_characters = 0.0
	char_progress = 0.0

func _process(delta):
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
			set_process(false)
