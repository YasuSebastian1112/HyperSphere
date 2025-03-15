extends Control

"""Propiedades"""

@onready var contenedor : VBoxContainer = $Contenedor_de_tablas/Tabla/Perfiles/Contenedor

@export_category("Administrador de perfiles")
@export var perfil : PackedScene

"""Metodos"""

func _ready():
	pass

func crear_perfiles() -> void:
	for i in DATOS.perfiles.keys():
		var nuevo_perfil = perfil.instantiate()
		nuevo_perfil.nombre_del_perfil = DATOS.perfiles[i]
		contenedor.add_child(nuevo_perfil)
