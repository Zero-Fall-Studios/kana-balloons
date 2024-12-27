class_name SignalTextureButton extends TextureButton

@export var signal_name: String

func _on_pressed() -> void:
	SignalBus.get_signal(signal_name).emit()
