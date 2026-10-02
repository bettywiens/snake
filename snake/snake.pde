int spielfeldBreite = 600;
int spielfeldHoehe = 800;

int spielfeldGröße = 20;
int spielfeldSkalierung = spielfeldBreite / spielfeldGröße;
int maximaleSpielerGröße = 100;
int dimension = 2;
int leeresFeldGröße = spielfeldSkalierung;
int spielerFeldGröße = spielfeldSkalierung;
int beuteFeldGröße = spielfeldSkalierung;
float maximaleTickZeit = 0.1;

int[][] spielfeld;
int[][] spielerPosition;
int[] beutePosition;

int spielerGröße; // wie viele Punkte der Körper hat
String richtung;
String letzteRichtung;
float tickZeit = 0;
float alleTicks = 0;
float beuteTicks = 0;
int highscore = 0;

void setup(){
  size(600, 600);
  rectMode(CENTER);
  imageMode(CENTER);
  spielfeld = new int[spielfeldGröße][spielfeldGröße];
  spielerPosition = new int[maximaleSpielerGröße][dimension]; // positionsGröße sind zwei Elemente, da wir x und y Richtung haben
  beutePosition = new int[dimension];
  
  resetGame();
}

void draw(){
  background(0);
  text("Highscore: " + highscore, 10, 10);
  tickZeit += 0.5/frameRate; // relativ genaue Zahl, die zeigt wie viele Sekunden vergangen sind
  if(tickZeit > maximaleTickZeit){
    bewegeSpieler();
    beuteTicks = testeSpielerKollision(); // Wenn auf Beute getroffen wird wird Geschwindigkeit erhöht
    if (beuteTicks > 0){ // Wenn Beute gefangen wird, wird der highscore erhöht
     highscore++;
    }
    alleTicks += beuteTicks; // Erhöhte Geschwindigkeit wird hinzugerechnet
    setzeSpielfeldZurück();
    zeichneSpielfigurenAufSpielfeld();
    tickZeit = alleTicks; // tickZeit auf neue TickZeit setzen
  }
  
  zeichneSpielfeld();
  setzeSpielerEingabe();
}

void bewegeSpieler(){
  int altePositionX = spielerPosition[0][0];
  int altePositionY = spielerPosition[0][1];
  
  if (keyPressed) {
    if(richtung.equals("up")){
      spielerPosition[0][1] -= 1; // y-Wert wird kleiner
      letzteRichtung = "up";
    } else if(richtung.equals("down")){
      spielerPosition[0][1] += 1; // y-Wert wird größer
      letzteRichtung = "down";
    } else if(richtung.equals("left")){
      spielerPosition[0][0] -= 1; // x-Wert wird kleiner
      letzteRichtung = "left";
    } else if(richtung.equals("right")){
      spielerPosition[0][0] += 1; // x-Wert wird größer
      letzteRichtung = "right";
    }
  }
  
  // Alle anderen Körperpunkte nachschieben
  for(int p = 1; p < spielerGröße; p++){ // p ist das aktuelle Element
    int kopfPositionX = spielerPosition[p][0];
    int kopfPositionY = spielerPosition[p][1];
    
    spielerPosition[p][0] = altePositionX;
    spielerPosition[p][1] = altePositionY;
    
    altePositionX = kopfPositionX;
    altePositionY = kopfPositionY;
  }

  
}

void setzeSpielfeldZurück(){
  for(int i = 0; i < spielfeldGröße; i++){
    for(int j = 0; j < spielfeldGröße; j++){
      spielfeld[i][j] = 0;
    }
  }
}

void zeichneSpielfeld(){
  PImage image;
  image = loadImage("C:/Users/bwiens/Documents/GitHub/PacMan/PacMan/data/images/environment/coin_1.png");
  for(int i = 1; i < spielfeldGröße; i++){
    for(int j = 1; j < spielfeldGröße; j++){
      if(spielfeld[i][j] == 0){
        image(image, spielfeldSkalierung * i, spielfeldSkalierung * j, spielerFeldGröße, spielerFeldGröße);
      }
      if(spielfeld[i][j] == 1){
        fill(0,255,0);
        ellipse(spielfeldSkalierung * i, spielfeldSkalierung * j, spielerFeldGröße, spielerFeldGröße);
        fill(255,255,255);
      }
      if(spielfeld[i][j] == 2){
        fill(255,255,0);
        rect(spielfeldSkalierung * i, spielfeldSkalierung * j, beuteFeldGröße, beuteFeldGröße);
        fill(255,255,255);
      }
    }
  }
}

