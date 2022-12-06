Class CookBook.Person Extends %Persistent
{

Property Name As %String;

Property Birthday As %Date;

Storage Default
{
<Data name="PersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Birthday</Value>
</Value>
</Data>
<DataLocation>^CookBook.PersonD</DataLocation>
<DefaultData>PersonDefaultData</DefaultData>
<IdLocation>^CookBook.PersonD</IdLocation>
<IndexLocation>^CookBook.PersonI</IndexLocation>
<StreamLocation>^CookBook.PersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
