#!/usr/bin/env bash
SPEC_DIR=/home/xieby1/Codes/MyRepos/spec2017/musl
RUN_IDX=run_base_refrate_nix.0000
EXT=nix
N=${N:=(($(nproc)))}

cmd=(
# intrate
"${SPEC_DIR}/benchspec/CPU/500.perlbench_r/run/${RUN_IDX}"
"../${RUN_IDX}/perlbench_r_base.${EXT} -I./lib checkspam.pl 2500 5 25 11 150 1 1 1 1 > checkspam.2500.5.25.11.150.1.1.1.1.out 2>> checkspam.2500.5.25.11.150.1.1.1.1.err"
"../${RUN_IDX}/perlbench_r_base.${EXT} -I./lib diffmail.pl 4 800 10 17 19 300 > diffmail.4.800.10.17.19.300.out 2>> diffmail.4.800.10.17.19.300.err"
"../${RUN_IDX}/perlbench_r_base.${EXT} -I./lib splitmail.pl 6400 12 26 16 100 0 > splitmail.6400.12.26.16.100.0.out 2>> splitmail.6400.12.26.16.100.0.err"

"${SPEC_DIR}/benchspec/CPU/502.gcc_r/run/${RUN_IDX}"
"../${RUN_IDX}/cpugcc_r_base.${EXT} gcc-pp.c -O3 -finline-limit=0 -fif-conversion -fif-conversion2 -o gcc-pp.opts-O3_-finline-limit_0_-fif-conversion_-fif-conversion2.s > gcc-pp.opts-O3_-finline-limit_0_-fif-conversion_-fif-conversion2.out 2>> gcc-pp.opts-O3_-finline-limit_0_-fif-conversion_-fif-conversion2.err"
"../${RUN_IDX}/cpugcc_r_base.${EXT} gcc-pp.c -O2 -finline-limit=36000 -fpic -o gcc-pp.opts-O2_-finline-limit_36000_-fpic.s > gcc-pp.opts-O2_-finline-limit_36000_-fpic.out 2>> gcc-pp.opts-O2_-finline-limit_36000_-fpic.err"
"../${RUN_IDX}/cpugcc_r_base.${EXT} gcc-smaller.c -O3 -fipa-pta -o gcc-smaller.opts-O3_-fipa-pta.s > gcc-smaller.opts-O3_-fipa-pta.out 2>> gcc-smaller.opts-O3_-fipa-pta.err"
"../${RUN_IDX}/cpugcc_r_base.${EXT} ref32.c -O5 -o ref32.opts-O5.s > ref32.opts-O5.out 2>> ref32.opts-O5.err"
"../${RUN_IDX}/cpugcc_r_base.${EXT} ref32.c -O3 -fselective-scheduling -fselective-scheduling2 -o ref32.opts-O3_-fselective-scheduling_-fselective-scheduling2.s > ref32.opts-O3_-fselective-scheduling_-fselective-scheduling2.out 2>> ref32.opts-O3_-fselective-scheduling_-fselective-scheduling2.err"

"${SPEC_DIR}/benchspec/CPU/505.mcf_r/run/${RUN_IDX}"
"../${RUN_IDX}/mcf_r_base.${EXT} inp.in  > inp.out 2>> inp.err"

"${SPEC_DIR}/benchspec/CPU/520.omnetpp_r/run/${RUN_IDX}"
"../${RUN_IDX}/omnetpp_r_base.${EXT} -c General -r 0 > omnetpp.General-0.out 2>> omnetpp.General-0.err"

"${SPEC_DIR}/benchspec/CPU/523.xalancbmk_r/run/${RUN_IDX}"
"../${RUN_IDX}/cpuxalan_r_base.${EXT} -v t5.xml xalanc.xsl > ref-t5.out 2>> ref-t5.err"

"${SPEC_DIR}/benchspec/CPU/525.x264_r/run/${RUN_IDX}"
"../${RUN_IDX}/x264_r_base.${EXT} --pass 1 --stats x264_stats.log --bitrate 1000 --frames 1000 -o BuckBunny_New.264 BuckBunny.yuv 1280x720 > run_000-1000_x264_r_base.sora-m64_x264_pass1.out 2>> run_000-1000_x264_r_base.sora-m64_x264_pass1.err"
"../${RUN_IDX}/x264_r_base.${EXT} --pass 2 --stats x264_stats.log --bitrate 1000 --dumpyuv 200 --frames 1000 -o BuckBunny_New.264 BuckBunny.yuv 1280x720 > run_000-1000_x264_r_base.sora-m64_x264_pass2.out 2>> run_000-1000_x264_r_base.sora-m64_x264_pass2.err"
"../${RUN_IDX}/x264_r_base.${EXT} --seek 500 --dumpyuv 200 --frames 1250 -o BuckBunny_New.264 BuckBunny.yuv 1280x720 > run_0500-1250_x264_r_base.sora-m64_x264.out 2>> run_0500-1250_x264_r_base.sora-m64_x264.err"

"${SPEC_DIR}/benchspec/CPU/531.deepsjeng_r/run/${RUN_IDX}"
"../${RUN_IDX}/deepsjeng_r_base.${EXT} ref.txt > ref.out 2>> ref.err"

"${SPEC_DIR}/benchspec/CPU/541.leela_r/run/${RUN_IDX}"
"../${RUN_IDX}/leela_r_base.${EXT} ref.sgf > ref.out 2>> ref.err"

"${SPEC_DIR}/benchspec/CPU/548.exchange2_r/run/${RUN_IDX}"
"../${RUN_IDX}/exchange2_r_base.${EXT} 6 > exchange2.txt 2>> exchange2.err"

"${SPEC_DIR}/benchspec/CPU/557.xz_r/run/${RUN_IDX}"
"../${RUN_IDX}/xz_r_base.${EXT} cld.tar.xz 160 19cf30ae51eddcbefda78dd06014b4b96281456e078ca7c13e1c0c9e6aaea8dff3efb4ad6b0456697718cede6bd5454852652806a657bb56e07d61128434b474 59796407 61004416 6 > cld.tar-160-6.out 2>> cld.tar-160-6.err"
"../${RUN_IDX}/xz_r_base.${EXT} cpu2006docs.tar.xz 250 055ce243071129412e9dd0b3b69a21654033a9b723d874b2015c774fac1553d9713be561ca86f74e4f16f22e664fc17a79f30caa5ad2c04fbc447549c2810fae 23047774 23513385 6e > cpu2006docs.tar-250-6e.out 2>> cpu2006docs.tar-250-6e.err"
"../${RUN_IDX}/xz_r_base.${EXT} input.combined.xz 250 a841f68f38572a49d86226b7ff5baeb31bd19dc637a922a972b2e6d1257a890f6a544ecab967c313e370478c74f760eb229d4eef8a8d2836d233d3e9dd1430bf 40401484 41217675 7 > input.combined-250-7.out 2>> input.combined-250-7.err"

# fprate
"${SPEC_DIR}/benchspec/CPU/503.bwaves_r/run/${RUN_IDX}"
"../${RUN_IDX}/bwaves_r_base.${EXT} bwaves_1 < bwaves_1.in > bwaves_1.out 2>> bwaves_1.err"
"../${RUN_IDX}/bwaves_r_base.${EXT} bwaves_2 < bwaves_2.in > bwaves_2.out 2>> bwaves_2.err"
"../${RUN_IDX}/bwaves_r_base.${EXT} bwaves_3 < bwaves_3.in > bwaves_3.out 2>> bwaves_3.err"
"../${RUN_IDX}/bwaves_r_base.${EXT} bwaves_4 < bwaves_4.in > bwaves_4.out 2>> bwaves_4.err"

"${SPEC_DIR}/benchspec/CPU/507.cactuBSSN_r/run/${RUN_IDX}"
"../${RUN_IDX}/cactusBSSN_r_base.${EXT} spec_ref.par   > spec_ref.out 2>> spec_ref.err"

"${SPEC_DIR}/benchspec/CPU/544.nab_r/run/${RUN_IDX}"
"../${RUN_IDX}/nab_r_base.${EXT} 1am0 1122214447 122 > 1am0.out 2>> 1am0.err"

"${SPEC_DIR}/benchspec/CPU/508.namd_r/run/${RUN_IDX}"
"../${RUN_IDX}/namd_r_base.${EXT} --input apoa1.input --output apoa1.ref.output --iterations 65 > namd.out 2>> namd.err"

"${SPEC_DIR}/benchspec/CPU/510.parest_r/run/${RUN_IDX}"
"../${RUN_IDX}/parest_r_base.${EXT}  ref.prm > ref.out 2>> ref.err"

"${SPEC_DIR}/benchspec/CPU/511.povray_r/run/${RUN_IDX}"
"../${RUN_IDX}/povray_r_base.${EXT}  SPEC-benchmark-ref.ini > SPEC-benchmark-ref.stdout 2>> SPEC-benchmark-ref.stderr"

"${SPEC_DIR}/benchspec/CPU/519.lbm_r/run/${RUN_IDX}"
"../${RUN_IDX}/lbm_r_base.${EXT} 3000 reference.dat 0 0 100_100_130_ldc.of > lbm.out 2>> lbm.err"

"${SPEC_DIR}/benchspec/CPU/521.wrf_r/run/${RUN_IDX}"
"../${RUN_IDX}/wrf_r_base.${EXT} > rsl.out.0000 2>> wrf.err"

"${SPEC_DIR}/benchspec/CPU/526.blender_r/run/${RUN_IDX}"
"../${RUN_IDX}/blender_r_base.${EXT} sh3_no_char.blend --render-output sh3_no_char_ --threads 1 -b -F RAWTGA -s 849 -e 849 -a > sh3_no_char.849.spec.out 2>> sh3_no_char.849.spec.err"

"${SPEC_DIR}/benchspec/CPU/527.cam4_r/run/${RUN_IDX}"
"../${RUN_IDX}/cam4_r_base.${EXT} > cam4_r_base.sora-m64.txt 2>> cam4_r_base.sora-m64.err"

"${SPEC_DIR}/benchspec/CPU/538.imagick_r/run/${RUN_IDX}"
"../${RUN_IDX}/imagick_r_base.${EXT} -limit disk 0 refrate_input.tga -edge 41 -resample 181% -emboss 31 -colorspace YUV -mean-shift 19x19+15% -resize 30% refrate_output.tga > refrate_convert.out 2>> refrate_convert.err"

"${SPEC_DIR}/benchspec/CPU/544.nab_r/run/${RUN_IDX}"
"../${RUN_IDX}/nab_r_base.${EXT} 1am0 1122214447 122 > 1am0.out 2>> 1am0.err"

"${SPEC_DIR}/benchspec/CPU/549.fotonik3d_r/run/${RUN_IDX}"
"../${RUN_IDX}/fotonik3d_r_base.${EXT} > fotonik3d_r.log 2>> fotonik3d_r.err"

"${SPEC_DIR}/benchspec/CPU/554.roms_r/run/${RUN_IDX}"
"../${RUN_IDX}/roms_r_base.${EXT} < ocean_benchmark2.in.x > ocean_benchmark2.log 2>> ocean_benchmark2.err"
)

for line in "${cmd[@]}"; do
    if [[ ${line:0:1} == "/" ]]; then
        dir="$line"
        idx=0
        name=${line#*Crate_Int/}
        name=${name%/run*}
        name=${name%/run*}
    else
        # interp="${QEMU} -d plugin -D ${PLUGIN_LOG_DIR}/${name}.${idx}.txt -plugin ${PLUGIN}"
        (
        echo "cd ${dir}"
        cd "${dir}" || exit
        echo "${interp} ${line}"
        eval "${interp} ${line}"
        ) &
        if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
            wait -n
        fi
        (( idx++ ))
    fi
done
wait
