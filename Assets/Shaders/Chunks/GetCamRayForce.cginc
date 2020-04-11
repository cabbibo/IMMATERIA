


float3 GetCamRayForce( float3 pos ,   float force ,float radius ){
  
  float3 p2 = _CameraPosition - _CameraForward * 200;
  float3 pa = pos - _CameraPosition;
  float3 ba = _CameraPosition - p2;
  float h =  dot(pa,ba)/dot(ba,ba);
  float3 pOnLine = h * _CameraForward * 200 +_CameraPosition;

  float3 inLine = pos - pOnLine;

  return  normalize(inLine) * force *  (1 - clamp( length(inLine) / radius , 0 , 1));
}
