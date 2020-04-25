Shader "IMMAT/Debug/ConnectionDebug" {
    Properties {
       _ColorMap ("ColorMap", 2D) = "white" {}
       _TextureMap ("TextureMap", 2D) = "white" {}
      
      _PainterlyLightMap("PLightMap1", 2D) = "white" {}

      _Color ("Color", Color) = (1,1,1,1)
      _Size ("Size", float) = .01
    }


  SubShader{
    Cull Off
    Pass{

      CGPROGRAM
      
      #pragma target 4.5

      #pragma vertex vert
      #pragma fragment frag

      #include "UnityCG.cginc"

struct Vert{
  float3 pos;
  float3 vel;
  float3 nor;
  float3 og;
  float2 uv;
  float2 debug;
  float4 resolver;
  float3 connections[16];
};

struct Vert2{
 float3 pos;
  float3 vel;
  float3 nor;
  float3 og;
  float2 uv;
  float2 debug;
};




      uniform int _Count;
      uniform float _Size;
      uniform float3 _Color;

      
      StructuredBuffer<Vert> _VertBuffer;
      StructuredBuffer<Vert2> _SkeletonBuffer;


      //uniform float4x4 worldMat;

      //A simple input struct for our pixel shader step containing a position.
      struct varyings {
          float4 pos      : SV_POSITION;
          float3 nor      : TEXCOORD0;
          float3 worldPos : TEXCOORD1;
          float3 eye      : TEXCOORD2;
          float3 debug    : TEXCOORD3;
          float2 uv       : TEXCOORD4;
          float2 uv2       : TEXCOORD6;
          float id        : TEXCOORD5;
      };


float _Multiplier;

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

      Vert v = _VertBuffer[int(float(base)/_Multiplier)];
      Vert2 s = _SkeletonBuffer[int(float(base)/ _Multiplier)];

      float3 dif = -(v.pos - s.pos);
      l = normalize(cross( dif, cross(l,u) )) * _Size;


    
    float2 uv = float2(0,0);

    if( alternate == 0 ){ extra = -l ; uv = float2(0,0); }
    if( alternate == 1 ){ extra =  l ; uv = float2(1,0); }
    if( alternate == 2 ){ extra =  l + dif; uv = float2(1,1); }
    if( alternate == 3 ){ extra = -l ; uv = float2(0,0); }
    if( alternate == 4 ){ extra =  l + dif; uv = float2(1,1); }
    if( alternate == 5 ){ extra = -l + dif; uv = float2(0,1); }


      o.worldPos = (v.pos) + extra;
      o.eye = _WorldSpaceCameraPos - o.worldPos;
      o.nor =v.nor;
      o.uv = v.uv;
      o.uv2 = uv;
      o.id = base;
      o.pos = mul (UNITY_MATRIX_VP, float4(o.worldPos,1.0f));

  }

  return o;

}



      //Pixel function returns a solid color for each point.
      float4 frag (varyings v) : COLOR {

          if( length( v.uv2 -.5) > .5 ){ discard;}
          return float4(_Color,1 );
      }

      ENDCG

    }
  }


}
