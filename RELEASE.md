RELEASE_TYPE: minor

Export the `root` and `root_parsec` parsecs as combinators so that they can
be used from other modules. This is backward-compatible with the previous version
(it only adds some new exports to the module).

This way, the `root` and `root_parsec` combinators can be used from other lexers
(such as the `EExLexer` for examples).