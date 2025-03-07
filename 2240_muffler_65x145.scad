
makeFull = false;

// // Prusa Mini:
// innerWallPerimeterWidth = 0.45;
// outerWallPerimeterWidth = 0.45;
// firstLayerHeight = 0.2;
// layerHeight = 0.2;

// BL A1:
innerWallPerimeterWidth = 0.45;
outerWallPerimeterWidth = 0.42;
firstLayerHeight = 0.2;
layerHeight = 0.2;

mufflerOD = 65;
mufflerZ = 145;
mufflerWallThickness = 2*innerWallPerimeterWidth + 2*outerWallPerimeterWidth;

rearInteriorCZ = 25.7; //23.4;
adapterCZ = 18;

topBaffleZ = mufflerZ - 53;
baffleSpacingZ = 26.55;
numBaffles = 4;
coneDeltaZ = 8*layerHeight;; //2;

innerDiaFront = 8; //6.5;
innerDiaInterior = (0.22*25.4) + 2; //6.5;

frontZ = firstLayerHeight + 9*layerHeight;

include <2240_muffler_vertical.scad>