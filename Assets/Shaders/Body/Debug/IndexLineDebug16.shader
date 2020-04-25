Shader "IMMAT/Debug/IndexLine16" {
	Properties {
  	_Color ("Color", Color) = (1,1,1,1)
	}


  SubShader{

    Pass{

		  CGPROGRAM

		  #pragma target 4.5

		  #pragma vertex vert
		  #pragma fragment frag

		  #include "UnityCG.cginc"


      
		  #include "../../Chunks/Struct16.cginc"
      #include "../../Chunks/lineIndexDebug.cginc"




      ENDCG

    }
  }

  Fallback Off


}
