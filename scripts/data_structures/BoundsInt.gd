# BoundsInt.gd
# Uma estrutura que representa um AABB (Axis-Aligned Bounding Box) usando inteiros.
# Equivalente ao BoundsInt da Unity.
class_name BoundsInt
extends RefCounted

var position: Vector3i
var size: Vector3i

# Construtor para inicializar com uma posição e tamanho.
func _init(p_position: Vector3i, p_size: Vector3i):
	self.position = p_position
	self.size = p_size

# O ponto mínimo do cubo (geralmente a própria posição).
var min: Vector3i:
	get: return position

# O ponto máximo do cubo (posição + tamanho).
# Note que a região inclui o 'min' mas exclui o 'max'.
var max: Vector3i:
	get: return position + size

# Propriedade para obter o centro do cubo (pode ser float).
var center: Vector3:
	get: return Vector3(position) + (Vector3(size) / 2.0)

# Verifica se um ponto (Vector3i) está dentro dos limites do cubo.
func contains(point: Vector3i) -> bool:
	return (point.x >= min.x and point.x < max.x and
			point.y >= min.y and point.y < max.y and
			point.z >= min.z and point.z < max.z)

# Retorna um array com todas as posições de coordenadas inteiras dentro do cubo.
# Muito útil para iterar sobre cada "célula" do grid.
func all_positions_within() -> Array[Vector3i]:
	var positions: Array[Vector3i] = []
	for z in range(min.z, max.z):
		for y in range(min.y, max.y):
			for x in range(min.x, max.x):
				positions.append(Vector3i(x, y, z))
	return positions

# Função estática para criar um BoundsInt a partir de um ponto mínimo e máximo.
static func from_min_max(p_min: Vector3i, p_max: Vector3i) -> BoundsInt:
	var size = p_max - p_min
	return BoundsInt.new(p_min, size)

func _to_string() -> String:
	return "BoundsInt(Pos: %s, Size: %s)" % [position, size]
