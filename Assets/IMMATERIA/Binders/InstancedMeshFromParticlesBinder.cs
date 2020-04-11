using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class InstancedMeshFromParticlesBinder : Binder
{

  public Particles particles;
  public float scale;


  // Use this for initialization
  public override void Bind() {

    InstancedMeshVerts v = GetComponent<InstancedMeshVerts>();
    toBind.BindForm( "_SkeletonBuffer" , particles );
    toBind.BindForm( "_BaseBuffer" , v.verts );

    toBind.BindFloat("_Scale", () => this.scale );
    toBind.BindInt("_VertsPerMesh", () => v.vertsPerMesh );
  }
  
}
}