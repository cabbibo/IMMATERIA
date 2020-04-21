
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;

namespace IMMATERIA {
public class HairBasic : Cycle {

  public Life set;
  public Life collision;
  
  public ConstraintLife constraint;
  public Form Base;
  public Hair Hair;

  public float[] transformArray;

public int numFrames;
  public override void Create(){

    transformArray = new float[16];
    if( Hair == null ){ Hair = gameObject.AddComponent<Hair>(); }
    if( set == null ){ set = gameObject.AddComponent<Life>(); }
    if( collision == null ){ collision = gameObject.AddComponent<Life>(); }
    if( constraint == null ){ constraint = gameObject.AddComponent<ConstraintLife>(); }

    
    /*  
      All of this info should be visualizable!
    */

    SafePrepend( set );
    SafePrepend( collision );
    SafePrepend( constraint );
    SafePrepend( Hair );

    //Cycles.Insert( 4 , Base );
    numFrames= 0;


  }


  public override void Bind(){

    set.BindPrimaryForm("_VertBuffer", Hair);
    set.BindForm("_BaseBuffer", Base );

    collision.BindPrimaryForm("_VertBuffer", Hair);
    collision.BindForm("_BaseBuffer", Base ); 

    constraint.BindFloat( "_HairLength"  , () => Hair.length );
    constraint.BindPrimaryForm("_VertBuffer", Hair);
    constraint.BindInt( "_NumVertsPerHair" , () => Hair.numVertsPerHair );

    set.BindFloat( "_HairLength"  , () => Hair.length);
    set.BindFloat( "_HairVariance"  , () => Hair.variance);
    set.BindInt( "_NumVertsPerHair" , () => Hair.numVertsPerHair );

    // Don't need to bind for all of them ( constraints ) because same shader
    collision.BindFloat( "_HairLength"  , () => Hair.length );
    collision.BindFloat( "_HairVariance"  , () => Hair.variance );
    collision.BindInt( "_NumVertsPerHair" , () => Hair.numVertsPerHair );
    collision.BindMatrix( "_Transform" , () => transform.localToWorldMatrix );

    data.BindCameraData(collision);

  }



  public override void WhileLiving(float v){

  numFrames += 1;

  if( numFrames == 3 ){ Set(); Activate(); }    
  }

  public void Set(){
      set.YOLO();
  }


}
}