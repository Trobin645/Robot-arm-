import processing.serial.*;

Serial myPort;


float[] vals     = {90, 90, 90, 90, 90, 0};
float[] lastSent = {-1,-1,-1,-1,-1,-1};
float[] minV = {10,  15,  10,  10,  10,  0};
float[] maxV = {170, 165, 170, 170, 170, 90};
String[] names   = {"BASE","SHOULDER","ELBOW","WRIST","WRIST YAW","CLAW"};

String[] presetNames = {"WAVE","POUR","POINT","SHAKE"};
float[][] presets = {
  {90,  102,  78,  84, 87, 0}, 
  {130, 83 , 64,  10,  90, 0},  
  {90,  94,  50,  00, 90, 0},   
  {90,  97, 73,  10,  90, 45}   
};
float[] pX=new float[4], pY=new float[4], pW=new float[4], pH=new float[4];
boolean[] pOver = new boolean[4];

boolean demoRunning   = false;
int     demoStep      = 0;
int     demoTimer     = 0;
int     demoHold      = 1800;
float[] demoStart     = new float[6];
float[] demoTarget    = new float[6];
int     demoLerpMs    = 800;
int     demoLerpStart = 0;
float   dBX, dBY, dBW, dBH;
boolean dOver = false;

boolean emergencyStop = false;
boolean serialConnected = false;

int dragIdx = -1;


float SW, SH, SX, SY0, SGAP;
float PANEL_X, PANEL_W;


color C_BG     = color(14,14,18);
color C_TRACK  = color(32,32,40);
color C_FILL   = color(0,160,230);
color C_THUMB  = color(235,240,255);
color C_LABEL  = color(140,150,175);
color C_VAL    = color(210,220,255);
color C_ACCENT = color(0,190,255);
color C_PANEL  = color(22,24,32);
color C_BORDER = color(48,52,68);


float[] bX=new float[5], bY=new float[5], bW=new float[5], bH=new float[5];
String[] bLabel = {"HOME","UPRIGHT","STOP","PICK","RELEASE"};
color[] bBg  = {color(38,40,55),color(38,40,55),color(155,22,22),
                color(18,75,35),color(85,68,10)};
color[] bHov = {color(55,58,80),color(55,58,80),color(200,38,38),
                color(28,125,55),color(145,118,18)};
boolean[] bOver = new boolean[5];

PFont F_LBL, F_VAL, F_HEAD, F_SUB, F_BTN, F_SMALL;

void settings() { fullScreen(); }

void setup() {
  try { 
    myPort =  new Serial(this, "COM5", 115200);
    serialConnected = true;
  }
  catch (Exception e) { 
    println("No serial - preview mode");
    serialConnected = false;
  }

  F_LBL  = createFont("Arial Bold", 22);
  F_VAL  = createFont("Arial", 20);
  F_HEAD = createFont("Arial Black", 52);
  F_SUB  = createFont("Arial Bold", 18);
  F_BTN  = createFont("Arial Bold", 17);
  F_SMALL = createFont("Arial Bold", 14);
}


void draw() {
  background(C_BG);
  calcLayout();
  drawHeader();
  updateDemo();
  drawPresetButtons();
  drawDemoButton();
  drawConnectionStatus();
  drawPanel();
  drawAllSliders();
  drawButtons();
  drawEmergency();
  if (!emergencyStop) sendIfChanged();
}

void updateDemo() {
  if (!demoRunning) return;
  int now = millis();
  int elapsed = now - demoLerpStart;
  if (elapsed < demoLerpMs) {
    float t = easeInOut(elapsed / float(demoLerpMs));
    for (int i=0;i<6;i++) vals[i] = lerp(demoStart[i], demoTarget[i], t);
  } else {
    for (int i=0;i<6;i++) vals[i] = demoTarget[i];
    if (now - demoTimer > demoHold) {
      demoStep = (demoStep+1) % presets.length;
      for (int i=0;i<6;i++) demoStart[i]  = vals[i];
      for (int i=0;i<6;i++) demoTarget[i] = presets[demoStep][i];
      demoLerpStart = millis();
      demoTimer     = millis();
    }
  }
}

float easeInOut(float t) {
  return t < 0.5 ? 2*t*t : -1+(4-2*t)*t;
}

