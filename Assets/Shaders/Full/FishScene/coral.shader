// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'unity_World2Shadow' with 'unity_WorldToShadow'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Scenes/FishScene/Coral1"
{
    Properties {
        // normal map texture on the material,
        // default to dummy "flat surface" normalmap
        _BumpMap("Normal Map", 2D) = "bump" {}
        _SpecMap("specMap", 2D) = "bump" {}
        _ColorMap("Color Map", 2D) = "bump" {}
    }
    SubShader
    {
        Pass
        {

            Tags { "LightMode" = "ForwardBase" }
         
            Cull Off
            CGPROGRAM


        #pragma vertex vert
 #pragma fragment frag
 #pragma multi_compile_fwdbase
 #include "AutoLight.cginc"
 #include "UnityCG.cginc"



 
   

            struct v2f {
                float3 worldPos : TEXCOORD0;
                // these three vectors will hold a 3x3 rotation matrix
                // that transforms from tangent to world space
                half3 tspace0 : TEXCOORD1; // tangent.x, bitangent.x, normal.x
                half3 tspace1 : TEXCOORD2; // tangent.y, bitangent.y, normal.y
                half3 tspace2 : TEXCOORD3; // tangent.z, bitangent.z, normal.z
                half3 norm : TEXCOORD4; // tangent.z, bitangent.z, normal.z
                // texture coordinate for the normal map
                float2 uv : TEXCOORD5;
                float4 pos : SV_POSITION;
                float4 _ShadowCoord : TEXCOORD6;
                // in v2f struct;
//LIGHTING_COORDS(7,8) // replace 0 and 1 with the next available TEXCOORDs in your shader, don't put a semicolon at the end of this line.
 
            };

            // vertex shader now also needs a per-vertex tangent vector.
            // in Unity tangents are 4D vectors, with the .w component used to
            // indicate direction of the bitangent vector.
            // we also need the texture coordinate.
            v2f vert (float4 vertex : POSITION, float3 normal : NORMAL, float4 tangent : TANGENT, float2 uv : TEXCOORD0)
            {
                v2f o;


                o.pos = UnityObjectToClipPos(vertex);
                o.worldPos = mul(unity_ObjectToWorld, vertex).xyz;
                half3 wNormal = UnityObjectToWorldNormal(normal);
                half3 wTangent = UnityObjectToWorldDir(tangent.xyz);
                // compute bitangent from cross product of normal and tangent
                half tangentSign = tangent.w * unity_WorldTransformParams.w;
                half3 wBitangent = cross(wNormal, wTangent) * tangentSign;
                // output the tangent space matrix
                o.tspace0 = half3(wTangent.x, wBitangent.x, wNormal.x);
                o.tspace1 = half3(wTangent.y, wBitangent.y, wNormal.y);
                o.tspace2 = half3(wTangent.z, wBitangent.z, wNormal.z);
                o.norm = wNormal;
                o.uv = uv;


                o._ShadowCoord = mul( unity_WorldToShadow[0], mul( unity_ObjectToWorld, vertex ) );
               //TRANSFER_VERTEX_TO_FRAGMENT(o); 
                return o;
            }

            // normal map texture from shader properties
            sampler2D _BumpMap;
            sampler2D _SpecMap;
            sampler2D _ColorMap;
        
            fixed4 frag (v2f i) : SV_Target
            {

                float atten = LIGHT_ATTENUATION(i);
                float4 specMap = tex2D(_SpecMap, i.uv);

                // sample the normal map, and decode from the Unity encoding
                half3 tnormal = UnpackNormal(tex2D(_BumpMap, i.uv));// lerp( i.norm ,  , specMap.x);
                // transform normal from tangent to world space
                half3 worldNormal;
                worldNormal.x = dot(i.tspace0, tnormal);
                worldNormal.y = dot(i.tspace1, tnormal);
                worldNormal.z = dot(i.tspace2, tnormal);


                //worldNormal = lerp( i.norm , worldNormal , specMap.a );


                // rest the same as in previous shader
                half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                //half3 worldRefl = reflect(-worldViewDir, worldNormal);
                half3 worldRefl = refract(worldViewDir, worldNormal,.8);
                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldRefl);
                half3 skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);
                fixed4 c = 0;

                float3 cMap = tex2D(_ColorMap , float2(dot( worldRefl , _WorldSpaceLightPos0 ) * .3 + atten * .1 + .4, 0 ));
                float3 cMap2 = tex2D(_ColorMap , float2(skyColor.x * 1.1+ 0, 0 )) * skyColor.x;
                c.rgb = skyColor;
                float m =  dot( worldNormal , _WorldSpaceLightPos0);
                c.rgb = cMap * skyColor * ( atten * .3 + .7);//*lerp( cMap2,  cMap * c , 0*specMap.x) + tex2D(_ColorMap , float2(m , 0 )) * m;// * (1-specMap);

               // c.rgb = specMap;
                return c;
            }
            

            ENDCG

        }


    }

    FallBack "Diffuse"
}