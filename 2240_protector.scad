include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/threads.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

makeThreaded = false;
makeUnthreadedTwistOn = false;
makeUnthreadedPushOn = false;

threadedLength = 13.5;
protectorZ = threadedLength+3;
protectorOD = 16;
exitDia = 8;

module basicPart(cz=0)
{
	difference()
    {
        // cylinder(d=protectorOD, h=protectorZ);
        simpleChamferedCylinder(d=protectorOD, h=protectorZ, cz=cz);

        // Bore:
        tcy([0,0,-1], d=exitDia, h=100);

        // Exit chafer:
        translate([0,0,protectorZ-exitDia/2-1.5]) cylinder(d1=0, d2=20, h=10);
    }
}

module threaded(doThreads=true)
{
    bodyCZ = 1;

	difference()
    {
        union()
        {
            basicPart(cz=bodyCZ);

            gripDia = 3;
            for(a = [0:30:360])
            {
                echo(str("a = ", a));
                cz = 0.8;
                rotate([0,0,a]) translate([protectorOD/2-gripDia/2+cz,0,0]) simpleChamferedCylinderDoubleEnded(d=gripDia, h=protectorZ-bodyCZ, cz=cz);
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

module unThreadedTwistOn()
{
    bodyCZ = 1;

    gripDia = 3;
    gripZ =protectorZ - bodyCZ;
    gripCZ = 0.8;

    difference()
    {
        union()
        {
            basicPart(cz=bodyCZ);

            for(a = [0:30:360])
            {
                echo(str("a = ", a));
                rotate([0,0,a]) translate([protectorOD/2-gripDia/2+gripCZ,0,0]) simpleChamferedCylinderDoubleEnded(d=gripDia, h=gripZ, cz=gripCZ);
            }
        }

        translate([0,0,-1]) cylinder(d=12.8, h=threadedLength+1);
        translate([0,0,-10+6+1]) cylinder(d2=0, d1=20, h=10);
    }
}


module unThreadedPushOn()
{
    bodyCZ = 1;

    gripDia = 3;
    gripZ = 3;
    gripCZ = 0.8;

    difference()
    {
        union()
        {
            basicPart(cz=bodyCZ);

            difference()
            {
                translate([0,0,protectorZ-gripZ-bodyCZ]) simpleChamferedCylinderDoubleEnded(d=protectorOD+2, h=gripZ, cz=1);

                cylinder(d=protectorOD-nothing, h=30);
            }
        }

        translate([0,0,-1]) cylinder(d=12.85, h=threadedLength+1);
        translate([0,0,-10+6+1]) cylinder(d2=0, d1=20, h=10);
    }
}

module clip(d=0)
{
	// tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() translate([-25,0,0]) threaded(doThreads=false);
    display() translate([ 25,0,0]) unThreadedTwistOn();
    display() unThreadedPushOn();
}
else
{
	if(makeThreaded) mirror([0,0,1]) threaded();
    if(makeUnthreadedTwistOn) mirror([0,0,1]) unThreadedTwistOn();
    if(makeUnthreadedPushOn) mirror([0,0,1]) unThreadedPushOn();
}
