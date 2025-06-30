@tool
## Classe utilitária para lidar com direções 2D.
extends RefCounted

class_name Direction2D

## Um array de vetores representando as quatro direções cardinais (Cima, Direita, Baixo, Esquerda).
static var direcoesCardinais: Array[Vector2i] = [
	Vector2i(0, 1), #CIMA
	Vector2i(1, 0), #DIREITA
	Vector2i(0, -1), #BAIXO
	Vector2i(-1, 0) #ESQUERDA
]

## Retorna uma direção cardinal aleatória do array 'direcoesCardinais'.
static func getRandomCardinalDirection() -> Vector2i:
	return direcoesCardinais[randi_range(0, direcoesCardinais.size() - 1)]
	
