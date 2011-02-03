# There is no clear way of keeping track of compiler command-line
# options chosen via `add_definitions', so we need our own method for
# using it on tools/llvm-config/CMakeLists.txt.

# Beware that there is no implementation of remove_llvm_definitions.

macro(add_llvm_definitions)
  # We don't want no semicolons on LLVM_DEFINITIONS:
  foreach(arg ${ARGN})
    set(LLVM_DEFINITIONS "${LLVM_DEFINITIONS} ${arg}")
  endforeach(arg)
  add_definitions( ${ARGN} )
endmacro(add_llvm_definitions)

# Following C/C++ checks can use -Dname=value.
# eg. add_llvm_config_definition(_WIN32_WINNT 0x0500)
# Some declarations might be unavailable without certain definition.
# configure_file() can use its definition(s).
macro(add_llvm_config_definition name value)
  set(${name} ${value})
  list(APPEND CMAKE_REQUIRED_DEFINITIONS "-D${name}=${value}")
endmacro(add_llvm_config_definition name value)
