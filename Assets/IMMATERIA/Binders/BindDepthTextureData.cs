using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class BindDepthTextureData : Binder
{

  public DepthRenderer depthRenderer;

  public override void Bind(){

    toBind.BindTexture("_DepthTexture",() => depthRenderer.texture);
  
    toBind.BindInt("_RenderSize",() => depthRenderer.renderSize);
    toBind.BindFloat("_CameraSize",() => depthRenderer.camSize);
    toBind.BindMatrix("_CameraMatrix",() => depthRenderer.cam.transform.localToWorldMatrix );
    toBind.BindFloat("_CameraNear",() => depthRenderer.cam.nearClipPlane );
    toBind.BindFloat("_CameraFar",() => depthRenderer.cam.farClipPlane );

  }

}
}
