using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class ParticlesOnCircle: Particles {
  
  public Form verts;
  public Life life;

  public bool specialInCenter;

  public IndexForm tris;

  public enum NoiseType {MiddleBand, CenterOut, Even,OuterRing };

  public NoiseType noiseType;


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


    float[] triangleAreas = new float[tris.count / 3];
    
    int[] triData = tris.GetIntData();
    float[] vertData = verts.GetFloatData();

    float totalArea = 0;

    int tri0;
    int tri1;
    int tri2;

    for (int i = 0; i < tris.count / 3; i++) {
    
      tri0 = i * 3;
      tri1 = tri0 + 1;
      tri2 = tri0 + 2;
     
      tri0 = triData[tri0];
      tri1 = triData[tri1];
      tri2 = triData[tri2];
     
      float area = 1;

      Vector3 p0 = extractToVector(tri0,0,vertData,verts);
      Vector3 p1 = extractToVector(tri1,0,vertData,verts);
      Vector3 p2 = extractToVector(tri2,0,vertData,verts);
      Vector2 uv0 = extractToVector2(tri0,12,vertData,verts);
      Vector2 uv1 = extractToVector2(tri1,12,vertData,verts);
      Vector2 uv2 = extractToVector2(tri2,12,vertData,verts);

   

      if( noiseType == NoiseType.MiddleBand ){

      float Y = 1-((1-uv0.y) + (1-uv1.y) + (1-uv2.y) ) / 3;
      area = Mathf.Clamp( Mathf.Min( Y * 2,( 1- Y )) * 4.5f  ,0 , 4);//((1-uv0.y) + (1-uv1.y) + (1-uv2.y) ) / 3;
      area *= area*area*area;// * area * area*area;
}else if( noiseType == NoiseType.CenterOut ){

  }else if( noiseType == NoiseType.Even ){
    float Y = 1-((1-uv0.y) + (1-uv1.y) + (1-uv2.y) ) / 3;
    area = Y;
  }else if( noiseType == NoiseType.OuterRing ){
    float Y = 1-((1-uv0.y) + (1-uv1.y) + (1-uv2.y) ) / 3;
    area = Y*Y;
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

      if( specialInCenter && i == 0 ){ baseTri = 0; }

      tri0 = baseTri + 0;
      tri1 = baseTri + 1;
      tri2 = baseTri + 2;

      tri0 = triData[tri0];
      tri1 = triData[tri1];
      tri2 = triData[tri2];

      Vector3 v0 = extractToVector(tri0,0,vertData,verts);
      Vector3 v1 = extractToVector(tri1,0,vertData,verts);
      Vector3 v2 = extractToVector(tri2,0,vertData,verts);

      pos = HELP.GetRandomPointInTriangle(i, v0, v1, v2);

      float a0 = HELP.AreaOfTriangle(pos, v1, v2);
      float a1 = HELP.AreaOfTriangle(pos, v0, v2);
      float a2 = HELP.AreaOfTriangle(pos, v0, v1);

      float aTotal = a0 + a1 + a2;

      float p0 = a0  / aTotal;
      float p1 = a1  / aTotal;
      float p2 = a2  / aTotal;

   
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

      if(specialInCenter){

        values[ index ++ ] = 1;
      }else{

        values[ index ++ ] = triangleAreas[baseTri/3] * 1000;
      }
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
