


float4 ShadowCasterPos (float3 vertex, float3 normal) {
  float4 clipPos;
    
    // Important to match MVP transform precision exactly while rendering
    // into the depth texture, so branch on normal bias being zero.
    if (unity_LightShadowBias.z != 0.0) {
      float3 wPos = vertex.xyz;
      float3 wNormal = normal;
      float3 wLight = normalize(UnityWorldSpaceLightDir(wPos));

    // apply normal offset bias (inset position along the normal)
    // bias needs to be scaled by sine between normal and light direction
    // (http://the-witness.net/news/2013/09/shadow-mapping-summary-part-1/)
    //
    // unity_LightShadowBias.z contains user-specified normal offset amount
    // scaled by world space texel size.

      float shadowCos = dot(wNormal, wLight);
      float shadowSine = sqrt(1 - shadowCos * shadowCos);
      float normalBias = unity_LightShadowBias.z * shadowSine;

      wPos -= wNormal * normalBias;

      clipPos = mul(UNITY_MATRIX_VP, float4(wPos, 1));
    }else {
        clipPos = UnityObjectToClipPos(vertex);
    }
  return clipPos;
}
