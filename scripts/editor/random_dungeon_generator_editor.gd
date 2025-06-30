@tool
## Ferramenta de editor para acionar a geração de masmorras.
class_name DungeonGenerationEditor
extends Node

## Referência ao nó gerador de masmorra que será executado.
@export var dungeon_generator: RandomWalkGeneration
## Marque esta caixa para acionar a geração da masmorra.
@export var executar_geracao: bool = false : set = _set_executar_geracao

@export_category("Ações do Editor")
## Função chamada quando a propriedade 'executar_geracao' é modificada no editor.
func _set_executar_geracao(value):
	if value:
		if is_instance_valid(dungeon_generator):
			dungeon_generator.runProceduralGeneration()
		else:
			push_error("Gerador de dungeon não atribuido no script do editor.")
		executar_geracao = false
