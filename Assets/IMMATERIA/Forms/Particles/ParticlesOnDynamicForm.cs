using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class ParticlesOnDynamicForm: Particles {
  
  public Form verts;
  public Life life;

  public IndexForm tris;

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
  public override void Create(){
    SafeInsert(life);
  }

  Vector3 extractToVector( int id , int offset, float[] data , Form form ){

    int baseID = id * form.structSize;
    return new Vector3( data[ baseID + offset + 0 ],data[ baseID + offset + 1 ],data[ baseID + offset + 2 ]);

  }

    Vector2 extractToVector2( int id , int offset, float[] data , Form form ){

    int baseID = id * form.structSize;
    return new Vector2( data[ baseID + offset + 0 ],data[ baseID + offset + 1 ]);

  }

  public override void Embody(){

    print("Embodying particles on dynamic mesh");

    float[] triangleAreas = new float[tris.count / 3];
    
    int[] triData = tris.GetIntData();
    float[] vertData = verts.GetFloatData();


    print( tris.count );
    print( verts.count );

    float totalArea = 0;

    int tri0;
    int tri1;
    int tri2;

    for (int i = 0; i < tris.count / 3; i++) {
    
      /*tri0 = i * 3;
      tri1 = tri0 + 1;
      tri2 = tri0 + 2;
     
      tri0 = triData[tri0];
      tri1 = triData[tri1];
      tri2 = triData[tri2];
     
      float area = 1;

      Vector3 p0 = extractToVector(tri0,0,vertData,verts);
      Vector3 p1 = extractToVector(tri1,0,vertData,verts);
      Vector3 p2 = extractToVector(tri2,0,vertData,verts);

      if( noiseType=="even"){ 
        area = HELP.AreaOfTriangle (p0, p1, p2);
      }else if( noiseType =="fractal" ){
        area = HELP.NoiseTriangleArea(noiseSize, p0, p1, p2);
        area = Mathf.Pow( area, 10);
      }*/

      triangleAreas[i] = 1;
      totalArea += 1;
    
    }

    for (int i = 0; i < triangleAreas.Length; i++) {
      triangleAreas[i] /= totalArea;
    }

    float[] values = new float[count*structSize];

    int index = 0;


    Vector3 pos;
    int baseTri;

    for( int i = 0; i < count; i ++ ){

      baseTri = 3 * HELP.getTri (Random.value, triangleAreas);

      tri0 = baseTri + 0;
      tri1 = baseTri + 1;
      tri2 = baseTri + 2;

      tri0 = triData[tri0];
      tri1 = triData[tri1];
      tri2 = triData[tri2];

      Vector3 v0 = new Vector3(1,0,0);//extractToVector(tri0,0,vertData,verts);
      Vector3 v1 = new Vector3(0,1,0);//extractToVector(tri1,0,vertData,verts);
      Vector3 v2 = new Vector3(0,0,1);//extractToVector(tri2,0,vertData,verts);

      pos = HELP.GetRandomPointInTriangle(i, v0, v1, v2);

      float a0 = HELP.AreaOfTriangle(pos, v1, v2);
      float a1 = HELP.AreaOfTriangle(pos, v0, v2);
      float a2 = HELP.AreaOfTriangle(pos, v0, v1);

      float aTotal = a0 + a1 + a2;

      float p0 = a0 / aTotal;
      float p1 = a1 / aTotal;
      float p2 = a2 / aTotal;

      //if( aTotal == 0 ){ print("hellloo"); }

   
      values[ index ++ ] = 0;
      values[ index ++ ] = 0;
      values[ index ++ ] = 0;

      values[ index ++ ] = 0;
      values[ index ++ ] = 0;
      values[ index ++ ] = 0;

      values[ index ++ ] = 0;
      values[ index ++ ] = 0;
      values[ index ++ ] = 0;

      values[ index ++ ] = 0;
      values[ index ++ ] = 0;
      values[ index ++ ] = 0;

      values[ index ++ ] = 0;
      values[ index ++ ] = 0;

   
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


  public override void Bind(){
    life.BindPrimaryForm( "_ParticleBuffer" , this );
    life.BindForm( "_VertBuffer" , verts );

  }

  public void Set(){
    life.YOLO();
  }


}

}