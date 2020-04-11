struct Human {
  float4x4 leftHand;
  float4x4 rightHand;
  float4x4 head;
  float leftTrigger;
  float rightTrigger;
  float voice;
  float debug;
};

RWStructuredBuffer<Human> _HumanBuffer;
int _HumanBuffer_COUNT;

float _HumanRadius;
float _HumanForce;
float _HumanFalloff;

int _HeadForce;



float3 HumanForces(float3 p){
  float3 totalForce;
  
  for( int i = 0; i < _HumanBuffer_COUNT; i++ ){
    Human h = _HumanBuffer[i];

    float3 hL = mul(h.leftHand,float4(0,0,0,1));
    float3 hR = mul(h.rightHand,float4(0,0,0,1));
    float3 hH = mul(h.head,float4(0,0,0,1));

    float3 d;

    d = p - hL;

    if( length( d ) < _HumanRadius && length( d ) > .00001 ){ 

      float v = (_HumanRadius - length( d )) / _HumanRadius;
      totalForce += normalize( d ) * v;
    }


     d = p - hR;
    if( length( d ) < _HumanRadius && length( d ) > .001 ){ 

      float v = (_HumanRadius - length( d )) / _HumanRadius;
      totalForce += normalize( d ) * v;
    }

      d = p - hH;
      if( length( d ) < _HumanRadius && length( d ) > .001 ){ 
        float v = (_HumanRadius - length( d )) / _HumanRadius;
        totalForce += normalize( d ) * v;
      }


    

  }
totalForce *= _HumanForce;
  return mul( _FullWTL , float4( totalForce,0)).xyz;
}







float4 GetHumanRayToPoint( float3 pos ,  float4x4 transform ){
  

  float3 ro = mul( transform , float4(0,0,0,1)).xyz;
  float3 rd = normalize(mul( transform , float4(0,0,-1,0)).xyz);
  float3 p2 = ro - rd;
  float3 pa = pos - ro;
  float3 ba = ro - p2;
  float h =  dot(pa,ba)/dot(ba,ba);
  float3 pOnLine = h * rd  + ro;

  float3 inLine = pos - pOnLine;

  return float4( inLine , h);
}



float3 HumanRayForces(float3 p){
  float3 totalForce;
  
  for( int i = 0; i < _HumanBuffer_COUNT; i++ ){
    Human h = _HumanBuffer[i];

 
    float4 d;
    float v;
    float falloffForce;

    d = GetHumanRayToPoint( p,h.leftHand );
    if( length( d.xyz ) < _HumanRadius && length( d.xyz ) > .00001 ){ 
      v = (_HumanRadius - length( d.xyz )) / _HumanRadius;
      falloffForce = saturate(1-(d.a / _HumanFalloff)) * saturate(d.a * 1000);
      totalForce +=  normalize( d.xyz ) * v;
    }


    d = GetHumanRayToPoint( p,h.rightHand );
    if( length( d.xyz  ) < _HumanRadius && length( d.xyz  ) > .001 ){ 

      v = (_HumanRadius - length( d.xyz  )) / _HumanRadius;
      falloffForce = saturate(1-(d.a / _HumanFalloff)) * saturate(d.a * 1000);
      totalForce +=  normalize( d.xyz ) * v;
    }

    if(_HeadForce == 1){


    d = GetHumanRayToPoint( p,h.head );
    if( length( d.xyz  ) < _HumanRadius && length( d.xyz  ) > .001 ){ 
      v = (_HumanRadius - length( d.xyz  )) / _HumanRadius;
      falloffForce = saturate(1-(d.a / _HumanFalloff)) * saturate(d.a * 1000);
      totalForce +=  normalize( d.xyz ) * v;
    }
}
    

  }
  totalForce *= _HumanForce;
  return mul( _FullWTL , float4( totalForce,0)).xyz;
}



