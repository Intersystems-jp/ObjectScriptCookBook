# ObjectScriptの基本のき！

ObjectScriptは、InterSystems全製品（Cache／Ensemble／HealthShare／InterSystems IRIS／InterSystems IRIS for Health）に組み込まれたスクリプト言語で、データベースに対する操作（オブジェクト／SQL／グローバル変数操作）以外にも文字列処理、数値演算、コマンドやユーティリティクラスを利用したHTTP要求・応答、ファイル入出力など、一般のプログラミング言語と同等の記述が行えるスクリプトです。

> InterSystems 製品のサーバサイドで行うプログラミングにObjectScriptを使用できます。例えば、InterSystems製品をデータベースとしてご利用いただいている場合は、ObjectScriptを利用することデータが存在するその場所でプログラムを実行できます（データベースサーバー上で実行できるので接続処理などは不要です）。

以下説明では、ObjectScript でプログラミングを始める方を対象に、ObjectScriptの操作の基本を解説します。

なお、インストールや環境設定、IDEの使い方などは含まれません。
事前に確認されたい場合は、以下ビデオをご利用ください。

- [【はじめての InterSystems IRIS】セルフラーニングビデオ：基本その１：InterSystems IRIS Community Edition をインストールしてみよう！](https://jp.community.intersystems.com/node/478596)
- [【はじめての InterSystems IRIS】セルフラーニングビデオ：基本その2：InterSystems IRIS で開発をはじめよう！](https://jp.community.intersystems.com/node/478601)


「こんなときはどうしたら？？」という場合は [ObjectScript クックブック](CookBook.md) にサンプルを含めた解説をご用意しています。

もし、疑問が解消できなかった場合は、[開発者コミュニティ](https://jp.community.intersystems.com)へぜひご質問ください！いただいた質問の回答は、[ObjectScript クックブック](CookBook.md) に追加させていただきます！

- [1. Hello Worldの出力](#1-hello-worldの出力)
    - [1-1) ターミナルを利用したObjectScriptの実行](#1-1-ターミナルを利用したobjectscriptの実行)
    - [1-2) ターミナルの起動方法](#1-2-ターミナルの起動方法)
    - [1-3) Hello World の出力](#1-3-hello-world-の出力)
- [2. ObjectScriptの記述方法](#2-objectscriptの記述ルール)
    - [2-1) ターミナルでのコマンドの書き方](#2-1-ターミナルでのコマンドの書き方)
    - [2-2) ルーチンやメソッドに記述する場合のルール](#2-2-ルーチンやメソッドに記述する場合のルール)
    - [2-3) コメントの記述](#2-3-コメントの記述)
    - [2-4) クラスメソッドの実行方法](#2-4-クラスメソッドの実行方法)
    - [2-5) ルーチン実行方法](#2-5-ルーチン実行方法)
- [3. 変数について](#3-変数について)
    - [3-1) 配列変数の作成](#3-1-配列変数の作成)
    - [3-2) 配列変数の参照](#3-2-配列変数の参照)
    - [3-3) 配列変数のサブスクリプトが不明な場合の参照方法](#3-3-配列変数のサブスクリプトが不明な場合の参照方法)
    - [3-4) 変数の削除](#3-4-変数の削除)
- [4. コマンド](#4-コマンド)
    - [4-1) メソッドやルーチンを実行する場合に使用するコマンド](#4-1-メソッドやルーチンを実行する場合に使用するコマンド)
    - [4-2) ループのコマンド](#4-2-ループのコマンド)
    - [4-3) プログラムの実行を終了するコマンドのQUIT](#4-3-プログラムの実行を終了するコマンドのquit)
    - [4-4) プログラムの実行を終了するコマンドのRETURN](#4-4-プログラムの実行を終了するコマンドのreturn)
    - [4-5) QUITとRETURNの違い](#4-5-quitとreturnの違い)
- [5. 引数の渡し方](#5-引数の渡し方)
    - [5-1) 参照渡しの使い方](#5-1-参照渡しの使い方)
    - [5-2) 可変数の引数の使い方](#5-2-可変数の引数の使い方)
- [6. TRUE／FALSEについて](#6-truefalseについて)
- [7. メソッドやルーチンでSQLを実行する方法](#7-メソッドやルーチンでsqlを実行する方法)
    - [7-1) 埋め込みSQL](#7-1-埋め込みsql)
    - [7-2) ダイナミックSQL](#7-2-ダイナミックsql)


___

## 1. Hello Worldの出力

### 1-1) ターミナルを利用したObjectScriptの実行

ターミナルはObjectScriptのインタラクティブな実行環境であり、Hello World の出力も含め、プログラミング、デバッグ、運用関連のコマンドを実行する際使用します。

### 1-2) ターミナルの起動方法

WindowsにInterSystems製品をインストールした場合は、タスクバー上に表示されたInterSystems製品のランチャーをクリックし「ターミナル」から起動します。

Windows以外にInterSystems製品をインストールした場合は、以下の iris または csession コマンドを利用して起動します。

なお、**コマンドの最後に指定している引数は、インストール時に設定する構成名（またはインスタンス名）** です。例では、インストール時のデフォルト名を指定していますので、環境に合わせて適宜ご変更ください。

インストール時に設定した構成名（インスタンス名）が不明な場合は、以下のコマンドで確認できます。

製品|コマンド
--|--
IRIS または IRIS for Helath | iris list
Caché または Ensemble| ccontrol list

Windows以外にInterSystems製品をインストールした場合のターミナルログイン時に使用するコマンドは以下の通りです。

製品|コマンド
--|--
IRIS | iris session IRIS
IRIS for Health | iris session IRISHealth
コンテナ|iris session IRIS
Caché| csession CACHE
Ensemble | csession ENSEMBLE

ターミナルを起動するとプロンプトに `USER>` と表示されますが、接続している仮想の作業環境名である「ネームスペース」の名称が表示されます。

> 「ネームスペース」について詳しくは、ビデオ：[【はじめての InterSystems IRIS】セルフラーニングビデオ：基本その2：InterSystems IRIS で開発をはじめよう！](https://jp.community.intersystems.com/node/478601) の 7分～ご紹介しています。

USERネームスペースはインストール時に作成されるネームスペースで、ターミナル起動時のデフォルトネームスペースに設定されています。


### 1-3) Hello World の出力

Hello World と出力したい場合、WRITEコマンドを利用します。

ターミナルを開き、以下のように記述することでターミナルに「Hello World」が出力されます。

```
write "Hello World"
```

ObjectScriptでは、文字列を操作する場合、文字列を二重引用符でくくる必要があります。

またコマンドは、大文字小文字を区別しないため、以下の記述でも同じ結果を得られます。

```
Write "Hello World"
```

実際の出力例は以下の通りです。
```
USER>write "Hello World"
Hello World
USER>
```
Hello Worldの出力結果の後、すぐに **USER>** のプロンプトが表示されています。見やすくするために改行を入れたい場合は、以下のように記述します。

```
USER>write "Hello World",!
Hello World
 
USER>write "Hello World",$char(13,10)
Hello World
 
USER>
```
WRITEコマンドの引数に **!** を指定すると改行が出力されます。

ちなみに、**$CHAR(13,10)** でも改行が出力されています。[$CHAR()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fchar)は引数に指定する整数をASCIIまたはUnicodeに変換する関数で、例では、CR+LF を指定しています。


## 2. ObjectScriptの記述ルール

### 2-1) ターミナルでのコマンドの書き方

ObjectScriptにはコマンドがあり、コマンドと引数の間は1つのスペースを記入します。

例えば、変数をセットして、設定した変数と文字列を出力したい場合の記述は以下の通りです（コマンドの引数が複数ある場合は、カンマで区切って指定できます）。

```
USER>set weather="曇り"
 
USER>write "今日の天気は",weather
今日の天気は曇り
USER>
```

### 2-2) ルーチンやメソッドに記述する場合のルール

ルーチンやメソッドにコマンドを記述する場合は、行の先頭にタブを入れてからコマンドを記述します。

行頭から記述できるのは、ラベル名でコマンドを書く場合は、必ずタブを入れてから記述します。

//はコメント文です。

以下、クラスメソッドの例
```
Class CookBook.Class1
{
ClassMethod Rule()
{
    //コマンドは先頭にタブを1つ入れてから記述します
    write "こんにちは",!
}
}
```
以下、ルーチンの例
```
Rule()  public {
    //先頭にタブを入れてからコマンドを書きます
    write "こんにちは",!
}
```

### 2-3) コメントの記述

1行のコメントは **//** または **;** や **#;** が利用できます。
複数行コメントは、 /* */ で囲います。

**#;** は、メソッドやルーチンコンパイル時に生成される中間コード（拡張子.int）に含まれないコメントとして記述できます（＝実行形式にも含まれません）。

ループ処理内に含めるコメントに **#;** を使用した場合、コメント行が省かれた状態で実行形式（拡張子.obj）が生成されるため、パフォーマンスの影響がない状態で実行できます。




### 2-4) クラスメソッドの実行方法

以下の文法でクラスメソッドを実行します。

**##class(パッケージ名.クラス名).メソッド名()**

戻り値を持たない場合は [DO コマンド](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cdo)を利用し、戻り値を変数にセットしたいときは [SET コマンド](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cset)で戻り値を変数に設定するように記述します。

バックグラウンドで実行する場合は [JOB コマンド](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cjob)を利用します。

#### - インスタンス生成方法

クラスのインスタンスの生成には、%New()メソッドを使用します（%New()もクラスメソッドです）。

**set 変数=##class(パッケージ名.クラス名).%New()**

実行予定のクラスで %New()メソッドが実行できるかどうかは、クラスリファレンスを使うと確認しやすいです。

使用中環境のクラスリファレンスのURLは以下の通りです（Webサーバ、ポート番号は環境に合わせて適宜ご変更ください）。

[http://localhost:52773/csp/documatic/%25CSP.Documatic.cls](http://localhost:52773/csp/documatic/%25CSP.Documatic.cls)

使い方は以下の通りです。

1. 左上部にネームスペース選択欄があるので、使用予定のクラスがあるネームスペースを選択します。
2. 画面左のパッケージリストから、使用予定のクラスのパッケージを選択します。
3. 画面右のクラスを確認し、%New()が「メソッド」の表内に存在するかどうか確認します。

操作が終わり、インスタンスを破棄したいときは、インスタンスを設定した変数を削除（Kill 変数）します。

### 2-5) ルーチン実行方法

以下の文法でルーチンを実行します。


戻り値を持たない場合は [DO コマンド](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cdo)を利用し、戻り値を変数にセットしたいときは [SET コマンド](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cset)で戻り値を変数に設定するように記述します。

バックグラウンドで実行する場合は [JOB コマンド](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cjob)を利用します。

- 戻り値がない場合

    **DO ラベル名^ルーチン名()** または **DO ラベル名^ルーチン名**

- 戻り値がある場合

    **SET 変数 = \$$ラベル名^ルーチン名()** または **SET 変数 = \$$ラベル名^ルーチン名**


## 3. 変数について

ObjectScriptには、**ローカル変数** と **グローバル変数** の2種類の変数があります。

- ローカル変数

    プロセス毎に管理される変数で、他プロセスからは参照・変更できない変数。

- グローバル変数

    ディスクに記録される変数で、複数プロセス間で共有される変数。最初の文字に **^** (サーカムフレックス）を付与することでグローバル変数としてディスクに記録される変数
    （管理ポータルの[システムエクスプローラー]>[グローバル]のメニューから参照できる変数）。

どちらの変数も操作方法は同じです。

また、ObjectScriptの変数は、型がない（動的で弱い型）ため、変数タイプを宣言する必要がありません。

型の概念はありませんが、内部的には数字か文字か、を認識しているため、計算時に注意が必要です。
詳細は、[ObjectScriptクックブック](/CookBook.md)の[注意点](/CookBook.md#注意点)をご参照ください。

### 3-1) 配列変数の作成

[SET](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cset)コマンドの後ろに作成したい配列を記述するだけです。（ローカル変数もグローバル変数もコマンド操作は同一です）

以下の例は、第1サブスクリプト（ノード）に 1～10 の数値を設定している例です。

（ _ は文字列結合の演算子です）

```
USER>for i=1:1:10 { set data(i)="これはテストデータです"_i }
 
USER>zwrite data
data(1)="これはテストデータです1"
data(2)="これはテストデータです2"
data(3)="これはテストデータです3"
data(4)="これはテストデータです4"
data(5)="これはテストデータです5"
data(6)="これはテストデータです6"
data(7)="これはテストデータです7"
data(8)="これはテストデータです8"
data(9)="これはテストデータです9"
data(10)="これはテストデータです10"
 
USER>
```
zwriteコマンドは配列の中身をすべて出力したり、インスタンスのプロパティをすべて表示できるコマンドで、ターミナルなどで利用できる便利コマンドです。

配列のサブスクリプト（ノード）は数字だけでなく文字を指定することもできます。また、サブスクリプトも1つだけでなく、カンマで区切り複数指定することもできます。

```
set Kion("東京","朝")=9
set Kion("東京","昼")=16
set Kion("大阪","朝")=12
set Kion("大阪","昼")=20
```

配列変数Kionのように複数のサブスクリプトを持つ変数も zwrite コマンドを利用して全階層を出力できます。

```
USER>zwrite Kion
Kion("大阪","昼")=20
Kion("大阪","朝")=12
Kion("東京","昼")=16
Kion("東京","朝")=9
 
USER>
```
zwrite の結果確認すると、配列の順序が設定した時と表示した時で違いがあることに気が付かれると思います。

ObjectScriptでは、配列のサブスクリプトは各レベルごとにUnicodeの昇順でソートされます。
上の例の配列変数Kionでは、東京や大阪が設定されている第1レベルでまずはソートされます。

第2レベルついては、第1レベルの "大阪" 以下にある、第2レベル "昼" "朝" の順でソートされます。

このように、ObjectScriptで設定する配列変数のサブスクリプトは、設定順に関係なく常にソートされた状態でアクセスできます。


### 3-2) 配列変数の参照

配列変数を参照する場合、サブスクリプトの情報を指定する必要があります。

例）大阪の昼の気温を参照したい場合

```
write Kion("大阪","昼")
```

### 3-3) 配列変数のサブスクリプトが不明な場合の参照方法

配列のサブスクリプトは、[$ORDER()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_forder)を利用して探すことができます。

$ORDER()関数は、「次のサブスクリプトを返す」関数です。

まずは、以下の配列変数を作成し、第1レベルのサブスクリプトを順番に$ORDER()で返す操作を試してみます。

```
set Kion("東京","朝")=9
set Kion("東京","昼")=16
set Kion("大阪","朝")=12
set Kion("大阪","昼")=20
```
$ORDER()関数は、調べたいサブスクリプトのレベルを決めます。最初の例は第1レベルで試します。
```
USER>write $ORDER(Kion(""))
大阪
USER>write $ORDER(Kion("大阪"))
東京
USER>write $ORDER(Kion("東京"))
 
USER>
```
*write $ORDER(Kion(""))* では、サブスクリプトに**空 ""** を指定しています。

サブスクリプトに**空 ""** を指定すると、Unicode の昇順で最初のサブスクリプトが返されます。

返された情報である「大阪」をサブスクリプトに指定して$ORDER()を実行すると、次のサブスクリプトの「東京」が返され、「東京」の後は、**空 ""** が返されました。

**空 ""** が返される＝そのレベルのサブスクリプトを最後まで検出した　の意味になります。

上記流れをFOR文を利用して順番にサブスクリプトを取得するように書くと以下のコードになります。

＜ルーチン・メソッドでの記述例＞
```
    set area=""
    for {
        set area=$ORDER(Kion(area))
        if area="" {
            quit
        }
        write area,!
    }
```
＜ターミナルで実行する場合の1行の例＞
```
set area="" for { set area=$ORDER(Kion(area)) if area="" {quit} write area,! }
```

第1レベルが確認できたら次は第2レベルを確認します。

これも同様に$ORDER()関数を利用しますが、第1レベルを特定した状態で第2レベルを$ORDER()で探すイメージとなります。

1コマンドずつ実行する例は以下の通りです。

```
USER>write $ORDER(Kion("大阪",""))
昼
USER>write $ORDER(Kion("大阪","昼"))
朝
USER>write $ORDER(Kion("大阪","朝"))
 
USER>write $ORDER(Kion("東京",""))
昼
USER>write $ORDER(Kion("東京","昼"))
朝
USER>write $ORDER(Kion("東京","朝"))
 
USER>
```

第1レベルも第2レベルも調べたい、という場合は、第1レベルを探すためのFOR文の中に、第2レベル用のFOR文を入れ子にして記述します。

＜ルーチン・メソッドでの記述例＞
```
    set area=""
    for {
        set area=$ORDER(Kion(area))
        if area="" {
            quit
        }
        write area,!
        set time=""
        for {
            set time=$ORDER(Kion(area,time))
            if time="" {
                quit
            }
            write "  ",time,!
        }
    }
```

例では、ローカル変数を使用していますがグローバル変数での操作方法は同様です。



### 3-4) 変数の削除

[KILL](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_ckill)コマンドを使用してローカル変数／グローバル変数を削除します。

テストでグローバル変数とローカル変数を設定します。
```
USER>set ^TestData="テストデータ"
 
USER>set localval="ローカル変数です"
```
まずは、WRITE文で出力してみましょう。
```
USER>write ^TestData
テストデータ
USER>write localval
ローカル変数です
```
KILLコマンドで変数を消去します。
```
USER>kill ^TestData

USER>kill localval
```
変数が削除されるため、WRITE文の結果は `<UNDEFINED>` です。

```
USER>write ^TestData
 
WRITE ^TestData
^
<UNDEFINED> ^TestData
USER>write localval
 
WRITE localval
^
<UNDEFINED> *localval
USER>
```

続いて、配列変数をグローバル変数とローカル変数で作成し、同様にKILLコマンドの実行を試します。

```
USER>zwrite localval
localval(1)="ローカル変数1"
localval(2)="ローカル変数2"
localval(3)="ローカル変数3"
localval(4)="ローカル変数4"
localval(5)="ローカル変数5"
 
USER>
 
USER>for i=1:1:5 { set ^TestData(i)="グローバル変数"_i }
 
USER>zwrite ^TestData
^TestData(1)="グローバル変数1"
^TestData(2)="グローバル変数2"
^TestData(3)="グローバル変数3"
^TestData(4)="グローバル変数4"
^TestData(5)="グローバル変数5"
```

配列変数を消去する場合、サブスクリプトが特定されている場合は、サブスクリプトを指定してKILLコマンドを実行します。

例えば、localval(3)だけを消したい場合
```
USER>kill localval(3)
 
USER>zwrite localval
localval(1)="ローカル変数1"
localval(2)="ローカル変数2"
localval(4)="ローカル変数4"
localval(5)="ローカル変数5"
```

例えば、^TestData(4)だけ消したい場合
```
USER>kill ^TestData(4)

USER>zwrite ^TestData
^TestData(1)="グローバル変数1"
^TestData(2)="グローバル変数2"
^TestData(3)="グローバル変数3"
^TestData(5)="グローバル変数5"
```
指定したサブスクリプトだけ、削除されていることがわかります。

では、サブスクリプトを指定しなかった場合はどうなるでしょうか。

```
USER>kill localval
 
USER>kill ^TestData
```
ZWRITEの結果は以下の通りです。
```
USER>zwrite localval
 
USER>zwrite ^TestData
 
USER>
```
全配列が削除されています。

KILLコマンドで配列を削除する場合、変数名の消去で全配列が削除されます（KILLの引数に指定した配列以下すべての情報が消去されます）

配列のグローバル変数を削除する場合、KILLコマンドで削除する配列に下位ノードが大量に含まれる場合もあり、大量のグローバル変数の消去につながることもあります。

誤って削除しないように、削除予定のグローバル変数をエクスポートしてから削除するなど、慎重に削除の操作を行っていただく必要があります。

グローバルのエクスポートは、管理ポータルから行えます。

管理ポータル > [システムエクスプローラ] > [グローバル] > （画面左でネームスペースを選択）> 一覧からエクスポート対象グローバルを選択 > エクスポートボタンクリック

- ドキュメント：[グローバルのエクスポート](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GGBL_managing#GGBL_managing_export)

グローバル変数の特定のノードに対するエクスポート方法については、以下トピックをご参照ください。
- [グローバル変数の特定ノードに対して、エクスポートはできますか？](https://faq.intersystems.co.jp/csp/faq/result.csp?DocNo=79)

## 4. コマンド

ObjectScriptのコマンドは大文字小文字を区別しません。[省略形](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_abbreviations)もありますが、例ではフルスペルでご紹介します。

### 4-1) メソッドやルーチンを実行する場合に使用するコマンド

メソッドやルーチンが戻りを持たない場合は、[DO](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cdo)コマンドを使用します。

ルーチンの場合は、以下の通りです。
```
ex1() public {
    write "戻り値がないルーチンです"
}
```
この場合は、**do ラベル名^ルーチン名()**　で実行できます。
```
do ex1^Routine1()
```
で実行できます。

メソッドの場合は以下の通りです。
```
ClassMethod ex1()
{
    write "戻り値のないメソッドです"
}
```
この場合は、`do ##class(パッケージ名.クラス名).メソッド名()` で実行できます。
```
do ##class(CookBook.Class1).ex1()
```

戻り値を持つ場合は、出力したい場合はWRITEコマンドで実行し、戻り値を変数に代入したい場合は、SETコマンドで設定します。

ルーチン例
```
ex2() public {
    write "こんにちは"
    return "戻り値が返るルーチンです"
}
```
戻り値のあるルーチンはユーザ定義関数として実行するため、ラベル名の前に$を2つ連続で指定する必要があります。 

**write \$$ラベル名^ルーチン名()**
```
write $$ex2^Routine1()
```

メソッドの場合は以下の通りです。
```
ClassMethod ex2() As %String
{
    write "こんにちは"
    return "戻り値が返るメソッドです"
}
```
実行例は以下の通りです。
```
write ##class(CookBook.Class1).ex2()
```

### 4-2) ループのコマンド

[FOR](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cfor)と[WHILE](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cwhile)が利用できます。

FORには引数指定もあり、開始値、増分値、終了値の指定ができます。順序は以下の通りです。

>for 変数=開始値:増分(減分)値:終了値 {}

1から3ずつ増分して10で終了するループは以下の通りです。

```
USER>for i=1:3:10 { write i,!}
1
4
7
10
```
10から2ずつ減分して4で終了するループは以下の通りです。
```
USER>for i=10:-2:4 { write i,!}
10
8
6
4
```
無限ループも記述できます。

ループを終了する場合は、if文で条件を指定し、[Quit](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cquit)でループを停止します。Quitのほかに、[Continue](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_ccontinue)もあり、Continueの場合は次のループに移動します。

以下、Quitでループを停止する例です。
```
ClassMethod ExForQuit()
{
    for i=1:1:5 {
        if i=3 {
            write "i=3の時ループを終了します",!
            quit
        }
        write i,!
    }
    write "終わり",!
}
```
実行例は以下の通り
```
USER>do ##class(CookBook.Class1).ExForQuit()
1
2
i=3の時ループを終了します
終わり
```

以下、Continueでループを次に移動する例です。
```
ClassMethod ExForContinue()
{
    for i=1:1:5 {
        if i=3 {
            write "i=3がきたら次のループに移動します",!
            continue
        }
        write i,!
    }
    write "終わり",!
}
```
実行例は以下の通りです。
```
USER>do ##class(CookBook.Class1).ExForContinue()
1
2
i=3がきたら次のループに移動します
4
5
終わり
```

Quitではなく、[Return](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_creturn)をFORの中で書いた場合は、メソッドやルーチンが終了します。
```
ClassMethod ExForReturn()
{
    for i=1:1:5 {
        if i=3 {
            write "i=3の時メソッド終了",!
            return
        }
        write i,!
    }
    write "終わり",!
}
```
実行例は以下の通りです。
```
USER>do ##class(CookBook.Class1).ExForReturn()
1
2
i=3の時メソッド終了
```

ご参考：[4-5) QUITとRETURNの違い](#4-5-quitとreturnの違い)

続いて[WHILE](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cwhile)についてです。

- 条件がTrueの場合コードを実行します。

    > while 条件 { コード }

- コードを実行し、条件がTrueの場合コードを実行します。

    > do { コード } while 条件 


### 4-3) プログラムの実行を終了するコマンドのQUIT

[QUIT](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cquit) は、プログラムの実行を終了する他にも、ループを終了するコマンドとしても利用できます。

ループを終了する場合は、引数を指定できません。詳細は、[4.2) ループのコマンド](#4-2-ループのコマンド)の実行例をご覧ください。

ターミナルでルーチンやメソッドをテスト実行する際、システムエラーが発生し、途中で終了してしまう場合、ターミナルプロンプトが以下のように変わります。

>実行例では、`<UNDEFINED>`エラーが途中で発生しています。

元のプロンプトに戻すためには、プログラムの終了を命令する**QUIT**コマンドを実行します。

```
USER>do ##class(CookBook.Class1).err()
 
    write abc }
    ^
<UNDEFINED>zerr+2^CookBook.Class1.1 *abc
USER 2d1>quit
 
USER>
```


### 4-4) プログラムの実行を終了するコマンドのRETURN

[RETURN](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_creturn)は、プログラムの実行を終了します。

WHILEやFORの中や、入れ子のループなど、任意の場所でRETURNを実行するとプログラムを終了できます（戻り値も指定できます）。

QUITとの違いは、[4-5) QUITとRETURNの違い](#4-5-quitとreturnの違い) をご覧ください。

### 4-5) QUITとRETURNの違い

[RETURN](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_creturn)はどこで実行しても「プログラムの実行を終了する」コマンドで、[QUIT](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cquit) はFORやWHILEの中で実行する場合、ループを終了するコマンドとして動作します（それ以外はプログラムの実行を終了します）。

記述例を利用して動作をご紹介します。
>ルーチンでもメソッドでも記述は同一ですが、以下の例はメソッドを使用しています。

QUITを利用した例です。
```
ClassMethod ExForQuit()
{
    for i=1:1:5 {
        if i=3 {
            write "i=3の時ループを終了します",!
            quit
        }
        write i,!
    }
    write "終わり",!
}
```
ループの中で、`write i,!` があるので、画面に i の値を順番に出力します。

i=3 の時、 `write "i=3の時ループを終了します",!` があるため、文字列を出力した後ループを終了し、ループの後ろに記述している ` write "終わり",!` が実行され、メソッド終了します。

実行結果を確認します。

```
USER>do ##class(CookBook.Class1).ExForQuit()
1
2
i=3の時ループを終了します
終わり
 
USER>
```

次に、QUITの場所にRETURNを記述した場合の例です。

```
ClassMethod ExForReturn()
{
    for i=1:1:5 {
        if i=3 {
            write "i=3の時メソッド終了",!
            return
        }
        write i,!
    }
    write "終わり",!
}
```

QUITの時と同様に、ループの中で、`write i,!` があるので、画面に i の値を順番に出力します。

i=3 の時、 `write "i=3の時メソッド終了",!` を出力した後RETURNがあるため、メソッドを終了しています。
そのため、ループの後にある ` write "終わり",!` は実行されていません。

実行結果を確認します。
```
USER>do ##class(CookBook.Class1).ExForReturn()
1
2
i=3の時メソッド終了
 
USER>
```


## 5. 引数の渡し方

ObjectScriptでは、値渡しと[参照渡し](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_usercode#GCOS_usercode_args_byref) で引数を渡すことができます。

また、最後の引数に対しては、可変数の引数を渡すこともできます。

### 5-1) 参照渡しの使い方

メソッドの引数定義では、**ByRef** マークを置くことで、「この引数は参照渡し」であることを指定できますが、ルーチンでは特にマーク付けはないため、コメントなどで参照渡しであることを記述したりします。

メソッドでもルーチンでも、参照渡しの引数を指定する場合、**引数前にピリオド . を付与**して指定します。

- メソッドでの記述例

    メソッドは、参照渡しの引数の定義前に**ByRef**のマークが付けられます。
    ```
    ClassMethod Parameter1(ByRef refVal As %String)
    {
        set refVal="新しい値に変更"
    }
    ```

    実行前、未設定だった変数の値が、参照渡しの引数を持つメソッド実行後、値が設定されていることを確認できます。
    ```
    USER>write p1
    
    WRITE p1
    ^
    <UNDEFINED> *p1
    USER>do ##class(CookBook.Class1).Parameter1(.p1)
    
    USER>write p1
    新しい値に変更
    ```

- ルーチンでの記述例

    メソッドと異なり、引数が参照渡しであるかどうかは、コードを読むまでわかりません（ByRefのマークが付けられないので、コードを読んで理解するかコメントを書くなど、開発者同士での工夫が必要です。）
    ```
    Parameter1(refVal) public {
        set refVal="新しい値に変更"
    }
    ```
    実行例は以下の通りです。
    ```
    USER>write p1
    
    WRITE p1
    ^
    <UNDEFINED> *p1
    USER>do Parameter1^Routine1(.p1)
    
    USER>write p1
    新しい値に変更
    ```

- その他の例：配列変数を作成して渡すこともできます。

    ※メソッドの記述例でご紹介します。
    ```
    ClassMethod Parameter2(ByRef data As %String)
    {
        zwrite data
    }
    ```

    実行結果：
    ```
    USER>for i=1:1:5 { set p1(i)="テスト"_i }
    
    USER>do ##class(CookBook.Class1).Parameter2(.p1)
    data(1)="テスト1"
    data(2)="テスト2"
    data(3)="テスト3"
    data(4)="テスト4"
    data(5)="テスト5"
    ```

### 5-2) 可変数の引数の使い方

ルーチンやメソッドの最後の引数に[可変数の引数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_usercode#GCOS_usercode_args_variable)を指定できます。

引数指定時、**引数名...** と記述します（引数の後にドットを3つ記述します）。

＜ルーチンの場合＞
```
valiable(a,b,c...) public {
  write "a=",a,!
  write "b=",b,!!
  write "*** c ***",!!
  zwrite c
}
```
実行結果は以下の通りです。
```
USER>do valiable^Routine1(1,2,3,4,5,6)
a=1
b=2
 
*** c ***
 
c=4
c(1)=3
c(2)=4
c(3)=5
c(4)=6
```

＜メソッドの場合＞
```
ClassMethod variable1(a As %String, b As %String, c... As %String)
{
  write "a=",a,!
  write "b=",b,!!
  write "*** c ***",!!
  zwrite c
}
```

実行結果は以下の通りです。
```
USER>do ##class(CookBook.Class1).variable1(1,2,3,4,5,6)
a=1
b=2
 
*** c ***
 
c=4
c(1)=3
c(2)=4
c(3)=5
c(4)=6
```

可変数の引数として指定した引数 c 直下には、指定した引数の個数が設定されます。

例えば、第3引数と第4引数を指定した場合、cには2が設定されます。

```
USER>do valiable^Routine1(1,2,3,4)
a=1
b=2
 
*** c ***
 
c=2
c(1)=3
c(2)=4
```

第3引数と第5引数に値を指定し、第4引数に値が指定されていなくても、引数としては3つ渡ることになります。

```
USER>do valiable^Routine1(1,2,3,,5)
a=1
b=2
 
*** c ***
 
c=3
c(1)=3
c(3)=5
```

可変数の引数の第1サブスクリプトには、指定された引数のポジション番号（1からスタート）が設定されます。

また、配列変数を用意して可変数の引数に値を渡すこともできます。

以下の例は、3つの引数を可変数の引数に渡しています（ルーチンもメソッドも同じ方法です）。

```
USER>set val(1)="あいうえお"
 
USER>set val(2)="かきくけこ"
 
USER>set val(3)="さしすせそ"
 
USER>set val=3

USER>do ##class(CookBook.Class1).variable1(1,2,val...)
a=1
b=2
 
*** c ***
 
c=3
c(1)="あいうえお"
c(2)="かきくけこ"
c(3)="さしすせそ"
```

※配列変数直下に引数の個数を指定する必要があります。

例えば、第3引数と第5引数を配列変数で渡す場合は、以下のように設定します。

```
USER>set val=3 // 全部で3つの引数があるので3を設定します
 
USER>set val(1)="第3引数"
 
USER>set val(3)="第5引数"
 
USER>do ##class(CookBook.Class1).variable1(1,2,val...)
a=1
b=2
 
*** c ***
 
c=3
c(1)="第3引数"
c(3)="第5引数"
```

## 6. TRUE／FALSEについて
ObjectScriptでは、以下の値をブーリアンのTRUE／FALSEとして解釈します。

- TRUE ：ゼロ以外の数値、または**ゼロ以外の数値に評価される数値文字列**　例）1、7、-0.007、"7-7"、"31th"

    ```
    USER>if 1 { write "これはTRUE" }
    これはTRUE
    USER>if 7 { write "これはTRUE" }
    これはTRUE
    USER>if -0.007 { write "これはTRUE" }
    これはTRUE
    USER>if "7-7" { write "これはTRUE" }
    これはTRUE
    USER>if "31th" { write "これはTRUE" }
    これはTRUE
    USER>
    ```

    **[ゼロ以外の数値に評価される数値文字列]** については以下の通りです。
    - すべて数字で構成される文字列
    - 数字で始まり、非数値の文字が続く文字列　（"3丁目"や"-12℃"など）

- FALSE ：ゼロの数値、またはゼロの数値に評価される文字列。例）0、-0.00、7-7、"0"、"TRUE"、"FALSE"、"No.3"

詳しくはドキュメントもご参照ください。
- [文字列から数値への変換](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_operators#GCOS_operators_str2num)
- [数値としての文字列](https://docs.intersystems.com/irisforhealthlastet/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_types#GCOS_types_nonnumasnum)

> ＜ご参考＞文字列であっても数値として評価したい場合は、文字列の前に + を付与することで評価できます。

ドキュメント： [単項プラス演算子 (+)](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_operators#GCOS_operators_unpos) をご参照ください。

```
USER>write "2022年10月22日"
2022年10月22日
USER>write +"2022年10月22日"
2022
USER>write +"令和4年10月22日"
0
```
## 7. メソッドやルーチンでSQLを実行する方法

メソッドやルーチン内でSQLを実行する場合、以下2種類の方法を選択できます。

- [埋め込みSQL](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GSQL_esql)：**&SQL()** 構文の括弧内にSQL文を記述する方法
- [ダイナミックSQL](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GSQL_dynsql)：[%SQL.Statement](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.Statement)クラスのインスタンスを生成してSQLをコンパイル・実行する方法

違いについては、ドキュメントの[「ダイナミックSQLと埋め込みSQL」](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GSQL_dynsql#GSQL_dynsql_vs_esql)をご参照ください。

メソッドやルーチン内でSQLを実行する場合、**DATE型やDATETIME型、TIME型は実行時に表示形式に変換されず内部値（論理モード）で実行されます。**

日付の内部値⇔表示形式の変換方法については詳しくは、[ObjectScript クックブック](/CookBook.md)の[メソッドやルーチンでSQLを実行する場合の日付の取り扱い](CookBook.md#メソッドやルーチンでsqlを実行する場合の日付の取り扱い)をご参照ください。

以下、埋め込みSQLとダイナミックSQLの基本の使い方について解説します。


### 7-1) 埋め込みSQL

実行したいSQLを **&SQL()** の括弧内に指定します。

例）
>&SQL(**任意のSQL文**)

SQLの実行が成功したか、失敗したかについては、変数 **SQLCODE** の値で確認できます。

- 変数**SQLCODE** < 0 のとき実行失敗。エラーメッセージは変数 **%msg** にセットされる
- 変数**SQLCODE** = 0 のとき行成功。埋め込みSQLでSELECTを実行している場合、FETCHで次の行が存在することを示す
- 変数**SQLCODE** = 100 のときはこれ以上行が存在しないことを示す

埋め込みSQLで実行するSQL文にObjectScriptの変数の値を入力引数として渡す場合や、実行したSELECTで指定したカラムの値をINTO節でObjectScriptの変数に出力するような[ホスト変数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GSQL_esql)の操作には、**:変数名** と記述します。


#### 例1) INSERTの実行：入力引数を指定する例

ルーチンやメソッドの中で埋め込みSQLを利用して[CookBook.Person](/CookBook/Person.cls)テーブルに1件データを追加します。

SQL文のVALUES()に指定する[ホスト変数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GSQL_esql)には、**:** を付与する必要があります。

>メモ：例文では、INSERT文に渡す誕生日の入力フォーマットは「YYYY-MM-DD」として記述しています。
```
ClassMethod INSERT1(name As %String, birthday As %String)
{
    set birthdayhorolog=$ZDATEH(birthday,3)  // 誕生日：YYYY-MM-DDを内部日付に変換
    &SQL(INSERT INTO CookBook.Person (Name,Birthday) VALUES(:name,:birthdayhorolog))
    if SQLCODE<0 {
        write "** SQLCODE：",SQLCODE,!
        write "** エラーメッセージ：",%msg,!
    }
    else {
        write "ID=",%ROWID,!
    }
}
```

エラーが発生していないときに出力している **[%ROWID](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GSQL_esql#GSQL_esql_pcROWID)** はINSERTで作成されたレコードのID番号（ROWID）を返します。

>複数行に影響を与える更新分を実行した場合、%ROWIDには最後に更新されたROWIDが設定されます。

実行結果は以下の通りです。

```
USER>do ##class(CookBook.Class1).INSERT1("楠太郎","1999-12-31")
ID=1
USER>
```

なお、サーバ側で実行するSQLでは、DATE型やDATETIME型、TIME型などのように内部値を持つ値に対し、自動的な変換は行っていません。

例では $ZDATEH()関数を使用して、表示形式から内部形式に変換したものをSQLに渡しています。

関数の使い方について詳しくは、[ObjectScript クックブック](/CookBook.md)の[日付の変換](CookBook.md#日付の表示変換)をご参照ください。


#### 例2) 1行のみ返るSELECTの実行：出力引数指定例

1行のみ返るSELECT文では、カーソルを利用せず直接SELECTの結果を確認できます。

SELECTで指定したカラム値は、INTO節を利用してホスト変数に代入されます（変数前にコロン **:** を付与する必要があります）。

```
ClassMethod SELECT0()
{
    &SQL(SELECT Birthday INTO :birthday FROM CookBook.Person WHERE ID=1)
    write "Birthdayの値＝",$SYSTEM.SQL.Functions.TOCHAR(birthday,"YYYY-MM-DD")
}
```
SELECTで取得したBirthdayカラムの値は、INTO節に設定した **:birthday** に設定されます。

※この例では、日付の表示変換に $SYSTEM.SQL.Functions.TOCHAR()メソッドを利用して内部値から表示形式を変換しています。利用方法詳細は[ObjectScript クックブック](/CookBook.md)の[%SYSTEM.SQL.FunctionsクラスにあるSQL関数を使用する](CookBook.md#--systemsqlfunctionsクラスにあるsql関数を使用する)をご参照ください。

実行結果は以下の通りです。

```
USER>do ##class(CookBook.Class1).SELECT0()
Birthdayの値＝1999-12-31
```

#### 例3) 複数行返るSELECTの実行

複数行返るSELECT文を実行する場合は、カーソルを使用します。

INTO節の中で使用するホスト変数は例2と同様です。

記述方法はメソッドもルーチンも同様です。

```
ClassMethod SELECTCursor()
{
    &SQL(DECLARE C1 CURSOR FOR 
        SELECT Name,Birthday INTO :name,:birthday FROM CookBook.Person)
    &SQL(OPEN C1)
    FOR {
        &SQL(FETCH C1)
        if SQLCODE'=0 {
            quit
        }
        write "名前：",name," 誕生日：",$ZDATE(birthday,3),!
    }
}
```
FETCH後、変数SQLCODEの値をチェックしています。SQLCODEはFETCHで行がなくなると100を返します。

0 は成功で 0未満は実行失敗のため、0以外が返ったらループを終了しています。

（以下実行例では、複数行返るように適当にデータを増やした状態で試しています）
```
USER>do ##class(CookBook.Class1).SELECTCursor()
名前：楠太郎 誕生日：1999-12-31
名前：テスト太郎 誕生日：1998-04-12
名前：鈴木次郎 誕生日：2010-05-22
```

【日付の変換方法についての参考情報】
- [ObjectScript クックブック](/CookBook.md)の[日付の変換](CookBook.md#日付の表示変換)
- [ObjectScript クックブック](/CookBook.md)の[%SYSTEM.SQL.FunctionsクラスにあるSQL関数を使用する](CookBook.md#--systemsqlfunctionsクラスにあるsql関数を使用する)
- [ObjectScript クックブック](/CookBook.md)の[埋め込みSQLの指示文を利用する](CookBook.md#--埋め込みsqlの指示文を利用する)

### 7-2) ダイナミックSQL

ダイナミックSQLでは、SQL実行のために[%SQL.Statement](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.Statement)クラスを使用します。

手順は以下の通りです。

>使用する変数名は任意名を使用できます。

1. [%SQL.Statement](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.Statement)のインスタンスを生成する。

    ```
    set statement=##class(%SQL.Statement).%New()
    ```

2. [%Prepare()](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.Statement#%25Prepare)メソッドで実行対象のSQLをコンパイルする。

    [%Prepare()](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.Statement#%25Prepare)メソッドの戻り値は %Status が設定されているので、戻り値を変数に設定します。

    実行するSQLに引数がある場合は、置き換え文字（プレースホルダ）として **?** を引数の場所に指定します。

    ```
    set status=statement.%Prepare("SELECT Name,Birthday FROM CookBook.Person WHERE ID<?")
    ```   

    [%Prepare()](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.Statement#%25Prepare)メソッドの実行でエラーが発生した場合は、%Statusのエラーが返るため、エラーが発生した場合の対応方法について詳しくは、[%Statusのエラーが戻ってきたら](CookBook.md#statusのエラーが戻ってきたら)をご参照ください。



3. [%Execute()](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.Statement#%25Execute)メソッドでSQL文を実行します。

    実行するSQLに引数がある場合は、置き換え文字（プレースホルダ） **?** の順序に合わせ %Execute()の引数に指定します。

    ```
    set rset=statement.%Execute(2)
    ```

    [%Execute()](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.Statement#%25Execute)メソッドは戻り値に [%SQL.StatementResult](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.StatementResult)のインスタンスが戻ります。

    エラーが発生した場合は、戻り値のインスタンス：[%SQL.StatementResult](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.StatementResult)の%SQLCODEプロパティと%Messageプロパティを確認します（エラーがない時は%SQLCODEプロパティは 0 が設定され、%Messageは何も設定されません）。

    ```
    write rset.%SQLCODE
    write rset.%Message
    ```
    SELECT文以外はここで終了です。


4. SELECTの結果を取得するため、インスタンス：[%SQL.StatementResult](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.StatementResult)の [%Next()](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.StatementResult#%25Next)を実行し行を移動します。行が存在すると1を返し、存在しないと0を返します。

    1コマンドずつ確認しながら進むと以下の通りです。
    
    行を移動します。
    ```
    write rset.%Next()
    ```
    1が返ったらカラムの情報が取得できるので、**%Get("カラム名")** メソッドか、**結果セットのインスタンス.カラム名** でアクセスします。

    ```
    write rset.%Get("Name") // SELECTに指定したNameの値を取得できます
    write rset.Birthday // SELECTに指定したBirthdayはプロパティ名としてもアクセスできます
    ```
    Birthdayの結果は内部日付（論理値）で戻るので、見やすくするため関数などを利用します。
    ```
    write $ZDATE(rset.Birthday,3)  //内部日付がYYYY-MM-DD形式に変換されます。
    ```
    【日付の変換方法についての参考情報】
    - [ObjectScript クックブック](/CookBook.md)の[日付の変換](CookBook.md#日付の表示変換)
    - [ObjectScript クックブック](/CookBook.md)の[%SYSTEM.SQL.FunctionsクラスにあるSQL関数を使用する](CookBook.md#--systemsqlfunctionsクラスにあるsql関数を使用する)
    - [ObjectScript クックブック](/CookBook.md)の[ダイナミックSQLの%SelectModeプロパティを利用する](CookBook.md#--ダイナミックsqlのselectmodeプロパティを利用する)

    カラムの値へのアクセスには、カラム番号を使用した方法もあります。
    詳細は、ドキュメントの[結果セットからの特定値の返送](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GSQL_dynsql#GSQL_dynsql_stmtresults_iterate)をご参照ください。


上記手順をメソッドで書いた例は以下の通りです（ルーチンでも同様の記述方法です）

```
ClassMethod DynamicSQLSELECT()
{
    #dim rset As %SQL.StatementResult
    set sql="SELECT Name,Birthday FROM CookBook.Person WHERE ID<?"
    set statement=##class(%SQL.Statement).%New()
    set status=statement.%Prepare(sql)

    //%Prepare()の結果がエラーステータスだった場合エラー情報を出力して終了
    if $SYSTEM.Status.IsError(status) {
        write $SYSTEM.Status.GetErrorText(status),!
        return
    }
    set rset=statement.%Execute(3)  // SQL文の引数を指定
    write "名前 - 誕生日",!
    while rset.%Next()
    {
        write rset.%Get("Name")," - ",$ZDATE(rset.Birthday,3),!
    }
}
```
検索結果は%Execute()の戻り値で返ってきます。戻ってきた結果セットのインスタンスを操作しやすくするため、メソッドの先頭で **#dim** を指定しています。#dim について詳しくは[ObjectScript クックブック](/CookBook.md)の[クラスメンバーの入力候補を出す方法](/CookBook.md#クラスメンバーの入力候補を出す方法)をご覧ください。


実行結果は以下の通りです。

```
USER>do ##class(CookBook.Class1).DynamicSQLSELECT()
名前 - 誕生日
楠太郎 - 1999-12-31
テスト太郎 - 1998-04-12
```


#### 例2) INSERT文の実行

更新文でカラムのタイプに合わない値を入れたため実行時にエラーが出た場合の例をご紹介します。

メソッドで書いた例は以下の通りです（ルーチンでも同様の記述方法です）

```
ClassMethod DynamicINVALIDINSERT() [ SqlProc ]
{
    #dim rset As %SQL.StatementResult
    set sql="INSERT INTO CookBook.Person (Name,Birthday) VALUES(?,?)"
    set statement=##class(%SQL.Statement).%New()
    set status=statement.%Prepare(sql)
    set rset=statement.%Execute("テスト太郎","不正な値")
    // エラーの場合 %SQLCODEプロパティは0より小さい値がセットされます
    if rset.%SQLCODE<0 {
        write "SQLエラーのコード：",rset.%SQLCODE,!
        write "SQLエラーのメッセージ：",rset.%Message,!
    }
}
```
実行結果は以下の通りです。

```
USER>do ##class(CookBook.Class1).DynamicINVALIDINSERT()
SQLエラーのコード：-104
SQLエラーのメッセージ：フィールド 'CookBook.Person.Birthday' (値 '不正な値') の妥当性検証が失敗しました
```



## ターミナルでSQLを実行する方法

ターミナルはObjectSriptを記述できるだけでなく、SQLシェルに切り替える事もできます。

```
do $SYSTEM.SQL.Shell()
```
を実行するか、バージョン2022.1以降であれば、`:sql` または `:s` でシェルに切り替えができます。

例では、以下のCREATE TABLE文を実行しています。

`CREATE TABLE CookBook.Employee (Name VARCHAR(50),DOB DATE)`

ターミナルをSQLシェルに切り替えて実行した例は以下の通りです。
```
USER>:sql
SQL Command Line Shell
----------------------------------------------------
 
The command prefix is currently set to: <<nothing>>.
Enter <command>, 'q' to quit, '?' for help.
[SQL]USER>>CREATE TABLE CookBook.Employee (Name VARCHAR(50),DOB DATE)
4.      CREATE TABLE CookBook.Employee (Name VARCHAR(50),DOB DATE)
 
0 Rows Affected
statement prepare time(s)/globals/cmds/disk: 0.0044s/1,980/13,903/0ms
          execute time(s)/globals/cmds/disk: 0.0991s/50,684/449,803/0ms
                          cached query class: %sqlcq.USER.cls21
---------------------------------------------------------------------------
[SQL]USER>>quit
 
USER>
```
シェルから普通のプロンプトに戻る場合は、`quit`を指定します。
