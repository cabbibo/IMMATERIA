using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace IMMATERIA{
public class SDFBoneBuffer : Form {

  public struct sdfBone{

        public Vector3 startPoint;
        public Vector3 endPoint;
        public float   size;
        public float   debug;

    };

    public struct boneInfo{
      public Transform start;
      public Transform end;
      public float size;
      public float id;
      public SDFBone data;
    }

    int sdfStructSize = 3 + 3 + 1;

    public Transform baseBone;
    public boneInfo[] bones;
    public float[] values;

    private int boneID = 0;

    public float defaultBoneWidth;


  // Use this for initialization
  public override void Create () {

    boneID = 0; 
    count = 0;
    DebugThis("hello");
    // Gets all the bones in our mesh;
    percolateNumber( baseBone );
    bones = new boneInfo[ count ];
    percolateBoneInfo( baseBone );
    
    structSize = 8;
    values = new float[count * structSize];
    
  }


  void percolateNumber( Transform t ){
    count += t.childCount;
    for( int i = 0; i < t.childCount; i++ ){
      percolateNumber(t.GetChild(i));
    }
  }

  void percolateBoneInfo( Transform t ){
    for( int i = 0; i < t.childCount; i++ ){
        Transform child = t.GetChild(i);
      bones[boneID].start = t;
      bones[boneID].end = child;
      bones[boneID].id = boneID;
      bones[boneID].size = defaultBoneWidth;
      if( child.GetComponent<SDFBone>() != null  ){
         // DebugThis( "wevegotdata");
          bones[boneID].data = child.GetComponent<SDFBone>();
      }
      boneID ++;
      percolateBoneInfo(t.GetChild(i));
    }
  }
  

  void SetValues(){

      int id = 0;
    for( int i = 0; i < count; i++){

      boneInfo b = bones[i];

      values[ id++ ] = b.start.position.x;
      values[ id++ ] = b.start.position.y;
      values[ id++ ] = b.start.position.z;

      values[ id++ ] = b.end.position.x;
      values[ id++ ] = b.end.position.y;
      values[ id++ ] = b.end.position.z;


        if( b.data == null ){
            values[ id++ ] = b.size;
            values[id++] = 0; // no data
        }else{
            values[ id++ ] = b.data.size;
            values[id++] = 1; // data
        }

    }

    SetData( values );


  }


    public override void WhileLiving(float v){
        SetValues();
    }


}}