
makeFull = false;

// Prusa Mini:
innerWallPerimeterWidth = 0.45;
outerWallPerimeterWidth = 0.45;
firstLayerHeight = 0.2;
layerHeight = 0.2;

mufflerOD = 65;
mufflerZ = 145;

rearInteriorCZ = 23.4;
adapterCZ = 18;

topBaffleZ = mufflerZ - 50;
baffleSpacingZ = 28;
numBaffles = 4;
coneDeltaZ = 2;

innerDiaFront = 6.5;
innerDiaInterior = 6.5;
mufflerWallThickness = 4*innerWallPerimeterWidth + outerWallPerimeterWidth;

include <2240_muffler_vertical.scad>