This repository contains original Matlab files created by Nicky McLean (in
2011) to calculate the optimal break-points for the piece-wise linear representation of
the per-unitised electrical loss curve that is used in vSPD/SPD.

All matlab code resides in the /matlab dir

The number of loss segments can be selected by setting the N variable (line 45)
of ParaWhat.m and then invoking ParaWhat.m from within Matlab.  While running,
the code iterates to a solution and up-dates a plot of the piece-wise linear
solution for each iteration...  

The /matlab/latex directory contains ad-hoc files that were used to draw/plot the results along with the resulting pdf files.

This really should be converted to run in Python, volunteers?

D J Hume, 5th November, 2013.





