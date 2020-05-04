using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class ForcesConstraintsResolve : Simulation
{


    public Life resolve;

    public override void Create(){
        SafeInsert(resolve);
    }


    public override void Bind(){

        resolve.BindPrimaryForm(nameInBuffer,form);


    }


}}
