lib: modulesPath:
modulesPath
|> lib.filesystem.listFilesRecursive
|> lib.filter (lib.hasSuffix ".nix")
|> lib.filter (
  path:
  path
  |> lib.path.removePrefix modulesPath
  |> lib.path.subpath.components
  |> lib.all (component: !(lib.hasPrefix "_" component))
)
