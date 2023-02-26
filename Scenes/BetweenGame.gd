extends Control

onready var multiplayer_manager = $"."
onready var join_button = $"%Join"

var types = []
var changed = 0
var ready = false

export var is_multiplayer = false
export (int) var turn = 1

func _ready():
	$VBoxContainer/HBoxContainer/Container/TextureRect.texture = load("res://Art/dice_empty.svg")
	$VBoxContainer/HBoxContainer/Container/TextureRect.modulate = Color.darkgray
	for i in $VBoxContainer/HBoxContainer.get_children():
		if i != $VBoxContainer/HBoxContainer/Container:
			i.queue_free()
	for i in clamp(turn,0,4):
		var new_box = $VBoxContainer/HBoxContainer/Container.duplicate()
		$VBoxContainer/HBoxContainer.add_child(new_box)
	$"%CootsBG".rect_min_size.x = 150*(clamp(turn,0,4)+1)

func start():
	join_button.disabled = true
	g.click()
	if is_multiplayer:
		if not ready:
			for i in $VBoxContainer/HBoxContainer.get_children():
				types.append([i.get_child(0).type,1])
			get_parent().remote_set_ready(types)
			ready = true
		types = []
	else:
		for z in 3:
			for i in $VBoxContainer/HBoxContainer.get_children():
				types.append([i.get_child(0).type,1])
		get_parent().get_node("Game").p1_moves = types
		types = []
		for z in 3:
			for i in $VBoxContainer/HBoxContainer2.get_children():
				types.append([i.get_child(0).type,1])
		get_parent().get_node("Game").p2_moves = types
		get_parent().get_node("Game").show()
		get_parent().get_node("Game").start()
		hide()
