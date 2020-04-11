#define PHI (sqrt(5.)*0.5 + 0.5)
#define PI 3.14159265

float fOpIntersectionRound(float a, float b, float r) {
    float m = max(a, b);
    if ((-a < r) && (-b < r)) {
        return max(m, -(r - sqrt((r+a)*(r+a) + (r+b)*(r+b))));
    } else {
        return m;
    }
}


// Cone with correct distances to tip and base circle. Y is up, 0 is in the middle of the base.
float fCone(float3 p, float radius, float height) {
    float2 q = float2(length(p.xz), p.y);
    float2 tip = q - float2(0, height);
    float2 mantleDir = normalize(float2(height, radius));
    float mantle = dot(tip, mantleDir);
    float d = max(mantle, -q.y);
    float projected = dot(tip, float2(mantleDir.y, -mantleDir.x));
    
    // distance to tip
    if ((q.y > height) && (projected < 0.)) {
        d = max(d, length(tip));
    }
    
    // distance to base ring
    if ((q.x > radius) && (projected > length(float2(height, radius)))) {
        d = max(d, length(q - float2(radius, 0)));
    }
    return d;
}

// Reflect space at a plane
float pReflect(inout float3 p, float3 planeNormal, float offset) {
    float t = dot(p, planeNormal)+offset;
    if (t < 0.) {
        p = p - (2.*t)*planeNormal;
    }
    return sign(t);
}

// Rotate around a coordinate axis (i.e. in a plane perpendicular to that axis) by angle <a>.
// Read like this: R(p.xz, a) rotates "x towards z".
// This is fast if <a> is a compile-time constant and slower (but still practical) if not.
void pR(inout float2 p, float a) {
    p = cos(a)*p + sin(a)*float2(p.y, -p.x);
}

// The "Round" variant uses a quarter-circle to join the two objects smoothly:
float fOpUnionRound(float a, float b, float r) {
    float m = min(a, b);
    if ((a < r) && (b < r) ) {
        return min(m, r - sqrt((r-a)*(r-a) + (r-b)*(r-b)));
    } else {
     return m;
    }
}

// Repeat around the origin by a fixed angle.
// For easier use, num of repetitions is use to specify the angle.
float pModPolar(inout float2 p, float repetitions) {
    float angle = 2.*PI/repetitions;
    float a = atan(p.y, p.x) + angle/2.;
    float r = length(p);
    float c = floor(a/angle);
    a = mod(a,angle) - angle/2.;
    p = float2(cos(a), sin(a))*r;
    // For an odd number of repetitions, fix cell index of the cell in -x direction
    // (cell index would be e.g. -5 and 5 in the two halves of the cell):
    if (abs(c) >= (repetitions/2.)) c = abs(c);
    return c;
}


float3 pModDodecahedron(inout float3 p) {
    float3 v1 = normalize(float3(0., PHI, 1.));
    float3 v2 = normalize(float3(PHI, 1., 0.));

    float sides = 5.;
    float dihedral = acos(dot(v1, v2));
    float halfDdihedral = dihedral / 2.;
    float faceAngle = 2. * PI / sides;
    
    p.z = abs(p.z);
    
    pR(p.xz, -halfDdihedral);
    pR(p.xy, faceAngle / 4.);
    
    p.x = -abs(p.x);
    
    pR(p.zy, halfDdihedral);
    p.y = -abs(p.y);
    pR(p.zy, -halfDdihedral);

    pR(p.xy, faceAngle);
    
    pR(p.zy, halfDdihedral);
    p.y = -abs(p.y);
    pR(p.zy, -halfDdihedral);

    pR(p.xy, faceAngle);
    
    pR(p.zy, halfDdihedral);
    p.y = -abs(p.y);
    pR(p.zy, -halfDdihedral);

    pR(p.xy, faceAngle);
    
    pR(p.zy, halfDdihedral);
    p.y = -abs(p.y);
    pR(p.zy, -halfDdihedral);

    p.z = -p.z;
    pModPolar(p.yx, sides);
    pReflect(p, float3(-1, 0, 0), 0.);
    
    return p;
}

