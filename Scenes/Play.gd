extends Node2D

func play():
	$AnimationPlayer.play("Claw")
	yield($AnimationPlayer,"animation_finished")
