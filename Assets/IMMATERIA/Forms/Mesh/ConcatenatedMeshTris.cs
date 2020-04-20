using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA{
public class ConcatenatedMeshTris : IndexForm
{

  private GameObject[] meshes;

  public override void SetCount(){
    meshes = ((ConcatenatedMeshVerts)toIndex).meshes;
    count = 0;
    for( int i = 0; i < meshes.Length; i++ ){
      count += meshes[i].GetComponent<MeshFilter>().sharedMesh.triangles.Length;
    }
  }

  public override void Embody(){

    int[] values = new int[ count ];

    int index = 0;
    int baseVal = 0;

    for( int i = 0; i < meshes.Length; i++ ){

      int[] tris = meshes[i].GetComponent<MeshFilter>().sharedMesh.triangles;

      for( int j = 0; j < tris.Length; j++ ){ values[index++] = tris[j] + baseVal; }

      baseVal += meshes[i].GetComponent<MeshFilter>().sharedMesh.vertices.Length;

    }

    SetData(values);
  }


}}
