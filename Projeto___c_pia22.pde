//.................................................... Variaveis
PImage Bricks;
PImage Metal;
PImage Water;
// -----------------------PECAPONTE
int w=150;                     //comprimento da primitiva cuboLDM
int h =150;                    //altura da primitiva cuboLDM
int d = 150;                   //profundidade da primitiva cuboLDM

int MargemC = 10;              //margem da face com curva da primitiva cuboLDM
float angInc=0;
// -----------------------CILINDRO
float topY = -200;             //altura do cilindro
float baseRadius = 50;         //raio do círculo da base
int segments = 100;            //número de vértices para desenhar as laterais


// -----------------------VARIAVÉIS PARA A INTERAÇÃO
boolean interact=false;
float INC=0;
float ROT=0;
float INCY=0;

// ------------------------CAMARA
float ang=0;

// ------------------------MOVIMENTO ÀGUA

float mov=0;

// ------------------------DIRECTION LIGHT COLORS
color red=255;
color green=200;
color blue=100;
//-----------------------------------------------------------------------------------
//                                   INICIALIZAÇÃO
//-----------------------------------------------------------------------------------
void settings() {
  smooth(8);
  pixelDensity(displayDensity());
  size(800, 800, P3D);
}

void setup() {
  colorMode(RGB, 255, 255, 255);
  Bricks=loadImage("Bricks.jpg");
  Metal=loadImage("metal.jpg");
  Water=loadImage("water.jpg");
}

//-----------------------------------------------------------------------------------
//                                   PRIMITIVAS
//-----------------------------------------------------------------------------------


//----------------                  CUBO LDM             -----------------------
void pecaponte(float r, float r2, float textureInicial, float textureFinal) {
  int halfW = w/3;
  int halfH = h/2;
  int halfD = d/2;
  int resolucaoArco = 20;
 materialGeneric(0.8, 0.8, 0.8,   // Cor ambiente (escuro)
                  0.001, 0.001, 0.001,   // Cor difusa (clara)
                  0.05, 0.05, 0.05,         // Cor especular (preto)
                  0.1);  

  textureMode(IMAGE);
  beginShape(QUADS);
  // Lado Cima (Y=-h)
  texture(Bricks);
  vertex(-halfW, -halfH, +halfD, textureInicial, textureInicial);
  vertex(+halfW, -halfH, +halfD, textureFinal, textureInicial);
  vertex(+halfW, -halfH, -halfD, textureFinal, textureFinal);
  vertex(-halfW, -halfH, -halfD, textureInicial, textureFinal);
  endShape(CLOSE);
  // Lado Baixo (Y=h)
  beginShape(QUADS);
  // texture(Bricks);
  vertex(-halfW, halfH, halfD);
  vertex(halfW-r, halfH, halfD);
  vertex(halfW-r, halfH, -halfD);
  vertex(-halfW, halfH, -halfD);

  endShape(CLOSE);
  // Lado direito (X=w)
  beginShape(QUADS);
  // texture(Bricks);
  vertex(halfW, -halfH, halfD);
  vertex(halfW, halfH-r2, halfD);
  vertex(halfW, halfH-r2, -halfD);
  vertex(halfW, -halfH, -halfD);
  endShape(CLOSE);
  // Lado esquerdo (X=-w)
  beginShape(QUADS);
  texture(Bricks);
  vertex(-halfW, -halfH, halfD, textureInicial, textureInicial);
  vertex(-halfW, -halfH, -halfD, textureFinal, textureInicial);
  vertex(-halfW, halfH, -halfD, textureFinal, textureFinal);
  vertex(-halfW, halfH, halfD, textureInicial, textureFinal);
  endShape(CLOSE);

  angInc = PI/2.0/resolucaoArco;
  beginShape();
  texture(Bricks);
  textureMode(NORMAL);

  // Frente (Z=d)
  for (int i = 0; i < resolucaoArco; i++) {

    float x = halfW + r * cos(PI + angInc * i);
    float y = halfH + r2 * sin(PI + angInc * i);

    float s = cos(PI+ angInc * i)*(r/150);
    float t = sin(PI+ angInc * i)*(r2/150);
    vertex(x, y, halfD, s+1, t+1);
  }
  vertex(halfW, halfH-r2, halfD, 1, 1-r2/150);
  vertex(halfW, -halfH, halfD, 1, 0);
  vertex(-halfW, -halfH, halfD, 0, 0);
  vertex(-halfW, halfH, halfD, 0, 1);
  endShape(CLOSE);

  // Tras (Z=-d)
  // Tras (Z=-d)
  beginShape();
  texture(Bricks); 
  for(int i = 0; i < resolucaoArco; i++){

      float x = halfW + r * cos(PI + angInc * i);
    float y = halfH + r2 * sin(PI + angInc * i);
  
  float s = cos(PI+ angInc * i)*(r/150);
  float t = sin(PI+ angInc * i)*(r2/150);
    vertex(x, y, -halfD, s+1,t+1);
    
  }
  vertex(halfW, halfH-r2, -halfD, 1, 1-r2/150);
  vertex(halfW, -halfH, -halfD, 1, 0);
  vertex(-halfW, -halfH, -halfD,0, 0);
  vertex(-halfW, halfH, -halfD,0, 1);
  endShape(CLOSE);
  

  textureMode(NORMAL);
  beginShape(QUADS);
  texture(Bricks);
  for (int i = 0; i < resolucaoArco; i++) {
    float u0 = map(i, 0, resolucaoArco, 0, 1); // Coordenada de textura para o início do arco
    float u1 = map(i + 1, 0, resolucaoArco, 0, 1); // Coordenada de textura para o final do arco

    // Cálculo das coordenadas x e y para o arco
    float x0 = halfW + r * cos(PI + angInc * i);
    float y0 = halfH + r2 * sin(PI + angInc * i);
    float x1 = halfW + r * cos(PI + angInc * (i + 1));
    float y1 = halfH + r2 * sin(PI + angInc * (i + 1));

    // Adicionando os vértices com as coordenadas de textura
    vertex(x0, y0, halfD, u0, 1);
    vertex(x1, y1, halfD, u1, 1);
    vertex(x1, y1, -halfD, u1, 0);
    vertex(x0, y0, -halfD, u0, 0);
  }
  endShape(CLOSE);
}
void ponte() {
  pecaponte(80, 140, 0, w);
  pushMatrix();
  translate(2*w/3, 0);
  rotateY(PI);
  pecaponte(80, 140, w, 2*w);
  popMatrix();
}


