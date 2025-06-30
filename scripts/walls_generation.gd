extends Node

class_name WallGenerator

static func create_walls(floor_positions: Dictionary[Vector2i, bool], tilemap_visualizer: TileMapVisualizer) -> void:
	var posicao_muro_simples = find_walls_in_directions(floor_positions, Direction2D.direcoesCardinais)
	for position in posicao_muro_simples:
		tilemap_visualizer.paint_single_basic_wall(position)
		

static func find_walls_in_directions(floor_positions: Dictionary[Vector2i, bool], directions: Array[Vector2i]) -> Dictionary[Vector2i, bool]:
	var wall_positions: Dictionary[Vector2i, bool] = {}
	
	for position in floor_positions:
		for direction in directions:
			var vizinho := position + direction
			if not floor_positions.has(vizinho):
				wall_positions[vizinho] = true
				
	return wall_positions
