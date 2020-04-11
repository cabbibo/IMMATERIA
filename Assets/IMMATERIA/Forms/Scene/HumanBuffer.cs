using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class HumanBuffer : Form
{


public int headForce;

public Human[] humans;
private float[] values;

/*

lefthand
righthand
head
leftTriggerDown
rightTriggerDown
voice
id
humanType
leftHandActive
rightHandActive
debug

16 * 3 + 4 + 4

*/
float[] tmp;

public override void Create(){
  count = humans.Length;
  count = Mathf.Max( count , 1 );
  values = new float[count * (16 * 3 + 4 + 4)];
}

public override void SetStructSize(){
  structSize = 16 * 3 + 4 + 4;
}


public override void WhileLiving(float v){

  for( int i = 0; i < count; i++ ){

    tmp = HELP.GetMatrixFloats(humans[i].LeftHand.localToWorldMatrix);
    for(int j=0; j < 16; j ++ ){
      values[i * structSize + j] =tmp[j]; 
    }

    tmp = HELP.GetMatrixFloats(humans[i].RightHand.localToWorldMatrix);
    for(int j=0; j < 16; j ++ ){
      values[i * structSize + 16 + j] =tmp[j]; 
    }

    tmp = HELP.GetMatrixFloats(humans[i].Head.localToWorldMatrix);
    for(int j=0; j < 16; j ++ ){
      values[i * structSize + 32 + j] =tmp[j]; 
    }

    values[i * structSize + 48 + 0 ]= humans[i].LeftTrigger;
    values[i * structSize + 48 + 1 ]= humans[i].RightTrigger;
    values[i * structSize + 48 + 2 ]= humans[i].Voice;
    values[i * structSize + 48 + 3 ]= humans[i].DebugVal;

  }

  SetData( values );

  // Toggles head force
  if( Input.GetKeyDown( KeyCode.Space )){
    headForce = 1 - headForce;
  }

}



}
}