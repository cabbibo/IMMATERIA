using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace IMMATERIA {
public class Hair: Form {

  public Form baseForm;
  public int numVertsPerHair;
  public float length;
  public float variance;
  public Material lineDebugMaterial;
  public int numHairs;

  protected MaterialPropertyBlock lineMPB;
  public float countMultiplier = 1;

  public override void SetStructSize(){ structSize = 16; }

  public override void SetCount(){

    print("IT ME TOO");
    print( baseForm.count );


    if( lineMPB == null ){ lineMPB = new MaterialPropertyBlock(); }
    
   float newNum = (float)baseForm.count * (float)countMultiplier;
   if(newNum - Mathf.Floor(newNum) != 0 ){ print("WATISS COUNT MULTIPLIER IS WACKY"); }
   numHairs = (int)newNum;//(float)baseForm.count / (float)countMultiplier;

    count = numHairs * numVertsPerHair; 
  }

  public override void WhileDebug(){
    
    lineMPB.SetBuffer("_VertBuffer", _buffer);
    lineMPB.SetInt("_Count",count);
    lineMPB.SetInt("_NumVertsPerHair",numVertsPerHair);
     Graphics.DrawProcedural(lineDebugMaterial,  new Bounds(transform.position, Vector3.one * 50000), MeshTopology.Lines, count *  2 , 1, null, mpb, ShadowCastingMode.Off, true, LayerMask.NameToLayer("Debug"));


    mpb.SetBuffer("_VertBuffer", _buffer);
    mpb.SetInt("_Count",count);
     Graphics.DrawProcedural(debugMaterial,  new Bounds(transform.position, Vector3.one * 50000), MeshTopology.Triangles, count * 3* 2 , 1, null, mpb, ShadowCastingMode.Off, true, LayerMask.NameToLayer("Debug"));

  //  Graphics.DrawProceduralNow(MeshTopology.Triangles, count  * 2 );

  }


}
}
