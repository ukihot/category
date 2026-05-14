#import "@preview/theorion:0.4.1": *
#import cosmos.clouds: *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: show-theorion
#show: codly-init.with()
#codly(languages: codly-languages)

随伴は、二つの圏の間にある最適な翻訳を与える。モナドは、その翻訳を一つの圏の内部に折り返したときに現れる代数的構造である。したがってモナドは、単なるプログラミング技法でも、抽象的な三つ組でもない。それは「自由に生成し、忘却し、再び自由に生成する」という操作が持つ反復可能性を、公理として取り出したものである。

本章では、モナドを三つの視点から扱う。第一に、随伴から生じる自己関手としてのモナド。第二に、Kleisli 圏による計算過程の圏論。第三に、Eilenberg--Moore 圏による代数構造の圏論である。最後に、分配法則、コモナド、計算論的例を通じて、モナドが現代数学と計算機科学の共通語になっている理由を明らかにする。

== 随伴からモナドへ

随伴 $F tack G$ を考える。$F: cal(C) -> cal(D)$ が左随伴、$G: cal(D) -> cal(C)$ が右随伴であるとき、合成 $G F: cal(C) -> cal(C)$ は $cal(C)$ 上の自己関手になる。単位 $eta: 1_cal(C) -> G F$ はそのまま得られる。さらに余単位 $epsilon: F G -> 1_cal(D)$ を用いると、
$ G F G F arrow.r^(G epsilon F) G F $
という自然変換が得られる。

#definition(title: "モナド")[
  圏 $cal(C)$ 上の *モナド* とは三つ組 $(T, eta, mu)$ である。

  - $T: cal(C) -> cal(C)$ は自己関手
  - $eta: 1_cal(C) -> T$ は単位
  - $mu: T T -> T$ は乗法

  これらは次の図式、すなわち結合律と単位律を満たす。

  $
    mu compose T mu = mu compose mu T
  $

  $
    mu compose T eta = id_T = mu compose eta T
  $
]

#theorem(title: "随伴から生じるモナド")[
  随伴 $F tack G$ が与えられると、$T = G F$, $eta$ を随伴の単位、$mu = G epsilon F$ として、$cal(C)$ 上のモナド $(T, eta, mu)$ が得られる。
]

#proof[
  モナドの単位律は随伴の三角等式
  $G epsilon compose eta G = id_G$ と
  $epsilon F compose F eta = id_F$
  から従う。結合律は、余単位 $epsilon$ の自然性と関手 $G, F$ の関手性から従う。
]

#remark[
  この定理は、モナドを「随伴の影」として理解させる。自由群関手 $F: bold("Set") -> bold("Grp")$ と忘却関手 $U: bold("Grp") -> bold("Set")$ の随伴 $F tack U$ からは、集合 $X$ に自由群の台集合 $U F X$ を対応させるモナドが得られる。
]

== 典型例

#example(title: "自由モノイドモナド")[
  集合 $X$ に、$X$ の元からなる有限列の集合 $X^*$ を対応させる関手を考える。単位 $eta_X: X -> X^*$ は元を長さ1の列に送る写像であり、乗法 $mu_X: (X^*)^* -> X^*$ は「列の列」を連結して一つの列に平坦化する写像である。結合律は連結の結合律、単位律は空でない一文字列の挿入が連結に影響しないことを表す。
]

#example(title: "冪集合モナド")[
  冪集合関手 $cal(P): bold("Set") -> bold("Set")$ は、$X$ に部分集合全体 $cal(P)(X)$ を対応させる。単位は $x |-> {x}$、乗法は部分集合族の和集合
  $ cal(P)(cal(P)(X)) -> cal(P)(X) $
  である。これは非決定的計算の数学的モデルを与える。
]

#example(title: "例外モナド")[
  固定した集合 $E$ に対し、$T(X)=X+E$ と置く。$eta_X$ は $X$ を左成分に入れる写像であり、$mu_X: (X+E)+E -> X+E$ は二重の例外を一つに畳み込む。これは「値を返すか、例外で停止する」計算を表す。
]

