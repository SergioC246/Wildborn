extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ESCENA_HOGUERA = preload("res://hoguera.tscn")
const COSTE_HOGUERA = {"madera": 5, "piedra": 3}

const HAMBRE_CARNE_CRUDA = 10
const DANO_CARNE_CRUDA = 10
const HAMBRE_CARNE_ASADA = 40

const NOMBRES = {
	"madera": "Madera",
	"piedra": "Piedra",
	"carne_cruda": "Carne cruda",
	"carne_asada": "Carne asada",
}

@export var vida_maxima: float = 100.0
@export var hambre_maxima: float = 100.0
@export var velocidad_hambre: float = 2.0
@export var dano_por_hambre: float = 5.0

var inventario = {}
var vida: float
var hambre: float
var posicion_inicial: Vector3

@onready var texto_ayuda = $CanvasLayer/ContadorMadera
@onready var barra_vida = $CanvasLayer/BarraVida
@onready var barra_hambre = $CanvasLayer/BarraHambre
@onready var panel_inventario = $CanvasLayer/Inventario
@onready var casillas = $CanvasLayer/Inventario/VBoxContainer/Casillas


func _ready() -> void:
	posicion_inicial = global_position
	vida = vida_maxima
	hambre = hambre_maxima
	barra_vida.max_value = vida_maxima
	barra_hambre.max_value = hambre_maxima
	texto_ayuda.text = "TAB: Inventario"
	panel_inventario.visible = false
	actualizar_barras()
	actualizar_inventario_ui()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("construir"):
		construir_hoguera()
	if Input.is_action_just_pressed("comer"):
		comer_carne()
	if Input.is_action_just_pressed("inventario"):
		panel_inventario.visible = not panel_inventario.visible
	actualizar_supervivencia(delta)


func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Salto
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimiento
	var input_dir := Input.get_vector("mover_izquierda", "mover_derecha", "mover_adelante", "mover_atras")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


# ---------- INVENTARIO ----------

func cantidad_de(item: String) -> int:
	return inventario.get(item, 0)


func agregar_item(item: String, cantidad: int) -> void:
	inventario[item] = cantidad_de(item) + cantidad
	actualizar_inventario_ui()


func quitar_item(item: String, cantidad: int) -> void:
	inventario[item] = cantidad_de(item) - cantidad
	if inventario[item] <= 0:
		inventario.erase(item)
	actualizar_inventario_ui()


func actualizar_inventario_ui() -> void:
	for hijo in casillas.get_children():
		casillas.remove_child(hijo)
		hijo.queue_free()

	if inventario.is_empty():
		var vacio = Label.new()
		vacio.text = "Vacío"
		casillas.add_child(vacio)
		return

	for item in inventario:
		var casilla = PanelContainer.new()
		casilla.custom_minimum_size = Vector2(110, 80)
		var etiqueta = Label.new()
		etiqueta.text = NOMBRES.get(item, item) + "\n" + str(inventario[item])
		etiqueta.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		etiqueta.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		casilla.add_child(etiqueta)
		casillas.add_child(casilla)


# ---------- SUPERVIVENCIA ----------

func actualizar_supervivencia(delta: float) -> void:
	hambre = max(hambre - velocidad_hambre * delta, 0.0)
	if hambre <= 0.0:
		vida = max(vida - dano_por_hambre * delta, 0.0)
	actualizar_barras()
	if vida <= 0.0:
		morir()


func morir() -> void:
	print("Has muerto. Pierdes todo lo que llevabas.")
	inventario.clear()
	vida = vida_maxima
	hambre = hambre_maxima
	global_position = posicion_inicial
	velocity = Vector3.ZERO
	actualizar_barras()
	actualizar_inventario_ui()


func actualizar_barras() -> void:
	barra_vida.value = vida
	barra_hambre.value = hambre


func agregar_recurso(tipo: String, cantidad: int) -> void:
	if tipo == "bayas":
		comer(cantidad)
	else:
		agregar_item(tipo, cantidad)


func comer(cantidad: int) -> void:
	hambre = min(hambre + cantidad, hambre_maxima)
	actualizar_barras()


func comer_carne() -> void:
	if cantidad_de("carne_asada") > 0:
		quitar_item("carne_asada", 1)
		comer(HAMBRE_CARNE_ASADA)
		print("¡Carne asada! Deliciosa.")
	elif cantidad_de("carne_cruda") > 0:
		quitar_item("carne_cruda", 1)
		comer(HAMBRE_CARNE_CRUDA)
		vida = max(vida - DANO_CARNE_CRUDA, 0.0)
		actualizar_barras()
		print("Carne cruda... te sienta mal.")
	else:
		print("No tienes carne.")


func cocinar_carne() -> void:
	if cantidad_de("carne_cruda") > 0:
		quitar_item("carne_cruda", 1)
		agregar_item("carne_asada", 1)
		print("Has asado un trozo de carne.")
	else:
		print("No tienes carne cruda para cocinar.")


# ---------- CONSTRUCCIÓN ----------

func tiene_materiales(coste: Dictionary) -> bool:
	for item in coste:
		if cantidad_de(item) < coste[item]:
			return false
	return true


func construir_hoguera() -> void:
	if not tiene_materiales(COSTE_HOGUERA):
		print("Necesitas: ", COSTE_HOGUERA)
		return

	for item in COSTE_HOGUERA:
		quitar_item(item, COSTE_HOGUERA[item])

	var hoguera = ESCENA_HOGUERA.instantiate()
	get_parent().add_child(hoguera)
	hoguera.global_position = global_position + Vector3(0, 0, -2)
	print("¡Hoguera construida!")
