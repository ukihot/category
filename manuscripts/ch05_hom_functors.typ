#import "@preview/theorion:0.4.1": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/xarrow:0.4.0"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import cosmos.clouds: *
#show: show-theorion

== 動機：射で対象を「測る」

圏 $cal(C)$ において対象 $X$ を調べるとき，最も自然な問いは「$X$ から（あるいは $X$ へ）どんな射があるか」である。

例として位相空間の圏 $bold("Top")$ を考える。円 $S^1$ を理解したければ，様々な位相空間 $Y$ から $S^1$ への連続写像 $f: Y -> S^1$ の全体を調べることができる。$Y = [0,1]$（閉区間）ならば $S^1$ 上の道，$Y = S^1$ ならば自己写像（回転，反射，定値写像など），$Y = S^2$（二次元球面）ならば写像の全体が $S^1$ の位相的複雑さを映し出す。

このように「様々な $Y$ をプローブとして $X$ を観測する」操作を，関手として定式化したものが Hom 関手である。

=== 定義

#definition(title: "Hom 関手（Hom Functor）")[
  局所的に小さい圏 $cal(C)$ と対象 $X in "Ob"(cal(C))$ を固定する。

  *共変 Hom 関手* $h^X$ を次のように定める：
  $
    h^X := cal(C)(X, -) : cal(C) -> bold("Set")
  $
  - 対象への作用：各 $Y in "Ob"(cal(C))$ に対して $h^X(Y) := cal(C)(X, Y)$（$X$ から $Y$ へのすべての射の集合）。
  - 射への作用：射 $g: Y -> Z$ に対して，写像 $g_* := h^X(g): cal(C)(X, Y) -> cal(C)(X, Z)$ を
    $
      g_*(f) := g compose f quad forall f in cal(C)(X, Y)
    $
    によって定める（*後合成*）。

  *反変 Hom 関手* $h_X$ を次のように定める：
  $
    h_X := cal(C)(-, X) : cal(C)^op -> bold("Set")
  $
  - 対象への作用：各 $Y in "Ob"(cal(C))$ に対して $h_X(Y) := cal(C)(Y, X)$。
  - 射への作用：射 $f: Y -> Z$ に対して，写像 $f^* := h_X(f): cal(C)(Z, X) -> cal(C)(Y, X)$ を
    $
      f^*(g) := g compose f quad forall g in cal(C)(Z, X)
    $
    によって定める（*前合成*）。
]

共変と反変の違いは，射の向きへの作用で決まる。$g: Y -> Z$ に対して $g_*$ は $cal(C)(X, Y) -> cal(C)(X, Z)$ と $g$ と*同じ向き*に動き，$f^*$ は $cal(C)(Z, X) -> cal(C)(Y, X)$ と $f$ と*逆向き*に動く。

=== Hom 関手が関手であることの検証

#theorem(title: "$h^X$ は関手である")[
  $h^X: cal(C) -> bold("Set")$ は関手の公理（恒等射の保存，合成の保存）を満たす。
]

#proof[
  *（恒等射の保存）* 任意の $f in cal(C)(X, Y)$ について
  $
    (h^X ("id"_Y))(f) = "id"_Y compose f = f,
  $
  よって $h^X("id"_Y) = "id"_{h^X(Y)}$. ✓

  *（合成の保存）* 射 $g: Y -> Z$，$k: Z -> W$，任意の $f in cal(C)(X, Y)$ について
  $
    (h^X(k compose g))(f) = (k compose g) compose f = k compose (g compose f) = (h^X(k) compose h^X(g))(f).
  $
  よって $h^X(k compose g) = h^X(k) compose h^X(g)$. ✓
]

合成の保存は，次の三角形が可換であることと等価である：

