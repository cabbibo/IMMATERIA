float3 GetRayForce( float3 pos ,   float force ,float radius ){
  
  float3 p2 = _RO - _RD * 200;
  float3 pa = pos - _RO;
  float3 ba = _RO - p2;
  float h =  dot(pa,ba)/dot(ba,ba);
  float3 pOnLine = h * _RD * 200 + _RO;

  float3 inLine = pos - pOnLine;

  return  _DOWN * normalize(inLine) * force *  (1 - clamp( length(inLine) / radius , 0 , 1));
}
