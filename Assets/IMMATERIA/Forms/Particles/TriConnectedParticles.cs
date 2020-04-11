using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using System.IO;

namespace IMMATERIA {
public class TriConnectedParticles : Particles {

  public MeshTris tris;
  public MeshVerts verts;

  int[] triVals;
  int[][][] connections;
  int[] numConnections;

  // max connections 32
  public override void SetStructSize(){ structSize = 20 + 16 * 3; }



  public void AddConnection(int t1 , int t2 , int t3){
    bool canAdd = true;


    
    for( int j = 0; j < 16; j++ ){
      if( connections[t1][j][0] == t2 ){ canAdd = false; }
    }

    //if( t1 < 10 ){ print(canAdd); }

    if( canAdd ){
      connections[t1][numConnections[t1]][0] = t2;
      connections[t1][numConnections[t1]][1] = t3;
      connections[t1][numConnections[t1]][2] = 1;
      numConnections[t1] ++;
    }

  }


  public override void Embody(){

   triVals = tris.GetTriData();
   connections = new int[count][][];
   numConnections = new int[count];
   int maxConnections = 0;

    for( int i = 0; i < connections.Length; i++ ){
      connections[i] = new int[16][];
      for(int j = 0; j < connections[i].Length; j++ ){
        connections[i][j] = new int[3];
      }
    }


    for(int i = 0; i < triVals.Length / 3; i++ ){
      
      int t1 = triVals[i * 3  + 0 ];
      int t2 = triVals[i * 3  + 1 ];
      int t3 = triVals[i * 3  + 2 ];

      AddConnection( t1 , t2 , t3 );
      AddConnection( t2 , t3 , t1 );
      AddConnection( t3 , t1 , t2 );

    }

    Vector3[] pos = verts.mesh.vertices;

    for( int i = 0; i < count; i++ ){
      for( int j = 0; j < count; j++ ){

        // means it is same vert
        if( pos[i].x == pos[j].x && pos[i].y == pos[j].y && pos[i].z == pos[j].z ){

          for( int k = 0; k < 16; k ++ ){
            AddConnection(i , connections[j][k][0] , connections[j][k][1] );
          }

        }

      }
    }

    float[] values = new float[ count * structSize ];




    for( int i = 0 ; i < count; i++ ){

      if( numConnections[i] > maxConnections ){
        maxConnections = numConnections[i];
      }

      for( int j = 0; j < numConnections[i]; j++ ){
        values[i * structSize + 20  + j * 3 + 0 ] = connections[i][j][0];
        values[i * structSize + 20  + j * 3 + 1 ] = connections[i][j][1];
        values[i * structSize + 20  + j * 3 + 2 ] = connections[i][j][2];
      }

    }

    print( "MAX CONNECTION : " + maxConnections );

    SetData(values);



  }

}
}
