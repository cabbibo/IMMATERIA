
// Get a 3D Vector using snoise
float3 snoise3( float3 x ){

  // for first noise we can just use the input vectors, but for others
  // we will subtract random amounts to put them in different locations
  // of the noise function. It is important to add / subtract, 
  // but not multiply because that will change noise size
  float noise1 = snoise( x );
  float noise2 = snoise( float3( x.y - 23.7 , x.z + 63.2 , x.x + 135.4 ));
  float noise3 = snoise( float3( x.z + 95.3 , x.x - 20.5 , x.y + 219.1 ));

  float3 finalNoiseVec = float3( noise1 , noise2 , noise3 );
  return finalNoiseVec;

}


float3 curlNoise( float3 p ){
  

  //Using a small value, get a 3D noise vectors
  //surrounding a location, to get the differences
  //in the noise function. 

  //you can think of this as a rate of change of the 
  //function in all directions

  const float dif = .1;

  float3 dx = float3( dif , 0 , 0 );
  float3 dy = float3( 0 , dif , 0 );
  float3 dz = float3( 0 , 0 , dif );


  //getting up and down vectors in all dimensions
  //do = down
  float3 doX = snoise3( p - dx );
  float3 upX = snoise3( p + dx );
  float3 doY = snoise3( p - dy );
  float3 upY = snoise3( p + dy );
  float3 doZ = snoise3( p - dz );
  float3 upZ = snoise3( p + dz );


  // getting the finall differences 
  // in the different dimensions
  float finalDifX = upY.z - doY.z - upZ.y + doZ.y;
  float finalDifY = upX.x - doZ.x - upX.z + doX.z;
  float finalDifZ = upX.y - doX.y - upY.x + doY.x;

  // scaling the vector properly according to how big our
  // small 'dif' is
  const float divisor = 1.0 / ( 2.0 * dif );
  return normalize( float3( finalDifX , finalDifY , finalDifZ ) * divisor );


}