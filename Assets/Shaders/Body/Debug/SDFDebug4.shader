Shader "IMMAT/Debug/SDFDebug4"
{
    Properties
    { 
        _Color ("Color", Color) = (1,1,1,1)
        _Size ("Size", float) = .01
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Cull off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"


struct Vert{
  float dist;
  float3 nor;
};

float3 _Dimensions;
float3 _Extents;
float3 _Center;

float4x4 _Transform;

float3 GetPos( int id){
    uint xID = id % int(_Dimensions.x);
    uint yID = (id / (int(_Dimensions.x))) % int(_Dimensions.y);
    uint zID = id / (int(_Dimensions.x) * int(_Dimensions.y));

    float x = float(xID) / float(_Dimensions.x);
    float y = float(yID) / float(_Dimensions.y);
    float z = float(zID) / float(_Dimensions.z);

    float3 p = (float3(x,y,z)-float3(.5 , .5 , .5)) * _Extents *2 + _Center;//_Extents;

    return mul(_Transform , float4( p ,1)).xyz;
 
}




      uniform int _Count;
      uniform float _Size;
      uniform float3 _Color;

      
      StructuredBuffer<Vert> _TransferBuffer;


      //uniform float4x4 worldMat;

      //A simple input struct for our pixel shader step containing a position.
      struct varyings {
          float4 pos      : SV_POSITION;
          float3 worldPos : TEXCOORD1;
          float3 nor      : NORMAL;
          float2 uv       : TEXCOORD4;
      };

//Our vertex function simply fetches a point from the buffer corresponding to the vertex index
//which we transform with the view-projection matrix before passing to the pixel program.
varyings vert (uint id : SV_VertexID){

  varyings o;

  int base = id / 6;
  int alternate = id %6;

  if( base < _Count ){

      float3 extra = float3(0,0,0);

    float3 l = UNITY_MATRIX_V[0].xyz;
    float3 u = UNITY_MATRIX_V[1].xyz;
    
    float2 uv = float2(0,0);

    if( alternate == 0 ){ extra = -l - u; uv = float2(0,0); }
    if( alternate == 1 ){ extra =  l - u; uv = float2(1,0); }
    if( alternate == 2 ){ extra =  l + u; uv = float2(1,1); }
    if( alternate == 3 ){ extra = -l - u; uv = float2(0,0); }
    if( alternate == 4 ){ extra =  l + u; uv = float2(1,1); }
    if( alternate == 5 ){ extra = -l + u; uv = float2(0,1); }


      Vert v = _TransferBuffer[base % _Count];
      o.worldPos = GetPos( base )  + extra * min(abs((1/(20*v.dist))) * _Size,_Size);
     // o.worldPos = 0  + extra;// * _Size;
        o.nor =  v.nor;
      o.uv = uv;
      o.pos = mul (UNITY_MATRIX_VP, float4(o.worldPos,1.0f));

  }

  return o;

}



      //Pixel function returns a solid color for each point.
      float4 frag (varyings v) : COLOR {

          //if( length( v.uv -.5) > .5 ){ discard;}

          float3 col = v.nor * .5 + .5;
      
          return float4(col,1 );
      }

      ENDCG
        }
    }
}
