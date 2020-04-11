Texture2D<float4> _HeightMap;
SamplerState sampler_HeightMap;
float _MapSize;
float _MapHeight;


float3 worldPos( float3 pos ){
    float4 c = _HeightMap.SampleLevel(sampler_HeightMap, (pos.xz-.5) * _MapSize  , 0);//tex2Dlod(_HeightMap , float4(pos.xz * _MapSize,0,0) );
    pos.y =  c.x * _MapHeight;
    return pos;
}


float3 getNormal( float3 pos ){

  float delta = .4;
  float3 dU = worldPos( pos + float3(delta,0,0) );
  float3 dD = worldPos( pos + float3(-delta,0,0) );
  float3 dL = worldPos( pos + float3(0,0,delta) );
  float3 dR = worldPos( pos + float3(0,0,-delta) );

  return normalize(cross(dU.xyz-dD.xyz , dL.xyz-dR.xyz));

}