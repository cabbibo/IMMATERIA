using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class DepthRenderer : Cycle
{

  public int renderSize;
  public int camSize;
  public RenderTexture texture;
  
  public string layerToRender;


  public Renderer debugRenderer;
  public Camera cam;




  private RenderTextureDescriptor textureDescriptor;

  public override void Create(){
    
    Set();
  }

  public override void WhileLiving(float v ){
    Set();
  }



  public void Set(){
    
    textureDescriptor = new RenderTextureDescriptor( renderSize,renderSize,RenderTextureFormat.Depth,24);
    texture = RenderTexture.GetTemporary( textureDescriptor );
    cam.orthographicSize = camSize; 
    //cam.depthTextureMode = DepthTextureMode.Depth;
    cam.SetTargetBuffers( texture.colorBuffer , texture.depthBuffer );
    cam.Render();

    debugRenderer.sharedMaterial.SetTexture("_MainTex", texture );
    debugRenderer.transform.localScale = Vector3.one * cam.orthographicSize * 2;

  RenderTexture.ReleaseTemporary( texture );

  }


}
}
