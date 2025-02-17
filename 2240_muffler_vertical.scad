include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>
include <makeText.scad>

makeFull = false;
makeTes = false;

innerWallPerimeterWidth = 0.42;
outerWallPerimeterWidth = 0.45;
firstLayerHeight = 0.2;
layerHeight = 0.2;

adapterOD = 20.1;
adapterRecessZ = 25;
adapterEndWall = 2*outerWallPerimeterWidth + 3*innerWallPerimeterWidth;
adapterCZ = 12;
echo(str("adapterEndWall = ", adapterEndWall));

mufflerOD = 60;
mufflerWallThickness = 6;

mufflerZ = 150;

innerDiaFront = 5; // drilled/reamed out to final dia.
innerDiaInterior = 6.5;
innerDiaAdaper = 9;

mufflerID = mufflerOD - 2*mufflerWallThickness;
echo(str("mufflerID = ", mufflerID));

frontZ = 6;
frontCZ = 4;

mufflerTopZ = mufflerZ + adapterRecessZ + adapterEndWall;
echo(str("mufflerTopZ = ", mufflerTopZ));

exteriorOffsetXY = mufflerOD/2; //mufflerOD/2 * cos((360/exteriorFN/2));

module itemModule()
{
	difference()
	{
		union()
		{
			difference()
			{
				// Exterior:
				hull()
				{
					mirror([0,0,1]) simpleChamferedCylinder(d=mufflerOD, h=frontZ, cz=frontCZ);
					simpleChamferedCylinder(d=mufflerOD, h=mufflerTopZ, cz=adapterCZ);

                    frontExtraZ = frontZ - frontCZ;
                    x = 14;
                    y = nothing;
                    z = mufflerTopZ - adapterCZ + frontExtraZ;
                    tcu([-x/2, exteriorOffsetXY-nothing, -frontExtraZ], [x, y, z]);
				}

				// Interior:
				union()
				{
					frontInteriorZ = 20;
					frontInteriorCZ = 6;
					translate([0,0,frontInteriorZ]) mirror([0,0,1]) simpleChamferedCylinder(d=mufflerID, h=frontInteriorZ, cz=frontInteriorCZ);
					rearInteriorCZ = 9;
					translate([0,0,frontInteriorZ-nothing]) simpleChamferedCylinder(d=mufflerID, h=mufflerZ-frontInteriorZ+nothing, cz=rearInteriorCZ);
				}

				// Inner hole:
				// Front (will be drilled/reamed out):
				tcy([0,0,-frontZ-1], d=innerDiaFront, h=frontZ+2);
				// Adapter end::
				tcy([0,0,mufflerZ-1], d=innerDiaAdaper, h=400);

				// Recess for the adapter:
				rotate([0,0,30]) translate([0,0,mufflerZ+adapterEndWall])
				{
					// Adapter recess:
					cylinder(d=adapterOD, h=100, $fn=6);
					// Chamfer at exterior opening:
					translate([0,0,adapterRecessZ-adapterOD/2-2]) cylinder(d2=40, d1=0, h=20, $fn=6);
				}
			}

			// Baffles:
			difference()
			{
				for (z=[50, 100]) 
				{
					translate([0,0,z]) baffle();
				}
				
				// Interior hole:
				tcy([0,0,frontZ+1], d=innerDiaInterior, h=400);
			}
		}

		// Top text:
		textIndent = 2*layerHeight;
		textCenterZ = mufflerTopZ - adapterCZ;
		topTextStr = ".22 cal. Airgun Use Only";
		echo(str("exteriorOffsetXY = ", exteriorOffsetXY));
		translate([-0.55, exteriorOffsetXY-textIndent, textCenterZ/2]) rotate([-90,0,0]) rotate([0,0,-90]) 
		{
			makeText(topTextStr); 
		}
	}
}

baffleZ = 2*outerWallPerimeterWidth + 5*innerWallPerimeterWidth;
echo(str("baffleZ = ", baffleZ));
module baffle()
{
	cylinder(d=mufflerOD, h=baffleZ);
}

module testModule()
{
	difference()
	{
		itemModule();

		// tcy([0,0,-400+mufflerZ-2], d=100, h=400);
		tcy([0,0,-400+mufflerZ], d=100, h=400);

		topClipZ = mufflerTopZ-adapterCZ+2;
		tcy([0,0,topClipZ], d=100, h=400);
		rotate([0,0,30]) translate([0,0,topClipZ-adapterOD/2-2]) cylinder(d2=40, d1=0, h=20, $fn=6);
	}
}

module testModuleHorizontal()
{
	testModule();
}

module testModuleVertical()
{
	testModule();
}

module clip(d=0)
{
	// tc([-200, -400-d, -10], 400);
	// tc([-400-d, -300, -10], 400);
	// tc([-200, -200, 25-d], 400);
}

if(developmentRender)
{
	display() itemModule();
	// display() testModule();
}
else
{
	if(makeFullVerticalPrint) itemModule(addBrims=true);
	if(makeTestVerticalPrint) testModule(addBrims=false);
}
