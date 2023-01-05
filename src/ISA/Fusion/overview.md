https://stackoverflow.com/questions/56413517/what-is-instruction-fusion-in-contemporary-x86-processors

> * Macro-fusion decodes cmp/jcc or test/jcc into a single compare-and-branch uop.
> * Micro-fusion stores 2 uops from the same instruction together so they only take up 1 "slot" in the fused-domain parts of the pipeline.
