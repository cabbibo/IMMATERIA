using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {

public class TransferLifeForm : Cycle {


  public Form verts;
  public IndexForm triangles; 
  public Life transfer;
  public Body body;
  public bool showBody;
  public Form skeleton;
  public float radius;

  public float[] transformArray;

  public Binder[] binders;


  // Use this for initialization
  public override void _Create(){

    _Destroy();


    transformArray = new float[16];


    
    binders = GetComponents<Binder>();
    for( int i = 0 ; i < binders.Length; i++ ){
      SafeInsert( binders[i] );
    }

    if( body == null ){ body = GetComponent<Body>(); }
    if( transfer == null ){ transfer = GetComponent<Life>();}
    if( verts == null ){ verts = GetComponent<Form>();}
    if( triangles == null ){ triangles = GetComponent<IndexForm>();}

    DebugThis(""+body.GetType());

    SafeInsert(body);
    SafeInsert(transfer);

    DoCreate();

  }

  public override void _Bind(){
    transfer.BindPrimaryForm("_VertBuffer", verts);
    transfer.BindForm("_SkeletonBuffer", skeleton); 

    data.BindCameraData( transfer );
    
    transfer.BindFloat("_Radius" , () => this.radius ); 
    transfer.BindMatrix("_Transform", () => transform.localToWorldMatrix );
    
    Bind();
  }

  public virtual void BindAttributes(){}

  public override void WhileLiving(float v){


    if( active == true ){

      if( showBody == true ){
        body.active = true;
      }else{
        body.active = false;
      }

      
    }

  }

  public override void Activate(){
    showBody = true;
  }

  public override void Deactivate(){
    showBody = false;
  }

}
}