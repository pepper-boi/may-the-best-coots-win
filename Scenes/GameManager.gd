extends Node2D

onready var animation_player = $AnimationPlayer
onready var coots_1 = $Coots1
onready var coots_2 = $Coots2
onready var p1_ui = $"%P1Moves"
onready var p2_ui = $"%P2Moves"
onready var coots_1bg = $"%Coots1BG"
onready var coots_2bg = $"%Coots2BG"
onready var claw_1 = $"%Claw1"
onready var claw_2 = $"%Claw2"
onready var minus_pos_1 = $"%MinusPos1"
onready var minus_pos_2 = $"%MinusPos2"

var shield_txt = preload("res://Art/dice_shield.svg")
var sword_txt = preload("res://Art/dice_sword.svg")
var heart_txt = preload("res://Art/dice_heart.svg")
var empty_txt = preload("res://Art/dice_empty.svg")
var hit_num = preload("res://Scenes/HitNumber.tscn")

var started = false
var tutorial = false

signal game_over

export (Array,Array,String) var p1_moves := []
export (Array,Array,String) var p2_moves := []
# d is dmg, l is love, s is sheild

func start(moves1 = [], moves2 = [], t = false):
	tutorial = t
	if moves1 != []:
		p1_moves = moves1
	if moves2 != []:
		p2_moves = moves2
	var num = 0
	for i in p1_moves:
		var new_txt := TextureRect.new()
		p1_ui.add_child(new_txt)
		new_txt.expand = true
		new_txt.modulate = get_color(i[0])
		new_txt.texture = get_texture(i[0])
		new_txt.rect_min_size = Vector2(16,16)
		new_txt.rect_pivot_offset = Vector2(8,8)
		num += 1
	coots_1bg.rect_min_size.x = (20*num)*5+30
#	coots_1bg.get_parent()
	num = 0
	for i in p2_moves:
		var new_txt := TextureRect.new()
		p2_ui.add_child(new_txt)
		new_txt.expand = true
		new_txt.modulate = get_color(i[0])
		new_txt.texture = get_texture(i[0])
		new_txt.rect_min_size = Vector2(16,16)
		new_txt.rect_pivot_offset = Vector2(8,8)
		num += 1
	coots_2bg.rect_min_size.x = (20*num)*5+30
	if not tutorial:
		turn(0)

#func _physics_process(_delta):
#	if Input.is_action_pressed("ui_accept") and not started:
#		started = true
#		turn(0)

func turn(t):
# bad jam code
	coots_1.shield = false
	coots_2.shield = false
	yield(get_tree().create_timer(1),"timeout")
	big_obj(1)
	big_obj(2)
#	coots_1bg.rect_min_size.x -= 100
	
#	coots_1bg.margin_left += 10
#	tween.parallel().tween_property(coots_2bg,"rect_min_size",coots_2bg.rect_min_size-Vector2(100,0),0.2).as_relative().set_trans(Tween.TRANS_ELASTIC)
	
