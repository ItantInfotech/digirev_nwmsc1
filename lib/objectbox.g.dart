// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'model/model.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 7402192783903559409),
      name: 'Review',
      lastPropertyId: const IdUid(14, 1892997284057931265),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7662970505366050941),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 6620997384843377812),
            name: 'rank',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3057736100478957853),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 8170717554935357183),
            name: 'profilePic',
            type: 23,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 6435100025321097708),
            name: 'appointment',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 1509750836848611275),
            name: 'address',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 8004184223935829200),
            name: 'hReview',
            type: 23,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 7146978945979931902),
            name: 'wReview',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 7152779210561217104),
            name: 'aReview',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 8936235480829164606),
            name: 'signature',
            type: 23,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 4720608842826598966),
            name: 'type',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 7642537085220134919),
            name: 'date',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 680987485522959423),
            name: 'status',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 1892997284057931265),
            name: 'client',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 2533960103596687884),
      name: 'Vip',
      lastPropertyId: const IdUid(7, 6551122496766315075),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 3846266449713767641),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 3079572746989282890),
            name: 'rank',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3385677851898152557),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 2602656728048344819),
            name: 'profilepic',
            type: 23,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 2863597855324776069),
            name: 'appointment',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 5503881412857237857),
            name: 'address',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 6551122496766315075),
            name: 'date',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Shortcut for [Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [Store.new] for an explanation of all parameters.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// Returns the ObjectBox model definition for this project for use with
/// [Store.new].
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(2, 2533960103596687884),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    Review: EntityDefinition<Review>(
        model: _entities[0],
        toOneRelations: (Review object) => [],
        toManyRelations: (Review object) => {},
        getId: (Review object) => object.id,
        setId: (Review object, int id) {
          object.id = id;
        },
        objectToFB: (Review object, fb.Builder fbb) {
          final rankOffset =
              object.rank == null ? null : fbb.writeString(object.rank!);
          final nameOffset =
              object.name == null ? null : fbb.writeString(object.name!);
          final profilePicOffset = object.profilePic == null
              ? null
              : fbb.writeListInt8(object.profilePic!);
          final appointmentOffset = object.appointment == null
              ? null
              : fbb.writeString(object.appointment!);
          final addressOffset =
              object.address == null ? null : fbb.writeString(object.address!);
          final hReviewOffset = object.hReview == null
              ? null
              : fbb.writeListInt8(object.hReview!);
          final wReviewOffset =
              object.wReview == null ? null : fbb.writeString(object.wReview!);
          final aReviewOffset =
              object.aReview == null ? null : fbb.writeString(object.aReview!);
          final signatureOffset = object.signature == null
              ? null
              : fbb.writeListInt8(object.signature!);
          final typeOffset =
              object.type == null ? null : fbb.writeString(object.type!);
          final dateOffset =
              object.date == null ? null : fbb.writeString(object.date!);
          final statusOffset =
              object.status == null ? null : fbb.writeString(object.status!);
          final clientOffset =
              object.client == null ? null : fbb.writeString(object.client!);
          fbb.startTable(15);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, rankOffset);
          fbb.addOffset(2, nameOffset);
          fbb.addOffset(3, profilePicOffset);
          fbb.addOffset(4, appointmentOffset);
          fbb.addOffset(5, addressOffset);
          fbb.addOffset(6, hReviewOffset);
          fbb.addOffset(7, wReviewOffset);
          fbb.addOffset(8, aReviewOffset);
          fbb.addOffset(9, signatureOffset);
          fbb.addOffset(10, typeOffset);
          fbb.addOffset(11, dateOffset);
          fbb.addOffset(12, statusOffset);
          fbb.addOffset(13, clientOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final rankParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 6);
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 8);
          final profilePicParam = const fb.Uint8ListReader(lazy: false)
              .vTableGetNullable(buffer, rootOffset, 10) as Uint8List?;
          final appointmentParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 12);
          final addressParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 14);
          final hReviewParam = const fb.Uint8ListReader(lazy: false)
              .vTableGetNullable(buffer, rootOffset, 16) as Uint8List?;
          final wReviewParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 18);
          final aReviewParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 20);
          final signatureParam = const fb.Uint8ListReader(lazy: false)
              .vTableGetNullable(buffer, rootOffset, 22) as Uint8List?;
          final typeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 24);
          final dateParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 26);
          final statusParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 28);
          final clientParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 30);
          final object = Review(
              id: idParam,
              rank: rankParam,
              name: nameParam,
              profilePic: profilePicParam,
              appointment: appointmentParam,
              address: addressParam,
              hReview: hReviewParam,
              wReview: wReviewParam,
              aReview: aReviewParam,
              signature: signatureParam,
              type: typeParam,
              date: dateParam,
              status: statusParam,
              client: clientParam);

          return object;
        }),
    Vip: EntityDefinition<Vip>(
        model: _entities[1],
        toOneRelations: (Vip object) => [],
        toManyRelations: (Vip object) => {},
        getId: (Vip object) => object.id,
        setId: (Vip object, int id) {
          object.id = id;
        },
        objectToFB: (Vip object, fb.Builder fbb) {
          final rankOffset =
              object.rank == null ? null : fbb.writeString(object.rank!);
          final nameOffset =
              object.name == null ? null : fbb.writeString(object.name!);
          final profilepicOffset = object.profilepic == null
              ? null
              : fbb.writeListInt8(object.profilepic!);
          final appointmentOffset = object.appointment == null
              ? null
              : fbb.writeString(object.appointment!);
          final addressOffset =
              object.address == null ? null : fbb.writeString(object.address!);
          final dateOffset =
              object.date == null ? null : fbb.writeString(object.date!);
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, rankOffset);
          fbb.addOffset(2, nameOffset);
          fbb.addOffset(3, profilepicOffset);
          fbb.addOffset(4, appointmentOffset);
          fbb.addOffset(5, addressOffset);
          fbb.addOffset(6, dateOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final rankParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 6);
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 8);
          final addressParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 14);
          final appointmentParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 12);
          final profilepicParam = const fb.Uint8ListReader(lazy: false)
              .vTableGetNullable(buffer, rootOffset, 10) as Uint8List?;
          final dateParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 16);
          final object = Vip(
              id: idParam,
              rank: rankParam,
              name: nameParam,
              address: addressParam,
              appointment: appointmentParam,
              profilepic: profilepicParam,
              date: dateParam);

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [Review] entity fields to define ObjectBox queries.
class Review_ {
  /// see [Review.id]
  static final id = QueryIntegerProperty<Review>(_entities[0].properties[0]);

