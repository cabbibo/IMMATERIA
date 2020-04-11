float3 triForce( float size , float3 pos , float3 v1 , float3 v2){


  float3 dif = (pos - v1 );

  float3 f = float3( 0,0,0);

  if( length( dif )> 0 ){
    f -= normalize( dif ) * abs( .5 * (length( dif ) - size) );
  }
  
  dif = (pos - v2 );

  if( length( dif )> 0 ){
    f -= normalize( dif ) * abs( .5 * (length( dif ) - size) );
  }
  return f;

}