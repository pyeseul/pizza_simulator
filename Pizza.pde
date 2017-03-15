PImage pizzaImg;  // load pizzaimg

class Pizza extends PVector {
  int slices, sliceTotal;
  int toppings = 0;
  float size = 80;
  
  Pizza(float xPos, float yPos) {
    x = xPos;
    y = yPos;
    slices = sliceTotal = 8;
    pizzaImg = loadImage("pizzaa.png");
  }

  // decrease the number of slices for a pizza until the number becomes 0  
  void getSlice() {
    if (slices > 0) {      
      slices--;
    }
  }

  void draw() {
    
    // draw the pizzaimg
    noStroke();
    beginShape();
    texture(pizzaImg);
    vertex(x-75, y-75, 0, 0);
    vertex(x+75, y-75, 150, 0);
    vertex(x+75, y+75, 150, 150);
    vertex(x-75, y+75, 0, 150);     
    endShape();
    fill(200);

    // draw arc on the pizzaimg to pretend pizza being eaten
    arc(x, y, size*2, size*2, 0, radians(45*(sliceTotal-slices)), PIE);
  }
}