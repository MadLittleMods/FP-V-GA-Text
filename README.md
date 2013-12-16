FP(V)GA-Text
============

A simple to use VHDL module to display text on VGA display.

![VGA Text Demo](https://raw.github.com/MadLittleMods/FP-V-GA-Text/master/vga-text-demo-side-by-side.png)

# [VGA Simulator](http://ericeastwood.com/lab/vga-simulator/)

Go simulate your own VHDL projects or even the ones you build with this text library. A faster better way to debug projects with VGA.

Go straight to the [tool](http://ericeastwood.com/lab/vga-simulator/). Or [read a bit about it and how to set it up](http://ericeastwood.com/blog/8/vga-simulator-getting-started).


Supported Characters
====================
 - VHDL'93 supports the full table of [ISO-8859-1 characters](http://kireji.com/reference/iso88591.html) (0x00 through 0xFF(255))
 - The font included includes 0x00 through 0x7F(127)
 - Non printing characters are supported using concatenation. ex.
  - `constant heart_msg : string := "I" & ETX & "You";`

Supported Boards
================
The constraints (.ucf) is configured for the [Basys 2](http://www.digilentinc.com/Products/Detail.cfm?Prod=BASYS2) but any FPGA with VGA should be able to run this code (make sure to update contraints)

TODO:
=====
 - Expand included font to support the full 0x00 through 0xFF (255) character range


Changelog:
==========

### 2013-12-15
 - Bug fix! Fixed a problem where text does not appear if you only use 1 text_line module.

### 2013-12-9

 - Added a font rom arbiter: This gets rid of the unnecessary font map for every text_line module and frees up board space.
 - Moved to block ram for the personal storage of each text_line module. This saves a lot of board space. We used to use an array of long std_logic_vectors

### 2013-7-13
 - Working text modules but took up a lot of board real estate.



## Notes:
 - The original font ROM pops up in many projects and sites (below). It has been since updated and cleaned up for this project.
  - https://ece320web.groups.et.byu.net/labs/VGATextGeneration/VGA_Terminal.html
  - https://github.com/thelonious/vga_generator
