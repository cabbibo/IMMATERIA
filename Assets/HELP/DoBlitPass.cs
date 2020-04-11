using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class DoBlitPass : MonoBehaviour {

  public Shader shader;
  float bw;

  private RenderTexture tmp;
  public Material material;
  // Creates a private material used to the effect
  void Awake(){
  }
  
  // Postprocess the image
  void OnRenderImage (RenderTexture source, RenderTexture destination){

    material.SetFloat("_Width" , source.width);
    material.SetFloat("_Height" , source.height);
    material.SetFloat("_BW" , bw );
    Graphics.Blit(source, destination, material);
  }

  public void Swap(){

    if( bw == 0 ){ bw = 1; }else{ bw = 0; }

  }

}