extends Control

const VERSION = "application/config/version"

@onready var fps: Label = $MarginContainer/VBoxContainer/fps
@onready var version: Label = $MarginContainer/VBoxContainer/version
@onready var debug: Label = $MarginContainer/VBoxContainer/debug

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_add_version_to_overlay()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	fps.text = "FPS: " + str(Engine.get_frames_per_second())

func _add_version_to_overlay():
	version.text = "Build: " + ProjectSettings.get_setting(VERSION)
