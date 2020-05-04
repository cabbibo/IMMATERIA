using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace IMMATERIA {
public class ConnectionList : Form
{
   

   public ClothVerts verts;
   /*

    struct Link{
        public float id1;
        public float id2;
        public float distance;
        public float stiffness;
    }

  */
   public override void SetStructSize(){
       structSize = 4;
   }

   public override void SetCount(){
       count = (verts.count/2 ) * 8;
   }


// up link
// right link
// diagDown
// diagUp

/// connection = id * 4 + passID

int getID( int x , int y ){

    if( x >= verts.numVertsX ){ return -10; }
    if( x < 0 ){ return -10; }

    if( y >= verts.numVertsY ){ return -10; }
    if( y < 0 ){ return -10; }


    return x + y * verts.numVertsX;

}
   public override void Embody(){


       float[] values =new float[count * structSize];

        int index = 0;

    int nvx = verts.numVertsX;
    int nvy = verts.numVertsY;
    float sizeX = verts.width/ (float)verts.numVertsX;
    float sizeY = verts.height/ (float)verts.numVertsY;
    float sizeDi = (new Vector2( sizeX, sizeY)).magnitude; 

       for( int i = 0; i < nvx; i++ ){
           for( int j = 0; j < nvy; j++ ){

               if( j % 2 == 0 ){

                // our link values going up
                values[index++] = getID(i,j);
                values[index++] = getID(i,j+1);
                values[index++] = sizeY;
                values[index++] = 1;


                    // our link values going to the side
                    // require a flip flop to make sure we aren't
                    // connecting 2 in the same pass
                    if( i %2 == 0 ){    
                        values[index++] = getID(i,j);
                        values[index++] = getID(i+1,j);
                    }else{
                        values[index++] = getID(i ,j+1);
                        values[index++] = getID(i+1,j+1);
                    }

                    values[index++] = sizeX;
                    values[index++] = 1;



        



                // our link values going diagonal down
                values[index++] = getID(i,j);
                values[index++] = getID(i-1,j-1);
                values[index++] = sizeDi;
                values[index++] = 1;

                // our link values going diagonal up
                values[index++] = getID(i,j);
                values[index++] = getID(i+1,j+1);
                values[index++] = sizeDi;
                values[index++] = 1;

                 // our link values goint down
                values[index++] = getID(i,j);
                values[index++] = getID(i,j-1);
                values[index++] = sizeY;
                values[index++] = 1;
            
                    // our link values going to the side
                    // require a flip flop to make sure we aren't
                    // connecting 2 in the same pass
                    if( i %2 == 0 ){    
                        values[index++] = getID(i,j);
                        values[index++] = getID(i-1,j);
                    }else{
                        values[index++] = getID(i ,j+1);
                        values[index++] = getID(i-1,j+1);
                    }

                    values[index++] = sizeX;
                    values[index++] = 1;

                    
                // our link values going diagonal down
                values[index++] = getID(i,j);
                values[index++] = getID(i+1,j-1);
                values[index++] = sizeDi;
                values[index++] = 1;

                // our link values going diagonal up
                values[index++] = getID(i,j);
                values[index++] = getID(i-1,j+1);
                values[index++] = sizeDi;
                values[index++] = 1;


               }
           }
       }


        SetData( values );


   }



    public override void WhileDebug(){

        mpb.SetBuffer("_VertBuffer", verts._buffer);
        mpb.SetBuffer("_ConnectionBuffer", _buffer);
        mpb.SetInt("_Count",count);
    
        Graphics.DrawProcedural(debugMaterial,  new Bounds(transform.position, Vector3.one * 5000), MeshTopology.Triangles, count * 3 * 2 , 1, null, mpb, ShadowCastingMode.Off, true, LayerMask.NameToLayer("Debug"));

    }



}}