float3 pModIcosahedron(inout float3 p) {

    float3 v1 = normalize(float3(1, 1, 1 ));
    float3 v2 = normalize(float3(0, 1, PHI+1.));

    float sides = 3.;
    float dihedral = acos(dot(v1, v2));
    float halfDdihedral = dihedral / 2.;
    float faceAngle = 2. * PI / sides;
    

    p.z = abs(p.z);    
    pR(p.yz, halfDdihedral);
    
    p.x = -abs(p.x);
    
    pR(p.zy, halfDdihedral);
    p.y = -abs(p.y);
    pR(p.zy, -halfDdihedral);

    pR(p.xy, faceAngle);
    
    pR(p.zy, halfDdihedral);
    p.y = -abs(p.y);
    pR(p.zy, -halfDdihedral);

    pR(p.xy, faceAngle);
     
    pR(p.zy, halfDdihedral);
    p.y = -abs(p.y);
    pR(p.zy, -halfDdihedral);

    pR(p.xy, faceAngle);
  
    pR(p.zy, halfDdihedral);
    p.y = -abs(p.y);
    pR(p.zy, -halfDdihedral);

    p.z = -p.z;
    pModPolar(p.yx, sides);
    pReflect(p, float3(-1, 0, 0), 0.);

    return p;
}

float spikeModel(float3 p) {
    pR(p.zy, PI/2.);
    return fCone(p, 0.25, 3.);
}

float spikesModel(float3 p) {
    float smooth = 0.6;
    
    pModDodecahedron(p);
    
    float3 v1 = normalize(float3(0., PHI, 1.));
    float3 v2 = normalize(float3(PHI, 1., 0.));

    float sides = 5.;
    float dihedral = acos(dot(v1, v2));
    float halfDdihedral = dihedral / 2.;
    float faceAngle = 2. * PI / sides;
    
    float spikeA = spikeModel(p);
    
    pR(p.zy, -dihedral);

    float spikeB = spikeModel(p);

    pR(p.xy, -faceAngle);
    pR(p.zy, dihedral);
    
    float spikeC = spikeModel(p);
    
    return fOpUnionRound(
        spikeC,
        fOpUnionRound(
            spikeA,
            spikeB,
            smooth
        ),
        smooth
    );
}

float coreModel(float3 p) {
    float outer = length(p) - .9;
    float spikes = spikesModel(p);
    outer = fOpUnionRound(outer, spikes, 0.4);
    return outer;
}

float exoSpikeModel(float3 p) {
    pR(p.zy, PI/2.);
    p.y -= 1.;
    return fCone(p, 0.5, 1.);
}

float exoSpikesModel(float3 p) {
    pModIcosahedron(p);

    float3 v1 = normalize(float3(1, 1, 1 ));
    float3 v2 = normalize(float3(0, 1, PHI+1.));

    float dihedral = acos(dot(v1, v2));

    float spikeA = exoSpikeModel(p);
    
    pR(p.zy, -dihedral);

    float spikeB = exoSpikeModel(p);

    return fOpUnionRound(spikeA, spikeB, 0.5);
}

float exoHolesModel(float3 p) {
    float len = 3.;
    pModDodecahedron(p);
    p.z += 1.5;
    return length(p) - .65;
}

float exoModel(float3 p) {    
    float thickness = 0.18;
    float outer = length(p) - 1.5;
    float inner = outer + thickness;

    float spikes = exoSpikesModel(p);
    outer = fOpUnionRound(outer, spikes, 0.3);
    
    float shell = max(-inner, outer);

    float holes = exoHolesModel(p);
    shell = fOpIntersectionRound(-holes, shell, thickness/2.);
    
    return shell;
}

float doExo(float3 p) {
    //return length(p + float3(0,0,-2)) - 3.;
    //float disp = (sin(length(p) * 5. - t * 8.)) * 0.03;
    return exoModel(p);
}

float doCore(float3 p) {
    //return length(p + float3(0,0,2)) - 3.;
    return coreModel(p);
}


// checks to see which intersection is closer
// and makes the y of the float2 be the proper id
float2 opU( float2 d1, float2 d2 ){
    
    return (d1.x<d2.x) ? d1 : d2;
    
}

float map( float3 p ){  
    p *= 3.;
    float2 res = float2(doExo(p) ,1.); 
    res = opU(res, float2(doCore(p) ,2.));
    return res.x;
}