#align(center)[
  #diagram(
    spacing: (3cm, 2cm), // (横方向の間隔, 縦方向の間隔)

    node((0, 1), $cal(C)(X, Y)$, name: <A>),
    node((2, 1), $cal(C)(X, Z)$, name: <B>),
    node((1, 0), $cal(C)(X, W)$, name: <C>),

    edge(<A>, <B>, $g_*$, "->"),
    edge(<B>, <C>, $k_*$, "->"),
    edge(<A>, <C>, $(k compose g)_*$, "->", label-side: left),
  )
]

「Hom 関手は射の合成を写像の合成として忠実に記録する」と読める。

=== 具体例：様々な圏における Hom 関手

*例 1（集合の圏 $bold("Set")$）* 一点集合 $X = {*}$ を固定すると，$h^X(Y) = bold("Set")({*}, Y) tilde.eq Y$。よって $h^{{*}} tilde.eq "Id"_{bold("Set")}$：Hom 関手が恒等関手に一致する。

*例 2（アーベル群の圏 $bold("Ab")$）* $X = ZZ$（整数の加法群）とすると，$h^ZZ(A) = bold("Ab")(ZZ, A) tilde.eq A$（準同型 $ZZ -> A$ は $1 in ZZ$ の像によって完全に決まる）。これは $ZZ$ が $bold("Ab")$ における *自由アーベル群（階数 1）* であることの圏論的な意味である。

*例 3（可換環の圏 $bold("CRing")$）* $X = ZZ[t]$ とすると，$h^{ZZ[t]}(R) = bold("CRing")(ZZ[t], R) tilde.eq R$（環準同型 $ZZ[t] -> R$ は $t$ の像によって決まる）。$ZZ[t]$ が「$bold("CRing")$ における自由環（一変数）」を表現しているという主張の正確な意味がここにある。

*例 4（位相空間の圏 $bold("Top")$）* 単位区間 $I = [0, 1]$ を固定すると，$h^I(X) = bold("Top")(I, X)$ は $X$ 上の道の全体，$h^{{*}}(X) tilde.eq X$ は各点を与える。これらは経路連結性や基本群の研究の基礎となる。

// ========================================================
//  第2章：表現可能関手
// ========================================================

== 表現可能関手：関手の背後にある「源泉」

=== 動機：関手はどこから来るのか

関手 $F: cal(C) -> bold("Set")$ が与えられたとき，「この関手はある Hom 関手と同型か？」と問うことができる。もしそうであれば，$F$ の背後に *源泉となる対象* が一つ存在し，$F$ の全挙動はその対象への射の情報に還元される。

表現可能性が強力な理由は，抽象的な関手の解析を，より把握しやすい対象の解析に還元できる点にある。

=== 定義

#definition(title: "表現可能関手（Representable Functor）")[
  関手 $F: cal(C) -> bold("Set")$ が *表現可能* であるとは，ある対象 $X in "Ob"(cal(C))$ と自然同型
  $
    phi: h^X xarrow(tilde) F
  $
  が存在することをいう。このとき $X$ を $F$ の *表現対象（representing object）*，組 $(X, phi)$ を $F$ の *表現（representation）* と呼ぶ。
]

=== 普遍元：表現可能性を一点で捉える

#definition(title: "普遍元（Universal Element）")[
  表現 $(X, phi)$ に対して，$u := phi_X("id"_X) in F(X)$ を $F$ の *普遍元* と呼ぶ。
]

#theorem(title: "普遍元の特徴づけ")[
  元 $u in F(X)$ が $F$ の普遍元であることは，次と同値である：任意の対象 $Y in "Ob"(cal(C))$ と任意の元 $a in F(Y)$ に対して，$F(f)(u) = a$ を満たす射 $f: X -> Y$ が *一意に* 存在する。
]

#proof[
  $phi: h^X -> F$ が自然同型であるから，各成分 $phi_Y: cal(C)(X, Y) xarrow(tilde) F(Y)$ は全単射。$phi_Y(f) = a$ を満たす $f$ が一意に存在する。

  あとは $phi_Y(f) = F(f)(u)$ を示せばよい。$phi$ の自然性より，射 $f: X -> Y$ に対して次の図式が可換：

