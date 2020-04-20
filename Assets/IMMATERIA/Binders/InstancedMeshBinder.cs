using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class InstancedMeshBinder : Binder
{

  public override void Bind() {

    InstancedMeshVerts v = GetComponent<InstancedMeshVerts>();
    toBind.BindForm( "_BaseBuffer" , v.verts );
    toBind.BindInt("_VertsPerMesh", () => v.vertsPerMesh );
  }
  
}
}