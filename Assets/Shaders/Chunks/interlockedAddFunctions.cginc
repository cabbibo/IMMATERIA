// Using groupshared memory to be able to
// add values together !

// want to use about 1-2k per 64 threads
groupshared float4 accumVal[NR_THREADS];
groupshared float4 interlockedFullValue;


void interlockedAddFloat4(float4 value , int threadid  )
{
  accumVal[threadid] = value;

  // accumulate a bit in parralel
  GroupMemoryBarrierWithGroupSync();
  if((threadid&0x3)==0){
    accumVal[threadid+0] += (accumVal[threadid+1] + accumVal[threadid+2] + accumVal[threadid+3]);
  }
  GroupMemoryBarrierWithGroupSync();
  if(threadid==0){
    float4 result = accumVal[0];
    for(int i=4; i<NR_THREADS; i+=0x4)  { result += accumVal[i]; }
    interlockedFullValue += result;
  }
  GroupMemoryBarrierWithGroupSync();

}

void interlockedAddFloat3(float3 value , int threadid ){

  accumVal[threadid].xyz = value;

  // accumulate a bit in parralel
  GroupMemoryBarrierWithGroupSync();
  if((threadid&0x3)==0){
    accumVal[threadid+0].xyz += (accumVal[threadid+1].xyz + accumVal[threadid+2].xyz + accumVal[threadid+3].xyz);
  }
  GroupMemoryBarrierWithGroupSync();
  if(threadid==0){
    float3 result = accumVal[0].xyz;
    for(int i=4; i<NR_THREADS; i+=0x4)  { result += accumVal[i].xyz; }
    interlockedFullValue.xyz += result;
  }
  GroupMemoryBarrierWithGroupSync();

}


void interlockedAddFloat2(float2 value , int threadid ){

  accumVal[threadid].xy = value;

  // accumulate a bit in parralel
  GroupMemoryBarrierWithGroupSync();
  if((threadid&0x3)==0){
    accumVal[threadid+0].xy += (accumVal[threadid+1].xy + accumVal[threadid+2].xy + accumVal[threadid+3].xy);
  }
  GroupMemoryBarrierWithGroupSync();
  if(threadid==0){
    float2 result = accumVal[0].xy;
    for(int i=4; i<NR_THREADS; i+=0x4)  { result += accumVal[i].xy; }
    interlockedFullValue.xy += result;
  }
  GroupMemoryBarrierWithGroupSync();

}

void interlockedAddFloat(float value , int threadid ){

  accumVal[threadid].x = value;

  // accumulate a bit in parralel
  GroupMemoryBarrierWithGroupSync();
  if((threadid&0x3)==0){
    accumVal[threadid+0].x += (accumVal[threadid+1].x + accumVal[threadid+2].x + accumVal[threadid+3].x);
  }
  GroupMemoryBarrierWithGroupSync();
  if(threadid==0){
    float result = accumVal[0].x;
    for(int i=4; i<NR_THREADS; i+=0x4)  { result += accumVal[i].x; }
    interlockedFullValue.x += result;
  }
  GroupMemoryBarrierWithGroupSync();

}


void resetValue(int threadid){

  GroupMemoryBarrierWithGroupSync();

  // Only one thread needs to intialize
  if(threadid==0){
    interlockedFullValue = float4(-1,-1,-1,-1);
  }

  GroupMemoryBarrierWithGroupSync();

}


void interlockedClosestLength(float4 value , int threadid ){


  GroupMemoryBarrierWithGroupSync();
  accumVal[threadid] = value;

  // accumulate a bit in parralel
  GroupMemoryBarrierWithGroupSync();
  if((threadid%4)==0){

    float4 fVal = float4(10000000,-1,-1,-1);

    for( int i = 0; i < 4; i++){
      float4 v = accumVal[threadid + i ];
      if( v.x > 0 && v.x < fVal.x ){
        fVal = v;
      }

    }

    accumVal[threadid+0] = fVal;

  }

  GroupMemoryBarrierWithGroupSync();
  if(threadid==0){
    float4 result = accumVal[0];
    for(int i=4; i<NR_THREADS; i+=4){
      if( accumVal[i].x > 0 && accumVal[i].x < result.x ){
        result = accumVal[i];
      }

    }
    interlockedFullValue = result;
  }
  GroupMemoryBarrierWithGroupSync();

}
