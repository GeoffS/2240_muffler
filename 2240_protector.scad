include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/threads.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

makeThreaded = false;
makeUnthreaded = false;

threadedLength = 13.5;
protectorZ = threadedLength+3;
protectorOD = 16;
exitDia = 8;

module basicPart()
{
	difference()
    {
        cylinder(d=protectorOD, h=protectorZ);

        // Bore:
        tcy([0,0,-1], d=exitDia, h=100);

        // Exit chafer:
        translate([0,0,protectorZ-exitDia/2-1.5]) cylinder(d1=0, d2=20, h=10);
    }
}

module threaded(doThreads=true)
{
	difference()
    {
        union()
        {
            basicPart();

            gripDia = 3;
            for(a = [0:30:360])
            {
                echo(str("a = ", a));
                cz = 0.8;
                rotate([0,0,a]) translate([protectorOD/2-gripDia/2+cz,0,0]) simpleChamferedCylinderDoubleEnded(d=gripDia, h=protectorZ, cz=cz);
            }
        }

        // Threads:
        if(doThreads) translate([0,0,-1]) english_thread(diameter=0.5+0.008, threads_per_inch=20, length=(threadedLength+1)/25.4, internal=true);

        // Threads inner "loosening":
        tcy([0,0,-1], d=11.6, h=threadedLength+1);

        // Starting Chamfer:
        translate([0,0,-1]) simpleChamferedCylinder(d=12.8, h=6+1.5, cz=1.5);
        translate([0,0,-10+6+1]) cylinder(d2=0, d1=20, h=10);
    }
}

module unThreaded()
{
    difference()
    {
        union()
        {
            basicPart();

            difference()
            {
                gripZ = 3;
                translate([0,0,protectorZ-gripZ]) simpleChamferedCylinderDoubleEnded(d=protectorOD+2, h=gripZ, cz=1);

                cylinder(d=protectorOD-nothing, h=30);
            }
        }

        translate([0,0,-1]) cylinder(d=12.8, h=threadedLength+1);
        translate([0,0,-10+6+1]) cylinder(d2=0, d1=20, h=10);
    }
}

module clip(d=0)
{
	tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	// display() threaded(doThreads=false);
    display() unThreaded();
}
else
{
	if(makeThreaded) mirror([0,0,1]) threaded();
    if(makeUnthreaded) mirror([0,0,1]) unThreaded();
}
