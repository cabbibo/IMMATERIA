using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace IMMATERIA {
public class SkinnedTriangles : IndexForm {

  [ HideInInspector ] public int width;
  [ HideInInspector ] public int length;
  [ HideInInspector ] public int numTubes;

  private int[] values;
  public override void SetCount(){
    SkinnedMeshRenderer mesh = ((SkinnedVerts)toIndex).mesh;
    values = mesh.sharedMesh.triangles;
    count = values.Length;
  }

  public override void Embody(){
    SetData(values);
  }

}
}
