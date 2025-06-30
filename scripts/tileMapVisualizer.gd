@tool
## Responsável por desenhar o mapa de tiles gerado no TileMap.
class_name TileMapVisualizer
extends Node

## A camada do TileMap onde a masmorra será desenhada.
@export var tile_map_layer: TileMapLayer

## O ID da fonte do tile a ser usado para o chão.
@export var id_fonte_tile_chao: int = 0
@export var id_fonte_tile_wall: int = 1
## As coordenadas do atlas do tile a ser usado para o chão.
@export var coordenadas_atlas_tile_chao: Vector2i = Vector2i(7, 1)
@export var coordenadas_atlas_tile_wall: Vector2i = Vector2i(3, 0)

## Pinta os tiles do chão em um array de posições.
func paint_floor_tiles(posicoes_chao: Array[Vector2i]) -> void:
	if not is_instance_valid(tile_map_layer):
		push_error("Nó do Mapa de Tiles da Camada não atribuído ao Visualizador ou é inválido!")
		return

	for posicao in posicoes_chao:
		paint_single_tile(posicao, id_fonte_tile_chao, coordenadas_atlas_tile_chao)

## Pinta um único tile em uma coordenada específica do mapa.
func paint_single_tile(coordenadas_mapa: Vector2i, id_fonte_tile: int ,coordenadas_atlas_tile: Vector2i) -> void:
	tile_map_layer.set_cell(coordenadas_mapa, id_fonte_tile, coordenadas_atlas_tile)

## Limpa todos os tiles da camada do mapa.
func limpar_piso() -> void:
	if is_instance_valid(tile_map_layer):
		tile_map_layer.clear()
		

func paint_single_basic_wall(position: Vector2i):
	paint_single_tile(position, id_fonte_tile_wall, coordenadas_atlas_tile_wall)
