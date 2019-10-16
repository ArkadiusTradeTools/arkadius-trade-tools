let projectName = "ArkadiusTradeTools"
let archiveName = "arkadius-trade-tools"
let directoryGlob = "build/"

open Fake.IO.Globbing
#r "paket:
nuget Fake.Core.Target
nuget Fake.IO.Zip //"
#load "./.fake/build.fsx/intellisense.fsx"

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
  ++ "LICENSE"
  ++ "**/*.txt"
  ++ "**/*.xml"
  ++ "**/*.dds"
  -- "**.fake/**/*"
  |> GlobbingPattern.setBaseDir "./"
  |> Shell.copyFilesWithSubFolder directoryGlob
)

Target.create "Deploy" (fun p ->
  (sprintf "%s-%s.zip" archiveName p.Context.Arguments.Head, !! (sprintf "%s/**" directoryGlob))
  ||> Zip.zip "build/"
  Shell.cleanDir buildDir
)

Target.create "Default" ignore

// Dependencies
open Fake.Core.TargetOperators

"Clean"
  ==> "Copy"
  ==> "Default"
  ==> "Deploy"

// start build
Target.runOrDefaultWithArguments "Default"