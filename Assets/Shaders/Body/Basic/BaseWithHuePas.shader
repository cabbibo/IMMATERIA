Shader "Base/MultiMaterial/hue/36"
{
    
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
            #pragma target 4.5
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"


            #include "../Chunks/Struct36.cginc"
            #include "../Chunks/hsv.cginc"

            int _SubMeshID;
            int _BaseID;


            struct v2f { float4 pos : SV_POSITION; float3 nor : NORMAL; };
            float4 _Color;

            StructuredBuffer<Vert> _VertBuffer;
            StructuredBuffer<int> _TriBuffer;

            v2f vert ( uint vid : SV_VertexID )
            {
                v2f o;
                Vert v = _VertBuffer[_TriBuffer[vid + _BaseID]];
                o.pos = mul (UNITY_MATRIX_VP, float4(v.pos,1.0f));
                o.nor = v.nor;
                return o;
            }


            float3 nor;

            float3 DoBeltBuckle(){
                return float3(0,0,1);
            }

            float3 DoBelt(){
                return float3(0,.3,.5);
            }

            float3 DoHair(){
                return float3(0,.5,1);//nor * .5 + .5;
            }

            float3 DoEyes(){
                return 1;
            }
            float3 DoPants(){
                return float3(1,.4,.2);
            }

            float3 DoShirtShoes(){
                return float3( .4, .8,1);
            }
            
            float3 DoSkin(){
                return float3( .5 , .3,.2);
            }

            float3 DoSocks(){
                return DoSkin();//float3( .5 , .3,.2);
            }

           

            fixed4 frag (v2f v) : SV_Target
            {

                float3 col = 0;
                nor = v.nor;


                if( _SubMeshID == 0 ){
                    col = DoEyes();
                }else if( _SubMeshID == 1 ){
                    col = DoHair();
                }else if( _SubMeshID == 2 ){
                    col = DoBeltBuckle();
                }else if( _SubMeshID == 3 ){
                    col = DoBelt();
                }else if( _SubMeshID == 4 ){
                    col = DoPants();
                }else if( _SubMeshID == 5 ){
                    col = DoShirtShoes();
                }else if( _SubMeshID == 6 ){
                    col = DoSocks();
                }else if( _SubMeshID == 7 ){
                    col = DoSkin();
                }


                  return fixed4( col,1);
            }

            ENDCG
        }
    }
}
