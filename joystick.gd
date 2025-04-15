extends Node2D

@onready var background = $JoystickBackground
@onready var handle = $JoystickHandle
var radius = 50.0  # Rayon du joystick (correspond au fond)
var touch_index = -1  # Index du toucher
var direction = Vector2.ZERO  # Direction du joystick

func _ready():
	# S'assurer que le manche est centré au départ
	handle.position = Vector2.ZERO

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed and touch_index == -1:
			# Début du toucher
			var touch_pos = event.position
			var local_pos = touch_pos - global_position
			if local_pos.length() < radius:
				touch_index = event.index
				update_handle(local_pos)
		elif event.index == touch_index and not event.pressed:
			# Fin du toucher
			touch_index = -1
			handle.position = Vector2.ZERO
			direction = Vector2.ZERO
	
	if event is InputEventScreenDrag and event.index == touch_index:
		# Glissement du doigt
		var touch_pos = event.position
		var local_pos = touch_pos - global_position
		update_handle(local_pos)

func update_handle(local_pos: Vector2):
	# Limiter le manche à l'intérieur du cercle
	var clamped_pos = local_pos.limit_length(radius)
	handle.position = clamped_pos
	# Calculer la direction (normalisée entre -1 et 1)
	direction = clamped_pos / radius
