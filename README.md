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
- Optimized serial communication (only sends data when angles change)
- Responsive fullscreen interface built with ControlP5

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

1. Install Processing
2. Install the ControlP5 library
3. Connect the Arduino with the robot arm
4. Update the serial port in the code:

myPort = new Serial(this, Serial.list()[PORT_NUMBER], 115200);

5. Run the Processing sketch.

Future Improvements

- Inverse kinematics for automatic positioning
- Motion path planning
- 3D robot arm visualization
- Autonomous pick-and-place routines

Author

Wisdom Daramola
