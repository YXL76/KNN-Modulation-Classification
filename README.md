# KNN-Modulation-Classification

## 实验目的

利用 kNN 算法识别无线信号传输系统所使用的调制方式，辅助传统的 AMC 技术

## 实验内容

利用样本集训练 kNN 分类器，同时通过修改高阶累积量、计算高阶矩的数据数、kNN 参数，对比分析不同情况下识别的准确率

## 实验方法和算法原理

### 调制方式

- `BPSK`: $u(i)=\frac{1}{\sqrt{2}}(1-2b(i))+j(1-2b(i))$
- `QPSK`: $u(i)=\frac{1}{\sqrt{2}}[(1-2b(i))+j(1-2b(2i+1))]$
- `16QAM`: $u(i)=\frac{1}{\sqrt{10}}\{(1-4b(i))[2-(1-2b(4i+2))]+j(1-2b(4i+1))[2-(1-2b(4i+3))]\}$
- `64QAM`: $u(i)=\frac{1}{\sqrt{42}}\{(1-2b(6i))[4-(1-2b(6i+2))[2-(1-2b(6i+4))]]+j(1-2b(6i+1))[4-(1-2b(6i+3))[2-(1-2b(6i+5))]]\}$

### AMC 技术

根据信噪比自适应选择调制方式，但是发射机与接收机之间必须相互通信告知调制方式，从而占用部分频谱/时隙/功率资源

### 高阶累积量特征

- 高阶矩: $M_{pq}=E[X(t)^{(p-q)}X^*(t)^q]$
- 高阶累积量: $C_pq=\mathrm{cum}\{X(t),\cdots,X(t),X^*(t),\cdots,X^*(t)\}$
  - 其中$X(t)$为$p-q$项，$X^*(t)$为$q$项

### kNN

> kNN 算法(k-nearest neighbors algorithm)是模式识别领域的一种统计方法，可以用于分类和回归。用于分类时，输出是一个对象$k$个最近邻居中出现最多的类别

1. 计算各个数据点到样本点的距离
2. 对距离进行排序
3. 统计距离最小的$k$个点
4. 统计$k$个点所属的类别
5. 返回出现频率最高的类别作为结果

## 实验平台

- `OS`: `Manjaro Linux x86_64`
- `Kernel`: `5.4.78-1-MANJARO`
- `Python`: `3.8.6`
- `Jupyter Notebook`: `6.1.4`
- `Scikit-learn`: `0.23.2`
- `Matplotlib`: `3.3.3`
- `Numpy`: `1.19.4`

## 实验步骤

1. 运行位于`data_generation`中的`Matlab`代码生成数据保存到`data`中
   - 生成样本集: 运行`getSample.m`，生成数据供`kNN`算法训练
   - 生成测试数据集: 运行`getTest16QAM.m`、`getTestBPSK.m`、`getTestQPSK.m`，生成的数据名称格式为`test[process]-[N]-[snr].dat`
     - `process`: 调制方式，有`BPSK`、`QPSK`、`16QAM`
     - `N`: 用于计算高阶矩的每组数据数，有`200`、`500`
     - `snr`: 信噪比
2. 运行位于`modulation_recognition`中的`main.ipynb`，查看并分析结果

## 实验总结

1. SNR 越大，识别正确率越高
2. 用于计算高阶矩的样本量越多，识别正确率越高
3. 调制阶数越高，识别正确率达到 1 时对应的 SNR 越高
4. 提升高阶累积量可以显著增加识别的正确率
