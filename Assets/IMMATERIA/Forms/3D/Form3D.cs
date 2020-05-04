using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace IMMATERIA {
public class Form3D : Form
{
    public Vector3 dimensions;
    public Vector3 extents;
    public Vector3 center;
    public bool showGrid;


    public Texture3D _texture;
    

    public override void SetCount(){
      count = (int)dimensions.x * (int)dimensions.y * (int)dimensions.z;
    }

    public override void SetStructSize(){
      structSize = 4;
    }

    public override void OnBirthed(){
      if(loadedFromFile){ MakeTexture(); }
    }

    public override void Embody(){

      float[] values = new float[count* structSize];
      int index = 0;
      for( int i = 0; i < count; i++ ){
        values[index++] = 1000;
        values[index++] = 1000;
        values[index++] = 1000;
        values[index++] = 1000;
      }

      SetData(values);
    }


public override void WhileDebug(){
  ///DebugThis("" + count);

    mpb.SetBuffer("_TransferBuffer", _buffer);
    mpb.SetInt("_Count",count);

    mpb.SetMatrix( "_Transform" , transform.localToWorldMatrix );
    mpb.SetVector("_Center", center);
    mpb.SetVector("_Dimensions", dimensions);
    mpb.SetVector("_Extents", extents);
    
    Graphics.DrawProcedural(debugMaterial,  new Bounds(transform.position, Vector3.one * 5000), MeshTopology.Triangles, count * 3 * 2 , 1, null, mpb, ShadowCastingMode.Off, true, LayerMask.NameToLayer("Debug"));

}

  public void OnDrawGizmos(){
    Gizmos.matrix = transform.localToWorldMatrix;

    if( showGrid ){
    Gizmos.color = new Vector4(0.2f,.5f,1.2f,1);

      for( int s = 0; s < 3; s++){




        float dimensionsX = dimensions.x;
        float dimensionsY = dimensions.y;

        float extentsX = extents.x;
        float extentsY = extents.y;
        float extentsZ = extents.z;

        Vector3 xDir = Vector3.left;
        Vector3 yDir = Vector3.up;
        Vector3 zDir = Vector3.forward;


        if( s == 1 ){
          dimensionsX = dimensions.x;
          dimensionsY = dimensions.z;
          extentsX = extents.x;
          extentsY = extents.z;
          extentsZ = extents.y;

          xDir = Vector3.left;
          yDir = Vector3.forward;
          zDir = Vector3.up;
        }

        if( s == 2 ){
          dimensionsX = dimensions.z;
          dimensionsY = dimensions.y;
          extentsX = extents.z;
          extentsY = extents.y;
          extentsZ = extents.x;
           xDir = Vector3.forward;
          yDir = Vector3.up;
          zDir = Vector3.left;
        }

        float sizeX = extentsX * 2 / dimensionsX;
        float sizeY = extentsY * 2 / dimensionsY;



        for(float i  = 0; i < 2; i++ ){

             float z = (i - .5f) *2 * extentsZ;
          for( float j = 0; j< dimensionsX;j++){
            for( float k = 0; k < dimensionsY; k++ ){


            Vector3 p1 = center + (sizeX * j     - extentsX)*xDir + (sizeY * k     - extentsY)*yDir + z*zDir;
            Vector3 p2 = center + (sizeX * (j+1) - extentsX)*xDir + (sizeY * k     - extentsY)*yDir + z*zDir;
            Vector3 p3 = center + (sizeX * j     - extentsX)*xDir + (sizeY * (k+1) - extentsY)*yDir + z*zDir;
            if( k != 0 ) Gizmos.DrawLine(p1, p2);
            if( j != 0 ) Gizmos.DrawLine(p1, p3);
           }
          }
        }
      }
    }


    Gizmos.color = new Vector4(1,.6f,.2f,1);
    Gizmos.DrawWireCube(center, extents*2);
  }



  public void MakeTexture(){

    Color[] bmp = GenerateBitmap(GetData());
    _texture = new Texture3D((int)dimensions.x, (int)dimensions.y, (int)dimensions.z, TextureFormat.RGBAHalf, true);

    _texture.name = "Distance Field Texture: "+ this.saveName;
    _texture.filterMode = FilterMode.Trilinear;
    _texture.wrapMode = TextureWrapMode.Clamp;
    _texture.SetPixels(bmp);
    _texture.Apply();


 //   print("texture");
    print(_texture);
    //return _texture;

  }

  public Color[] GenerateBitmap(float[] values){

    Color[] col = new Color[count];
    for( int i = 0; i < count; i++ ){
      col[i] = new Color( values[ i * structSize + 0 ],
                          values[ i * structSize + 1 ],
                          values[ i * structSize + 2 ],
                          values[ i * structSize + 3 ]);
    }


    return col;

  }

  public void RemakeTexture(){
    MakeTexture();
  }


}}
