class_name MarkerObject

extends Area2D

signal picked_up

@onready var prompt_label = $Label
var player_in_range = false
var player: Player = null

func _ready():
	prompt_label.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player_in_range = true
		prompt_label.text = "Press [E] to pick up"
		prompt_label.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player = null
		player_in_range = false
		prompt_label.visible = false

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("pick_up"):
		pick_up()

func pick_up():
	prompt_label.visible = false
	player.inventory.append("Marker")
	picked_up.emit()