  /// see [Review.rank]
  static final rank = QueryStringProperty<Review>(_entities[0].properties[1]);

  /// see [Review.name]
  static final name = QueryStringProperty<Review>(_entities[0].properties[2]);

  /// see [Review.profilePic]
  static final profilePic =
      QueryByteVectorProperty<Review>(_entities[0].properties[3]);

  /// see [Review.appointment]
  static final appointment =
      QueryStringProperty<Review>(_entities[0].properties[4]);

  /// see [Review.address]
  static final address =
      QueryStringProperty<Review>(_entities[0].properties[5]);

  /// see [Review.hReview]
  static final hReview =
      QueryByteVectorProperty<Review>(_entities[0].properties[6]);

  /// see [Review.wReview]
  static final wReview =
      QueryStringProperty<Review>(_entities[0].properties[7]);

  /// see [Review.aReview]
  static final aReview =
      QueryStringProperty<Review>(_entities[0].properties[8]);

  /// see [Review.signature]
  static final signature =
      QueryByteVectorProperty<Review>(_entities[0].properties[9]);

  /// see [Review.type]
  static final type = QueryStringProperty<Review>(_entities[0].properties[10]);

  /// see [Review.date]
  static final date = QueryStringProperty<Review>(_entities[0].properties[11]);

  /// see [Review.status]
  static final status =
      QueryStringProperty<Review>(_entities[0].properties[12]);

  /// see [Review.client]
  static final client =
      QueryStringProperty<Review>(_entities[0].properties[13]);
}

/// [Vip] entity fields to define ObjectBox queries.
class Vip_ {
  /// see [Vip.id]
  static final id = QueryIntegerProperty<Vip>(_entities[1].properties[0]);

  /// see [Vip.rank]
  static final rank = QueryStringProperty<Vip>(_entities[1].properties[1]);

  /// see [Vip.name]
  static final name = QueryStringProperty<Vip>(_entities[1].properties[2]);

  /// see [Vip.profilepic]
  static final profilepic =
      QueryByteVectorProperty<Vip>(_entities[1].properties[3]);

  /// see [Vip.appointment]
  static final appointment =
      QueryStringProperty<Vip>(_entities[1].properties[4]);

  /// see [Vip.address]
  static final address = QueryStringProperty<Vip>(_entities[1].properties[5]);

  /// see [Vip.date]
  static final date = QueryStringProperty<Vip>(_entities[1].properties[6]);
}
