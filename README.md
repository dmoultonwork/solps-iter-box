A quick guide to using solps-iter-box:

1) Create a new directory in runs, containing an INPUT.m script copied over from one of the example directories.
2) Modify the INPUT.m script for the box geometry you want to create and run the script.
3) Copy the baserun and ref directories that have been created in your run directory to the server where you want to run the simulation.
4) On that server, go into baserun and type the following:
b2run b2ag [enter]
triang [enter] (at this point you will be given some letter options. Type "T [enter] G [enter] [ctrl-c]")
b2run b2ah [enter]
b2run b2ai [enter]
b2run b2ar [enter]
cd ../ref [enter]
b2run b2mn < input.dat >! run.log [enter]
5) The run should finish after one time step. Check that it has completed successfully by typing "b2fstate [enter]".
6) If the answer is "yes" then go into b2mn.dat, increase ntim to a larger number of steps (e.g. ~5000).
7) Now run the simulation for longer by typing (for freia with 12 processors):
   jetsubmit -m "-np 12" [enter]