extends CanvasLayer

signal start_game

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$Title.hide()
	start_game.emit()
