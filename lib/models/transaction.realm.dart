// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class TransactionItem extends _TransactionItem
    with RealmEntity, RealmObjectBase, RealmObject {
  TransactionItem(
    ObjectId id,
    double amount,
    String type,
    String category,
    String wallet,
    DateTime date,
    String repeatPattern, {
    String? note,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'amount', amount);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'category', category);
    RealmObjectBase.set(this, 'wallet', wallet);
    RealmObjectBase.set(this, 'note', note);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set(this, 'repeatPattern', repeatPattern);
  }

  TransactionItem._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  double get amount => RealmObjectBase.get<double>(this, 'amount') as double;
  @override
  set amount(double value) => RealmObjectBase.set(this, 'amount', value);

  @override
  String get type => RealmObjectBase.get<String>(this, 'type') as String;
  @override
  set type(String value) => RealmObjectBase.set(this, 'type', value);

  @override
  String get category =>
      RealmObjectBase.get<String>(this, 'category') as String;
  @override
  set category(String value) => RealmObjectBase.set(this, 'category', value);

  @override
  String get wallet => RealmObjectBase.get<String>(this, 'wallet') as String;
  @override
  set wallet(String value) => RealmObjectBase.set(this, 'wallet', value);

  @override
  String? get note => RealmObjectBase.get<String>(this, 'note') as String?;
  @override
  set note(String? value) => RealmObjectBase.set(this, 'note', value);

  @override
  DateTime get date => RealmObjectBase.get<DateTime>(this, 'date') as DateTime;
  @override
  set date(DateTime value) => RealmObjectBase.set(this, 'date', value);

  @override
  String get repeatPattern =>
      RealmObjectBase.get<String>(this, 'repeatPattern') as String;
  @override
  set repeatPattern(String value) =>
      RealmObjectBase.set(this, 'repeatPattern', value);

  @override
  Stream<RealmObjectChanges<TransactionItem>> get changes =>
      RealmObjectBase.getChanges<TransactionItem>(this);

  @override
  Stream<RealmObjectChanges<TransactionItem>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<TransactionItem>(this, keyPaths);

  @override
  TransactionItem freeze() =>
      RealmObjectBase.freezeObject<TransactionItem>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'amount': amount.toEJson(),
      'type': type.toEJson(),
      'category': category.toEJson(),
      'wallet': wallet.toEJson(),
      'note': note.toEJson(),
      'date': date.toEJson(),
      'repeatPattern': repeatPattern.toEJson(),
    };
  }

  static EJsonValue _toEJson(TransactionItem value) => value.toEJson();
  static TransactionItem _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'amount': EJsonValue amount,
        'type': EJsonValue type,
        'category': EJsonValue category,
        'wallet': EJsonValue wallet,
        'date': EJsonValue date,
        'repeatPattern': EJsonValue repeatPattern,
      } =>
        TransactionItem(
          fromEJson(id),
          fromEJson(amount),
          fromEJson(type),
          fromEJson(category),
          fromEJson(wallet),
          fromEJson(date),
          fromEJson(repeatPattern),
          note: fromEJson(ejson['note']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(TransactionItem._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, TransactionItem, 'TransactionItem', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('amount', RealmPropertyType.double),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('category', RealmPropertyType.string),
      SchemaProperty('wallet', RealmPropertyType.string),
      SchemaProperty('note', RealmPropertyType.string, optional: true),
      SchemaProperty('date', RealmPropertyType.timestamp),
      SchemaProperty('repeatPattern', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
