extends Area2D

@export_category("Rotacion")
@export_enum("Abajo", "Arriba", "Izquierda", "Derecha") var Direccion_de_la_gravedad : int = 0


func _on_body_entered(body):
	if body is Personaje:
		body.Direccion_de_la_gravedad = Direccion_de_la_gravedad
		body.cambiar_direccion_visual(Direccion_de_la_gravedad)
