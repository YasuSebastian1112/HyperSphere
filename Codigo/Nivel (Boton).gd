extends TextureButton

@export_category("Informacion del nivel")
@export var mundo : String = "Hogar":
	set(value):
		if DATOS.datos["Niveles"].has(value):
			print("Mundo existente")
		else: print("Mundo invalido")
@export var nivel : String = "Nivel 1":
	set(value):
		if DATOS.datos["Niveles"][mundo].has(value):
			print("Nivel existente")
		else: print("Nivel invalido")
@export var nivel_desbloqueado : bool = false:
	get:
		return DATOS.datos["Niveles"][mundo][nivel]["Desbloqueado"]
@export var nivel_completado : bool = false:
	get:
		return DATOS.datos["Niveles"][mundo][nivel]["Completado"]
