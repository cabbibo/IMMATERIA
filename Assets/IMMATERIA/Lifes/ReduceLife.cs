using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class ReduceLife : Life{
  
  private float[] values;
  public Vector4 value;
  public ComputeBuffer _buffer;
  
  public override void Create(){
     boundForms = new Dictionary<string, Form>();
     boundInts = new Dictionary<string, int>();
     boundAttributes = new List<BoundAttribute>();
     FindKernel();
     GetNumThreads();
     //OnCreate();

     _buffer = new ComputeBuffer((int)numThreads, 4 * sizeof(float));
     values = new float[numThreads*4];



  }


  public override void _SetInternal(){
    
    shader.SetFloat("_Time", Time.time);
    shader.SetFloat("_Delta", Time.deltaTime);
    shader.SetBuffer(kernel, "_OutBuffer" , _buffer );///, Time.deltaTime);

  }

  public override void AfterDispatch(){

    _buffer.GetData(values);
    float x = 0; float y = 0; float z = 0; float w = 0;

    for( int i = 0; i < numThreads; i++ ){
      x += values[i*4+0];
      y += values[i*4+1];
      z += values[i*4+2];
      w += values[i*4+3];
    }

    value = new Vector4( x , y , z , w );
  }

}


}