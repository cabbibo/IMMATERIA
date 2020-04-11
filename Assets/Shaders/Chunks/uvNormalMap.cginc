float3 uvNormalMap( sampler2D normalMap , float3 pos , float2 uv , float3 norm , float texScale , float normalScale ){
             
  float3 q0 = ddx( pos.xyz );
  float3 q1 = ddy( pos.xyz );
  float2 st0 = ddx( uv.xy );
  float2 st1 = ddy( uv.xy );

  float3 S = normalize(  q0 * st1.y - q1 * st0.y );
  float3 T = normalize( -q0 * st1.x + q1 * st0.x );
  float3 N = normalize( norm );

  float3 mapN = tex2D( normalMap, uv*texScale ).xyz * 2.0 - 1.0;
  mapN.xy = normalScale * mapN.xy;
 
  float3x3 tsn = transpose( float3x3( S, T, N ) );
  float3 fNorm =  normalize( mul(tsn , mapN) ); 

  return fNorm;

} 