<div style="text-align:right; font-size:3em;">2023.08.05</div>

`make spec2017/523.xalancbmk.0/xalancbmk.0.reg.bz2`
运行了100h+还未出结果。

<div style="text-align:right; font-size:3em;">2023.07.14</div>

```
$ sde_pinpoints.py --default_phases --program_name ls --input_name miao --sdehome /home/xieby1/Downloads/sde-external-9.21.1-2023-04-24-lin/ --mode=st --command ls -S 10000
│ sde_pinpoints.py: main()
└─┐ pinpoints.py: Run()
  └─┐ phases.py: Logger()
    ├─┐ $ sde_logger.py --log_file whole_program.miao/ls.miao  --global_file global.dat.9190 "ls"
    │ ├─┐ sde_logger.py: main()
    │ │ └─┐ logger.py: Run()
    │ │   │ $ sde_log.py --compressed=bzip2  --log_file whole_program.miao/ls.miao --log_options "-log:syminfo -log:pid "  --global_file global.dat.1103 -- "ls"
    │ │   └─┐ sde_log.py: main()
    │ │     └─┐ log.py: Run()
    │ │       └ $ /home/xieby1/Downloads/sde-external-9.21.1-2023-04-24-lin/sde -log -xyzzy  -log:basename whole_program.miao/ls.miao  -log:mt 0 -log:compressed bzip2 -log:syminfo -log:pid  -- ls
    │ └ 输出信息Finished generating whole program pinballs
    │ util.py: PrintInstrCount(...)
    ├── 读文件whole_program.miao/ls.miao_149.0.result，其中0指TID。
    │ 输出信息Generating basic block vectors
    │ phases.py: BasicBlockVector(...)
    ├─┐ sde_replay_dir.py --replay_dir whole_program.miao --log_options "-bbprofile -slice_size 10000" --bb_add_filename   --global_file global.dat.20959
    │ └─┐ sde_replay_dir.py: main()
    │   └─┐ replay_dir.py: Run()
    │     └─┐ replay_dir.py: ProcessCommandLine(...)
    │       └─┐ replay_dir.py: RunAllDir(..., Replay, ...)
    │         └─┐ $ sde_replayer.py --replay_file whole_program.miao/ls.miao_149 --log_options "-bbprofile -slice_size 10000 -o ls.miao_149.Data/ls.miao_149"  --global_file global.dat.5057
    │           └─┐ sde_replayer.py: main()
    │             └─┐ replayer.py: Run()
    │               └── $ /ome/xieby1/Downloads/sde-external-9.21.1-2023-04-24-lin/sde -p -xyzzy -p -reserve_memory -p whole_program.miao/ls.miao_149.address   -replay -xyzzy  -replay:deadlock_timeout 0  -replay:basename whole_program.miao/ls.miao_149 -replay:playout 0   -bbprofile -slice_size 10000 -o ls.miao_149.Data/ls.miao_149 -log:mt 0 -- /home/xieby1/Downloads/sde-external-9.21.1-2023-04-24-lin/intel64/nullapp
    │ 输出信息Finished basic block vector generation
    │ 输出信息Running Simpoint on all processes
    └─┐ pinpoints.py: util.RunAllDir(..., RunSimPoint,...)
      └─┐ phases.py: RunSimPoint()
        ├─┐ 输出信息Running Simpoints for
        │ │ $ simpoint.py --bbv_file ls.miao_149.T.0.bb --data_dir ls.miao_149.Data --simpoint_file ls.miao_149 -f 0 --maxk 20 --cutoff 1.0  --global_file global.dat.16576  --global_file global.dat.30995
        │ └─┐ simpoint.py: main()->Run()
        │   └─┐ 进入Data文件夹，复制bbv_file为t.bb
        │     │ simpoint.ppy: NormProjectBBV(...)
        │     ├─┐ $ regions.py --project_bbv --bbv_file t.bb --dimensions 16
        │     │ └── 生成projected_t.bb
        │     │ simpoint.ppy: RunSimpoint(...)
        │     ├─┐ $ simpoint -loadFVFile t.bb -coveragePct 1.0 -maxK 20 -saveSimpoints ./t.simpoints -saveSimpointWeights ./t.weights -saveLabels t.labels
        │     │ └── 生成simpoint.out
        │     │ simpoint.ppy: GenRegionCSVFile(...)                  $ regions.py -f 0 --csv_region  --bbv_file t.bb --region_file t.simpoints --weight_file t.weights
        │     └─┐ $ regions.py -f 0 --csv_region  --bbv_file t.bb --region_file t.simpoints --weight_file t.weights
        │       └── 生成ls.miao_149.pinpoints.csv
        │ 输出信息Finished running Simpoint for all processes
        │ 输出信息Generating region pinballs
        └─┐ phases.py: MultiIterGenRegionPinballs(...)
          └─┐ util.RunAllDir(..., self.GetMaxClusters, ...)
            │ util.RunAllDir(..., self.SetFirstIterCSV, ...)
            ├─┐ phases.py: SetFirstIterCSV(...)
            │ └── 输出信息Setup original CSV file for iteration 1 in dir
            │ 输出信息Iteration 1 generating pinballs
            │ phases.py: GenAllRegionPinballs(...)
            └─┐ phases.py: GenRegionPinballs(...)
              ├─┐ $ sde_replayer.py --replay_file whole_program.miao/ls.miao_149 --log_options " -log -xyzzy -regions:in ls.miao_149.pinpoints.in.csv -regions:out ls.miao_149.pinpoints.out.csv -regions:warmup 1500 -regions:prolog 0 -regions:epilog 0 -log:basename ls.miao_149.pp/ls.miao_149 -log:compressed bzip2  -log:focus_thread 0"  --global_file global.dat.25878
              │ └── $ /home/xieby1/Downloads/sde-external-9.21.1-2023-04-24-lin/sde -p -xyzzy -p -reserve_memory -p whole_program.miao/ls.miao_149.address   -replay -xyzzy  -replay:deadlock_timeout 0  -replay:basename whole_program.miao/ls.miao_149 -replay:playout 0    -log -xyzzy -regions:in ls.miao_149.pinpoints.in.csv -regions:out ls.miao_149.pinpoints.out.csv -regions:warmup 1500 -regions:prolog 0 -regions:epilog 0 -log:basename ls.miao_149.pp/ls.miao_149 -log:compressed bzip2  -log:focus_thread 0 -log:mt 0 -- /home/xieby1/Downloads/sde-external-9.21.1-2023-04-24-lin/intel64/nullapp
              │ phases.py: util.RunAllDir(..., self.GetNextRegionCSV, ...)
              └ 若out.csv不空，out.csv变in.csv则再来一遍
```

