using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class ClothVerts : Form
{

    public float width;
    public float height;

    public int numVertsX;
    public int numVertsY;

    public override void SetCount(){
        count = numVertsX * numVertsY;
    }

    public override void SetStructSize(){
        structSize = 16;
    }


    public override void Embody(){
        float[] values = new float[count* structSize];

        int id;
        Vector3 v1 , v2;
        for( int i = 0; i < numVertsX; i++ ){
        for( int j = 0; j < numVertsY; j++ ){

            id = i + j * numVertsX;
   float x = (float)i/(float)numVertsX;
            float y = (float)j/(float)numVertsY;
            v2 = new Vector3( (x-.5f) * width,0,(y-.5f) * height);
           v1 = transform.TransformPoint(v2);

            
            
         

            values[id * structSize + 0 ]= v1.x;
            values[id * structSize + 1 ]= v1.y;
            values[id * structSize + 2 ]= v1.z;

            
            values[id * structSize + 3 ]= v1.x;
            values[id * structSize + 4 ]= v1.y;
            values[id * structSize + 5 ]= v1.z;

            //nor
            //tan


                  
            values[id * structSize + 12 ]= x;
            values[id * structSize + 13 ]= y;

        }}

        SetData(values);

    }
}
}
