using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
namespace IMMATERIA {
public class AddTransformBufferToMaterial : Cycle {


  public TransformBuffer transforms;

  public Material material;

  public Renderer self;

  public Renderer[] renderers;
  public MaterialPropertyBlock mpb;

  public override void _Create(){

    if( mpb == null ){ mpb = new MaterialPropertyBlock(); }
    
    
    mpb.SetInt("_TransformBuffer_COUNT", transforms.count);
    mpb.SetBuffer("_TransformBuffer", transforms._buffer );

    self = GetComponent<Renderer>();

    self.SetPropertyBlock( mpb );

    for( int i = 0; i < renderers.Length; i++ ){
      renderers[i].material = material;
      renderers[i].SetPropertyBlock(mpb);
    }

  }

  public override void WhileLiving(float v){
     mpb.SetInt("_TransformBuffer_COUNT", transforms.count);
    mpb.SetBuffer("_TransformBuffer", transforms._buffer );
    

    self.SetPropertyBlock( mpb );
    for( int i = 0; i < renderers.Length; i++ ){
      renderers[i].SetPropertyBlock(mpb);
    }
  }

}
}

 
