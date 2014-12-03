final  float len = 230;
final  float len2 = 80;
final  float maxAngle = radians(120);
final  int   numBones = 20; 
final  float thickness = 1;
final  float boneWidth = 3;

final  float speed = 0.9;

final  float farClip = 1000;

PImage textureImage;
PImage bgImage;

int counter;
void setup() {
  size(400, 300, P3D);
  textureImage = loadImage("hau.png");
  bgImage = loadImage("purty_wood.png");
  counter = 0;
  noStroke();
}

void draw() {
  randomSeed(0);
  background(0);
  if(textureImage.get(0,0) == 0 || bgImage.get(0,0) == 0) return;

  camera();
  
  beginShape();
  texture(bgImage);
  float focalLength = (0.5 * height) / tan(PI / 6.0);  // 焦点距離
  vertex( 0.5 * width * (1 - (abs(farClip) + focalLength) / focalLength) , 0.5 * height * (1 - (abs(farClip) + focalLength) / focalLength), -abs(farClip),             0,              0);
  vertex( 0.5 * width * (1 - (abs(farClip) + focalLength) / focalLength) , 0.5 * height * (1 + (abs(farClip) + focalLength) / focalLength), -abs(farClip),             0, bgImage.height);
  vertex( 0.5 * width * (1 + (abs(farClip) + focalLength) / focalLength) , 0.5 * height * (1 + (abs(farClip) + focalLength) / focalLength), -abs(farClip), bgImage.width, bgImage.height);
  vertex( 0.5 * width * (1 + (abs(farClip) + focalLength) / focalLength) , 0.5 * height * (1 - (abs(farClip) + focalLength) / focalLength), -abs(farClip), bgImage.width,              0);
  endShape(CLOSE);
  
  
  pushMatrix();
  noFill();
  
  translate(0.5 * width, 0.5 * (height - len), -30);
  rotateY(radians(frameCount) * 0.5);
  
  
  // 骨と骨の間の最大角度（固定値）
  float interspatial = (float)maxAngle / (numBones - 1);
  
  // 目標角度（補正前）
  float targetAngle = min(speed * radians(counter++), maxAngle);

  // 基準角度 
  float baseAngle = (int)(targetAngle / interspatial) * interspatial;
  
  // 骨と骨とがパタンと1回開くまでの、開き具合の割合
  float ratio = pow((targetAngle - baseAngle) / interspatial, 5);

  targetAngle = baseAngle + ratio * interspatial;
  
  for(int i = 0; i < numBones; ++i) {
    float z = thickness * (i - 0.5 * numBones);

    float angle = max(0, targetAngle - (numBones - (i + 1)) * interspatial) - 0.5 * targetAngle;

    pushMatrix();
    translate(0,  len);
    rotateZ(angle);
    translate(0, -len);

    beginShape(QUAD_STRIP);
    texture(textureImage);
    for(float coef : new float[] {0 , 1 }) {
      float theta = (coef - 0.5) * maxAngle / numBones;
      float textureAngle = maxAngle * ((i + coef) / numBones - 0.5);

      // 頂点座標（始点）
      float x, y;
      x = len2 * sin(theta);
      y = len - len2 * cos(theta);
      
      // テクスチャuv座標（始点）
      float u, v;
      u = 0.5 * textureImage.width * (1 + len2 * sin(textureAngle) / (len * sin(0.5 * maxAngle)));
      v = (len - len2 * cos(textureAngle)) * (float)textureImage.height / len;
      vertex(x, y, z, u, v);

      // 頂点座標（終点）
      x = len * sin(theta);
      y = len * (1 - cos(theta));
      
      // テクスチャuv座標（終点）
      u = 0.5 * textureImage.width * (1 + sin(textureAngle) / sin(0.5 * maxAngle));
      v = (1 - cos(textureAngle)) * (float)textureImage.height;
      vertex(x, y, z, u, v);
    }
    endShape();  
    popMatrix();
        
    // 骨
    lights();
    fill(100, 80, 0);
    pushMatrix();
    translate(0, len, z);
    rotateZ(angle);
    translate(0, -0.5 * len2, 0);
    box(boneWidth, len2, thickness);
    popMatrix();
    fill(255);
    noLights();
  }
  popMatrix(); 
}

