#import "@preview/theorion:0.4.1": *
#import cosmos.clouds: *
#show: show-theorion

圏と圏の間の「構造を保つ写像」である関手を定義し、その諸性質を俯瞰する。

== 関手の定義

#definition(title: "関手 (Functor)")[
  圏 $bold(C)$ から圏 $bold(D)$ への *共変関手* (covariant functor) $F: bold(C) -> bold(D)$ とは、以下の対応からなる：

  - 任意のオブジェクト $X in bold(C)$ に対し、オブジェクト $F(X) in bold(D)$ を割り当てる。
  - 任意の射 $f: X -> Y in bold(C)$ に対し、射 $F(f): F(X) -> F(Y) in bold(D)$ を割り当てる。

  これらは以下の公理（構造の保存）を満たす必要がある：
  + *恒等射の保存*: 任意の $X in bold(C)$ に対して $F(id_X) = id_(F(X))$
  + *合成の保存*: 任意の合成可能な射 $f, g in bold(C)$ に対して $F(g compose f) = F(g) compose F(f)$
]

== 共変／反変

射の向きを逆転させる関手を反変関手と呼ぶ。これは双対圏からの共変関手としてスマートに記述できる。

#lemma(title: "反変関手の性質")[
  反変関手 $F: bold(C) -> bold(D)$ は、合成の順序を入れ替える：
  $ F(g compose f) = F(f) compose F(g) $
  これは共変関手 $F: bold(C)^op -> bold(D)$ と本質的に等価である。
]

== 恒等関手と合成

#theorem(title: "関手の合成")[
  関手 $F: bold(C) -> bold(D)$ と $G: bold(D) -> bold(E)$ が存在するとき、その合成 $G compose F: bold(C) -> bold(E)$ もまた関手となる。
]

関手の合成は結合律を満たし、各圏 $bold(C)$ に対して恒等関手 $1_bold(C)$ が存在することから、*「圏を対象とし、関手を射とする圏」* $bold("Cat")$ が構成される。

== 忘却関手

#definition(title: "忘却関手 (Forgetful Functor)")[
  群の圏 $bold("Grp")$ から集合の圏 $bold("Set")$ への関手のように、代数的な構造（演算や単位元）を「忘れて」台集合のみを取り出す関手を $U$ (Underlying/Utile) と表記し、忘却関手と呼ぶ。
]

忘却関手は情報を捨てる操作だが、数学的には非常に重要な役割（随伴対の片割れ）を担うことが多い。

== 忠実・充満・本質的全射性

関手が「圏の構造をどの程度保存するか」を測る基準として、三つの重要な性質がある。

#definition(title: "忠実関手 (Faithful Functor)")[
  関手 $F: cal(C) -> cal(D)$ が *忠実* であるとは、任意の対象 $X, Y in "Ob"(cal(C))$ に対して、Hom集合の間の写像
  $ F_{X,Y}: cal(C)(X, Y) -> cal(D)(F(X), F(Y)) $
  が単射であることである。

  言い換えれば、$F(f) = F(g) => f = g$（異なる射は異なる像へ移る）が成り立つ。
]

#definition(title: "充満関手 (Full Functor)")[
  関手 $F: cal(C) -> cal(D)$ が *充満* であるとは、任意の対象 $X, Y in op("Ob")(cal(C))$ に対して、Hom集合の制限 $F_{X,Y}$ が全射であることである。言い換えれば、$cal(D)(F(X), F(Y))$ のすべての射は、$F$ の下での何らかの $cal(C)$ の射の像である。
]

#definition(title: "本質的全射性 (Essential Surjectivity)")[
  関手 $F: cal(C) -> cal(D)$ が *本質的全射* であるとは、任意の対象 $Z in op("Ob")(cal(D))$ に対して、$Z approx F(X)$ となる $X in op("Ob")(cal(C))$ が存在することである。すなわち、$cal(D)$ のすべての対象が、$cal(C)$ の何らかの対象の像と同型である。
]

#theorem(title: "圏の同値の特徴づけ")[
  関手 $F: cal(C) -> cal(D)$ について、以下は同値である：
  1. $F$ は *忠実かつ充満かつ本質的全射*である
  2. $F$ は *圏の同値*を誘導する（すなわち、逆関手 $G: cal(D) -> cal(C)$ が存在して、$G compose F approx 1_{cal(C)}$ かつ $F compose G approx 1_{cal(D)}$）

  このような関手を、*関手圏の同値*と呼ぶ。#footnote[圏の「同型」（すべての射がすべての対象で対応）と「同値」（本質的に同じ構造）の区別は重要である。同値の方がより柔軟で、実用的である。]
]

#proof[
  方向 (1) ⇒ (2)：
  - 本質的全射性から、各 $Y in cal(D)$ に対して $X_Y in cal(C)$ と同型 $iota_Y: Y approx F(X_Y)$ が存在する
  - 逆関手 $G: cal(D) -> cal(C)$ を、$G(Y) := X_Y$ と定義し、射も適切に定義する
  - 充満性と忠実性により、$G compose F$ と $F compose G$ は「自然同型で元に戻る」

  方向 (2) ⇒ (1)：逆関手の存在から、忠実・充満・本質的全射性が直接導かれる。
]

#example(title: "同値関手の例")[
  1. *有限次元ベクトル空間の双対性*:
    有限次元 $k$-ベクトル空間の圏 $bold("FinVect")_k$ において、各対象 $V$ をその双対空間 $V^* = "Hom"(V, k)$ に対応させる双対関手は、$bold("FinVect")_k$ とその双対圏 $(bold("FinVect")_k)^("op")$ の間の同値を誘導する。

  2. *充満・忠実関手の定義*:
    関手 $F: bold(C) -> bold(D)$ が誘導する写像 $F_(X,Y): "Hom"_bold(C)(X, Y) -> "Hom"_bold(D)(F X, F Y)$ について：
    - これが *単射* であるとき、$F$ は *忠実* (faithful) であるという。
    - これが *全射* であるとき、$F$ は *充満* (full) であるという。
    - これが *全単射* であるとき、$F$ は *忠実充満* (fully faithful) であるという。
]

関手が *忠実充満* かつ *本質的に全射* であるとき、その関手は *圏の同値* を与える。

== 埋め込み関手

#theorem(title: "埋め込み (Embedding)")[
  関手 $F: bold(C) -> bold(D)$ が忠実充満であり、かつオブジェクトレベルで単射であるとき、これを *埋め込み* と呼ぶ。
  これにより、$bold(C)$ は $bold(D)$ の充満部分圏として「再現」される。
]

#proof[
  忠実充満関手は、$bold(C)$ における射の構造を $bold(D)$ の中で完全に保存するため、$bold(C)$ の性質を $bold(D)$ の中で調べることを可能にする。
]
