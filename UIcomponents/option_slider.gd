class_name OptionSlider
extends Control

signal value_updated(old_value:float, new_value:float)

@export var parameter_name: String = "Slider"
@export var min_value:float = 0.01
@export var max_value:float = 1.0
@export var step:float = 0.01

@onready var slider_name: Label = $HBoxContainer/ParamLabel
@onready var slider: HSlider = $HBoxContainer/SettingEdit/Slider
@onready var slider_value: LineEdit = $HBoxContainer/SettingEdit/SliderValue

var current_value:float = 0.5

func _ready() -> void:
	slider_name.text = parameter_name
	slider.max_value = max_value
	slider.min_value = min_value
	slider.step = step
	update_value(current_value * max_value) #to be changed with the loading of config value

func update_value(value:float):
	var old = current_value
	value = clampf(value, min_value, max_value)
	current_value = value
	slider.value = value
	slider_value.text = str(value)
	value_updated.emit(old, current_value)

func _on_slider_value_changed(value: float) -> void:
	update_value(value)

func _on_incr_btn_pressed() -> void:
	update_value(current_value + step)

func _on_decr_btn_pressed() -> void:
	update_value(current_value - step)
