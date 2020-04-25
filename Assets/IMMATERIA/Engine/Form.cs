using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;


using System;

using System.IO;


namespace IMMATERIA {
public class Form : Cycle {


  public int count;

   public string saveName;
  public bool alwaysRemake;

  [HideInInspector] public bool intBuffer;

  [HideInInspector] public int structSize;
  [HideInInspector] public ComputeBuffer _buffer;

//  [HideInInspector] public string name;
  [HideInInspector] public string description;
  [HideInInspector] public float timeToCreate;
  [HideInInspector] public int totalMemory;  

  public Material debugMaterial;
  protected MaterialPropertyBlock mpb;

  public bool loadedFromFile;

  public override void _Create(){
    if( mpb == null ){ mpb = new MaterialPropertyBlock(); }
    SetStructSize();
    SetCount();
    SetBufferType();
    DoCreate();
  }

  public override void _OnGestate(){ 
    DoGestate();
    _buffer = MakeBuffer();
    _Embody();
  }

  
  public virtual void _Embody(){

    if( String.IsNullOrEmpty(saveName) ){
      saveName = "entity"+ UnityEngine.Random.Range(0,10000000);
    }

    if( Saveable.Check(saveName) && !alwaysRemake ){
      
      loadedFromFile = true;
      Saveable.Load(this);
    }else{
      loadedFromFile = false;
      Embody();
      Saveable.Save(this);
    }

  }

  public virtual void Embody(){}
  public virtual void SetCount(){}
  public virtual void SetStructSize(){}
  public virtual void SetBufferType(){}

  public override void _Destroy(){
    DoDestroy();
    ReleaseBuffer();
  }

  public int[] GetIntData(){
    int[] val = new int[count];
    GetData(val);
    return val;
  }

  public float[] GetFloatData(){
    float[] val = new float[count*structSize];
    GetData(val);
    return val;
  }

  public float[] GetData(){
    return GetFloatData();
  }

  public void GetData( int[] values ){ _buffer.GetData(values); }
  public void GetData( float[] values ){ _buffer.GetData(values); }

  public void SetData( float[] values ){ _buffer.SetData( values );}
  public void SetData( int[] values ){ _buffer.SetData( values ); }

  public ComputeBuffer MakeBuffer(){

    if( count ==  0){
      DebugThis( "YOUR COUNT IS ZERO U DINKY DOO!");
    }
    
    if( intBuffer == true ){
      return new ComputeBuffer( count, sizeof(int) * structSize );
    }else{
      return new ComputeBuffer( count, sizeof(float) * structSize );
    }
  }

  public virtual int[] GetIntDNA(){
    return GetIntData();
  }

  public virtual float[] GetDNA(){
    return GetData();
  }


  public virtual void SetDNA(int[] dna){
    SetData(dna);
  }

  public virtual void SetDNA(float[] dna){
    SetData(dna);
  }

  public void ReleaseBuffer(){
   if(_buffer != null){ _buffer.Release(); }
  }

  public override void WhileDebug(){
    mpb.SetBuffer("_VertBuffer", _buffer);
    mpb.SetInt("_Count",count);
    
    Graphics.DrawProcedural(debugMaterial,  new Bounds(transform.position, Vector3.one * 5000), MeshTopology.Triangles, count * 3 * 2 , 1, null, mpb, ShadowCastingMode.Off, true, LayerMask.NameToLayer("Debug"));

  }

}
}