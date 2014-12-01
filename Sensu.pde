final  float len = 230;
final  float len2 = 80;
final  float maxAngle = radians(120);
final  int   numBone = 19; 
final  float thickness = 1;
final  float boneWidth = 5;

PImage img;

int counter;
void setup() {
  size(400, 300, P3D);
  
  img = loadImage("img.png");
  counter = 0;
}

void draw() {
  background(0);
  if(img.get(0,0) == 0) return;
  
  noFill();
  stroke(255);
  
  translate(0, 0, -100);
  translate( 0.5 * width, 0, 0);
  rotateY(0.5 * radians(frameCount));
  translate(-0.5 * width, 0, 0);
  
  translate(width / 2,0);
  
  pushMatrix();
  //translate(0, -0.5 * len, 0);
  for(int i = 0; i < numBone; ++i) {
    
    float z = thickness * (i - 0.5 * numBone);
    float angle = min(0.1 * radians(counter++), maxAngle) * ((float)i / numBone - 0.5);    

    pushMatrix();
    translate(0,  len);
    rotateZ(angle);
    translate(0, -len);

    beginShape(QUAD_STRIP);
    texture(img);
    for(float coef : new float[] { 0 , 1 }) {
      
      float textureAngle = -0.5 * maxAngle + ((i + coef) * (float)maxAngle) / numBone;
      float theta = (coef - 0.5) * maxAngle / numBone;

      float x, y, u, v;
      x = len2 * sin(theta);
      y = len - len2 * cos(theta);
      u = 0.5 * img.width + len2 * sin(textureAngle) * (float)img.width / (2 * len * sin(0.5 * maxAngle));
      v = (len - len2 * cos(textureAngle)) * (float)img.height / len;
      vertex(x, y, z, u, v);

      x = len * sin(theta);
      y = len * (1 - cos(theta));
      u = 0.5 * img.width + sin(textureAngle) * img.width / (2 * sin(0.5 * maxAngle));
      v = (1 - cos(textureAngle)) * (float)img.height;
      vertex(x, y, z, u, v);
    }
    
    endShape();  
    popMatrix();
    
    // Bone
    pushMatrix();
    translate(0, len, z);
    rotateZ(angle);
    translate(0, -0.5 * len2, 0);
    box(boneWidth, len2, thickness);
    popMatrix();

  }
  popMatrix(); 
}

