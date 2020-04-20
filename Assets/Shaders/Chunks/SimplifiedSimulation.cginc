  int pID = id.x;
  pID = safeID(pID,_VertBuffer_COUNT);
  Vert vert = _VertBuffer[pID];


  if( vert.pos.x == 0  && vert.pos.y == 0 && vert.pos.z == 0 ){
    DoInit(vert, float(pID));
  }
  
  /*if( vert.life == 0 ){ vert.life = hash(float(pID));}
  if( length(vert.axis) == 0 ){ vert.axis = newAxis(float(pID)); }
  
  vert.nor = mul(rotation(vert.axis,vert.life*10*(hash(float(pID*123))+1)),float4(0,0,1,0)).xyz;*/

  if( vert.life < 0 ){

    vert.pos = DoRemitPosition(pID);
    vert.vel = DoRemitVelocity(pID);
    vert.life = 1;//
  
  }else{

    float3 force = DoForce( vert , pID); //float3(0,0,0);

    vert.vel += force;/// * .00004 * (1+hash(pID*1021.))/2;

    vert.life -= DoLife( vert , pID );//.0004 * (3+sin(float(pID)));
    vert.pos += vert.vel;

    vert.vel *= DoDampening( vert , pID );

  }


  
  _VertBuffer[pID] = vert;