component persistent="true" table="person" {
    property name="id" fieldtype="id" generator="native";
    property name="firstName" ormtype="string";
    property name="lastName" ormtype="string";
    property name="balance" ormtype="big_decimal";
}