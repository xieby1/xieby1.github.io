# Cambrige Advanced Topics in Computer Architecture Reading List

[原阅读清单](https://www.cl.cam.ac.uk/teaching/1920/R265/materials.html)

**Note:** All Week 1 papers are **not for assessment**. You should not submit an essay on the topic of these papers.

### Week 1: Trends in Computer Architecture

- *[Clock Rate versus IPC: The End of the Road for Conventional Microarchitectures](http://www.cl.cam.ac.uk/~rdm34/acs/00854395.pdf)* Agarwal, Hrishikesh, Keckler and Burger, ISCA, June 2000.
  [[ IEEE Xplore ](https://ieeexplore.ieee.org/document/854395)]
- *[Dark Silicon and the End of Multicore Scaling ](http://www.cl.cam.ac.uk/~rdm34/acs/06175879.pdf)*Esmaeilzadeh et al, IEEE Micro, 32:2, May-June 2012.
  [[ IEEE Xplore ](https://doi.org/10.1109/MM.2012.17)]
- *[The Accelerator Wall: Limits to Chip Specialization ](http://www.cl.cam.ac.uk/~rdm34/acs/08675237.pdf)*Fuchs and Wentzlaff, HPCA 2019.
  [[ IEEE Xplore ](https://doi.org/10.1109/HPCA.2019.00023)]



##### Other optional material for week 1

- *[A New Golden Age for Computer Architecture ](https://cacm.acm.org/magazines/2019/2/234352-a-new-golden-age-for-computer-architecture/fulltext)*Hennessy and Patterson, Communications of the ACM, Feb. 2019, 62(2), pp. 48-60 (Turing Lecture)

### Week 2: State-of-the-art Processor Design

- *[BROOM: An Open-Source Out-of-Order Processor With Resilient Low-Voltage Operation in 28nm CMOS](http://www.cl.cam.ac.uk/~rdm34/acs/BROOM-IEEEMicro2019.pdf)* Celio, Chiu, Asanovic, Nikolic and Patterson. Hot Chips 30, 2019.
  [[IEEE Xplore ](https://ieeexplore.ieee.org/document/8634812)]
- *[Inside 6th-Generation Intel Core: New Microarchitecture Code-Named Skylake](http://www.cl.cam.ac.uk/~rdm34/acs/07924286.pdf)* Doweck et al, IEEE Micro, vol. 37, 2017
  [[IEEE Xplore ](https://ieeexplore.ieee.org/document/7924286)]
- *[The Celerity Open-Source 511-Core RISC-V Tiered Accelerator Fabric: Fast Architectures and Design Methodologies for Fast Chips](http://www.cl.cam.ac.uk/~rdm34/acs/08344478.pdf)* Davidson et al. IEEE Micro, 38(2), March-April, 2019
  [[IEEE Xplore ](https://ieeexplore.ieee.org/document/8344478)]



##### Other optional material for week 2

- *[Samsung M3 Processor](http://www.cl.cam.ac.uk/~rdm34/acs/08634890.pdf)* Rupley, Burgess, Grayson, Zuraski, IEEE Micro, 39(2), March-April, 2019
  [[IEEE Xplore ](https://ieeexplore.ieee.org/document/8634890)]

### Week 3: Memory system design

- *[Linearizing Irregular Memory Accesses for Improved Correlated Prefetching](https://www.cl.cam.ac.uk/teaching/1920/R265/cam-only/micro13.pdf)* Jain and Lin, MICRO 2013
  [[ACM Digital Library](https://dl.acm.org/citation.cfm?id=2540730)]
- *[Best-Offset Hardware Prefetching](https://www.cl.cam.ac.uk/teaching/1920/R265/cam-only/best-offset.pdf)* Michaud, HPCA 2016
  [[IEEE Xplore](https://ieeexplore.ieee.org/document/7446087)] [[Version with figure 6 fixed](https://www.cl.cam.ac.uk/teaching/1920/R265/cam-only/bop.pdf)]
- *[Minnow: Lightweight Offload Engines for Worklist Management and Worklist-Directed Prefetching](https://www.cl.cam.ac.uk/teaching/1920/R265/cam-only/Minnow_Lightweight_Offload_Engines_for_Worklist_Ma.pdf)* Zhang, Ma, Thomson and Chiou, ASPLOS 2018
  [[ACM Digital Library](https://dl.acm.org/citation.cfm?id=3173197)]

##### Other optional material for week 3

- *[Continuous Runahead: Transparent Hardware Acceleration for Memory Intensive Workloads](https://www.cl.cam.ac.uk/teaching/1920/R265/cam-only/continuous-runahead-engine_micro16.pdf)* Hashemi, Mutlu and Patt, MICRO 2016
  [[ACM Digital Library](https://dl.acm.org/citation.cfm?id=3195712)]
- *[Meet the Walkers: Accelerating Index Traversals for In-Memory Databases](https://www.cl.cam.ac.uk/teaching/1920/R265/cam-only/walkers_micro13.pdf)* Kocberber, Grot, Picorel, Falsafi, Lim and Ranganathan
  [[ACM Digital Library](https://dl.acm.org/citation.cfm?id=2540748)]

### Week 4: Specification, verification and test

- ISA specification & verification:

- - **Mandatory:** *Who Guards the Guards? Formal validation of the Arm v8-m architecture specification*, OOPSLA 2017
    [[ACM Digital Library](https://dl.acm.org/citation.cfm?id=3152284.3133912)]
  - *ISA Semantics for ARMv8-A, RISC-V, and CHERI-MIPS*, POPL 2019
    [[Open Access](https://www.cl.cam.ac.uk/~pes20/sail/sail-popl2019.pdf)]
  - Sail RISC-V docs:
    [[GitHub](https://github.com/rems-project/sail-riscv/tree/master/doc)]

- Instruction test generation:

- - **Mandatory:** *Genesys-Pro: Innovations in Test Program Generation for Functional Processor Verification*, IBM Research, IEEE Design and Test 2004
    [[IEEExplore](http://dx.doi.org/10.1109/MDT.2004.1277900)]
  - *Randomised testing of a microprocessor model using SMT-solver state generation*, 2015
    [[Science Direct](http://dx.doi.org/10.1016/j.scico.2015.10.012)]
  - RISC-V torture tests:
    [[GitHub](https://github.com/ucb-bar/riscv-torture)]

- Additional material:

- - RISC-V tests:
    [[GitHub](https://github.com/riscv/riscv-tests)]
  - RISC-V formal framework:
    [[Open Access Slides](https://github.com/SymbioticEDA/riscv-formalhttp://www.clifford.at/papers/2017/riscv-formal/slides.pdf)]

### Week 5: Hardware security (I)

### Week 6: Hardware security (II)

### Week 7: Hardware reliability

- *[StageWeb: Interweaving Pipeline Stages into a Wearout and Variation Tolerant CMP Fabric](https://www.cl.cam.ac.uk/teaching/1920/R265/cam-only/stageweb-dsn10.pdf)* Gupta, Ansari, Feng and Mahlke, DSN 2010
  [[IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/5544915)]
- *[Reunion: Complexity-Effective Multicore Redundancy](https://www.cl.cam.ac.uk/teaching/1920/R265/cam-only/reunion-micro06.pdf)* Smolens, Gold, Falsafi and Hoe, MICRO 2006
  [[ACM Digital Library](https://dl.acm.org/citation.cfm?id=1194840)]
- *[Utilizing Dynamically Coupled Cores to Form a Resilient Chip Multiprocessor](https://www.cl.cam.ac.uk/teaching/1920/R265/cam-only/coupled-cores-dsn07.pdf)* LaFrieda, İpek, Martínez and Manohar, DSN 2007
  [[IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/4272983)]

##### Other optional material for week 7

- *[Architectural Core Salvaging in a Multi-Core Processor for Hard-Error Tolerance](https://www.cl.cam.ac.uk/teaching/1920/R265/cam-only/core-salvaging-isca09.pdf)* Powell, Biswas, Gupta and Mukherjee, ISCA 2009
  [[ACM Digital Library](https://dl.acm.org/citation.cfm?id=1555769)]
- *[Relax: An Architectural Framework for Software Recovery of Hardware Faults](https://www.cl.cam.ac.uk/teaching/1920/R265/cam-only/relax-isca10.pdf)* De Kruijf, Nomura and Sankaralingam, ISCA 2010
  [[ACM Digital Library](https://dl.acm.org/citation.cfm?id=1816026)]

### Week 8: HW Accelerators and accelerators for machine learning

## Lecture Slides

[Seminar 1 - Trends in Computer Architecture](http://www.cl.cam.ac.uk/~rdm34/acs/trends.pdf)

[Seminar 1 - Processor Design](http://www.cl.cam.ac.uk/~rdm34/acs/processor.pdf)

[Seminar 2 - Prefetching](https://www.cl.cam.ac.uk/teaching/1920/R265/slides/prefetching.pdf)

 