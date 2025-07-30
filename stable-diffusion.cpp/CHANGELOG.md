# Changelog

## [1.0.0] - 2025-07-29

### Added
- Initial port of Stable Diffusion to z/OS mainframe
- Cross-compilation support using Clang 14 and CMake
- Custom memory management for mainframe architecture
- z/OS-specific patches for GGML and memory mapping
- Support for GGUF Q4_0 quantized models

### Technical Details
- Successfully generates 512x512 PNG images
- Memory optimization for EBCDIC architecture
- Build automation pipeline for z/OS deployment
- ~13.7 hour generation time for 512x512 images

### Known Limitations
- CPU-only inference (no GPU acceleration)
- Long generation times due to mainframe hardware constraints
