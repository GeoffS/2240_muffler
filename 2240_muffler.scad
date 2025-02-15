include <../OpenSCAD_Lib/MakeInclude.scad>

adapterOD = 19.9;
adapterRecessZ = 25;
adapterEndWall = 2;

mufflerOD = 60;
mufflerWallThickness = 6;

mufflerZ = 150;

innerDia = 6;

mufflerID = mufflerOD - 2*mufflerWallThickness;
echo(str("mufflerID = ", mufflerID));

frontZ = 6;

module itemModule()
{
	difference()
	{
		union()
		{
			cylinder(d=mufflerOD, h=mufflerZ+adapterRecessZ+adapterEndWall, $fn=6);
		}

		// Interior:
		tcy([0,0,frontZ], d=mufflerID, h=mufflerZ-frontZ, $fn=6);

		// Inner hole:
		tcy([0,0,-1], d=innerDia, h=400);

		// Recess for the adapter:
		rotate([0,0,30]) tcy([0,0,mufflerZ+adapterEndWall], d=adapterOD, h=100, $fn=6);
	}
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
