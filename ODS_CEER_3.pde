import KinectPV2.KJoint;
import KinectPV2.*;
import java.util.Date;
 
String[] imageNames;
int i=0;

 
float derecha_ext = -0.50;
float izquierda_ext= 1.2;

float abajo_ext= 0.1;
float arriba_ext= 0.5;

PImage[] ods_logo;
PImage[] ods_fondo;
int curImg = 0;
PImage tower;
PGraphics pg;

int num = 30;

int foto = 0;
boolean cambiar_foto;
boolean crecer;
float umbral_cambio = 0.90;
circulo[] circulos = new circulo[num];  

int aux;
boolean activar_foto;
KinectPV2 kinect;
long tiempo_muestra; 
PImage Logo_CEER;
PImage Obj_OMS;
PVector pos_mano;
boolean skeleto;

void setup() 
{
    String path = "data/ods/";
    String path2 = "data/ods_img/";
    
    File[] files = listFiles(path);
    ods_logo = new PImage[files.length];
    println("Cantidad:"+files.length);
    for (int i = 0; i < files.length; i++) 
    {
      File f = files[i];    
      //println("Name: " + f.getName());
      //println("-----------------------"); 
      ods_logo[i] = loadImage(path+f.getName());
   } 
   File[] files_2 = listFiles(path2);
    ods_fondo = new PImage[files_2.length];
    println("Cantidad:"+files_2.length);
    for (int i = 0; i < files_2.length; i++) 
    {
      File f = files_2[i];    
      //println("Name: " + f.getName());
      //println("-----------------------"); 
      ods_fondo[i] = loadImage(path2+f.getName());
   } 
  
  kinect = new KinectPV2(this);
  kinect.enableColorImg(true);
    //enable 3d  with (x,y,z) position
  kinect.enableSkeleton3DMap(true);
  kinect.init();
    
    Logo_CEER = loadImage("CEER.png");
    Obj_OMS = loadImage("Obj.png");
    
   
     size(displayWidth, displayHeight,P2D);
   //size(800, 600,P2D);
    pg = createGraphics( width, height, P2D);    
    crecer = false;
        
  for (int a=0; a<ods_logo.length; a++)
  {
    ods_logo[a].resize(400,400);    
  }
 
   Logo_CEER.resize(260,107);
   Obj_OMS.resize(250,250);;
    
  for (int a=0; a<ods_fondo.length; a++)
  {
    ods_fondo[a].resize(width,height);    
  }
  
  for(int a=0; a<circulos.length-1; a++)
  {
   circulos[a] = new circulo(mouseX, mouseY);
  }
  activar_foto = true;
  aux = 30;
 }
 
void draw() 
{
  //background(ods_logo[foto]);
  background(ods_fondo[foto]);
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();
 
  pg.beginDraw();
  pg.background(0);
  pg.smooth();
  pg.endDraw();

  for (int i = 0; i < skeletonArray.size(); i++) 
  {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(0);
    if (skeleton.isTracked()) 
    {
      if(skeleto == false)
      {
      skeleto = true;
      crecer = true;
      }
      KJoint[] joints = skeleton.getJoints();
      //drawHandState(joints[KinectPV2.JointType_HandRight]);
      float x_kinect = map(joints[KinectPV2.JointType_HandRight].getX(),derecha_ext, izquierda_ext, 0, displayWidth);
      float y_kinect = map(joints[KinectPV2.JointType_HandRight].getY(),abajo_ext, arriba_ext, displayHeight,0);
      pos_mano = new PVector(int(x_kinect), int(y_kinect));
      println("X: "+pos_mano.x+"_Y: "+pos_mano.y);
      println("X_1: "+joints[KinectPV2.JointType_HandRight].getX()+"_Y_1: "+joints[KinectPV2.JointType_HandRight].getY()); 
    }
    if(!skeleton.isTracked()) 
    {
      skeleto = false;
      crecer = false;
    }
  }

 tower= ods_fondo[foto+1].get(0,0,width,height);
 tower.loadPixels();
  
   if(crecer)
    {
    for(int b=0; b<circulos.length-1; b++)
    {    
      //println(b);
      //println(skeleto);
      circulos[b].crecer();
      circulos[b].display();
    }
    }
  if(frameCount%15 == 0)
      {
  //    //println(cantidad_luz()); 
      if(cantidad_luz() > umbral_cambio)
      {
       cambiar_foto = true;
       activar_foto=true;
       aux = 30;
       tiempo_muestra = millis();
       } 
     }
      
  funcion_cambiar_pixeles();
  tower.updatePixels();
  image(tower, 0, 0);
    if(activar_foto)
  {
     
     dibujar_logo(foto,aux,(1-cantidad_luz()));
     if(aux > 0) 
     {
       crecer = false;
       //activar_foto = false;
       aux--;
     }
   else
   {
      if((millis()-tiempo_muestra)>9000) 
       {crecer = true;}
   }
   }
 if(crecer)
 {
   fill(0,255,0);
   noStroke();
   ellipse(10,height-15,15,15);
    
 }
} 
void mousePressed() 
{
 if(mousePressed){
 crecer = true;
 }
}

void funcion_cambiar_pixeles()
{
    if(frameCount%2 == 0)
    {
      if(skeleto)
      {
      circulos[circulos.length-1] = new circulo(int(pos_mano.x),int(pos_mano.y));
      circulos[circulos.length-1].display();
      for(int a=0; a<circulos.length-1; a++)
      {
      circulos[a] = circulos[a+1];
      }
      }
    }   
  if (cambiar_foto)
  {
   foto++;
   for(int b=0; b<circulos.length-1; b++)
    {    
      circulos[b].reset();//Aqui cambio-----------
    }
    
     if(foto == ods_fondo.length-1 )
     {
       foto = 0;
     }
    if(skeleto)
     {
     for(int a=0; a<circulos.length-1; a++)
        {
         circulos[a] = new circulo(int(pos_mano.x),int(pos_mano.y)); 
        }
     }
  }
 
  cambiar_foto = false; 
  tower.mask(pg.get()); // This is the magic.
}          


float cantidad_luz(){
    float pixelBrightness;
    int threshold = 10; // Set the threshold value
    int cantidad= 0;
   pg.loadPixels();
   for (int i = 0; i <   pg.pixels.length; i++) {
      pixelBrightness = brightness(pg.pixels[i]);
      if (pixelBrightness > threshold) { // If the pixel is brighter than the
        cantidad++; // threshold value, make it white
      } 
    }
    return (cantidad/(pg.pixels.length/1.0));
   //return (pg.pixels.length);
}
void keyPressed() {
  if (key >= 'e' ) {
   exit();
  }
}

void dibujar_logo(int aux_foto, int val, float alpha)
{
pushMatrix();
scale(.7+val/2.5);
tint(255,alpha*255);
image(ods_logo[aux_foto],0,0);
popMatrix();
if(val <10)
{
 // scale(1);
  image(Logo_CEER,displayWidth-266,displayHeight-120);
}
tint(255,255);
}
