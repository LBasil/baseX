extends Control

@onready var ip_input = $VBoxContainer/IpInput
@onready var host_button = $VBoxContainer/HostButton
@onready var join_button = $VBoxContainer/JoinButton
@onready var network_manager = $"../NetworkManager"

func _ready():
	host_button.pressed.connect(_on_host_pressed)
	join_button.pressed.connect(_on_join_pressed)

func _on_host_pressed():
	network_manager.start_server()
	visible = false

func _on_join_pressed():
	network_manager.start_client(ip_input.text)
	visible = false
