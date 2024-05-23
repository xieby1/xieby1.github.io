<div style="text-align:right; font-size:3em;">2024.05.23</div>

主文件.cpp的名字为top module的名字加前缀V，如果没top module则为文件名加前缀V

* verilator/src/V3EmitCMain.cpp
  * filename = v3Global.opt.makeDir() + "/" + topClassName() + "__main.cpp";
    * verilator/src/V3EmitCBase.h: v3Global.opt.prefix();
      * src/V3Options.h: string prefix() const VL_MT_SAFE { return m_prefix; }
        * src/V3Options.cpp
          ```cpp
            // Default prefix to the filename
            if (prefix() == "" && topModule() != "")
                m_prefix = string{"V"} + AstNode::encodeName(topModule());
            if (prefix() == "" && vFilesList.size() >= 1)
                m_prefix = string{"V"} + AstNode::encodeName(V3Os::filenameNonExt(*(vFilesList.begin())));
          ```

主文件.h的名字，同理

* verilator/src/V3EmitCModel.cpp
  * filename = v3Global.opt.makeDir() + "/" + topClassName() + ".h";


