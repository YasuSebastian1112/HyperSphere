extends Global

"""Propiedades"""

var ruta_del_archivo : String = "user://Data.data"

var datos : Dictionary = {
	"Niveles" : {
		"Hogar" : {
			"Nivel 1" : {
				"Desbloqueado" : true,
				"Completado" : false
			},

			"Nivel 2" : {
				"Desbloqueado" : true,
				"Completado" : false
			},

			"Nivel 3" : {
				"Desbloqueado" : true,
				"Completado" : false
			},

			"Nivel 4" : {
				"Desbloqueado" : true,
				"Completado" : false
			},

			"Nivel 5" : {
				"Desbloqueado" : true,
				"Completado" : false
			}
		}
	}
}:
	get:
		return cargar_datos(datos,ruta_del_archivo)

