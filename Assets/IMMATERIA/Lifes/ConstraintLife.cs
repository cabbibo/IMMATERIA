using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class ConstraintLife : Life{


  public int numPasses = 2;
  public int numIterations = 1;
  public override void GetNumGroups(){   
    
    float totalCount = (float)primaryForm.count * countMultiplier;
    if( totalCount != Mathf.Floor( totalCount )){ DebugThis("your count multiplier is not allowing proper total count");}
    numGroups = ((int)totalCount+((int)numThreads-1))/(int)numThreads;
   // numGroups = Mathf.Max( (primaryForm.count/2+((int)numThreads-1))/(int)numThreads,1);
  }



  public override void DoDispatch(){

    for( int i = 0; i < numIterations; i++ ){
      
      float value = (float)i/(float)numIterations;
      shader.SetFloat("_PassMultiplier", 1 - value);
      for( int j= 0; j < numPasses; j++ ){
      shader.SetInt("_Pass", j);
      shader.Dispatch( kernel,numGroups ,1,1);
      }
    }


  }
}
}


