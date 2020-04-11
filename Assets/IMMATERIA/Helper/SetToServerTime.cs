using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class SetToServerTime : Cycle
{

  public Animator animator;
  public string startAnimationName;

  public float oT;
  public float delta;
  public override void Create(){
    if( animator == null ){ animator = GetComponent<Animator>();}
  }

  public override void OnBirthed(){
    animator.Play("startAnimationName", 0, 0.0f);
    oT = data.time;
  }

  public override void WhileLiving(float v){
    delta = data.time - oT;
    animator.Update(delta);
    oT = data.time;
  }
}
}