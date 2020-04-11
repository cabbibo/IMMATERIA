using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HELP{

  public static Vector3 GetRandomPointInTriangle( int seed, Vector3 v1 , Vector3 v2 , Vector3 v3 ){
   
    /* Triangle verts called a, b, c */

    Random.InitState(seed* 14145);
    float r1 = Random.value;

    Random.InitState(seed* 19247);
    float r2 = Random.value;
    //float r3 = Random.value;

    return (1 - Mathf.Sqrt(r1)) * v1 + (Mathf.Sqrt(r1) * (1 - r2)) * v2 + (Mathf.Sqrt(r1) * r2) * v3;
     
    ///return (r1 * v1 + r2 * v2 + r3 * v3) / (r1 + r2 + r3);
  }

  public static float AreaOfTriangle( Vector3 v1 , Vector3 v2 , Vector3 v3 ){
     Vector3 v = Vector3.Cross(v1-v2, v1-v3);
     float area = v.magnitude * 0.5f;
     return area;
  }

  public static float NoiseTriangleArea( float size , Vector3 v1  , Vector3 v2 , Vector3 v3 ){

    Vector3 ave = v1 + v2 + v3;
    ave /= 3;
    float nV =     ( Noise.Perlin3D(ave, size) + 1)/2;

   // if( nV > .4f ){ Debug.Log(nV);}
    return nV;

  }

  public static float[] GetMatrixFloats(Matrix4x4 m){

    float[] matrixFloats = new float[]
    {
    m[0,0], m[1, 0], m[2, 0], m[3, 0],
    m[0,1], m[1, 1], m[2, 1], m[3, 1],
    m[0,2], m[1, 2], m[2, 2], m[3, 2],
    m[0,3], m[1, 3], m[2, 3], m[3, 3]
    };

    return matrixFloats;


  }

  public static Vector3 ToV3( Vector4 parent)
  {
     return new Vector3(parent.x, parent.y, parent.z);
  }

  public static float getRandomFloatFromSeed( int seed ){
    Random.InitState(seed);
    return Random.value;
  }

  public static int getTri(float randomVal, float[] triAreas){


    int triID = 0;
    float totalTest = 0;
    for( int i = 0; i < triAreas.Length; i++ ){

      totalTest += triAreas[i];
      if( randomVal <= totalTest){
        triID = i;
        break;
      }

    }

    return triID;

  }



}