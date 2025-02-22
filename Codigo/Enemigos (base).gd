extends Personaje

class_name Enemigo_basico

"""Propiedades"""

@export_category("Control del enemigo")
@export var direccion : int = -1
@export_category("Objetos del enemigo")
@export var proyectiles : Array[PackedScene]
@export var botin : PackedScene


"""Metodos"""
