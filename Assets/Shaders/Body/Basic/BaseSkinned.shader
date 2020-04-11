Shader "Base/StraightColor/36"
{
    Properties
    {

        _Color( "Color" , color ) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Cull Off
        Pass
        {
            CGPROGRAM
            #pragma target 4.5
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"


            #include "../Chunks/Struct36.cginc"
            #include "../Chunks/baseColorVSChunk.cginc"

            ENDCG
        }
    }
}
