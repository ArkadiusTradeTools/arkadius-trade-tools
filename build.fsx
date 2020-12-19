open Fake.IO.Globbing
#r "paket:
nuget Fake.Core.Target
nuget Fake.IO.Zip //"
#load "./.fake/build.fsx/intellisense.fsx"

let projectName = "ArkadiusTradeTools"
let archiveName = "arkadius-trade-tools"
let directoryGlob = "build/"


open Fake.Core
open Fake.IO
open Fake.IO.Globbing.Operators

// Properties
let buildDir = "./build/"

// Targets
Target.create "Clean" (fun _ ->
  Directory.ensure buildDir
  Shell.cleanDir buildDir
)
Target.create "Copy" (fun _ -> 
  !! "**/*.lua"
  -- "**/*.test.lua"
  ++ "LICENSE"
  ++ "**/*.md"
  ++ "**Exports/lua53.exe"
  ++ "**/*.txt"
  ++ "**/*.xml"
  ++ "**/*.dds"
  -- "**.fake/**/*"
  |> GlobbingPattern.setBaseDir "./"
  |> Shell.copyFilesWithSubFolder directoryGlob
)

Target.create "Deploy" (fun p ->
  let fileName = sprintf "%s-%s.zip" archiveName p.Context.Arguments.Head
  (fileName, !! (sprintf "%s/**" directoryGlob)) ||> Zip.zip "build/"
  Shell.cleanDir buildDir
  Directory.ensure "releases"
  Shell.moveFile "releases" fileName
)

Target.create "Default" ignore

// Dependencies
open Fake.Core.TargetOperators

"Clean"
  ==> "Copy"
  ==> "Default"
  ==> "Deploy"

// start build
Target.runOrDefaultWithArguments "Deploy"