#align(center)[
  #diagram(
    spacing: (3cm, 2cm), // 横の間隔を広めにとって見やすく
    
    // ノードの配置
    node((0, 0), $cal(C)(X, X)$, name: <XX>),
    node((1, 0), $cal(C)(X, Y)$, name: <XY>),
    node((0, 1), $F(X)$, name: <FX>),
    node((1, 1), $F(Y)$, name: <FY>),
    
    // エッジ（矢印）の配置
    edge(<XX>, <XY>, $f_*$, "->"),
    edge(<XX>, <FX>, $phi_X$, "->"),
    edge(<XY>, <FY>, $phi_Y$, "->"),
    edge(<FX>, <FY>, $F(f)$, "->"),
  )
]

  $"id"_X in cal(C)(X, X)$ を追うと：
  $
    phi_Y (f_* ("id"_X)) = F(f)(phi_X ("id"_X))
    quad arrow.double quad
    phi_Y (f) = F(f)(u). quad square
  $
]

普遍元 $u in F(X)$ は「すべての $F(Y)$ の元を，$X$ から $Y$ へのある射を通じて $u$ から生成できる」という意味で，$F$ の全情報を一点に凝縮している。

=== 表現可能性と普遍性の同一視

圏論で「普遍性」と呼ばれる性質は，ほぼ例外なく表現可能性として定式化できる。

*例 1：直積*　$cal(C)$ における対象 $A, B$ の *直積* とは，関手 $F: cal(C)^op -> bold("Set"),\ Z mapsto cal(C)(Z, A) times cal(C)(Z, B)$ を表現する対象 $A times B$ のことである。普遍元は射影の対 $("pr"_A, "pr"_B)$ であり，普遍性は次の自然同型として現れる：
$
  cal(C)(Z, A times B) tilde.eq cal(C)(Z, A) times cal(C)(Z, B).
$

*例 2：自由群*　集合 $S$ 上の *自由群* $F(S)$ は，忘却関手 $U: bold("Grp") -> bold("Set")$ に対して，関手 $G mapsto bold("Set")(S, U(G))$ の表現対象である。

*例 3：テンソル積*　$R$ 加群の圏において，$M times.o_R N$ は双線形写像を表現する対象である：
$
  bold("Mod")_R (M times.o_R N, -) tilde.eq bold("BiLin")(M times N, -).
$

=== 表現対象の一意性

#theorem(title: "表現対象の一意性")[
  関手 $F: cal(C) -> bold("Set")$ が表現可能ならば，表現対象は同型を除いて一意に定まる。
]

#proof[
  $(X, phi)$ と $(X', phi')$ がともに $F$ の表現とする。合成 $(phi')^{-1} compose phi: h^X xarrow(tilde) h^{X'}$ は自然同型。米田の補題の特殊ケース（後述）$op("Nat")(h^X, h^{X'}) tilde.eq cal(C)(X', X)$ より，この自然同型はある射 $g: X' -> X$ に対応する。逆合成はある射 $g': X -> X'$ に対応する。埋め込みの忠実性から $g compose g' = "id"_X$，$g' compose g = "id"_{X'}$ が従い，$X tilde.eq X'$。$square$
]

// ========================================================
//  第3章：米田の補題
// ========================================================

== 米田の補題：自然変換の全体を一点で決定する

=== 主張

#lemma(title: "米田の補題（Yoneda Lemma）")[
  局所的に小さい圏 $cal(C)$，対象 $X in "Ob"(cal(C))$，関手 $F: cal(C) -> bold("Set")$ に対して，次の写像は *全単射* である：
  $
    Phi: op("Nat")(h^X, F) xarrow(tilde) F(X), quad alpha mapsto alpha_X ("id"_X).
  $
  さらにこの全単射は，$X$ について*反変的に*，$F$ について*共変的に*自然である。

  *特殊ケース* $F = h^Y$ として：
  $
    op("Nat")(h^X, h^Y) tilde.eq h^Y(X) = cal(C)(Y, X).
  $
]

