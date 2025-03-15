extends Control

"""Propiedades"""

@onready var iniciar : Label = $Iniciar
@onready var botones : VBoxContainer = $Botones1
@onready var jugar : Button = $Botones1/Jugar
@onready var configuracion : Button = $Botones1/Configuracion
@onready var extras : Button = $Botones1/Extras
@onready var salir : Button = $Botones1/Salir

var iniciado : bool = false
var en_grab : bool = false

"""Metodos"""

func _input(event) -> void:
	if event.is_pressed() and iniciado == false:
		iniciado = true
		iniciar.hide()
		botones.show()
		swichear_botones(false)
	elif Input.is_action_just_pressed("ui_cancel") and iniciado == true:
		iniciado = false
		iniciar.show()
		botones.hide()
		en_grab = false
		swichear_botones(true)
	if Input.is_action_just_pressed("ui_up") and en_grab == false or Input.is_action_just_pressed("ui_down") and en_grab == false:
		en_grab = true
		jugar.grab_focus()

func swichear_botones(valor : bool) -> void:
	jugar.disabled = valor
	configuracion.disabled = valor
	extras.disabled = valor
	salir.disabled = valor

func _on_jugar_pressed() -> void:
	print("SsO")
	pass # Replace with function body.

func _on_configuracion_pressed():
	pass # Replace with function body.

func _on_extras_pressed():
	pass # Replace with function body.

func _on_salir_pressed():
	get_tree().quit()
