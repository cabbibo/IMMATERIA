using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace IMMATERIA {
public class GridBasedParticleCollisions : Simulation
{


    public Form3D grid;

    public Life resolve;

    public Life clearGridValues;
    public Life assignGridValues;

    public override void Create(){
        SafeInsert(resolve);
        SafeInsert(clearGridValues);
        SafeInsert(assignGridValues);
        SafeInsert(grid);
    }


    public override void Bind(){


        life.BindForm("_GridBuffer",grid);
        resolve.BindPrimaryForm(nameInBuffer,form);
        
        assignGridValues.BindPrimaryForm(nameInBuffer,form);
        assignGridValues.BindForm("_GridBuffer", grid );
        
        clearGridValues.BindPrimaryForm("_GridBuffer", grid );


    }


}}
