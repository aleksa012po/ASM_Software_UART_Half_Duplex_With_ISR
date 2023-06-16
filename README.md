# ASM_Software_UART_Half_Duplex_With_ISR

This project implements a software UART for half-duplex serial communication on AVR microcontrollers
using assembly language. It provides a flexible solution for data transmission and reception when 
hardware UART is not available or shared with other peripherals.

Features
- Supports half-duplex communication using separate GPIO pins for Rx (receive) and Tx (transmit).
- Configurable number of stop bits.
- Utilizes interrupts for efficient data transfer.
- Simple and lightweight implementation in AVR assembly language.

Getting Started
1. Clone the repository or download the source code.
2. Adjust the configuration parameters in the code as needed (baud rate, stop bits, pin assignments).
3. Compile and upload the program to your AVR microcontroller using the appropriate tools.
4. Connect your device to the Rx and Tx pins of the AVR microcontroller.
5. Use a terminal program or another microcontroller to communicate with the AVR device.

Refer to the comments in the code for more detailed information on how to use and configure the software UART.

License
This project is licensed under the MIT License.

Acknowledgments
Special thanks to Aleksandar Bogdanovic for developing and sharing this software UART implementation in AVR assembly language.

Feel free to contribute to this project by submitting bug reports, feature requests, or pull requests.
