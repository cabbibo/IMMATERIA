
Shader "Debug/idHueDebug" {
    Properties {

    _HueSize ("HueSize", float) = .01
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
      #include "../Chunks/hsv.cginc"
      #include "../Chunks/Struct16.cginc"
      #include "../Chunks/debugVSChunk.cginc"

float _HueSize;

//Pixel function returns a solid color for each point.
float4 frag (varyings v) : COLOR {

    float3 col = hsv( v.id * _HueSize , 1, 1);
    return float4(col,1 );
}


      ENDCG

    }
  }

  Fallback Off


}
