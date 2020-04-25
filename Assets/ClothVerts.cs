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
        for( int i = 0; i < numVertsX; i++ ){
        for( int j = 0; j < numVertsY; j++ ){

            id = i + j * numVertsX;
            
            float x = (float)i/(float)numVertsX;
            float y = (float)j/(float)numVertsY;
            values[id * structSize + 0 ]= (x-.5f) * width;
            values[id * structSize + 1 ]= 0;
            values[id * structSize + 2 ]= (y-.5f) * height;

            
            values[id * structSize + 3 ]= (x-.5f) * width;
            values[id * structSize + 4 ]= 0;
            values[id * structSize + 5 ]= (y-.5f) * height;

        }}

        SetData(values);

    }
}
}
