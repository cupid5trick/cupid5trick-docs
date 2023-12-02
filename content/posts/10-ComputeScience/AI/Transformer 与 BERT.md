---
scope: learn
draft: true
---
# 1. 背景

本文是 NAACL2021 录取论文 [^1^](#ref1)。

以 BM25 位为代表的经典信息检索系统依靠词汇精确匹配在基于词频统计建立的倒排索引上高效搜索来完成检索。这类精确匹配的检索模型虽然效率很高，但准确度已经达到瓶颈。

目前通常认为检索问题面临着词汇不匹配和语义不匹配两大问题。词汇不匹配即检索查询和待检索文档使用不同的单词来表达同样的意义，语义不匹配是查询和文档中同样的单词由于语境不同而指向不同的含义。以 BM25 为代表的 Lexical IR 采用 BOW（Bag Of Words）语言模型，近几年的成果利用了深度语言（deep LM）模型来解决这两个问题，作者把相关成果总结为四类：

1. 应用深度语言模型进行文档排序 Deep LM Based Ranker，BM25+BERT reranker
2. 引用深度语言模型增强词汇匹配过程 Deep LM Based Retriever，DocT5Query，DeepCT
3. 利用深度语言模型建立单向量的稠密索引 Dense Retrievers with single vector representation，DPR
4. 多向量检索系统 Multi-vector representation，ColBERT

而作者提出的方案是 DPR 和 ColBERT 的折中，把每个文档编码为一组低维向量，而检索时只根据查询和文本的重叠词计算相关度评分。其效率接近 DPR，而准确度与 ColBERT 相当。



# 2. BERT: 基于 Transformer 的 deep LM（深度语言模型）

BERT [^2^](#ref2)（Bidirectional Encoder Representations from Transformers）是一个基于注意力机制的 Transformer 神经网络模型，BERT 采用著名的*Attention Is All You Need*[^4^](#ref4)中 Encoder Decoder 架构实现了自然语言理解，能够在各种自然语言处理任务上训练出表现十分优秀的模型。BERT 模型在 GLUE（General Language Understanding Evaluation）数据集的多项自然语言理解任务上获得优秀成绩。

## 2.1 Transformer Network [^4^](#ref4)

BERT 采用的是*Attention Is All You Need*[^4^](#ref4)中的网络结构，网络由若干个 Transformer 单元构成。Transformer 是 Encoder Decoder 架构。

- 左边 Encoder 由*Multi-Head Attention*注意力模块和全连接层构成，每层后面都施加了标准化，并采用了残差链接的设计。而 Encoder 和 Decoder 中的全连接层*Feed Forward*模块是由两个全连接层中间加上*ReLU*激活函数构成的。
- 右边 Decoder 比 Encoder 在第一层多了一个*Masked Multi-Head Attention*模块，使用第二层的*Multi-Head Attention*模块计算 Encoder 和 Decoder 的注意力，同样采用了残差链接设计和标准化。
- 为了能够描述输入序列的顺序特征，在 Encoder 和 Decoder 的输入层还采用了位置编码（*Positional Encoding*），在词向量中加入位置信息。

Transformer 网络基本单元的结构如图所示。

![](transformer.png)

### 2.1.1 Multi-Head Attention 模块

*Multi-Head Attention*模块是基于*Attention*模块的。

Attention 模块的结构如图。Attention 模块的三个输入 $Q$ , $K$ , $V$ 是被描述为查询（queries）、键（key）、值（value）的向量。

![](attention.png)
$$
\mathrm{Attention}(Q, K, V) = \mathrm{softmax}(\frac{QK^T}{\sqrt{d_k}})V
$$
*Attention Is All You Need*中把这种注意力函数叫做*Scaled Dot-Product Attention*，注意力模块的输出是 $V$ 的加权平均。

*Multi-Head Attention*模块通过很多组参数矩阵 $W$ 分别对 $Q$ , $K$ , $V$ 施加变换后计算它们的注意力，并在串联之后再次施加一次变换，其模块结构如图。

![](multi-head-attention.png)
$$
\mathrm{MultiHead}(Q, K, V) = \mathrm{Concat}(\mathrm{head_1}, ..., \mathrm{head_h})W^O    \\                                           
    \text{where}~\mathrm{head_i} = \mathrm{Attention}(QW^Q_i, KW^K_i, VW^V_i)
$$
$W$ 变换矩阵是参数， $W^Q_i \in \mathbb{R}^{d_{\text{model}} \times d_k}$ , $W^K_i \in \mathbb{R}^{d_{\text{model}} \times d_k}$ , $W^V_i \in \mathbb{R}^{d_{\text{model}} \times d_v}$ and $W^O \in \mathbb{R}^{hd_v \times d_{\text{model}}}$ 。

而在 Decoder 模块中的***Masked Multi-Head Attention***模块是由于 Decoder 上一次的输出作为 Decoder 的输入，为了阻止前面位置的词向量参与到后面位置词向量的运算中而进行掩模（例如，在翻译任务中位置* $i$ *的单词其输出只依赖于单词* $i$ *左侧的单词）。

### 2.1.2 Transformer 网络中的 Attention 机制

- Decoder 中的第二个组件*Multi-Head Attention*计算了编码器和解码器之间的 Attention，这里的 $Q$ , $K$ 来自编码器的输出， $V$ 来自解码器中的上一层输出（即*Masked Multi-Head Attention*模块的输出）
- 编码器模块中的自注意力（***Self Attention***），即 Encoder 中的*Multi-Head Attention*模块。这里的 $Q$ , $K$ , $V$ 都来自同一个输入。Encoder 中的自注意力计算中，每个位置的词向量都通过*Multi-Head Attention*的计算与任意位置的词向量产生联系。
- 解码器中的自注意力（***Self Attention***），即 Decoder 中的*Masked Multi-Head Attention*模块。这里 $Q$ , $K$ , $V$ 都来自解码器的上一次输出。但是与编码器中自注意力的不同之处在于每个位置的词向量只能与它左侧位置的词向量产生联系，因此在计算*Masked Multi-Head Attention*时把相应位置的参数设为 $-\infin$ 来实现掩模。

### 2.1.3 Position-wise Feed-Forward Networks

Encoder 和 Decoder 中另一个主要模块是全连接模块，它由两个全连接层中间加上 ReLU 激活层组成，对每个位置的单词（词向量）施加这个运算。这个全连接层的公式为：
$$
\mathrm{FFN}(x)=\max(0, xW_1 + b_1) W_2 + b_2
$$

### 2.1.4 位置编码（Positional Encoding）

为了使模型能够捕捉到输入序列的位置信息，在输入层引入了位置编码。对不同位置的单词引入一个位置编码，这样即使同一单词出现在不同位置其词向量也会不同，因此模型才能够捕捉到输入序列的位置特征。否则输入单词序列无论如何打乱都会训练出相似的词向量表达。

对于位置编码*Attention Is All You Need*试验了固定编码和根据数据学习编码两种方式，发现两种编码方式产生的结果几乎没有任何区别，最终采取了正弦函数编码的方式。即：对词向量的不同维度分量采用不同频率的正弦函数作为其位置编码：
$$
PE_{(pos,2i)} = sin(pos / 10000^{2i/d_{\text{model}}})
$$

$$
PE_{(pos,2i+1)} = cos(pos / 10000^{2i/d_{\text{model}}})
$$

公式中 $pos$ 表示单词位置， $i$ 表示词向量的维度。

### 2.1.5 Transformer 网络完整结构

基于 Encoder 和 Decoder 的基本结构，Transformer 网络由 6 层编码器和 6 层解码器堆叠构成。一个 6 层 Transformer 构成的网络在机器翻译任务下的网络结构示意图：

![](transformer-network-1623947935007.png)

## 2.2 BERT 语言模型

BERT 语言模型就采用 Transformer 网络架构。以 BERT-BASE 为例，使用了 12 个 Transformer 单元，*Multi-Head Attention*的注意力组数为 12，输出维度为 512。

下图是 BERT 模型的输入输出结构。BERT 语言模型的输入是一个单词序列（可能是一个句子或两句包装到一起），每个序列第一个元素是一个特殊记号** `[CLS]` **，在分类任务中** `[CLS]` **的词向量将用于整合句子级的表示。在图中，用 $E$ 表示输入的词向量， $C$ 表示训练完成后** `[CLS]` **的词向量， $T_i$ 表示训练完成后第 $i$ 个单词的词向量。

![](bert-arc.png)

每个单词的输入向量 $E$ 由词嵌入编码（*token embedding*）、分段编码（*segment embedding*）和位置编码（*position embedding*）三部分相加组成，词嵌入编码采用 WordPiece 编码，分段编码用于表示一个单词属于两句中的哪一句（输入为两句的情况）。如图：

![](bert-input-embeding.png)

# 3. 相关成果

## 3.1 应用 deep LM 进行文档排序（Deep LM Based Ranker）

一些利用深度语言模型进行文档排序的方法通常是基于 BERT 语言模型的，把查询和文档包装起来正好作为 BERT 语言模型的输入，从而利用预训练模型生成查询与文档之间的相关性评分，作为文档排序的指标。下图是一些 BERT 语言模型计算交叉注意力产生相关度评分的示意图。

![](deepLM-ranker.png)

在检索系统的文档排序流程中使用深度语言模型同时解决了单词不匹配和语义不匹配问题，但对于最顶层的全局语料库检索 (full-collection retrieval) 的召回阶段来说，交叉注意力的计算量依旧过于昂贵。因此人们通常会用简单的 BM25 召回一批用于排序的候选文档，然后再用 BERT reranker 做精排。

## 3.2 应用 deep LM 进行文档召回（Deep LM Based Retriever）

还有一些以 DocT5Query、DeepCT 为代表的方法通过 deep LM 来增强传统信息检索系统的文档召回流程。DocT5Query 通过基于 T5 的问题生成模型来扩充文档内容，缓解词汇不匹配的问题，DeepCT 利用 BERT 来修正词权重以更好地匹配重点词。这些方法都没有从根本上解决词汇不匹配问题。

## 3.3 单向量表示的密集检索

另一些研究者延续之前建立单向量表示、建立密集索引的方法。把文档的向量表示存储在一个密集索引中，通过最邻近搜索来查询文档。这种方法和深度语言模型结合后，也能够取得不错的效果。以 SentenceBERT 和 DPR 为代表的基于 deep LM 的稠密检索模型在多个检索任务上取得了最优性能，后续也有很多研究探讨了如何训练出一个泛化性能更好的稠密检索模型，比如语义残差嵌入 (semantic residual embeddings) 和基于近似最近邻的对比学习 (ANN negative contrastive learning)。

下图展示了 DPR 模型密集检索系统：

![](dpr-dense-retriever.png)

## 3.4 多向量表示的检索方法

由于文档和语言的复杂性，单个稠密向量实际上很难表示文本的细粒度语义信息，也有很多研究者探索了文档多向量表示的检索系统。*Poly-encoder*把查询表示为一组向量。*Me-BERT*把文档表示为一组向量集合。同时期的*ColBERT*把查询和文档都使用多个向量来表示：把文档用所有单词的词向量来表示，用查询中所有单词的词向量和扩展单词的词向量集合来表示查询，然后计算两个词向量集合两两匹配的笛卡儿积的匹配评分，从而得到查询和文档的匹配评分。下图展示了*ColBERT*模型的匹配计算模式。

![](colbert.png)

由于 ColBERT 将 document 的所有 token 都进行了稠密编码，也就是需要将文档的所有 token 向量存到单个索引中，这导致 ColBERT 与 DPR 相比，索引的复杂度直接增加了一个数量级，并且在查询过程中需要遍历所有索引，因此 ColBERT 对硬件的要求很高，对大规模语料库来说往往是不可承受的。

# 4. 模型实现

## 4.1 相关度评分

COIL 的相关度评分包括单词评分和语义评分两部分。采用基于 Transformer 的语言模型（具体为 BERT [^2^](#ref2) LM 公开发布的 BERT-BASE，uncased 版本 [^3^](#ref3)），把查询和文档的每个单词编码成一个向量
$$
\mathbf{\upsilon}_{i}^{q}=\mathit{W}_{tok}\mathbf{LM}(q,i)+\mathit{b}_{tok}\\
\mathbf{\upsilon}_{j}^{d}=\mathit{W}_{tok}\mathbf{LM}(d,j)+\mathit{b}_{tok}
$$
计算相似度时，只计算查询和文档中有重叠单词的部分：
$$
\mathit{s}_{tok}=\sum_{q_i\in q\cap d}\mathop{\mathbf{max}}_{d_j=q_i}(\mathit{{\upsilon_{i}^{q}}^{\mathit{T}}}\mathit{\upsilon_{j}^{d}})
$$
因为每个向量都表示了一个单词在整个语境中的信息，因此作者把这部分叫做语境化的单词匹配评分（*contextualized exact lexical match scoring*），这部分相似度只计算了词形相同的部分，没有解决单词不匹配的问题。所以作者使用一个特殊的 `[CLS]` 符号来计算整个文档或整个查询粒度的相似度：
$$
\mathbf{\upsilon}_{cls}^{q}=\mathit{W}_{cls}\mathbf{LM}(q,\mathbf{CLS})+\mathit{b}_{cls}\\
\mathbf{\upsilon}_{cls}^{d}=\mathit{W}_{cls}\mathbf{LM}(d,\mathbf{CLS})+\mathit{b}_{cls}
$$
最终整个 COIL 模型的相关度评分公式为：
$$
\mathit{s}_{full}=\mathit{s}_{tok}+\mathit{{\upsilon_{cls}^{q}}^{\mathit{T}}}\mathit{\upsilon_{cls}^{d}}
$$


在文章实验中作者把加入了 `[CLS]` 的 COIL 模型称为 COIL-full，没有加入 `[CLS]` 的叫做 COIL-tok。

由 COIL 检索模型建立的索引结构如图。每个文档会有一个 $\mathit{n_c}$ 维的 CLS 向量，所有的 CLS 向量占一个索引条目。每个单词占一个索引条目，一个单词的每次出现都会产生一个 token 向量。

![](coil-index-1623951978530.png)

## 4.2 索引建立过程

索引建立过程如图。获取到一篇文章时，利用训练好的模型参数去计算文档中每个单词的向量，合并到相应单词的倒排列表中。之后还要计算整篇文章的 `[CLS]` 向量，同样合并到 `[CLS]` 的倒排列表中。

![](indexing.jpg)

## 4.3 检索查询过程

以查询“apple juice”为例，论文给出了检索过程的示例。作者把检索过程总结为三个步骤：

1. A set of matrix products to compute token similarities over contextualized inverted lists
2. Scatter to map token scores back to documents
3. Sort to rank the documents

![](querying.png)

接收到“apple juice”这个查询以后，检索系统计算出查询的矩阵 $Q$ 和 `[CLS]` 向量 $\mathit{cls}_1$ ，并搜索索引获取文档的 token 矩阵 $D$ 和 `[CLS]` 矩阵 $\mathbf{CLS}$ ：
$$
Q=\begin{bmatrix}q_1,q_2\end{bmatrix}\\
D=\begin{bmatrix}u_1,v_1,w_1,u_2,v_2,w_2\end{bmatrix}\\
\mathbf{CLS}=\begin{bmatrix}cls(6), cls(7),cls(5),cls(9)\end{bmatrix}
$$
随后系统对 $Q^{\mathit{T}}D$ 和 $\mathit{cls_1}^{\mathit{T}}\mathbf{CLS}$ 的矩阵运算可以做并行等优化处理，然后计算得到相关度评分：
$$
\mathit{socre}=\begin{bmatrix}s_6,s_7,s_5,s_9\end{bmatrix}
$$
最后根据评分大小排序得到检索结果。

COIL 检索系统和 ColBERT 的区别在于只对查询和文档中重叠单词计算评分，而 ColBERT 的相关性评分公式为：
$$
\mathit{s}(q,d)=\sum_{q_i\in [cls;q;exp]}\mathop{\mathbf{max}}_{d_j\in [cls; d]}(\mathit{{\upsilon_{i}^{q}}^{\mathit{T}}}\mathit{\upsilon_{j}^{d}})
$$
ColBERT 计算了查询和文档之间所有单词基于语境的匹配评分，计算代价要比 COIL 大得多，因此效率也就比不上 COIL。



# 5. 模型评价结果

## 5.1 基线模型比较

作者在 MSMACRO passage (8M 英文文章，平均长度 60) 和 MSMACRO document (3M 英文文档，平均长度 900) 两个数据集上测试了*COIL*模型，实验设置了四类基线模型：

- 基于精确单词匹配的传统检索系统（*BM25*）
- 使用深度语言模型增强的 BM25 检索系统（*DeepCT*，*DocT5Query*）
- 单向量表示的密集检索系统（*DPR*）
- 基于多向量表示计算*all-to-all*式软匹配的检索系统（*ColBERT*）

*MSMARCO passage*任务上的测试结果：

![img](MSMARCO-passage.jpg)

*MSMARCO document*任务上的测试结果：

![](MSMARCO-document.jpg)

测试结果表明*COIL*模型确实超过了传统的检索系统和密集索引的检索系统，在短篇文章测试上的表现几乎与*ColBERT*相当，长篇文档任务上的测试结果也表明*COIL*能够应用于长文档检索。*COIL*通过把匹配计算限制在查询和文档的重叠词，获得了比*ColBERT*更高的效率，而在准确度上与*ColBERT*差距极小。

## 5.2 模型维度分析

作者在实验中也测试了单词的上下文词向量维度 $n_t$ 和 `[CLS]` 的词向量维度 $n_c$ 对模型性能的影响。

![](dimension.jpg)

从测试结果可以看出，将 ``[CLS]`` 从 768 维降到 128 维会导致表现轻微的下降，因为降低 ``[CLS]`` 的维度限制了模型学习语义特征（尤其是单词不匹配情境下的语义特征）的能力。将 $n_t$ 从 32 降到 8 所带来的影响很小，甚至可以获得更高的 MRR，这表明降维有时候能够起到一定的正则化作用。

# 6. 对 COIL 的思考

## 6.1 对单词不匹配问题的解决显得粗放

COIL-tok 完全采用单词匹配没有解决单词不匹配问题的能力，而 COIL-full 仅仅引入一个 `[CLS]` 向量作为单词不匹配问题的补丁尚显不足。从图中实验数据也能看到 COIL-full 和 ColBERT 还有一些差距。

![](MSMARCO-passage.jpg)

从语言上来说，语言结构非常复杂，文档长度也有长有短，仅仅一个 `[CLS]` 向量必然不足以描述整个文档或用户查询的特征。COIL 虽然通过限制单词匹配范围获取了效率上的优势，但也丢失了一部分匹配词义的能力。对于单词不匹配问题的解决还需要更精细的设计。



## 6.2 索引系统

COIL 的多向量索引系统是一个向量存储系统，需要支持频繁写入和快速查找，还需要根据索引快速进行矩阵、向量的拼接。随着数据规模的扩张，这个向量存储系统也需要向分布式转变。目前还没有这样的索引系统，设计难度大。

## 6.3 训练难度

作者使用了 BERT-BASE，uncased 版本的 BERT 语言模型，其训练复杂度、训练条件没有给出。

## 6.4 训练条件

实际的检索系统中待检索的文档长度不一，而论文中给出的结果都是在文章长度固定的任务下给出的，对实际应用中说服力不够强。相信之后的研究会像图像识别领域一样对训练数据的多尺度给与关注。

# 7. 参考文献

<div><a  name="ref1"></a>[1]:<a href=" https://arxiv.org/abs/2104.07186">COIL: Revisit Exact Lexical Match in Information Retrieval with Contextualized Inverted List</a></div>

<div id="ref2">[2]:<a href=" https://arxiv.org/abs/1810.04805">J. Devlin, Ming-Wei Chang, Kenton Lee, and Kristina Toutanova. 2019. Bert: Pre-training of deep bidirectional transformers for language understanding. In NAACL-HLT.</a></div>

<div id="ref3">[3]:<a href=" https://github. Com/google-research/bert #pre -trained-models">Google Research Pre-trained models</a></div>

<div id="ref4">[4]:<a href=" https://papers.nips.cc/paper/7181-attention-is-all-you-need.pdf">Ashish Vaswani, Noam Shazeer, Niki Parmar, Jakob Uszkoreit, Llion Jones, Aidan N. Gomez, Łukasz Kaiser, and Illia Polosukhin. 2017. Attention is all you need. In Proceedings of the 31st International Conference on Neural Information Processing Systems (NIPS'17). Curran Associates Inc., Red Hook, NY, USA, 6000–6010</a></div>

