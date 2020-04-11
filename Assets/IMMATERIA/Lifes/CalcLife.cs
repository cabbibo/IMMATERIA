
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class CalcLife : Life{
  
  private float[] values;
  public Vector4 value;
  public int count;
  public ComputeBuffer _buffer;
  public bool readBack;
  
  public override void _Create(){
    DoCreate();
    boundForms = new Dictionary<string, Form>();
    boundInts = new Dictionary<string, int>();
    boundAttributes = new List<BoundAttribute>();

    boundIntList = new List<BoundInt>();
    boundFloatList = new List<BoundFloat>();
    boundFloatsList = new List<BoundFloats>();
    boundVector2List = new List<BoundVector2>();
    boundVector3List = new List<BoundVector3>();
    boundVector4List = new List<BoundVector4>();
    boundMatrixList = new List<BoundMatrix>();
    boundTextureList = new List<BoundTexture>();
    boundBufferList = new List<BoundBuffer>();
    FindKernel();
    GetNumThreads();

    // OnCreate();
     
     _buffer = new ComputeBuffer((int)count, 4 * sizeof(float));
     
     values = new float[count*4];

    _buffer.SetData(values);
    
  }

  public override void _Destroy(){
    if(_buffer != null){ _buffer.Release(); }
  }

  public override void _SetInternal(){
    
    shader.SetFloat("_Time", Time.time);
    shader.SetFloat("_Delta", Time.deltaTime);
    shader.SetBuffer(kernel, "_OutBuffer" , _buffer );///, Time.deltaTime);

  }

  public override void AfterDispatch(){
    if( readBack ){
      _buffer.GetData(values);
      DecodeData(values);
    }
  }

  public virtual void DecodeData(float[] vals){
    value = new Vector4( vals[0] , vals[1] , vals[2] , vals[3] );
  }

}

}