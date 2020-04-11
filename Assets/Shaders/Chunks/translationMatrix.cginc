


float4x4 translationMatrix( float3 position ){


    float4 row1 = float4( 1 , 0 , 0 , position.x );
    float4 row2 = float4( 0 , 1 , 0 , position.y );
    float4 row3 = float4( 0 , 0 , 1 , position.z );
    float4 row4 = float4( 0 , 0 , 0 , 1 );

    return float4x4( row1 , row2 , row3 , row4 );

}
