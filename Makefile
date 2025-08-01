# Makefile for C++ Static Library

# Compiler settings
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -O2 -Iinclude -fPIC
DEBUG_FLAGS = -std=c++17 -Wall -Wextra -g -O0 -Iinclude -fPIC
AR = ar
ARFLAGS = rcs

# Directories
SRC_DIR = src
INCLUDE_DIR = include
TEST_DIR = tests
BUILD_DIR = build
LIB_DIR = lib

# Library name
LIBRARY_NAME = libcalculator
STATIC_LIB = $(LIB_DIR)/$(LIBRARY_NAME).a
SHARED_LIB = $(LIB_DIR)/$(LIBRARY_NAME).so

# Source files
SOURCES = $(wildcard $(SRC_DIR)/*.cpp)
OBJECTS = $(SOURCES:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)

# Test files
TEST_SOURCES = $(wildcard $(TEST_DIR)/*.cpp)
TEST_OBJECTS = $(TEST_SOURCES:$(TEST_DIR)/%.cpp=$(BUILD_DIR)/%.o)
TEST_TARGET = test_runner

# Default target
all: static shared

# Create necessary directories
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(LIB_DIR):
	mkdir -p $(LIB_DIR)

# Build object files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Build test object files
$(BUILD_DIR)/%.o: $(TEST_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Build static library
static: $(STATIC_LIB)

$(STATIC_LIB): $(OBJECTS) | $(LIB_DIR)
	$(AR) $(ARFLAGS) $@ $^
	@echo "Static library created: $@"

# Build shared library
shared: $(SHARED_LIB)

$(SHARED_LIB): $(OBJECTS) | $(LIB_DIR)
	$(CXX) -shared -o $@ $^
	@echo "Shared library created: $@"

# Debug build
debug: CXXFLAGS = $(DEBUG_FLAGS)
debug: static

# Build tests
$(TEST_TARGET): $(TEST_OBJECTS) $(STATIC_LIB) | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -o $(TEST_TARGET) $(TEST_OBJECTS) $(STATIC_LIB)
	@echo "Test executable created: $(TEST_TARGET)"

# Run tests
test: $(TEST_TARGET)
	@echo "Running library tests..."
	./$(TEST_TARGET)
	@echo "Library tests completed successfully"

# Install library (copy to system directories)
install: static shared
	@echo "Installing library..."
	sudo cp $(STATIC_LIB) /usr/local/lib/
	sudo cp $(SHARED_LIB) /usr/local/lib/
	sudo cp $(INCLUDE_DIR)/*.h /usr/local/include/
	sudo ldconfig
	@echo "Library installed successfully"

# Uninstall library
uninstall:
	@echo "Uninstalling library..."
	sudo rm -f /usr/local/lib/$(LIBRARY_NAME).a
	sudo rm -f /usr/local/lib/$(LIBRARY_NAME).so
	sudo rm -f /usr/local/include/Calculator.h
	sudo rm -f /usr/local/include/MathUtils.h
	sudo ldconfig
	@echo "Library uninstalled successfully"

# Package library for distribution
package: static shared
	@echo "Creating distribution package..."
	mkdir -p dist/include dist/lib
	cp $(INCLUDE_DIR)/*.h dist/include/
	cp $(LIB_DIR)/* dist/lib/
	tar -czf $(LIBRARY_NAME)-dist.tar.gz dist/
	rm -rf dist/
	@echo "Distribution package created: $(LIBRARY_NAME)-dist.tar.gz"

# Clean build artifacts
clean:
	rm -f $(TEST_TARGET)
	rm -rf $(BUILD_DIR) $(LIB_DIR)
	rm -f $(LIBRARY_NAME)-dist.tar.gz

# Static analysis
analyze:
	@if command -v cppcheck >/dev/null 2>&1; then \
		echo "Running static analysis..."; \
		cppcheck --enable=all --std=c++17 --suppress=missingIncludeSystem $(SRC_DIR) $(INCLUDE_DIR); \
	else \
		echo "cppcheck not found, skipping static analysis"; \
	fi

# Format code
format:
	@if command -v clang-format >/dev/null 2>&1; then \
		echo "Formatting code..."; \
		find $(SRC_DIR) $(INCLUDE_DIR) $(TEST_DIR) -name "*.cpp" -o -name "*.h" | xargs clang-format -i; \
		echo "Code formatting completed"; \
	else \
		echo "clang-format not found, skipping code formatting"; \
	fi

# Show project structure
structure:
	@echo "Static Library Project Structure:"
	@tree -I 'build|.git' . || find . -type f -name "*.cpp" -o -name "*.h" -o -name "Makefile" -o -name "*.md" | sort

# Show library information
info:
	@echo "=== Static Library Information ==="
	@echo "Library Name: $(LIBRARY_NAME)"
	@echo "Static Library: $(STATIC_LIB)"
	@echo "Shared Library: $(SHARED_LIB)"
	@echo "Source Files: $(SOURCES)"
	@echo "Include Directory: $(INCLUDE_DIR)"
	@if [ -f "$(STATIC_LIB)" ]; then \
		echo "Static Library Size: $$(ls -lh $(STATIC_LIB) | awk '{print $$5}')"; \
		echo "Static Library Symbols:"; \
		nm -g $(STATIC_LIB) | head -10; \
	fi

.PHONY: all static shared debug test clean install uninstall package analyze format structure info
