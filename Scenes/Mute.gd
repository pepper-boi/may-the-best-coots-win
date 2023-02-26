extends Sprite

func mute():
	var master_sound = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_sound, !AudioServer.is_bus_mute(master_sound))
	
	if AudioServer.is_bus_mute(master_sound):
		frame = 50
		offset.x = -2
	else:
		frame = 49
		offset.x = 0

