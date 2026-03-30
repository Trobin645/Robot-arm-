Hardware Setup
Overview

This project uses a 6 Degrees of Freedom (DOF) robotic arm controlled via an Arduino microcontroller and a PCA9685 PWM driver. The hardware setup ensures precise control of each servo motor while maintaining safe and stable operation. A dedicated external power supply provides the current required by all servos, avoiding overloading the microcontroller.

This section describes the components used, wiring guidelines, power setup, and safety considerations.

Components

The robot arm is built using the following components:

Microcontroller: Arduino Uno R3
The Arduino acts as the central control unit, sending commands to the servo driver via serial communication.
Servo Driver: PCA9685 PWM driver
The PCA9685 allows the control of multiple servos simultaneously with high precision and reduces the load on the Arduino. It receives commands from the Arduino and outputs PWM signals to each servo.
Servo Motors:
3 × MG996R (high-torque servos, used for the base, shoulder, and elbow joints)
3 × SG90 / MG90S (smaller servos, used for wrist, wrist yaw, and claw joints)
Power Supply:
6V 5A external power supply
DC barrel jack for connecting the power supply to the PCA9685
Connections:
Jumper wires for signal and power routing
Power Setup

Servos are powered exclusively through the external 6V 5A power supply connected to the PCA9685. This ensures that all servos receive sufficient current to operate reliably, especially under load.

The Arduino is used solely to provide control signals to the PCA9685. It is not used to power the servos. Drawing power for multiple high-torque servos from the Arduino can lead to instability and potential damage to the board.

Wiring Guidelines

To ensure correct operation, follow these wiring guidelines:

Power Connections:
Connect the positive output of the external power supply to the V+ terminal on the PCA9685.
Connect the negative output (ground) of the power supply to the GND terminal on the PCA9685.
Arduino to PCA9685:
Connect the SDA pin on the Arduino to the SDA input on the PCA9685.
Connect the SCL pin on the Arduino to the SCL input on the PCA9685.
Common Ground:
Connect the Arduino GND to the PCA9685 GND to ensure a shared reference voltage. This is critical for accurate control and to avoid erratic servo behavior.
Servo Channels:
Each servo is connected to a designated channel on the PCA9685, corresponding to the channel configuration in the Arduino code.
Ensure the wiring matches the channel numbers exactly to prevent unexpected movements.
Safety Considerations

Servo motors, particularly high-torque models like the MG996R, require significant current, especially when operating under load. Powering these directly from the Arduino is not recommended and can result in the following:

Permanent damage to the Arduino
Random resets or unstable system behaviour
Potential overheating of the board or servos

Always use a dedicated external power supply for the servo motors. Verify that the supply can provide sufficient current for all servos operating simultaneously. Additionally, ensure all connections are secure and insulated to prevent short circuits.
