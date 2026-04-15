extends MarginContainer
@onready var life_counter = $HBoxContainer/LifeCounter.get_children()

func update_life(value):
	for i in range(life_counter.size()):
		life_counter[i].visible = value > i
