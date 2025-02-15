include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

adapterOD = 19.9;
adapterRecessZ = 25;
adapterEndWall = 2;
adapterCZ = 12;

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

module itemModule()
{
	difference()
	{
		// Exterior:
		union()
		{
			mirror([0,0,1]) simpleChamferedCylinder(d=mufflerOD, h=frontZ, cz=frontCZ, $fn=6);
			simpleChamferedCylinder(d=mufflerOD, h=mufflerZ+adapterRecessZ+adapterEndWall, cz=adapterCZ, $fn=6);
		}

		// Interior:
		frontInteriorZ = 20;
		frontInteriorCZ = 6;
		translate([0,0,frontInteriorZ]) mirror([0,0,1]) simpleChamferedCylinder(d=mufflerID, h=frontInteriorZ, cz=frontInteriorCZ, $fn=6);
		rearInteriorCZ = 9;
		translate([0,0,frontInteriorZ-nothing]) simpleChamferedCylinder(d=mufflerID, h=mufflerZ-frontInteriorZ+nothing, cz=rearInteriorCZ, $fn=6);

		// Inner hole:
		// Front (will be drilled/reamed out):
		tcy([0,0,-frontZ-1], d=innerDiaFront, h=frontZ+2);
		// Adapter end::
		tcy([0,0,mufflerZ-1], d=innerDiaAdaper, h=400);

		// Recess for the adapter:
		rotate([0,0,30]) tcy([0,0,mufflerZ+adapterEndWall], d=adapterOD, h=100, $fn=6);
	}

	difference()
	{
		for (z=[50, 100]) 
		{
			translate([0,0,z]) baffle();
		}
		
		// Interior:
		tcy([0,0,frontZ+1], d=innerDiaInterior, h=400);
	}
}

baffleZ = 4;
module baffle()
{
	cylinder(d=mufflerOD, h=baffleZ, $fn=6);
}

module clip(d=0)
{
	tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	rotate([90,0,0]) itemModule();
}
