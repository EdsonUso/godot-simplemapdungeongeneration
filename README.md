# Godot Simple Map Dungeon Generation

This is an educational Godot project demonstrating various procedural dungeon generation algorithms. The project is intended to be a public resource for anyone interested in learning about procedural generation in game development.

## Algorithms Implemented

This project contains implementations of the following dungeon generation algorithms:

*   **Simple Random Walk:** A simple algorithm that creates cave-like structures by randomly carving out a map.
*   **Corridor-First Dungeon Generation:** An algorithm that starts by generating corridors and then adds rooms to them.

## How to Use

1.  Clone this repository.
2.  Open the project in the Godot Engine (version 4.4 or later).
3.  Open one of the demo scenes in the `scenes` folder to see the generation in action.

## Project Structure

*   `scenes/`: Contains the main scenes for demonstrating the different generation algorithms.
*   `scripts/`: Contains the GDScript code for the generation algorithms.
    *   `abstract_dungeon_generator.gd`: An abstract base class for dungeon generators.
    *   `simpleRandomWalkDungeonGeneration.gd`: Implementation of the Simple Random Walk algorithm.
    *   `corridor_first_dungeon_generator.gd`: Implementation of the Corridor-First algorithm.
*   `assets/`: Contains 3D models and other assets used in the project.

## Contributing

Since this is an educational project, contributions are welcome! Feel free to open an issue or submit a pull request if you have any improvements or new features to add.
