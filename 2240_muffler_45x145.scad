makeFull = false;

// BL A1:
innerWallPerimeterWidth = 0.42;
outerWallPerimeterWidth = 0.45;
firstLayerHeight = 0.2;
layerHeight = 0.2;

mufflerOD = 45;
mufflerZ = 145;

rearInteriorCZ = 15.35;
adapterCZ = 8;

topBaffleZ = mufflerZ - 30;
baffleSpacingZ = 20;
numBaffles = 6;
coneDeltaZ = 5*layerHeight;
echo(str("coneDeltaZ = ", coneDeltaZ));

include <2240_muffler_vertical.scad>