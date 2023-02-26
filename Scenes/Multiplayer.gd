extends Control

onready var lobby_name = $"%LobbyName"
onready var error_message = $"%ErrorMessage"
onready var host_and_join = $HostAndJoin
onready var game = $"%Game"
onready var between = $ChooseDie

var ready = 0
var p1_moves = []
var p2_moves = []

var p1_wins = 0
var p2_wins = 0

const PORT = 8070

func _ready():
	var config = GotmConfig.new()
	# replace with authenticator key
	config.project_key = ""
	Gotm.initialize(config)
	game.connect("game_over",self,"reset_game")

func _physics_process(_delta):
	if Input.is_action_just_released("ui_accept"):
		_end_game(0)

func host():
	g.click()
	error_message.text = "Loading..."
	
	var fetch = GotmLobbyFetch.new()
	
	fetch.filter_properties["n"] = lobby_name.text.to_lower()
	
	var lobbies = yield(fetch.first(1), "completed")
	
	if lobbies.size() == 0:
		Gotm.host_lobby(false)
		Gotm.lobby.name = lobby_name.text.to_lower()
		Gotm.lobby.hidden = false
		Gotm.lobby.set_property("n",lobby_name.text.to_lower())
		Gotm.lobby.set_filterable("n",true)
		
		error_message.text = "Lobby Created"
		
		var peer = NetworkedMultiplayerENet.new()
		peer.create_server(PORT,2)
		get_tree().set_network_peer(peer)
		get_tree().connect("network_peer_connected", self, "_player_connected")
		get_tree().connect("network_peer_disconnected", self, "_end_game")
	else:
		error_message.text = "Name Already Used"

func join():
	g.click()
	var fetch = GotmLobbyFetch.new()
	fetch.filter_properties["n"] = lobby_name.text.to_lower()
	
	error_message.text = "Loading..."
	
	var lobbies = yield(fetch.first(1), "completed")
	
	if lobbies.size() > 0:
		var success = yield(lobbies[0].join(), "completed")
		if success:
			var peer = NetworkedMultiplayerENet.new()
			peer.create_client("127.0.0.1", PORT)
			get_tree().set_network_peer(peer)
			get_tree().connect("network_peer_disconnected", self, "_end_game")
		else:
			error_message.text = "Lobby not found or full"
	else:
		error_message.text = "Lobby not found or full"

func _player_connected(_id):
	Gotm.lobby.hidden = true
	rpc("start")

func _end_game(_id):
	g.starting_text = "Opponent Disconnected"

remotesync func start():
	host_and_join.hide()
	between.show()
	error_message.text = ""

func remote_set_ready(moves):
	rpc("set_ready",moves)

remotesync func set_ready(moves):
	ready += 1
	between.get_node("ReadyMessage").text = str(ready) + "/2 ready"
	if get_tree().get_rpc_sender_id() == 1:
		p1_moves = moves
	else:
		p2_moves = moves
	if ready == 2:
		between.join_button.disabled = false
		start_game()

func start_game():
	game.p1_moves = p1_moves
	game.p2_moves = p2_moves
	game.show()
	$ChooseDie.hide()
	game.start()

func reset_game():
	ready = 0
	between.get_node("ReadyMessage").text = "0/2 ready"
	between.turn += 1
	between.ready = false
	between._ready()
	between.show()
	game.hide()


func tutorial():
	g.click()
	get_tree().change_scene("res://Scenes/Tutorial.tscn")
