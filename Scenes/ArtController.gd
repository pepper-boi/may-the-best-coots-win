tool
extends Node2D

var cat_1 = preload("res://Art/Cat_01.png")
var cat_2 = preload("res://Art/Cat_02.png")

onready var anim_player = $AnimationPlayer

export (bool) var side setget setter

func setter(value):
	if value:
		$Sprite.texture = cat_1
		$Sprite.position.x = -2
	else:
		$Sprite.texture = cat_2
		$Sprite.position.x = 2
	$Node2D.scale.x = (int(value)-0.5)*2
	side = value

func _ready():
	if side:
		$Sprite.texture = cat_1
		$Sprite.position.x = -2
	else:
		$Sprite.texture = cat_2
		$Sprite.position.x = 2
	$Node2D.scale.x = (int(side)-0.5)*2

func particle(e):
	$Node2D/CPUParticles2D.emitting = e
