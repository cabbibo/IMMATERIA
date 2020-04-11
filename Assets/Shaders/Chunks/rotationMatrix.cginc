



float4x4 rotationMatrix(  float3 direction,float3 up,float flip ){

    float4 row1 = float4(0,0,0,0);
    float4 row2 = float4(0,0,0,0);
    float4 row3 = float4(0,0,0,0);
    float4 row4 = float4(0,0,0,1);

    float3 x = normalize(cross(up, direction));
    float3 y = normalize(cross(direction, x));
    float3 z = normalize(direction);
  
    row1.x = x.x;
    row1.y = x.y;
    row1.z = x.z;

    row2.x = y.x;
    row2.y = y.y;
    row2.z = y.z;

    row3.x = z.x;
    row3.y = z.y;
    row3.z = z.z;


    return float4x4( row1 , row3 , row2 , row4 );

}



float4x4 rotationMatrix(  float3 nor,float3 tang ){

    float4 row1 = float4(0,0,0,0);
    float4 row2 = float4(0,0,0,0);
    float4 row3 = float4(0,0,0,0);
    float4 row4 = float4(0,0,0,1);

    float3 x = tang;//normalize(cross(up, direction));
    float3 y = nor;//normalize(cross(direction, x));
    float3 z = normalize(cross(tang, nor));//normalize(direction);
  
    row1.x = x.x;
    row1.y = x.y;
    row1.z = x.z;

    row2.x = y.x;
    row2.y = y.y;
    row2.z = y.z;

    row3.x = z.x;
    row3.y = z.y;
    row3.z = z.z;


    return float4x4( row1 , row3 , row2 , row4 );

}

// http://www.euclideanspace.com/maths/geometry/rotations/conversions/angleToMatrix/index.htm
float4x4 rotationMatrix( float3 axis , float angle ){


  float x = axis.x;
  float y = axis.y;
  float z = axis.z;

  float c = cos( angle );
  float s = sin( angle );
  float t = 1.-c;

  float4 row1 = float4(t*x*x + c , t*x*y - z*s , t*x*z + y*s , 0.);
  float4 row2 = float4(t*x*y + z*s , t*y*y + c  ,t*y*z - x*s,0.);
  float4 row3 = float4(t*x*z - y*s , t*y*z + x*s, t*z*z + c , 0.);
  float4 row4 = float4(0,0,0,1);

  return float4x4( row1 , row3 , row2 , row4 );
}