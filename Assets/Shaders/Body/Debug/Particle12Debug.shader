
Shader "Debug/Particles12" {
    Properties {

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
      #include "../Chunks/Struct12.cginc"
      #include "../Chunks/debugVSChunk.cginc"



//Pixel function returns a solid color for each point.
float4 frag (varyings v) : COLOR {
    return float4(_Color,1 );
}

      ENDCG

    }
  }

  Fallback Off


}
