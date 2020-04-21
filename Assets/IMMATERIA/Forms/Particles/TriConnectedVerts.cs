using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using System.IO;

namespace IMMATERIA {
public class TriConnectedVerts : MeshVerts {

  public MeshTris tris;
  public MeshVerts verts;

  int[] triVals;

  // store list of every index to every other 
  // vert that this vert is connected too
  // via a triangle! 

  // note that we are comparing via 'position'
  // so verts that are placed on top of each other
  // will be considered the same vert!
  public List<int> connections;


  public int[] numConnections;
  public int[] connectionStart;


  public override void SetStructSize(){ structSize = 16; }
  public override void SetCount(){
    count = verts.count;
  }

  

  public override void Embody(){

   triVals = tris.GetTriData();

   connections = new List<int>();

   numConnections = new int[count];
   connectionStart = new int[count];

   int maxConnections = 0;
    Vector3[] pos = verts.mesh.vertices;
   

   Vector3 me;
   Vector3 p1; Vector3 p2; Vector3 p3;
   int id1; int id2; int id3;

   int totalIndicies = 0;
  
   for( int i = 0; i < count; i++ ){
     me = pos[i];
     connectionStart[i] = totalIndicies;
     int connectionsForThisVert = 0;
  
    for(int j = 0; j < triVals.Length / 3; j++ ){

      id1 = triVals[j*3+0];
      id2 = triVals[j*3+1];
      id3 = triVals[j*3+2];

      p1 = pos[id1];
      p2 = pos[id2];
      p3 = pos[id3];

      if( me.x == p1.x  && me.y == p1.y && me.z == p1.z ){
        connections.Add(id2);
        connections.Add(id3);
        connectionsForThisVert += 1;
      }

      if( me.x == p2.x  && me.y == p2.y && me.z == p2.z ){
        connections.Add(id3);
        connections.Add(id1);
        connectionsForThisVert += 1;
      }

      if( me.x == p3.x  && me.y == p3.y && me.z == p3.z ){
        connections.Add(id1);
        connections.Add(id2);
        connectionsForThisVert += 1;
      }

    }

    totalIndicies += connectionsForThisVert;
    numConnections[i] = connectionsForThisVert;
   }

   float[] values = new float[ count * structSize ];




    for( int i = 0 ; i < count; i++ ){

      if( numConnections[i] > maxConnections ){
        maxConnections = numConnections[i];
      }

      // making our data into the debug section of our vert 
        values[i * structSize + 14 ] = numConnections[i];
        values[i * structSize + 15 ] = connectionStart[i];
    }

    SetData(values);



  }

}
}
