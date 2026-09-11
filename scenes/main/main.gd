extends Node

func _ready() -> void:
	load_classroom()

func load_classroom() -> void:
	SceneManager.change_scene("res://scenes/levels/classroom.tscn")
