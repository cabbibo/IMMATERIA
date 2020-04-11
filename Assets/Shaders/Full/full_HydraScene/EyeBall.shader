// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Scenes/HydraScene/Eyeball" {

  Properties {
  


    _NumberSteps( "Number Steps", Int ) = 3

    _TotalDepth( "Total Depth", Float ) = 0.16


    
    _ColorMap ("Color Map", 2D) = "white" {}
    _ColorStart( "_ColorStart", Float ) = 0.16
    _ColorDepth( "_ColorDepth", Float ) = 0.16
    _BackColor( "_BackColor", Float ) = 0.16


  }

  SubShader {


    Pass {
// Lighting/ Texture Pass
Stencil
{
Ref 5
Comp always
Pass replace
ZFail keep
}
        CULL Back
      CGPROGRAM

      #pragma vertex vert
      #pragma fragment frag

      #include "UnityCG.cginc"
      #include "../../Chunks/noise.cginc"
      #include "../../Chunks/hsv.cginc"


      uniform int _NumberSteps;
      uniform float _TotalDepth;

      uniform float3 _EyePos;
      uniform float _ColorStart;
      uniform float _ColorDepth;
      uniform sampler2D _ColorMap;


      struct VertexIn{
         float4 position  : POSITION; 
         float3 normal    : NORMAL; 
         float4 texcoord  : TEXCOORD0; 
         float4 tangent   : TANGENT;
      };


      struct VertexOut {
          float4 pos        : POSITION; 
          float3 normal     : NORMAL; 
          float4 uv         : TEXCOORD0; 
          float3 ro         : TEXCOORD1;
          float3 rd         : TEXCOORD2;
          float3 eyePos     : TEXCOORD3;
      };


      float getFogVal( float3 pos  , float3 eyePos ){

        float d = length( pos - eyePos );

        if( d < .3 + noise( pos * 20 ) * .1 ){ return 0; }else{ return .4 + noise( pos * 20 ) * .3; }
        //return noise( pos * 20 ) * 1+d*2;//abs( sin( pos.x * 40) + sin(pos.y * 40 ) + sin( pos.z * 40 ))*d * 4.;
      }
      
      VertexOut vert(VertexIn v) {
        
        VertexOut o;

        o.normal = v.normal;

        o.uv = v.texcoord;
       
  
        // Getting the position for actual position
        o.pos = UnityObjectToClipPos(  v.position );
     
        float3 mPos = mul( unity_ObjectToWorld , v.position );

        // The ray origin will be right where the position is of the surface
        o.ro = v.position;


        float3 camPos = mul( unity_WorldToObject , float4( _WorldSpaceCameraPos , 1. )).xyz;

        o.eyePos = mul( unity_WorldToObject , float4( _EyePos , 1. )).xyz;

        // the ray direction will use the position of the camera in local space, and 
        // draw a ray from the camera to the position shooting a ray through that point
        o.rd = normalize( v.position.xyz - camPos );

        return o;

      }

      // Fragment Shader
      fixed4 frag(VertexOut v) : COLOR {

                // Ray origin 
        float3 ro           = v.ro;

        // Ray direction
        float3 rd           = v.rd;       

        // Our color starts off at zero,   
        float3 col = float3( 0.0 , 0.0 , 0.0 );

        // the accumulation of our stepping through the object
        float  hit = 0;

        float3 p;

        [unroll(10)]
        for( int i = 0; i < _NumberSteps; i++ ){

            // We get out position by adding the ray direction to the ray origin
            // Keep in mind thtat because the ray direction is normalized, the depth
            // into the step will be defined by our number of steps and total depth
          p = ro + rd * float( i ) * _TotalDepth / _NumberSteps;
    
    
           // We get our value of how much of the volumetric material we have gone through
           // using the position
           float val = getFogVal( p , v.eyePos ); 


                    // Here we basically say 
                    // 'only care about this if we hit enough fog'
          if( val > .5 ){
            hit = 1;
            col = tex2D(_ColorMap, float2( (float(i)/float(_NumberSteps)) *_ColorDepth  + _ColorStart , 0)).xyz;//float3( 1 ,1,1 ) * float(i);
            break;
          }


        }



        //col /= _NumberSteps;
        if( hit == 0 ){  discard; }



            fixed4 color;
        color = fixed4( col , 1. );
        return color;
      }

      ENDCG
    }



    Pass {
// Outline Pass
Cull OFF
ZWrite OFF
ZTest ON
Stencil
{
Ref 5
Comp notequal
Fail keep
Pass replace
}
        CULL Back
      CGPROGRAM

      #pragma vertex vert
      #pragma fragment frag

      #include "UnityCG.cginc"

      struct VertexIn{
         float4 position  : POSITION; 
         float3 normal    : NORMAL; 
      };


      struct VertexOut {
          float4 pos        : POSITION; 
      };
      VertexOut vert(VertexIn v) {
        
        VertexOut o;
        // Getting the position for actual position
        o.pos = UnityObjectToClipPos(  v.position + v.normal * .02f );
    

        return o;

      }

      // Fragment Shader
      fixed4 frag(VertexOut v) : COLOR {


            fixed4 color;
        color = 1;//fixed4( 1 , 1. );
        return color;
      }

      ENDCG
    }




    Pass {

// Lighting/ Texture Pass
Stencil
{
Ref 5
Comp always
Pass replace
ZFail keep
}
    CULL Front
      CGPROGRAM

      #pragma vertex vert
      #pragma fragment frag

      #include "UnityCG.cginc"
      #include "../../Chunks/noise.cginc"


      uniform int _NumberSteps;
      uniform float _TotalDepth;

      uniform float3 _EyePos;

      uniform float _BackColor;
      uniform sampler2D _ColorMap;

      struct VertexIn{
         float4 position  : POSITION; 
         float3 normal    : NORMAL; 
         float4 texcoord  : TEXCOORD0; 
         float4 tangent   : TANGENT;
      };


      struct VertexOut {
          float4 pos        : POSITION; 
          float3 normal     : NORMAL; 
          float4 uv         : TEXCOORD0; 
          float3 ro         : TEXCOORD1;
          float3 rd         : TEXCOORD2;
          float3 eyePos     : TEXCOORD3;
      };


      float getFogVal( float3 pos  , float3 eyePos ){

        float d = length( pos - eyePos );

        return noise( pos * 20 ) * 1+d;//abs( sin( pos.x * 40) + sin(pos.y * 40 ) + sin( pos.z * 40 ))*d * 4.;
      }
      
      VertexOut vert(VertexIn v) {
        
        VertexOut o;

        o.normal = v.normal;

        o.uv = v.texcoord;
       
  
        // Getting the position for actual position
        o.pos = UnityObjectToClipPos(  v.position );
     
        float3 mPos = mul( unity_ObjectToWorld , v.position );

        // The ray origin will be right where the position is of the surface
        o.ro = v.position;


        float3 camPos = mul( unity_WorldToObject , float4( _WorldSpaceCameraPos , 1. )).xyz;

        o.eyePos = mul( unity_WorldToObject , float4( _EyePos , 1. )).xyz;

        // the ray direction will use the position of the camera in local space, and 
        // draw a ray from the camera to the position shooting a ray through that point
        o.rd = normalize( v.position.xyz - camPos );

        return o;

      }

      // Fragment Shader
      fixed4 frag(VertexOut v) : COLOR {

        float4 color =  tex2D(_ColorMap, float2( _BackColor , 0));
        return color;
      }

      ENDCG
    }
  }
  
  //FallBack "Diffuse"
}