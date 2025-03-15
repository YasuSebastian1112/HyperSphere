extends TabBar

"""Propiedades"""

@onready var idioma : int = $Configuraciones/Idioma/Idioma.selected:
	get:
		return CONFIGURACIONES.configuraciones["Accesibilidad"]["Idioma"]

"""Metodos"""

func _on_idioma_item_selected(index:int) -> void:
	CONFIGURACIONES.cambiar_idioma(index)