void drawPresetButtons() {
  for (int i=0;i<4;i++) {
    float rr = pH[i]*0.4;
    noStroke(); fill(0,80);
    rect(pX[i]+2, pY[i]+3, pW[i], pH[i], rr);
    color bg  = pOver[i] ? color(0,130,200) : color(20,50,80);
    color brd = pOver[i] ? C_ACCENT : color(0,100,160);
    fill(bg); stroke(brd); strokeWeight(1.4);
    rect(pX[i], pY[i], pW[i], pH[i], rr);
    noStroke(); fill(255); textFont(F_BTN);
    textAlign(CENTER,CENTER); textSize(height*0.017);
    text(presetNames[i], pX[i]+pW[i]*0.5, pY[i]+pH[i]*0.5);
  }
}

void drawDemoButton() {
  float rr = dBH*0.4;
  noStroke(); fill(0,80);
  rect(dBX+2, dBY+3, dBW, dBH, rr);
  color bg  = demoRunning ? color(180,100,0) : (dOver ? color(60,160,60) : color(20,80,20));
  color brd = demoRunning ? color(255,160,0) : (dOver ? color(80,220,80) : color(40,140,40));
  fill(bg); stroke(brd); strokeWeight(1.5);
  rect(dBX, dBY, dBW, dBH, rr);
  if (demoRunning) {
    float pulse = 0.5+0.5*sin(millis()*0.008);
    noStroke(); fill(255,180,0,int(200*pulse));
    ellipse(dBX+dBH*0.7, dBY+dBH*0.5, dBH*0.35, dBH*0.35);
  }
  noStroke(); fill(255); textFont(F_BTN);
  textAlign(CENTER,CENTER); textSize(height*0.019);
  text(demoRunning ? "STOP DEMO" : "DEMO SEQ", dBX+dBW*0.5, dBY+dBH*0.5);
  // Current pose name while running
  if (demoRunning) {
    fill(C_ACCENT); textFont(F_BTN);
    textAlign(CENTER,TOP); textSize(height*0.015);
    text("► " + presetNames[demoStep], dBX+dBW*0.5, dBY+dBH+6);
  }
}

void calcLayout() {
  SW      = width  * 0.38;
  SH      = height * 0.044;
  SX      = width  * 0.36;
  SY0     = height * 0.175;
  SGAP    = height * 0.098;
  PANEL_X = width  * 0.042;
  PANEL_W = width  * 0.225;

  float gap     = width  * 0.018;
  float centerX = width  * 0.5;

  
  float sbw = SW * 0.14;
  float cy2 = SY0 + SGAP * 5;
  bX[4]=SX-sbw-14;  bY[4]=cy2; bW[4]=sbw; bH[4]=SH;
  bX[3]=SX+SW+14;   bY[3]=cy2; bW[3]=sbw; bH[3]=SH;

  
  float btnAreaY = SY0 + SGAP*5 + SH + 45;
  float pw = width*0.095, ph = height*0.052;
  float presetsW = 4*pw + 3*gap;
  float presetsX = centerX - presetsW*0.5;
  for (int i=0;i<4;i++) {
    pX[i] = presetsX + i*(pw+gap);
    pY[i] = btnAreaY;
    pW[i] = pw;
    pH[i] = ph;
  }

  
  dBW = width*0.18; dBH = height*0.052;
  dBX = centerX - dBW*0.5;
  dBY = btnAreaY + ph + gap;

  float bw = width*0.095, bh = height*0.052;
  float by = dBY + dBH + gap;
  bX[0]=centerX-bw*1.5-gap; bY[0]=by; bW[0]=bw; bH[0]=bh;
  bX[1]=centerX-bw*0.5;     bY[1]=by; bW[1]=bw; bH[1]=bh;
  bX[2]=centerX+bw*0.5+gap; bY[2]=by; bW[2]=bw; bH[2]=bh;
}

   

void drawConnectionStatus() {
  float cx = width*0.93, cy = height*0.073;
  float r  = height*0.018;
  if (serialConnected) {
    float pulse = 0.5 + 0.5*sin(millis()*0.004);
    noStroke(); fill(0, 220, 80, int(40*pulse));
    ellipse(cx, cy, r*4, r*4);
    noStroke(); fill(0, 220, 80);
    ellipse(cx, cy, r*1.5, r*1.5);
    textFont(F_SMALL); fill(0, 220, 80);
    textAlign(RIGHT, CENTER); textSize(height*0.016);
    text("CONNECTED", cx - r*1.4, cy);
  } else {
    noStroke(); fill(220, 50, 50);
    ellipse(cx, cy, r*1.5, r*1.5);
    textFont(F_SMALL); fill(220, 50, 50);
    textAlign(RIGHT, CENTER); textSize(height*0.016);
    text("NO SERIAL", cx - r*1.4, cy);
  }
}

