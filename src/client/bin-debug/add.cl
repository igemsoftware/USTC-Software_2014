__kernel void nbody_sim(__global float2* pos,int numBodies,__global float2* acc) {
	unsigned int gid = get_global_id(0);
	float2 myPos = pos[gid];
	float2 acc1 = (float2)0.0f;

	int i = 0;
	for (; i < numBodies; i++) {
		float2 p = pos[i];
		float2 r;
		r.xy = p.xy - myPos.xy;
		float distSqr = r.x * r.x  +  r.y * r.y ;
		float invDist = 1.0f / sqrt(distSqr + 100);
		float invDistCube = invDist * invDist * invDist;
		float s = 200000* invDistCube;

		// accumulate effect of all particles
		acc1.xy -= s * r.xy;
	}
	// write to global memory
	acc[gid] = acc1;
}