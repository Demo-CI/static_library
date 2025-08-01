# Calculator Static Library

A C++ static library providing calculator functionality and mathematical utilities.

## Structure

```
static_library/
├── src/
│   ├── Calculator.cpp    # Calculator class implementation
│   └── MathUtils.cpp     # Mathematical utilities
├── include/
│   ├── Calculator.h      # Calculator class header
│   └── MathUtils.h       # Mathematical utilities header
├── tests/
│   └── test_main.cpp     # Library tests
├── Makefile              # Build configuration
└── .github/workflows/    # CI/CD trigger workflow
```

## Building

The library is built using the centralized build system in the build repository.
When you push changes to this repository, it automatically triggers a build workflow
