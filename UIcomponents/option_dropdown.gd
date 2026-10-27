class_name OptionDropdown
extends Control

signal option_updated(old_option:String, new_option:String)

@export var config_section = "Section"
@export var parameter_name: String = "Dropdown"
@export var options: Array[String] = []

@onready var param_label: Label = $HBoxContainer/ParamLabel
@onready var option_button: OptionButton = $HBoxContainer/SettingEdit/OptionButton

var current_option: String = ""

func _ready() -> void:
	param_label.text = parameter_name
	update_options(options)

func update_options(opts:Array[String]):
	for o in opts:
		option_button.add_item(o)
	current_option = opts[0]

func _on_option_button_item_selected(index: int) -> void:
	var old = current_option
	current_option = option_button.get_item_text(index)
	option_updated.emit(old, current_option)

func get_config_value() -> Variant:
	return current_option
