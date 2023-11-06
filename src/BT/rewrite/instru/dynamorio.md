<div style="text-align:right; font-size:3em;">2023.10.21</div>

* $ drrun ~/Gist/hello/helloworld.musl.static
  * tools/drdeploy.c:2059 _tmain(...)
    * tools/drdeploy.c:711 dr_inject_process_inject(data, force_injection=false, library_path=NULL)
      * core/unix/injector.c: inject_early(info=data, library_path="/home/xieby1/Codes/dynamorio/build/lib64/release/libdynamorio.so")
        * pre_execve_early: // set env DYNAMORIO_VAR_EXE_PATH to info->exe, that is "/home/xieby1/Gist/hello/helloworld.musl.static"
        * execute_exec(...) //  DYNAMORIO_EXE_PATH=/home/xieby1/Gist/hello/helloworld.musl.static ./build/lib64/release/libdynamorio.so <argv>, here argv is /home/xieby1/Gist/hello/helloworld.musl.static

* DYNAMORIO_EXE_PATH=/home/xieby1/Gist/hello/helloworld.musl.static ./build/lib64/release/libdynamorio.so <argv>, here argv is /home/xieby1/Gist/hello/helloworld.musl.static
  * core/arch/x86/x86.asm:1144 _start
  * core/arch/x86/x86.asm:1158 CALLC3 relocate_dynamorio
  * core/arch/x86/x86.asm:1178 CALLC0 privload_early_inject
    * ./core/unix/loader.c:2046 privload_early_inject(...)
    * ./core/unix/loader.c:2107 exe_path = getenv(DYNAMORIO_VAR_EXE_PATH); // exe_path="/home/xieby1/Gist/hello/helloworld.musl.static"
    * ./core/unix/loader.c:2107 entry = (app_pc)exe_ld.ehdr->e_entry + exe_ld.load_delta; // e_entry is 0x401032, where load_delta is 0
    * ./core/unix/loader.c:2284 memset(&mc, 0, sizeof(mc));
    * ./core/unix/loader.c:2285 mc.xsp = (reg_t)sp;
    * ./core/unix/loader.c:2286 mc.pc = entry;
    * ./core/unix/loader.c:2287 dynamo_start(&mc);
      * core/arch/x86_code.c:86 dynamo_start(priv_mcontext_t *mc) // priv means private?
      * core/arch/x86_code.c:86 call_switch_stack(..., (void (*)(void *))d_r_dispatch, ...);
        * core/dispatch.c:131 d_r_dispatch(dcontext_t *dcontext)



