extends Node2D

signal level_finished

const MARKER = preload("res://scenes/ui/marker.tscn")
const DIALOG_BOX = preload("res://scenes/ui/dialog_box.tscn")
const TASK_DISPLAY = preload("res://scenes/ui/task_display.tscn")
const TEACHER = preload("res://scenes/npc/teacher.tscn")



@onready var player: Player = %Player
@onready var ui_layer: CanvasLayer


var current_dialog: DialogBox = null
var current_task: TaskDisplay = null

var earthquake: bool = false

var teacher: NonPlayerCharacter
var marker: MarkerObject

var finding_marker: bool = false

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
		{"name": "You", "text": "...?"},
		{"name": "You", "text": "Wala lage tao?!"}
	])
	current_dialog.dialogue_finished.connect(teleport_si_sir)


func teleport_si_sir() -> void:
	current_dialog.queue_free()
	
	await get_tree().create_timer(2.5).timeout
	
	earthquake = true
	AudioManager.play_sfx("earthquake")
	
	await get_tree().create_timer(1.5).timeout
	
	AudioManager.play_sfx("thunder")
	
	teacher = TEACHER.instantiate()
	teacher.position = %TeacherPosition.position
	$NPC.add_child(teacher)
	
	await get_tree().create_timer(2.0).timeout
	
	earthquake = false
	AudioManager.stop_all_sfx()
	
	await get_tree().create_timer(1.5).timeout
	
	current_dialog = DIALOG_BOX.instantiate()
	ui_layer.add_child(current_dialog)
	current_dialog.start_dialogue([
		{"name": "You", "text": "HALAKA YAWARDS TUNGA RA LAGE KAG KALIT SIR!?!??"},
		{"name": "Teacher", "text": "Wala may klase dong?!"},
		{"name": "You", "text": "Wala diay?"},
		{"name": "Teacher", "text": "Holiday mangud dong."},
		{"name": "You", "text": "Diay?"},
		{"name": "You", "text": "Dawbe naa lage ka dinhi sir??"},
		{"name": "Teacher", "text": "Na sense sa akong ultra instincts na naay bugo ni adto sa skwelahan."},
		{"name": "Teacher", "text": "Ni teleport nalang dayon ko dinhi."},
		{"name": "You", "text": "Gusto mangud ko maka learn sir :("},
		{"name": "Teacher", "text": "Ipa quiz nalang tika kay bugo kayka."},
		{"name": "You", "text": "Ako ra sir?"},
		{"name": "Teacher", "text": "Oo kay ikaw raman naa dinhi"},
		{"name": "Teacher", "text": "Gi sugod nata quiz "},
		{"name": "Teacher", "text": "AYY HALA NABLIN NAKO MARKER PAG TELEPORT NAKO!!"},
		{"name": "Teacher", "text": "Pangitae sa kog marker para di e bagsak"}
	])
	current_dialog.dialogue_finished.connect(find_the_marker)

func find_the_marker() -> void:
	current_dialog.queue_free()
	
	current_task = TASK_DISPLAY.instantiate()
	ui_layer.add_child(current_task)
	
	current_task.task("Find a marker")
	
	finding_marker = true
	
	marker = MARKER.instantiate()
	marker.position = %MarkerPosition.position
	%Objects.add_child(marker)
	marker.picked_up.connect(picked_up_marker)

func picked_up_marker():
	current_task.queue_free()
	marker.queue_free()
