void interlockedAddFloat4(float4 value , int threadid)
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
    fullValue += result;
  } 
  GroupMemoryBarrierWithGroupSync();
  
}
