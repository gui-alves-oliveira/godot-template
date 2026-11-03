extends Node

const PROTOTYPE = "uid://dfxbwoi3k2hc0"
const PLAYER = "uid://cfnv31lsyv2og"

# Game World
@onready var levels_root: Node2D = $World/LevelsRoot
@onready var entities_root: Node2D = $World/EntitiesRoot

# UI
@onready var ui_root: Control = $UI/UIRoot
@onready var pause_root: Control = $Pause/PauseRoot
@onready var transition_root: Control = $Transition/TransitionRoot

var player: Node2D = null
var current_level: Level = null

func _ready() -> void:
	_init_player()
	load_level(PROTOTYPE)
	pass

func _process(_delta: float) -> void:
	pass

func _init_player():
	var player_scene = ResourceLoader.load(PLAYER) as PackedScene
	
	if player_scene == null:
		return
	
	player = player_scene.instantiate()
	
	if player == null:
		return
	
	entities_root.add_child(player)

func load_level(scene_uid: String):
	_deferred_load_level.call_deferred(scene_uid)

func _deferred_load_level(scene_uid: String):
	if current_level != null:
		current_level.queue_free()
		current_level = null
	
	await get_tree().process_frame
	
	var next_level = ResourceLoader.load(scene_uid, "PackedScene")
	
	if next_level == null:
		return
	
	current_level = next_level.instantiate()
	levels_root.add_child(current_level)
	
	await get_tree().process_frame
	
	_spawn_player_at_initial_position()
	_initiate_camera()

func _spawn_player_at_initial_position():
	if player == null:
		return
	
	if current_level == null:
		return
	
	player.global_position = current_level.get_player_spawn_position().global_position

func _initiate_camera():
	if player == null:
		return
	
	if current_level == null:
		return
	
	var level_camera : Camera2D = current_level.get_camera()
	
	if level_camera == null:
		return
	
	level_camera.target = player
