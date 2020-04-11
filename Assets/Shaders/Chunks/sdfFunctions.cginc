
/*

  Primatives

*/

float sdBox( float3 p, float3 b ){

  float3 d = abs(p) - b;

  return min(max(d.x,max(d.y,d.z)),0.0) +
         length(max(d,0.0));

}

float sdSphere( float3 p, float s ){
  return length(p)-s;
}

float sdPlane( float3 p, float4 n )
{
  // n must be normalized
  return dot(p,n.xyz) + n.w;
}

float sdCapsule( float3 p, float3 a, float3 b, float r )
{
    float3 pa = p - a, ba = b - a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    return length( pa - ba*h ) - r;
}

float sdCone( float3 p, float2 c )
{
    // c must be normalized
    float q = length(p.xy);
    return dot(c,float2(q,p.z));
}

float sdCappedCylinder( float3 p, float2 h )
{
  float2 d = abs(float2(length(p.xz),p.y)) - h;
  return min(max(d.x,d.y),0.0) + length(max(d,0.0));
}



float sdCylinderZ( float3 p, float3 c )
{
  return length(p.xz-c.xy)-c.z;
}




/*

  Operations

*/


float2 smoothU( float2 d1, float2 d2, float k)
{
    float a = d1.x;
    float b = d2.x;
    float h = clamp(0.5+0.5*(b-a)/k, 0.0, 1.0);
    return float2( lerp(b, a, h) - k*h*(1.0-h), lerp(d2.y, d1.y, pow(h, 2.0)));
}

float smax(float a, float b, float k)
{
    return log(exp(k*a)+exp(k*b))/k;
}

float smin(float a, float b, float k)
{
    return -(log(exp(k*-a)+exp(k*-b))/k);
}

float2 smoothS( float2 d1, float2 d2, float k)
{
    return  float2( smax( -d1.x , d2.x , k ) , d2.y );
}




float2 hardU( float2 d1, float2 d2 ){
    
  return (d1.x<d2.x) ? d1 : d2;
    
}

float hardU( float d1, float d2 ){
    
  return max(d1,d2);
    
}

float2 hardS( float2 d1, float2 d2 )
{
    return  -d1.x > d2.x ? d2 : d1;
}

float hardS( float d1, float d2 )
{
    return max(-d1,d2);
}



float3 rotatedBox( float3 p, float4x4 m )
{
    float3 q = mul( m , float4( p , 1 )).xyz;
    return sdBox(q,float3(.6,.6,.6));
}

float3 modit(float3 x, float3 m) {
          float3 r = x%m;
          return r<0 ? r+m : r;
      }


/*

  Combinations

*/

float opRepSphere( float3 p, float3 c , float r)
{
    float3 q = modit(p,c)-0.5*c;
    float3 re = (q-p)/c;
    return sdSphere( q  , r * 1.9 - .1 * length(re) );
}


/*float subCube( float3 pos , float size ){

  float r = opRepSphere( pos , float3( .05 * size * 2. )  , .025 * size * 2.8);
  r = hardS( r ,sdBox( pos , float3( .125 * size * 2. )) );

  return r;

}*/



