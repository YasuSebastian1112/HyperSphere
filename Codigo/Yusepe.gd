extends Personaje

class_name Yusepe

"""Propiedades"""

@onready var colision : CollisionShape2D = $CollisionShape2D
@onready var sprite_animado : AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote : Timer = $Temporizadores/Coyote
@onready var particulas_de_caminar : CPUParticles2D = $AnimatedSprite2D/Caminar
@onready var hitbox : Area2D = $Hitbox

"""Métodos"""

func get_axis() -> Vector2:
	var axis : Vector2 = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	return axis

func control_de_movimiento() -> void:
	if get_axis().x != 0:
		match Direccion_de_la_gravedad:
			0:
				velocity.x = get_axis().x * (velocidad * multiplicador_de_velocidad)
			1:
				velocity.x = -get_axis().x * (velocidad * multiplicador_de_velocidad)
			2:
				velocity.y = get_axis().x * (velocidad * multiplicador_de_velocidad)
			3:
				velocity.y = -get_axis().x * (velocidad * multiplicador_de_velocidad)
	elif friccion > 0:
		match Direccion_de_la_gravedad:
			0,1: velocity.x = lerp(velocity.x, 0.0, friccion)
			2,3: velocity.y = lerp(velocity.y, 0.0, friccion)

func control_del_suelo() -> void:
	if si_esta_en_el_suelo():
		saltos_restantes = saltos_maximos
	if si_esta_en_el_suelo() == false:
		if saltos_restantes == saltos_maximos and coyote.is_stopped():
			coyote.start(tiempo_de_coyote)

func control_del_salto() -> void:
	if Input.is_action_just_pressed("Saltar") and saltos_restantes > 0: # Acción de saltar
		salto()
	elif Input.is_action_just_released("Saltar"): # Salto regulado
		regular_salto()

func recibir_daño(daño_recibido : float):
	var tiempo_de_invulnerabilidad = get_tree().create_timer(1.0)
	vida -= daño_recibido
	hitbox.set_deferred("monitoring", false)
	await tiempo_de_invulnerabilidad.timeout
	hitbox.set_deferred("monitoring", true)
	print("Daño recibido: ", daño_recibido)

func control_de_animaciones() -> void:
	if get_axis().x != 0:
		if si_esta_en_el_suelo():
			sprite_animado.play("Caminando")
			particulas_de_caminar.emitting = true
		sprite_animado.scale.x = get_axis().x
	elif si_esta_en_el_suelo() == false: sprite_animado.play("Cayendo")
	else: sprite_animado.play("Quieto"); particulas_de_caminar.emitting = false

# Función que inicia el dash según la gravedad activa con cooldown de 1 segundo
func control_del_dash() -> void:
	dash = true
	puede_dashear = false
	match Direccion_de_la_gravedad:
		0:# En gravedad vertical, el dash se realiza en el eje X
			velocity.x = sprite_animado.scale.x * fuerza_del_dash
		1:
			velocity.x -= sprite_animado.scale.x * fuerza_del_dash
		2:# En gravedad horizontal, el dash se realiza en el eje Y utilizando el valor de entrada (get_axis().x)
			velocity.y = sprite_animado.scale.x * fuerza_del_dash
		3: 
			velocity.y -= sprite_animado.scale.x * fuerza_del_dash
	var aux = get_tree().create_timer(duracion_del_dash)
	await aux.timeout
	dash = false
	# Inicia el cooldown de 1 segundo para reactivar el dash
	var cooldown_timer = get_tree().create_timer(cooldown_del_dash)
	await cooldown_timer.timeout
	puede_dashear = true

func _ready() -> void:
	cambiar_direccion_visual(Direccion_de_la_gravedad)

func _physics_process(_delta: float) -> void:
	# Mientras no se esté en dash se aplican las físicas y el movimiento normal
	if not dash:
		control_de_gravedad()
		control_del_suelo()
		control_de_movimiento()
	move_and_slide()
	control_de_animaciones()

func _input(_event: InputEvent) -> void:
	control_del_salto()
	# Si se presiona la tecla para dash y éste está disponible, se inicia
	if Input.is_action_just_pressed("ui_accept") and puede_dashear:
		control_del_dash()

"""Señales"""

func _on_coyote_timeout(): # Se le quita uno a saltos maximos al ya quedarse sin tiempo
	if saltos_restantes >= saltos_maximos:
		saltos_restantes -= 1

func _on_hitbox_body_entered(body):
	if body is Enemigo_basico: recibir_daño(body.daño)
