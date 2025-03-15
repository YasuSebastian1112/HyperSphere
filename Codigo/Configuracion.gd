extends Control

"""Propiedades"""

"""Clases"""

func _on_salir_pressed():
	CONFIGURACIONES.salvar_datos(CONFIGURACIONES.configuraciones, CONFIGURACIONES.ruta_del_archivo)
