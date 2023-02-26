extends Node2D

func _ready():
	var tutorial = Dialogic.start("Test")
	$GameManager.start([["l",1],["d",1],["d",1],["s",1],["l",1]],[["d",1],["s",1],["d",1],["l",1],["d",1]],true)
	add_child(tutorial)
