extends Node

const PORT = 4433
const MAX_PLAYERS = 4
var players = {}

func _ready():
	pass

func start_server():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_PLAYERS)
	if error:
		print("Erreur serveur : ", error)
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	print("Serveur démarré sur le port ", PORT)

func start_client(ip):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ip, PORT)
	if error:
		print("Erreur client : ", error)
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	print("Client connecté à ", ip)
	# Instancier le joueur local immédiatement
	spawn_player(multiplayer.get_unique_id())

func _on_peer_connected(id):
	print("Joueur connecté : ", id, " sur ", "serveur" if multiplayer.is_server() else "client")
	if multiplayer.is_server():
		spawn_player(id)

func _on_peer_disconnected(id):
	print("Joueur déconnecté : ", id)
	if players.has(id):
		players[id].queue_free()
		players.erase(id)

func spawn_player(id):
	print("Instanciation joueur ", id, " sur ", "serveur" if multiplayer.is_server() else "client")
	var player_scene = load("res://player.tscn")
	if player_scene == null:
		print("Erreur : player.tscn non trouvé")
		return
	var player = player_scene.instantiate()
	if player == null:
		print("Erreur : instanciation échouée")
		return
	player.name = str(id)
	player.position = Vector3(randi_range(-5, 5), 1.5, randi_range(-5, 5))
	var root = get_tree().root.get_node("Node3D")
	if root == null:
		print("Erreur : Node3D non trouvé")
		return
	root.add_child(player)
	print("Joueur ", id, " ajouté à la scène avec autorité ", id)
	players[id] = player
	player.set_multiplayer_authority(id)
