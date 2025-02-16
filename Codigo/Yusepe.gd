extends CharacterBody2D

class_name Yusepe

"""Propiedades"""

@onready var colision : CollisionShape2D = $CollisionShape2D
@onready var sprite_animado : AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote : Timer = $Temporizadores/Coyote

@export_category("Fisicas") #Todas las propiedades relacionadas a las fisicas 
@export var velocidad : float = 200.0
@export var gravedad : float = 9.81
@export var multiplicador_de_velocidad : float = 1.0
@export var multiplicador_de_gravedad : float = 1.0
@export var fuerza_de_salto : float = 300.0
@export_enum("Abajo", "Arriba", "Izquierda", "Derecha") var Direccion_de_la_gravedad : int = 0
@export_range(0,1) var friccion : float = 1.0

@export_category("Control")
@export var saltos_maximos : int = 2
@export var tiempo_de_coyote : float = 0.15

"""Propiedades de Dash"""
@export_category("Dash")
@export var puede_dashear : bool = true       # Indica si se puede iniciar el dash
@export var dash : bool = false         # Estado actual del dash (en curso o no)
@export var fuerza_del_dash : float = 400.0  # Fuerza que se aplica al dash
@export var duracion_del_dash : float = 0.2 # Tiempo (en segundos) que dura el dash
@export var cooldown_del_dash : float = 1.0   # Cooldown del dash en segundos

var saltos_restantes : int
var en_suelo : bool = false


"""Métodos"""

func get_axis() -> Vector2:
	var axis : Vector2 = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	return axis

func control_de_gravedad() -> void:
	match Direccion_de_la_gravedad:
		0: velocity.y += gravedad * multiplicador_de_gravedad  # Abajo
		1: velocity.y -= gravedad * multiplicador_de_gravedad  # Arriba
		2: velocity.x -= gravedad * multiplicador_de_gravedad  # Izquierda
		3: velocity.x += gravedad * multiplicador_de_gravedad  # Derecha

func control_de_movimiento() -> void:
	match Direccion_de_la_gravedad:
		0:
			if get_axis().x != 0:
				velocity.x = get_axis().x * (velocidad * multiplicador_de_velocidad)
			elif friccion > 0:
				velocity.x = lerp(velocity.x, 0.0, friccion)
		1:
			if get_axis().x != 0:
				velocity.x = -get_axis().x * (velocidad * multiplicador_de_velocidad)
			elif friccion > 0:
				velocity.x = lerp(velocity.x, 0.0, friccion)
		2:
			if get_axis().x != 0:
				velocity.y = get_axis().x * (velocidad * multiplicador_de_velocidad)
			elif friccion > 0:
				velocity.y = lerp(velocity.y, 0.0, friccion)
		3:
			if get_axis().x != 0:
				velocity.y = -get_axis().x * (velocidad * multiplicador_de_velocidad)
			elif friccion > 0:
				velocity.y = lerp(velocity.y, 0.0, friccion)
	move_and_slide()

func control_del_suelo() -> void:
	match Direccion_de_la_gravedad:
		0: en_suelo = is_on_floor()
		1: en_suelo = is_on_ceiling()
		2, 3: en_suelo = is_on_wall()
	if en_suelo:
		saltos_restantes = saltos_maximos
		# Eliminamos la reinicialización inmediata de canDash para respetar el cooldown
	if not en_suelo:
		if saltos_restantes == saltos_maximos and coyote.is_stopped():
			coyote.start(tiempo_de_coyote)

func control_del_salto() -> void:
	if Input.is_action_just_pressed("Saltar") and saltos_restantes > 0: # Acción de saltar
		saltos_restantes -= 1
		match Direccion_de_la_gravedad:
			0: velocity.y = -fuerza_de_salto  # Saltar hacia arriba
			1: velocity.y = fuerza_de_salto   # Saltar hacia abajo
			2: velocity.x = fuerza_de_salto   # Saltar hacia la derecha
			3: velocity.x = -fuerza_de_salto  # Saltar hacia la izquierda
	elif Input.is_action_just_released("Saltar"): # Salto regulado
		match Direccion_de_la_gravedad:
			0: if velocity.y < 0: velocity.y /= 2  # Cancelar salto hacia arriba
			1: if velocity.y > 0: velocity.y /= 2  # Cancelar salto hacia abajo
			2: if velocity.x > 0: velocity.x /= 2  # Cancelar salto hacia derecha
			3: if velocity.x < 0: velocity.x /= 2  # Cancelar salto hacia izquierda

func cambiar_direccion_visual(direccion: int = 0) -> void:
	match direccion:
		0: rotation_degrees = 0    # Abajo
		1: rotation_degrees = 180  # Arriba
		2: rotation_degrees = 90   # Izquierda
		3: rotation_degrees = -90  # Derecha


func control_de_animaciones() -> void:
	if get_axis().x != 0 and en_suelo == true:
		sprite_animado.play("Caminando")
		sprite_animado.scale.x = get_axis().x
	else:
		sprite_animado.play("Quieto")

# Función que inicia el dash según la gravedad activa con cooldown de 1 segundo
func control_del_dash() -> void:
	var direccion_del_dash = sprite_animado.scale.x
	dash = true
	puede_dashear = false
	match Direccion_de_la_gravedad:
		0:# En gravedad vertical, el dash se realiza en el eje X
			velocity.x = direccion_del_dash * fuerza_del_dash
		1:
			velocity.x -= direccion_del_dash * fuerza_del_dash
		2:# En gravedad horizontal, el dash se realiza en el eje Y utilizando el valor de entrada (get_axis().x)
			velocity.y = direccion_del_dash * fuerza_del_dash
		3: 
			velocity.y -= direccion_del_dash * fuerza_del_dash
	var aux = get_tree().create_timer(duracion_del_dash)
	await aux.timeout
	dash = false
	# Inicia el cooldown de 1 segundo para reactivar el dash
	var cooldown_timer = get_tree().create_timer(cooldown_del_dash)
	await cooldown_timer.timeout
	puede_dashear = true

func _ready() -> void:
	cambiar_direccion_visual(Direccion_de_la_gravedad)
	en_suelo = false

func _physics_process(_delta: float) -> void:
	# Mientras no se esté en dash se aplican las físicas y el movimiento normal
	if not dash:
		control_de_gravedad()
		control_del_suelo()
		control_de_movimiento()
	else:
		# Durante el dash, se mueve con la velocidad actual sin modificarla
		move_and_slide()
	control_de_animaciones()

func _input(_event: InputEvent) -> void:
	control_del_salto()
	# Si se presiona la tecla para dash y éste está disponible, se inicia
	if Input.is_action_just_pressed("ui_accept") and puede_dashear:
		control_del_dash()

"""Señales"""
func _on_coyote_timeout():
	if saltos_restantes >= saltos_maximos:
		saltos_restantes -= 1

func _on_hitbox_body_entered(body):
	match body:
		Enemigo_basico: pass
		Trampa_basica: pass
		TileMap: pass

