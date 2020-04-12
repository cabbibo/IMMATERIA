using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class ParticlesOnDynamicMesh: Particles {
  
  public Mesh mesh;

  public string noiseType;// { "even", "fractal" , "allOne"};
  public float noiseSize;

  /*struct Vert{
    public Vector3 pos;
    public Vector3 vel;
    public Vector3 nor;
    public Vector3 tan;
    public Vector2 uv;
    public float used;
    public Vector3 triIDs;
    public Vector3 triWeights;
    public Vector3 debug;

  };*/

  public override void SetStructSize(){ structSize = 24; }

  public override void Embody(){

    Mesh m = mesh;

    int[] triangles = m.triangles;
    Vector3[] verts = m.vertices;
    Vector2[] uvs =   m.uv;
    Vector4[] tans = m.tangents;
    Vector3[] nors = m.normals;

    float[] triangleAreas = new float[triangles.Length / 3];
    float totalArea = 0;

    int tri0;
    int tri1;
    int tri2;

    for (int i = 0; i < triangles.Length / 3; i++) {
    
      tri0 = i * 3;
      tri1 = tri0 + 1;
      tri2 = tri0 + 2;
     
      tri0 = triangles[tri0];
      tri1 = triangles[tri1];
      tri2 = triangles[tri2];
     
      float area = 1;

      if( noiseType=="even"){ 
        area = HELP.AreaOfTriangle (verts[tri0], verts[tri1], verts[tri2]);
      }else if( noiseType =="fractal" ){
        area = HELP.NoiseTriangleArea(noiseSize, verts[tri0],  verts[tri1], verts[tri2]);
        area = Mathf.Pow( area, 3);
      }else if( noiseType == "band"){

        float avePos = verts[tri0].y + verts[tri1].y + verts[tri2].y;
        area = HELP.AreaOfTriangle (verts[tri0], verts[tri1], verts[tri2])/(.01f + Mathf.Abs(100 * avePos));
      }

      triangleAreas[i] = area;
      totalArea += area;
    
    }

    for (int i = 0; i < triangleAreas.Length; i++) {
      triangleAreas[i] /= totalArea;
    }

    float[] values = new float[count*structSize];

    int index = 0;


    Vector3 pos;
    Vector3 uv;
    Vector3 tan;
    Vector3 nor;
    int baseTri;

    for( int i = 0; i < count; i ++ ){

      baseTri = 3 * HELP.getTri (Random.value, triangleAreas);
      tri0 = baseTri + 0;
      tri1 = baseTri + 1;
      tri2 = baseTri + 2;

      tri0 = triangles[tri0];
      tri1 = triangles[tri1];
      tri2 = triangles[tri2];

      pos = HELP.GetRandomPointInTriangle(i, verts[tri0], verts[tri1], verts[tri2]);

      float a0 = HELP.AreaOfTriangle(pos, verts[tri1], verts[tri2]);
      float a1 = HELP.AreaOfTriangle(pos, verts[tri0], verts[tri2]);
      float a2 = HELP.AreaOfTriangle(pos, verts[tri0], verts[tri1]);

      float aTotal = a0 + a1 + a2;

      float p0 = a0 / aTotal;
      float p1 = a1 / aTotal;
      float p2 = a2 / aTotal;

      nor = (nors[tri0] * p0 + nors[tri1] * p1 + nors[tri2] * p2).normalized;
      uv = uvs[tri0] * p0 + uvs[tri1] * p1 + uvs[tri2] * p2;
      //tan = (HELP.ToV3(tans[tri0]) * p0 + HELP.ToV3(tans[tri1]) * p1 + HELP.ToV3(tans[tri2]) * p2).normalized;


   
//            print( pos);
      values[ index ++ ] = pos.x;
      values[ index ++ ] = pos.y;
      values[ index ++ ] = pos.z;

      values[ index ++ ] = 0;
      values[ index ++ ] = 0;
      values[ index ++ ] = 0;

      values[ index ++ ] = nor.x;
      values[ index ++ ] = nor.y;
      values[ index ++ ] = nor.z;

      values[ index ++ ] = 0;
      values[ index ++ ] = 0;
      values[ index ++ ] = 0;

      values[ index ++ ] = uv.x;
      values[ index ++ ] = uv.y;

   
      values[index++ ] = (float)i/(float)count;

      values[ index ++ ] = tri0;
      values[ index ++ ] = tri1;
      values[ index ++ ] = tri2;

      values[ index ++ ] = p0;
      values[ index ++ ] = p1;
      values[ index ++ ] = p2;

      values[ index ++ ] = 1;
      values[ index ++ ] = 0;
      values[ index ++ ] = 0;

    }


    SetData( values );



  }
}
}