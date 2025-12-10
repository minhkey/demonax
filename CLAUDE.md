 Rust coding guidelines

* Prioritize code correctness and clarity. Speed and efficiency are secondary priorities unless otherwise specified.
* Do not write organizational or comments that summarize the code. Comments should only be written in order to explain "why" the code is written in some way in the case there is a reason that is tricky / non-obvious.
* Prefer implementing functionality in existing files unless it is a new logical component. Avoid creating many small files.
* Avoid using functions that panic like `unwrap()`, instead use mechanisms like `?` to propagate errors.
* Be careful with operations like indexing which may panic if the indexes are out of bounds.
* Never silently discard errors with `let _ =` on fallible operations. Always handle errors appropriately:
  - Propagate errors with `?` when the calling function should handle them
  - Use `.log_err()` or similar when you need to ignore errors but want visibility
  - Use explicit error handling with `match` or `if let Err(...)` when you need custom logic
  - Example: avoid `let _ = client.request(...).await?;` - use `client.request(...).await?;` instead
* When implementing async operations that may fail, ensure errors propagate to the UI layer so users get meaningful feedback.
* Never create files with `mod.rs` paths - prefer `src/some_module.rs` instead of `src/some_module/mod.rs`.

# Preferred crates

* When starting a new project you must always use the latest version of any dependencies and rust edition 2024.
* When modifying existing code, do not change the version of dependencies. If a change of version is required for functionality, always ask before changing.
* Use clap for command line interface (CLI) applications. Use subcommands with arguments coming after the subcommand. Use the derive syntax
* If necessary, use inquire for interative input from the user in command line interfaces
* Use indicatif to report messages and progress to the user in command line interfaces
* Use ratatui for building more complex terminal GUI components/interactions. Include terminal theme detection using crate dark-light and default to a standard theme with forced black background and only BASE 16 colors.
* Use anyhow for error handling in CLI apps
* Use eyre for error handling in libraries/crates
* Divide code into one library (use the app-core subdirectory for the library, i.e. of the app is called xyz, use xyz-core) and one or more binaries (use the cli subdirectory if there is only one binary, otherwise use the individual app names as sub dirs)
* Use the tracing framework in libraries and add verbose option levels (-v -vv -vvv and -vvvv) to get tracing output to stderr in the cli (and optionally a -logfile argument specified on the command line)
* Keep the non-verbose messaging to a minimum, but make sure to provide terse but informative messages at the info level (-v).
* Speed up exection by using async and parallel execution using fugures and rayon. Use tokio for async runtime
* Use dir crate to always store config, cache and other data on Linux, Windows, macOS in their platform/OS specific user locations
