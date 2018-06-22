readme_SimulinkExamples.txt

Created: 1/3/2017

Each folder within the "TSAT_Examples" folder contains and example of how to use the TSAT library.
The use of every single block is not illustrated but a significant portion of them are. The examples
will include a Simulink model and may be accompanied by a MATLAB script to initialize the workspace 
and or to automate the simulation and result analysis process. Please read the comments in the Simulink
models and MATLAB scripts to better understand how to use the TSAT library. Also, each block has a help
file that can be refered to. Given below is a list of the examples and alphabetic order and a short 
description of each.

2D Heat Transfer - Rectangular Object
	- Illustrates usage of the 2D conduction blocks to model heat transfer with a rectangular
	  object.

2D Heat Transfer - Shape Options
	- The 2D conduction blocks have various options when it comes to the shape. The object can 
	  be planar or cylindrical about either axis. This example demonstates the 3 options on the 
	  same cross-sectional shape with the same boundary conditions and differences due to shape 
	  can be observed.

2D Heat Transfer Test
	- This example models what could be modeled as a 1D heat transfer problem with a 2D conduction 
	  block. It compares the results of the 2D block with its 1D counterpart to verify that the
	  2D block accurately models the 1D heat transfer problem.

Air Properties
	- Illustrates the usage of the air properties blocks to approximate the heat capacity, specific 
	  heat at constant volume, dynamic viscosity, and thermal conductivity or air given its 
	  temperature and density.

Averaging
	- Illustrates usage of the averaging blocks within TSAT.

Dynamic Material Properties
	- Illustrates how dynamic material properties could be considered when using the 1D or 2D 
	  conduction blocks.

Fluid Energy Balance
	- Illustrates usage of the fluid energy balance block to provide a first cut estimate of the 
	  temperature of a low flow rate fluid passing between hot surfaces.

Interpolation
	- Demonstrates how to use the 1D, 2D, and 3D interpolation tools in TSAT.

Iterative Subsystem
	- The 1D and 2D conduction blocks have a memory block embedded in them to hold the previous 
	  time-steps solution. If they were used inside an iterative subsystem, the temperature solution
	  from these blocks would continue to march ahead in time while the rest of the simulation remains
	  on the same time-step. Therefore, a modified version of these blocks was created to allow for their
	  use within iterative subsystems while producing time-accurate results. This example shows how to 
	  implement this modified version of the block within an iterative subsystem.

Laminar Boundary Layer Heat Transfer
	- This example illustrates heat transfer between a hot plate and laminar flow that is modeled
	  using the Falkner-Skan solution. Several of the convection tools and general tools are used along
	  with a 2D conduction block.

Lumped Mass Heat Transfer
	- Illustrates a lumped mass heat transfer problem that considers convection and radiation.

Material Transitions
	- Illustrates how material transitions can be handled using the 1D and 2D conduction blocks.

Matrix Tools
	- Illustrates the usage of TSATs matrix manipulation tools.

Modular Structure Modeling
	- The ability to model a heat transfer problem in a modular manner is a powerful concept and is
	  an emphasized feature of TSAT. For instance, a complex structure can be broken up into various
	  smaller pieces and linked together through boundary conditions. This allows for more complex 
	  structures to be modeled and may reduce computational time. This example illustrates this powerful
	  concept.

Non-Isotropic Structures
	- Some structures could be non-isotropic by having directional thermal conductivity. This example
	  illustrates such a case and how it can be handled with TSAT.

Pipe Heat Transfer (1D)
	- This is meant to be an example that demonstrates usage of various TSAT tools including various
	  convection models, air property blocks, the 1D conduction block, and more. It models heat transfer
	  of a pipe with a flowing liquid on the inside and flowing air on the outside.

Polynomial Fitting
	- Illustrates the functionality of the polynomial fitting tools of TSAT which allow for on-the-fly
	  polynomial fitting.

Radiation Between Plates (1D)
	- This example illustates radiation heat transfer coefficient approximations and their use with 
	  1D conduction blocks to model radiation heat transfer between 2 plates and their surroundings.

Turbulent Boundary Layer Heat Transfer
	- This example illustrates heat transfer between a hot plate and turbulent flow that is modeled
	  using the 1/7 power law. Several of the convection tools and general tools are used along
	  with a 2D conduction block.