//----------------                  CILINDRO             -----------------------

void Cilindro(float numREP) {
  // BASE
  materialGeneric(0.3000, 0.3000, 0.3000, 0.01000, 0.01000, 0.01000, 0.633, 0.727811, 0.633, 0.6);
  textureWrap(REPEAT);
  textureMode(NORMAL);
  beginShape();
  texture(Metal);
  for (int i = 0; i < segments; i++) {
    float angle = map(i, 0, segments, 0, TWO_PI);
    float x = baseRadius * cos(angle);
    float y =  baseRadius * sin(0);     //seno a 0 para o círculo ficar paralelo ao eixo Z
    float z =  baseRadius * sin(angle);

    // Mapear as coordenadas de textura
    float u = map(x, -baseRadius, baseRadius, 0, 1); // Normalizar 'x' para o intervalo [0, 1]
    float v = map(z, -baseRadius, baseRadius, 0, 1); // Normalizar 'z' para o intervalo [0, 1]


    vertex(x, y, z, u, v);
  }
  endShape(CLOSE);

  // TOPO
  beginShape();
  texture(Metal);
  for (int i = 0; i < segments; i++) {
    float angle = map(i, 0, segments, 0, TWO_PI);
    float x =  baseRadius * cos(angle);
    float y =  topY;
    float z =  baseRadius * sin(angle);

    // Mapear as coordenadas de textura
    float u = map(x, -baseRadius, baseRadius, 0, 1); // Normalizar 'x' para o intervalo [0, 1]
    float v = map(z, -baseRadius, baseRadius, 0, 1); // Normalizar 'z' para o intervalo [0, 1]

    vertex(x, y, z, u, v);
  }
  endShape(CLOSE);

  // LATERAIS
  beginShape(TRIANGLE_STRIP);    //liga os vértices aos anteriores
  texture(Metal);
  for (int i = 0; i <= segments; i++) {
    float angle = map(i, 0, segments, 0, TWO_PI);
    float x1 =  baseRadius * cos(angle);
    float y1 =  baseRadius * sin(0);

    float y2 = topY + baseRadius * sin(0);
    float z2 =  baseRadius * sin(angle);

    float u = map(i, 0, segments, 0, 1);
    vertex(x1, y1, z2, u*numREP, 1*numREP);
    vertex(x1, y2, z2, u*numREP, 0);
  }
  endShape();
}
//----------------                  PLANO DE FUNDO   -----------------------
void quadrado(PImage img) {

 materialGeneric(0.3000, 0.3000, 0.3000, 0.01000, 0.01000, 0.01000, 0.633, 0.727811, 0.633, 0.6);
  int halfW = w/3;
  int halfH = h/2;
  int halfD = d/2;
  float size=150;
  textureWrap(REPEAT);
  textureMode(IMAGE);
  beginShape(QUADS);
  //topo
  texture(img);
  vertex(-halfW, -halfH, halfD, 0, 0);
  vertex(halfW, -halfH, halfD, size, 0);
  vertex(halfW, -halfH, -halfD, size, size);
  vertex(-halfW, -halfH, -halfD, 0, size);
  endShape();
  //fundo
  beginShape(QUADS);
  texture(img);
  vertex(-halfW, halfH, halfD, 0, 0);
  vertex(halfW, halfH, halfD, size, 0);
  vertex(halfW, halfH, -halfD, size, size);
  vertex(-halfW, halfH, -halfD, 0, size);
  endShape();

  //esquerdo
  beginShape(QUADS);
  texture(img);
  vertex(-halfW, -halfH, halfD, 0, 0);
  vertex(-halfW, halfH, halfD, 0, size);
  vertex(-halfW, halfH, -halfD, size, size);
  vertex(-halfW, -halfH, -halfD, size, 0);
  endShape();
  // Lado Direito (X=w)
  beginShape(QUADS);
  texture(img);
  vertex(halfW, -halfH, halfD, 0, 0);
  vertex(halfW, halfH, halfD, 0, size);
  vertex(halfW, halfH, -halfD, size, size);
  vertex(halfW, -halfH, -halfD, size, 0);
  endShape();

  //tras

  beginShape(QUADS);
  texture(img);
  vertex(-halfW, -halfH, -halfD, 0, 0);
  vertex(-halfW, halfH, -halfD, 0, size);
  vertex(halfW, halfH, -halfD, size, size);
  vertex(halfW, -halfH, -halfD, size, 0);
  endShape();

  //frente
  beginShape(QUADS);
  texture(img);
  vertex(halfW, -halfH, halfD, 0, 0);
  vertex(halfW, halfH, halfD, 0, size);
  vertex(-halfW, halfH, halfD, size, size);
  vertex(-halfW, -halfH, halfD, size, 0);
  endShape();
}
//----------------                  CARRO            -----------------------
void carro() {
  int halfW = w / 2;
  int halfD = d / 2;

  fill(0);
  pushMatrix();
  translate(0, -50, 0);
  tint(255, 0, 0);
  quadrado(Metal);
  noTint();
  //-----------------RODAS
  popMatrix();
  fill(125);
  pushMatrix();
  scale(0.8, 0.9, 0.3);
  rotateX(PI/2);
  for (int i = 0; i < 4; i++) {
    pushMatrix();
    if (i==0) {
      translate(halfW, (halfD/2 + topY), (halfD + topY/2));
    } else if (i==1) {
      translate(halfW, -(halfD/2 + 2*topY), (halfD + topY/2));
    } else if (i==2) {
      translate(-halfW/2, (halfD/2 + topY), (halfD + topY/2));
    } else {
      translate(-halfW/2, -(halfD/2 + 2*topY), (halfD + topY/2));
    }
    Cilindro(1);
    popMatrix();
  }
  popMatrix();
}

