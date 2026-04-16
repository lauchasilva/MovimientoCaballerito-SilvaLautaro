extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -600.0
@onready var AREA_ATAQUE: CollisionShape2D = $AreaAtaque/CollisionShape2D
var GIRADO_DERECHA = true
@onready var COOLDOWN_ATAQUE: Timer = $TimerAtaque
@onready var CUERPO_PJ : CollisionShape2D = $Area2D/HitBoxPJ
var KNOCKBACK_FUERTE = 1000.0
var KNOCKBACK_DEBIL = 500.0
@onready var COOLDOWN_DANO_RECIBIDO: Timer = $TimerDanoRecibido
var SEGUNDO_SALTO_DISPONIBLE = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor():
		SEGUNDO_SALTO_DISPONIBLE = true
	# Handle jump.
	if Input.is_action_pressed("saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("saltar") and not is_on_floor():
		segundo_salto()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("izquierda", "derecha")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	mirar()
	if  Input.is_action_just_pressed("atacar"):
		atacar()


func mirar():
	if Input.is_action_just_pressed("derecha"):
		AREA_ATAQUE.position = Vector2 (68.0, 0)
		AREA_ATAQUE.rotation = 0
		GIRADO_DERECHA = true
	if Input.is_action_just_pressed("izquierda"):
		AREA_ATAQUE.position = Vector2 (-68.0, 0)
		AREA_ATAQUE.rotation = 0
		GIRADO_DERECHA = false
	if Input.is_action_just_pressed("saltar"):
		AREA_ATAQUE.position = Vector2 (0, -68.0)
		AREA_ATAQUE.rotation = 90.0
	if Input.is_action_just_pressed("abajo"):
		AREA_ATAQUE.position = Vector2 (0, 68.0)
		AREA_ATAQUE.rotation = 90.0
	if not Input.is_action_pressed("abajo") and not Input.is_action_pressed("saltar"):
		if GIRADO_DERECHA == true:
			AREA_ATAQUE.position = Vector2 (68.0, 0)
			AREA_ATAQUE.rotation = 0
		else:
			AREA_ATAQUE.position = Vector2 (-68.0, 0)
			AREA_ATAQUE.rotation = 0
	if not Input.is_action_pressed("izquierda") and not Input.is_action_pressed("derecha") and Input.is_action_pressed("abajo"):
		AREA_ATAQUE.position = Vector2 (0, 68.0)
		AREA_ATAQUE.rotation = 90.0
	if not Input.is_action_pressed("izquierda") and not Input.is_action_pressed("derecha") and Input.is_action_pressed("saltar"):
		AREA_ATAQUE.position = Vector2 (0, -68.0)
		AREA_ATAQUE.rotation = 90.0

func atacar():
	if COOLDOWN_ATAQUE.is_stopped():
		print("atacando")
		COOLDOWN_ATAQUE.start(0.3)
		var cuerpos = $AreaAtaque.get_overlapping_bodies()
		for body in cuerpos:
			if body.is_in_group("enemigos"):
				_on_area_ataque_body_entered(body)

func _on_area_ataque_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigos") and Input.is_action_just_pressed("atacar"):
		print("Enemigo Golpeado")
		var direccion = (global_position - body.global_position).normalized()
		direccion.y = direccion.y * 0.4
		velocity = direccion * KNOCKBACK_FUERTE
		move_and_slide() 

func _on_cuerpo_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigos") and COOLDOWN_DANO_RECIBIDO.is_stopped():
		var direccion = (global_position - body.global_position).normalized()
		direccion.y = direccion.y * 0.4
		velocity = direccion * KNOCKBACK_DEBIL
		move_and_slide()
		COOLDOWN_DANO_RECIBIDO.start(1.0)
		

func segundo_salto():
	if SEGUNDO_SALTO_DISPONIBLE:
		velocity.y = JUMP_VELOCITY *0.5
		SEGUNDO_SALTO_DISPONIBLE = false
	else:
		SEGUNDO_SALTO_DISPONIBLE = false
