.amdgcn_target "amdgcn-amd-amdhsa--gfx942"
.text
.globl vector_add
.p2align 8
.type vector_add,@function
vector_add:
  s_load_dwordx2 s[4:5], s[0:1] 0      // s[4:7] for Srd a
  s_load_dwordx2 s[8:9], s[0:1] 8      // s[8:11] for Srd b
  s_load_dwordx2 s[12:13], s[0:1] 16   // s[12:15] for Srd c
  s_load_dword s[0], s[0:1] 24         // reuse s[0] for the number of elements
  s_mul_i32 s[6], s[0], 0x4            // calculate the Num_records in bytes for Srd a
  s_mul_i32 s[10], s[0], 0x4           // calculate the Num_records in bytes for Srd b
  s_mul_i32 s[14], s[0], 0x4           // calculate the Num_records in bytes for Srd c 
  s_mov_b32 s[7], 0x20000              // Specify the format for Srd a, refer to Buffer Resource Descriptor table
  s_mov_b32 s[11], 0x20000             // Specify the format for Srd b
  s_mov_b32 s[15], 0x20000             // Specify the format for Srd c
  v_lshl_add_u32 v0, s2, 8, v0         // s2 holds workgroup ID, g_tId = (workgroupId * workgroupSize) + tId where workgroupSize is 256 right here
  v_cmpx_lt_u32 vcc, v0, s0            // set exec mask in vcc register, it's 64 bits, each bit is for each lane
  v_lshlrev_b32 v2, 2, v0              // byte offset for each lane: g_tId * sizeof(float) because the data type is float
  s_waitcnt lgkmcnt(0)                 // wait for Srds
  buffer_load_dword v0, v2, s[4:7], 0 offen offset:0    // load each value to v0 from address of Srd a
  buffer_load_dword v1, v2, s[8:11], 0 offen offset:0   // load each value to v1 from address of Srd b
  s_waitcnt vmcnt(0)                   // wait for buffer load
  v_add_f32 v1, v0, v1                 // reuse v1 for the final result
  buffer_store_dword v1, v2, s[12:15], 0 offen offset:0 // store the value from v1 to the address of Srd c with thread-specific offset
  s_endpgm
.Lvector_add_end0:
  .size vector_add, .Lvector_add_end0 - vector_add

.rodata
.p2align 6
.amdhsa_kernel vector_add
  .amdhsa_user_sgpr_kernarg_segment_ptr 1
  .amdhsa_system_sgpr_workgroup_id_x 1
  .amdhsa_accum_offset 4
  .amdhsa_next_free_vgpr .amdgcn.next_free_vgpr
  .amdhsa_next_free_sgpr .amdgcn.next_free_sgpr
.end_amdhsa_kernel

.amdgpu_metadata
---
amdhsa.version:
 - 1
 - 1

amdhsa.kernels:
 - .name: vector_add
   .symbol: vector_add.kd
   .kernarg_segment_size: 32
   .group_segment_fixed_size: 0
   .private_segment_fixed_size: 0
   .kernarg_segment_align: 8
   .wavefront_size: 64
   .sgpr_count: 16
   .vgpr_count: 3
   .agpr_count: 0
   .max_flat_workgroup_size: 256
   .args:
     - .size: 8
       .offset: 0
       .value_kind: global_buffer
       .address_space: global
     - .size: 8
       .offset: 8
       .value_kind: global_buffer
       .address_space: global
     - .size: 8
       .offset: 16
       .value_kind: global_buffer
       .address_space: global
     - .size: 4
       .offset: 24
       .value_kind: by_value
.end_amdgpu_metadata
