class_name OptionKeybind
extends Control

@export var input:String = "Keybind"

@onready var param_label: Label = $HBoxContainer/ParamLabel

func _ready() -> void:
	param_label.text = clean_input_name(input)

func clean_input_name(text:String) -> String:
	var new_text:String = ""
	for c in text:
		if c == "_":
			c = " "
		new_text += c
	new_text[0] = new_text[0].capitalize()
	return new_text
