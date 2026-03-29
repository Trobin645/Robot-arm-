#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>

Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver();


#define BASE_MIN 135
#define BASE_MAX 540

#define SHOULDER_MIN 130
#define SHOULDER_MAX 535

#define ELBOW_MIN 130
#define ELBOW_MAX 540

#define WRIST_MIN 130
#define WRIST_MAX 520

#define WRIST_YAW_MIN 130
#define WRIST_YAW_MAX 540

#define CLAW_MIN 120
#define CLAW_MAX 350


int basePWM      = -1;
int shoulderPWM  = -1;
int elbowPWM     = -1;
int wristPWM     = -1;
int wristYawPWM  = -1;
int clawPWM      = -1;


int targetBase;
int targetShoulder;
int targetElbow;
int targetWrist;
int targetWristYaw;
int targetClaw;

bool firstCommandReceived = false;

void setup() {
  Serial.begin(115200);
  pwm.begin();
  pwm.setPWMFreq(50);
  Serial.println("System Ready");
}

void loop() {

  
  if (Serial.available()) {
    String data = Serial.readStringUntil('\n');

    int c1 = data.indexOf(',');
    int c2 = data.indexOf(',', c1 + 1);
    int c3 = data.indexOf(',', c2 + 1);
    int c4 = data.indexOf(',', c3 + 1);
    int c5 = data.lastIndexOf(',');

    if (c1 > 0 && c2 > c1 && c3 > c2 && c4 > c3 && c5 > c4) {

      
      int baseAngle     = data.substring(0, c1).toInt();
      int shoulderAngle = data.substring(c1 + 1, c2).toInt();
      int elbowAngle    = data.substring(c2 + 1, c3).toInt();
      int wristAngle    = data.substring(c3 + 1, c4).toInt();
      int wristYawAngle = data.substring(c4 + 1, c5).toInt();
      int clawAngle     = data.substring(c5 + 1).toInt();

      baseAngle     = constrain(baseAngle,     10,  170);
      shoulderAngle = constrain(shoulderAngle, 15,  165);
      elbowAngle    = constrain(elbowAngle,    10,  170);
      wristAngle    = constrain(wristAngle,    10,  170);
      wristYawAngle = constrain(wristYawAngle, 10,  170);
      clawAngle     = constrain(clawAngle,     0,   90);

      
      targetBase     = angleToPWM(baseAngle,     BASE_MIN,      BASE_MAX,      180);
      targetShoulder = angleToPWM(shoulderAngle, SHOULDER_MIN,  SHOULDER_MAX,  180);
      targetElbow    = angleToPWM(elbowAngle,    ELBOW_MIN,     ELBOW_MAX,     180);
      targetWrist    = angleToPWM(wristAngle,    WRIST_MIN,     WRIST_MAX,     180);
      targetWristYaw = angleToPWM(wristYawAngle, WRIST_YAW_MIN, WRIST_YAW_MAX, 180);
      targetClaw     = angleToPWM(90 - clawAngle, CLAW_MIN,     CLAW_MAX,      90);

      
      if (!firstCommandReceived) {
        basePWM     = targetBase;
        shoulderPWM = targetShoulder;
        elbowPWM    = targetElbow;
        wristPWM    = targetWrist;
        wristYawPWM = targetWristYaw;
        clawPWM     = targetClaw;
        firstCommandReceived = true;
      }
    }
  }

  
  if (firstCommandReceived) {
    basePWM     = smoothMove(basePWM,     targetBase);
    shoulderPWM = smoothMove(shoulderPWM, targetShoulder);
    elbowPWM    = smoothMove(elbowPWM,    targetElbow);
    wristPWM    = smoothMove(wristPWM,    targetWrist);
    wristYawPWM = smoothMove(wristYawPWM, targetWristYaw);
    clawPWM     = smoothMove(clawPWM,     targetClaw);

    pwm.setPWM(0, 0, basePWM);
    pwm.setPWM(1, 0, shoulderPWM);
    pwm.setPWM(2, 0, elbowPWM);
    pwm.setPWM(3, 0, wristPWM);
    pwm.setPWM(4, 0, wristYawPWM);
    pwm.setPWM(5, 0, clawPWM);
  }


  delay(15);
}

int angleToPWM(int angle, int minPWM, int maxPWM, int maxAngle) {
  angle = constrain(angle, 0, maxAngle);
  int pwmVal = map(angle, 0, maxAngle, minPWM, maxPWM);
  return constrain(pwmVal, minPWM, maxPWM);
}

int smoothMove(int current, int target) {
  int step = 2;
  if (abs(current - target) <= step) return target;
  return (current < target) ? current + step : current - step;
}