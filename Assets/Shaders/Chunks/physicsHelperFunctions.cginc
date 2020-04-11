float3 getVel( float3 p1 , float3 p2 ){

  float3 v = p1 - p2;

  if( length( v ) > .5){ v = normalize( v ) *.5; }
  return v;
  
}

float3 springForce( float3 p1 , float3 p2 , float sl ){
  float3 dif = p1 - p2;
  float l = length(dif);

  if( l > 0 ){
    float d = l - sl;
    return normalize( dif ) * d;
  }else{
    return float3(0,0,0);
  }

}