void drawHeader() {
  stroke(C_ACCENT,55); strokeWeight(1);
  line(width*0.04, height*0.12, width*0.96, height*0.12);

  textFont(F_HEAD); textAlign(CENTER,CENTER);
  fill(C_ACCENT,28); textSize(height*0.050);
  text("6 DOF ROBOT ARM CONTROL", width*0.5+3, height*0.073+3);
  fill(C_ACCENT); textSize(height*0.050);
  text("6 DOF ROBOT ARM CONTROL", width*0.5, height*0.073);

  textFont(F_SUB); fill(C_LABEL); textSize(height*0.018);
  text("REAL-TIME SERVO INTERFACE", width*0.5, height*0.108);
}

void drawPanel() {
  float py=height*0.155, ph=height*0.62, pr=22;
  noStroke(); fill(0,90); rect(PANEL_X+5,py+7,PANEL_W,ph,pr);
  fill(C_PANEL); stroke(C_BORDER); strokeWeight(1.2); rect(PANEL_X,py,PANEL_W,ph,pr);
  noStroke(); fill(C_ACCENT,20); rect(PANEL_X,py,PANEL_W,height*0.052,pr,pr,0,0);

  textFont(F_SUB); fill(C_ACCENT,190); textAlign(CENTER,CENTER); textSize(height*0.019);
  text("LIVE ANGLES", PANEL_X+PANEL_W*0.5, py+height*0.026);

  String[] rn={"Base","Shoulder","Elbow","Wrist","Wrist Yaw","Claw"};
  float rowH=(ph-height*0.065)/6.0, sy=py+height*0.065;
  for (int i=0;i<6;i++) {
    float ry=sy+i*rowH;
    if (i>0) { stroke(C_BORDER); strokeWeight(0.7); line(PANEL_X+16,ry,PANEL_X+PANEL_W-16,ry); }
    textFont(F_VAL); fill(C_LABEL); textAlign(LEFT,CENTER); textSize(height*0.020);
    text(rn[i], PANEL_X+18, ry+rowH*0.5);
    fill(C_VAL); textAlign(RIGHT,CENTER); textSize(height*0.023);
    text(int(vals[i])+"°", PANEL_X+PANEL_W-16, ry+rowH*0.5);
  }
}

void drawAllSliders() {
  for (int i=0;i<6;i++) {
    float x,y,sw;
    if (i<5) { x=SX; y=SY0+SGAP*i; sw=SW; }
    else { sw=SW; x=SX; y=SY0+SGAP*5; }
    drawSlider(i,x,y,sw,SH);
  }
  text("CLAW", SX+SW*0.5, SY0+SGAP*5+SH+10);
}

void drawSlider(int i, float x, float y, float sw, float sh) {
  float R  = sh * 0.5;
  float t  = constrain((vals[i]-minV[i])/(maxV[i]-minV[i]), 0, 1);
  float tx = x + R + t*(sw-sh);
  float ty = y + R;

  rectMode(CORNER);
  ellipseMode(CENTER);

  noStroke(); fill(C_TRACK);
  rect(x, y, sw, sh, R);

  if (t > 0.002) {
    noStroke();
    fill(lerpColor(color(0,90,180), C_FILL, t));
    rect(x, y, sh + t*(sw-sh), sh, R);
  }

  noFill(); stroke(C_BORDER); strokeWeight(1.5);
  rect(x, y, sw, sh, R);

  noStroke(); fill(C_ACCENT, 38);
  ellipse(tx, ty, sh*1.7, sh*1.7);

  noStroke(); fill(C_THUMB);
  ellipse(tx, ty, sh*0.86, sh*0.86);

  noFill(); stroke(C_ACCENT, 210); strokeWeight(2.0);
  ellipse(tx, ty, sh*0.56, sh*0.56);


  noStroke(); fill(C_LABEL); textFont(F_LBL);
  textAlign(RIGHT, CENTER); textSize(height*0.022);
  text(names[i], x-20, ty);

  float bw=sh*1.65, bh=sh*0.82, bx=x+sw+16, by2=ty-bh*0.5;
  noStroke(); fill(C_TRACK); rect(bx, by2, bw, bh, bh*0.5);
  noFill(); stroke(C_BORDER); strokeWeight(1.2); rect(bx, by2, bw, bh, bh*0.5);
  noStroke(); fill(C_VAL); textFont(F_VAL);
  textAlign(CENTER, CENTER); textSize(height*0.020);
  text(nf(int(vals[i]),3), bx+bw*0.5, ty);
}

