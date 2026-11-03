class_name GameCamera
extends Camera2D

var target: Node2D


func _process(_delta: float) -> void:
	if is_instance_valid(target):
		global_position = target.global_position
