class_name Prototype
extends Level

@export var player_spawn_position: Marker2D
@export var camera: Camera2D

func get_player_spawn_position() -> Marker2D:
	return player_spawn_position

func get_camera() -> Camera2D:
	return camera
