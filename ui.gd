extends Control

@export var player: Node3D
@onready var resource_label = $ResourceLabel

func _process(delta):
	if player:
		resource_label.text = "Resources: " + str(player.resources)
