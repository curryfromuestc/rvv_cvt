package rvv_cvt

import chisel3._
import chisel3.util._

class fp16toint8(val VNUM : Int) extends Module {
  val io = IO(new Bundle {
    val in = Input(Vec(VNUM, UInt(fp16.LENGTH.W)))
    val out = Output(Vec(VNUM, SInt(8.W)))
  })

  // 创建两级流水线寄存器
  val stage1_data = Reg(Vec(VNUM, new Bundle {
    val sign = Bool()
    val significand = UInt(11.W)  // 1.mant 格式，11位包含隐含的1
    val exponent = SInt(6.W)      // 无偏指数
  }))

  for (i <- 0 until VNUM) {
   stage1_data(i).sign := io.in(i)(15)
   stage1_data(i).significand := Cat(1.U, io.in(i)(9, 0))
   stage1_data(i).exponent := io.in(i)(14, 10).asSInt - 15.S
  }

  for (i <- 0 until VNUM) {
    val shift_amount = stage1_data(i).exponent - 10.S
    val shifted_significand = (stage1_data(i).significand >> (-shift_amount).asUInt)(6,0)

    when (stage1_data(i).sign === 0.U) {
      io.out(i) := Cat(0.U, shifted_significand).asSInt
    } .otherwise {
      io.out(i) := Cat(1.U, (~shifted_significand + 1.U)(6,0)).asSInt
    }
  }
}