=== 証明の骨格：なぜ一点で決まるのか

詳細な証明に入る前に，なぜこの定理が成り立つかを直観的に説明する。

自然変換 $alpha: h^X -> F$ の各成分 $alpha_Y: cal(C)(X, Y) -> F(Y)$ は，原理的には対象 $Y$ ごとに独立に指定できそうに見える。しかし *自然性条件*
$
  F(g) compose alpha_Y = alpha_Z compose g_*
$
は強い制約を課す。任意の射 $f: X -> Y$ について，この条件から次が導かれる：
$
  alpha_Y(f)
  = alpha_Y(f compose "id"_X)
  = alpha_Y(f_*("id"_X))
  = F(f)(alpha_X("id"_X)).
$

どんな $Y$ と $f: X -> Y$ を選んでも，$alpha_Y(f)$ の値は $a := alpha_X("id"_X) in F(X)$ という*一個の元*と関手 $F$ の作用だけから決まる。$alpha$ という「全対象・全射にわたる大きなデータ」が一点 $a in F(X)$ に圧縮される。逆に $a$ を一つ決めれば，$alpha_Y(f) := F(f)(a)$ という式が自然変換を復元する。これが米田の補題の核心である。

=== 詳細な証明

*Step 1：逆写像 $Psi$ の定義*

元 $a in F(X)$ に対して，自然変換 $Psi(a): h^X -> F$ を次の式で定義する：各対象 $Y$ に対して
$
  Psi(a)_Y: cal(C)(X, Y) -> F(Y), quad f mapsto F(f)(a).
$

*Step 2：$Psi(a)$ が自然変換であることの確認*

$Psi(a)$ が自然変換であるとは，任意の射 $g: Y -> Z$ に対して次の可換図式が成り立つことである：

#align(center)[
  #diagram(
    spacing: (3.2cm, 2.2cm), // ラベルが重ならないよう少し広めに
    
    // ノード（名前をつけて管理）
    node((0, 0), $cal(C)(X, Y)$, name: <XY>),
    node((1, 0), $cal(C)(X, Z)$, name: <XZ>),
    node((0, 1), $F(Y)$,        name: <FY>),
    node((1, 1), $F(Z)$,        name: <FZ>),
    
    // エッジ（矢印）
    edge(<XY>, <XZ>, $g_*$, "->"),
    edge(<XY>, <FY>, $Psi(a)_Y$, "->"),
    edge(<XZ>, <FZ>, $Psi(a)_Z$, "->"),
    edge(<FY>, <FZ>, $F(g)$, "->"),
  )
]

任意の $f in cal(C)(X, Y)$ に対して：
$
  F(g)(Psi(a)_Y(f)) & = F(g)(F(f)(a)) = F(g compose f)(a), \
   Psi(a)_Z(g_*(f)) & = F(g compose f)(a).
$
両者は一致する（最後の等号で $F$ の関手性を使用）。✓

*Step 3：$Psi compose Phi = "id"$ の確認（$Phi$ の単射性）*

自然変換 $alpha: h^X -> F$ を任意にとり，$a := Phi(alpha) = alpha_X("id"_X)$ とおく。$alpha$ の自然性は，射 $f: X -> Y$ に対して次の図式の可換性を意味する：

#align(center)[
  #diagram(
    spacing: (3cm, 2.2cm), // ラベルの高さに合わせて縦を少し広めに
    
    node((0, 0), $cal(C)(X, X)$, name: <XX>),
    node((1, 0), $cal(C)(X, Y)$, name: <XY>),
    node((0, 1), $F(X)$, name: <FX>),
    node((1, 1), $F(Y)$, name: <FY>),
    
    edge(<XX>, <XY>, $f_*$, "->"),
    edge(<XX>, <FX>, $alpha_X$, "->"),
    edge(<XY>, <FY>, $alpha_Y$, "->"),
    edge(<FX>, <FY>, $F(f)$, "->"),
  )
]

