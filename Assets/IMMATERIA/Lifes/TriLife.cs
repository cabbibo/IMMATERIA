using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace IMMATERIA {
public class TriLife : CalcLife {
  
 public override void GetNumGroups(){
  numGroups = ((primaryForm.count/3)+((int)numThreads-1))/(int)numThreads;
 }

 

}
}