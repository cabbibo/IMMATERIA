using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;


namespace IMMATERIA {
public class MultiMaterialBody : Body
{


  public SkinnedMeshRenderer mainMesh;

  public override void _WhileLiving(float v ){


   // List<int> indicies;
    int baseIndex;

    DoLiving(v);

    if( active ){

      baseIndex = 0;

      mpb.SetInt("_VertCount", verts.count);
      mpb.SetBuffer("_VertBuffer", verts._buffer );
      mpb.SetBuffer("_TriBuffer", triangles._buffer );
    
      for( int i = 0; i < mainMesh.sharedMesh.subMeshCount; i++ ){

        MaterialPropertyBlock mpb1 = new MaterialPropertyBlock();

      mpb1.SetInt("_VertCount", verts.count);
      mpb1.SetBuffer("_VertBuffer", verts._buffer );
      mpb1.SetBuffer("_TriBuffer", triangles._buffer );
        
        int[] indicies =  mainMesh.sharedMesh.GetIndices( i );
       
        mpb1.SetInt("_BaseID" , baseIndex);
        mpb1.SetInt("_SubMeshID" , i );

   // Infinit bounds so its always drawn!
        Graphics.DrawProcedural(
          material, 
          new Bounds(transform.position, Vector3.one * 50000), 
          MeshTopology.Triangles, 
          indicies.Length, 
          1, 
          null, 
          mpb1, 
          ShadowCastingMode.TwoSided, 
          true, 
          gameObject.layer
        );


        baseIndex += indicies.Length;

      }

    }

     
  }


}
}