void zeichneSpielfigurenAufSpielfeld(){
  // Zeichne Spieler
  // Mit der for-Schleife iterieren wir durch die Körperteile des Spielers
  for(int p = 0; p < maximaleSpielerGröße; p++){
    if(spielerPosition[p][0] != 0 && spielerPosition[p][1] != 0){
      spielfeld[spielerPosition[p][0]][spielerPosition[p][1]] = 1;
    }
  }
  
  // Zeichne Beute
  spielfeld[beutePosition[0]][beutePosition[1]] = 2;
}

void setzeZufälligBeutePosition(){
  beutePosition[0] = floor(random(1, spielfeldGröße));
  beutePosition[1] = floor(random(1, spielfeldGröße));
  
  for(int p = 0; p < spielerGröße; p++){
    if(beutePosition[0] == spielerPosition[p][0] || beutePosition[1] == spielerPosition[p][1]){
      setzeZufälligBeutePosition();
    }
  }
}

void setzeSpielerEingabe(){
  //int zufallszahl = floor(random(1,4));
  
  if (keyPressed) {
    if(keyCode == UP){
      richtung = "up";
    }
    if(keyCode == DOWN){
      richtung = "down";
    }
    if(keyCode == RIGHT){
      richtung = "right";
    }
    if(keyCode == LEFT){
      richtung = "left";
    }  
  }
  
}

float testeSpielerKollision(){
  float ticks = 0;
  // Wenn Spieler in sich selber fährt
  for(int p = 1; p < spielerGröße; p++){
    if(spielerPosition[0][0] == spielerPosition[p][0] && spielerPosition[0][1] == spielerPosition[p][1]){ // x und y Position muss mit x und y Position des anderen Körperpunktes übereinstimmen
      resetGame();
    }
  }
  
  // Wenn Spieler auf Beute trifft bekommt er einen neuen Punkt und eine neue Beute wird generiert
  if(spielerPosition[0][0] == beutePosition[0] && spielerPosition[0][1] == beutePosition[1]){
    spielerGröße++;
    //spielerPosition[spielerGröße - 1][0] = beutePosition[0];
    //spielerPosition[spielerGröße - 1][1] = beutePosition[1];
    setzeZufälligBeutePosition(); // Beute neu setzen, nachdem sie gefressen wurde
    ticks = 0.5/frameRate;
  }
  
  // Wenn Spieler aus dem Spielfeld fährt:
  if(spielerPosition[0][0] < 1){ // Wenn Spieler links rausfährt
    spielerPosition[0][0] = spielfeldGröße - 1;
  } else if(spielerPosition[0][0] > (spielfeldGröße - 1)){ // Wenn Spieler rechts rausfährt
    spielerPosition[0][0] = 1;
  } else if(spielerPosition[0][1] < 1){ // Wenn Spieler oben rausfährt
    spielerPosition[0][1] = spielfeldGröße - 1; 
  } else if(spielerPosition[0][1] > (spielfeldGröße - 1)){ // Wenn Spieler unten rausfährt
    spielerPosition[0][1] = 1;
  }
  
  return ticks;
}

void resetGame(){
  setzeZufälligBeutePosition();
  
  // setze Spieler Kopf
  spielerPosition[0][0] = spielfeldGröße/2;
  spielerPosition[0][1] = spielfeldGröße/2;
  // Spieler Rest
  for(int p = 1; p < maximaleSpielerGröße; p++){
    spielerPosition[p][0] = 0;
    spielerPosition[p][1] = 0;
  }
  // Spieler-Größe
  spielerGröße = 1;
  
  // Richtung
  richtung = "up";
  letzteRichtung = "up";
  
}
