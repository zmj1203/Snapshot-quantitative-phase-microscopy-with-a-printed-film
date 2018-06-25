%=========================================================
% Matlab code for ECCV 2006 paper
% Copyright: Amit Agrawal, 2006
% http://www.umiacs.umd.edu/~aagrawal/
% Permitted for personal use and research purpose only
% Refer to the following citations:
 
%   1.  A. Agrawal, R. Raskar and R. Chellappa, "What is the Range of
%   Surface Reconstructions from a Gradient Field? European Conference on
%   Computer Vision (ECCV) 2006
 
%   2.  A. Agrawal, R. Chellappa and R. Raskar, "An Algebraic approach to surface reconstructions from gradient fields?
%   Intenational Conference on Computer Vision (ICCV) 2006
%=========================================================


Tested with Matlab 7.1, Windows XP and Windows 7


At command prompt 

> SurfaceReconstructionECCV06


This code implements the algorithms described in my ECCV and ICCV paper for surface reconstruction.


=========================================



============================================================
Note:

Algorithm 3 (ICCV 2005) uses C code to quickly find the minimum set of edges required to connect the graph.

To properly run Algo 3, 
--Set USE_ALGORITH_3 to 1 in SurfaceReconstructionECCV06.m file
 -compile the C code in folder MST_fromlabpc on your machine
 -copy mst.exe from Release folder into the main folder

The matlab code calls mst.exe. The input arrays are written in txt files and output arrays are read from the txt file

















