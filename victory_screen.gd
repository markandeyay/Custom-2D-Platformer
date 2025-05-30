extends CenterContainer

@onready var menu_button = %MenuButton

func _ready():
	menu_button.grab_focus()

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://start_menu.tscn")
