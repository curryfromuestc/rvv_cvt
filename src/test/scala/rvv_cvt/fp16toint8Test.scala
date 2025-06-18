package rvv_cvt

import chisel3._
import chisel3.util._
import chisel3.experimental.BundleLiterals._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.freespec.AnyFreeSpec
import org.scalatest.matchers.must.Matchers

class fp16toint8Test extends AnyFreeSpec with Matchers {
    "fp16toint8" in {
      simulate(new fp16toint8(8)) { dut =>
        dut.io.in(0).poke(0x4940.U)
        dut.io.in(1).poke(0xcb38.U)
        dut.io.in(2).poke(0x0000.U)
        dut.io.in(3).poke(0x0000.U)
        dut.io.in(4).poke(0x4940.U)
        dut.io.in(5).poke(0xcb38.U)
        dut.io.in(6).poke(0x0000.U)
        dut.io.in(7).poke(0x0000.U)
        
        dut.clock.step(3)  // 等待2个时钟周期让数据通过流水线
        
        // for (i <- 0 until 8) {
        //   println(s"out($i) = ${dut.io.out(i).peek()}")
        // }
      }
    }
}