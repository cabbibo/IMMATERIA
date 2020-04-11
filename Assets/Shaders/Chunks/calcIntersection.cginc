float2 calcIntersection( in float3 ro , in float3 rd ){     
            
               
    float h =  _IntersectionPrecision * 2;
    float t = 0.0;
    float res = -1.0;
    float id = -1.0;

    for( int i = 0; i< _NumberSteps; i++ ){
        
        if( h < _IntersectionPrecision || t > _MaxTraceDistance ) break;

        float3 pos = ro + rd*t;
        float2 m = map( pos );
        
        h = m.x;
        t += h;
        id = m.y;
        
    }


    if( t <  _MaxTraceDistance ){ res = t; }
    if( t >  _MaxTraceDistance ){ id = -1.0; }

    return float2( res , id );
  

}
        