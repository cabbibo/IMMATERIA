using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class InstancedMeshTris : MeshTris {

  public MeshTris tris;

  public int numMesh;
  public int vertsPerMesh;
  public int trisPerMesh;




 public override void SetCount(){
    trisPerMesh = tris.count;
    vertsPerMesh = ((InstancedMeshVerts)toIndex).vertsPerMesh;
    numMesh = ((InstancedMeshVerts)toIndex).numMesh;
    count = trisPerMesh * numMesh;
  }

  public override void Embody(){
    int[] values = new int[count];
    int[] data = tris.GetIntData();

    int index = 0;
    for( int i = 0; i < numMesh; i++){
      for( int j = 0; j < trisPerMesh; j++){
        values[index++] = data[j  ]+ i * vertsPerMesh;
      }
    }
    SetData(values);
  }
}
}