$"id"_X in cal(C)(X, X)$ を追うと $alpha_Y(f) = F(f)(alpha_X("id"_X)) = F(f)(a) = Psi(a)_Y(f)$。$Y$ は任意であったから $Psi(Phi(alpha)) = alpha$。✓

*Step 4：$Phi compose Psi = "id"$ の確認（$Phi$ の全射性）*

任意の $a in F(X)$ に対して
$
  Phi(Psi(a)) = Psi(a)_X ("id"_X) = F("id"_X)(a) = "id"_{F(X)}(a) = a. quad square
$

=== 対応の自然性

全単射 $Phi$ が $X$ および $F$ について自然であることを確認する。
「全単射が単に存在するだけでなく，整合的な族をなす」ことが保証される。

*$F$ についての共変自然性*：自然変換 $eta: F -> G$ が与えられると，次の四角形が可換である：

#align(center)[
  #diagram(
    spacing: (3.5cm, 2.2cm), // Nat(h^X, F) が長めなので横幅を広めに確保
    
    // ノード設定
    node((0, 0), $op("Nat")(h^X, F)$, name: <NF>),
    node((1, 0), $F(X)$, name: <FX>),
    node((0, 1), $op("Nat")(h^X, G)$, name: <NG>),
    node((1, 1), $G(X)$, name: <GX>),
    
    // エッジ設定
    edge(<NF>, <FX>, $Phi_F$, "->"),
    edge(<NF>, <NG>, $eta compose (-)$, "->"),
    edge(<FX>, <GX>, $eta_X$, "->"),
    edge(<NG>, <GX>, $Phi_G$, "->"),
  )
]

確認：$alpha in op("Nat")(h^X, F)$ をとる。
$
  eta_X(Phi_F(alpha)) = eta_X(alpha_X("id"_X))
  = (eta compose alpha)_X ("id"_X) = Phi_G(eta compose alpha). quad ✓
$

*$X$ についての反変自然性*：射 $f: X' -> X$ が与えられると，$h^f: h^{X'} -> h^X$（$(h^f)_Y(g) = g compose f$）を介して次の四角形が可換である：

