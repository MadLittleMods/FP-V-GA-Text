FP(V)GA-Text
============

A simple to use VHDL module to display text on VGA display.

Supported Characters
====================
 - VHDL'93 supports the full table of [ISO-8859-1 characters](http://kireji.com/reference/iso88591.html) (0x00 through 0xFF(255))
 - The font included includes 0x00 through 0x7F(127)

Supported Boards
================
The constraints (.ucf) is configured for the [Basys 2](http://www.digilentinc.com/Products/Detail.cfm?Prod=BASYS2) but any FPGA with VGA should be able to run this code (make sure to update contraints)

TODO:
=====
 - Expand included font to support the full 0x00 through 0xFF character range

Notes:
======
 - The original font ROM pops up in many projects and sites (below). It has been since updated and cleaned up for this project.
  - https://ece320web.groups.et.byu.net/labs/VGATextGeneration/VGA_Terminal.html
  - https://github.com/thelonious/vga_generator
