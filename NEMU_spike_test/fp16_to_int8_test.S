.section .rodata
.align 3
fp16_data:
  .hword 0x4940
  .hword 0xcb38
  .hword 0x0000
  .hword 0x0000
  .hword 0x4940
  .hword 0xcb38
  .hword 0x0000
  .hword 0x0000

.section .bss
.align 3
int8_result:
  // 为8个 int8 结果预留空间
  .space 8

.text
.globl _start
_start:
  // --- 开启浮点和向量单元 ---
  csrr t1, mstatus

  // 一次性将 FS 和 VS 字段都设置为 'Initial' (01)
  // 0x2200 = (1 << 13) | (1 << 9)
  li t2, 0x2200
  or t1, t1, t2
  
  // 将修改后的值写回 mstatus
  csrw mstatus, t1
  // --- 单元已开启 ---

  // 我们要处理8个FP16元素
  li t0, 8
  
  // 设置向量配置 (vcfg):
  // 元素位宽 SEW = 16 bits (用于 fp16 和 int16)
  // 向量寄存器分组 LMUL = 1
  // 设置向量长度 (vl) 为 8
  vsetvli a0, t0, e16, m1, ta, ma

  // 从内存加载 FP16 数据到向量寄存器 v8
  la t1, fp16_data
  vle16.v v8, (t1)

  // --- 核心转换逻辑 (新方法) ---

  // 1. 设置 SEW=8 为 vfncvt 指令做准备
  //    该指令将 2*SEW (16-bit) 的浮点数转换为 SEW (8-bit) 的整数。
  //    vl 保持不变 (8)，因为我们还是要处理8个元素。
  //    v8 寄存器中的内容不变，但现在被 vfncvt 解释为双倍宽度的源操作数。
  vsetvli a0, t0, e8, m1, ta, ma

  // 2. 转换: 直接将 FP16 向量 (v8) 转为 INT8 向量 (v10)
  //    使用 vfncvt.rtz.x.f.w 指令，带 'rtz' (Round-towards-Zero) 以匹配原逻辑。
  //    .x(有符号整数), .f(浮点源), .w(双倍宽度源)
  vfncvt.rtz.x.f.w v10, v8


  // --- 验证步骤 ---
  
  // 将最终的 INT8 结果 (v10) 存回内存，方便在调试器中观察
  la t1, int8_result
  vse8.v v10, (t1)

// 结束程序，进入一个无限循环，以便在调试器中检查寄存器状态
done:
  li a0, 0
  .word 0x5006b
  j done 