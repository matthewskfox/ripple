/**
 * config.h - compile-time constants for ripple
 *
 * Central definition point for all compile-time constants. No magic numbers are
 * permitted outside this file. Include directly in .c translation units; do not
 * re-export through other headers.
 */

#ifndef RIPPLE_CONFIG_H
#define RIPPLE_CONFIG_H

/* Version */

#define RIPPLE_VERSION_MAJOR 1
#define RIPPLE_VERSION_MINOR 0
#define RIPPLE_VERSION_PATCH 0
#define RIPPLE_VERSION "1.0.0"

#endif /* RIPPLE_CONFIG_H */