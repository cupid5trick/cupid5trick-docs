---
title: ANN
author: cupid5trick
created: "2022-12-02 17:06"
tags: []
categories: []
access: private
scope: learn
draft: true
lang:
- zh-cn
- en-us
abstract: []
keywords: []
export_hugo: |
    pandoc -f markdown --resource-path="D:\LearnProgramming\javascript\code\obsidian\documents\10-学习\AI" --resource-path="D:\LearnProgramming\javascript\code\obsidian\documents\10-学习\AI\_attachments\ANN" --lua-filter="D:\LearnProgramming\javascript\code\obsidian\documents\.obsidian\plugins\obsidian-enhancing-export\lua\markdown+hugo.lua" -s -o "D:\LearnProgramming\javascript\code\obsidian\documents\.output\pandoc\hugo\ANN.md" -t commonmark_x-attributes --log="D:\LearnProgramming\javascript\code\obsidian\documents\.output\pandoc\hugo\ANN.md.log" "D:\LearnProgramming\javascript\code\obsidian\documents\10-学习\AI\ANN.md"
---

ANN（神经网络基础与应用）

# 人工神经网络

基本概念

大脑功能

生物神经元

人工神经元

# 学习与感知

人工神经网络

损失函数

Rosenblatt 感知机

学习

- 有监督
	- 回归
	- 分类
- 无监督
- 强化学习

![](image-20221203163330714.png)

![](image-20221203163245793.png)

# 优化

## 最优化

## 梯度下降

GD、SGD、BGD、MBGD

![](image-20221203151646519.png)

SGD

每次随机选择一个样本学习。

优点：能跳过局部极小值点

缺点：存在波动。迭代次数多，收敛速度慢

BGD

每次使用全部的训练样本学习

优点：每次更新都会朝着正确的方向进行，最后能保证收敛于极值点

缺点：每次学习时间过长，并且如果训练集很大以至于需要消耗大量的 内存，不能进行在线模型参数更新。

MBGD

每次从训练集样本随机选择 k (k<m) 个样本进行学习，取得每次更新速度和更新次数的平衡

优点：降低了收敛波动性：即降低了参数更新的方差，使得更新更加稳定；

相对于批量梯度下降，其提高了每次学习的速度；

MBGD 不用担心内存瓶颈从而可以利用矩阵运算进行高效计算；

![](image-20221203152930966.png)

## 学习率调整（Category Optimization）

Ada、AdaGrad、RMSProp、Adam

**Adam**

动量法和 RMSProp 方法的结合，不仅具有动量法的优点而且可以自适应调整学习率。

[Adam优化器 | 机器之心](https://www.jiqizhixin.com/graph/technologies/f41c192d-9c93-4306-8c47-ce4bf10030dd)

![](image-20221203171413119.png)

## 反向传播

# 卷积神经网络

## 生物感受野

## 卷积神经网络拓扑结构

- 卷积
- 池化
- 展平

## 共享链接权重

## 一些卷积神经网络模型

LeNet AlexNet VGG GoogLeNet ResNet

## Dropout 技术

[理解dropout_张雨石的博客-CSDN博客_dropout](https://blog.csdn.net/stdcoutzyx/article/details/49022443)

- 防止过拟合的方法：

    - 提前终止（当验证集上的效果变差的时候）
    - L1 和 L2 正则化加权
    - soft weight sharing
    - dropout
- dropout 率的选择

    - 经过交叉验证，隐含节点 dropout 率等于 0.5 的时候效果最好，原因是 0.5 的时候 dropout 随机生成的网络结构最多。
    - dropout 也可以被用作一种添加噪声的方法，直接对 input 进行操作。输入层设为更接近 1 的数。使得输入变化不会太大（0.8）
- 训练过程

    - 对参数 w 的训练进行球形限制 (max-normalization)，对 dropout 的训练非常有用。
    - 球形半径 c 是一个需要调整的参数。可以使用验证集进行参数调优
    - dropout 自己虽然也很牛，但是 dropout、max-normalization、large decaying learning rates and high momentum 组合起来效果更好，比如 max-norm regularization 就可以防止大的 learning rate 导致的参数 blow up。
    - 使用 pretraining 方法也可以帮助 dropout 训练参数，在使用 dropout 时，要将所有参数都乘以 1/p。

# 递归神经网络 RNN

## 结构

## 输入

## 输出

## 时间维度的反向传播（BPTT）

## LSTM

- [Understanding LSTM Networks -- colah's blog](https://colah.github.io/posts/2015-08-Understanding-LSTMs/)
- [The Unreasonable Effectiveness of Recurrent Neural Networks](http://karpathy.github.io/2015/05/21/rnn-effectiveness/)
- [理解 LSTM 网络 - 简书](https://www.jianshu.com/p/9dc9f41f0b29)

## GRU

[人人都能看懂的GRU - 知乎](https://zhuanlan.zhihu.com/p/32481747)

## Seq2Seq

Encoder Decoder 模式。Encoder 把原始输入数据编码为向量，现实问题转为数学问题。Decoder 把数学问题求解后的向量表达，转化为现实解决方案。

## Attention

## Transformer

## BERT

# 强化学习
