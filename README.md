Images of robot arm https://github.com/user-attachments/assets/a3e858a0-f781-4d5d-b8b6-2898b0411ebd

Images of robot arm https://github.com/user-attachments/assets/a58a5560-9372-4583-88ed-2a65b75b0425

Images of robot arm https://github.com/user-attachments/assets/39d8f225-0105-45bd-a9ad-ae85d4f3938f

Interface https://github.com/user-attachments/assets/2c1df6f4-cb75-40f9-a7c7-f299f00f857e
Interface https://github.com/user-attachments/assets/4d2e27a2-fe18-4309-b440-4525abce7635


Videos of robot arm https://github.com/user-attachments/assets/d1acf517-ed5e-44ce-ad53-f962ddfd8ea6

6 DOF Robot Arm Control System

Overview

This project is a real-time control system for a 6 Degrees of Freedom (DOF) robotic arm.

A custom interface built using Processing lets the user control each joint using sliders. 

The interface communicates with an Arduino through serial communication, allowing the robot arm to move smoothly and accurately.

This system combines concepts from:
Robotics
Human–computer interaction
Embedded systems

Features
Control of 6 servo joints:
Base
Shoulder
Elbow
Wrist
Wrist Yaw
Claw
Real-time slider control
Preset positions:

Home
Upright
Pick
Release
Demo sequence

Emergency stop function

Efficient communication (only sends data when values change)

Full-screen responsive interface
Technologies Used

Processing (Java-based)

Arduino

Serial communication

Servo motors

PCA9685 PWM driver

How It Works
The user moves sliders in the interface
Each slider controls a servo angle
The angles are sent to the Arduino via serial communication
The Arduino updates the servo positions
Example Command:

90,120,85,90,45,30
Each number represents a servo angle (in degrees).
🎮 Controls
HOME → Reset to default position
UPRIGHT → Move arm vertically
PICK → Close the claw
RELEASE → Open the claw
STOP → Emergency stop

Installation & Setup

1. Install Required Software
Install Arduino IDE
Install Processing
Install the Adafruit PWM Servo Driver library

2. Calibrate the Servos
Before assembling the robot arm, each servo must be calibrated.
Steps:
Connect a servo to the PCA9685 PWM driver
Set the correct channel number in the code
Upload the calibration code to the Arduino
Open the Serial Monitor
Use the controls to find:
Minimum (MIN) PWM value
Maximum (MAX) PWM value
You’ll know you’ve reached the limit when the servo stops moving.

Calculate the centre value:

(MIN + MAX) ÷ 2
Set the centre value in your code:
C++
int servoChannel = 1;
int pwmValue = 325; // example centre value
Upload the code and type "s" in the Serial Monitor to test

3. Update Main Code Values
Replace the MIN and MAX values in your main Arduino code:
C++
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
Make sure servo channels match:
C++
pwm.setPWM(0, 0, basePWM);
pwm.setPWM(1, 0, shoulderPWM);
pwm.setPWM(2, 0, elbowPWM);
pwm.setPWM(3, 0, wristPWM);
pwm.setPWM(4, 0, wristYawPWM);
pwm.setPWM(5, 0, clawPWM);

4. Serial Connection Setup
Update the port in Processing:
Java
myPort = new Serial(this, Serial.list()[PORT_NUMBER], 115200);
5. Run the System
Upload Arduino code
Run the Processing sketch
Start controlling the robot arm

Notes:

Typical PWM range: ~85 to 600 (depends on servo)

Always calibrate to avoid damaging servos

Your project uses custom PWM values, so others should recalibrate if using different servos

Future Improvements


Inverse kinematics (automatic positioning)

Motion path planning

3D visualisation of the arm

Autonomous pick-and-place system

👤 Author

Wisdom Daramola
