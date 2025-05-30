extends Node2D

@export var next_level: PackedScene

var level_time = 0.0
var start_level_msec = 0.0
var time_left = 30.0
var level_failed_shown = false

@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var start_in = %StartIn
@onready var start_in_label = %StartInLabel
@onready var animation_player = $AnimationPlayer
@onready var level_time_label = %LevelTimeLabel
@onready var level_failed = $CanvasLayer/LevelFailed

func _ready():
	if not next_level is PackedScene:
		level_completed.next_level_button.text = "Victory Screen"
		next_level = load("res://victory_screen.tscn")

	Events.level_completed.connect(show_level_completed)
	Events.level_failed.connect(show_level_failed)
	get_tree().paused = true
	start_in.visible = true
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false
	start_in.visible = false
	start_level_msec = Time.get_ticks_msec()

func _process(delta):
	level_time = Time.get_ticks_msec() - start_level_msec
	time_left = 30.0 - level_time / 1000.0
	level_time_label.text = str(time_left)

	if time_left <= 0 and not level_failed_shown:
		show_level_failed()
		

func retry():
	level_failed_shown = false
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_file_path)

func go_to_next_level():
	if not next_level is PackedScene: return
	level_failed_shown = false
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)

func show_level_completed():
	level_completed.show()
	level_completed.retry_button.grab_focus()
	get_tree().paused = true

func show_level_failed():
	level_failed.show()
	level_failed_shown = true
	level_completed.retry_button.grab_focus()
	get_tree().paused = true
	

func _on_level_completed_retry():
	retry()

func _on_level_completed_next_level():
	go_to_next_level()


func _on_level_failed_retry():
	retry()
