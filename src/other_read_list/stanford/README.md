<div style="font-size:3em; text-align:right;">2019.11.14</div>
# Stanford EE392C Reading List

**注1**该阅读清单来自stanford的[Advanced Topics in Computer Architecture: Chip Multiprocessors & Polymorphic Processors](https://web.stanford.edu/class/ee392c/)课程。

**注2**：以下内容在[原阅读清单](https://web.stanford.edu/class/ee392c/list.html)的基础上删掉了课程内容无关的部分，修改了链接，修正了清单中明显的小错误。<span style="color:red;">红色</span>的文献暂未找到。

Papers for each topic are classified in the following categories

- **(R)** – **required** reading for the corresponding lectures
- *(B)* – background reading on the specific topic
- *(F)* – further reading on the specific topic

### Technology & Architecture Background

(All papers on this topic are background & further reading. The main issues will be discussed in the first lecture.) 

* *(B)* R. Ho, K. Mai, and M. Horowitz. [The Future of Wires](2001.the_future_of_wires.horowitz.pieee.pdf). Proceedings of the IEEE, Volume: 89, Issue: 4, April 2001.

* *(B)* V. Agarwal, H.S. Murukkathampoondi, S.W. Keckler, and D.C. Burger. [Clock Rate Versus IPC: The End of the Road for Conventional Microarchitectures](2000.clock_rate_versus_ipv.burger.isca.pdf.pdf). Proceedings of the 27th International Symposium on Computer Architecture (ISCA), Vancouver, Canada, June 2000.
*  *(F)* R. Ronen, A. Mendelson, K. LAI, S. Lu, F. Pollack, AND J. P. Shen. [Coming Challenges in Microarchitecture and Architecture](2001.uarch_challenges.ronnen.pieee.pdf). Proceedings of the IEEE, Volume: 89, Issue: 3, March 2001.
*  *(F)* A. Allan, D. Edenfeld, W.H. Joyner, A.B. Kahng, M. Rodgers, Y. Zorian. [2001 Technology Roadmap for Semiconductors](2001.roadmap.sematch.computer.pdf). IEEE Computer, Volume: 35, Issue: 1, January 2001. 

### Data-parallel Architectures

- **(R)** B. Khailany, W. Dally, S. Rixner, U. Kapasi, P. Mattson, J. Namkoong, J. Owens, B. Towles, A. Chang. [Imagine: Media Processing with Streams](2001.imagine_overview.dally.micro.pdf). *IEEE Micro*, Volume: 21, Issue: 2, March 2001.
- ✔️**(R)** C. Kozyrakis, D. Patterson. [Vector Vs Superscalar and VLIW Architectures for Embedded Multimedia Benchmarks](2002.vector_vs_ss.kozyrakis.micro.pdf). Proceedings the 35th International Symposium on Microarchitecture, Instabul, Turkey, November 2002.

- *(B)* W. Hillis, G. Steele. [Data Parallel Algorithms](1986.dp_algorithms.hillis.cacm.pdf). Communications of ACM, Volume: 29, Issue: 12, December 1986.
- *(F)* R. Espasa, F. Ardanaz, J. Emer, S. Felix, J. Gago, R. Gramunt, I. Hernandez, T. Juan, G. Lowney, M. Mattina, A. Seznec. [Tarantula: A Vector Extension to the Alpha Architecture](2002.tarantula.espasa.isca.pdf). Proceedings of the 29th International Symposium on Computer Architecture (ISCA), Anchorage, AL, May 2002.
- *(F)* J. Smith, G. Faanes, R. Sugumar. [Vector Instruction Set Support for Conditional Operations](2002.conditional_vectors.smith.isca.pdf). Proceedings of the 27th International Symposium on Computer Architecture (ISCA), Vancouver, BC, June 2000.

### Multi-threaded Architectures 

- **(R)** J. Laudon, A. Gupta, M. Horowitz. [Interleaving: A Multithreading Technique Targeting Multiprocessors and Workstations](1994.interleaved_mt.laudon.asplos.pdf). Proceedings of the 6th International Conference on Architectural Support for Programming Languages and Operating Systems (ASPLOS), San Jose, CA, October 1994.
- **(R)** R. Saavedra-Barrera , D. Culler , T. von Eicken. [Analysis of Multithreaded Architectures for Parallel Computing](1990.analysis_of_mt_arch_for_parallel_computing.culler.spaa.pdf). Proceedings of the 2nd Symposium on Parallel Algorithms and Architectures (SPAA), Crete, Greece, July 1990.
- **(R)** A. Gupta, J. Hennessy , K. Gharachorloo , T. Mowry , W. Weber. [Comparative Evaluation of Latency Reducing and Tolerating Techniques](2001.roadmap.sematch.computer.pdf). Proceedings of the 18th International Symposium on Computer Architecture (ISCA), Toronto, Canada, May 1991 

- *(B)* B. Dennis, G. R. Gao. <span style="color:red;">Multithreaded Architectures: Principles, Projects, and Issues</span>. ACAPS Technical Memo 29, McGill University, Montreal, Canada, February 1994.
- *(F)* C. Cascaval, J. Castanos, L. Ceze, M. Denneau, M. Gupta, D. Lieber, J. Moreira, K. Strauss, H. S. Warren. [Evaluation of a Multithreaded Architecture for Cellular Computing](2002.cellular_computing_mt_arch_evaluation.cascaval.hpca.pdf). Proceedings of the 8th International Symposium on High-Performance Computer Architecture (HPCA), Cambridge, MA, February 2002.
- *(F)* J. Borkenhagen, R. Eickemeyer, R. Kalla, S. Kunkel. [A Multithreaded PowerPC Processor for Commercial Servers](2000.multithreaded_powerpc.kunkel.ibmjrd.pdf). IBM Journal of Research and Development, Volume: 44, Issue: 6, November 2000.

### Speculative Multithreading

- **(R)** M. Garzaran, M. Prvulovic, V. Vinals, J. Llaberia, L. Rauchwerger, J. Torrellas. [Tradeoffs in Buffering Memory State for Thread-Level Speculation in Multiprocessors](2003.tradeoffs_in_buffering_mem_state_for_tls.torrellas.hpca.pdf). Proceedings of the 9th International Symposium on High Performance Computer Architecture (HPCA), Anaheim, CA, February 2003.
- **(R)** Matthew Frank, Walter Lee and Saman Amarasinghe. [A Software Framework for Supporting General Purpose Applications on Raw Computation Fabrics](2001.software_framework_for_supporting_general_purpose_apps_on_raw_computation_fabrics.frank.lcstm619.pdf). MIT-LCS Technical Memo MIT-LCS-TM-619, July 20, 2001.

- *(B)* M. Herlihy, J. Moss. [Transactional Memory: Architectural Support for Lock-Free Data Structures](1992.transactional_memory.herlihy.ISCA.pdf). Proceedings of the 20th International Symposium on Computer Architecture (ISCA), San Diego, CA, May 1993.
- *(F)* J. T. Oplinger, D. L. Heine, and M. S. Lam. [In Search of Speculative Thread-level Parallelism](1999.tls_parallelism.lam.pact.pdf). Proceedings of the 1999 International Conference on Parallel Architectures and Compilation Techniques (PACT), October 1999.
- *(F)* J. G. Steffan, C. B. Colohan, A. Zhai, and T. C. Mowry. [A Scalable Approach to Thread-level Speculation](2000.scalable_approach_to_tls.mowry.isca.pdf). Proceedings of the 27th International Symposium on Computer Architecture (ISCA), Vancouver, BC, June 2000.

### Emerging Applications

This topic will be studied as part of a homework assignment. Links to background papers will be available after the corresponding class meeting.

### Proposed CMP/Polymorphic Architectures (2 lectures)

- **(R-I)** K. Mai, T. Paaske, N. Jayasena, R. Ho, W. Dally, M. Horowitz. [Smart Memories: A Modular Reconfigurable Architecture](2000.smart_memories.horowitz.isca.pdf). Proceedings of the 27th International Symposium on Computer Architecture, Vancouver, BC, June 2000.
- **(R-I)** D. Burger, S. Keckler, et. al. <span style="color:red;">Exploiting ILP, DLP, and TLP Using Polymorphism in the TRIPS Processor</span>. Proceedings of the 30th International Symposium on Computer Architecture (ISCA), San Diego, CA, June 2003.
- **(R-II)** S. Goldstein, H. Schmit, M. Budiu, S. Cadambi, M. Moe, R. Taylor. [PipeRench: A Reconfigurable Architecture and Compiler](2000.piperench.goldstein.computer.pdf). IEEE Computer, Volume: 33 Issue: 4, April 2000.
- **(R-II)** W. Lee, R. Barua, M. Frank, D. Srikrishna, J. Babb, V. Sarkar, S. Amarasinghe. [Space-Time Scheduling of Instruction-Level Parallelism on a Raw Machine](1998.space_time_scheduling_of_instructions_level_parallelism_on_a_row_machine.saman.asplos.pdf). Proceedings of the 8th International Conference on Architectural Support for Programming Languages and Operating Systems (ASPLOS), San Jose, CA, October 1998.

### Programming Models

- **(R)** M. Gordon, W. Thies, M. Karczmarek, J. Lin, A. Meli, A. Lamb, C. Leger, J. Wong, H. Hoffmann, D. Maze, and S. Amarasinghe. [A Stream Compiler for Communication-Exposed Architectures](2002.stream_compiler.saman.asplos.pdf). Proceedings of the 10th International Conference on Architectural Support for Programming Languages and Operating Systems, San Jose, CA, October, 2002
- **(R)** P. Wu, D Padua. [Beyond Arrays: a Container-centric Approach on Parallelization of Real-world Symbolic Applications](1998.container_parallelization.padua.lcpc.pdf). Proceedings of the 11th International. Workshop of Language and Compilers for Parallel Computing, NC, August 1998.
- **(R)** M. Rinard, M. Lam. [Coarse-grain Parallel Programming in Jade](1991.jade_parallel_programming.rinard.ppopp.pdf). Proceedings of the 3rd Symposium on Principles and Practice of Parallel Programming,
  Williamsburg, VA, April 1991. 

- *(B)* H. Bal, J. Steiner, and A. Tanenbaum. [Programming Languages for Distributed Computing Systems](1989.distributed_programming_lang.tanenbaum.compsurveys.pdf). *ACM Computing Surveys*, Volume: 21, Issue:3, September 1989.
- *(F)* W. Carlson, J. Draper, D. Culler, K. Yelick, E. Brooks, K. Warren. [Introduction to UPC and Language Specification](1999.upc.carlson.ccstr.pdf). CCS-TR-99-157, Center for Computing Sciences, Bowie, MD, May 1999.
- *(F)* M. Rinard, M. Lam. [The Design, Implementation, and Evaluation of Jade](1998.jade.rinard.toplas.pdf). ACM Transactions of Programming Languages and Systems, Volume: 20, Issue: 1, Januarry 1998.

### Virtual Machines 

- ✔️**(R)** J. Smith, S. Sastry, T. Heil, T. Bezenek. [Achieving High Performance via Co-designed Virtual Machines](1999.codesigned_vm.smith.iwia.pdf). Proceedings of the International Workshop on Innovative Architecture, Maui, HI, November 1999.
- **(R)** E. Bugnion, S. Devine and M. Rosenblum. [Disco: Running Commodity Operating Systems on Scalable Multiprocessors](1997.disco.mendel.sosp.pdf). Proceedings of 16th Symposium on Operating Systems Principles, Saint Malo, France, October 1997.

- *(B)* G. Popek, R. Goldberg. [Formal Requirements for Virtualizable Third Generation Architectures](1974.formal_vm_req.goldberg.cacm.pdf). Communications of ACM, Volume: 17, Issue: 7, July 1974.
- ✔️*(B)* J. Smith. [An Overview of Virtual Machine Architectures](2001.vm_intro.smith.pdf). University of Wisconsin, October 2001.

### On-line Profiling Techniques

- **(R)** M. Chen, K. Olukotun. [TEST: A Tracer for Extracting Speculative Threads](2003.TEST.olukotun.cgo.pdf). Proceedings of International Symposium on Code Generation and Optimization, San Francisco, CA, March 2003.
- **(R)** T. Heil, J. Smith. [Relational Profiling: Enabling Thread Level Parallelism in Virtual Machines](2000.relational_profiling.heil.micro.pdf). Proceedings of the 33rd International Symposium on Microarchitecture, Monterey, CA, December 2000.

- *(F)* G. Zilles, G. Sohi. [A Programmable Co-processor for Profiling](2001.profiling_coproc.sohi.hpca.pdf). Proceedings of the 7th International Symposium on High Performance Computer Architecture, Monterrey, Mexico, January 2001.
- *(F)* S. Sastry, R. Bodik, J. Smith. [Rapid Profiling via Stratified Sampling](2001.stratified_profiling.bodik.isca.pdf). Proceedings of the 28th International Symposium on Computer Architecture, Göteborg, Sweden June 2001.

### Dynamic Compilation (2 lectures) 

- **(R-I)** M. Chen, K. Olukotun. [The JRPM System for Dynamically Parallelizing Java Programs](2003.jrpm.kunle.isca.pdf). Proceedings of the 30th International Symposium on Computer Architecture, San Diego, CA, June 2003.
- **(R-I)** V. Bala, E. Duesterwald, S. Banerjia. [Dynamo: A Transparent Dynamic Optimization System](2000.dynamo.duesterwald.pldi.pdf). Proceedings of the Conference on Programming Language Design and Implementation, Vancouver, Canada, June 2000.
- **(R-II)** J. Auslander, M. Philipose, C. Chambers, S.J. Eggers and B.N. Bershad. [Fast, Effective Dynamic Compilation](1999.fast_effective_dynamic_compilation.eggers.pldi.pdf). Proceedings of the *Conference on Programming Language Design and Implementation**,* Las Vegas, NV, May 1996.
- **(R-II)** G. Desoli, N. Mateev, E. Duesterwald, P. Faraboschi, J. Fisher. [DELI: A New Run-time Control Point](2002.deli.fischer.micro.pdf). Proceedings of the 35th International Symposium on Microarchitecture, Istanbul, Turkey, October 2002.  

- *(B)* E. Altman, K. Ebcioglu, M. Gschwind, S. Sathaye. [Advances and Future Challenges in Binary Translation and Optimization.](2001.binary_translation_overview.altman.proceedings_ieee.pdf) Proceedings of the IEEE, Volume: 89, Issue: 11, November 2001.
- *(B)* M. Smith. [Overcoming the Challenges to Feedback-Directed Optimization](2000.dynacomp_issues.smith.daco.pdf). *Proceedings of the Workshop on Dynamic and Adaptive Compilation and Optimization*, Boston, MA, January 2000.
- *(F)* M. Arnold, S. Fink, D. Grove, M. Hind, and P. Sweeney. [Adaptive optimization in the Jalapeno JVM](2000.jalapeno.arnold0.oopsla.pdf). In Proceedings of the Conference on Object-Oriented Programming, Systems, Languages & Applications, Minneapolis MN. October 2000
- ✔️*(F)* A. Klaiber. [The Technology Behind Crusoe Processors](2000.code_morphing.transmeta.pdf). Transmeta Technical Brief, 2000 

### Fault Tolerance & Reliability Techniques 

- **(R)** D. Bossen, A. Kitamorn, K. Reick, M. Floyd. [Fault-tolerant Design of the IBM pSeries 690 System using Power4 Processor Technology](2002.power4_faults.bossen.ibmjrd.pdf). IBM Journal of Research and Development, Volume: 46, Issue: 1, January 2002.
- **(R)** D. Sorin, M. Martin, M. Hill, D. Wood. [SafetyNet: Improving Availability of Shared Memory Multiprocessors with Global Checkpoint/Recovery](2002.safetynet.sorin.isca.pdf). Proceedings of the 29th International Symposium on Computer Architecture, Anchorage, AL, May 2002.

- *(B)* L. Spainhower, T. Gregg. [IBM S/390 Parallel Enterprise Server G5 Fault Tolerance: A Historical Perspective](1999.ibm_faults_mainframe.spainhower.ibmjrd.pdf). IBM Journal of Research and Technology, Volume: 43, Issue: 5, September 1999.
- *(F)* T. Vijaykumar, I. Porneranz, K. Cheng. [Transient-Fault Recovery Using Simultaneous Multithreading](2002.transient-fault_recovery.vijaykumart.isca.pdf). Proceedings of the 29th International Symposium on Computer Architecture, Anchorage, AL, May 2002.
- *(F)* Todd Austin. DIVA: [A Reliable Substrate for Deep Submicron Microarchitecture Design](1999.deep_submicron_microarchitecture_design.austin.micro.pdf). Proceedings of the 32nd International Symposium on Microarchitecture, Haifa, Israel, November 1999. 

### Applications of Machine Learning Techniques to Systems 

- (R) J. Emer, N. Gloy. [A Language for Describing Predictors and its Applications to Automatic Synthesis](1997.predictors_language.emer.isca.pdf). Proceedings of the 24th International Symposium on Computer Architecture, Denver, CO, June 1997.
- (R) D. Jimenez, C. Lin. [Dynamic Branch Prediction with Perceptrons](2001.dynamic_branch_prediction_with_perceptron.shimenez.hpca.pdf). Proceedings of the 7th International Symposium on High Performance Computer Architecture, Monterrey, Mexico, January 2001.

- (F) M. Stephenson, S. Amarasinghe, M. Martin, U. O’Reilly. [Meta Optimization: Improving Compiler Heuristics with Machines Learning](2003.meta_opt.saman.pldi.pdf). Proceedings of the Conference on Programming Languages Design and Implementation, San Diego, CA, June 2003.
- (F) M. Sakr, D. Chiarulli, B. Horne, C. Giles. Predicting [Multiprocessor Memory Access Patterns with Learning Models](1997.pattern_prediction_with_learing.sakr.icml.pdf). Proceedings of the 4th International Conference on Machine Learning, Nashville, TN, July 1997.

### Last Lecture (TBD)
