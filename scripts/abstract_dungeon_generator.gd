## Classe base abstrata para todos os algoritmos de geração de masmorras.
extends Node

class_name AbstractDungeonGenarator

## Referência ao TileMapVisualizer para desenhar a masmorra.
@export var tilemap_visualizer: TileMapVisualizer = null
## A posição inicial para a geração.
@export var posicao_inicial: Vector2i = Vector2i.ZERO

## Função pública principal para iniciar a geração da masmorra.
func gerar_dungeon() -> void:
	tilemap_visualizer.limpar_piso()
	run_procedural_generation()
	
	
## Função que deve ser sobrescrita por classes filhas para implementar a lógica de geração específica.
func run_procedural_generation() -> void:
	pass
