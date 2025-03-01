include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/threads.scad>

threadedLength = 13.5;
protectorZ = threadedLength+3;
exitDia = 8;

module itemModule(doThreads=true)
{
	difference()
    {
        union()
        {
            cylinder(d=16, h=protectorZ);
        }

        // Bore:
        tcy([0,0,-1], d=exitDia, h=100);

        // Threads:
        if(doThreads) translate([0,0,-1]) english_thread(diameter=0.5+0.004, threads_per_inch=20, length=(threadedLength+1)/25.4, internal=true);

        // Threads inner "loosening":
        tcy([0,0,-1], d=11.6, h=threadedLength+1);

        // Starting Chamfer:
        translate([0,0,-10+6+1]) cylinder(d2=0, d1=20, h=10);

        // Exit chafer:
        translate([0,0,protectorZ-exitDia/2-1.5]) cylinder(d1=0, d2=20, h=10);
    }
}

module clip(d=0)
{
	tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule(doThreads=false);
}
else
{
	mirror([0,0,1]) itemModule();
}
