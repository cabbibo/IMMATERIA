using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace IMMATERIA{
public class SDFFromMesh : Simulation
{

  public Body mesh;
  public int iterationsPerFrame;
  
  public int currentStep;
  public float percentageDone;

  public Life finalLife;

  public bool finished;

  public override void Create(){
    SafeInsert(finalLife);
  }

  public override void OnBirthed(){
    if( form.alwaysRemake ){ 
      currentStep = 0; 
      percentageDone = 0;
      finished = false;
    }else{
      finished = true;
    }

    life.active = false;

  }

  public override void Bind(){

    life.BindInt( "_CurrentStep" , () => currentStep );
    life.BindFloat( "_PercentageDone" , () => percentageDone );
    
    life.BindMatrix( "_Transform", () => transform.localToWorldMatrix );
    life.BindMatrix( "_InverseTransform", () => transform.worldToLocalMatrix );

    life.BindForm("_VertBuffer" , mesh.verts);
    life.BindForm("_TriBuffer" , mesh.triangles);

    life.BindVector3( "_Center"      , () => ((Form3D)form).center );
    life.BindVector3( "_Dimensions"  , () => ((Form3D)form).dimensions );
    life.BindVector3( "_Extents"     , () => ((Form3D)form).extents );


    finalLife.BindPrimaryForm("_VolumeBuffer" , form );
    finalLife.BindInt( "_CurrentStep" , () => currentStep );
    finalLife.BindFloat( "_PercentageDone" , () => percentageDone );
    
    finalLife.BindMatrix( "_Transform", () => transform.localToWorldMatrix );
    finalLife.BindMatrix( "_InverseTransform", () => transform.worldToLocalMatrix );


    finalLife.BindVector3( "_Center"      , () => ((Form3D)form).center );
    finalLife.BindVector3( "_Dimensions"  , () => ((Form3D)form).dimensions );
    finalLife.BindVector3( "_Extents"     , () => ((Form3D)form).extents );

  }

  public override void WhileLiving( float v ){


    if( !finished ){
    for( int i = 0; i < iterationsPerFrame; i++ ){
      percentageDone = (float)currentStep / (float)mesh.triangles.count;
      currentStep += 3;
      life.YOLO();

      if( percentageDone >= 1 ){
        OnComplete();
        break;
      }
    }}

  }

  public void OnComplete(){
    finalLife.YOLO();
    ((Form3D)form).MakeTexture();
    Saveable.Save(form);
    finished = true;
  }

}}
