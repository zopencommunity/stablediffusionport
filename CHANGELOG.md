# Changelog

## [1.0.0] - 2025-07-29

### Added
- Initial port of Stable Diffusion to z/OS mainframe
- Cross-compilation support using Clang 14
- Custom memory management for mainframe architecture
- CMake build system integration
- Support for GGUF Q4_0 quantized models
- z/OS-specific patches for GGML and memory mapping

### Technical Details
- Successfully generates 512x512 PNG images
- Memory optimization for EBCDIC architecture
- Build automation pipeline for z/OS deployment

### Known Limitations
- CPU-only inference (no GPU acceleration)
- Long generation times (~13-14 hours per image)
