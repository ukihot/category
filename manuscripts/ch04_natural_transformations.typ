#import "@preview/theorion:0.4.1": *
#import cosmos.clouds: *
#show: show-theorion

前章までに、我々は対象を点とし、関手を世界（圏）の間の翻訳として捉えてきた。しかし、翻訳の仕方は一通りではない。本章で扱う *自然変換* (Natural Transformation) は、二つの翻訳 $F$ と $G$ を比較し、一方が他方へと滑らかに変形可能であることを保証する「メタな矢印」である。

== 自然変換の定義：射の族としての翻訳

二つの関手 $F, G: cal(C) -> cal(D)$ があるとき、それらを結ぶ「橋」を架ける。

#definition(title: "自然変換 (Natural Transformation)")[
  圏 $cal(C)$ から $cal(D)$ への二つの関手 $F, G: cal(C) -> cal(D)$ に対し、*自然変換* $alpha: F arrow.r.double G$ とは、各対象 $X in op("Ob")(cal(C))$ に対して、$cal(D)$ の射
  $$alpha_X : F(X) -> G(X)$$
  を割り当てた族 ${alpha_X}_{X in op("Ob")(cal(C))}$ であり、以下の *自然性条件* を満たす：

  任意の射 $f: X -> Y in cal(C)$ に対して、以下の図式が可換である：
  $$
  F(X) arrow.r^(alpha_X) G(X) \\
  arrow.d^(F(f)) arrow.d^(G(f)) \\
  F(Y) arrow.r^(alpha_Y) G(Y)
  $$

  すなわち、$alpha_Y compose F(f) = G(f) compose alpha_X$
]

#important-box(title: "イメージと直観")[
  自然変換は「関手というムービーの、各フレーム間の差分」のようなものである。$F(X)$ という点が $G(X)$ という点へ移動する「道」が全対象にわたって用意されており、それらがバラバラではなく、圏 $cal(C)$ の構造を保ったまま連動している様子を想像してほしい。

  より正確には：任意の "遷移" $f: X -> Y$ に対して、「先に $f$ で移動してから変換する」ことと「先に変換してから $f$ で移動する」ことが同じ結果をもたらす。
]

#theorem(title: "自然性四角形の重要性")[
  自然変換の定義における可換性条件（自然性四角形）は、単なる技術的条件ではなく、*変換が「特定の対象の個別の構造」に依存しない* ことを表現している。すべての対象に対して統一的に機能する変換のみが「自然」と呼ばれるのである。
]

#footnote[
  圏論の歴史において、実は「圏」や「関手」よりも先に定義されたのがこの「自然変換」である。Eilenberg と Mac Lane の元々の動機は、「自然な対応」を厳密に定義することであった。
]

== 自然性四角形：経路独立性の詳細な解析

#theorem(title: "自然変換の可換性と情報保存")[
  自然変換 $alpha: F -> G$ に対して、$f: X -> Y$ を任意の射とするとき、以下の二つの経路は同じ射をもたらす：
  1. 経路1：$F(X)$ から $F(Y)$ へ $F(f)$ で移動してから $alpha_Y$ で変換
  2. 経路2：$F(X)$ から $alpha_X$ で変換してから $G(X)$ から $G(Y)$ へ $G(f)$ で移動

  すなわち、圏論的言語では $alpha$ は「異なる道順で同じ結果に到達できる」ことを保証する。
]

#definition(title: "自然変換の垂直合成")[
  自然変換 $alpha: F -> G$ と $beta: G -> H$ に対して、*垂直合成* $beta circle alpha$（または $beta compose alpha$）を次のように定義する：
  $ (beta circle alpha)_X := beta_X compose alpha_X $
]

#definition(title: "自然変換の水平合成")[
  関手 $F, G: cal(C) -> cal(D)$ と $F', G': cal(D) -> cal(E)$、および自然変換 $alpha: F -> G$ と $beta: F' -> G'$ に対して、*水平合成* $beta ast alpha: F' compose F -> G' compose G$ を定義する：
  $ (beta ast alpha)_X := beta_{G(X)} compose F'(alpha_X) $
  （あるいは交換法則により $G'(alpha_X) compose beta_{F(X)}$ とも書ける）
]

== 自然同型：構造の完全な一致
