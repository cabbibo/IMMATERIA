Shader "Debug/TriConnectedDebug" {
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
      #include "../Chunks/debugVSChunk.cginc"



      //Pixel function returns a solid color for each point.
      float4 frag (varyings v) : COLOR {

          if( length( v.uv2 -.5) > .5 ){ discard;}
          return float4(_Color,1 );
      }

      ENDCG

    }
  }


}