== Kleisli 圏

モナドは、通常の射 $X -> Y$ を「効果を伴う射」$X -> T Y$ に置き換える。これを圏として整理したものが Kleisli 圏である。

#definition(title: "Kleisli 圏")[
  モナド $(T, eta, mu)$ に対する *Kleisli 圏* $cal(C)_T$ は次のように定義される。

  - 対象は $cal(C)$ の対象と同じ
  - $cal(C)_T(X, Y)=cal(C)(X, T Y)$
  - 恒等射は $eta_X: X -> T X$
  - $f: X -> T Y$, $g: Y -> T Z$ の合成は
    $
      X arrow.r^f T Y arrow.r^(T g) T T Z arrow.r^(mu_Z) T Z
    $
]

#theorem(title: "Kleisli 合成の結合律")[
  上の定義により $cal(C)_T$ は圏になる。
]

#proof[
  恒等律はモナドの単位律から従う。結合律は、三つの Kleisli 射を合成したときに現れる二つの畳み込み
  $mu compose T mu$ と $mu compose mu T$
  がモナドの結合律により一致することから従う。
]

Kleisli 圏では、モナドは「射の型」を変えることで、合成可能な計算の世界を作る。Haskell の `>>=` はこの Kleisli 合成をプログラム言語の構文として具体化したものである。

```haskell
(>=>) :: Monad m => (a -> m b) -> (b -> m c) -> (a -> m c)
f >=> g = \x -> f x >>= g
```

== Eilenberg--Moore 圏

Kleisli 圏が「モナド的計算」を表すのに対し、Eilenberg--Moore 圏は「モナドに対する代数」を表す。

#definition(title: "T-代数")[
  モナド $(T, eta, mu)$ に対する *$T$-代数* とは、対象 $A$ と射 $a: T A -> A$ の組 $(A, a)$ であり、次を満たす。

  $
    a compose eta_A = id_A
  $

  $
    a compose T a = a compose mu_A
  $
]

#definition(title: "Eilenberg--Moore 圏")[
  $T$-代数 $(A, a)$ から $(B, b)$ への射は、$cal(C)$ の射 $f: A -> B$ であって
  $
    f compose a = b compose T f
  $
  を満たすものとする。これらからなる圏を $cal(C)^T$ と書き、*Eilenberg--Moore 圏* という。
]

#example(title: "自由モノイドモナドの代数")[
  $T(X)=X^*$ に対する $T$-代数 $a: X^* -> X$ は、有限列を一つの元へ評価する操作である。モナド法則との整合性は、$X$ がモノイドであり、$a$ が列の積を取る写像であることと一致する。したがって $bold("Set")^T$ はモノイドの圏と同値である。
]

この例は重要である。多くの代数的構造は、適切なモナドの Eilenberg--Moore 代数として表現できる。群、環、加群、束、順序代数などは、自由構成と忘却の随伴から得られるモナドによって統一的に扱われる。

== 二つの普遍性

同じモナド $T$ から、Kleisli 圏と Eilenberg--Moore 圏という二つの圏が生じる。これらは任意の随伴から得られるモナドの、両極端な普遍的実現である。

#theorem(title: "Kleisli 圏と Eilenberg--Moore 圏の普遍性")[
  モナド $T$ に対し、Kleisli 随伴
  $ F_T: cal(C) -> cal(C)_T $ と $ G_T: cal(C)_T -> cal(C) $
  が存在し、これから生じるモナドは $T$ である。また Eilenberg--Moore 随伴
  $ F^T: cal(C) -> cal(C)^T $ と $ U^T: cal(C)^T -> cal(C) $
  も存在し、同じく $T$ を生じる。
]

#remark[
  Kleisli 圏は、$T$ による効果を持つ射を「できるだけ自由に」加えた圏である。一方 Eilenberg--Moore 圏は、$T$ の作用をすでに吸収している代数的対象を集めた圏である。
]

== モナド性

随伴からはモナドが得られる。しかし逆に、ある関手が「モナドの代数を忘れる関手」として本質的に表されるのはいつか。この問いに答えるのが Beck のモナド性定理である。

