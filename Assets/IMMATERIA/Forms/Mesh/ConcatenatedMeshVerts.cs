using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA{
public class ConcatenatedMeshVerts : Particles
{
  
  public GameObject[] meshes;

  public override void SetCount(){
    count = 0;
    for( int i = 0; i < meshes.Length; i++ ){
      count += meshes[i].GetComponent<MeshFilter>().sharedMesh.vertices.Length;
    }
  }

  public override void Embody(){



    Vector3[] verts  = new Vector3[  count ];
    Vector3[] nors   = new Vector3[  count ];
    Vector3[] tans   = new Vector3[  count ];
    Vector2[] uvs    = new Vector2[  count ];
    int[] meshID     = new int[      count ];

    int index = 0;
    for( int i = 0; i < meshes.Length; i++ ){
      Vector3[] v = meshes[i].GetComponent<MeshFilter>().sharedMesh.vertices;
      Vector3[] n = meshes[i].GetComponent<MeshFilter>().sharedMesh.normals;
      Vector4[] t = meshes[i].GetComponent<MeshFilter>().sharedMesh.tangents;
      Vector2[] u = meshes[i].GetComponent<MeshFilter>().sharedMesh.uv;

      for( int j = 0; j < v.Length; j++ ){
        verts[index] = meshes[i].transform.TransformPoint(v[j]);
        nors[index]  = meshes[i].transform.TransformDirection(n[j]);
        tans[index]  = meshes[i].transform.TransformDirection(HELP.ToV3(t[j]));
        uvs[index]      = u[j];
        meshID[index]   = i;
        index += 1;
      }
    }


    float[] values = new float[count * structSize];
    index = 0;

    for( int i = 0; i < count; i++ ){
      //DebugThis( "" +verts[i].x );

      values[ index ++ ] = verts[i].x;
      values[ index ++ ] = verts[i].y;
      values[ index ++ ] = verts[i].z;

      values[ index ++ ] = 0;
      values[ index ++ ] = 0;
      values[ index ++ ] = 0;

      values[ index ++ ] = nors[i].x;
      values[ index ++ ] = nors[i].y;
      values[ index ++ ] = nors[i].z;


      values[ index ++ ] = tans[i].x;
      values[ index ++ ] = tans[i].y;
      values[ index ++ ] = tans[i].z;


      values[ index ++ ] = uvs[i].x;
      values[ index ++ ] = uvs[i].y;

      values[ index ++ ] = (float)i/(float)count;
      values[ index ++ ] = meshID[i];


    }

    SetData( values );


  }


  



}}
