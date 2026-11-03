extends Node

@export var player_scene: PackedScene
@export var initial_level_scene: PackedScene

var player: Player
var current_level: Level

# Game World
@onready var levels_root: Node2D = $World/LevelsRoot
@onready var entities_root: Node2D = $World/EntitiesRoot

# UI
@onready var ui_root: Control = $UI/UIRoot
@onready var pause_root: Control = $Pause/PauseRoot
@onready var transition_root: Control = $Transition/TransitionRoot


func _ready() -> void:
	_init_player()
	load_level(initial_level_scene)


func _init_player() -> void:
	if player_scene == null:
		return

	player = player_scene.instantiate() as Node2D

	if player == null:
		return

	entities_root.add_child(player)


func load_level(scene: PackedScene) -> void:
	_deferred_load_level.call_deferred(scene)


func _deferred_load_level(scene: PackedScene) -> void:
	if current_level != null:
		current_level.queue_free()
		current_level = null

	await get_tree().process_frame

	if scene == null:
		return

	current_level = scene.instantiate() as Level

	if current_level == null:
		return

	levels_root.add_child(current_level)

	await get_tree().process_frame

	_spawn_player_at_initial_position()
	_initiate_camera()


func _spawn_player_at_initial_position() -> void:
	if player == null or current_level == null:
		return

	player.global_position = current_level.get_player_spawn_position().global_position


func _initiate_camera() -> void:
	if player == null or current_level == null:
		return

	var level_camera: Camera2D = current_level.get_camera()

	if level_camera == null:
		return

	level_camera.target = player