//-----------------MALHA POLIGONAL

void rectanguloComMalha(float w, float h, float res) {
  materialGeneric(0.05, 0.05, 0.05, 0.5, 0.5, 0.5, 0.7, 0.7, 0.7, .078125);
  textureMode(NORMAL);
  textureWrap(REPEAT);
  pushMatrix();
  translate(-w/2, -h/2, 0);
  beginShape(QUADS);
  texture(Water);
  for (int i = 0; i < res; i++) { // para cada linha (x)
    for (int j = 0; j < res; j++) { // para cada coluna (y)
      float u0 = i / res;
      float v0 = j / res;
      float u1 = (i + 1) / res;
      float v1 = (j + 1) / res;

      vertex(i/res*w, j/res*h, 0, u0, v0);
      vertex(i/res*w, (j+1)/res*h, 0, u0, v1);
      vertex((i+1)/res*w, (j+1)/res*h, 0, u1, v1);
      vertex((i+1)/res*w, j/res*h, 0, u1, v0);
    }
  }
  endShape(CLOSE);
  popMatrix();
}

//-----------------------------------------------------------------------------------
//                                   DESENHO
//-----------------------------------------------------------------------------------
void draw() {
    background(200, 130, 10);
  mov+=5;
  noStroke();
  //---------CAMARA E PERSPETIVA
  if (mousePressed) {
    ortho();
  } else {
    perspective(PI/3, width/float(height), 100, 10000);
  }

  // ang+=0.01;
  if (keyPressed) {
    if (keyCode==LEFT) {
      ang+=0.01;
    }

    if (keyCode==RIGHT) {
      ang-=0.01;
    }
  }
  ang+=0.01;
  camera(1000*cos(ang), -h*2, 1000*sin(ang), 0, -h/2, 0, 0, 1, 0);
  ambientLight(80, 80, 80);
  lightSpecular(255, 255, 255);
  directionalLight(constrain(red,0,255), constrain(green,0,255), constrain(blue,0,255), 0.5, 0.5, -1);
  specular(255, 255, 255);

 translate(-w,0);
  pushMatrix();
  translate(-w/3 + (w/2*0.3) + INC, -h/2 - (0.20*h/2) + INCY, 0); //y=-metade do y do cubo - metado do y do cubo a multiplicar pela escala
  rotate(ROT);
  fill(255,0,0);
  pointLight(200, 0, 0, 0, 0, 0);      //luz do carro
  popMatrix();
  //-----------INTERAÇÃO DO CARRO
  if (interact & INC<=5*w/2) {
    INC+=2;
  }

  if (INC>=5*w/2 & INCY<=h) {
    INC+=1.5;
    INCY+=3;
    ROT+=PI/25;
  }

  fill(100);
  ambient(255);


  pushMatrix();
  translate(w/2+(2*w/3), h/2+(h/2*0.1), 0); //(h/2*0.1) corresponde a escala do quadrado
  scale(7, 0.1, 7);
  //quadrado(Water,1050, 15, mov);

  popMatrix();

  pushMatrix();
  noFill();
  // stroke(0);
  translate(w/2+(2*w/3), h/2, 0);
  scale(7, 0.1, 7);
  rotateZ(PI/2);
  rotateY(PI/2);
  rectanguloComMalha(w, h, 20);
  popMatrix();

  fill(#926246);

  //CUBO
  ponte();
  pushMatrix();
  translate(w+w/3, 0, 0);
  ponte();
  popMatrix();
  //CILINDROS VERTICAIS
  materialGeneric(0.25, 0.20725, 0.20725, 1, 0.829, 0.829, 0.296648, 0.296648, 0.296648, 0.088);
  noStroke();
  pushMatrix();
  scale(0.1, 0.25, 0.1);
  fill(60);
  for (int i = 0; i <= 13; i++) {
    pushMatrix();
    if (i>6) {
      translate((-2*w)+(i-7)*(4*w), -h+(topY/2), 4*-d); //-4*w serve para o primeiro ficar na margem esquerda e posiconamento; i-7 é para as medidas serem iguais de frente e de trás; o outro é o espaçamento entre eles
    } else {
      translate((-2*w)+(i*(4*w)), -h+(topY/2), 4*d);
    }
    Cilindro(1);
    popMatrix();
  }
  popMatrix();

  //CILINDRO HORIZONTAL
  for (int i = 0; i < 2; i++) {
    pushMatrix();
    if (i==1) {
      translate(-w/3, topY/2, d/2-15);        //margem de 15 no z para não ficar tão junto à borda da ponte
    } else {
      translate(-w/3, topY/2, -d/2+15);
    }
    rotate(PI/2);
    scale(0.1, 2, 0.1);
    Cilindro(2);

    popMatrix();
  }

  //----------CARRO
  fill(125, 67, 78);
  pushMatrix();
  translate(-w/3 + (w/2*0.3) + INC, -h/2 - (0.15*h/2) + INCY, 0); //y=-metade do y do cubo - metado do y do cubo a multiplicar pela escala
  rotate(ROT);
  pushMatrix();
  scale(0.3, 0.2, 0.2);
  carro();
  popMatrix();
  popMatrix();

  println(" Red: " + red + " Green: " + green + " Blue: " + blue);
}

//-----------------------------------------------------------------------------------
//-------------------------------------------------------------------- INTERACCAO
//-----------------------------------------------------------------------------------
void keyPressed() {
  if (key=='a' || key=='A')
    if (interact==false) {
      interact=true;
    } else {
    interact=false;
  }

  if (key=='g' || key=='G') {
    if(green<255) green+=5;
  }
  
    if (key=='h' || key=='H') {
    if(green>0) green-=5;
  }
  
    if (key=='R' || key=='r') {
    if(red<255) red+=5;
  }
  
    if (key=='T' || key=='t') {
    if(red>0) red-=5;
  }
  
    if (key=='B' || key=='b') {
    if(blue<255) blue+=5;
  }
  
    if (key=='N' || key=='n') {
    if(blue>0) blue-=5;
  }
}

//MATERIAIS
void materialGeneric(float ar, float ag, float ab,
  float dr, float dg, float db,
  float sr, float sg, float sb, float sh) {
  ambient(ar*255, ag*255, ab*255);
  fill(dr*255, dg*255, db*255);
  specular(sr*255, sg*255, sb*255);
  shininess(sh*125);
}
