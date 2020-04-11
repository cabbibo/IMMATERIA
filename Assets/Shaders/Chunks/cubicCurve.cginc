float3 cubicCurve( float t , float3  c0 , float3 c1 , float3 c2 , float3 c3 ){

  float s  = 1. - t;

  float3 v1 = c0 * ( s * s * s );
  float3 v2 = 3. * c1 * ( s * s ) * t;
  float3 v3 = 3. * c2 * s * ( t * t );
  float3 v4 = c3 * ( t * t * t );

  float3 value = v1 + v2 + v3 + v4;

  return value;

}
