6 DOF Robot Arm Control System 🦾

Overview

This project is a real-time control system for a 6 Degrees of Freedom (DOF) robotic arm.
A custom graphical interface built with Processing allows the user to control each servo joint interactively. The software communicates with an Arduino microcontroller using serial communication to move the robot arm smoothly and precisely.

The system demonstrates principles from robotics, human-machine interfaces, and embedded systems.

Features

- Control of 6 servo joints:
  - Base
  - Shoulder
  - Elbow
  - Wrist
  - Wrist Yaw
  - Claw
- Real-time slider-based GUI control
- Preset positions:
  - Home
  - Upright
  - Pick
  - Release
  - Demo seq
- Emergency stop system
- Optimised serial communication (only sends data when angles change)
- Responsive full-screen interface built with ControlP5

Technologies Used

- Processing (Java-based)
- ControlP5 GUI library
- Arduino
- Serial communication
- Servo motors

How It Works

1. The user moves sliders in the Processing interface.
2. Each slider represents a servo angle.
3. The software sends the angles to the Arduino via serial communication.
4. The Arduino updates the servo positions on the robot arm.

Example Command Sent to Arduino

90,120,85,90,45,30

Each number represents a servo angle in degrees.

Demo

Example controls in the interface include:

- HOME – resets the robot to the default position
- UPRIGHT – positions the arm vertically
- PICK – closes the claw
- RELEASE – opens the claw
- STOP – emergency stop

Installation

1. Install Arduino
2. Install Processing
3. Install the Adafruit Library PWM Servo Driver in Arduino libraries.
4. Calibrate all servos before assembling.

Run calibration code
Follow these instructions:
To use this code, connect the servo to the PCA9685 board, note the channel number, update the code, upload it, open the serial monitor, then check the MAX PWM values and MIN PWM values. To see whether you are at the MAX or MIN values, the servo won't move when using "+" or "-".
Note each servo's PWM values down, then add the MAX and MIN together, then divide by two. Note the middle PWM value number down, then go to the code then input the number in this part "int pwmValue = 325;".
Example: int servoChannel = 1; // Change for each servo int pwmValue = 325; // Start near center
Upload the code, open the serial monitor, then enter"s".

The noted MAX and MIN values should be changed in the main Arduino code in:
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
Save the code and make sure the channel number is in order, 0 to 5. If changed, just change the code in (make sure the channel matches the code):
pwm.setPWM(0, 0, basePWM);
    pwm.setPWM(1, 0, shoulderPWM);
    pwm.setPWM(2, 0, elbowPWM);
    pwm.setPWM(3, 0, wristPWM);
    pwm.setPWM(4, 0, wristYawPWM);
    pwm.setPWM(5, 0, clawPWM);
  

Typical MIN and MAX PWM values are around 85 to 600, depending on the servo.
Please use this code to avoid purchasing servos because the attached Arduino code uses my specific servo PWM values.


Update the serial port in the code:

myPort = new Serial(this, Serial.list()[PORT_NUMBER], 115200); in proccessing. 
5. Run the Processing sketch.

Future Improvements

- Inverse kinematics for automatic positioning
- Motion path planning
- 3D robot arm visualisation
- Autonomous pick-and-place routines
  

Author

Wisdom Daramola
