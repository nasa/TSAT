readme_main.txt

TSAT version 1.0.0
Date of most recent update: 02/22/2018
Developer: Jonathan Kratz (NASA Glenn Research Center)

The Thermal Systems Analysis Toolbox (TSAT) is a MATLAB/Simulink based tool for modeling and analysis
of dynamic and steady-state thermal systems involving heat transfer. TSAT consists of a Simulink library
that will appear in your Simulink library browser when installed. Each block has a help file that can
be reached by right clicking the block and clicking "help". The help files will provide general modeling 
information of what the block does; will described inputs, parameters, and outputs; and will provide 
references if appropriate. In addition to the help files, several examples are provided that illustrate
usage of several of the TSAT blocks. TSAT also provides several MATLAB functions that can be used in a
variety of ways. Descriptions of function inputs, outputs, and usage is provided by comments within the 
function files.

The "Trunk" folder contains all the tools including the Simulink libraries, the MATLAB tools, the help
files, and examples. The "Resources" folder contains the TSAT Quickstart Guide (TSATquicksart.pdf) and 
could include various other materials if future updates of the software package are made. The quickstart 
guide is recommended reading before attempting to install, uninstall, or use TSAT.

TSAT was created during the development of thermal models of aero-engines for the purpose of approximating
the thermal environment relevant for control system components when considering the application of 
distributed engine control. Also of interest was thermal modeling relevent to turbine tip clearance control.
A significant portion of the TSAT library blocks and MATLAB tools are a direct result of these efforts. At 
the core of the library are its 1D and 2D conduction blocks used to model conduction through solid structures.
The library also has various options of estabilishing boundary conditions and it contains various general-use 
tools as well. 

NOTE: TSAT and the examples it comes with were developed using MATLAB/Simulink R2015a. Although compatability
with newer versions is not thought to be an issue, the user should be aware of the potential for 
compatability issues.