using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using IMMATERIA;

public class SetSDFTexture : Cycle
{
    public Form3D form;

    MaterialPropertyBlock mpb;

    Renderer renderer;

    public override void Create(){
   //   print( "start");
      renderer = GetComponent<MeshRenderer>();
      if( mpb == null ){ mpb = new MaterialPropertyBlock(); }
    }

    public override void WhileLiving( float f ){

     // print("what");

      if( form._texture != null ){
       // print("helllooo");

        mpb.SetTexture("_MainTex",form._texture);
        mpb.SetVector("_Extents",form.extents);
        mpb.SetVector("_Center",form.center);
        mpb.SetVector("_Dimensions",form.dimensions);
        mpb.SetMatrix("_FormTransform", form.transform.worldToLocalMatrix );
        renderer.SetPropertyBlock(mpb);

      }
    }
}
