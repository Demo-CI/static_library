# Calculator Static Library

C++ static library providing calculator functionality and mathematical utilities.

## Project Structure

```
static_library/
├── src/           # Source files (Calculator.cpp, MathUtils.cpp)
├── include/       # Header files (Calculator.h, MathUtils.h)
├── tests/         # Unit tests
└── Makefile       # Build configuration
```

## Local Development

```bash
# Build library
make

# Run tests
make test

# Clean build
make clean
```

## Build System

Uses [centralized CI/CD](../build) for automated building and testing.

### Automatic Triggers
- **Pull Requests**: Builds automatically trigger when opening/updating PRs
- **Push to main/develop**: Direct commits trigger builds immediately

### Manual JSON Triggers
Post a JSON comment in any Pull Request to customize the build:

```json
{
  "build_type": "debug",
  "save_logs": true,
  "reason": "Testing library changes"
}
```

**Monitor builds:** [Build Actions](../build/actions)

---
**Related:** [Calculator Application](../application) | [Build System](../build)
