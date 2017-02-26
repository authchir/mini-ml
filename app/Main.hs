module Main where

import qualified Compiler
import qualified Compiler.Llvm
import qualified Lexer
import qualified Parser
import qualified System.Environment
import qualified TypeContext as TyContext
import qualified TypeInference as TyInference

compileFile :: String -> String
compileFile code =
  let tokens = Lexer.alexScanTokens code in
  let exp = Parser.parse tokens in
  case TyInference.infer TyContext.empty exp of
    Nothing -> "Does not type check"
    Just (_, expr) ->
      let nf = Compiler.toNormalForm expr in
      let nfCl = Compiler.toClosure nf in
      let llvmIr = Compiler.Llvm.compile nfCl in
      llvmIr

main :: IO ()
main = interact compileFile
