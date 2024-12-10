// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class WalletItem extends _WalletItem
    with RealmEntity, RealmObjectBase, RealmObject {
  WalletItem(
    String id,
    String name,
    double initBalance,
    String walletType,
    String currency, {
    String? note,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'initBalance', initBalance);
    RealmObjectBase.set(this, 'walletType', walletType);
    RealmObjectBase.set(this, 'currency', currency);
    RealmObjectBase.set(this, 'note', note);
  }

  WalletItem._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  double get initBalance =>
      RealmObjectBase.get<double>(this, 'initBalance') as double;
  @override
  set initBalance(double value) =>
      RealmObjectBase.set(this, 'initBalance', value);

  @override
  String get walletType =>
      RealmObjectBase.get<String>(this, 'walletType') as String;
  @override
  set walletType(String value) =>
      RealmObjectBase.set(this, 'walletType', value);

  @override
  String get currency =>
      RealmObjectBase.get<String>(this, 'currency') as String;
  @override
  set currency(String value) => RealmObjectBase.set(this, 'currency', value);

  @override
  String? get note => RealmObjectBase.get<String>(this, 'note') as String?;
  @override
  set note(String? value) => RealmObjectBase.set(this, 'note', value);

  @override
  Stream<RealmObjectChanges<WalletItem>> get changes =>
      RealmObjectBase.getChanges<WalletItem>(this);

  @override
  Stream<RealmObjectChanges<WalletItem>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<WalletItem>(this, keyPaths);

  @override
  WalletItem freeze() => RealmObjectBase.freezeObject<WalletItem>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'initBalance': initBalance.toEJson(),
      'walletType': walletType.toEJson(),
      'currency': currency.toEJson(),
      'note': note.toEJson(),
    };
  }

  static EJsonValue _toEJson(WalletItem value) => value.toEJson();
  static WalletItem _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'initBalance': EJsonValue initBalance,
        'walletType': EJsonValue walletType,
        'currency': EJsonValue currency,
      } =>
        WalletItem(
          fromEJson(id),
          fromEJson(name),
          fromEJson(initBalance),
          fromEJson(walletType),
          fromEJson(currency),
          note: fromEJson(ejson['note']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(WalletItem._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, WalletItem, 'WalletItem', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('initBalance', RealmPropertyType.double),
      SchemaProperty('walletType', RealmPropertyType.string),
      SchemaProperty('currency', RealmPropertyType.string),
      SchemaProperty('note', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
