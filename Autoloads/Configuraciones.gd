extends Global

"""Propiedades"""

var ruta_del_archivo : String = "user://Configuraciones.cfg"

var configuraciones : Dictionary = {
	"Video" : {
		
	},
	"Sonido" : {
		
	},
	"Controles" : {
		
	},
	"Accesibilidad" : {
		"Idioma" : 0
	}
}:
	get:
		return cargar_datos(configuraciones, ruta_del_archivo)

"""Metodos"""

func cambiar_idioma(index) -> void:
	match index:
		0: TranslationServer.set_locale("Es")
		1: TranslationServer.set_locale("En")
	configuraciones["Accesibilidad"]["Idioma"] = index
