Shader "IMMAT/Painterly/painterly16"
{
    Properties {

        _ColorMap ("ColorMap", 2D) = "white" {}
        _TextureMap ("TextureMap", 2D) = "white" {}
        _NormalMap ("NormalMap", 2D) = "white" {}
        _ShinyMap ("ShinyMap", 2D) = "white" {}

        
        _PLightMap("Painterly Light Map", 2D) = "white" {}
        _CubeMap( "Cube Map" , Cube )  = "defaulttexture" {}

        _ColorStart("_ColorStart",float) = 0
        _ColorRandomSize("_ColorRandomSize",float) = 0
        _ColorStart("_ColorStart",float) = 0
        _Saturation("_Saturation",float) = .3
        _Brightness("_Brightness",float) = .1


        _OutlineAmount("_OutlineAmount",float) = .3
        _OutlineHue("_OutlineHue",float) = .1
        
        
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Cull Off
        Pass
        {

            Stencil
            {
                Ref 9
                Comp always
                Pass replace
                ZFail keep
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.5
            #include "UnityCG.cginc"

            #pragma multi_compile_fwdbase
            #pragma fragmentoption ARB_precision_hint_fastest

            #include "AutoLight.cginc"

            #include "../../Chunks/Struct16.cginc"


            struct v2f { 
                float4 pos : SV_POSITION; 
                float3 nor : NORMAL; 
                float3 world : TEXCOORD1; 
                float2 uv  : TEXCOORD2; 
                float2 debug  : TEXCOORD3; 
                half3 tspace0 : TEXCOORD11; // tangent.x, bitangent.x, normal.x
                half3 tspace1 : TEXCOORD12; // tangent.y, bitangent.y, normal.y
                half3 tspace2 : TEXCOORD13; // tangent.z, bitangent.z, normal.z
                half3 tang : TEXCOORD14; // tangent.z, bitangent.z, normal.z
                // in v2f struct;
                LIGHTING_COORDS(5,6)

            };
            float4 _Color;

            StructuredBuffer<Vert> _VertBuffer;
            StructuredBuffer<int> _TriBuffer;


            sampler2D _ColorMap;
            sampler2D _TextureMap;
            sampler2D _ShinyMap;
            sampler2D _NormalMap;

            
            sampler2D _PLightMap;


            samplerCUBE _CubeMap;

            float _ColorStart;
            float _ColorRandomSize;
            float _Saturation;
            float _Brightness;

            v2f vert ( uint vid : SV_VertexID )
            {
                v2f o;
                Vert v = _VertBuffer[_TriBuffer[vid]];
                o.pos = mul (UNITY_MATRIX_VP, float4(v.pos,1.0f));
                o.uv = v.uv;
                o.nor = v.nor;
                o.world = v.pos;
                o.debug = v.debug;

                half3 wNormal = v.nor;
                half3 wTangent = v.tan;
                // compute bitangent from cross product of normal and tangent
                //half tangentSign = tangent.w * unity_WorldTransformParams.w;
                half3 wBitangent = cross(wNormal, wTangent);// * tangentSign;
                // output the tangent space matrix
                o.tspace0 = half3(wTangent.x, wBitangent.x, wNormal.x);
                o.tspace1 = half3(wTangent.y, wBitangent.y, wNormal.y);
                o.tspace2 = half3(wTangent.z, wBitangent.z, wNormal.z);


                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            fixed4 frag (v2f v) : SV_Target
            {


                // sample the normal map, and decode from the Unity encoding
                half3 tnormal =UnpackNormal(tex2D(_NormalMap, v.uv));// lerp( i.norm ,  , specMap.x);
                // transform normal from tangent to world space
                half3 worldNormal;
                worldNormal.x = dot(v.tspace0, tnormal);
                worldNormal.y = dot(v.tspace1, tnormal);
                worldNormal.z = dot(v.tspace2, tnormal);

                worldNormal = v.nor;

                // worldNormal = lerp( v.nor , worldNormal , tCol.x);
                
                half3 worldViewDir = normalize(UnityWorldSpaceViewDir(v.world));
                //half3 worldRefl = reflect(-worldViewDir, worldNormal);
                half3 worldRefl = refract(worldViewDir, worldNormal,.8);
                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, -worldRefl);
                half3 skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);



                float3 tCol = texCUBE(_CubeMap,worldRefl);
                float3 fNor = normalize(v.nor);
                float m = 1-dot(_WorldSpaceLightPos0.xyz , fNor);

                

                ///in frag shader;
                float atten = LIGHT_ATTENUATION(v);
                //m = 1-pow(-fern,.5);//*fern*fern;//pow( fern * fern, 1);
                //m = saturate( 1-m );

                //                m = (-m* atten);

                float4 p = tex2D( _PLightMap , v.uv * 3 );
                m = 1-((1-m)*atten);
                m *= 3;

                float4 fLCol = float4(1,0,0,0);


                float4 weights = 0;
                if( m < 1 ){
                    weights = float4(1-m , m , 0, 0);//lerp( p.x , p.y , m );
                    }else if( m >= 1 && m < 2){
                    weights = float4(0,1-(m-1) , (m-1) ,  0);
                    }else if( m >= 2 && m < 3){
                    weights = float4(0,0,1-(m-2) , (m-2) );
                    }else{
                    weights = float4(0,0,0 , 1);
                }



                fLCol = p.x * weights.x;
                fLCol += p.y * weights.y;
                fLCol += p.z * weights.z;
                fLCol += p.w * weights.w;
                fLCol = 1-fLCol;
                // sample the texture


                float4 s3 = tex2D( _TextureMap , v.uv );
                float4 s2 = tex2D( _ColorMap , float2(  sin(v.debug.x) * _ColorRandomSize + _ColorStart + v.debug.x * .2, 0) );
                float3 shiny = tex2D(_ShinyMap,v.uv);

                float3 fCol=lerp( pow(length(tCol),3)* .3* s2*3, pow(length(tCol),3) * .1 * s2 ,shiny.x)  *_Saturation + _Brightness;//*shiny.x * fLCol;//fLCol*s3* skyColor;//v.nor * .5 + .5;
                
                fCol*= fLCol * 3;


                fCol = fLCol;// skyColor;
                //fCol = v.debug.x;
                fixed4 col = float4(fCol,1);//fLCol;//float4( i.nor * .5 + .5 , 1);//tex2D(_MainTex, i.uv);
                return col;
            }

            ENDCG
        }

        // SHADOW PASS

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
            

            #include "../../Chunks/ShadowCasterPos.cginc"


            struct Vert{
                float3 pos;
                float3 vel;
                float3 nor;
                float3 tan;
                float2 uv;
                float2 debug;
            };



            StructuredBuffer<Vert> _VertBuffer;
            StructuredBuffer<int> _TriBuffer;

            struct v2f {
                V2F_SHADOW_CASTER;
                float3 nor : NORMAL;
            };


            v2f vert(appdata_base input, uint id : SV_VertexID)
            {
                v2f o;
                Vert v = _VertBuffer[_TriBuffer[id]];
                o.nor = normalize( v.nor);
                float4 position = ShadowCasterPos(v.pos, normalize(v.nor));
                o.pos = UnityApplyLinearShadowBias(position);
                return o;
            }

            float4 frag(v2f i) : COLOR
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }


        Pass
        {

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
            // make fog work
            #pragma multi_compile_fogV
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            


            struct Vert{
                float3 pos;
                float3 vel;
                float3 nor;
                float3 tan;
                float2 uv;
                float2 debug;
            };


            struct v2f { 
                float4 pos : SV_POSITION; 
            };
            float4 _Color;

            StructuredBuffer<Vert> _VertBuffer;
            StructuredBuffer<int> _TriBuffer;

            float _OutlineHue;
            float _OutlineAmount;

            v2f vert ( uint vid : SV_VertexID )
            {
                v2f o;

                
                Vert v = _VertBuffer[_TriBuffer[vid]];
                float3 fPos = v.pos + v.nor * _OutlineAmount;
                o.pos = mul (UNITY_MATRIX_VP, float4(fPos,1.0f));


                return o;
            }

            sampler2D _ColorMap;
            fixed4 frag (v2f v) : SV_Target
            {
                
                fixed4 col = tex2D(_ColorMap, float2( _OutlineHue,0));
                return col;
            }

            ENDCG
        }

        
        

        
        
    }

    FallBack "Diffuse"
}