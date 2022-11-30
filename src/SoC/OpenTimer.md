<div style="text-align:right; font-size:3em;">2022.11.01</div>

# OpenTimer

## Examples

### TODO: Library

[OSU Free PDK 45nm](https://vlsiarch.ecen.okstate.edu/flow/)

[NanGate 45nm Open Cell Library](http://www.nangate.com/?page_id=22)

[TAU15 contest library](https://sites.google.com/site/taucontest2015/)

### TODO: File format

Info source:

* [OSU Free PDK 45nm](https://vlsiarch.ecen.okstate.edu/flow/),
* 2020.soc_design_guide.chakravarthi.pdf: Table 9.1: Different file formats encountered in SOC design

* Timing Libraries: DB, TLF
  * .lib (liberty timing file)
    * company: `Synopsys`
    * obtained by OSU Free PDK 45nm: `osu_soc_v2.7.tar.gz`

    Synthesis tool can also write out liberty timing file in the form of .lib.
    Liberty timing file is the ASCII representation of timing and power parameters associated with the cell at various conditions.
    It contains timing models and data to compute input-output path delays,
    timing requirements (for timing checks),
    and interconnect delays

* Design modelling using HDL: Verilog(.v), VHDL(.vhd)
* Synthesis result (Gate-level file): .vg
* Geometry Libraries
  * FRAM
  * LEF(Design Exchange Format)
    * die size, logical connectivity, physical location in the die.
    * floor planning information of standard cells, modules, placement and routing blockages, placement constrains, and powerboundaries.
  * LEF(Layer Exchange Format)
    * metal layer, via layer information and via geometry rules
* Cell layouts:
  * Virtuoso, Magic, CIF
  * GDS2
    * Tape-out
* Static timing analysis and signal integrity checks: SPEF(Standard Parasitic Exchange Format)
* Static timing analysis / dynamic timing analysis: SDF(Standard Delay Fromat)

