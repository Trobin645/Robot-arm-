6DOF Robot Arm Control System
A real-time control interface for a 6 Degrees of Freedom (DOF) robotic arm. Built using Processing (Java) and Arduino, the system allows precise control of each joint through an interactive slider-based GUI, with serial communication translating inputs into servo movements.
The control interface UI was designed with the assistance of AI to achieve a clean, responsive, and visually polished layout.
Robot Arm

https://github.com/user-attachments/assets/a3e858a0-f781-4d5d-b8b6-2898b0411ebd
 https://github.com/user-attachments/assets/a58a5560-9372-4583-88ed-2a65b75b0425
 https://github.com/user-attachments/assets/39d8f225-0105-45bd-a9ad-ae85d4f3938f

Demo

https://github.com/user-attachments/assets/d1acf517-ed5e-44ce-ad53-f962ddfd8ea6
Interface
https://github.com/user-attachments/assets/2c1df6f4-cb75-40f9-a7c7-f299f00f857e

https://github.com/user-attachments/assets/4d2e27a2-fe18-4309-b440-4525abce7635
Overview
This project combines concepts from:
Robotics — multi-joint servo control via PWM
Human-Computer Interaction — real-time slider-based GUI
Embedded Systems — Arduino + PCA9685 PWM driver integration
Features
6-joint control — Base, Shoulder, Elbow, Wrist, Wrist Yaw, Claw
Real-time slider interface — instant feedback and control
Preset positions — Home, Upright, Pick, Release, Demo sequence
Emergency stop — immediate halt of all movement
Efficient serial communication — only transmits data when values change
Full-screen responsive interface
Technologies Used
Component
Role
Processing (Java)
GUI and serial communication
Arduino
Servo controller
PCA9685 PWM Driver
Hardware PWM output for 6 servos
Servo Motors
Joint actuation
Serial (UART)
PC to Arduino communication
How It Works
The user adjusts sliders in the Processing interface
Each slider maps to a servo joint angle (0 to 180 degrees)
Angles are packaged and sent to the Arduino over serial
The Arduino converts angles to PWM values and drives the servos
Example serial command:
90,120,85,90,45,30
Each value is the target angle in degrees for one servo — Base, Shoulder, Elbow, Wrist, Wrist Yaw, Claw.
Controls
Button
Action
HOME
Reset all joints to default position
UPRIGHT
Move arm to vertical position
PICK
Close the claw
RELEASE
Open the claw
STOP
Emergency stop — halts all movement
Installation & Setup
1. Install Required Software
Arduino IDE
Processing
Adafruit PWM Servo Driver library (via Arduino Library Manager)
2. Calibrate the Servos
Calibrate each servo before assembling the arm to avoid mechanical damage.
Connect a servo to the PCA9685 and set the correct channel in the calibration sketch
Upload the calibration code to the Arduino
Open the Serial Monitor and slowly sweep the PWM value in each direction
Record the MIN and MAX PWM values where movement stops
Calculate the centre value: (MIN + MAX) / 2
Set the centre value in your code and upload:
int servoChannel = 1;
int pwmValue = 325; // example centre value
Type s in the Serial Monitor to verify the servo centres correctly
3. Update PWM Limits in Main Code
#define BASE_MIN        135
#define BASE_MAX        540
#define SHOULDER_MIN    130
#define SHOULDER_MAX    535
#define ELBOW_MIN       130
#define ELBOW_MAX       540
#define WRIST_MIN       130
#define WRIST_MAX       520
#define WRIST_YAW_MIN   130
#define WRIST_YAW_MAX   540
#define CLAW_MIN        120
#define CLAW_MAX        350
Ensure servo channels match the physical wiring:
pwm.setPWM(0, 0, basePWM);
pwm.setPWM(1, 0, shoulderPWM);
pwm.setPWM(2, 0, elbowPWM);
pwm.setPWM(3, 0, wristPWM);
pwm.setPWM(4, 0, wristYawPWM);
pwm.setPWM(5, 0, clawPWM);
4. Configure Serial Port in Processing
myPort = new Serial(this, Serial.list()[PORT_NUMBER], 115200);
5. Run the System
Upload the Arduino sketch
Open and run the Processing sketch
Use the sliders and preset buttons to control the arm
Notes
Typical PWM range is approximately 85 to 600, but varies by servo model
Always calibrate with your specific servos — do not reuse values from a different build
The Processing interface runs full-screen and scales responsively
Future Improvements
[ ] Inverse kinematics — target-position-based control
[ ] Motion path planning and trajectory smoothing
[ ] 3D visualisation of the arm in real time
[ ] Autonomous pick-and-place sequences
Author
Wisdom Daramola