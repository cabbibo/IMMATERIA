Shader "IMMAT/Basic/Color12"
{
    Properties
    {

        _Color( "Color" , color ) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

       // Cull Off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"


            #include "../../Chunks/Struct12.cginc"
            #include "../../Chunks/baseColorVSChunk.cginc"

            ENDCG
        }
    }
}