#align(center)[
  #diagram(
    spacing: (3.8cm, 2.2cm), // ラベルの長さに合わせて横幅を広めに設定
    
    // ノード定義
    node((0, 0), $op("Nat")(h^X, F)$, name: <NX>),
    node((1, 0), $F(X)$, name: <FX>),
    node((0, 1), $op("Nat")(h^{X'}, F)$, name: <NXprime>),
    node((1, 1), $F(X')$, name: <FXprime>),
    
    // エッジ定義
    edge(<NX>, <FX>, $Phi$, "->"),
    edge(<NX>, <NXprime>, $(- compose h^f)$, "->"),
    edge(<FX>, <FXprime>, $F(f)$, "->"),
    edge(<NXprime>, <FXprime>, $Phi$, "->"),
  )
]
確認：$alpha in op("Nat")(h^X, F)$ をとる。
$
  Phi(alpha compose h^f) & = alpha_{X'}((h^f)_{X'}("id"_{X'})) = alpha_{X'}(f). \
        F(f)(Phi(alpha)) & = F(f)(alpha_X("id"_X)).
$
Step 3 の図式（$f: X' -> X$ を代入）より $alpha_{X'}(f) = F(f)(alpha_X("id"_X))$。両者は一致する。✓

=== 特殊ケースの意味：$F = h^Y$

$F = h^Y = cal(C)(Y, -)$ として米田の補題を適用すると：
$
  op("Nat")(h^X, h^Y) tilde.eq h^Y(X) = cal(C)(Y, X).
$

「$h^X$ から $h^Y$ への自然変換を一つ与えること」と「$Y$ から $X$ への射を一つ与えること」は，完全に同等な情報量を持つ。自然変換という高次の概念が，一階の射に完全に還元される。

// ========================================================
//  第4章：米田埋め込み
// ========================================================

== 米田埋め込み：圏を関手の宇宙に送り込む

=== 定義

#definition(title: "米田埋め込み（Yoneda Embedding）")[
  *米田埋め込み* を次の関手として定義する：
  $
    yen: cal(C)^op -> bold("Set")^(cal(C))
  $
  - 対象への作用：$X mapsto h^X = cal(C)(X, -)$。
  - 射への作用：$cal(C)^op$ の射 $f: X -> X'$（$cal(C)$ では $f: X' -> X$）に対して，自然変換 $h^f: h^{X'} -> h^X$ を
    $
      (h^f)_Z: cal(C)(X', Z) -> cal(C)(X, Z), quad g mapsto g compose f
    $
    によって定める（前合成）。
]

$bold("Set")^(cal(C))$ は，関手 $cal(C) -> bold("Set")$ を対象とし，自然変換を射とする圏（関手圏）である。米田埋め込みはこの大きな圏の中に $cal(C)^op$ を埋め込む。

射のレベルでの作用を図で表すと：射 $f: X' -> X$ は，各対象 $Z$ について次の写像を引き起こす。

#align(center)[
  #diagram(
    spacing: (4cm, 2cm), // ラベルが長いので横幅を広めに
    
    node((0, 0), $cal(C)(X', Z)$, name: <Xprime>),
    node((1, 0), $cal(C)(X, Z)$, name: <X>),
    
    edge(<Xprime>, <X>, $(h^f)_Z = (- compose f)$, "->"),
  )
]

=== 充満忠実性の証明

#theorem(title: "米田埋め込みは充満忠実（Fully Faithful）である")[
  任意の $X, X' in "Ob"(cal(C))$ に対して，
  $
    yen_(X, X') : cal(C)(X, X') -> op("Nat")(h^X, h^X'), quad f mapsto h^f
  $
  は全単射である。
]

#proof[
  $cal(C)^"op"(X, X') = cal(C)(X', X)$ に注意する。米田の補題に $F = h^X'$ を代入すると，全単射
  $
    Phi: op("Nat")(h^X, h^X') xarrow(tilde) h^X'(X) = cal(C)(X', X)
  $
  が存在する（$Phi(alpha) = alpha_X ("id"_X)$）。$Phi compose yen_(X, X')$ を計算する：射 $f: X' -> X$ に対して
  $
    (Phi compose yen_(X, X'))(f) = Phi(h^f) = (h^f)_X ("id"_X) = "id"_X compose f = f.
  $
  よって $Phi compose yen_(X, X') = "id"_(cal(C)(X', X))$。$Phi$ は全単射であるから $yen_(X, X')$ も全単射。
]

充満忠実性は次の二つの性質に分解される：

- *忠実性（faithful）*：$yen(f) = yen(g) => f = g$（異なる射は異なる自然変換に送られる）。
- *充満性（full）*：任意の自然変換 $alpha: h^X -> h^X'$ に対して，$alpha = h^f$ となる射 $f: X' -> X$ が存在する（自然変換は必ず射から来る）。

「$h^X$ と $h^{X'}$ の間の自然変換は，$cal(C)$ での射と完全に対応している」と一言で表せる。

=== 対象の同型性の特徴づけ

#corollary(title: "Hom 関手の同型と対象の同型")[
  任意の $X, X' in "Ob"(cal(C))$ に対して：
  $
    h^X tilde.equiv h^X' space (bold("Set")^cal(C) "での自然同型")
    quad <=> quad
    X tilde.equiv X' space (cal(C) "での同型").
  $
]

#proof[
  $(arrow.l.double)$：$X tilde.equiv X'$ であれば，同型射 $i: X -> X'$ と $i^(-1): X' -> X$ から $h^i: h^X' -> h^X$ と $h^(i^(-1)): h^X -> h^X'$ が互いに逆の自然変換となる。
  
  $(arrow.r.double)$：自然同型 $phi: h^X xarrow(tilde) h^X'$ が与えられたとする。充満忠実性より，$phi = h^f$，$phi^(-1) = h^g$ となる射 $f: X' -> X$，$g: X -> X'$ が存在する。忠実性から $g compose f = "id"_X$，$f compose g = "id"_X'$ が従い $X tilde.equiv X'$。
]

対象の同型 $X tilde.eq X'$ と Hom 関手の同型 $h^X tilde.eq h^{X'}$ の同値性を図式で表すと：

#align(center)[
  #diagram(
    spacing: (3cm, 2cm),
    
    // ノード（プライムの中括弧を削除）
    node((0, 0), $X$, name: <X>),
    node((1, 0), $X'$, name: <Xp>),
    node((0, 1), $h^X$, name: <hX>),
    node((1, 1), $h^X'$, name: <hXp>),
    
    // エッジ（同型記号は tilde.equiv を使用）
    edge(<X>, <Xp>, $tilde.equiv$, "<->"),
    edge(<hX>, <hXp>, $tilde.equiv$, "<->"),
    
    // 垂直の米田埋め込み
    edge(<X>, <hX>, $yen$, "->"),
    edge(<Xp>, <hXp>, $yen$, "->"),
  )
]

$X$ と $X'$ が同型かを確かめるには，内部構造を分解する必要はなく，全ての対象に対する射のパターンが一致するか—すなわち $h^X tilde.eq h^{X'}$ か—を確認すれば十分である。

=== プレシーフ圏への完備化

米田埋め込みのもう一つの重要な側面は，圏 $cal(C)$ を *プレシーフ圏* $hat(cal(C)) := bold("Set")^(cal(C)^op)$（反変関手の圏）の中に埋め込むことで，$cal(C)$ が持っていなかった構造（極限・余極限など）を自由に構成できるようになる点である。

#theorem(title: "プレシーフ圏は余完備である")[
  $hat(cal(C)) = bold("Set")^(cal(C)^op)$ は任意の小さな余極限を持つ。さらに，任意のプレシーフ $F in hat(cal(C))$ は表現可能プレシーフ（Hom 関手）の余極限として表現できる（*余ネルブ定理*）。
]

この操作は，有理数体 $QQ$ を実数体 $RR$（コーシー列の完備化）に埋め込む操作と類比できる：元の圏 $cal(C)$ では余極限が存在しなかった箇所でも，プレシーフ圏 $hat(cal(C))$ に移れば自由に構成できる。

// ========================================================
//  第5章：意味と応用
// ========================================================

== 意味と応用：米田補題が告げること

=== 対象の外部的な決定：ライプニッツの原理の数学化

*集合論的なパラダイム*では，対象の「中身」が本質であり，外部との関係は二次的な情報である。*米田的なパラダイム*では，対象 $X$ の「本質」は，あらゆる対象 $Y$ との射のパターン $\{cal(C)(X, Y)\}_{Y in cal(C)}$ の全体にある。系 4.1 が示すように，この外部情報が一致すれば，対象は同型でなければならない。

これはライプニッツの *不可識別者同一の原理*（二つのものが全ての性質を共有すれば同一である）の圏論的な具現化である。ただし「性質」が「他の全対象との射の集合」として数学的に定式化されている点が，哲学的な議論との決定的な違いである。

=== 随伴関手との関係

#definition(title: "随伴関手（Adjoint Functor）—米田的定義")[
  関手 $L: cal(C) -> cal(D)$ と $R: cal(D) -> cal(C)$ が *随伴対*（$L tack.r R$）であるとは，次の自然同型が存在することである：
  $
    cal(D)(L X, Y) tilde.equiv cal(C)(X, R Y) quad (X in cal(C), Y in cal(D)).
  $
]

米田の補題を用いると，この自然同型は「関手 $cal(D)(L -, Y): cal(C)^op -> bold("Set")$ と関手 $cal(C)(-, R Y): cal(C)^op -> bold("Set")$ が自然同型」と読める。すなわち $L$ と $R$ の間の表現可能性の対称的な関係として理解できる。随伴の存在定理（右随伴の存在定理など）は，この表現可能性の問いとして定式化される。

=== 計算機科学への応用

Haskell などの関数型言語における *米田埋め込み* は次の型として現れる：

```haskell
newtype Yoneda f a = Yoneda { runYoneda :: forall b. (a -> b) -> f b }
```

この型は $op("Nat")(h^a, f) tilde.eq f(a)$（米田の補題）を Haskell の型システムで表現している。$F$ が関手であれば，`Yoneda f a` と `f a` は自然に同型である。この同型を利用すると，関手の連続した `fmap` 呼び出しを「一回の合成」に変換する最適化が可能になる：*継続渡しスタイル（CPS 変換）* との深い関係がここにある。

=== 自然性という概念の不可欠性

米田の補題の証明で最も重要な等式は
$
  alpha_Y(f) = F(f)(alpha_X ("id"_X))
$
である。この等式は自然性条件（可換図式の成立）だけから導かれた。もし自然性を要求せず，単なる射の族 $\{alpha_Y: cal(C)(X, Y) -> F(Y)\}$ を考えるなら，それを $F(X)$ の一元で決定することはできない。

自然変換が「正しい変換の概念」である理由の一つが，ここにある。自然性は単なる技術的条件ではなく，「変換が圏の構造（射の合成）と整合する」という実質的な要請であり，その整合性が強力な圧縮を可能にしている。

#remark[
  米田の補題は「なぜ自然変換が圏論の適切な射の概念であるか」を事後的に正当化する。自然性なしには情報の圧縮は起こらず，圏論の理論的な豊かさの多くが失われる。
]

// ========================================================
//  まとめ
// ========================================================

== まとめ：米田補題が確立すること

本章で証明した主要な事実を整理する。

+ *Hom 関手* $h^X = cal(C)(X, -)$ は関手の公理を満たし，$X$ の「外部観測のパッケージ」として機能する。具体例として $bold("Set")$，$bold("Ab")$，$bold("CRing")$，$bold("Top")$ での現れを確認した。

+ *表現可能関手* とは Hom 関手と自然同型な関手であり，圏論における普遍性（直積，自由対象，テンソル積など）を統一的に定式化する概念である。表現対象は同型を除いて一意に定まる。

+ *米田の補題* $op("Nat")(h^X, F) tilde.eq F(X)$ は，自然変換という高次の構造が $F(X)$ の一元という一点情報に完全に圧縮されることを述べる。証明の核心は，自然性条件が全ての $alpha_Y(f)$ を $alpha_X("id"_X)$ で決定することにある。

+ *米田埋め込み* $yen: cal(C)^"op" -> bold("Set")^(cal(C))$ は充満忠実であり，$h^X tilde.equiv h^X' <=> X tilde.equiv X'$ を保証する。対象の同型は外部観測の一致と等価である。

+ 応用として，随伴関手・普遍性・プレシーフ完備化・計算機科学（CPS 変換）など，圏論の主要な理論がすべて米田の補題を基盤としている。

#important-box(title: "最後に：圧縮の源泉")[
  $op("Nat")(h^X, F) tilde.eq F(X)$ が可能なのは，$h^X$ が「恒等射 $"id"_X$ を一つ持つ」という事実から，自然性を通じて全ての射 $f: X -> Y$ への作用が決定されるからである。恒等射が「全射の生成元」として機能するこの構造が，米田の補題の数学的な源泉である。
]
