using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class MeshTris : IndexForm {


  private int[] values;

  public override void SetCount(){
    Mesh mesh = ((MeshVerts)toIndex).mesh;
    values = mesh.triangles;
    count = values.Length;
  }

  public int[] GetTriData(){ return values; }

  public override void Embody(){ SetData(values); }

}
}

