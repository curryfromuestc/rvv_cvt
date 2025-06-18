# rvv_cvt

  这是一个将fp16转换为int8的模块，用于RISCV的向量（vector）扩展。
  实现了RTL，以及用在NEMU和spike上面测试的汇编代码。

## 在NEMU上面测试  

  确保香山的NEMU已经安装，并且已经编译好了。

  首先运行命令：
  ```
  cd NEMU_spike_test
  make
  ```

  然后将生成的.bin文件复制到nemu的build文件夹下，然后运行nemu：
  ```
  ./riscv64-nemu-interpreter fp16_to_int8_test.bin
  ```

## 在spike上面测试

  确保spike已经安装，并且已经编译好了。

  运行命令：
  ```
  cd NEMU_spike_test
  make
  spike --isa=rv64gcv_zfh_zvfh -d fp16_to_int8_test.elf
  ```
## chisel测试

  ```
  mill rvv_cvt.test
  ```
