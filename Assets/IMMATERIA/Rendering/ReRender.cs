using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace IMMATERIA {
public class ReRender : Cycle {


  public Form verts;
  public IndexForm triangles;

  public Material material;
  public Material debugMaterial;

  public MaterialPropertyBlock mpb;

  public override void _Create(){

    if( mpb == null ){ mpb = new MaterialPropertyBlock(); }
    
    if( verts == null ){ verts = GetComponent<MeshVerts>(); }
    if( triangles == null ){ triangles = GetComponent<MeshTris>(); }


    mpb.SetInt("_VertCount", verts.count);
    mpb.SetBuffer("_VertBuffer", verts._buffer );
    mpb.SetBuffer("_TriBuffer", triangles._buffer );

    DoCreate();


  }

  public override void _WhileLiving(float v ){

   
    DoLiving(v);


   if( active ){
    mpb.SetInt("_VertCount", verts.count);
    mpb.SetBuffer("_VertBuffer", verts._buffer );
    mpb.SetBuffer("_TriBuffer", triangles._buffer );

    // Infinit bounds so its always drawn!
    Graphics.DrawProcedural(material,  new Bounds(transform.position, Vector3.one * 50000), MeshTopology.Triangles, triangles.count , 1, null, mpb, ShadowCastingMode.TwoSided, true, gameObject.layer);
  }
  }

 



 
  


  public override void WhileDebug(){
    debugMaterial.SetPass(0);
    debugMaterial.SetBuffer("_VertBuffer", verts._buffer);
    debugMaterial.SetBuffer("_TriBuffer", triangles._buffer);
    debugMaterial.SetInt("_Count",triangles.count);
    Graphics.DrawProceduralNow(MeshTopology.Triangles, triangles.count * 3 * 2 );
  }



}
}