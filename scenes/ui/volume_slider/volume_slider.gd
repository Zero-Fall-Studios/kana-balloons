extends Control

@export var bus_index: int = 0
@export var label_text: String = ""

@onready var label: Label = $Label
@onready var slider: Slider = $HSlider

func _ready():
	label.text = label_text
	if Engine.is_editor_hint():
		label.text = label_text
		
	var percent = AudioManager.bus_idx_volume[bus_index];
	slider.set_value_no_signal(percent)

func _on_h_slider_value_changed(value):
	AudioManager.set_volume(bus_index, value)