#definition(title: "比較関手")[
  随伴 $F tack G: cal(D) -> cal(C)$ からモナド $T=G F$ が生じるとき、各 $D in cal(D)$ に
  $ (G D, G epsilon_D) $
  を対応させる関手
  $ K: cal(D) -> cal(C)^T $
  を *比較関手* という。
]

#theorem(title: "Beck のモナド性定理")[
  適切な余等化子の存在を仮定する。右随伴 $G: cal(D) -> cal(C)$ がモナド的である、すなわち比較関手 $K: cal(D) -> cal(C)^T$ が同値であるための必要十分条件は、$G$ が特定の $G$-分裂余等化子を作り、かつ保存し、さらに $G$ が同型を反映することである。
]

#remark[
  Beck の定理の力は、「代数的構造を持つ対象の圏」を、忘却関手の性質から認識できる点にある。たとえば群、環、加群の圏が集合上の代数として理解できることは、この定理の典型的な応用である。
]

== 分配法則とモナドの合成

二つのモナド $S, T$ があるとき、合成 $S T$ が常にモナドになるわけではない。必要なのは、二つの効果を入れ替える規則である。

#definition(title: "モナドの分配法則")[
  モナド $(S, eta^S, mu^S)$ と $(T, eta^T, mu^T)$ の間の *分配法則* とは、自然変換
  $ lambda: T S -> S T $
  であって、両方の単位と乗法に関する整合性図式を満たすものをいう。
]

#theorem(title: "合成モナド")[
  分配法則 $lambda: T S -> S T$ が与えられると、合成関手 $S T$ は自然にモナドとなる。
]

この事実は、例外、状態、非決定性、入出力などの計算効果を合成する際の数学的制約を説明する。プログラミングにおけるモナド変換子は、この問題の実践的な解法の一つである。

== Applicative と強モナド

計算論では、モナドより弱い構造として applicative 関手が現れる。圏論的には、これはモノイダル圏上の lax monoidal functor として理解される。

```haskell
class Functor f => Applicative f where
  pure  :: a -> f a
  (<*>) :: f (a -> b) -> f a -> f b
```

Applicative は、計算の形があらかじめ決まっている場合に十分である。一方、モナドでは前の計算結果に応じて次の計算を選ぶことができる。この差は、単なるプログラム上の利便性ではなく、合成可能な射のクラスの差である。

#remark[
  直積閉圏上で計算効果を扱うには、モナドに *強さ* (strength) が必要になる。強モナドは、通常の値と効果付き値を整合的に組み合わせる自然変換
  $ X times T Y -> T(X times Y) $
  を持つモナドである。
]

== コモナド

モナドの双対がコモナドである。モナドが「値を文脈へ入れ、文脈を平坦化する」構造なら、コモナドは「文脈から値を取り出し、文脈を展開する」構造である。

#definition(title: "コモナド")[
  圏 $cal(C)$ 上の *コモナド* とは三つ組 $(W, epsilon, delta)$ である。

  - $W: cal(C) -> cal(C)$ は自己関手
  - $epsilon: W -> 1_cal(C)$ は余単位
  - $delta: W -> W W$ は余乗法

  これらはモナド法則を双対化した余結合律と余単位律を満たす。
]

#example(title: "余自由的な文脈")[
  ストリーム、近傍、環境付き値などはコモナド的に扱える。たとえば無限ストリームでは、現在位置の値を取り出す操作が $epsilon$、各位置から見たストリームを並べる操作が $delta$ に対応する。
]

== まとめ

モナドは、随伴から生じる自己関手であると同時に、計算を合成するための構文であり、代数的構造を記述する意味論でもある。Kleisli 圏は「効果を持つ射」の圏を与え、Eilenberg--Moore 圏は「効果を吸収した対象」の圏を与える。この二重性こそが、モナドを圏論の中心概念にしている。

次章では、射の集合に加法構造を入れた圏を扱う。そこでは、モナドが与える代数的抽象とは別の方向から、線形代数とホモロジー代数が圏論の言葉に組み込まれる。
