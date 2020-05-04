using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA{
public class UpdateAnimatorInEditMode : Cycle
{
  public Animator animator;
  public string animationName;

    public override void Create(){
      if( Application.isPlaying == false ){  animator.Play(animationName,0); }
    }
  public override void WhileLiving(float v){
    if( Application.isPlaying == false ){  animator.Update(Time.deltaTime); }
  }
}
}