#	coots_2bg.rect_min_size.x -= 100
#	coots_2bg.margin_left += 10
	var p1_move = p1_moves[0]
	var p2_move = p2_moves[0]
	if p1_move[0] == "s":
		coots_1.shield = true
		yield(get_tree().create_timer(1),"timeout")
	if p2_move[0] == "s":
		coots_2.shield = true
		yield(get_tree().create_timer(1),"timeout")
	if p1_move[0] == "d":
		if !coots_2.shield:
			animation_player.play("Attack1")
		else:
			animation_player.play("Attack1Blocked")
		yield(get_tree().create_timer(0.8),"timeout")
		if !coots_2.shield:
			claw_2.play()
			coots_2.hp -= 1-int(coots_2.shield)
			if coots_2.hp == 0:
				coots_2.get_node("CootsArt").anim_player.play("Die")
				g.explode()
				yield(get_tree().create_timer(1.5),"timeout")
				get_tree().reload_current_scene()
			var hn = hit_num.instance()
			add_child(hn)
			hn.global_position = minus_pos_2.global_position
		else:
			if p1_moves.size() > 1:
				p1_moves[1] = ["",0]
				p1_ui.get_child(1).texture = empty_txt
				p1_ui.get_child(1).modulate = Color.darkgray
		coots_2.shield = false
	if p2_move[0] == "d":
		if p1_move[0] == "d":
			yield(get_tree().create_timer(0.7),"timeout")
		if !coots_1.shield:
			animation_player.play("Attack2")
		else:
			animation_player.play("Attack2Blocked")
		yield(get_tree().create_timer(0.8),"timeout")
		if !coots_1.shield:
			claw_1.play()
			coots_1.hp -= 1-int(coots_1.shield)
			if coots_1.hp == 0:
				coots_1.get_node("CootsArt").anim_player.play("Die")
				g.explode()
				yield(get_tree().create_timer(1.5),"timeout")
				get_tree().reload_current_scene()
				return
			var hn = hit_num.instance()
			add_child(hn)
			hn.global_position = minus_pos_1.global_position
		else:
			if p1_moves.size() > 1:
				p2_moves[1] = ["",0]
				p2_ui.get_child(1).texture = empty_txt
				p2_ui.get_child(1).modulate = Color.darkgray
		coots_1.shield = false
	if p1_move[0] == "l":
		if p2_move[0] == "s":
			animation_player.play("Love1")
			if p2_moves.size() > 1:
				p2_moves[1] = ["",0]
				p2_ui.get_child(1).texture = empty_txt
				p2_ui.get_child(1).modulate = Color.darkgray
			yield(get_tree().create_timer(1),"timeout")
		yield(get_tree().create_timer(1),"timeout")
	if p2_move[0] == "l":
		if p1_move[0] == "s":
			animation_player.play("Love2")
			if p1_moves.size() > 1:
				p1_moves[1] = ["",0]
				p1_ui.get_child(1).texture = empty_txt
				p1_ui.get_child(1).modulate = Color.darkgray
		yield(get_tree().create_timer(1),"timeout")
	
	if p1_move[0] == "d" and p2_move[0] == "d":
		yield(get_tree().create_timer(1),"timeout")
	
	remove_obj(1)
	remove_obj(2)
	
	p1_moves.remove(0)
	p2_moves.remove(0)
	
	if p1_moves.size() > 0 or p2_moves.size() > 0:
		if not tutorial:
			turn(t+1)
			yield(get_tree().create_timer(1),"timeout")
	else:
		yield(get_tree().create_timer(1.5),"timeout")
		emit_signal("game_over")

func big_obj(obj):
	var p
	if obj == 1:
		p = p1_ui
	if obj == 2:
		p = p2_ui
	
	var tween = get_tree().create_tween()
	
	tween.tween_property(p.get_child(0),"rect_scale",Vector2.ONE*0.5,0.2).as_relative().set_trans(Tween.TRANS_ELASTIC)

func remove_obj(obj):
	var p
	var bg
	if obj == 1:
		p = p1_ui
		bg = coots_1bg
	if obj == 2:
		p = p2_ui
		bg = coots_2bg
	
	var tween = get_tree().create_tween()
	var first_child = p.get_child(0)
	tween.parallel().tween_property(first_child,"rect_scale",Vector2.ZERO,0.3).set_trans(Tween.TRANS_ELASTIC)
#	tween.parallel().tween_property(first_child,"rect_position",Vector2(0,-50),0.3).as_relative().set_trans(Tween.TRANS_ELASTIC)
	yield(tween,"finished")
	p.get_child(0).modulate.a = 0
	tween = get_tree().create_tween()
	tween.parallel().tween_property(first_child,"rect_min_size",Vector2.ZERO,0.05).set_trans(Tween.TRANS_ELASTIC)
	p.get_child(0).queue_free()
	yield(tween,"finished")
	tween = get_tree().create_tween()
	tween.parallel().tween_property(bg,"rect_min_size",Vector2(-100,0),0.3).as_relative().set_trans(Tween.TRANS_ELASTIC)

func get_color(type):
	if type == "d":
		return Color.red
	if type == "l":
		return Color.pink
	if type == "s":
		return Color.dodgerblue

func get_texture(type):
	if type == "d":
		return sword_txt
	if type == "l":
		return heart_txt
	if type == "s":
		return shield_txt
