# ObjectScript クックブック

クックブックでは、ObjectScriptでプログラミングを行う際に「こんなときはどうするの？」の疑問が解消できるような具体的なサンプルを中心に使用方法をご紹介します。

もし、知りたい内容が掲載されていない場合は、ぜひ[開発者コミュニティ](https://jp.community.intersystems.com)へご質問ください！いただいた質問の回答は、[ObjectScript クックブック](CookBook.md) に追加させていただきます！

クックブックでご紹介する内容は以下の通りです。

- [文字列操作](#文字列操作)
- [演算子](#演算子)
- [注意点](#注意点)
- [現在日付と時刻の取得](#現在日付と時刻の取得)
- [日付時刻の変換](#日付の表示変換)
- [実行時間を計測したい](#実行時間を計測したい)
- [リスト](#リスト)
- [変数や引数の存在チェック](#変数や引数の存在チェック)
- [プロセス単位で一意となるデータを作りたい](#プロセス単位で一意となるデータを作りたい)
- [ファイルの入出力](#ファイルの入出力)
- [HTTPのGET要求を実行したい](#httpのget要求を実行したい)
- [HTTPのPOST要求を実行したい](#httpのpost要求を実行したい)
- [HTTP要求時の認証](#http要求時の認証の指定)
- [FTPサーバにPUT／GET／DELETEしたい](#ftpサーバにputgetdeleteしたい)
- [メールの送受信](#メールの送受信)
- [%Statusのエラーが返ってきたら](#statusのエラーが戻ってきたら)
- [ストアドプロシージャの呼び出し元に正しくエラーを返したい](#ストアドプロシージャの呼び出し元に正しくエラーを返したい)
- [クラスメンバーの入力候補を出す方法](#クラスメンバーの入力候補を出す方法)
- [メソッドやルーチンでSQLを実行する場合の日付の取り扱い](#メソッドやルーチンでsqlを実行する場合の日付の取り扱い)


## 文字列操作

### 文字列結合

アンダースコア（_）を使います。

```
set a="今日の天気は"
set b="晴れ"
set c=a_b
write c
//以下出力結果
今日の天気は晴れ
```

### 文字列の置換
    
[$REPLACE()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_freplace)を使用します。

> $repace(文字列,検索文字,置換文字,検索開始位置,置換回数,大小文字を区別する:1／しない:0)

第4引数以降はオプション指定です。

#### - 例1：文字列の置換
```
USER>set weather="今日の天気は快晴です。明日の天気は曇りです"

USER>write $REPLACE(weather,"天気","予報")
今日の予報は快晴です。明日の予報は曇りです
```

改行をスペースに変換する例

*※改行は $CHAR(13,10)で指定できます。*

```
USER>write moji
あいうえお
かきくけこ
さしすせそ
USER>
 
USER>write $REPLACE(moji,$c(13,10)," ")
あいうえお かきくけこ さしすせそ
```

#### - 例2：文字列の指定位置から置換を開始し、指定位置以降の文字を返す

第4引数は検索を開始する位置を指定します（最初の文字の位置は 1 から始まります）。

$REPLACE()の結果は、指定した位置以降の置換後の文字列を返します。

```
USER>set weather="今日の天気は快晴です。明日の天気は曇りです"
 
USER>write $REPLACE(weather,"天気","予報",12)
明日の予報は曇りです
```

#### - 例3：置換回数の指定

第5引数を指定します。デフォルトでは、一致する文字を全部置換します。

以下の例では、置換文字候補は2回出現しますが第5引数に1を指定したため、最初に出現した文字のみを置換しています。

```
USER>set weather="今日の天気は快晴です。明日の天気は曇りです"

USER>write $REPLACE(weather,"天気","予報",,1)
今日の予報は快晴です。明日の天気は曇りです
```

#### - 例4：大小文字を区別して置換文字する

第6引数を指定します。デフォルトでは 1 が指定され大小文字を区別しません。

```
USER>write $REPLACE("AppleBanana","banana","バナナ",,,1)
Appleバナナ
USER>write $REPLACE("AppleBanana","banana","バナナ",,,0)
AppleBanana
```


### - 文字の長さを取得する

[$LENGTH()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_flength)を使います。

```
USER>set moji="あいうえお"

USER>write $LENGTH(moji)
5
```

区切りマーク付き文字列の場合、$LENGTH()の第2に引数に区切り文字を指定することで、区切り数を取得できます。

```
USER>write $LENGTH(moji,"-")
5
```


### - 区切りマーク付き文字列から文字を抽出／設定する

[$PIECE()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fpiece) を利用します。

> $PIECE(文字列,区切りマーク,位置(from),位置(to))

```
USER>set moji="160-0023,東京都,新宿区,西新宿,6-10-1,日土地西新宿ビル15F"

USER>write $PIECE(moji,1)

USER>write $PIECE(moji,",",1)
160-0023
USER>write $PIECE(moji,",",2)
東京都
USER>write $PIECE(moji,",",3,5)
新宿区,西新宿,6-10-1
```

### - 区切り数の不明な区切りマーク付き文字列を順番に操作したい場合

[FOR](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cfor)と[$LENGTH()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_flength)と[$PIECE()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fpiece)を利用します。

ターミナルでの実行例は以下の通りです。
```
USER>set moji="160-0023,東京都,新宿区,西新宿,6-10-1,日土地西新宿ビル15F"

USER>for i=1:1:$LENGTH(moji,",") { write $PIECE(moji,",",i),! }
160-0023
東京都
新宿区
西新宿
6-10-1
日土地西新宿ビル15F
```

ルーチン・メソッドの記述例は以下の通りです。
```
    set moji="160-0023,東京都,新宿区,西新宿,6-10-1,日土地西新宿ビル15F"
    for i=1:1:$LENGTH(moji,",") {
        write $PIECE(moji,",",i),!
    }
```

区切りマーク付き文字列を順番に取得し、配列変数に設定する、ルーチン・メソッドの記述例は以下の通りです。
```
    set moji="160-0023,東京都,新宿区,西新宿,6-10-1,日土地西新宿ビル15F"
    for i=1:1:$LENGTH(moji,",") {
        //write $PIECE(moji,",",i),!
        set address(i)=$PIECE(moji,",",i)
    }
    zwrite address
```
実行結果は以下の通りです。
```
USER>do ##class(CookBook.Class1).Moji1()
address(1)="160-0023"
address(2)="東京都"
address(3)="新宿区"
address(4)="西新宿"
address(5)="6-10-1"
address(6)="日土地西新宿ビル15F"
```

[$LENGTH()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_flength)は、第1引数に指定した文字列の文字数を返す関数ですが、第2引数に区切りマークを指定することで、第1引数に指定した文字列が第2引数で指定する区切りマークでいくつに区切られているか数えることができます。

> $LENGTH(文字列,区切りマーク)

第2引数の区切りマークは任意の文字列を指定できます。
```
USER>write $LENGTH("赤;青;黄色",";")
3
```

    
### - 文字列の指定位置の抽出や部分設定を行う

[$EXTRACT()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fextract) を使用します。

指定位置から文字の最後まで抽出したい場合は、以下のように記述します。

指定位置の情報を取得する例
```
USER>set color="赤青黄紫白黒"

USER>write $EXTRACT(color,2)
青
```
指定範囲の情報を取得する例

```
USER>set color="赤青黄紫白黒"

USER>write $EXTRACT(color,2,3)
青黄
```

部分設定する場合は、SET文を利用します。

文字列の3番目に来る文字の「黄」を「yellow」に設定する例は以下の通りです。

```
USER>set $EXTRACT(color,3)="yellow"

USER>write color
赤青yellow紫白黒
```

指定範囲（例では2番目～8番目に来る文字列）に、任意文字を設定する例は以下の通りです。
```
USER>write $EXTRACT(color,2,8)
青yellow
USER>set $EXTRACT(color,2,8)="青もあれば黄色もあります"

USER>write color
赤青もあれば黄色もあります紫白黒
USER>
```

文字列の指定位置から最後までを指定する場合は、第3引数に * を指定します。
```
USER>write $EXTRACT(color,15,*)
白黒
```

## - 文字のトリミング

[$ZSTRIP()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fzstrip) を使用します。

文字列からマスクコード（A：すべてのアルファベット、W：空白 など）に該当する文字を、指定するアクションコード（<や>や*）を利用して、一部または全ての削除を指定できます。

>$ZSTRIP(文字列,アクションコードとマスクコードの組み合わせ,削除したい特定の文字,削除したくない文字)

第3引数以降はオプション指定です。

### - 例1：文中からすべての半角のスペースを取り除く

すべての対象文字を取り除く場合、アクションコードに * を指定します。半角スペースを表現するマスクコードは **W** なので、第2引数には ***W** を指定します。

※マスクコードのWは、ASCIIコード：9、32、160 の空白を指定できます。

```
USER>set moji="this is a pen."

USER>write $ZSTRIP(moji,"*W")
thisisapen
```

### - 例2：文中から全角スペースを取り除く

削除対象を示すマスクコードに対応する文字が存在しない場合は、第3引数を使用することで指定できます。

マスクコードに、全角スペースを表すコードがないため、**第3引数の「削除したい特定の文字」** に全角スペースを指定します。また、文中からすべての対象文字を取り除く場合に指定するアクションコード * は、第2引数に指定します。

以下例では、全角スペースが、文頭と「は」後方にあり、半角スペースが「気」後方にあります。

```
USER>set moji="　今日は　いい天気 です。"

USER>write $ZSTRIP(moji,"*","　")
今日はいい天気 です。   
```
上記例文から、**全角スペースと半角スペースを両方取り除く**場合、第2引数に半角スペースを示すマスクコード W を追加で指定します（例では、第2引数に *W を指定しています）。

```
USER>write $ZSTRIP(moji,"*W","　")
今日はいい天気です。
USER>
```

### - 例3：文頭、文末の半角スペースを削除する

文頭を示すアクションコードは **<**、文末を示すアクションコードは **>**、半角スペースを示すマスクコードは **W** なので、以下のような組み合わせで使用します。

文頭のスペースを削除する例（文末の半角スペースが表示上わかりにくいので変数mojiの出力の後で * を出力しています）
```
USER>set moji=" 原文は文頭と文末にスペースが入っています "

USER>write moji
 原文は文頭と文末にスペースが入っています
USER>write $ZSTRIP(moji,"<W"),"*"
原文は文頭と文末にスペースが入っています *
```

文末のスペースを削除する例
```
USER>write $ZSTRIP(moji,">W"),"*"
 原文は文頭と文末にスペースが入っています*
```

文頭、文末のスペースを削除する例（アクションコードに **<>** を指定します）
```
USER>write $ZSTRIP(moji,"<>W"),"*"
原文は文頭と文末にスペースが入っています*
```

アクションコードやマスクコードについては、[ドキュメント](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fzstrip#RCOS_fzstrip27)をご参照ください。

＜関連情報＞
- 開発者コミュニティ：[文字列の中から数値だけを抜き出す方法](https://jp.community.intersystems.com/node/502686)　


## - 文字の位置を調べたい
    
[$FIND()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_ffind) を使用します。

> $FIND(文字列,検索文字)

$FIND()は文字列の中から検索文字に指定した文字を見つけると、次の文字の位置を返します。

```
USER>set moji="令和4年10月31日"

USER>write $FIND(moji,"令和")
3
//確認に、$EXTRACT()で3番目を指定すると、「令和」の次の文字である「4」が返ります。
USER>write $EXTRACT(moji,3)
4
```
検索文字が存在しない場合は、0を返します。

```
USER>write $FIND(moji,"平成")
0
```

文字列の指定位置以降で一致する検索文字の次の位置を取得する場合は以下の通りです。
以下の例は、「令和4年10月31日」の6文字目以降に出現する「1」の次の位置を返しています。

```
USER>write $FIND(moji,1,6)
10
//確認に、$EXTRACT()で10番を指定すると「日」が返ります。
USER>write $EXTRACT(moji,10)
日   
```

## - 文字列の中に指定の文字を含む／含まないを調べたい

[包含演算子](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_operators#GCOS_operators_strrel_bincont)を利用します。

演算子の左辺の文字列の中に、右辺で指定する文字列が含まれる場合は、1 を返し、含まれない場合は 0 を返します。
```
USER>write moji
令和4年10月31日
USER>write moji["10月"
1
USER>write moji["11月"
0
```

**含まれない**場合は、演算子の左に否定演算子(')を指定するか、条件式全体を括弧で囲い、否定演算子を左に指定します。

```
USER>write moji'["11月"
1
USER>write '(moji["11月")
1
USER>write moji'["10月"
0
USER>write '(moji["10月")
0
```

## - 正規表現を使いたい

[$MATCH()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fmatch)を使用します。

文字列が指定した正規表現記号に合致するかどうかを1/0で返します。

> $MATCH("文字列","正規表現")


```
USER>write $MATCH("明日は雨です","明日は[雨晴雪]です")
1
USER>write $MATCH("明日は雷です","明日は[雨晴雪]です")
0
```

[$LOCATE()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_flocate)では、指定の正規表現の先頭位置を検索し、位置番号を返します。
```
USER>set str="APPLE-１５5"

USER>write $LOCATE(str,"[A-z]+")  //アルファベットのA～ｚが数回出現する場合の先頭ポジション確認

1
USER>write $LOCATE(str,"-")  //ハイフン – が出現するポジションを返します。

6
USER>write $LOCATE(str,"\d") //数字が出現する先頭のポジション確認

7
USER>write $LOCATE(str,"\d$")  //数字が出現する最後のポジション確認

9
```

## - 簡易的な正規表現を使いたい

[パターンマッチング演算子（?）](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_operators#GCOS_operators_pattern) が利用できます。

InterSystems 製品独自の記述で正規表現での評価とは異なりますが、以下のパターンコードを使用して簡易的な評価が行えます。

|コード| 意味 |
|--|--|
|N|0～9の整数|
|A|アルファベットの大文字小文字|
|U|アルファベットの大文字|
|L|アルファベットの小文字|
|ZFWCHARZ|日本語の全角文字
|ZHWKATAZ|日本語の半角カナ文字|

（他のコードについては[パターンマッチング演算子（?）のドキュメント](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_operators#GCOS_operators_pattern)をご参照ください。）

電話番号のパターンマッチング例（1～4桁の市外局番に 1つの - 1～4桁の市内局番に 1つの - 4桁の局番）
```
USER>set tel="03-5321-6200"

USER>if tel ? 1.4N1"-"1.4N1"-"4N { write "パターンOK" }
パターンOK
```
範囲指定（例：1桁から4桁）は、**1.4** のようにピリオドを使用します。

例えば、1桁の数字があってもなくてもいい場合は、**.1N** のように記述します。 

```
USER>set zip="160-0023"

USER>if zip?3N.1(1"-"4N) { write zip }
160-0023

USER>set zip=160 // .1(1"-"4N)に対する表記はあってもなくてもいいのでzipが出力されます

USER>if zip?3N.1(1"-"4N) { write zip }
160
USER>set zip="160-12"  //括弧内のパターンが合わないのでzipは出力されません

USER>if zip?3N.1(1"-"4N) { write zip }

USER>
```

## - 全部大文字／小文字にしたい

[$ZCONVERT()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fzconvert)を利用します。

大文字にしたい場合は、第2引数のモード・コードに**U**を指定します。

```
USER>set moji="InterSystems Japan"

USER>write $ZCONVERT(moji,"U")
INTERSYSTEMS JAPAN    
```
小文字にしたい場合は、第2引数のモード・コードに**L**を指定します。

```
USER>write $ZCONVERT(moji,"L")
intersystems japan
```

## - 全角日本語をバイト単位で切り出す方法

[FAQトピック](https://faq.intersystems.co.jp/csp/faq/result.csp?DocNo=524)をご参照ください。

## - HTMLの < や > をエスケープしたい

[$ZCONVERT()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fzconvert)を利用します。

```
USER>write $ZCONVERT("<DIV>","O","HTML")
&lt;DIV&gt;
```

## - URLやクエリパラメータに含まれる文字をエスケープ文字にしたい

[$ZCONVERT()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fzconvert)を利用します。

例）http://localhost:52778/csp/healthshare/fhirtest/fhir/r4/Patient?family=山田
のURLに含まれるクエリパラメータの[山田]をエスケープする場合

```
USER>write $ZCONVERT("山田","O","URI")
%E5%B1%B1%E7%94%B0
//または
USER>write $ZCONVERT("山田","O","URL")
%u5C71%u7530
```
例）URLの末尾に含まれる日本語をエスケープしたい。
https://jp.community.intersystems.com/post/コンテナ版irisのコンテナにrootユーザでログインする方法

```
USER>write $ZCONVERT("コンテナ版irisのコンテナにrootユーザでログインする方法","O","URI")
%E3%82%B3%E3%83%B3%E3%83%86%E3%83%8A%E7%89%88iris%E3%81%AE%E3%82%B3%E3%83%B3%E3%83%86%E3%83%8A%E3%81%ABroot%E3%83%A6%E3%83%BC%E3%82%B6%E3%81%A7%E3%83%AD%E3%82%B0%E3%82%A4%E3%83%B3%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95   
```

## - 文字を右寄せしたい

[$JUSTIFY()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fjustify)を使用します。

> $JUSTIFY(右寄せしたい値,右寄せする文字数の指定)

### - 例1：値を右寄せする

第1引数の指定した値を10桁内で右寄せして表示する
```
USER>write $JUSTIFY("abc123",10)
    abc123
```

### - 例2：値を右寄せして空白に別の値を挿入する

$JUSTIFY関数()の結果を[$REPLACE()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_freplace)を利用して置換します。
```
USER>write $REPLACE($JUSTIFY("abc123",10)," ","*")
****abc123
````

## 現在日付と時刻の取得

現在日付と時刻を取得するには、[特殊変数$HOROLOG](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_vhorolog)か、[$NOW()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_vhorolog) を使用します。

出力例は以下の通りです。

```
USER>write $HOROLOG
66414,42778
USER>write $NOW()
66414,42780.8974511
```

$HOROLOGも$NOW()も、カンマ区切りの左側が内部日付を表す数値で、右側が時刻を表す数値です。

内部日付は、1840年12月31日を起源日（0）とした経過日数を返します。

時刻は、0時からの経過秒数で、$NOW()関数は小数部も含む数値で返します。


### - タイムスタンプの取得

[特殊変数$ZTIMESTAMP](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_vztimestamp)を使用します。

```
USER>write $ZTIMESTAMP
66415,10087.0814289

//表示日付に変換
USER>write $ZDATETIME($ZTIMESTAMP,3)
2022-11-02 02:49:35
```
$ztimestampはUTC形式のタイムスタンプを返します。

ローカルタイムに合わせるためには、以下システム提供メソッドや関数を組み合わせて使います。

- システム提供メソッド：[%SYSTEM.Utilクラス](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Util)の[UTCtoLocalWithZTIMEZONE()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Util#UTCtoLocalWithZTIMEZONE)

    ```
    USER>write $SYSTEM.Util.UTCtoLocalWithZTIMEZONE($ZTIMESTAMP)
    66431,38353.2368065

    //$ZDATETIME()で表示変換をかける例
    USER>write $ZDATETIME($SYSTEM.Util.UTCtoLocalWithZTIMEZONE($ZTIMESTAMP),3)
    2022-11-18 10:39:26
    ```

    [$SYSTEM](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_vsystem)は、%SYSTEMパッケージ以下クラスの呼び出しが行える特殊変数で、**$SYSTEM.クラス名.メソッド名()** で実行できます。

    >##class(%SYSTEM.クラス名).メソッド名()　と同じ意味です。


- 関数： [$ZDATETIMEH()](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fzdatetimeh)

    第2引数に **-3** を指定します。引数詳細は[ドキュメント：dformat](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fzdatetimeh#RCOS_fzdatetimeh_dformat) をご参照ください。

    ```
    USER>write $ZDATETIMEH($ZTIMESTAMP,-3)
    66431,38387.1195591

    //$ZDATETIME()で表示変換をかける例
    USER>write $ZDATETIME($ZDATETIMEH($ZTIMESTAMP,-3),3)
    2022-11-18 10:40:01
    ```

### - $HOROLOGや$NOW()から内部日付だけ取得したい

[$PIECE()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fpiece)を利用してカンマ区切りの1番目を取得するか、+ の記号を利用します。

#### - 例：$PIECE()を利用する

カンマ区切りの1番目を取得するので位置を指定する第3引数は省略できます。
```
USER>write $PIECE($HOROLOG,",")
66414
USER>write $PIECE($NOW(),",")
66414
```

#### - 例：+ を利用する。

[単項プラス演算子 (+)](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_operators#GCOS_operators_unpos) を利用して、数字として取得できる部分を取得できます。

```
USER>write +$HOROLOG
66414
USER>write +$NOW()
66414
```
＜理由＞ObjectScriptはインタプリタであるため、左から右にコードを解釈します。+ の記号を文字の左側に指定した場合、数値ではない無効な文字に遭遇するまで文字列内に現れる数値を数値として返します。

文字列の先頭が文字の場合は、0を返します。
```
USER>write +"A123"
0
```

### - $HOROLOGや$NOW()から時刻だけ取得したい

[$PIECE()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fpiece)を利用してカンマ区切りの2番目を取得するか、+ の記号を利用します。

```
USER>write $PIECE($HOROLOG,",",2)
43606
USER>write $PIECE($NOW(),",",2)
43609.6208618
```

## 演算子

その他言語とObjectScriptの演算子早見表です。

--|ObjectScript|C または C++|C#|Visual Basic|Java|Python|JavaScript|GO|Rust
--|--|--|--|--|--|--|--|--|--
文字列結合|_|なし|+|+または&|+|+または+=|+|+|+
Not|'|!|!|Not|!|not|!|!|!
代入|=|=|=|=|=|=|=|=|=
比較（一致）|=|==|==|=|==|==|==|==|==
比較（不一致）|'=|!=|!=|<>|!=|!=|!=|!=|!=
論理演算（AND）|[&または&&](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_operators#GCOS_operators_binand)|&&|&&|And|&&|and|&&|&&|&&
論理演算（OR）|[!または&#124;&#124;](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_operators#GCOS_operators_binor)|&#124;&#124;|&#124;&#124;|Or|&#124;&#124;|or|&#124;&#124;|&#124;&#124;|&#124;&#124;
加,減,乗,除|+,-,*,/|+,-,*,/|+,-,*,/|+,-,*,/|+,-,*,/|+,-,*,/|+,-,*,/|+,-,*,/|+,-,*,/
剰余|#|%|%|Mod|%|%|%|%|%
整数除算|`\`|/|/|`\`|/|//|なし|/|/
インクリメント|なし|変数++／++変数|変数++／++変数|なし|変数++／++変数|なし|変数++／++変数|変数++／++変数|なし
デクリメント|なし|変数--／--変数|変数--／--変数|なし|変数--／--変数|なし|変数--／--変数|変数--／--変数|なし

※ ObjectScriptの演算子について詳細はドキュメント：[演算子と式](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_operators)をご参照ください。


## 注意点

### - 演算子の優先順位

ObjectScriptは、**必ず左から右に実行されます。**


```
USER>write 3+4*5
35
USER>write 3+(4*5)
23
USER>
```

通常の計算では **3+4\*5 は掛け算の 4*5 が先に計算され 3 が加算される**はずですが、ObjectScript は、**必ず左から右に実行されるため 3+4 の結果に 5 を掛けるため結果は 35 となります。**

明示的に **()** を使用して優先度を指定することで通常の計算と同じ結果を得ることができますので、()の指定を忘れないようにご注意ください


### - 数値と数字の扱い

すべて数字で構成される数値文字列 `"123"` は、**数値**として解釈されます。
>詳細はドキュメントの「[数値文字列](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_operators#GCOS_operators_str2num_numstrings)」も併せてご参照ください。

ObjectScriptでは、数に対する数値演算をすべて[キャノニック形式](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_types#GCOS_types_numcanonical)で実行するため、`123.0` は、数値演算を行うときに末尾の 0 が削除され `123` として解釈されます。

```
USER>if "123"=123 {write "SAME"}  //"123" は数値として解釈され一致するため「SAME」と表示されます
SAME
USER>if "123.0"=123.0 {write "SAME"} // "123.0"は文字として解釈され、123.0は123と解釈され一致しません
 
USER>if "123.0"=123 {write "SAME"}  // "123.0"は文字として解釈されるため一致しません
 
USER>
```

CSVファイル入力時に取得した値や、区切りマーク付き文字列の部分抽出で取得した値と数値の比較を行う場合、注意が必要です。

```
USER>set value=100*1.08  // 108
 
USER>set record="108.0,100,20"
 
USER>set col1=$PIECE(record,",",1)  // 108.0
 
USER>if col1=value { write "SAME" }  //　★

USER>
```

変数 col1 には、文字列として `108.0` が設定されるため、★ のWRITE文は実行されません。

ObjectScriptでは、+ の演算子を変数や文字列前に付与することで数値として解釈することができるので、以下のように記述することで数値としての比較が行えます。

```
USER>if +col1=value { write "SAME" }
SAME
USER>
```
> ご参考：[単項プラス演算子 (+)](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_operators#GCOS_operators_unpos) 

\+ の演算子の他に [$NUMBER()](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fnumber)関数を使用して数値を検証することもできます。

```
USER>write col1
108.0
USER>write $NUMBER(col1)
108
USER>write $NUMBER("108.0円")   //数値ではない場合 空("") を返します
 
USER>
```

## 日付の表示変換

### - 内部日付を表示日付に変換したい

[$ZDATE()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fzdate)を使用します。

> $ZDATE(内部日付,変換フォーマットの指定)

変換フォーマットを指定しない場合、MM/DD/YYYYの形式で日付が返ります。

```
USER>write $ZDATE($HOROLOG)
11/01/2022
USER>write $ZDATE($NOW())
11/01/2022
```

YYYY-MM-DD 形式に変換する場合は、第2引数に3を指定します。

```
USER>write $ZDATE($HOROLOG,3)
2022-11-01
USER>write $ZDATE($NOW(),3)
2022-11-01
```

YYYYMMDD 形式に変換する場合は、第2引数に8を指定します。
```
USER>write $ZDATE($HOROLOG,8)
20221101
USER>write $ZDATE($NOW(),8)
20221101
```
YYYY年MM月DD日 形式に変換する場合は、第2引数に16を指定します。
```
USER>write $ZDATE($HOROLOG,16)
2022年11月1日
USER>write $ZDATE($NOW(),16)
2022年11月1日
```

曜日（英字）を取得したいときは、12を指定します。
```
USER>write $ZDATE($HOROLOG,12)
Tuesday
USER>write $ZDATE($NOW(),12)
Tuesday
```

第2引数で指定できるフォーマット番号について詳細は、[ドキュメント](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fzdate#RCOS_fzdate_dformat)をご参照ください。

＜関連情報＞
- 元号への変換はコミュニティサポートの[Japanese Calendar Converter](https://openexchange.intersystems.com/package/Japanese-Calendar-Converter)をご参照ください。

### - 表示日付から内部日付への変換

[$ZDATEH()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fzdateh)を使用します。

> $ZDATEH(表示日付,変換フォーマットの指定)

第2引数の変換フォーマットの指定を省略すると、MM/DD/YYYYの形式の日付に対して内部日付に変換をかけます。

```
USER>write $ZDATEH("01/31/1999")
57739
```

YYYY-MM-DDの形式を内部日付に変換する場合は、第2引数に 3 を指定します。
```
USER>write $ZDATEH("1999-01-31",3)
57739
```

YYYYMMDD の形式を内部日付に変換する場合は、第2引数に 8 を指定します。
```
USER>write $ZDATEH("19990131",8)
57739
```

YYYY年MM月DD日の形式を内部日付に変換する場合は、第2引数に 16 を指定します。
```
USER>write $ZDATEH("1999年1月31日",16)
57739
```

※変換フォーマットの指定は、$ZDATE()関数と$ZDATEH()関数で共通です。


## 時刻の表示変換

### - 内部時刻から表示時刻への変換

[$ZTIME()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fztime)を使用します。

現在日付時刻（$HOROLOG）のカンマ区切りの2番目から内部時刻が取得できるので、その数値を利用した表示時刻への変換は以下の通りです。
```
USER>write $ZTIME($PIECE($HOROLOG,",",2))
13:14:54
```

hh:mm:ss[AM/PM]の形式変換は第2引数で指定できるフォーマット変換番号に3を指定します。
```
USER>write $ZTIME($PIECE($HOROLOG,",",2),3)
01:19:22PM
```


### - 表示時刻から内部時刻への変換

[$ZTIMEH()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fztimeh)

```
USER>write $ZTIMEH("13:10:59")
47459
```
hh:mm:ss[AM/PM]の形式から内部時刻へ変換する場合は、第2引数に指定できるフォーマット変換番号に3を指定します。
```
USER>write $ZTIMEH("01:10:59PM",3)
47459
```
## 日付時刻の変換

### - 内部日付時刻から表示日付時刻への変換

[$ZDATETIME()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fzdatetime)を使用します。

> $ZDATETIME(内部日付時刻,フォーマット変換番号)

第2引数のフォーマット変換番号は、[$ZDATE()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fzdate)や[$ZDATEH()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fzdateh)と共通番号です。


以下の例では、内部日付時刻に$HOROLOGや$NOW()を指定しています。
```
USER>write $ZDATETIME($HOROLOG,3)
2022-11-01 13:24:57
USER>write $ZDATETIME($NOW(),3)
2022-11-01 13:25:15
```

### - 表示日付時刻から内部日付時刻への変換
[$ZDATETIMEH()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fzdatetimeh)を使用します。

> $ZDATETIMEH(表示日付時刻,フォーマット変換番号)
```
USER>write $ZDATETIMEH("2022-11-01 13:25:15",3)
66414,48315
```

## 実行時間を計測したい

InterSystems製品開始以降からの経過秒数を保持している[特殊変数$ZHOROLOG](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_vzhorolog)を使用します。

メソッドやルーチンでの使用例は以下の通りです（計測時間を出力する例で記載しています）。
```
    set starttime=$ZHOROLOG
    /*
        何らかの処理
    */
    write $ZHOROLOG-starttime,!
```


## リスト

### - リストを作成／取得する

[$LISTBUILD()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_flistbuild)を使用します。

$LISTBUILD()関数に作成したいリストの要素を順番に指定します。
```
set color=$LISTBUILD("赤","青","黄色")
```
設定した順序で、リストの要素1番に赤、2番に青、3番に黄色が設定されます。

### - 作成したリストの要素を変数にセットする

#### - $LISTBUILD()を利用する方法

取得したい要素の場所に変数を指定します。

以下の例では、リストの1番目が変数aに、リストの2番目が変数bに設定されます。
```
USER>set color=$LISTBUILD("赤","青","黄色")

USER>set $LISTBUILD(a,b)=color
 
USER>write a,"-",b
赤-青
```

リストの1番目と3番目を取得して変数に代入したい場合は、1番と3番の要素の場所に変数を設定します。
```
USER>set $LISTBUILD(a,,c)=color

USER>write a,"-",c
赤-黄色
```

以下の例では変数dを参照すると値が設定されていないため、未定義`<UNDEFINED>` エラーが出ます。
存在しない要素番号の位置に変数を指定してもエラーにはなりませんが、値は設定されません。

```
USER>set color=$LISTBUILD("赤","青","黄色")

USER>set $LISTBUILD(a,,c,d)=color
 
USER>write a,"-",c,"-",d
赤-黄色-
WRITE a,"-",c,"-",d
                  ^
<UNDEFINED> *d
```

#### - $LISTNEXT()関数を利用する方法

[$LISTNEXT()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_flistnext)を使用して、要素を順番に取得できます。

リストの要素を順番に取得するため、第2引数に要素のポインタを示すローカル変数を指定します。このローカル変数には0を設定しておきます（第2引数に指定するローカル変数に指定できる値は0だけです）。

第3引数にリストの値を登録するローカル変数を指定します（グローバル変数や配列変数を指定することはできません）。

$LISTNEXT()関数は、リストの要素の取得に成功すると1を返し、最後まで検出すると0を返します。

```
USER>set color=$LISTBUILD("赤","青","黄色")

USER>set p=0
 
USER>while $LISTNEXT(color,p,value) { write value,!}
赤
青
黄色
```

リストに未設定の要素が含まれる場合、第3引数に指定するローカル変数が未設定となり、`<UNDEFINED>`エラーが発生します。

```
USER>set color=$LISTBUILD("赤","青",,,,"白")
 
USER>set p=0
 
USER>while $LISTNEXT(color,p,value) { write value,!}
赤
青
 
WHILE $LISTNEXT(color,p,value) { WRITE value,!}
                                ^
<UNDEFINED> *value
USER>
```
`<UNDEFINED>`エラーを防止するため、第3引数に指定したローカル変数にアクセスする際、[$GET()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fget)を使用します。

```
USER>set p=0
 
USER>while $LISTNEXT(color,p,value) { write $GET(value),!}
赤
青
 
 
 
白

```
ということで、取得したリストの要素を変数にセットすると以下のようになります。

（ルーチン・メソッドの例）

```
    set color=$LISTBUILD("赤","青","","紫")
    set p=0,cn=0
    while $LISTNEXT(color,p,value) {
        set cn=cn+1
        if $GET(value)="" continue
        set data(cn)=value
    }
    zwrite data
```
※ continueコマンドについては、[4-2) ループのコマンド](#4-2-ループのコマンド)をご参照ください。

実行例は以下の通り
```
USER>do ##class(CookBook.Class1).listgetset()
data(1)="赤"
data(2)="青"
data(4)="紫"
```


>**※ リストの要素を順番に取得する方法として、$LIST()関数／$LISTLENGTH()関数／FOR文を利用しても取得できますが、$LISTNEXT()の方がパフォーマンスの面で大幅に効率よく処理できるため、順番に取得する場合は、$LISTNEXT()をご利用ください**

### - リストに未設定の要素が含まれる場合の取得

以下のように、リストの要素に未設定の項目が含まれる場合、
```
set color=$LISTBUILD("赤","青",,,"白")
```

例えば、要素番号3番目に$LIST()関数でアクセスすると、`<NULL VALUE>` のエラーが発生します。
```
USER>write $LIST(color,3)
 
WRITE $LIST(color,3)
^
<NULL VALUE>
```
このエラーを回避するには、[$LISTGET()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_flistget)を利用します。

```
USER>write $LISTGET(color,3)
 
USER>
```
$LISTGET()関数はアクセスするリストの要素が未定義の場合`<NULL VALUE>` のエラーを発生させずに、既定値（空文字）を返します。


### - リストの要素を変更する

[$LIST()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_flist)を使用します。

>set $LIST(リスト,要素番号)=値

```
USER>set color=$LISTBUILD("赤","青","黄色")

USER>set $LIST(color,3)="Yellow"
 
USER>zwrite color
color=$lb("赤","青","Yellow")
```
※リストは文字列ではないため、write で出力すると文字化けしたように見えます。ターミナルで確認する際は、**zwrite** を使うと便利です。



### - リストに要素を追加する

[$LIST()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_flist)を使用し、追加したい要素番号を指定してSET文で追加します。

>set $LIST(リスト,番号)=値

```
USER>set color=$LISTBUILD("赤","青","黄色")
 
USER>set $LIST(color,10)="白"
 
USER>zwrite color
color=$lb("赤","青","黄色",,,,,,,"白")
```

### - リストの末尾に要素を追加する

[$LIST()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_flist)を使用します。

現在のリストの要素の末尾を取得するには、第2引数に * を指定します。
```
USER>set color=$LISTBUILD("赤","青","白")
 
USER>write $LIST(color,*)
白
```

末尾に追加する場合は第2引数に ***+1** を指定してSET文を実行します。

```
USER>set $LIST(color,*+1)="最後に追加"
 
USER>zwrite color
color=$lb("赤","青","白","最後に追加")

```

### - リストの要素数を取得する

[$LISTLENGTH()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_flistlength)を使用します。

```
USER>set moji=$LISTBUILD("あ","い","う","え","お")
 
USER>write $LISTLENGTH(moji)
5
```

### - リストの要素が存在しているか確認する

[$LISTDATA()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_flistdata)を使用します。

リストの指定ポジションの要素が存在する場合は1、存在しない場合は0 を返します。
```
USER>set color=$LISTBUILD("赤","青",,,"白")
 
USER>write $LISTDATA(color,1)
1
USER>write $LISTDATA(color,3)
0
```

### - リストの末尾の要素を削除する

[$LIST()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_flist)の第2と第3引数を利用します。

例えば、以下のリストがあるとして
```
USER>set color=$LISTBUILD("赤","青","黄色","緑")
```
4番目の要素を削除する場合は、以下のように指定します。

>set $LIST(リスト,開始位置,終了位置)=""
```
USER>set $LIST(color,4,4)=""
 
USER>zwrite color
color=$lb("赤","青","黄色")
```

2番目と3番目の要素を削除する場合は、以下のように記述します。

```
USER>set $LIST(color,2,3)=""
 
USER>zwrite color
color=$lb("赤")
```

※リストの末尾ではない要素に "" を設定すると指定位置の要素は削除されず、空文字が設定されます。


### - リストの結合

結合演算子(_)で結合できます。

```
USER>set list1=$LISTBUILD("おはようございます","こんばんは")
 
USER>set list2=$LISTBUILD("Good morning","Good evening")
 
USER>set list3=list1_list2
 
USER>zwrite list3
list3=$lb("おはようございます","こんばんは","Good morning","Good evening")
```

### - リストの一部要素の削除

[$LIST()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_flist)を使用します。

削除したい要素以外を第2、第3引数を使用して取得し、文字列結合（_）を使って一部要素を削除します。

以下の例は、変数list1に4つの要素がありますが、3つ目の要素を削除する場合の例文です。
```
USER>set list1=$LISTBUILD("赤","青","黄色","黒")
 
USER>set list2=$LIST(list1,1,2)_$LIST(list1,4,4)
 
USER>zwrite list2
list2=$lb("赤","青","黒")
```

**＜メモ＞**
1つの要素を取得するときは、第3引数も指定します（例文では4番目のリストを取得する際 *$LIST(list1,4,4)* と第3引数まで指定しています）。
第3引数がない場合、指定要素の値が返ってしまうため、**リストとして取得したい場合は、第3引数まで指定します。**



### - リストから文字列への変換

[$LISTTOSTRING()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_flisttostring)を使用します。

> $LISTTOSTRING(リスト,区切り文字)

第2引数は文字列にする際に使用したい任意の区切り文字を指定できます。

```
USER>set color=$LISTBUILD("赤","青","黄色","緑")

USER>write $LISTTOSTRING(color,",")
赤,青,黄色,緑
USER>write $LISTTOSTRING(color,"*")
赤*青*黄色*緑
```

### - 文字列からリストへの変換

[$LISTFROMSTRING()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_flistfromstring)を使用します。

> $LISTFROMSTRING(文字列,区切り文字)

第2引数はリストにしたい文字列に含まれる区切り文字列を指定します。

```
USER>set moji="赤,青,黄色,緑"

USER>zwrite $LISTFROMSTRING(moji,",")
$lb("赤","青","黄色","緑")
```

### - CSVファイルの中身をリストに格納する

[$LISTFROMSTRING()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_flistfromstring)の利用と、ファイル入出力に便利なライブラリクラス：[%Stream.FileCharacter](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Stream.FileCharacter)を使用する例でご紹介します。

このクラスの使い方の詳細は開発者コミュニティの記事もご参照ください。
- [ファイル入出力処理をスクリプトで記述する方法](https://jp.community.intersystems.com/node/492531)　（【B】%Stream.FileCharacterを利用する方法　に詳しく記載しています）

以下データが c:\temp\Kion.txtに用意されているとします。
```
都市名,最低気温,最高気温
札幌,6.0,15.2
青森,8.0,17.0
秋田,5.8,17.5
岩手,5.1,17.2
宮城,8.9,17.3
山形,5.1,17.3
福島,6.1,17.8
```
このファイルを入力する処理は以下の通りです。（ターミナルでの実行例で記載します）

```
USER>set filename="c:\temp\Kion.txt"
 
USER>set file=##class(%Stream.FileCharacter).%New()
 
USER>do file.LinkToFile(filename)
 
USER>while file.AtEnd=0 {  write file.ReadLine(),! }
都市名,最低気温,最高気温
札幌,6.0,15.2
青森,8.0,17.0
秋田,5.8,17.5
岩手,5.1,17.2
宮城,8.9,17.3
山形,5.1,17.3
福島,6.1,17.8

USER>kill file  // ファイルクローズ
```
文字列ファイル操作用のインスタンスを生成し、実ファイルとリンクさせた後、ファイルの中身をREADしています。

%Stream.FileCharacterクラスのAtEndプロパティは、EndOfFileを検出すると 1 が設定されるので、0が設定されている間、ReadLine()メソッドを利用して改行のあるところまでREADし、ターミナルに出力しています。

なお、WindowsにInterSystems製品をインストールしている場合、ファイル入出力時の文字コードはデフォルトでSJISが利用さます。入出力したいファイルの文字コードが異なる場合は、インスタンス生成後、TranslateTableプロパティを利用して文字コードを変更できます。

例えば、UTF8のファイルを入力する場合は以下の通りです。

```
USER>set file=##class(%Stream.FileCharacter).%New()
 
USER>set file.TranslateTable="UTF8"
```
（以降の流れは同じです。詳細は、 [ファイル入出力処理をスクリプトで記述する方法](https://jp.community.intersystems.com/node/492531)の「【B】%Stream.FileCharacterを利用する方法」をご参照ください）

ファイルの各行をリストに登録する流れ全体は以下のようになります。

ルーチン・メソッドのコード例は以下の通りです。
```
    set filename="c:\temp\Kion.txt"
    set file=##class(%Stream.FileCharacter).%New()
    set file.TranslateTable="UTF8"
    do file.LinkToFile(filename)
    //先頭行はヘッダ行なので読み飛ばします
    do file.ReadLine()
    //各行読みながら配列変数にリストで登録
    set cn=0
    while file.AtEnd=0 {
        set cn=cn+1
        set csvdata(cn)=$LISTFROMSTRING(file.ReadLine(),",")
    }
    zwrite csvdata
```

実行例は以下の通りです。
```
USER>do ##class(CookBook.Class1).csvtolist()
csvdata(1)=$lb("札幌","6.0","15.2")
csvdata(2)=$lb("青森","8.0","17.0")
csvdata(3)=$lb("秋田","5.8","17.5")
csvdata(4)=$lb("岩手","5.1","17.2")
csvdata(5)=$lb("宮城","8.9","17.3")
csvdata(6)=$lb("山形","5.1","17.3")
csvdata(7)=$lb("福島","6.1","17.8")
```

> メモ：ローカル変数に設定していますがグローバル変数に設定することももちろんできます。

＜関連情報＞
- [ファイルの入出力](#ファイルの入出力)


## 変数や引数の存在チェック

ルーチンやメソッド内で扱う変数や引数に値が設定されていない場合、`<UNDEFINED>`エラーが発生します。

変数にアクセスしたときの未定義エラーを防ぐため、変数の存在チェック方法として、[$GET()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fget)や [$DATA()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fdata)が利用できます。

2つの関数の概要は、以下の通りです。

- [$GET()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fget)

    引数に指定する変数の値を返す。未定義の場合は空（""）を返す。


- [$DATA()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fdata)

    変数とサブスクリプトの有無を確認できる（1、0、11、10 のいずれかを返す）。

例）ターミナルを開き、変数abcをWRITEします。
```
USER>write abc
 
WRITE abc
^
<UNDEFINED> *abc
USER>write $GET(abc)
 
USER>write $DATA(abc)
0
USER>
```
ターミナルを開いたばかりの時は、ローカル変数が存在していませんので、変数abcは存在しないため、`<UNDEFINED>`エラーが発生します。

次の行では、$GET()関数を使用することで`<UNDEFINED>`エラーを発生せず、空（""）が返されていることを確認できます。

さらに次の行では、$DATA()関数を使用することで、変数abcに値が存在しないことを示す 0 が返されていることを確認できます。

上記例の場合、$GET()でも$DATA()でもどちらを使っても変数が存在するかしないかを未定義エラーが発生させずに確認できます。

では、変数abcに空（""）を設定した場合はどうでしょうか。
```
USER>set abc=""
 
USER>write $GET(abc)
 
USER>write $DATA(abc)
1
```

$GET(abc)の結果をみると、`<UNDEFINED>`エラーが発生したことによる空（""）なのか、空（""）を設定したことによる結果なのかを判別できません。

$DATA(abc)の結果を見ると、変数が存在していることを示す 1 が返されるため、変数が存在していることを正しく認識できます。

つまり、変数自身の存在チェックを厳密に行いたい場合は、$DATA()関数が向いているといえます。

空（""）を設定したかどうかのチェックは不要で値のチェックを行うだけであれば、$GET()関数でも十分です。


## 配列のサブスクリプトの存在チェック

[$DATA()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fdata)を使用します。

以下の配列変数で確認しましょう。

例えば、オンラインショッピングのカートの中身をイメージして以下の配列を用意します（グローバル変数でもローカル変数でもどちらでも設定できますが、例はグローバル変数を利用しています）。

```
USER>set ^cart("cust001")="顧客一郎"
 
USER>set ^cart("cust001","ShipAddress")="東京都新宿区"
 
USER>set ^cart("cust001","Items",1)="加湿器"
 
USER>set ^cart("cust001","Items",2)="加湿器専用フィルター"
```

例えば、カート使用中の cust001 のお客さんに対して送付先住所（ShipAddres）が指定されているか
？を確認するイメージで、^cart("cust001","ShipAddress") に対して $DATA()関数を実行します。
```
USER>write $DATA(^cart("cust001","ShipAddress"))
1
```
1 が戻ったので ^cart("cust001","ShipAddress") にデータが存在していることを確認できました。

次に、^cart("cust001","Items") に対して$DATA()関数を実行します。

```
USER>write $DATA(^cart("cust001","Items"))
10
```
10 が戻りました。

10 が戻るということは、サブスクリプト：Items は存在しているが、^cart("cust001","Items") にデータがないことを示しています。

次に、^cart("cust001")に対して$DATA()関数を実行します。
```
USER>write $DATA(^cart("cust001"))
11
```
11 が戻りました。

$DATA(^cart("cust001")) と $DATA(^cart("cust001","Items")) の違いは、指定のサブスクリプトに対して**データが存在しているか、していないか**の差になります。

配列変数のサブスクリプトが存在しているかどうかをチェックする場合、11 または 10 が返るパタンがあるのでご注意ください。

### データの有無に関わらずサブスクリプトの存在チェックをしたい

[$DATA()関数](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_fdata)で評価した結果を10で割り、商が 1 であるかどうか確認します（算術演算子 \ を使用します）。

```
USER>write $DATA(^cart("cust001","Items"))\10
1
USER>write $DATA(^cart("cust001"))\10
1
USER>write $DATA(^cart("cust001","Items22"))\10
0
```
サブスクリプトが存在している場合は、1 を返り、存在しないと 0 が戻ります。


## プロセス単位で一意となるデータを作りたい

プロセス単位で一意となるデータを作る場合は、グローバル変数、または[プロセスプライベートグローバル](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_variables#GCOS_variables_procprivglbls)を使用します。

グローバル変数を使用する場合は、ネームスペース内でユニークとなるように、[特殊変数$JOB](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_vjob)を使用してプロセスIDを調べ、グローバル変数の第1サブスクリプトに指定します。

```
USER>set ^TEST($JOB)="テストデータです"
 
USER>zwrite ^TEST
^TEST(10972)="テストデータです"
 
USER>write $JOB
10972
```

プロセスプライベートグローバルを使用するときは、グローバル変数名の前に || を指定します。

**^||グローバル変数名**

```
USER>set ^||data="プロセスプライベートグローバル"
 
USER>for i=1:1:3 { set ^||data(i)="test"_i }
 
USER>zwrite ^||data
^||data="プロセスプライベートグローバル"
^||data(1)="test1"
^||data(2)="test2"
^||data(3)="test3"
```

プロセスプライベートグローバルは、作成したプロセスの中だけで利用できるグローバルで、[管理ポータル>エクスプローラー>グローバル] の画面から参照できません。

また、プロセス消去と同時にグローバル変数も消去されます。

プロセスプライベートグローバルは通常のグローバル変数と異なり、[一時的なグローバルを保持できる専用データベース（IRISTEMP／CACHETEMP）](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GGBL_tempgbl)に保存される仕組みになっています。

IRISTEMP／CACHETEMPデータベースは、InterSystems製品の停止を行うとデータが消去される特別なデータベースです。

永続的に情報を保持したい場合には不向きですので、ワークデータや一時的に保存しておきたい大量データなどの置き場所に向いています。

## ファイルの入出力

ライブラリクラスを利用する方法と、コマンドを利用する方法があります。

### - ライブラリクラス：%Stream.FileCharacter/FileBinaryを利用する方法

- [%Stream.FileCharacter](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Stream.FileCharacter)

    文字列のファイル入出力に利用できるクラス

- [%Stream.FileBinary](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Stream.FileBinary)

    バイナリのファイル入出力に利用できるクラス

以下、文字列のファイル入出力例をご紹介します。

例で使用するファイルの中身は以下の通りです。
```
あいうえお
かきくけこ
さしすせそ
```
例えば、Windowsのメモ帳で上記3行を記述して　c:\temp\testfile1.txt で保存したとします。

> 最近のWindowsのメモ帳は、UTF8で保存するので、例の中ではUTF8で保存されたファイルを使用します。

手順は以下の通りです。

1) ファイル操作用インスタンスを生成します。

    ```
    set fo=##class(%Stream.FileCharacter).%New()
    ```

2) 入力ファイルと作成したインスタンスをリンク付けます。

    ※ファイル名はフルパスで指定します。

    ```
    do fo.LinkToFile("c:\temp\testfile1.txt")
    ```

3) UTF8の文字コードで入力するため、TranslateTableプロパティにUTF8を設定します。

    ※WindowsにインストールしたInterSystems製品では、ファイル入出力時にSJISをデフォルトの文字コードとして使用します。Windows以外では、ファイル入出力にUTF8を使用します。

    ```
    set fo.TranslateTable="UTF8"
    ```
    ※ UTF8はすべて大文字で記述します。

4) 改行のあるところまでREADするため、ReadLine()メソッドを使用します。

    ```
    write fo.ReadLine()   // あいうえお と出力される予定
    ```

5) AtEndプロパティを確認します。

    AtEndプロパティはファイルの終わりを検出すると 1 が設定され、未検出時は 0　が設定されます。
    ```
    write fo.AtEnd  // 0が返る予定
    ```

6) AtEndプロパティに1が返るまでReadLine()を繰り返します。

    ```
    USER>write fo.ReadLine()
    かきくけこ
    USER>write fo.AtEnd
    0
    USER>write fo.ReadLine()
    さしすせそ
    USER>write fo.AtEnd
    1
    ```

7) 処理を終了します。

    使用していたインスタンスを破棄するため、変数を消去します。

    ```
    kill fo
    ```

一連の流れをルーチン・メソッドで記述するとこんな感じです。

```
    set fo=##class(%Stream.FileCharacter).%New()
    do fo.LinkToFile("c:\temp\testfile1.txt")
    set fo.TranslateTable="UTF8"
    while fo.AtEnd=0 {
        write fo.ReadLine(),!
    }
    kill fo
```
実行結果は以下の通りです。
```
USER>do ##class(CookBook.Class1).fileread()
あいうえお
かきくけこ
さしすせそ
```

ファイル出力する例は、ReadLine()のところがWrite()やWriteLine()になるだけです。

- Write()

    引数に指定した文字列をファイルに出力する

- WriteLine()

    引数に指定した文字列をファイルに出力＋改行する

新規ファイルを文字コードUTF8で出力する流れは以下の通りです。ファイル入力の流れと 1)～3) まで同様です。

>Windowsでの例で記載しています。Windows以外にInterSystems製品をインストールしている場合、ファイル入出力の文字コードはUTF8で行われるので、TranslateTableの指定は不要です。

```
//インスタンス生成
set fo=##class(%Stream.FileCharacter).%New()
//出力用ファイルのリンク付け（存在していない場合は新規作成）
do fo.LinkToFile("c:\temp\testfile2.txt")
//UTF8で出力するように文字コード指定
set fo.TranslateTable="UTF8"
```

ファイルに文字列を出力し、改行を末尾に追加します。

```
do fo.WriteLine("新しいファイルに出力します")
do fo.WriteLine("正しく記述できたか確認します")
```

ファイルを保存します。

```
write fo.%Save() // 1が返れば保存成功
```

%Stream.FileCharacter／%Stream.FileBinary は、Read()／ReadLine()の操作があると、読み込みモードでファイルをオープンし、Write()／WriteLine()の操作があると、書き込みモードでファイルをオープンします。

この他、ファイルユーティリティを豊富に持つ [%Library.File](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Library.File)を利用してもファイル入出力が行えます。

※%Libraryパッケージはクラスの構築基盤となるクラスが多く存在するパッケージで、非常によく利用されるため、**Library.** を省略し、%File と記述することができます。

%Fileクラスを利用してファイルをオープンする際、読み込みモードなのか、書き込みモードなのか、パラメータで指定する必要があります。

### - ライブラリクラス：%Fileを使ったファイル出力

>Windowsでの例で記載しています。Windows以外にInterSystems製品をインストールしている場合、ファイル入出力の文字コードはUTF8で行われるので、Kオプションの指定は不要です。


1) ファイル処理用インスタンス生成
    
    インスタンス生成時に操作したいファイルのフルパスを引数に指定します。

    ```
    set file=##class(%File).%New("c:\temp\testfile3.txt")
    ```
2) ファイルのオープン

    新規：N、書き込みモード：W、ストリーム形式：Sを指定してオープンします。
    ```
    write file.Open("NWSK\UTF8\")
    ```

    ※ファイル入出力時の文字コードをデフォルトから変更する場合は、Kオプションを指定します（**K\\文字コード\\** と指定します）

3) ファイルに文字を出力します。（%Stream.FileCharacterと同様です）

    ```
    do file.WriteLine("テストです")
    do file.WriteLine("2行目です")
    ```

4) 書き込みを終了し、ファイルをクローズします。
    ```
    do file.Close()
    kill file
    ```

### - ライブラリクラス：%Fileを使ったファイル入力

>Windowsでの例で記載しています。Windows以外にInterSystems製品をインストールしている場合、ファイル入出力の文字コードはUTF8で行われるので、Kオプションの指定は不要です。

1) ファイル処理用インスタンス生成
    
    インスタンス生成時に操作したいファイルのフルパスを引数に指定します。

    ```
    set file=##class(%File).%New("c:\temp\testfile3.txt")
    ```
2) ファイルのオープン

    読み込みモードのRとストリーム形式のSを指定してオープンします。
    ```
    write file.Open("RSK\UTF8\")
    ```

    ※ファイル入出力時の文字コードをデフォルトから変更する場合は、Kオプションを指定します（**K\\文字コード\\** と指定します）

3) ファイルの中身を読み込みます。（%Stream.FileCharacterと同様です）

    ```
    while file.AtEnd=0 { write file.ReadLine(),!}
    ```

4) ファイルをクローズします。

    ```
    do file.Close()
    kill file
    ```

%Fileクラスはファイルの入出力操作のほかに、ディレクトリやファイルの存在チェック、ディレクトリの作成、ディレクトリやファイルの正規化（NormalizeDirectory()／NormalizeFilename()／NormalizeFilenameWithSpaces()）、ファイルのコピーなどが行えるユーティリティメソッドを多く持っています。
詳細は、クラスリファレンス：[%Library.File](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Library.File)をご参照ください。

＜関連記事＞
- [ファイル入出力処理をスクリプトで記述する方法](ファイル入出力処理をスクリプトで記述する方法)


### - コマンドを利用してファイルを入出力する方法

[OPEN](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_copen)、[USE](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cuse)、入力には[READ](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_cread)、出力にはWRITEコマンドを使用します。

ファイル入出力時、[OPENコマンドのモードパラメータ](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GIOD_rmsseqfiles#GIOD_rmsseqfiles_openmodeparams)を使用します。

- ファイル出力時

    N：新規作成／S：ストリーム形式／W：書き込み／K\文字コード\

- ファイル入力時

    R：読み取り／S：ストリーム形式／K\文字コード\

Kパラメータで指定する文字コードの調査方法は、FAQトピック[文字コードを変換するときに利用できる変換テーブル名を取得する](https://jp.community.intersystems.com/node/491776)をご参照ください。

- ファイルデバイスへの切り替え

USEコマンドで切り替えるデバイスを指定します。ファイルの場合はファイルのフルパスをデバイス名として使用します。

デバイス名を変数に設定して指定もできるので、以降の例では、変数fileに設定しています。

またコマンドを利用する場合、デバイスを切り替えて入出力を行うため、実行前のカレントデバイス情報を[特殊変数$IO](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_vio)を使用して変数に設定し、処理の最後に元のデバイスに戻すためUSEコマンドを実行します。

### - ファイル出力例（OPEN、USE、WRITE、CLOSE）

以下の手順でファイル出力が行えます。

パラメータやUSEコマンドについての解説は[コマンドを利用してファイルを入出力する方法](#--コマンドを利用してファイルを入出力する方法)をご参照ください。

1. ファイルのオープン

    **OPEN フルパスのファイル名:"モードパラメータの指定"**

    例1）OPEN "c:\temp\testfile4.txt":"NWS"

    デフォルトの文字コードから変更する場合は、K\文字コード\を指定します。

    例2）OPEN "c:\temp\testfile4.txt":"NWSK\UTF8\"

2. USEコマンドでデバイスの使用を指定し、WRITEで出力します。

    **USE フルパスのファイル名 WRITE "出力したい文字列",!**

    ※ !は改行を出力します。

3. ファイルのクローズ

    **CLOSE フルパスのファイル名**  


ルーチン・メソッド例は以下の通りです。
```
    set file="c:\temp\testfile4.txt"
    set currentIO=$IO
    //open file:"NWS"  //ファイルIOのデフォルト文字コード：WindowsはSJIS
    open file:"NWSK\UTF8\"
    use file write "あいうえお",!
    use file write "かきくけこ",!
    use file write "さしすせそ",!
    close file
    use currentIO
```

### - ファイル入力例（OPEN、USE、READ、CLOSE）

以下の手順でファイル出力が行えます。

パラメータやUSEコマンドについての解説は[コマンドを利用してファイルを入出力する方法](#--コマンドを利用してファイルを入出力する方法)をご参照ください。

1. ファイルのオープン

    **OPEN フルパスのファイル名:"モードパラメータの指定"**

    例1）OPEN "c:\temp\testfile4.txt":"RS"

    デフォルトの文字コードから変更する場合は、K\文字コード\を指定します。

    例2）OPEN "c:\temp\testfile4.txt":"RSK\UTF8\"

2. USEコマンドでデバイスの使用を指定し、READで改行のある位置まで読み取り変数に代入します。

    **USE フルパスのファイル名 READ 変数**

    ファイルの終わりを検出すると`<ENDOFFILE>`エラーが発生します。
    このエラーを検知したとき、ファイル入力処理を終了するためファイルをクローズします。

    ターミナルで実行した例は以下の通りです。[ファイル出力例（OPEN、USE、WRITE、CLOSE）](#--ファイル出力例openusewriteclose)で作成したファイルをREADする例で記載します。
    ```
    USER>set io=$IO
    
    USER>set file="c:\temp\testfile4.txt"
    
    USER>open file:"RSK\UTF8\"
    
    USER>use file read x use io write x,!  //読み取った行を変数xに代入しカレントデバイスに出力
    あいうえお
    
    USER>use file read x use io write x,!
    かきくけこ
    
    USER>use file read x use io write x,!
    さしすせそ
    
    USER>use file read x use io write x,!
    
    USE file READ x USE io WRITE x,!
            ^
    <ENDOFFILE>
    USER>close file    
    ```

3. ファイルのクローズ

    **CLOSE フルパスのファイル名**  

ルーチン・メソッド例は以下の通りです。例では、`<ENDOFFILE>`のエラーでCATCHブロックに移動したところでファイルをクローズしカレントデバイスに切り替えを行っています。
```
    #dim ex As %Exception.AbstractException
    set file="c:\temp\testfile4.txt"
    set currentIO=$IO
    try {
        //open file:"RS"  //ファイルIOのデフォルト文字コード：WindowsはSJIS
        open file:"RSK\UTF8\"
        for {
            use file read x use currentIO write x,!
        }
    }
    catch ex {
        if ex.DisplayString() [ "ENDOFFILE" {
            close file
            use currentIO
            write "***ファイル入力終了***",!
        }
    }
```

実行結果は以下の通りです。
```
USER>do ##class(CookBook.Class1).filereadcommand()
あいうえお
かきくけこ
さしすせそ
***ファイル入力終了***

```

## HTTPのGET要求を実行したい

[%Net.HttpRequest](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.HttpRequest) を利用します。

以下、[OpenWather](https://openweathermap.org/) の [Current weather data](https://openweathermap.org/current) へGET要求を行う流れでご紹介します。

（試される場合はアカウント登録を行い、[APPIDを取得する](https://openweathermap.org/)必要があります。）

1. 事前準備

    httpsでアクセスするので、InterSystems製品側の設定として、SSL構成（クライアント）を作成します。

    **管理ポータル > システム管理 > セキュリティ > SSL/TLS構成** の画面で「構成名」に任意名を記入して保存をクリックするだけです（他のパラメータはデフォルト値で作成します）。

    設定図例は、コミュニティの記事：[%Net.HttpRequest クラスを使用して https のアクセスでエラーが発生したときに確認したいこと](https://jp.community.intersystems.com/node/483106) が参考になります。ぜひご参照ください。

2. %Net.HttpRequestのインスタンスを生成しサーバやパスの設定を行う

    アクセスする*Webサーバ*は**Serverプロパティ**に、*パスの情報*は**Locationプロパティ**に、*HTTPSを使用する場合*は**Httpsプロパティに1を設定**します。
    事前準備で作成した*SSL構成名*は**SSLConfigurationプロパティ**に設定します。

    ContentTypeはContentTypeプロパティ、charsetは、CharSetプロパティに設定します。

    ```
    set req=##class(%Net.HttpRequest).%New()
    set req.Server="api.openweathermap.org"
    set req.Location="/data/2.5/weather"
    set req.SSLConfiguration="webapi"  //SSL構成名を設定します
    set req.Https=1
    set req.ContentType="application/json"
    set req.ContentCharset="utf-8"
    ```

3. クエリパラメータを設定する。

    クエリパラメータの指定は、SetParam(パラメータ名,値)メソッドを使用します。

    今回使用するAPIには3つのパラメータがあります。

    パラメータ|値|意味
    --|--|--
    lang|ja|言語指定で日本語を指定
    q|長野市|天気を取得したいエリア名を指定
    appid|APPID|事前取得したAPPIDを指定
    units|metric|気温を摂氏で返します

    実行例は以下の通りです。

    ```
    do req.SetParam("q","長野市")
    do req.SetParam("lang","ja")
    do req.SetParam("appid","ここに取得したAPPIDを指定")
    do req.SetParam("units","metric")
    ```

4. GET要求実行！

    ```
    set st=req.Get() //戻り値が1なら成功
    ```

    戻り値が1以外の場合は、GET要求が失敗しているのでエラーの原因を確認します。

    ```
    write $SYSTEM.Status.GetErrorText(st)
    ```
    
    $SYSTEM特殊変数は%SYSTEMパッケージ以下クラスの呼び出しが行える変数で、上記実行例では、%SYSTEM.Statusクラスの [GetErrorText()](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status#GetErrorText) メソッドを実行しています。

5. HTTP応答の操作

    4でGET要求が成功すると、%Net.HttpRequestインスタンスのHttpResponseプロパティにHTTP応答がセットされます。

    HttpResponseプロパティは[%Net.HttpResponse](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.HttpResponse) のインスタンスで、DataプロパティにHTTPヘッダ以降の情報が含まれています。

    Dataプロパティはストリームなので、HTTP応答を取り出すときは、Read()メソッドが利用できます。

    なお、一度Read()を実行するとストリームの末尾のポジションに移動するので、先頭ポジションに戻るにはRewind()を使用してください。

    ```
    USER>write res.Data.Read()
    {"coord":{"lon":138.1,"lat":36.644},"weather":[{"id":802,"main":"Clouds","description":"雲","icon":"03n"}],"base":"stations","main":{"temp":11.03,"feels_like":1 0.28,"temp_min":11.03,"temp_max":12.32,"pressure":1014,"humidity":80,"sea_level":1014,"grnd_level":919},"visibility":10000,"wind":{"speed":0.98,"deg":356,"gust":1.54},"clouds":{"all":38},"dt":1667467705,"sys":{"type":2,"id":2030915,"country":"JP","sunrise":1667423549,"sunset":1667461785},"timezone":32400,"id":1856215,"name":"Nagano","cod":200}
    ```

    JSON文字列が返送されるので、InterSystems製品内のJSONオブジェクト（ダイナミックオブジェクトと呼びます）として操作するには、以下のように実行します。
    
    ```
    set json={}.%FromJSON(req.HttpResponse.Data)
    ```

    JSONオブジェクトの中身を簡単に確認するには、zwriteコマンドを使うと便利です。

    ```
    USER>zwrite json
    json={"coord":{"lon":138.1,"lat":36.644},"weather":[{"id":802,"main":"Clouds","description":"雲","icon":"03n"}],"base":"stations","main":{"temp":11.03,"feels_li ke":10.28,"temp_min":11.03,"temp_max":12.32,"pressure":1014,"humidity":80,"sea_level":1014,"grnd_level":919},"visibility":10000,"wind":{"speed":0.98,"deg":356,"gust":1.54},"clouds":{"all":38},"dt":1667467705,"sys":{"type":2,"id":2030915,"country":"JP","sunrise":1667423549,"sunset":1667461785},"timezone":32400,"id":1856215,"name":"Nagano","cod":200}  ; <DYNAMIC OBJECT>
    ```
    現時点の天気は weatherプロパティ以下のJSON配列で取得できます。

    ```
    USER>write json.weather.%Get(0).description
    雲
    USER>write json.weather.%Get(0).main
    Clouds
    ```

    最低気温、最高気温は mainプロパティ以下オブジェクトで取得できます。

    ```
    USER>write json.main."temp_min"
    11.03
    USER>write json.main."temp_max"
    12.32
    ```


＜関連情報＞

- InterSystems製品内でのJSONの操作については、自習用ビデオがあります。ぜひご参照ください。
    - [【はじめてのInterSystems IRIS】セルフラーニングビデオ：アクセス編：IRIS での JSON の操作](https://jp.community.intersystems.com/node/480106)

- GET要求のサンプル
    - [ObjectScript言語でイメージファイルをWEBサーバからダウンロードする方法](https://jp.community.intersystems.com/node/498786)
    - [REST/JSON の簡単なサンプルご紹介](https://jp.community.intersystems.com/node/496376)


## HTTPのPOST要求を実行したい

基本的な操作は [HTTPのGET要求を実行したい](#httpのget要求を実行したい) と同様です。

POST要求時に渡すBodyは、[%Net.HttpRequest](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.HttpRequest) クラスの
[EntityBodyプロパティ](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.HttpRequest#EntityBody)に登録します。

[EntityBodyプロパティ](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.HttpRequest#EntityBody)は、ストリームのタイプなので、Bodyの中身を指定する場合は、Write()メソッドを使用します。

JSON文字列をJSONのダイナミックオブジェクトとしてObjectScriptで作成した場合は、EntityBodyはストリームなので以下のようにダイナミックオブジェクトをストリームにコピーすることができます。

例）
```
USER>set req=##class(%Net.HttpRequest).%New()
 
USER>set json={}
 
USER>set json.Test="これはテストです"
 
USER>set json.Status="OK"
 
USER>do json.%ToJSON(req.EntityBody)
 
USER>write req.EntityBody.Read()
{"Test":"これはテストです","Status":"OK"}
```

以下の例は、Teamsの [Incoming Webhook](https://learn.microsoft.com/ja-jp/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook) に通知するPOST要求送信時の例です。

Webhook作成方法については、[マイクロソフトのドキュメント](https://learn.microsoft.com/ja-jp/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook)をご参照ください

> 以下例の Serverプロパティと Locationプロパティには、Incoming Webhook作成時に自動生成されるURLを指定します。

```
    set req=##class(%Net.HttpRequest).%New()
    set req.Server="xxx.webhook.office.com"
    set req.Location="incoming webhook作成時に生成されるURLのパスを指定"
    set req.SSLConfiguration="webapi"
    set req.Https=1
    set req.ContentType="application/json"
    set req.ContentCharset="utf-8"
    //以下Teamsに送信するメッセージ作成（JSONオブジェクトのtextプロパティにマークダウンで書いたメッセージを送信できます）
    set json={}
    set message="#★Incoming Webhookのテスト★"
    set message=message_$CHAR(13,10)_"**メッセージ送信しました**"
    set json.text=message
    //BODY に作成したJSONを設定
    do json.%ToJSON(req.EntityBody)
    //POST要求送信
    set st=req.Post()
    //HTTPステータスコード確認
    write req.HttpResponse.StatusCode,!
    //エラーがない時は空を出力
    write $SYSTEM.Status.GetErrorText(st)
```
上記実行の結果、以下のようなメッセージが通知されます。

![](/images/IncomingWebhookSample.png)


## HTTP要求時の認証の指定

### - HTTP要求時Basic認証をしたい

Basic認証を行うため、ヘッダ：Authorizationにユーザ名とパスワードの組み合わせをBase64でエンコードした文字列を指定します。

手順は以下の通りです。

1. ユーザ名とパスワードをコロンで結合し、Base64でエンコードした文字列を用意する

    以下の例は、ユーザ名が _system でパスワードが SYS をコロンで結合し、Base64でエンコードした内容が変数base64にセットされます。

    ```
    set base64=$SYSTEM.Encryption.Base64Encode("_system:SYS")
    ```

2. ヘッダ：Authorizationに設定する。

    ヘッダ：Authorization に "Basic "とBase64でエンコードしたユーザ名とパスワードを結合し設定します。

    ```
    set req=##class(%Net.HttpRequest).%New()
    do req.SetHeader("Authorization","Basic "_base64)
    //以下省略
    ```



### - HTTP要求時Bearer認証をしたい

Bearer認証を行うため、ヘッダ：Authorizationにトークンを設定します。

設定時、 Authorization: Bearer `<token>` となるように設定します。

手順は以下の通りです。

```
set req=##class(%Net.HttpRequest).%New()
set token="Bearer "_<トークン>
do request.SetHeader("Authorization",token)  
```


## FTPサーバにPUT／GET／DELETEしたい

[%Net.FtpSession](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.FtpSession#SetDirectory) を使用します。

共通処理は以下の通りです。

例でご紹介するFTPセッション用メソッド（Connect()/Ascii()/Binary()/SetDirectory()/Logout()/Store()/Retrieve() etc..）の戻り値は、1または0で返ります。

戻り値が1の場合は接続成功です。0の場合は、ReturnMessageプロパティの値をチェックしてください。


1. インスタンス生成

    ```
    set ftp=##class(%Net.FtpSession).%New()
    ```

2. 接続

    第1引数はサーバ名、第2引数はユーザ名、第3引数はパスワードを指定します。
    ```
    set st=ftp.Connect("192.168.0.7","user01","p@ssword")
    ```
    ※第4引数にポートを指定できますがデフォルトで21が使用されます。

    戻り値が1の場合は接続成功です。0の場合は、以下プロパティの値をチェックしてください。

    ```
    write ftp.ReturnMessage
    ```

3. ASCII/Binaryの切り替え

    ASCIIの指定は以下の通りです。
    ```
    write ftp.Ascii() 
    ```

    Binaryの指定は以下の通りです。
    ```
    write ftp.Binary()
    ```

4. ディレクトリ移動

    ```
    write ftp.SetDirectory("/test")
    ```

5. ログアウト
    ```
    write ftp.Logout()
    ```


＜関連情報＞
- [イメージファイルを FTP サーバからアップロード／ダウンロードする方法ご紹介](https://jp.community.intersystems.com/node/496381)

- [%Net.FtpSession クラスを使用してファイルサイズを取得する方法](https://jp.community.intersystems.com/node/491956)

PUT／GET／DELETEの手順については、以下の例をご参照ください。


### - FTPのPUTをObjectScriptで実行する

基本の操作は[FTPサーバにPUT／GET／DELETEしたい](#ftpサーバにputgetdeleteしたい)をご参照ください。

以降の説明では、PUTを行うときに使用する[Store()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.FtpSession#Store)の使い方をご紹介します。

手順は以下の通りです。

1. PUT対象ファイルのストリームを用意する。

    文字列の場合は%Stream.FileCharacterクラスを利用し、それ以外は%Stream.FileBinary()クラスを利用してインスタンスを作成します。

    ＜文字列ファイルの例＞
    ```
    set fstream=##class(%Stream.FileCharacter).%New()
    do fstream.LinkToFile("c:\temp\ftptest.txt")
    ```
    ※ LinkToFile()の引数にはPUTしたいファイルをフルパスで指定します。

    ＜バイナリファイルの例＞
    ```
    set fstream=##class(%Stream.FileBinary).%New()
    do fstream.LinkToFile("c:\temp\imagesample.png")
    ```
    ※ LinkToFile()の引数にはPUTしたいファイルをフルパスで指定します。

    ファイルのストリームクラスの使い方詳細は[ファイルの入出力](#ファイルの入出力)もご参照ください。

2. Store()メソッド実行

    戻り値が1の場合は接続成功です。0の場合は、ReturnMessageプロパティの値をチェックしてください。

    第1引数はファイル名を指定します。第2引数は 1.で作成したストリームのインスタンスを指定します（必要に応じてFTPサーバのディレクトリ移動：SetDirectory()を行ってから実行します）。
    ```
    Write ftp.Store("imagesample.png",fstream)
    ```

#### - 例1：テキストファイルのPUT

```
set fstream=##class(%Stream.FileCharacter).%New()
do fstream.LinkToFile("c:\temp\ftptest.txt")
set ftp=##class(%Net.FtpSession).%New()
set st=ftp.Connect("192.168.0.7","user01","p@ssword")
write ftp.Ascii()
set ftp.TranslateTable="UTF8"
write ftp.SetDirectory("/test")
write ftp.Store("ftptest.txt",fstream)
write ftp.ReturnMessage  // Store()メソッドの戻りが1の場合は「Transfer complete.」が設定されます
write ftp.Logout()
```

#### - 例2：バイナリファイルのPUT

```
set fstream=##class(%Stream.FileBinary).%New()
do fstream.LinkToFile("c:\temp\imagesample.png")
set ftp=##class(%Net.FtpSession).%New()
set st=ftp.Connect("192.168.0.7","user01","p@ssword")
write ftp.Binary()
write ftp.SetDirectory("/test")
write ftp.Store("imagesample.png",fstream)
write ftp.ReturnMessage   //Store()の戻り値が1の場合「Transfer complete.」が設定されます
write ftp.Logout()
```

### - FTPのGETをObjectScriptで実行する

基本の操作は[FTPサーバにPUT／GET／DELETEしたい](#ftpサーバにputgetdeleteしたい)をご参照ください。

以降の説明では、GETを行うときに使用する[Retrieve()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.FtpSession#Retrieve)の使い方をご紹介します。

手順は以下の通りです。

1. GET対象ファイルのストリームを用意する。

    文字列の場合は%Stream.FileCharacterクラスを利用し、それ以外は%Stream.FileBinary()クラスを利用してインスタンスを作成します。
    LinkToFile()メソッドで指定するファイルフルパスはGET後に配置したいパス・ファイル名で指定します。

    ＜文字列ファイルの例＞
    ```
    set fstream=##class(%Stream.FileCharacter).%New()
    do fstream.LinkToFile("c:\temp2\GETText.txt")
    ```

    ＜バイナリファイルの例＞
    ```
    set fstream=##class(%Stream.FileBinary).%New()
    do fstream.LinkToFile("c:\temp2\GetImage.png")
    ```
    ファイルのストリームクラスの使い方詳細は[ファイルの入出力](#ファイルの入出力)もご参照ください。

2. Retrieve()メソッド実行

    戻り値が1の場合は接続成功です。0の場合は、ReturnMessageプロパティの値をチェックしてください。

    第1引数はFTPサーバ上のファイル名を指定します。第2引数は 1.で作成したストリームのインスタンスを指定します（必要に応じてFTPサーバのディレクトリ移動：SetDirectory()を行ってから実行します）。
    ```
    write ftp.Retrieve("ファイル名",fstream)
    ```

#### - 例1：テキストファイルのGET

```
set fstream=##class(%Stream.FileCharacter).%New()
do fstream.LinkToFile("c:\temp2\GETText.txt")
//Windows：UTF8で保存したい場合は文字コード指定（WindowsでのファイルIOのデフォルト文字コードはSJIS）
set fstream.TranslateTable="UTF8"
set ftp=##class(%Net.FtpSession).%New()
set st=ftp.Connect("192.168.0.7","user01","p@ssword")
write ftp.Ascii()
set ftp.TranslateTable="UTF8"
write ftp.SetDirectory("/test")
write ftp.Retrieve("ftptest.txt",fstream)
write ftp.ReturnMessage  // メソッドの戻りが1の場合は「Transfer complete.」が設定されます
write ftp.Logout()
write fstream.%Save()  // ストリームの保存
```

#### - 例2：バイナリファイルのGET
```
set fstream=##class(%Stream.FileBinary).%New()
do fstream.LinkToFile("c:\temp2\GETImage.png")
set ftp=##class(%Net.FtpSession).%New()
set st=ftp.Connect("192.168.0.7","user01","p@ssword")
write ftp.Binary()
write ftp.SetDirectory("/test")
write ftp.Retrieve("imagesample.png",fstream)
write ftp.ReturnMessage  // メソッドの戻りが1の場合は「Transfer complete.」が設定されます
write ftp.Logout()
write fstream.%Save()  // ストリームの保存
```

### - FTPのDELETEをObjectScriptで実行する

基本の操作は[FTPサーバにPUT／GET／DELETEしたい](#ftpサーバにputgetdeleteしたい)をご参照ください。

以降の説明では、[Delete()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.FtpSession#Delete) の使用例をご紹介します。


```
set ftp=##class(%Net.FtpSession).%New()
set st=ftp.Connect("192.168.0.7","user01","p@ssword")
write ftp.SetDirectory("/test")
write ftp.Delete("imagesample.png")
write ftp.ReturnMessage  // メソッドの戻りが1の場合は「DELE command successful.」が設定されます
write ftp.Logout()
```
## メールの送受信

メールの送信には [%Net.SMTPクラス](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.SMTP)、メールの受信には [%Net.POP3クラス](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.POP3)を利用します。
メール本文には、[%Net.MailMessageクラス](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.MailMessage)、メール送付時の認証情報には、[%Net.Authenticatorクラス](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.Authenticator)を使用します。


＜ご参考＞ドキュメント：[電子メールの送受信](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GNET_email)

### - メール送信のサンプル

以下の記事をご参照ください

- [OAuth 2.0 を利用して IRIS から Gmail を送信する](https://jp.community.intersystems.com/node/519306)
- [SSL/TLS を使用しているメールサーバへメールを送信するコードサンプルご紹介](https://jp.community.intersystems.com/node/515066)

### - メール受信のサンプル

手順は以下の通りです。

1. pop3用インスタンスの生成とSSLの指定

    ```
    set pop3=##class(%Net.POP3).%New()
    // 管理ポータルで設定したSSL構成名を指定
    set pop3.SSLConfiguration="webapi"
    // SSLなので0を指定します
    set pop3.UseSTARTTLS=0 
    ```
    ※SSL構成名の設定図例については、コミュニティの記事：[%Net.HttpRequest クラスを使用して https のアクセスでエラーが発生したときに確認したいこと](https://jp.community.intersystems.com/node/483106) をご参照ください。

2. 接続
    [Connect()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.POP3#Connect)を使用します。

    - 第1引数：サーバ名
    - 第2引数：ユーザ名
    - 第3引数：パスワード
    - 第4引数：OAuth2利用時、アクセストークンを指定できます
    - 戻り値：%Statusで返されるため、1以外が戻る場合はエラーです。

        エラー時は、以下メソッドを使用してエラー情報を確認してください。
        ```
        write $SYSTEM.Status.GetErrorText(status)
        ```
    
    実行例は以下の通りです。
    ```
    set pop3.port=995  //ポート番号の指定
    set status=pop3.Connect(servername,user,pass,AccessToken)
    ```

3. メールボックスのメッセージ数とバイト数の取得

    [GetMailBoxStatus()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.POP3#GetMailBoxStatus) で確認できます。

    - 第1引数：参照渡し（引数前にピリオドを付けます）でメッセージ数取得用引数指定
    - 第2引数：参照渡し（引数前にピリオドを付けます）でバイト数取得用引数指定

    実行例は以下の通りです。
    ```
    set status=pop3.GetMailBoxStatus(.count,.size)
    ```

4. メール本文などを取得

    [Fetch()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.POP3#Fetch)または、[FetchMessage()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.POP3#FetchMessage)を使用します。

    以下の例は、FetchMessage()を使用しています。

    ```
    set status=pop3.FetchMessage(1,.from,.to,.date,.subject,.msize,.mheader,.mailmessage,0)
    ```
    第2～8引数は参照渡しで指定します（引数前にピリオドを付与して引数を指定します）。

    - 第1引数：メッセージ番号を指定（1は一番古いメッセージ）
    - 第2引数：差出人（参照渡し）
    - 第3引数：送付先（参照渡し）
    - 第4引数：受信日付（参照渡し）
    - 第5引数：件名（参照渡し）
    - 第6引数：サイズ（参照渡し）
    - 第7引数：メッセージヘッダ（参照渡し、Arrayコレクションで返る）
    - 第8引数：メッセージ（参照渡し：%Net.MailMessageで返る）
    - 第9引数：削除（1：の場合は削除、0は削除しない）

    取得したメール本文は以下のように情報を取得できます。

    メッセージばマルチパートの場合、Partsプロパティ
    ```
    //本文取得：MultiPartの場合Partsプロパティに複数の%Net.MailMessagePartのインスタンスが格納
    if mailmessage.IsMultiPart {
        for cn=1:1:mailmessage.Parts.Count() { 
            while 'mailmessage.Parts.GetAt(cn).TextData.AtEnd {
                write mailmessage.Parts.GetAt(cn).TextData.ReadLine(),!
            }
        }
    }
    else {
        // MultiPartメッセージじゃない場合
        while '(mailmessage.TextData.AtEnd) { 
            write mailmessage.TextData.ReadLine(),!
        }
    }

    // 削除対象メールを削除しない場合の終了方法
    set status=pop3.QuitAndRollback()
    write status
    ```

## %Statusのエラーが戻ってきたら

%Stautsのタイプを使用している場合、処理が成功すると1を返し、失敗するとエラーステータスが戻ります。

エラーステータスは、1つ以上のエラーコードとテキストメッセージを含む内部文字列として返されます。


%Statusは、様々なシステムクラスのメソッドの戻り値に指定されています。
> 例）%Net.HttpRequestの[Get()](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.HttpRequest#Get)や[Post()](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.HttpRequest#Post)メソッドなど、%Net.SMTPクラスの[Send()](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Net.SMTP#Send)メソッドなど

実行例では、サンプルクラス定義：[CookBook.Person](/CookBook/Person.cls)を使用してエラーステータスを作成します。

プロパティのタイプに合わないデータを設定し、%Save()を実行した結果のエラーステータスを利用して確認します。

> 永続クラスの保存の時に使用する %Save()メソッドは戻り値に%Statusが設定されています。 ご参考：[%Save()メソッドのクラスリファレンス](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Library.Persistent#%25Save)


### - %Statusのエラーステータスを出力する


ターミナルでエラーステータスをそのまま表示した場合は以下のようになります。
> メモ：%Save()の戻り値を設定する変数名は任意名です。
```
USER>set p=##class(CookBook.Person).%New()
 
USER>set p.Birthday="文字列を入れるとエラーです"  // Birthdayのタイプは%Date
 
USER>set status=p.%Save()
 
USER>write status
'eW[R0eQ00h0¨0é0ü0g0Y0Û&zBirthdayIsValid+1^CookBook.Person.1USER­*e^z BirthdayIsValid+1^CookBook.Person.1^1)e^%ValidateObject+3^CookBook.Person.1^4.e^%SerializeObject+3^%Library.Persistent.1^1#e^%Save+4^%Library.Persistent.1^2e^^^00 ~ªCookBook.Person:BirthdayeW[R0eQ00h0¨0é0ü0g0Y0<EmbedErr+1^%occS ystemUSER^EmbedErr+1^%occSystem^1
USER>
```

人が読める文字で出力する場合、以下のいずれかのメソッドを使用します。
- [%SYSTEM.OBJクラス](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.OBJ)の[DisplayError()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.OBJ#DisplayError)
- [%SYSTEM.Statusクラス](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status)の[DisplayError()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status#DisplayError)

%SYSTEMパッケージ以下クラスは[$SYSTEM](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RCOS_vsystem)特殊変数を利用して実行できます。

以下、それぞれのターミナル実行例です。

 [%SYSTEM.OBJクラス](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.OBJ)の[DisplayError()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.OBJ#DisplayError)はカレントデバイスにエラーステータスのエラーメッセージを出力します。
 
 ```
 USER>do $SYSTEM.OBJ.DisplayError(status)
 
エラー #7207: データタイプ値 '文字列を入れるとエラーです' は妥当な数値ではありません
  > エラー #5802: プロパティ 'CookBook.Person:Birthday' のデータタイプ妥当性検証が失敗しました。値は "文字列を入れるとエラーです" です。
 ```

 このメソッドの引数は省略できます。省略した場合、直近で発生したエラーステータスを利用してエラーメッセージを出力します。

```
USER>do $SYSTEM.OBJ.DisplayError()
```

直近で発生したエラーステータスは、%objlasterror変数に格納されます（この変数はシステムにより設定される変数です）。

直前のエラーではないことにご注意ください。
> 直前の操作が成功していても、%objlasterror変数の中身は初期化されることはありません。直近で発生したエラーステータスが設定されたままです。


[%SYSTEM.Statusクラス](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status)の[DisplayError()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status#DisplayError)の例は以下の通りです。

```
USER>do $SYSTEM.Status.DisplayError(status)

エラー #7207: データタイプ値 '文字列を入れるとエラーです' は妥当な数値ではありません
  > エラー #5802: プロパティ 'CookBook.Person:Birthday' のデータタイプ妥当性検証が失敗しました。値は "文字列を入れるとエラーです" です。
```
%SYSTEM.OBJクラスのメソッドと同じ名称ですが、%SYSTEM.Statusクラスのメソッドは、引数を省略できません。

### - %Statusのエラーステータスからエラー文字列を取得する

[%SYSTEM.Statusクラス](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status)の[GetErrorText()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status#GetErrorText)を使用するとエラー文字列を戻り値で取得できます。

※エラーの内容は[%Statusのエラーステータスを出力する](#--statusのエラーステータスを出力する)と同様です。

このメソッドは戻り値にエラーメッセージを文字で返すので、WRITE文の実行例でご紹介します。
```
USER>write $SYSTEM.Status.GetErrorText(status)
エラー #7207: データタイプ値 '文字列を入れるとエラーです' は妥当な数値ではありません
  > エラー #5802: プロパティ 'CookBook.Person:Birthday' のデータタイプ妥当性検証が失敗しました。値は "文字列を入れるとエラーです" です。
```

### - エラーステータスかどうか確認する
[%SYSTEM.Statusクラス](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status)の[IsError()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status#IsError)を使用すると、エラーステータスの時は1、成功しているときは0を返します。

※エラーの内容は[%Statusのエラーステータスを出力する](#--statusのエラーステータスを出力する)と同様です。

実行例は以下の通りです。（例では、WRITE文で戻り値を出力しています）
```
USER>write $SYSTEM.Status.IsError(status)
1
```

逆の確認方法で、[IsOK()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status#IsOK)もあります。

成功している場合は1を返し、エラーステータスの場合は0を返します。

エラーステータスの入った変数を指定した場合の実行例は以下の通りです。（例では、WRITE文で戻り値を出力しています）

```
USER>write $SYSTEM.Status.IsOK(status)
0
```

### - ユーザ作成のエラーステータス

任意のエラーメッセージを指定したエラーステータスを作成できます。


[%SYSTEM.Statusクラス](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status)の [Error()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status#Error)を使用します。

Error()メソッドの第1引数にはエラー番号を指定できます。

ユーザ定義のカスタムエラーは、83 または 5001 をエラー番号として指定します。

※一般的なエラーメッセージについて詳細は、[ドキュメント：一般的なエラーメッセージ](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RERR_gen)をご参照ください。

```
USER>set errtxt="ユーザ定義の任意エラー文字列も追加できます"
 
USER>set usererr=$SYSTEM.Status.Error(83,errtxt)
 
USER>write $SYSTEM.Status.GetErrorText(usererr)
エラー #83: エラーコード = ユーザ定義の任意エラー文字列も追加できます
USER>set usererr=$SYSTEM.Status.Error(5001,errtxt)
 
USER>write $SYSTEM.Status.GetErrorText(usererr)
エラー #5001: ユーザ定義の任意エラー文字列も追加できます
```

※ユーザ定義のエラーステータスの作り方は、[ドキュメント](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_errors#GCOS_errors_statcodes_creating)にも例があります。




### - 既にあるエラーステータスに他のエラーステータスを追加したい

既にエラーステータスがある状態で、他のエラーステータスを追加するには、[%SYSTEM.Statusクラス](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status)の[AppendStatus()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status#AppendStatus)を使用します。

例文：`set newstatus=$SYSTEM.Status.AppendStatus(エラーステータス1,エラーステータス2)`

以下のターミナル実行例では、変数 status1 のエラーステータスに、変数 status2 のエラーステータスを追加しています。

[AppendStatus()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status#AppendStatus)実行後、2つのエラーが含まれるエラーステータスが返されます。

```
USER>set p=##class(CookBook.Person).%New()
 
USER>set p.Birthday="文字を入力するとエラー"
 
USER>set status1=p.%Save()
 
USER>set status2=$SYSTEM.Status.Error(5001,"＊＊ユーザエラー作成＊＊")
 
USER>set status1=$SYSTEM.Status.AppendStatus(status1,status2)
 
USER>write $SYSTEM.Status.GetErrorText(status1)
エラー #7207: データタイプ値 '文字を入力するとエラー' は妥当な数値ではありません
  > エラー #5802: プロパティ 'CookBook.Person:Birthday' のデータタイプ妥当性検証が失敗しました。値は "文字を入力するとエラー" です。
エラー #5001: ＊＊ユーザエラー作成＊＊
```

### - エラーステータスを変数に設定したい

エラーステータスの詳細を変数に設定するには、[%SYSTEM.Statusクラス](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status)の[DecomposeStatus()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status#DecomposeStatus)を使用します。

※[既にあるエラーステータスに他のエラーステータスを追加したい](#--既にあるエラーステータスに他のエラーステータスを追加したい)で作成した2つのエラーステータスを利用した例でご紹介します。

第1引数はエラーステータス、第2引数は設定した変数名を参照渡しで指定します。

変数直下にエラー件数が設定され、第1サブスクリプトにはエラー番号、第2サブスクリプトにはエラーの詳細情報を示す配列が設定されます。

```
USER>write $SYSTEM.Status.DecomposeStatus(status1,.val)
1
USER>zwrite val
val=2
val(1)="エラー #7207: データタイプ値 '文字を入力するとエラー' は妥当な数値ではありません"_$c(13,10)_"  > エラー #5802: プロパティ 'CookBook.Person:Birthday' のデータタイプ妥当性検証が失敗しました。値は ""文字を入力するとエラー"" です。"
val(1,"caller")="zBirthdayIsValid+1^CookBook.Person.1"
val(1,"code")=7207
val(1,"dcode")=7207
val(1,"domain")="%ObjectErrors"
val(1,"embeddederror")=1
val(1,"embeddederror",1)="0 "_$lb($lb(5802,"CookBook.Person:Birthday","文字を入力するとエラー",,,,,,,$lb("EmbedErr+1^%occSystem","USER",$lb("e^EmbedErr+1^%occSystem^1"))))/* エラー #5802: プロパティ 'CookBook.Person:Birthday' のデータタイプ妥当性検証が失敗しました。値は "文字を入力するとエラー" です。 */
val(1,"embeddedstatus")="0 "_$lb($lb(5802,"CookBook.Person:Birthday","文字を入力するとエラー",,,,,,,$lb("EmbedErr+1^%occSystem","USER",$lb("e^EmbedErr+1^%occSystem^1"))))/* エラー #5802: プロパティ 'CookBook.Person:Birthday' のデータタイプ妥当性検証が失敗しました。値は "文字を入力するとエラー" です。 */
val(1,"namespace")="USER"
val(1,"param")=1
val(1,"param",1)="文字を入力するとエラー"
val(1,"stack")=$lb("e^zBirthdayIsValid+1^CookBook.Person.1^1","e^%ValidateObject+3^CookBook.Person.1^4","e^%SerializeObject+3^%Library.Persistent.1^1","e^%Save+4^%Library.Persistent.1^2","e^^^0")
val(1,"tail")="0 "_$lb($lb(5001,"＊＊ユーザエラー作成＊＊",,,,,,,,$lb(,"USER",$lb("e^zError+1^%SYSTEM.Status.1^1","e^^^0"))))/* エラー #5001: ＊＊ユーザエラー作成＊＊ */
val(2)="エラー #5001: ＊＊ユーザエラー作成＊＊"
val(2,"caller")="zError+1^%SYSTEM.Status.1"
val(2,"code")=5001
val(2,"dcode")=5001
val(2,"domain")="%ObjectErrors"
val(2,"namespace")="USER"
val(2,"param")=1
val(2,"param",1)="＊＊ユーザエラー作成＊＊"
val(2,"stack")=$lb("e^zError+1^%SYSTEM.Status.1^1","e^^^0")
```



### - エラーステータスからSQLエラーに変更したい

InterSystems 製品では、エラーステータスとSQLエラーでコードが異なります。
- [一般的なエラーメッセージ](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RERR_gen)
- [SQLエラー](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=RERR_sql)

ルーチンやメソッドの処理の中で、エラーステータスからSQLエラーに変更する必要がある場合は、[%SYSTEM.Statusクラス](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status)の[StatusToSQLCODE()メソッド](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status#StatusToSQLCODE)を使用します。

- 第1引数にエラーステータスを指定します。
- 第2引数に参照渡しでSQLエラーのメッセージが設定される引数を指定します。
- 戻り値にSQLエラーのコードが返ります

`set SQLCODE=$SYSTEM.Status.StatusToSQLCODE(status,.message)`

実行例は以下の通りです。

```
USER>set p=##class(CookBook.Person).%New()
 
USER>set p.Birthday="文字列を入力するとエラー"
 
USER>set status=p.%Save()
 
USER>write $SYSTEM.Status.StatusToSQLCODE(status,.message)
-400
USER>write message
データタイプ値 '文字列を入力するとエラー' は妥当な数値ではありません
  > エラー #5802: プロパティ 'CookBook.Person:Birthday' のデータタイプ妥当性検証が失敗しました。値は "文字列を入力するとエラー" です。
```

## ストアドプロシージャの呼び出し元に正しくエラーを返したい

ストアドプロシージャが呼び出されるときに自動生成されるインスタンスが格納された**変数：%sqlcontext** を使用します。

※この変数は、[%Library.SQLProcContext](https://docs.intersystems.com/irisforhealth20221/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Library.SQLProcContext)のインスタンスです。

- エラーコードは、**%sqlcontext.%SQLCODE** プロパティに設定します。
- エラーメッセージは、**%sqlcontext.%Message** プロパティに設定します。

### - 埋め込みSQL実行時のエラーをストアド呼び出し元に返したい

埋め込みSQL **&sql()** 実行時のエラーは、**変数SQLCODE**、エラーメッセージは**変数%msg** に設定されるので、以下のように設定します。

```
set %sqlcontext.%SQLCODE=SQLCODE
set %sqlcontext.%Message=%msg
```

記述例は以下の通りです。

```
ClassMethod EmbeddedSQL() [ SqlProc ]
{
    #dim %sqlcontext As %Library.SQLProcContext
    //何らかの処理実行
    //埋め込みSQLの実行失敗の例
    &sql(INSERT INTO CookBook.Person (Name,Birthday) VALUES('テスト太郎','不正な値'))
    if SQLCODE<0 {
        set %sqlcontext.%SQLCODE=SQLCODE
        set %sqlcontext.%Message=%msg
    }
}
```
ODBCクライアントから実行した結果は以下の通りです（%sqlcontextの設定がない場合、エラーは返りません）。
```
SQL実行中に以下のエラーが発生しました。
ｴﾗｰｺｰﾄﾞ：104  [Iris ODBC][State : 23000][Native Code 104]
[C:\kit\cse161\cse161\cse.exe]
[SQLCODE: <-104>:<INSERTでフィールド妥当性検証が失敗したか、DisplayToLogical または OdbcToLogical での値の変換に失敗しました>]
[Location: <SPFunction>]
[%msg: <フィールド 'CookBook.Person.Birthday' (値 '不正な値') の妥当性検証が失敗しました>]
SQLｽﾃｰﾀｽ：23000
```

### - ダイナミックSQLのエラーをストアド呼び出し元に返したい

[%SQL.Statement](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.Statement)クラスの[%Prepare()](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.Statement#%25Prepare)メソッドの実行でエラーが発生した場合は、%Statusのエラーが返るため、[エラーステータスからSQLエラーに変更したい](#--エラーステータスからSQLエラーに変更したい)にあるように、エラーステータスをSQLエラーとメッセージに変更し、**変数：%sqlcontext** を利用して操作できる以下プロパティに割り当てます。

```
set %sqlcontext.%SQLCODE=SQLコード
set %sqlcontext.%Message=エラーメッセージ
```
記述例は以下の通りです。
```
ClassMethod DynamicSQL1() [ SqlProc ]
{
    #dim %sqlcontext As %Library.SQLProcContext
    set sql="INSERT INTO CookBook.Person2 (Name,Birthday) VALUES(?,?)"
    set statement=##class(%SQL.Statement).%New()
    set status=statement.%Prepare(sql)

    if $SYSTEM.Status.IsError(status) {
        set SQLCODE=$SYSTEM.Status.StatusToSQLCODE(status,.message)
        set %sqlcontext.%SQLCODE=SQLCODE
        set %sqlcontext.%Message=message
    }
}
```
ODBCクライアントから実行した結果は以下の通りです（%sqlcontextの設定がない場合、エラーは返りません）。
```
SQL実行中に以下のエラーが発生しました。
ｴﾗｰｺｰﾄﾞ：30  [Iris ODBC][State : S0002][Native Code 30]
[C:\kit\cse161\cse161\cse.exe]
[SQLCODE: <-30>:<テーブルまたはビューが見つかりません>]
[Location: <SPFunction>]
[%msg: < テーブル 'COOKBOOK.PERSON2' が見つかりません>]
SQLｽﾃｰﾀｽ：S0002
```

> memo: エラーステータスがエラーであるかどうか確認する方法に、マクロを使用する方法もあります。`if $$$ISERR(ステータス) {}`

次に、[%Execute()](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.Statement#%25Execute)メソッド実行時にエラーが発生した場合、戻り値に [%SQL.StatementResult](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.StatementResult)のインスタンスが戻ります。戻り値のインスタンスの%SQLCODEプロパティと、%Messageプロパティを利用して **変数：%sqlcontext** に値を設定します。

```
set %sqlcontext.%SQLCODE=[%Execute()の戻り値].%SQLCODE
set %sqlcontext.%Message=[%Execute()の戻り値].%Message
```
記述例は以下の通りです。
```
ClassMethod DynamicSQL2() [ SqlProc ]
{
    #dim %sqlcontext As %Library.SQLProcContext
    #dim rset As %SQL.StatementResult
    set sql="INSERT INTO CookBook.Person (Name,Birthday) VALUES(?,?)"
    set statement=##class(%SQL.Statement).%New()
    set status=statement.%Prepare(sql)
    set rset=statement.%Execute("テスト太郎","不正な値")

    if rset.%SQLCODE<0 {
        set %sqlcontext.%SQLCODE=rset.%SQLCODE
        set %sqlcontext.%Message=rset.%Message
    }
}
```

ODBCクライアントから実行した結果は以下の通りです（%sqlcontextの設定がない場合、エラーは返りません）。
```
SQL実行中に以下のエラーが発生しました。
ｴﾗｰｺｰﾄﾞ：146  [Iris ODBC][State : S1000][Native Code 146]
[C:\kit\cse161\cse161\cse.exe]
[SQLCODE: <-146>:<入力された日付を妥当な日付論理値に変換できません>]
[Location: <SPFunction>]
[%msg: <Error: '不正な値' is an invalid ODBC/JDBC Date value>]
SQLｽﾃｰﾀｽ：S1000
```

## クラスメンバーの入力候補を出す方法

自動生成されるインスタンスや参照渡しの引数に設定されるインスタンス、戻り値で返ってくるインスタンスなどは、構文中にクラス名に対して##class()で指定する構文がないため、IDE内で入力候補が出てきません。

そんな時は、**#dim** を以下のように利用します。

メソッドやルーチンで、対象となる変数を使用する前に記述します。
```
#dim 使用する変数 As クラス名
```
例えば、ダイナミックSQLで使用する%SQL.Statementクラスの%Execute()メソッドは、実行結果を [%SQL.StatementResult](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.StatementResult) のインスタンスとして戻り値で返します。

ルーチンやメソッド内で以下のように #dim を利用して実行結果の変数に対してどんなインスタンスが返ってくるのか明記すると、クラスメンバを入力候補に出すように変わります。

```
    #dim rset As %SQL.StatementResult
    set sql="INSERT INTO CookBook.Person (Name,Birthday) VALUES(?,?)"
    set statement=##class(%SQL.Statement).%New()
    set status=statement.%Prepare(sql)
    set rset=statement.%Execute("テスト太郎","不正な値")

    if rset.%SQLCODE<0 {
        set %sqlcontext.%SQLCODE=rset.%SQLCODE
        set %sqlcontext.%Message=rset.%Message
    }
```

## メソッドやルーチンでSQLを実行する場合の日付の取り扱い

メソッドやルーチンでSQLを実行する場合、日付や時刻は内部値（論理モード）で実行されます。

内部日付から表示日付、表示日付から内部日付の変換に便利な方法を以下解説します。

### - [%SYSTEM.SQL.Functions](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.SQL.Functions)クラスにあるSQL関数を使用する

※お使いの製品のバージョンで、[%SYSTEM.SQL.Functions](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.SQL.Functions)クラスが存在しない場合は、[%SYSTEM.SQL](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.SQL)クラスにある同じ名称のメソッドをご利用ください。

1. 表示形式から内部形式への変換

[%SYSTEM.SQL.Functions.TODATE()](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.SQL.Functions#TODATE)メソッドを利用します。

- 第1引数は変換対象の表示形式の日付を指定します。

- 第2引数には第1引数で指定した日付のフォーマットを指定します。

例）
```
USER>write $SYSTEM.SQL.Functions.TODATE("2022-11-21","YYYY-MM-DD")
66434
USER>write $SYSTEM.SQL.Functions.TODATE("20221121","YYYYMMDD")
66434
USER>write $ZDATEH("2022-11-21",3)  // $ZDATEH()関数で変換した値と同じ内部値を得られます
66434
USER>write $ZDATEH("2022-11-21",8)
66434
```

2. 内部形式から表示兵式への変換

[%SYSTEM.SQL.Functions.TOCHAR()](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.SQL.Functions#TOCHAR)メソッドを利用します。

- 第1引数は変換対象の内部日付の数値を指定します。

- 第2引数には第1引数をどのフォーマットの日付に変換するか指定します。

例）2022年11月21日の内部日付の値（66434）を使用した例
```
USER>write $SYSTEM.SQL.Functions.TOCHAR(66434,"YYYY年MM月DD日")
2022年11月21日
USER>write $SYSTEM.SQL.Functions.TOCHAR(66434,"YYYY-MM-DD")
2022-11-21
USER>write $SYSTEM.SQL.Functions.TOCHAR(66434,"YYYYMMDD")
20221121
```

### - ObjectScriptの関数を使用する

[日付の表示変換](#日付の表示変換)をご参照ください。


### - 埋め込みSQLの指示文を利用する

埋め込みSQLを実行している場合は、[#SQLCompile SELECT](https://docs.intersystems.com/irisforhealthlatest/csp/docbookj/DocBook.UI.Page.cls?KEY=GCOS_macros#GCOS_macros_mpp_lbSQLCompile_Select) の指示文が利用できます。

指定できる値は、以下の通りです。

- Display : カラムに定義されている形式に合わせて変換
- Logical : 論理値（内部数値）のまま
- ODBC : xDBC形式の表示モードへ変換

実行するSQL文より前に指示文を記述します。

指示文を使用しなかった場合のSELECTの表示結果は以下の通りです（ルーチンでもメソッドでも記述方法は同じです）。
```
ClassMethod SELECT0()
{
    &SQL(SELECT Birthday INTO :birthday FROM CookBook.Person WHERE ID=1)
    write "Birthdayの値＝",birthday
}
```

実行結果は以下の通り。
```
USER>do ##class(CookBook.Class1).SELECT0()
Birthdayの値＝57709
```

指示文でODBCを指定した場合の表示結果は以下の通りです。
```
ClassMethod SELECT1()
{
    #SQLCompile SELECT=ODBC
    &SQL(SELECT Birthday INTO :birthday FROM CookBook.Person WHERE ID=1)
    write "Birthdayの値＝",birthday
}
```
実行結果は以下の通り
```
USER>do ##class(CookBook.Class1).SELECT1()
Birthdayの値＝1999-01-01
```


### - ダイナミックSQLの%SelectModeプロパティを利用する

ダイナミックSQL実行時は、[%SQL.Statement](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.Statement)クラスの[%SelectMode](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.Statement#PROPERTY_%25SelectMode)プロパティを利用して表示形式を変更できます。

指定できる値は、以下の通りです（デフォルトは0）。

- 0 : 論理値（内部数値）のまま
- 1 : xDBC形式の表示モードへ変換
- 2 : カラムに定義されている形式に合わせて変換

SQLを実行する前に設定します。

%SelectModeプロパティを指定しなかった場合のSELECTの表示結果は以下の通りです（ルーチンでもメソッドでも記述方法は同じです）。

```
ClassMethod SELECTMODE0()
{
    set statement=##class(%SQL.Statement).%New()
    set status=statement.%Prepare("SELECT Birthday FROM CookBook.Person WHERE ID=1")
    set rset=statement.%Execute()
    while rset.%Next() {
        write "Birthdayの値＝",rset.Birthday,!
    }
}
```

実行結果は以下の通りです。

```
USER>do ##class(CookBook.Class1).SELECTMODE0()
Birthdayの値＝57709
```

SelectModeプロパティに1（xDBC形式）を指定した場合のSELECTの結果は以下の通りです（ルーチンでもメソッドでも記述方法は同じです）。

```

ClassMethod SELECTMODE1()
{
    set statement=##class(%SQL.Statement).%New()
    set statement.%SelectMode=1
    set status=statement.%Prepare("SELECT Birthday FROM CookBook.Person WHERE ID=1")
    set rset=statement.%Execute()
    while rset.%Next() {
        write "Birthdayの値＝",rset.Birthday,!
    }
}
```
実行結果は以下の通りで
```
USER>do ##class(CookBook.Class1).SELECTMODE1()
Birthdayの値＝1999-01-01
```
