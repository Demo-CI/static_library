# Calculator Static Library

A C++ static library providing calculator functionality and mathematical utilities.

## 📁 Project Structure

```
static_library/
├── src/           # Source files (Calculator.cpp, MathUtils.cpp)
├── include/       # Header files (Calculator.h, MathUtils.h)
├── tests/         # Unit tests
└── Makefile       # Build configuration
```

## 🚀 Triggering Builds

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

**Parameters:**
- `build_type`: `"release"` (default) or `"debug"`
- `save_logs`: `true` or `false` (default)
- `reason`: Custom description (optional)

### Manual Workflow
Go to [Actions](../../actions) → "Trigger Centralized Build" → "Run workflow"

## 📊 Build System

This library uses a **centralized build system** from the [build repository](../build) that:
- Builds the static library
- Builds dependent applications
- Runs comprehensive tests
- Posts results back to your PR

**Monitor builds:** [Centralized Build Actions](../build/actions)
