#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>-

Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver();

int servoChannel = 2;   // Change for each servo
int pwmValue = 325;     // Start near center

void setup() {
  Serial.begin(9600);
  pwm.begin();
  pwm.setPWMFreq(50);  // 50Hz for servos

  Serial.println("Use + or - to adjust PWM");
  Serial.println("Press s to set position");
}

void loop() {
  if (Serial.available()) {
    char input = Serial.read();

    if (input == '+') {
      pwmValue += 5;
    }
    if (input == '-') {
      pwmValue -= 5;
    }

    pwmValue = constrain(pwmValue, 70, 600);

    pwm.setPWM(servoChannel, 0, pwmValue);

    Serial.print("PWM Value: ");
    Serial.println(pwmValue);

    delay(100);
  }
}
