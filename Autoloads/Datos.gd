extends Global

"""Propiedades"""

var perfiles : Dictionary = {}

var perfil : String

var ruta_del_archivo : String = "user://"+perfil+".cfg"

var datos : Dictionary = {
	"Niveles" : {
		"Hogar" : {
			"Nivel 1 completado" : {
				"Desbloqueado" : true,
				"Completado" : false
			},

			"Nivel 2 completado" : {
				"Desbloqueado" : true,
				"Completado" : false
			},

			"Nivel 3 completado" : {
				"Desbloqueado" : true,
				"Completado" : false
			},

			"Nivel 4 completado" : {
				"Desbloqueado" : true,
				"Completado" : false
			},

			"Nivel 5 completado" : {
				"Desbloqueado" : true,
				"Completado" : false
			}
		}
	}
}

"""Metodos"""

func crear_perfil(nombre_del_perfil : String) -> void:
	if not perfiles.has(nombre_del_perfil):
		perfiles[nombre_del_perfil] = nombre_del_perfil
	else : print("Error: perfil ya existente") 

func borrar_perfil(nombre_del_perfil : String) -> void:
	if perfiles.has(nombre_del_perfil):
		perfiles.erase(nombre_del_perfil)
