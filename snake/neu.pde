class MapLoader {
  MapLoader(int[][] spielfeld) {
    String[] lines = loadStrings("C:/Users/bwiens/Documents/GitHub/PacMan/PacMan/data/map/map.txt");

    for (int i = 0; i < lines.length; i++) {
      char[] characters = lines[i].toCharArray();
      for (int j = 0; j < characters.length; j++) {
        char character = characters[j];

        if (character == 'P') {
          world_objects.add(new Player(j, i, PLAYER_SPEED));
        } else if (character == '#') {
          world_objects.add(new Wall(j, i));
        } else if (character == '.') {
          world_objects.add(0, new Coin(j, i));
        } else if (character == 'E') {
          world_objects.add(new Enemy(j, i, ENEMY_SPEED));
        }
      }
    }
  }
}
