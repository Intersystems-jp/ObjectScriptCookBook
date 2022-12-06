# ObjectScriptでエラーが発生したら

ここでは、以下の内容を解説します。

- [ObjectScriptのエラー](#objectscriptのエラー)
- [システムエラーについて](#システムエラーについて)
- [プログラム実行中にエラーが発生した場合どうなるか](#プログラム実行中にエラーが発生した場合どうなるか)
- [エラーメッセージの読み方](#エラーメッセージの読み方)
- [TRY-CATCHブロックの書き方](#try-catchブロックの書き方)
- [例外の種類](#例外の種類)
- [例外に用意されているメソッド紹介](#例外に用意されている共通メソッド紹介)


## ObjectScriptのエラー
ObjectScriptのエラーには以下が存在します。
- [システムエラー](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RERR_system)
- [%Statusのタイプで表現するエラーステータス](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RERR_gen)
- SQLの実行が失敗したときの[SQLエラー](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RERR_sql)

ObjectScript のプログラム実行中に[システムエラー](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RERR_system)が発生した場合、処理は途中で停止します。

システムエラー以外のエラーは、対象の処理を実行した後、戻り値や参照渡しの引数にエラーステータスが返ってきたり、変数やプロパティにエラーコードやメッセージが設定されるため、処理が途中で停止することはありません。

%Statusのタイプのエラーが発生した場合の対応方法については、[ObjectScript クックブック](CookBook.md)の[%Statusのエラーが戻ってきたら](CookBook.md#statusのエラーが戻ってきたら)をご参照ください。

SQLエラーが発生した場合は、「[SQLエラーの例外](#--sqlエラーの例外exceptionsql)」の章を参照ください。

## システムエラーについて

以降の説明では、システムエラーが発生した場合の流れを解説します。

システムエラーは、`<UNDEFIND>` や `<CLASS DOSE NOT EXIST>` や `<INVALID OREF>` のようなエラーで、簡単にターミナルで発生させることができます。

以下例は、ターミナルで`<UNDEFINED>` や `<INVALID OREF>`を発生させたときの実行例です。

```
USER>kill  //プロセス内のローカル変数全消去
 
USER>write abc // (1)変数abcを出力→変数が存在しないので<UNDEFINED>エラー発生
 
WRITE abc
^
<UNDEFINED> *abc

USER>set abc=1  //(2) 変数に値セット
 
USER>write abc  //エラーなく出力成功
1
USER>write abc.Property  //(3) 変数abcにインスタンスがあるかのようなアクセス→エラー発生
 
WRITE abc.Property
^
<INVALID OREF>
```

(3)のエラーは、変数abcに1が設定されているにも関わらず、インスタンスが設定されているようなアクセスを行っています。

インスタンスが設定されてない変数に対して不正なアクセスを行ったため、`<INVALID OREF>` のエラーが発生します。
（OREF=Object Refereneceの略）


## プログラム実行中にエラーが発生した場合どうなるか

ルーチンやメソッドの中で[システムエラー](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RERR_system)が発生させるコードを記述します。

```
ClassMethod undeftest()
{
    set Test1="ローカル変数設定"
    write "UNDEFINEDエラーを発生させる例",!
    write abc,!
    write "おわり"
}
```

上記メソッドを実行すると、以下のようになります。
```
USER>do ##class(CookBook.Class1).undeftest()
UNDEFINEDエラーを発生させる例
 
    write abc,!
    ^
<UNDEFINED>zundeftest+3^CookBook.Class1.1 *abc
USER 2d1>
```
実行後、途中でエラーが発生して処理が停止しているため、プロンプトの表示が変わります。

この表示の時は処理途中の状態を維持しているので、メソッドやルーチンで使用しているプライベート変数の中身を確認したりできます。

```
USER 2d1>write
 
<Private variables>
Test1="ローカル変数設定"
USER 2d1>
```

プロンプトを元に戻すためには、プログラムの終了命令であるQUITを実行します。
```
USER 2d1>quit
 
USER>
```

## エラーメッセージの読み方

[プログラム実行中にエラーが発生した場合どうなるか](#プログラム実行中にエラーが発生した場合どうなるか) の例で発生したエラーメッセージを確認してみます。

```
USER>do ##class(CookBook.Class1).undeftest()
UNDEFINEDエラーを発生させる例
 
    write abc,!
    ^
<UNDEFINED>zundeftest+3^CookBook.Class1.1 *abc
USER 2d1>
```
エラーメッセージは以下のように分けて読んでみると、エラーが発生した場所の情報などを確認できます。

`<UNDEFINED>zundeftest+3^CookBook.Class1.1 *abc`

`<システムエラー>エラー発生箇所（ラベル名+行数^ルーチン名）*原因となった構文`

ObjectScriptのエラー発生個所の行数はコンパイル時に生成される拡張子INTのコードでの行数を指しています。

これは、メソッドやルーチン中に #dim など中間コードに生成されない構文やObjectScript以外の構文を記述できるため、コンパイル時に生成される中間コード（拡張子INTのコード）上でエラー発生個所の行数を表しています。

エラー発生行のコードを確認する場合は、**必ずソースコードの中間コードを開いた状態で確認してください。**

中間コードは、以下の方法で参照できます。
- スタジオの場合：ソースコードを表示した状態でスタジオのメニューバーにある 表示 > 他のコードを表示 をクリック
- VSCodeの場合：ソースコードを表示した状態で右クリック > View Other をクリック

なお、中間コードはコンパイル時に再作成されるものなので、コードを修正する場合は、元のメソッドやルーチンで修正してください。


## TRY-CATCHブロックの書き方

[Try-Catchブロック](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_errors)は、メソッドやルーチンで以下のように記述します。

```
    TRY {
        //(1) 通常時の処理
    } CATCH ErrorObject {
        //(2) エラー時の処理
    }
    //(3) その他の処理
```

- TRYブロックの中で「(1)通常時の処理」を記述します。処理の途中でシステムエラーが発生した場合、自動的に例外を生成しCATCHブロックへ例外をTHROWします。
- CATCHブロックでは`ErrorObject`の場所に例外オブジェクトを設定する任意の変数名を指定します。例外が渡されたときに「(2) エラー時の処理」を実行します。
- 「(3) その他の処理」は、以下実行後に実行されます。
    - 例外が発生しなかった場合、TRYブロックの「(1) 通常時の処理」を終了した後
    - 例外が発生した場合、CATCHブロック内でTHROWやGOTOコマンドを含まない「(2) エラー時の処理」を終了した後

予期しないエラーが発生し、例外がCATCHへスローされた後の処理は様々ですが、記述例として以下2例をご紹介します。

[(1) 戻り値を返して終了する](#1-戻り値を返して終了する)

[(2) 例外をCATCHしてくれるところにスローする](#2-例外をcatchしてくれるところにスローする)


### (1) 戻り値を返して終了する

処理の中でエラーの発生を予測できる場合、エラーを回避するコードを記述し途中で処理を終了させる場合もあります。

処理が正常であったか、異常であったかを戻り値で返す方法を選択される場合は、上記説明に登場する **(3) その他の処理** のコードを利用して戻り値を返すか、お好みの場所で **RETURN** を利用して戻り値を返します。

以下の説明では、**(3) その他の処理** のコードを利用して戻り値を返す例をご紹介します。

TRY-CATCHブロック内で、**(3) その他の処理** へ移動するには、**QUIT** を使用します。


例では、第2引数に0が渡された場合、0除算を避けるため戻り値にエラー情報となる文字列を設定しCATCHブロック以降の行へ制御を渡す流れが含まれます。

なお、例の中で戻り値に文字列を設定していますが、文字列以外であっても問題ありません。また戻り値を設定している変数も任意名の変数を使用できます。

```
ClassMethod Test1(p1 As %Integer, p2 As %Integer) As %String
{
    #dim ex As %Exception.AbstractException
    set retVal="OK"  // (a)戻り値に初期値設定
    TRY {
        // (b) 第2引数の値をチェックして異常値ならTRYブロックをQUITで終了
        if $GET(p2)=0 {
            set retVal="0は指定しないでください"  // (c)
            quit
        }
        write "割り算結果：",p1/p2,!   // (d)
    }
    CATCH ex {
        set retVal=ex.DisplayString()
    }
    quit retVal   // (e)
}
```

正常に終了する場合の実行結果は、(d)の割り算の結果が出力された後に、(e)の行が実行されるため、WRITE文の出力結果として「OK」が出力されています。この戻り値の「OK」は(a)の行で設定しています。
```
USER>write ##class(CookBook.Class1).Test1(4,2)
割り算結果：2
OK
USER>
```

第2引数に 0 を指定した場合は、(b)の If 文を通るため、(c)で戻り値用に使用している変数retValを更新し、(e)の行が実行されているため、WRITE文の出力結果として(c)で設定した文字列が出力されています。
```
USER>write ##class(CookBook.Class1).Test1(4,0)
0は指定しないでください
USER>
```

第1 引数を未指定で実行した場合は、(d)で「割り算の結果：」までを出力したところで `<UNDEFINED>`エラーが発生するため、例外を生成しCATCHへスローされ、CATCHブロックで変更した変数retValの値が(e)の実行で戻されます。
```
USER>write ##class(CookBook.Class1).Test1(,2)
割り算結果：<UNDEFINED> 9 zTest1+8^CookBook.Class1.1 p1
USER>
```

>戻り値を戻す方法としては、上記例のほかにRETURNも利用できます。RETURNを利用する場合は、上記例文と異なり実行した場所でルーチンやメソッドが終了します。


### (2) 例外をCATCHしてくれるところにスローする

[THROW](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cthrow)コマンドを利用することで、明示的に例外を次の例外ハンドラ（CATCH）へ渡せます。

例外がどこでCATCHされるかを2つの例を利用してご紹介します。

1. TRYブロックでTHROWを実行した場合

    ユーザ定義の例外を作成し、THROWコマンドで例外をスローさせる流れで動作をご紹介します。
    
    以下の例では、TRYブロックの下にあるCATCHブロックで例外がスローされるため、コメントの (1) (2) (3)の順序にWRITE文が出力されます。
    ```
    ClassMethod Test2()
    {
        TRY{
            write "TRYブロックです",!  // (1)
            set exception=##class(%Exception.General).%New("ユーザ作成の例外",5001,,"一般例外作成テスト")
            throw exception
            write "THROWの後",!  //実行されないコード
        }
        CATCH ex {
            write "CATCHブロックです",!  // (2)
            write "*** ",ex.DisplayString(),!  // (3)
        }
    }
    ```
    実行例は以下の通りです。
    ```
    USER>do ##class(CookBook.Class1).Test2()
    TRYブロックです
    CATCHブロックです
    *** ユーザ作成の例外 5001  一般例外作成テスト
    
    USER>
    ```

2. CATCHブロックでTHROWを実行した場合

    CATCHブロックでTHROWを実行すると、例外を次の例外ハンドラ（CATCH）へ渡せます。

    例文では、Call1()メソッドを作成し、TRYブロックの中で別のABC()メソッドを呼び出すようにしています。
    
    ABC()メソッドのTRYブロックでは 0 除算を行い、`<DIVIDE>`エラーを発生させています。また、CATCHブロック内でTHROWコマンドを利用して例外をスローしています。

    この場合、どの順序でWRITE文が出力されるか実行例を見ながら確認します。

    ```
    ClassMethod Call1()
    {
        TRY{
            write "Call1のTRYブロック",!  // (1)
            do ..ABC()
        }
        CATCH ex {
            write "Call1の中のCATCHブロック",!  //(5)
            write "Call1で例外の中身を表示：",ex.DisplayString(),!  // (6)
        }
    }

    ClassMethod ABC()
    {
        TRY{
            write "ABC()のTRYブロックです",!  // (2)
            write 1/0 // DIVIDEエラー
        }
        CATCH ex {
            write "ABC()のCATCHブロックです",!  // (3)
            write "*** ",ex.DisplayString(),!  // (4)
            throw ex
            write "ABC()のTHROWの後です",! //実行されないコード
        }
    }
    ```
    実行結果は以下の通りです。コード例にあるWRITE文のコメントにある順番通りに出力されていることがわかります。

    ```
    USER>do ##class(CookBook.Class1).Call1()
    Call1のTRYブロック
    ABC()のTRYブロックです
    ABC()のCATCHブロックです
    *** <DIVIDE> 18 zABC+3^CookBook.Class1.1
    Call1の中のCATCHブロック
    Call1で例外の中身を表示：<DIVIDE> 18 zABC+3^CookBook.Class1.1
    
    USER>
    ```
    ABC()メソッド内でTHROWされた例外は、Call1()のCATCHで捉えられていることが確認できました。

    次に、Call1()メソッドからCall2()メソッドを呼び出し、Call2()メソッドからABC()メソッドを呼び出す流れに変えて実行してみます。

    1つ前の例と異なる点は、Call2()メソッドでは、TRY-CATCHブロックを使用していない点です。
    
    この場合、ABC()のCATCHブロックでスローした例外はどうなるでしょうか。

    ```
    ClassMethod Call1()
    {
        TRY{
            write "Call1のTRYブロック",!  // (1)
            do ..Call2()
        }
        CATCH ex {
            write "Call1の中のCATCHブロック",!  // (5)
            write "Call1で例外の中身を表示：",ex.DisplayString(),!  //(6)
        }
    }

    ClassMethod Call2()
    {
        do ..ABC()
        write "Call2でABC()実行後",! // ★
    }

    ClassMethod ABC()
    {
        TRY{
            write "ABC()のTRYブロックです",!  // (2)
            write 1/0 // DIVIDEエラー
        }
        CATCH ex {
            write "ABC()のCATCHブロックです",!  // (3)
            write "*** ",ex.DisplayString(),!  // (4)
            throw ex
            write "ABC()のTHROWの後です",! //実行されないコード
        }
    }
    ```    

    実行結果は以下の通りで、1つ前の例と同じ順序でWRITE文が出力されていることがわかります。

    また、Call2()の (★) のWRITE文は出力されていないことがわかります。

    ```
    USER>do ##class(CookBook.Class1).Call1()
    Call1のTRYブロック
    ABC()のTRYブロックです
    ABC()のCATCHブロックです
    *** <DIVIDE> 18 zABC+3^CookBook.Class1.1
    Call1の中のCATCHブロック
    Call1で例外の中身を表示：<DIVIDE> 18 zABC+3^CookBook.Class1.1
    
    USER>
    ```

    Call2()の呼び出し先であるABC()メソッド内で例外をスローしていますが、Call2()には例外を捉えるためのCATCHブロックがないため捉えることができず、Call1()のCATCHブロックで例外が捉えられていることがわかります。


## 例外の種類

ObjectScriptの例外は4種類あります。

- ObjectScriptの[システムエラー](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RERR_system)用の例外：[%Exception.SystemException](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.SystemException)

- %Statusの例外：[%Exception.StatusException](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.StatusException)

- SQLエラーの例外：[%Exception.SQL](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.SQL)

- ユーザ定義の例外：[%Exception.General](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.General)

> この説明には含めていません、Embedded Python 利用時に発生する[%Exception.PythonException](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.PythonException)もあります。



### - システムエラーの例外：[%Exception.SystemException](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.SystemException)

ObjectScriptの[システムエラー](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RERR_system)は、`<UNDEFIND>` や `<CLASS DOSE NOT EXIST>` や `<INVALID OREF>` のようなエラーで、プログラム途中で発生すると処理が途中で停止します。

システムエラーの例外：[%Exception.SystemException](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.SystemException)は、ObjectScriptのTRY-CATCHブロックの中でシステムエラーが発生したとき自動的に生成され、スローされます。


### - %Statusの例外：[%Exception.StatusException](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.StatusException)

システム提供クラスのメソッドの戻り値に、よく[%Status](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Library.Status)のタイプが使用されています。


処理が成功したときは 1 を返します。失敗したときは、ステータスを戻り値や参照渡しの引数として戻すため、例外は発生しません。

エラーステータスであるかどうか、またエラーの内容を確認する方法やエラーを変数に設定したり、文字列として取得する方法などについては、[ObjectScript クックブック](CookBook.md)の[%Statusのエラーが戻ってきたら](CookBook.md#statusのエラーが戻ってきたら)をご参照ください。

以降の説明では、%Status 由来の例外を作成し、スローさせる方法を解説します。

%Statusの例外は、[%Exception.StatusException](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.StatusException) クラスの [CreateFromStatus()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.StatusException#CreateFromStatus) を使用し、引数にエラーステータスを指定して作成します。

記述例）
```
THROW ##class(%Exception.StatusException).CreateFromStatus(ステータス)
```

[CookBook.Person](/CookBook/Person.cls)クラスのインスタンスを生成し、Bitrhdayプロパティに不正な値設定し、%Save()でインスタンスを保存したとき発生するエラーステータスを利用して手順を解説します。

例ではクラスメソッドを使用していますが、記述内容についてはルーチンも同様です。

```
ClassMethod StatusError()
{
    TRY{
        set p=##class(CookBook.Person).%New()
        set p.Birthday="不正な値"
        set status=p.%Save()
        // (1)エラーステータスであるかどうかの確認
        if $SYSTEM.Status.IsError(status){
            throw ##class(%Exception.StatusException).CreateFromStatus(status)
        }
        write "TRYブロック最終行",!
    }
    CATCH ex {
        write "CATCHブロックです",!
        write ex.DisplayString(),!
    }
}
```
(1)の下にあるIf文では、エラーステータスの場合に%Statusの例外を生成し、スローしています。

実行結果で確認します。
```
USER>do ##class(CookBook.Class1).StatusError()
CATCHブロックです
エラー #7207: データタイプ値 '不正な値' は妥当な数値ではありません
  > エラー #5802: プロパティ 'CookBook.Person:Birthday' のデータタイプ妥当性検証が失敗しました。値は "不正な値" です。
 
USER>
```
スローされた例外がCATCHブロックで捉えられ、CATCHブロック内のWRITE文が実行されていることがわかります。

なお、%Statusの例外を生成しスローする流れは、専用のマクロを利用しても実行できます。詳細は後述の[便利なマクロ](#便利なマクロ)をご参照ください。

### - SQLエラーの例外：[%Exception.SQL](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.SQL)

サーバ側処理でSQLを実行したときに発生する[SQLのエラー](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RERR_sql)は、ステータスを変数やプロパティに設定します。そのため、例外は発生しません。

記述方法|エラーコード|エラーメッセージ|参考情報
--|--|--|--|
[埋め込みSQL](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GSQL_esql)|変数 **SQLCODE**|変数 **%msg**|[7-2)埋め込みSQL](Basic.md#7-1-埋め込みsql)／[埋め込みSQL実行時のエラーをストアド呼び出し元に返したい](CookBook.md#--埋め込みsql実行時のエラーをストアド呼び出し元に返したい)|
[ダイナミックSQL](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GSQL_dynsql)：%Prepare()の結果|エラーステータスからコードを作成|エラーステータスからメッセージを作成|[7-2)ダイナミックSQL](/Basic.md#7-2-ダイナミックsql)／[ダイナミックSQLのエラーをストアド呼び出し元に返したい](CookBook.md#--ダイナミックsqlのエラーをストアド呼び出し元に返したい)
[ダイナミックSQL](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GSQL_dynsql)：%Execute()の結果|結果セット（[%SQL.StatementResult](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.StatementResult)）のインスタンスの%SQLCODEプロパティ|結果セット（[%SQL.StatementResult](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.StatementResult)）のインスタンスの%Messageプロパティ|[7-2)ダイナミックSQL](/Basic.md#7-2-ダイナミックsql)／[ダイナミックSQLのエラーをストアド呼び出し元に返したい](CookBook.md#--ダイナミックsqlのエラーをストアド呼び出し元に返したい)



メソッドやルーチン内でSQLエラーが発生した場合、構文ごとのエラーコードとメッセージの取得方法については、[ObjectScriptの基本のき！](/Basic.md)の[7. メソッドやルーチンでSQLを実行する方法](Basic.md#7-メソッドやルーチンでsqlを実行する方法)をご参照ください。

以降の説明では、SQLエラーだった場合に、SQLエラー由来の例外を作成し、スローさせる方法を解説します。


#### 例1）埋め込みSQLの場合

以下の例では、埋め込みSQLを利用して、[CookBook.Person](/CookBook/Person.cls)テーブルのBirthdayカラムに不正な値を設定したときに発生するSQLコードとエラーメッセージから、SQLエラーの例外：[%Exception.SQL](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.SQL)を生成しスローする流れを記述しています。


例）

`THROW ##class(%Exception.SQL).CreateFromSQLCODE(SQLエラー,メッセージ)`


以下の例では、埋め込みSQLを利用して、[CookBook.Person](/CookBook/Person.cls)テーブルのBirthdayカラムに不正な値を設定したときに発生するSQLコードとエラーから、例外を生成し、スローする流れを記述しています。

埋め込みSQLでエラーが発生すると、変数SQLCODE が0未満で、変数 %msg にエラーメッセージが設定されます。

例ではクラスメソッドを使用していますが、記述内容についてはルーチンも同様です。
```
ClassMethod SQLerror2()
{
    TRY{
        &SQL(INSERT INTO CookBook.Person (Name,Birthday) VALUES('テスト従業員','誕生日ではない情報を設定'))
        //(1) エラーかどうかの確認
        if SQLCODE<0 {
            throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
        }
        write "TRYブロック最終行",!
    }
    CATCH ex {
        write "CATCHブロックです",!
        write ex.DisplayString(),!
    }
}
```
(1)の下にあるIf文では、SQLエラーの場合にSQLエラーとメッセージから例外を生成し、スローしています。

実行結果で確認します。
```
USER>do ##class(CookBook.Class1).SQLerror2()
CATCHブロックです
-104 -104  フィールド 'CookBook.Person.Birthday' (値 '誕生日ではない情報を設定')の妥当性検証が失敗しました
 
USER>
```

スローされた例外がCATCHブロックで捉えられ、CATCHブロック内のWRITE文が実行されていることがわかります。

#### 例2）ダイナミックSQLの場合

[%SQL.Statement](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.Statement)クラスの[%Prepare()](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.Statement#%25Prepare)メソッドの実行でエラーが発生した場合は、%Statusのエラーが返るため、例外を生成しスローする場合の流れは[%Statusの例外：%Exception.StatusException](#--statusの例外exceptionstatusexception)の流れと共通です。


[%Execute()](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.Statement#%25Execute)メソッド実行時にエラーが発生した場合は、戻り値に [%SQL.StatementResult](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.StatementResult)のインスタンスが戻り、インスタンスに含まれる%SQLCODEプロパティと、%Messageプロパティから、SQLエラーの例外：[%Exception.SQL](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.SQL)を生成しスローできます。

例）

`THROW ##class(%Exception.SQL).CreateFromSQLCODE(%SQLCODEプロパティ,%Messageプロパティ)`

以下の例では、ダイナミックSQLを利用して、[CookBook.Person](/CookBook/Person.cls)テーブルのBirthdayカラムに不正な値を設定したときに発生するSQLエラーから、例外を生成し、スローする流れを記述しています。

%Execute()メソッド実行後に戻るインスタンスの%SQLCODEプロパティの値が0未満のときエラーが発生しています。

例ではクラスメソッドを使用していますが、記述内容についてはルーチンも同様です。

記述例は以下の通りです。
```
ClassMethod SQLError4() [ SqlProc ]
{
    #dim rset As %SQL.StatementResult
    TRY{
        set sql="INSERT INTO CookBook.Person (Name,Birthday) VALUES(?,?)"
        set statement=##class(%SQL.Statement).%New()
        set status=statement.%Prepare(sql)
        set rset=statement.%Execute("テスト太郎","不正な値")
        //(1)　エラーかどうかの確認
        if rset.%SQLCODE<0 {
            throw ##class(%Exception.SQL).CreateFromSQLCODE(rset.%SQLCODE,rset.%Message)
        }
        write "TRYブロック最終行",!       
    }
    CATCH ex {
        write "CATCHブロックです",!
        write ex.DisplayString(),!
    }
}
```

(1)の下にあるIf文では、SQLエラーの場合にSQLエラーとメッセージから例外を生成し、スローしています。

実行結果で確認します。

```
USER>do ##class(CookBook.Class1).SQLError4()
CATCHブロックです
-104 -104  フィールド 'CookBook.Person.Birthday' (値 '不正な値') の妥当性検証が失敗しました
 
USER>
```

スローされた例外がCATCHブロックで捉えられ、CATCHブロック内のWRITE文が実行されていることがわかります。


### - ユーザ定義エラーの例外

ユーザ定義の例外：[%Exception.General](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.General)は、任意の文字列で例外を生成できます。

例外を生成し、CATCHへスローする方法は以下の通りです。

```
THROW ##class(%Exception.General).%New(例外の名前,コード,エラー発生場所,説明)
```
記述例は以下の通りです。
```
ClassMethod GeneralError()
{
    TRY{
        write "TRYブロックです",!
        set exception=##class(%Exception.General).%New("ユーザ作成の例外",5001,,"一般例外作成テスト")
        throw exception
        write "THROWの後",!  //出力されないコード
    }
    CATCH ex {
        write "CATCHブロックです",!
        write "*** ",ex.DisplayString(),!
    }
}
```
実行例は以下の通りです。
```
USER>do ##class(CookBook.Class1).GeneralError()
TRYブロックです
CATCHブロックです
*** ユーザ作成の例外 5001  一般例外作成テスト
 
USER>
```

## 便利なマクロ

%Statusでエラーステータスが発生した場合に、例外を生成しCATCHへスローさせる便利なマクロや、エラーステータスであるかどうかを確認できるマクロについてご紹介します。


### - [$$$ThrowOnError](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_errors#GCOS_errors_ttc_macros)

このマクロは、%Statusで返った結果を確認し、エラーステータスの場合は%Statusの例外：[%Exception.StatusException](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.StatusException)を作成し、Catchブロックへ[Throw](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cthrow)します。

> `$$$ThrowOnError(%Statusの結果)`

```
ClassMethod savetest2()
{
    Try {
        set person=..%New()
        set person.Birthday="データタイプに合わない値"
        set st=person.%Save()
        $$$ThrowOnError(st)
    }
    catch ex {
        write "CATCHに移動",!
        write ex.DisplayString(),!
    }
}
```
このメソッドの実行結果は以下の通りです。
```
USER>do ##class(CookBook.Class1).savetest2()
CATCHに移動
エラー #7207: データタイプ値 'データタイプに合わない値' は妥当な数値ではありません
  > エラー #5802: プロパティ 'CookBook.Person:Birthday' のデータタイプ妥当性検証が失敗しました。値は "データタイプに合わない値" です。

USER>
```
例外がスローされ、処理がCATCHに移動したことを確認できました。

### - $$$THROWONERROR（スタジオに出てくる入力候補）

このマクロは、IDEにスタジオを利用している場合に入力候補として登場します。

マクロは大文字小文字を区別します。このマクロを利用する場合は全部大文字で記述してください。

マクロの実行内容は、[$$$ThrowOnError](#--throwonerror)と一緒ですが、引数が異なります。

> `$$$THROWONERROR(例外用変数,エラーステータス)`

```
ClassMethod savetest3()
{
    Try {
        set person=##class(CookBook.Person).%New()  // CookBook.Personクラスのインスタンス生成
        set person.Birthday="データタイプに合わない値"
        set st=person.%Save()
        $$$THROWONERROR(ex,st)
    }
    catch ex {
        write "CATCHに移動",!
        write ex.DisplayString(),!
    }
}
```
```
USER>do ##class(CookBook.Class1).savetest3()
CATCHに移動
エラー #7207: データタイプ値 'データタイプに合わない値' は妥当な数値ではありません
  > エラー #5802: プロパティ 'CookBook.Person:Birthday' のデータタイプ妥当性検証が失敗しました。値は "データタイプに合わない値" です。
 
USER>
```
`$$$ThrowOnError()`と処理は一緒なので、どちらを使っても同じ結果が得られます。

### - エラーステータスを評価できるその他のマクロ

`$$$ThrowOnError`や`$$$THROWONERROR`の他に以下のマクロもあります。

ステータスを評価するマクロは、クラス定義を作成すると自動的にインクルードされますが、**ルーチンを使用する場合は、%occStatusインクルードルーチンを#includeでインクルードする必要があります。**

> #include %occStatus


- `$$$ISOK` ：ステータスがOKかどう確認し、OKなら1を返し、エラーなら0を返す
- `$$$ISERR` : ステータスがエラーの場合1を返し、OKなら0を返す。

この他には[ドキュメント:システムにより提供されるマクロのリファレンス](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_macros#GCOS_macros_syssuppliedlist)をご参照ください。


## 例外に用意されている共通メソッド紹介

全例外は、[%Exception.AbstractException](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.AbstractException)クラスのサブクラスです。

CATCHブロック内で使用できるメソッドやプロパティについて詳細はは、[%Exception.AbstractException](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.AbstractException)クラスのクラスリファレンスをご覧ください。

メソッド／プロパティ名|内容|
--|--|
DisplayString()|例外を文字列で返します。|
Log()|例外をアプリケーションエラーログに登録します。|
AsStatus()|例外からエラーステータスを作成し戻します。|
AsSQLCODE()|例外からSQLエラーを作成し戻します。|
AsSQLMessage()|例外からSQLメッセージを作成し戻します。|
Nameプロパティ|エラー名を取得できます。|
Codeプロパティ|エラーコードを取得できます。|
Locationプロパティ|エラー発生場所を取得できます。|
Dataプロパティ|例外に追加情報がある場合取得できます。|
%ClassName(1)|例外のクラス名のフルネームを取得できます（$CLASSNAME(例外)メソッドを使用しても取得できます）。|