尝试复现

```
$ sde -log -xyzzy  -log:basename whole_program.wang/ls.wang  -log:mt 0 -log:compressed bzip2 -log:syminfo -log:pid  -- ls
  生成文件whole_program.wang/
  ls.wang_854.0.dyn_text.bz2  ls.wang_854.address     ls.wang_854.procinfo.xml
  ls.wang_854.0.reg.bz2       ls.wang_854.cpuid.def   ls.wang_854.text.bz2
  ls.wang_854.0.result        ls.wang_854.global.log  
  ls.wang_854.0.sel.bz2       ls.wang_854.log.txt
$ mkdir ls.wang_854.Data
$ ./sde -p -xyzzy -p -reserve_memory -p whole_program.wang/ls.wang_854.address   -replay -xyzzy  -replay:deadlock_timeout 0  -replay:basename whole_program.wang/ls.wang_854 -replay:playout 0   -bbprofile -slice_size 10000 -o ls.wang_854.Data/ls.wang_854 -log:mt 0 -- /home/xieby1/Downloads/sde-external-9.21.1-2023-04-24-lin/intel64/nullapp
  生成文件
  ls.wang_854.Data/ls.wang_854.T.0.bb
  whole_program.wang/ls.wang_854.replay.txt
$ cd ls.wang_854.Data
$ cp ls.wang_854.T.0.bb t.bb
$ /home/xieby1/Downloads/sde-external-9.21.1-2023-04-24-lin/pinplay-scripts/regions.py --project_bbv --bbv_file t.bb --dimensions 16 > projected_t.bb
  生成文件
  ls.wang_854.Data/projected_t.bb
$ /home/xieby1/Downloads/sde-external-9.21.1-2023-04-24-lin/pinplay-scripts/PinPointsHome/Linux/bin/SimPoint.3.2/bin/simpoint -loadFVFile t.bb -coveragePct 1.0 -maxK 20 -saveSimpoints ./t.simpoints -saveSimpointWeights ./t.weights -saveLabels t.labels
  生成文件ls.wang_854.Data/
  t.labels  t.simpoints  t.weights
$ regions.py -f 0 --csv_region  --bbv_file t.bb --region_file t.simpoints --weight_file t.weights > ls.wang_854.pinpoints.csv
  生成文件ls.wang_854.Data/ls.wang_854.pinpoints.csv
$ cd ..
$ cp ls.wang_854.Data/ls.wang_854.pinpoints.csv ./ls.wang_854.pinpoints.in.csv
$ mkdir ls.wang_854.pp
$ ./sde -p -xyzzy -p -reserve_memory -p whole_program.wang/ls.wang_854.address   -replay -xyzzy  -replay:deadlock_timeout 0  -replay:basename whole_program.wang/ls.wang_854 -replay:playout 0    -log -xyzzy -regions:in ls.wang_854.pinpoints.in.csv -regions:out ls.wang_854.pinpoints.out.csv -regions:warmup 1500 -regions:prolog 0 -regions:epilog 0 -log:basename ls.wang_854.pp/ls.wang_854 -log:compressed bzip2  -log:focus_thread 0 -log:mt 0 -- /home/xieby1/Downloads/sde-external-9.21.1-2023-04-24-lin/intel64/nullapp
  生成文件ls.wang_854.pp/*
```

