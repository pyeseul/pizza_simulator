ArrayList<Student> students;
ArrayList<Pizza> pizzas;

void setup() {
  size(800, 800, P2D);
  students = new ArrayList();
  pizzas = new ArrayList();
}

int pizzaCounter = 0;

void draw() {
  background(200);
  stroke(0);
  noFill();
  
  // if a pizza doesn't have any slices, remove the pizza from the pizzas arraylist
  if(pizzaCounter>(pizzas.size()-1)){
    pizzaCounter = 0;
  } else {
    if(pizzas.get(pizzaCounter).slices == 0){
      pizzas.remove(pizzaCounter);
    }
    pizzaCounter++;
  }

  // if there are one or more pizzas with slices in the pizzas arraylist, run update() and draw()
  if(pizzas.size() > 0) {
    for (Pizza p : pizzas) {
      if (p.slices > 0) {
        p.draw();
      }     
    }
  }

  // if there are one or more students, itereate through the students
  if(students.size() > 0){
    for (Student s : students) {

      // if there's more then a pizza, get a pizza to move towards 
      if(pizzas.size() > 0){
        s.getNewDog();

        // if the pizza has slices, move towards the pizza
        if(pizzas.get(s.topDog).slices > 0){
          s.seek(pizzas.get(s.topDog));
        }

        // run separate() to prevent students from colliding with other students or pizzas
        s.separate(students, pizzas);
      }

      // run borders() so students bounce off when they touch the walls
      s.borders();

      // run update() and draw() for each student
      s.update(students);
      s.draw();
    }
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    students.add(new Student(mouseX, mouseY, 15.0));
  }
  if (mouseButton == RIGHT) {
    pizzas.add(new Pizza(mouseX, mouseY));
  }
}

void keyPressed() {
  switch(key) {
  case 'r':
    reset();
    break;
  case 'p':
    pizzas.add(new Pizza(mouseX, mouseY));
    break;
  }
}

void reset() {
  students.clear();
  pizzas.clear();
  println("resetting everything");
}