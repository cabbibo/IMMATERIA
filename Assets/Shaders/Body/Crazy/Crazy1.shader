Shader "IMMAT/Crazy/Rainbow1"
{
    Properties {
        _ColorMap("_ColorMap", 2D) = "white" {}
        _Steps("_Steps", Int) = 5
        _ColorMapStart("_ColorMapStart",float) = 0
        _ColorMapSize("_ColorMapSize",float) = 0
        _OutlineWidth("_OutlineWidth",float) = 0
        _OutlineHue("_OutlineHue", float ) = .5
        
        _Multiplier("_Multiplier", float ) = 1
        _BumpMap("_BumpMap", 2D) = "white" {}
    }
    SubShader
    {
        
        
        Pass
        {

            Stencil
            {
                Ref 9
                Comp always
                Pass replace
                ZFail keep
            }

        Tags { "RenderType"="Opaque" }
        LOD 100

        Cull Off

          Tags{ "LightMode" = "ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.5
            // make fog work
            #pragma multi_compile_fogV
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"

            #include "../../Chunks/Struct16.cginc"
            #include "../../Chunks/hsv.cginc"

            sampler2D _MainTex;
            sampler2D _ColorMap;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;

            int _Steps;
            float _ColorMapStart;
            float _ColorMapSize;

            struct v2f { 
              float4 pos : SV_POSITION; 
              float3 nor : NORMAL;
              float2 uv :TEXCOORD0; 
              float3 worldPos :TEXCOORD1;
              float2 debug : TEXCOORD3;
              float3 eye : TEXCOORD4;
             LIGHTING_COORDS(5,6) 
                 half3 tspace0 : TEXCOORD7; // tangent.x, bitangent.x, normal.x
                half3 tspace1 : TEXCOORD8; // tangent.y, bitangent.y, normal.y
                half3 tspace2 : TEXCOORD9; // tangent.z, bitangent.z, normal.z
            };
            float4 _Color;
            float _Multiplier;

            StructuredBuffer<Vert> _VertBuffer;
            StructuredBuffer<int> _TriBuffer;

            v2f vert ( uint vid : SV_VertexID )
            {
                v2f o;

                UNITY_INITIALIZE_OUTPUT(v2f, o);
                Vert v = _VertBuffer[_TriBuffer[vid]];
                o.pos = mul (UNITY_MATRIX_VP, float4(v.pos,1.0f));

                o.nor = v.nor;
                o.uv = TRANSFORM_TEX(v.uv,_BumpMap).xy;
                o.worldPos = v.pos;
                o.debug = v.debug;
                o.eye = v.pos - _WorldSpaceCameraPos;


                half3 wNormal = v.nor;//UnityObjectToWorldNormal(normal);
                half3 wTangent = v.tan;//UnityObjectToWorldDir(tangent.xyz);
                half3 wBitangent = normalize(cross(wNormal, wTangent));// * tangentSign;
                // output the tangent space matrix
                o.tspace0 = half3(wTangent.x, wBitangent.x, wNormal.x);
                o.tspace1 = half3(wTangent.y, wBitangent.y, wNormal.y);
                o.tspace2 = half3(wTangent.z, wBitangent.z, wNormal.z);

                UNITY_TRANSFER_LIGHTING(o,o.worldPos);


                return o;
            }

   // normal map texture from shader properties

            fixed4 frag (v2f v) : SV_Target
            {

                      // sample the normal map, and decode from the Unity encoding
                half3 tnormal = UnpackNormal(tex2D(_BumpMap, v.uv));
                // transform normal from tangent to world space
                half3 worldNormal;
                worldNormal.x = dot(v.tspace0, tnormal);
                worldNormal.y = dot(v.tspace1, tnormal);
                worldNormal.z = dot(v.tspace2, tnormal);


                    half3 worldViewDir = normalize(UnityWorldSpaceViewDir(v.worldPos));
         half3 worldRefl = reflect(-worldViewDir, worldNormal);
         half4 skyData =UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldRefl);
         half3 skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);
//

                fixed shadow = UNITY_SHADOW_ATTENUATION(v,v.worldPos);
                float val = dot( reflect(worldNormal,normalize(v.eye)) , _WorldSpaceLightPos0.xyz);
                val += dot( worldNormal , normalize( v.eye));
                float3 col = tex2D(_ColorMap, val * _ColorMapSize + _ColorMapStart + _Time.y ) ;
                col *= skyColor*2 * _Multiplier;
                return float4(col,1);
            }

            ENDCG
        }

// Shadow Pass
    Pass
    {
      Tags{ "LightMode" = "ShadowCaster" }


      Fog{ Mode Off }
      ZWrite On
      ZTest LEqual
      Cull Off
      Offset 1, 1
      CGPROGRAM

      #pragma target 4.5
      #pragma vertex vert
      #pragma fragment frag
      #pragma multi_compile_shadowcaster
      #pragma fragmentoption ARB_precision_hint_fastest

      #include "UnityCG.cginc"
      #include "../../Chunks/Shadow16.cginc"
      ENDCG
    }
    
  
 Pass
    {
 Tags { "RenderType"="Opaque" }

            // Outline Pass
            Cull OFF
            ZWrite OFF
            ZTest ON
            Stencil
            {
            Ref 9
            Comp notequal
            Fail keep
            Pass replace
            }
      
            CGPROGRAM

            
        #pragma vertex vert
        #pragma fragment frag
        #pragma target 4.5
        #include "UnityCG.cginc"
        #include "../../Chunks/Struct16.cginc"



        StructuredBuffer<Vert> _VertBuffer;
        StructuredBuffer<int> _TriBuffer;
            // make fog work
            #pragma multi_compile_fogV
             #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight

            #include "AutoLight.cginc"
    


            struct v2f { 
              float4 pos : SV_POSITION; 
            };
            float4 _Color;
            float _OutlineWidth;
            float _OutlineHue;
            v2f vert ( uint vid : SV_VertexID )
            {
                v2f o;

        
                Vert v = _VertBuffer[_TriBuffer[vid]];
                float3 fPos = v.pos + v.nor * _OutlineWidth;
                o.pos = mul (UNITY_MATRIX_VP, float4(fPos,1.0f));


                return o;
            }

            sampler2D _ColorMap;
            fixed4 frag (v2f v) : SV_Target
            {
              
                fixed4 col = _OutlineHue;//tex2D(_ColorMap, float2( _OutlineHue-_Time.y,0));
                return col;
            }

            ENDCG
        }

    
  

  
    }
}
