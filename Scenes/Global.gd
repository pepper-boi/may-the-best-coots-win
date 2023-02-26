extends Node

var starting_text = ""

var p1_wins = 0
var p2_wins = 0

func click():
	$Click.play()

func smack():
	$Smack.play()

func shield():
	$Shield.play()

func dropped():
	$Dropped.play()

func picked():
	$Dropped2.play()

func explode():
	$Explode.play()
