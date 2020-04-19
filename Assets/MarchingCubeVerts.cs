using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace IMMATERIA {
public class MarchingCubeVerts : Form
{

  public Form3D sdfBuffer;
  public Material baseMeshMaterial;

  public override void SetStructSize(){ structSize = 8; }
  public override void SetCount(){ count = sdfBuffer.count  * 5 * 3; }
  public override void Embody(){
    float[] values = new float[count*8];
    for( int i = 0; i< count*8;i++){
      values[i] = -1;
    }
    SetData( values );
  }


  public void MakeMesh(){


    float[] values = new float[count*8];
    GetData(values);

    //Extract the positions, normals and indexes.
    List<Vector3> positions = new List<Vector3>();
    List<Vector3> normals = new List<Vector3>();
    List<int> indices = new List<int>();

    positions.Clear();
    normals.Clear();
    indices.Clear();


    int index = 0;
    for( int i  = 0; i < count; i++ ){  

      if( values[ i * 8 + 0 ] != -1 ){
        Vector3 p = new Vector3( values[ i * 8 + 0 ] ,values[ i * 8 + 1 ],values[ i * 8 + 2 ]);
        Vector3 n = -1 * new Vector3( values[ i * 8 + 3 ] ,values[ i * 8 + 4 ],values[ i * 8 + 5 ]);

        if( index < 100 ){
          //print( n );
        }

        positions.Add( p );
        normals.Add( n );
        indices.Add(index);
        index++;
      }

    }

    print( index );



    if( index != 0 ){
      MakeGameObject(positions, normals, indices);
    }

  }

  void MakeGameObject(List<Vector3> positions, List<Vector3> normals, List<int> indices){


    GameObject go = new GameObject("Voxel Mesh");
    Mesh mesh = new Mesh();
    
    mesh.vertices = positions.ToArray();
    mesh.normals = normals.ToArray();
    mesh.bounds = new Bounds(new Vector3(0, 0, 0), new Vector3(100, 100, 100));
    mesh.SetTriangles(indices.ToArray(), 0);

    mesh.RecalculateNormals();
    
    go.AddComponent<MeshFilter>();
    go.AddComponent<MeshRenderer>();
    go.GetComponent<Renderer>().material =  baseMeshMaterial;//new Material(Shader.Find("Custom/CelShadingForward"));
    go.GetComponent<MeshFilter>().mesh = mesh;
    go.transform.parent = transform;

  }

}
}
