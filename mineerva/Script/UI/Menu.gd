extends Control

func _on_Button_pressed():
	Global.galaxy_size = $SpinBox.value
	get_tree().change_scene_to_file("res://Scenes/Galaxy.tscn")
