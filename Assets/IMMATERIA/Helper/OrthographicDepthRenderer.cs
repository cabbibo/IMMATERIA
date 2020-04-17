using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class OrthographicDepthRenderer : Cycle
{

  public int renderSize;
  public int camSize;
  public RenderTexture texture;
  
  public string layerToRender;


  public Renderer debugRenderer;
  public Camera cam;



  private RenderTextureDescriptor textureDescriptor;

  public override void Create(){
    textureDescriptor = new RenderTextureDescriptor( renderSize,renderSize,RenderTextureFormat.Depth,24);
    texture = RenderTexture.GetTemporary( textureDescriptor );
    Set();
  }

  public override void WhileLiving(float v ){
    Set();
  }



  public void Set(){
   

 
    cam.targetTexture = texture;
    cam.orthographicSize = camSize; 
    cam.depthTextureMode = DepthTextureMode.DepthNormals;
    ///print( texture.depth);
    cam.SetTargetBuffers( texture.colorBuffer , texture.depthBuffer );
    cam.Render();


if( debugRenderer ){
     debugRenderer.sharedMaterial.SetTexture("_MainTex", texture );
    debugRenderer.transform.localScale = Vector3.one * cam.orthographicSize * 2;
}

 // RenderTexture.ReleaseTemporary( texture );
 

  }


}
}
