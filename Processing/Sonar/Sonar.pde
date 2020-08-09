////////////////////////////////////////////////////////////////////////////
//            ------ AutoCore Robótica -------         
//               Projeto: Sonar com HC-SR04            
//               Autor: Danilo Nogueira                
//               Data: 20/08/2018                      
///////////////////////////////////////////////////////////////////////////
// Aqui vou apenas explicar os principais comandos do programa a seguir
// Mas prometo fazer posts explicando cada comando utilizando aqui combinado?

import processing.serial.*;       // Importa as bibliotecas para comunicação de Serie
import java.awt.event.KeyEvent;   // Importa as bibliotecas para ler a informação da entrada de serie
import java.io.IOException;
Serial Porta_serial;             // Define o objeto Serial

// Definindo as variáveis
String angulo="";
String distancia="";
String dados="";
String noObject;

float pixsDistancia;
int iAngulo, iDistancia;

int index1=0;
int index2=0;

PFont orcFont;    // Variavel para configurar a fonte do radar

void setup() {
 
size (1355, 725); // Aqui é onde você coloca a resolução da sua tela
smooth();

// Aqui tem um detalhe importante:
// onde tem 'Serial.list()[0]', caso dê algum erro
// troque isso pela porta que se Arduino está tipo "COM3" ok?

Porta_serial = new Serial(this, "/dev/ttyUSB0", 9600);   // Começa a comunicação Serie
Porta_serial.bufferUntil('.');                             // Lê o Serial Monitor até ao ponto final (lembra do ponto que falamos no cód do Arduino?

orcFont = loadFont("ArialMT-48.vlw");   // Fonte utilizada no radar
}

void draw() {

// Desenha os efeitos do radar
fill(98,245,31);        //Aqui você coloca a cor (no caso é verde)
textFont(orcFont);

// Simula o movimento das linhas
noStroke();
fill(0,4);
rect(0, 0, width, height-height*0.065);
 
fill(98,245,31);


// Chama as funções Sonar, line, Object, Text
// Aqui é onde a mágica acontece
drawSonar();
drawLine();
drawObject();
drawText();
}

// Aqui vamos começar a ler a serial do Arduino
void serialEvent (Serial Porta_serial) {

//Lê a informação de Serie até ao caracter '.', esta informação é atribuida a uma string chamada "dados".
dados = Porta_serial.readStringUntil('.');
dados = dados.substring(0,dados.length()-1);
 
index1 = dados.indexOf(","); //
angulo= dados.substring(0, index1);
distancia= dados.substring(index1+1, dados.length());
 
// Converte as variaveis string em Integer
iAngulo = int(angulo);
iDistancia = int(distancia);
}
void drawSonar() {

  pushMatrix();
translate(width/2,height-height*0.074); // Move as coordenadas iniciais para outro local
noFill();
strokeWeight(2);
stroke(98,245,31);

// Desenha os semicirculos
  arc(0,0,(width-width*0.0625),(width-width*0.0625),PI,TWO_PI);
  arc(0,0,(width-width*0.27),(width-width*0.27),PI,TWO_PI);
  arc(0,0,(width-width*0.479),(width-width*0.479),PI,TWO_PI);
  arc(0,0,(width-width*0.687),(width-width*0.687),PI,TWO_PI);

// Desenha as linhas dos angulos
  line(-width/2,0,width/2,0);
  line(0,0,(-width/2)*cos(radians(30)),(-width/2)*sin(radians(30)));
  line(0,0,(-width/2)*cos(radians(60)),(-width/2)*sin(radians(60)));
  line(0,0,(-width/2)*cos(radians(90)),(-width/2)*sin(radians(90)));
  line(0,0,(-width/2)*cos(radians(120)),(-width/2)*sin(radians(120)));
  line(0,0,(-width/2)*cos(radians(150)),(-width/2)*sin(radians(150)));
  line((-width/2)*cos(radians(30)),0,width/2,0);
popMatrix();
}

void drawObject() {
pushMatrix();
translate(width/2,height-height*0.074); // Move as coordenadas iniciais para outro local
strokeWeight(9);
stroke(255,10,10);  // Caso algum objeto seja identificado desenha retangulos vermelhos

pixsDistancia = iDistancia*((height-height*0.1666)*0.025); // cobre a distancia entre o sensor e o objeto

// limite de faixa 40 cm, ou seja, se o objeto estiver a menos de 40 cm, ele aparece na tela.
if(iDistancia<40){

  // Desenha o objeto de acordo com a distancia e o angulo
line(pixsDistancia*cos(radians(iAngulo)),-pixsDistancia*sin(radians(iAngulo)),(width-width*0.505)*cos(radians(iAngulo)),-(width-width*0.505)*sin(radians(iAngulo)));
}
popMatrix();
}


void drawLine() {
pushMatrix();
strokeWeight(9);
stroke(30,250,60);

translate(width/2,height-height*0.074); // Move as coordenadas iniciais para outro local
line(0,0,(height-height*0.12)*cos(radians(iAngulo)),-(height-height*0.12)*sin(radians(iAngulo))); // Desenha a linha de acordo com o angulo
popMatrix();
}

// Aqui vamos criar os textos que aparecem na tela
void drawText() {
 
pushMatrix();
if(iDistancia>40) {
noObject = "Nenhum objeto no Sonar";
}
else {
noObject = "Objeto Detectado!";
}
fill(0,0,0);
noStroke();
rect(0, height-height*0.0648, width, height);
fill(98,245,31);
textSize(25);
 
text("10cm",width-width*0.3854,height-height*0.0833);
text("20cm",width-width*0.281,height-height*0.0833);
text("30cm",width-width*0.177,height-height*0.0833);
text("40cm",width-width*0.0729,height-height*0.0833);

textSize(40);
text("Objeto: " + noObject, width-width*0.960, height-height*0.0277);
text("Ângulo: " + iAngulo +" °", width-width*0.48, height-height*0.0277);
text("Distancia: ", width-width*0.30, height-height*0.0277);
if(iDistancia<40) {
text("          " + iDistancia +" cm", width-width*0.225, height-height*0.0277);
}
textSize(25);


fill(98,245,60);
translate((width-width*0.4994)+width/2*cos(radians(30)),(height-height*0.0907)-width/2*sin(radians(30)));
rotate(-radians(-60));
text("30°",0,0);
resetMatrix();

translate((width-width*0.503)+width/2*cos(radians(60)),(height-height*0.0888)-width/2*sin(radians(60)));
rotate(-radians(-30));
text("60°",0,0);
resetMatrix();

translate((width-width*0.507)+width/2*cos(radians(90)),(height-height*0.0833)-width/2*sin(radians(90)));
rotate(radians(0));
text("90°",0,0);
resetMatrix();

translate(width-width*0.513+width/2*cos(radians(120)),(height-height*0.07129)-width/2*sin(radians(120)));
rotate(radians(-30));
text("120°",0,0);
resetMatrix();

translate((width-width*0.5104)+width/2*cos(radians(150)),(height-height*0.0574)-width/2*sin(radians(150)));
rotate(radians(-60));
text("150°",0,0);
popMatrix();
}
