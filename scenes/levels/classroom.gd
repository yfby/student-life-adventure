extends Node2D

signal level_finished

const DIALOG_BOX = preload("res://scenes/ui/dialog_box.tscn")
#const TASK_DISPLAY = preload("res://scenes/ui/task_display.tscn")
const TEACHER = preload("res://scenes/npc/teacher.tscn")



@onready var player: Player = %Player
@onready var ui_layer: CanvasLayer

@onready var sfx_earthquake: AudioStreamPlayer = %Earthquake
@onready var sfx_thunder: AudioStreamPlayer = %Thunder

var current_dialog: DialogBox = null
#var current_task: TaskDisplay = null

var earthquake: bool = false

var teacher: NonPlayerCharacter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_layer = $UI
	
#	AudioManager.stop_all_music(2)
#	AudioManager.play_music(MusicTrack.TRACK_TYPE.TUTORIAL_LEVEL, 2) #paly tutorial music
	
	intro()

func _process(delta: float) -> void:
	if earthquake == true:
		player.camera.shake_continuous(1)

func intro() -> void:
	current_dialog = DIALOG_BOX.instantiate()
	ui_layer.add_child(current_dialog)
	current_dialog.start_dialogue([
		{"name": "You", "text": "...huh? Wala man diay tay klase?"}
	])
	current_dialog.dialogue_finished.connect(_intro_dialog_finished)


func _intro_dialog_finished() -> void:
	current_dialog.queue_free()
	
	await get_tree().create_timer(2.5).timeout
	
	earthquake = true
	sfx_earthquake.play()
	
	await get_tree().create_timer(1.5).timeout
	
	sfx_thunder.play()
	
	teacher = TEACHER.instantiate()
	teacher.position = %TeacherPosition.position
	$NPC.add_child(teacher)
	
	await get_tree().create_timer(2.0).timeout
	
	earthquake = false
	sfx_earthquake.stop()
	
	await get_tree().create_timer(1.5).timeout
	
	current_dialog = DIALOG_BOX.instantiate()
	ui_layer.add_child(current_dialog)
	current_dialog.start_dialogue([
		{"name": "You", "text": "HALAKA YAWARDS TUNGA RA LAGE KAG KALIT SIR!?!??"},
	])
	# current_dialog.dialogue_finished.connect(_intro_dialog_finished)
