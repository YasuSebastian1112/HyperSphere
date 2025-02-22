extends Node

class_name Global

"""Metodos"""

func salvar_datos(datos:Dictionary, ruta:String) -> void: 
	var file = FileAccess.open(ruta, FileAccess.WRITE) # dar permisos de acceso al archivo
	file.store_var(datos) # guardar datos
	file = null # cerrar archivo

func cargar_datos(datos:Dictionary, ruta:String) -> void:
	if FileAccess.file_exists(ruta): #Verificar la existencia del archivo
		var file = FileAccess.open(ruta, FileAccess.READ) # Dar permisos de escritura
		var ndatos = file.get_var() # cargar datos en una variable
		file = null #cerrar archivo
		combinar_diccionarios(datos, ndatos)

func combinar_diccionarios(datos_predeterminados: Dictionary, datos_cargados: Dictionary) -> Dictionary: # añadir nuevos datos
	for key in datos_predeterminados.keys():
		if datos_cargados.has(key):
			if typeof(datos_predeterminados[key]) == TYPE_DICTIONARY and typeof(datos_cargados[key]) == TYPE_DICTIONARY:
				# añadir recursividad
				datos_predeterminados[key] = combinar_diccionarios(datos_predeterminados[key], datos_cargados[key])
			else:
				# si el dato esta entonces carga su valor
				datos_predeterminados[key] = datos_cargados[key]
	return datos_predeterminados
