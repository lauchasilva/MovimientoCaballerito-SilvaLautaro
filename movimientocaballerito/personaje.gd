extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
var PUEDE_PEGAR = true
var PEGANDO = false
@onready var AREA_ATAQUE: CollisionShape2D = $AreaAtaque/CollisionShape2D
var GIRADO_DERECHA = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY
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

func atacar():
	pass
