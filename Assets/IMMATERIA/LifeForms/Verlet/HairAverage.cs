
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;

namespace IMMATERIA {
public class HairAverage : Cycle {

  public Life set;
  public Life collision;
  public Life constraint;
  public Life resolve;

  public Form Base;
  public Hair Hair;

  public float[] transformArray;

  public override void Create(){

    transformArray = new float[16];

    
    /*  
      All of this info should be visualizable!
    */

    SafePrepend( set );
    SafePrepend( collision );
    SafePrepend( constraint );
    SafePrepend( resolve );
    SafePrepend( Hair );

    //Cycles.Insert( 4 , Base );


  }


  public override void Bind(){

    set.BindPrimaryForm("_VertBuffer", Hair);
    set.BindForm("_BaseBuffer", Base );

    collision.BindPrimaryForm("_VertBuffer", Hair);
    collision.BindForm("_BaseBuffer", Base ); 

    constraint.BindInt("_Pass" , 0 );
    constraint.BindPrimaryForm("_VertBuffer", Hair);
    constraint.BindInt( "_NumVertsPerHair" , () => Hair.numVertsPerHair );

    resolve.BindPrimaryForm("_VertBuffer", Hair);
    resolve.BindInt( "_NumVertsPerHair" , () => Hair.numVertsPerHair );

    set.BindFloat( "_HairLength"  , () => Hair.length);
    set.BindFloat( "_HairVariance"  , () => Hair.variance);
    set.BindInt( "_NumVertsPerHair" , () => Hair.numVertsPerHair );

    // Don't need to bind for all of them ( constraints ) because same shader
    collision.BindFloat( "_HairLength"  , () => Hair.length );
    collision.BindFloat( "_HairVariance"  , () => Hair.variance );
    collision.BindInt( "_NumVertsPerHair" , () => Hair.numVertsPerHair );
    collision.BindFloats( "_Transform" , () => this.transformArray );

    data.BindCameraData(collision);

  }


  public override void OnBirth(){
    set.active = true;
  }

  public override void Activate(){
    set.active = true;
  }

  public override void WhileLiving(float v){
    
    //set.active = false;
    transformArray = HELP.GetMatrixFloats( transform.localToWorldMatrix );
  }

  public void Set(){
    set.YOLO();
  }


}
}