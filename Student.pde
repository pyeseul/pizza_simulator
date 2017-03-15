class Student extends PVector {
  float size;
  int eating = 0;
  int hunger = 2;
  int topDog = 0;
  int eatingTime = 200;
  boolean needNewDog = true;
  PVector velocity;
  PVector acceleration;
  float maxForce; 
  float maxSpeed;
  
  Student(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    maxSpeed = 4;
    maxForce = 0.5;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
  }

  void update(ArrayList<Student> studentList) {

    // while eating, do nothing but counting down the eating value
    if (eating > 0) {
      eating--;
    }
    // if not eating, 
    else {
      if(hunger <= 0){  // if a student is not hungry, 
        if(frameCount % 100 == 0)hunger++; // add hunger value by 1 every 100 frames so they become hungry again
      }
      // method to update position - from shiffman's seek implentation
      velocity.add(acceleration);
      velocity.limit(maxSpeed);
      this.add(velocity);
      acceleration.mult(0);
      
      if (pizzas.size() > 0 && this.hunger > 0) {
        if (pizzas.get(topDog).slices > 0) {  // if there are one or move pizza with slices and the student is hungry,
          if (pizzas.get(topDog).dist(this) < 80) {  // and if the student is close to topdog
            pizzas.get(topDog).getSlice();  // get a slice of the topdog
            this.hunger--;  // the student's hunger level goes down
            eating += eatingTime;  // eating time counter
          }
        }
      }
    }          
  }

    // applyforce(), seek(), draw(): calculates a steering force towards a target and display the position - based on seek implementation by shiffman
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  void seek(PVector target) {
    PVector desired = PVector.sub(target, this);
    desired.setMag(maxSpeed);
    PVector steer = PVector.sub(desired, this.velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }

  void draw() {
    fill(200, 0, 255, 255/(this.hunger+1));  // thicker color means they're more full
    noStroke();
    pushMatrix();
    translate(this.x, this.y);
    ellipse(0, 0, this.size/(this.hunger+1)*2, this.size/(this.hunger+1)*2);  // bigger means they're more full
    popMatrix();
  }

  // bounce off when a student touch the walls
  void borders() {
    if (this.x > width-this.size || this.x < this.size) {
      this.velocity.x *= -1;
    }
    if (this.y > height-this.size || this.y < this.size) {
      this.velocity.y *= -1;
    }
  }

  // find the closest pizza which has slices
  void getNewDog() {
    for (int i = 0; i < pizzas.size(); i++) {
      if (pizzas.get(i).slices >= 0) {
        topDog = i;
      }
    }
    float tmp = pizzas.get(topDog).dist(this);
    for (int j = 0; j < pizzas.size(); j++) {
      if(j == topDog){
        // do nothing 
      } else {
        if (pizzas.get(j).slices > 0) {
          if (tmp > pizzas.get(j).dist(this)) {
            topDog = j;
          }
        }
      }
    }
    needNewDog = false;
  }

  // students repel each other so they don't collide. pizzas repel students so they don't collide - separate implentation by shiffman
  void separate (ArrayList<Student> students, ArrayList<Pizza> pizzas) {
    PVector sum = new PVector();
    int count = 0;

    for (Student other : students) { 
      float desiredSeparation = other.size*2;
      float d = this.dist(other);
      
      if ((d > 0) && (d < desiredSeparation)) {
        PVector diff = PVector.sub(this, other);
        diff.normalize();
        diff.div(d);       
        sum.add(diff);
        count++;           
      }
      if (count > 0) {     
        sum.setMag(maxSpeed);
        PVector steer = PVector.sub(sum, velocity);
        steer.limit(maxForce);
        this.applyForce(steer);
      }
    }

    for (Pizza p : pizzas) {
      float d = this.dist(p);
      if ((d > 0) && (d < p.size)) {
        PVector diff = PVector.sub(this, p);
        diff.normalize();
        diff.div(d);       
        sum.add(diff);
        count++;           
      }

      if (count > 0) {     
        sum.setMag(maxSpeed);
        PVector steer = PVector.sub(sum, velocity);
        steer.limit(maxForce);
        this.applyForce(steer);
      }
    }    
  }
}