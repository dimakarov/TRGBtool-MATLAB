TRGBtool
Determine the Tip of the Red Giant Branch using Maximum Likelihood Algorithm

Installation:

You have to add TRGBtool directory to the MATLAB path either 
by using the addpath function, or by selecting 
File:SetPath to edit the path.

Usage:

trgbtool runs the graphical interface
trgbplot draws the result plot

TRGBtool:

The top left panel allows to load photometry files and save the results.
The Galaxy edit box contains the name of the galaxy.
AV and AI do not implemented. 
The trgbtool DOES NOT apply any correction for galactic absorption.
You can load either text photometry and fake files, or previously stored 
trgbtool session.

Parameters panel allows regulate the start point of the minimization.
TRGB - position of TRGB jump
a - RGB luminosity function slope
b - jump level at TRGB position
c - AGB LF slope

Fix check boxes allow to fix several parameters and remove them from 
minimization.

Bounds edit boxes allow to define domain range. 

Range [-1,+1] determines the domain range of LF in respect to 
the TRGB position. The stars with magnitude [TRGB-1,TRGB+1] will be 
included in minimization process.

Alpha is a value between 0 and 1 that specifies the confidence level 
as 100(1-alpha)%. Default is 0.317 which is rough corresponded to 
1 sigma level.

Graphical panels consist of CMD and set of graphics: completeness,
distribution of errors, luminosity function and log of LF. These graphics
can be hidden or shown using buttons "C", "B", "#", "L" correspondingly.

The first approximation of TRGB position can be made by mouse click on 
graphic panels, CMD or LF diagrams.

CMD panel:
It shows photometry with gray dots. The cyan dash lines bound the selection 
region. The bounds can be changed using mouse. 
If first approximation of TRGB position already pointed then the selected 
stars are shown by red dots. Magenta curved line shows running mean of 
distribution of stars.

LF and log LF diagrams:
The blue line shows smoothed luminosity function of stars in selected region.
Green line corresponds to smoothed edge detection filter of LF. 
The starting point and domain region are shown by red lines.
Fitting result is shown by bold magenta and cyan lines. 
The cyan line is model and magenta one is model with applied photometric 
effects.

Information panel:
The fitting results are shown in format = X (Left,Right), 
where X is the best approximation, Left and Right show the confidence 
interval defined by Alpha.
Color of TRGB position and its error are given for tip position and for 
tip+0.5mag. Color is the robust estimation of running mean.

Dmitry Makarov
