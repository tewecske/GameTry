extends CanvasLayer

signal start_game

@onready var debug := $Debug

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$Title.hide()
	start_game.emit()


func _on_debug_button_toggled(toggled_on: bool) -> void:
	Global.debug = toggled_on
	if toggled_on:
		debug.show()
	else:
		debug.hide()
		
