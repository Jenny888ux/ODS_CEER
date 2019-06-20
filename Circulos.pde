float acel = 4;

class circulo {
  int x, y; // X-coordinate, y-coordinate
  int tamano; // Left and right angle offset
  float vel;
  
  // Constructor
  circulo(int xpos, int ypos) {
    x = xpos;
    y = ypos;
    tamano = 40;
    vel = 0;
  }
  
  void reset(){
  tamano = 40;
  }
  void crecer() {
   vel = vel + acel;
    if(tamano < displayHeight)
   {
    tamano+=int (vel);
    }
   }

 
 int devolver_x() {
   return (x);
   }
 

  void display() 
  {
    pg.beginDraw();
    pg.noStroke();
    pg.fill(255,40);
    //pg.fill(255);
    pg.pushMatrix();
    pg.translate(x, y);
    pg.ellipse(0,0,tamano*0.8,tamano);
    pg.popMatrix();
    pg.endDraw();
    
  }
}
