# Temperature_Effects

Notes on nomenclature:

Profile_* is a snapshot(profile_0), or historical trajectory(profile_t) of the model state.
Current_ is the trajectory of the various current components calculated at each timestep.

Model_* functions calculate the derivative of the model state. Thus, they require the model state as well as model parameters as inputs.

Main_* functions iteratively calls on the model functions to calculate successive model states that the system will evolve to. The model's parameters are calculated by the main functions from the inital and final parameters, as well as the time constant (see methods for more detailed description). This will output a historical trajectory(profile_t) of the system.



1. run initialize.m

This runs the model from a base state that closely resembles our experiement for extended period of time so that it will reach a steady state (a limit cycle)
	
It outputs two files in init folder.

First is the leak_profile_0.mat, which is the state of the system at the end of the run, which will serve as the starting point for other simulations.
		
Second is the leak.mat, which is an instance of the initialdata class. This will contain not only the state, but also the function used to evaluate it, as well as the model parameters used.

2. run the scripts inside figure folders

Simualted data will be in results folder, and plots will be saved to plots folder.
