// Tri-Planar blending function. Based on an old Nvidia tutorial.
float3 tex3D( sampler2D tex, in float3 p, in float3 n ){
  
  n = max((abs(n) - 0.2)*7, 0.001); // max(abs(n), 0.001), etc.
  n /= (n.x + n.y + n.z );  
    
  float3 tx = (texture2D(tex, p.yz)*n.x + tex2D(tex, p.zx)*n.y + tex2D(tex, p.xy)*n.z).xyz;
    
  return tx*tx;
}