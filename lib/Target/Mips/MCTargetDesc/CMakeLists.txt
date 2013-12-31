add_llvm_library(LLVMMipsDesc
  MipsAsmBackend.cpp
  MipsMCAsmInfo.cpp
  MipsMCCodeEmitter.cpp
  MipsMCTargetDesc.cpp
  MipsELFObjectWriter.cpp
  MipsReginfo.cpp
# LOCALMOD-BEGIN
  MipsMCNaCl.cpp
# LOCALMOD-END
  )

add_dependencies(LLVMMipsDesc MipsCommonTableGen)
