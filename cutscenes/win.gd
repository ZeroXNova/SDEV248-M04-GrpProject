extends CanvasLayer

@onready var label: RichTextLabel = $Panel/RichTextLabel
@onready var text_beep: AudioStreamPlayer2D = $AudioStreamPlayer2D

var typing_speed = 15.0
var char_progress = 0.0
signal typing_finished

func _ready():
	label.text = """	You've survived the climb up Sawtooth Mountain, fighting every evil thing in your path.
		
	The peak of the mountain looks entirely black at first. Then the shadow begins to stir, lifting upward into to large, draconic wings.
	
	You're knocked to the ground by a thunderous roar.
	
	You stagger back to your feet, drawing your sword.
	
	You know this is the fight you've been chasing since this journey began.
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
