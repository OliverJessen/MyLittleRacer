//populationSize: Hvor mange "controllere" der genereres, controller = bil & hjerne & sensorer
int       populationSize  = 100;
float[]   bedsteWeights   = {0, 0, 0, 0, 0, 0, 0, 0};
float[]   bedsteBiases    = {0, 0, 0};
int       generation      = 1;

//CarSystem: Indholder en population af "controllere"
CarSystem carSystem       = new CarSystem(populationSize);

//trackImage: RacerBanen , Vejen=sort, Udenfor=hvid, Målstreg= 100%grøn
PImage    trackImage;

void setup() {
  size(1000, 1200);
  trackImage = loadImage("track.png");
}

void draw() {
  clear();
  background(255);
  image(trackImage, 0, 80);

  carSystem.updateAndDisplay();

  push();
  fill(0);
  textSize(20);
  text("Population size: " + populationSize + "\n" + "generation: " + generation + "\n" + "framecount: " + frameCount + "\n" +
    "weights: " + bedsteWeights, width/2 + 50, 60);
  pop();

  if (frameCount%500==0) {
    nextGeneration();
  }
}


void nextGeneration() {

  int bestCar = 0;

  for (int i = carSystem.CarControllerList.size() -1; i >= 0; i--) {
    SensorSystem s = carSystem.CarControllerList.get(i).sensorSystem;
    NeuralNetwork n = carSystem.CarControllerList.get(i).hjerne;

    if (s.whiteSensorFrameCount == 0 && s.clockWiseRotationFrameCounter > 10 && s.lastGreenDetection == true) {

      bestCar = i;
    }

    if (i == bestCar) {
      bedsteBiases = n.biases;
      bedsteWeights = n.weights;
    }
  }

  generation += 1;
  carSystem = new CarSystem(populationSize);
}


// Pseudokode for den genetiske algoritme

/* Denne genetiske algortime skal kunne gøre et par ting. Den skal helst som følgende:
 
 - Kunne identificere den bedste racerbil ud fra nogle værdier, såsom:
 * Antallet af gange den er udenfor banen.
 * Hvor meget den roterer rundt om centrum, anti-klokkevis.
 * hvor hurtigt den kan køre banen rundt.
 
 - Gemme på dens weights og biases ved at lave en pladsholder og sætte pladsholderen som de nye weights og biases.
 
 - Lave en ny 'generation' af biler ud fra disse weights og biases, og have en mindre varians for hver generation.
 
 - Gentage processen når en bil kører over slutlinjen eller når der er gået 300 frames.
 
 Hvis algoritmen har alle disse ting, vil den kunne køre uendeligt indtil den har den bedste racerbil.
 
 */
