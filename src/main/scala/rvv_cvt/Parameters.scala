package rvv_cvt

import chisel3._
import chisel3.util._

object fp16 {
  val LENGTH = 16
  val EXPWIDTH = 5
  val FRACTIONWIDTH = 10
}

object bf16 {
  val LENGTH = 16
  val EXPWIDTH = 8
  val FRACTIONWIDTH = 7
}