@tool
## Recurso que armazena os parâmetros para o algoritmo Simple Random Walk.
class_name RandomWalkData
extends Resource

## Número de vezes que o algoritmo de caminhada aleatória será executado.
@export var iterations: int = 10
## O comprimento de cada caminhada aleatória.
@export var walkLength: int = 10
## Se verdadeiro, cada nova iteração começará de uma posição aleatória no caminho já criado.
@export var startRandomly: bool = true

## Construtor que permite criar e configurar o objeto a nível de código.
func _init(p_iterations: int = 10, p_walk_length: int = 10, p_start_randomly: bool = true):
	iterations = p_iterations
	walkLength = p_walk_length
	startRandomly = p_start_randomly
