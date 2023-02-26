extends Node2D

onready var hp_txt = $CootsArt/"%HpTxt"
#onready var love_txt = $VBoxContainer/Love
#onready var shield_txt = $VBoxContainer/Shield

var hp = 10
var love = 0
var shield = false

var dmg = 500
var love_amount = 334
var sheild_amount = 500

func _physics_process(_delta):
	hp_txt.text = str(hp)
