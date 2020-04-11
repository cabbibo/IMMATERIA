
float4x4 scaleMatrix( float3 scale ){

    float4 row1 = float4( scale.x, 0 ,0 ,0 );
    float4 row2 = float4( 0, scale.y ,0 ,0 );
    float4 row3 = float4( 0, 0 ,scale.z,0 );
    float4 row4 = float4(0 , 0,0 ,1 );

    return float4x4( row1 , row2 , row3 , row4 );

}


float4x4 scaleMatrix( float scale ){

  return scaleMatrix(float3(scale,scale,scale));

}