Shader "IMMAT/Basic/NormalFlat16"
{
    
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Cull Off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.5
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"


              struct Vert{
      float3 pos;
      float3 vel;
      float3 nor;
      float3 tan;
      float2 uv;
      float2 debug;
    };


            struct v2f { float4 pos : SV_POSITION; float3 nor : NORMAL;float3 world : TEXCOORD0; };
            float4 _Color;

            StructuredBuffer<Vert> _VertBuffer;
            StructuredBuffer<int> _TriBuffer;

            v2f vert ( uint vid : SV_VertexID )
            {
                v2f o;
                Vert v = _VertBuffer[_TriBuffer[vid]];
                o.pos = mul (UNITY_MATRIX_VP, float4(v.pos,1.0f));
                o.nor = v.nor;
                o.world = v.pos;
                return o;
            }

            fixed4 frag (v2f v) : SV_Target
            {

                float3 nor = -cross(normalize(ddx(v.world)),normalize(ddy(v.world)));
                // sample the texture
                fixed4 col = float4( nor * .5 + .5 , 1);//tex2D(_MainTex, i.uv);
                return col;
            }

            ENDCG
        }
    }
}