尝试使用pinball2elf，gem5修复了/proc/self/environ（返回空的文件），可以正常运行。


<div style="text-align:right; font-size:3em;">2023.07.17</div>

用ubuntu16 gcc5编译出来的spec 2000的memset使用了vinserti128 AVX2指令。
gem5 v23并未实现。

<div style="text-align:right; font-size:3em;">2023.07.19</div>

spec2000 gzip测试

```bash
sde64 -log -xyzzy  -log:basename whole_program/gzip  -log:mt 0 -log:compressed bzip2 -log:syminfo -log:fat -- ../spec2000/musl/benchspec/CINT2000/164.gzip/run/00000002/gzip_base.nix ../spec2000/musl/benchspec/CINT2000/164.gzip/run/00000002/input.source 1
mkdir gzip.data
sde64 -p -xyzzy -p -reserve_memory -p whole_program/gzip.address   -replay -xyzzy  -replay:deadlock_timeout 0  -replay:basename whole_program/gzip -replay:playout 0   -bbprofile -slice_size 10000 -o gzip.data/gzip -log:mt 0 -log:fat -- ${SDE_ROOT}/intel64/nullapp
regions.py --project_bbv --bbv_file gzip.data/gzip.T.0.bb --dimensions 16 > gzip.data/projected_t.bb
simpoint -loadFVFile gzip.data/gzip.T.0.bb -coveragePct 1.0 -maxK 20 -saveSimpoints gzip.data/t.simpoints -saveSimpointWeights gzip.data/t.weights -saveLabels gzip.data/t.labels
regions.py -f 0 --csv_region  --bbv_file gzip.data/gzip.T.0.bb --region_file gzip.data/t.simpoints --weight_file gzip.data/t.weights > gzip.data/pinpoints.csv
mkdir pp
sde64 -p -xyzzy -p -reserve_memory -p whole_program/gzip.address   -replay -xyzzy  -replay:deadlock_timeout 0  -replay:basename whole_program/gzip -replay:playout 0    -log -xyzzy -regions:in gzip.data/pinpoints.csv -regions:overlap_ok 1 -regions:warmup 1500 -regions:prolog 0 -regions:epilog 0 -log:basename pp/gzip -log:compressed bzip2  -log:focus_thread 0 -log:mt 0 -log:fat -- ${SDE_ROOT}/intel64/nullapp
pinball2elf.basic.sh pp/gzip_t0r11_warmup1500_prolog0_region10001_epilog0_011_0-10729.0
```
