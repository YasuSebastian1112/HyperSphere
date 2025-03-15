extends Control

@onready var nombre : Label = $Datos/Nombre

@export_category("Perfil")
@export var nombre_del_perfil : String:
	set(valor):
		print(valor)
		nombre.text = valor
