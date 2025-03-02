include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>
include <makeText.scad>

// makeFull = false;
makeTest = false;
makeDisplay1 = false;
makeAdapterRemovalTool1 = false;
makeAdapterRemovalTool2 = false;

// BL A1:
// innerWallPerimeterWidth = 0.42;
// outerWallPerimeterWidth = 0.45;

// Prusa Mini:
// innerWallPerimeterWidth = 0.45;
// outerWallPerimeterWidth = 0.45;

// firstLayerHeight = 0.2;
// layerHeight = 0.2;

adapterOD = 20.2;
adapterRecessZ = 25;
adapterEndWall = 2*outerWallPerimeterWidth + 3*innerWallPerimeterWidth;
// adapterCZ = 18;
echo(str("adapterEndWall = ", adapterEndWall));

// mufflerOD = 65;
mufflerWallThickness = 4*innerWallPerimeterWidth + outerWallPerimeterWidth;
echo(str("mufflerWallThickness = ", mufflerWallThickness));

// mufflerZ = 145; // 216.84 = total Z of 250mm
echo(str("mufflerZ = ", mufflerZ));

innerDiaFront = 6.5;
innerDiaInterior = 6.5;
innerDiaAdaper = 12;

mufflerID = mufflerOD - 2*mufflerWallThickness;
echo(str("mufflerID = ", mufflerID));

frontZ = 4;
frontCZ = 4;

mufflerTopZ = mufflerZ + adapterRecessZ + adapterEndWall;
echo(str("mufflerTopZ = ", mufflerTopZ));

echo(str("Muffler Total Z = ", mufflerTopZ + frontZ));

exteriorOffsetXY = mufflerOD/2; //mufflerOD/2 * cos((360/exteriorFN/2));

// rearInteriorCZ = 23.4;

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
					translate([0,0,frontInteriorZ-nothing]) simpleChamferedCylinder(d=mufflerID, h=mufflerZ-frontInteriorZ+nothing, cz=rearInteriorCZ);
				}

				// Inner hole:
				// Front:
				tcy([0,0,-frontZ-1], d=innerDiaFront, h=frontZ+2);
                translate([0,0,-innerDiaFront/2-frontZ/2]) cylinder(d2=20, d1=0, h=10);
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
            // topBaffleZ = mufflerZ - 50;
            // baffleSpacingZ = 28;
            for (zi=[0:1:numBaffles-1]) 
            {
                z = topBaffleZ-zi*baffleSpacingZ;
                echo(str("Baffle Z Position = ", z));
                translate([0,0,z]) baffle();
            }
            // for (z=[80, 45, 16]) 
            // {
            //     translate([0,0,z]) baffle();
            // }
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
	// cylinder(d=mufflerOD, h=baffleZ);
    // coneDeltaZ = 2;
    baseZabove = 2;
    outerDia = mufflerID + nothing;
    topDia = innerDiaInterior+2;
    coneTopZ = outerDia/2;

    coneInterorDia = outerDia - 4;

    difference()
    {
        // Cone exterior:
        union()
        {
            translate([0,0,coneDeltaZ]) cylinder(d1=outerDia, d2=0, h=outerDia/2);
            cylinder(d=outerDia, h=coneDeltaZ+baseZabove);
        }
        // Cone interior:
        interiorDia = mufflerID + nothing;
        translate([0,0,-nothing]) cylinder(d1=mufflerID, d2=0, h=mufflerID/2);
        // Cone top:
        tcu([-200, -200, coneDeltaZ+outerDia/2-innerDiaInterior/2-0.4], 400);
        // Interior hole:
        tcy([0,0,-1], d=innerDiaInterior, h=400);
    }
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

module adapterRemovalTool(toolHeight)
{
    //toolHeight = toolHeight_inches * 25.4;
    extractionHeight = toolHeight - 22; //extrationHeight_inches * 25.4;
    echo(str("toolHeight = ", toolHeight));
    echo(str("extractionHeight = ", extractionHeight));
    boltHoleDia = 13;
    difference()
    {
        cylinder(d=adapterOD+8, h=toolHeight);

        hull()
        {
            tcy([0,0,-1], d=adapterOD+2, h=extractionHeight+1, $fn=6);
            cylinder(d=boltHoleDia, h=toolHeight-6);
        }

        cylinder(d=boltHoleDia, h=100);
    }
}

module displayModule1()
{
	difference()
	{
		itemModule();
		tc([-200, -400, -10], 400);
	}
}

module clip(d=0)
{
	tc([-200, -400-d, -10], 400);
	// tc([-400-d, -300, -10], 400);
	// tc([-200, -200, 25-d], 400);
}

if(developmentRender)
{
	display() itemModule();
	// display() testModule();
	// display() displayModule1();
    // display() adapterRemovalTool(toolHeight=50);
    // display() translate([40,0,0]) adapterRemovalTool(toolHeight=65);
}
else
{
	if(makeFull) itemModule();
	if(makeTest) testModule();
	if(makeDisplay1) displayModule1();
	if(makeAdapterRemovalTool1) adapterRemovalTool(toolHeight=50);
	if(makeAdapterRemovalTool2) adapterRemovalTool(toolHeight=65);
}
