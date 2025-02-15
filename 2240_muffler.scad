include <../OpenSCAD_Lib/MakeInclude.scad>

adapterOD = 19.9;

module itemModule()
{
	difference()
	{
		rotate([0,0,0]) cylinder(d=40, h=20, $fn=6);
		rotate([0,0,30]) tcy([0,0,-1], d=adapterOD, h=100, $fn=6);
	}
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	rotate([90,0,0]) itemModule();
}
