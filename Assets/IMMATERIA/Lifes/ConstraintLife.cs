using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class ConstraintLife : Life{


  public int numberOfPasses = 1;
  public override void GetNumGroups(){
    numGroups = Mathf.Max( (primaryForm.count/2+((int)numThreads-1))/(int)numThreads,1);
  }



  public override void DoDispatch(){

    for( int i = 0; i < numberOfPasses; i++ ){
      shader.SetFloat("_PassMultiplier", 1 - (float)i/(float)numberOfPasses);
      shader.SetInt("_Pass", 0);
      shader.Dispatch( kernel,numGroups ,1,1);
      shader.SetInt("_Pass", 1);
      shader.Dispatch( kernel,numGroups ,1,1);
    }


  }
}
}


