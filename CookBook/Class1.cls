Class CookBook.Class1
{

/// ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
/// 
/// 以下　ObjectScriptの基本のき！　に登場するメソッド
/// https://github.com/Intersystems-jp/ObjectScriptCookBook/blob/master/Basic.md
/// 
/// ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
ClassMethod Rule()
{
    //コマンドは先頭にタブを1つ入れてから記述します
    write "こんにちは",!
}

ClassMethod Order1()
{
    set Kion("東京","朝")=9
    set Kion("東京","昼")=16
    set Kion("大阪","朝")=12
    set Kion("大阪","昼")=20

    set area=""
    for {
        set area=$ORDER(Kion(area))
        if area="" {
            quit
        }
        write area,!
    }
}

ClassMethod Order2()
{
    set Kion("東京","朝")=9
    set Kion("東京","昼")=16
    set Kion("大阪","朝")=12
    set Kion("大阪","昼")=20

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
}

ClassMethod ex1()
{
    write "戻り値のないメソッドです"
}

ClassMethod ex2() As %String
{
    write "こんにちは"
    return "戻り値が返るメソッドです"
}

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

ClassMethod err()
{
    set today=$NOW()
    write abc
}

ClassMethod Parameter1(ByRef refVal As %String)
{
    set refVal="新しい値に変更"
}

ClassMethod Parameter2(ByRef data As %String)
{
    zwrite data
}

ClassMethod variable1(a As %String, b As %String, c... As %String)
{
  write "a=",a,!
  write "b=",b,!!
  write "*** c ***",!!
  zwrite c
}

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

ClassMethod SELECT0()
{
    &SQL(SELECT Birthday INTO :birthday FROM CookBook.Person WHERE ID=1)
    write "Birthdayの値＝",$SYSTEM.SQL.Functions.TOCHAR(birthday,"YYYY-MM-DD")
}

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

/// ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
/// 
/// 以下　ObjectScriptクックブックに登場するメソッド
/// https://github.com/Intersystems-jp/ObjectScriptCookBook/blob/master/CookBook.md
/// 
/// ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
ClassMethod Moji1()
{
    set moji="160-0023,東京都,新宿区,西新宿,6-10-1,日土地西新宿ビル15F"
    for i=1:1:$LENGTH(moji,",") {
        //write $PIECE(moji,",",i),!
        set address(i)=$PIECE(moji,",",i)
    }
    zwrite address
}

ClassMethod listgetset()
{
    set color=$LISTBUILD("赤","青","","紫")
    set p=0,cn=0
    while $LISTNEXT(color,p,value) {
        set cn=cn+1
        if $GET(value)="" continue
        set data(cn)=value
    }
    zwrite data
}

ClassMethod csvtolist()
{
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
}

ClassMethod fileread()
{
    set fo=##class(%Stream.FileCharacter).%New()
    do fo.LinkToFile("c:\temp\testfile1.txt")
    set fo.TranslateTable="UTF8"
    while fo.AtEnd=0 {
        write fo.ReadLine(),!
    }
    kill fo
}

ClassMethod fileoutCommand()
{
    set file="c:\temp\testfile4.txt"
    set currentIO=$IO
    //open file:"NWS"  //ファイルIOのデフォルト文字コード：WindowsはSJIS
    open file:"NWSK\UTF8\"
    use file write "あいうえお",!
    use file write "かきくけこ",!
    use file write "さしすせそ",!
    close file
    use currentIO
}

ClassMethod filereadcommand()
{
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
}

ClassMethod HTTPPost()
{
    //https://<webサーバ>/<path>  へのアクセス例
    set req=##class(%Net.HttpRequest).%New()
    set req.Server=""  //webサーバ指定
    set req.Location="/webhookb2/"   //pathの指定
    set req.SSLConfiguration="webapi"  // 管理ポータルで設定するSSL構成名指定
    set req.Https=1  // Httpsを使う場合1
    set req.ContentType="application/json"
    set req.ContentCharset="utf-8"
    //以下Teamsに送信するメッセージ作成（JSONオブジェクトのtextプロパティにマークダウンで書いたメッセージを送信できます）
    set json={}
    set message="# ★Incoming Webhookのテスト★"
    set message=message_$char(13,10)_"**メッセージ送信しました**"
    set json.text=message
    //BODY に作成したJSONを設定
    do json.%ToJSON(req.EntityBody)
    //POST要求送信
    set st=req.Post()
    //HTTPステータスコード確認
    write req.HttpResponse.StatusCode,!
    //エラーがない時は空
    write $SYSTEM.Status.GetErrorText(st)
}

/// 以下の記事　(6)前半コード<br>
/// https://jp.community.intersystems.com/node/519306
ClassMethod GetGmailToken(code As %String)
{
    //事前にアクセスコードを入手すること
    //set code="4/0AfgeXvtTM21bZ3pGGB3sLH_*************************************"
    set req = ##class(%Net.HttpRequest).%New()
    set req.SSLConfiguration="webapi"
    do req.SetParam("code",code)
    do req.SetParam("client_id","")  //第2引数にクライアントIDを指定
    do req.SetParam("client_secret","")  //第2引数にクライアントシークレットを指定
    do req.SetParam("redirect_uri","https://localhost/test.html")  //リダイレクトURLを指定
    do req.SetParam("grant_type","authorization_code")
    do req.SetParam("access_type","offline")
    do req.Post("https://accounts.google.com/o/oauth2/token")
    set resData = req.HttpResponse.Data
    set json={}.%FromJSON(resData.Read(10000))

    //返送されたJSONを全部参照したいときはzwriteが便利
    //zwrite json

    set AccessToken=json."access_token"
    set refreshToken=json."refresh_token"
    write "AccessToken=",AccessToken,!
    write "RefreshToken=",refreshToken,!
}

/// 以下の記事　(6)後半コード<br>>
/// https://jp.community.intersystems.com/node/519306
ClassMethod SendMail(AccessToken As %String(MAXLEN=1000))
{
    set mbox= ##class(%Net.SMTP).%New()
    set mbox.smtpserver="smtp.gmail.com"
    set mbox.port="587"
    set mbox.UseSTARTTLS=1    
    set mbox.SSLConfiguration="webapi" // 管理ポータルで設定したSSL構成名

    set auth=##class(%Net.Authenticator).%New()
    set auth.MechanismList="XOAUTH2"
    set auth.UserName="mihokoiijima@gmail.com"
    set auth.AccessToken=AccessToken  //引数で指定したアクセストークン
    set mbox.authenticator=auth

    //メール本文作成
    set message=##class(%Net.MailMessage).%New()
    do message.To.Insert("abc@xxx.com")  // To
    set message.From="test@gmail.com"  // FROM
    set message.Subject="test from IRIS" //件名
    set status=message.TextData.Write("こんにちは!") //本文

    //メール送信
    set status=mbox.Send(message)
    write $SYSTEM.OBJ.DisplayError(status),!
}

/// メール送信時とAccessTokenの取得方法は同様
ClassMethod recieveMail()
{
    // pop3用インスタンス生成
    set pop3=##class(%Net.POP3).%New()

    // *** 接続先に合わせて正しい情報に変更必要
    set servername="pop.gmail.com"
    set user="xxx@gmail.com"
    set pass="passwordxxxx"
    set AccessToken=""  //事前に取得したアクセストークンを指定します
    set pop3.port=995
    // ***

    // SSL用の設定
    set pop3.SSLConfiguration="webapi"   //管理ポータルで設定したSSL構成名
    set pop3.UseSTARTTLS=0 // SSLなので0

    set status=pop3.Connect(servername,user,pass,AccessToken)
    // ポート番号をプロパティに設定しない場合は、ConnectPort()メソッドでも接続可
    //set port=995
    //set status=pop3.ConnectPort(servername,port,user,pass)

    if $$$ISERR(status) {
        write "接続失敗",!
        write $SYSTEM.Status.GetErrorText(status),!
        return
    }
    write "接続完了",!

    set status=pop3.GetMailBoxStatus(.count,.size)
    write "メール件数：",count," - サイズ：",size,!
    // 直近のメールを取得
    set status=pop3.FetchMessage(count,.from,.to,.date,.subject,.msize,.mheader,.mailmessage,0)
    if $$$ISERR(status) {
        write $SYSTEM.Status.GetErrorText(status),!
        set status=pop3.QuitAndRollback()
        return
    }

    //取得できたメール基本情報
    write "FROM:",from,!
    write "TO:",to,!
    write "受信日付：",date,!
    write "件名：",subject,!
    write "メールサイズ：",msize,!

    //本文取得：MultiPartの場合
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

    // 削除対象メールを削除しない
    set status=pop3.QuitAndRollback()
    write status
}

ClassMethod keisoku()
{
    set starttime=$ZHOROLOG
    /*
        何らかの処理
    */
    write $ZHOROLOG-starttime,!
}

ClassMethod EmbeddedSQL() [ SqlProc ]
{
    #dim %sqlcontext As %Library.SQLProcContext
    &sql(INSERT INTO CookBook.Person (Name,Birthday) VALUES('テスト太郎','不正な値'))
    if SQLCODE<0 {
        set %sqlcontext.%SQLCODE=SQLCODE
        set %sqlcontext.%Message=%msg
    }
}

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

ClassMethod SELECT1()
{
    #SQLCompile SELECT=ODBC
    &SQL(SELECT Birthday INTO :birthday FROM CookBook.Person WHERE ID=1)
    write "Birthdayの値＝",birthday
}

ClassMethod SELECTMODE0()
{
    set statement=##class(%SQL.Statement).%New()
    set status=statement.%Prepare("SELECT Birthday FROM CookBook.Person WHERE ID=1")
    set rset=statement.%Execute()
    while rset.%Next() {
        write "Birthdayの値＝",rset.Birthday,!
    }
}

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

/// ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
/// 
/// 以下　ObjectScriptでエラーが発生したら に登場するメソッド
/// https://github.com/Intersystems-jp/ObjectScriptCookBook/blob/master/ErrorOpe.md
/// 
/// ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
ClassMethod undeftest()
{
    set Test1="ローカル変数設定"
    write "UNDEFINEDエラーを発生させる例",!
    write abc,!
    write "おわり"
}

ClassMethod Test1(p1 As %Integer, p2 As %Integer) As %String
{
    #dim ex As %Exception.AbstractException
    set retVal="OK"
    TRY {
        // 第2引数の値をチェックして異常値ならTRYブロックをQUITで終了
        if $GET(p2)=0 {
            set retVal="0は指定しないでください"
            quit
        }
        write "割り算結果：",p1/p2,!
    }
    CATCH ex {
        set retVal=ex.DisplayString()
    }
    quit retVal
}

ClassMethod Test2()
{
    TRY{
        write "TRYブロックです",!
        set exception=##class(%Exception.General).%New("ユーザ作成の例外",5001,,"一般例外作成テスト")
        throw exception
        write "THROWの後",!
    }
    CATCH ex {
        write "CATCHブロックです",!
        write "*** ",ex.DisplayString(),!
    }
}

ClassMethod Call1()
{
    TRY{
        write "Call1のTRYブロック",!
        //do ..ABC()
        do ..Call2()
    }
    CATCH ex {
        write "Call1の中のCATCHブロック",!
        write "Call1で例外の中身を表示：",ex.DisplayString(),!
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
        write "ABC()のTRYブロックです",!
        write 1/0 // DIVIDEエラー
    }
    CATCH ex {
        write "ABC()のCATCHブロックです",!
        write "*** ",ex.DisplayString(),!
        throw ex
        write "ABC()のTHROWの後です",! //実行されないコード
    }
}

ClassMethod StatusError()
{
    TRY{
        set p=##class(CookBook.Person).%New()
        set p.Birthday="不正な値"
        set status=p.%Save()
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

ClassMethod SQLerror2()
{
    TRY{
        &SQL(INSERT INTO CookBook.Person (Name,Birthday) VALUES('テスト従業員','誕生日ではない情報を設定'))
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

ClassMethod SQLError4() [ SqlProc ]
{
    #dim rset As %SQL.StatementResult
    TRY{
        set sql="INSERT INTO CookBook.Person (Name,Birthday) VALUES(?,?)"
        set statement=##class(%SQL.Statement).%New()
        set status=statement.%Prepare(sql)
        set rset=statement.%Execute("テスト太郎","不正な値")

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

ClassMethod savetest2()
{
    Try {
        set person=##class(CookBook.Person).%New()  // CookBook.Personクラスのインスタンス生成
        set person.Birthday="データタイプに合わない値"
        set st=person.%Save()
        $$$ThrowOnError(st)
    }
    catch ex {
        write "CATCHに移動",!
        write ex.DisplayString(),!
    }
}

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

ClassMethod savetest4()
{
    Try {
        set person=##class(CookBook.Person).%New()  // CookBook.Personクラスのインスタンス生成
        set person.Birthday="データタイプに合わない値"
        set st=person.%Save()
        if $system.Status.IsError(st) {
            throw ##class(%Exception.StatusException).CreateFromStatus(st)
        }
    }
    catch ex {
        write "CATCHに移動",!
        write ex.DisplayString(),!
    }
}

}