void drawButtons() {
  for (int i=0;i<5;i++) {
    float rr=bH[i]*0.38;
    noStroke(); fill(0,80); rect(bX[i]+3,bY[i]+4,bW[i],bH[i],rr);
    fill(bOver[i]?bHov[i]:bBg[i]); stroke(bOver[i]?C_ACCENT:C_BORDER);
    strokeWeight(1.4); rect(bX[i],bY[i],bW[i],bH[i],rr);
    textFont(F_BTN); fill(255); textAlign(CENTER,CENTER); textSize(height*0.020);
    text(bLabel[i], bX[i]+bW[i]*0.5, bY[i]+bH[i]*0.5);
  }
  if (emergencyStop) {
    noFill(); stroke(255,70,70); strokeWeight(2.5);
    rect(bX[2]-4,bY[2]-4,bW[2]+8,bH[2]+8,bH[2]*0.42);
  }
}

void drawEmergency() {
  if (!emergencyStop) return;
  float bh=height*0.058;
  noStroke(); fill(155,0,0,215); rect(0,height-bh,width,bh);
  textFont(F_SUB); fill(255); textAlign(CENTER,CENTER); textSize(height*0.026);
  text("  EMERGENCY STOP ACTIVE  —  PRESS STOP TO RESUME  ", width*0.5, height-bh*0.5);
}

void mouseMoved()   { updateHover(); }
void mouseDragged() {
  updateHover();
  if (dragIdx>=0) slideFromMouse(dragIdx, mouseX);
}
void mousePressed() {
  updateHover();
  for (int i=0;i<6;i++) {
    float x,y,sw;
    if (i<5) { x=SX; y=SY0+SGAP*i; sw=SW; }
     else     { x=SX; y=SY0+SGAP*5; sw=SW; } 
    if (mouseX>=x&&mouseX<=x+sw&&mouseY>=y&&mouseY<=y+SH) {
      dragIdx=i; slideFromMouse(i,mouseX); return;
    }
  }
  for (int i=0;i<5;i++) if (bOver[i]) { fireBtn(i); return; }
  for (int i=0;i<4;i++) {
    if (pOver[i]) {
      demoRunning=false;
      for (int j=0;j<6;j++) vals[j]=presets[i][j];
      return;
    }
  }

  if (dOver) {
    demoRunning=!demoRunning;
    if (demoRunning) {
      demoStep=0;
      for (int i=0;i<6;i++) demoStart[i]=vals[i];
      for (int i=0;i<6;i++) demoTarget[i]=presets[0][i];
      demoLerpStart=millis(); demoTimer=millis();
    }
    return;
  }
}
void mouseReleased() { dragIdx=-1; }


void slideFromMouse(int i, float mx) {
  float t=constrain((mx-(SX+SH*0.5))/(SW-SH),0,1);
  vals[i]=minV[i]+t*(maxV[i]-minV[i]);
}

void updateHover() {
  for (int i=0;i<5;i++)
    bOver[i]=(mouseX>=bX[i]&&mouseX<=bX[i]+bW[i]&&mouseY>=bY[i]&&mouseY<=bY[i]+bH[i]);
  for (int i=0;i<4;i++)
    pOver[i]=(mouseX>=pX[i]&&mouseX<=pX[i]+pW[i]&&mouseY>=pY[i]&&mouseY<=pY[i]+pH[i]);
  dOver=(mouseX>=dBX&&mouseX<=dBX+dBW&&mouseY>=dBY&&mouseY<=dBY+dBH);
}



void fireBtn(int i) {
  demoRunning = false;
  if (i==0) { vals[0]=170;vals[1]=165;vals[2]=151;vals[3]=94;vals[4]=20;vals[5]=0; }
  if (i==1) { vals[0]=134;vals[1]=106;vals[2]=19; vals[3]=92;vals[4]=98;vals[5]=0; }
  if (i==2) emergencyStop=!emergencyStop;
  if (i==3) vals[5]=90;
  if (i==4) vals[5]=0;
  for (int j=0;j<6;j++) vals[j]=constrain(vals[j], minV[j], maxV[j]);
}

void sendIfChanged() {
  if (myPort==null) return;
  boolean chg=false;
  for (int i=0;i<6;i++) if (int(vals[i])!=int(lastSent[i])) { chg=true; break; }
  if (!chg) return;
  myPort.write(int(vals[0])+","+int(vals[1])+","+int(vals[2])+","
              +int(vals[3])+","+int(vals[4])+","+int(vals[5])+"\n");
  for (int i=0;i<6;i++) lastSent[i]=vals[i];
}
