This folder contains all the CAD files required to build the 6 DOF robot arm.

Note:

The CAD models were not created by me.
My contribution focuses on improving the control system, code efficiency, and usability of the robot arm.

Assembly Instructions

To assemble the robot arm, follow this video guide:

YouTube https://www.youtube.com/watch?v=ZEir102PxJ8&t=0s


Important Assembly Notes

1. Base Setup
While assembling the base servo, ensure the PCA9685 PWM driver is already connected to the Arduino Uno R3

Position the PCA9685 board next to the base servo inside the base for clean wiring and compact design


2. Servo Connections

After completing the mechanical assembly:

Connect all servo wires to the PCA9685

Ensure each servo is plugged into the correct channel (0–5)

Match each channel with your code configuration

3. Power Connection

Connect the DC jack to the green screw terminals on the PCA9685:

V+ → Power supply positive
GND → Power supply ground

This powers all servos safely using the external supply

Important Reminder

Double-check all wiring before powering the system
Ensure correct servo channel mapping
Keep wiring neat to avoid interference or loose connection
Credits

Full credit for the CAD design goes to Fabri Creator
