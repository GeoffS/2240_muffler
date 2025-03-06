makeFull = false;

// BL A1:
innerWallPerimeterWidth = 0.42;
outerWallPerimeterWidth = 0.45;
firstLayerHeight = 0.2;
layerHeight = 0.2;

mufflerOD = 50;
mufflerZ = 100;
mufflerWallThickness = 2*innerWallPerimeterWidth + 2*outerWallPerimeterWidth;

rearInteriorCZ = 16.85;
adapterCZ = 8;

topBaffleZ = mufflerZ - 38;
baffleSpacingZ = 25;
numBaffles = 3;
coneDeltaZ = 5*layerHeight;
echo(str("coneDeltaZ = ", coneDeltaZ));

innerDiaFront = 8;
innerDiaInterior = (0.22*25.4) + 2;
echo(str("innerDiaInterior = ", innerDiaInterior));

include <2240_muffler_vertical.scad>