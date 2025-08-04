// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'p2p_cache_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetP2PDataCacheCollection on Isar {
  IsarCollection<P2PDataCache> get p2PDataCaches => this.collection();
}

const P2PDataCacheSchema = CollectionSchema(
  name: r'P2PDataCache',
  id: 5868483008450424708,
  properties: {
    r'batchId': PropertySchema(
      id: 0,
      name: r'batchId',
      type: IsarType.string,
    ),
    r'createdTimestamp': PropertySchema(
      id: 1,
      name: r'createdTimestamp',
      type: IsarType.dateTime,
    ),
    r'expiredTimestamp': PropertySchema(
      id: 2,
      name: r'expiredTimestamp',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.string,
    ),
    r'isExpired': PropertySchema(
      id: 4,
      name: r'isExpired',
      type: IsarType.bool,
    ),
    r'isProcessed': PropertySchema(
      id: 5,
      name: r'isProcessed',
      type: IsarType.bool,
    ),
    r'metaData': PropertySchema(
      id: 6,
      name: r'metaData',
      type: IsarType.string,
    ),
    r'priority': PropertySchema(
      id: 7,
      name: r'priority',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 8,
      name: r'status',
      type: IsarType.string,
    ),
    r'subtitle': PropertySchema(
      id: 9,
      name: r'subtitle',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 10,
      name: r'title',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 11,
      name: r'type',
      type: IsarType.byte,
      enumMap: _P2PDataCachetypeEnumValueMap,
    ),
    r'updatedTimestamp': PropertySchema(
      id: 12,
      name: r'updatedTimestamp',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 13,
      name: r'userId',
      type: IsarType.string,
    ),
    r'value': PropertySchema(
      id: 14,
      name: r'value',
      type: IsarType.string,
    )
  },
  estimateSize: _p2PDataCacheEstimateSize,
  serialize: _p2PDataCacheSerialize,
  deserialize: _p2PDataCacheDeserialize,
  deserializeProp: _p2PDataCacheDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'type': IndexSchema(
      id: 5117122708147080838,
      name: r'type',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'type',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'createdTimestamp': IndexSchema(
      id: -6330424217074401074,
      name: r'createdTimestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdTimestamp',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'expiredTimestamp': IndexSchema(
      id: 1031739888846499515,
      name: r'expiredTimestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'expiredTimestamp',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isProcessed': IndexSchema(
      id: 2788530510351198829,
      name: r'isProcessed',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isProcessed',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'batchId': IndexSchema(
      id: -5468368523860846432,
      name: r'batchId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'batchId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _p2PDataCacheGetId,
  getLinks: _p2PDataCacheGetLinks,
  attach: _p2PDataCacheAttach,
  version: '3.1.0+1',
);

int _p2PDataCacheEstimateSize(
  P2PDataCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.batchId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.metaData.length * 3;
  {
    final value = object.status;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.subtitle.length * 3;
  bytesCount += 3 + object.title.length * 3;
  {
    final value = object.userId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.value.length * 3;
  return bytesCount;
}

void _p2PDataCacheSerialize(
  P2PDataCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.batchId);
  writer.writeDateTime(offsets[1], object.createdTimestamp);
  writer.writeDateTime(offsets[2], object.expiredTimestamp);
  writer.writeString(offsets[3], object.id);
  writer.writeBool(offsets[4], object.isExpired);
  writer.writeBool(offsets[5], object.isProcessed);
  writer.writeString(offsets[6], object.metaData);
  writer.writeLong(offsets[7], object.priority);
  writer.writeString(offsets[8], object.status);
  writer.writeString(offsets[9], object.subtitle);
  writer.writeString(offsets[10], object.title);
  writer.writeByte(offsets[11], object.type.index);
  writer.writeDateTime(offsets[12], object.updatedTimestamp);
  writer.writeString(offsets[13], object.userId);
  writer.writeString(offsets[14], object.value);
}

P2PDataCache _p2PDataCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = P2PDataCache(
    batchId: reader.readStringOrNull(offsets[0]),
    createdTimestamp: reader.readDateTime(offsets[1]),
    expiredTimestamp: reader.readDateTimeOrNull(offsets[2]),
    id: reader.readString(offsets[3]),
    isProcessed: reader.readBoolOrNull(offsets[5]) ?? false,
    metaData: reader.readStringOrNull(offsets[6]) ?? '{}',
    priority: reader.readLongOrNull(offsets[7]) ?? 0,
    status: reader.readStringOrNull(offsets[8]),
    subtitle: reader.readString(offsets[9]),
    title: reader.readString(offsets[10]),
    type: _P2PDataCachetypeValueEnumMap[reader.readByteOrNull(offsets[11])] ??
        P2PDataCacheType.pairingRequest,
    updatedTimestamp: reader.readDateTime(offsets[12]),
    userId: reader.readStringOrNull(offsets[13]),
    value: reader.readString(offsets[14]),
  );
  return object;
}

P _p2PDataCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? '{}') as P;
    case 7:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (_P2PDataCachetypeValueEnumMap[reader.readByteOrNull(offset)] ??
          P2PDataCacheType.pairingRequest) as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _P2PDataCachetypeEnumValueMap = {
  'pairingRequest': 0,
  'dataTransferTask': 1,
  'fileTransferRequest': 2,
};
const _P2PDataCachetypeValueEnumMap = {
  0: P2PDataCacheType.pairingRequest,
  1: P2PDataCacheType.dataTransferTask,
  2: P2PDataCacheType.fileTransferRequest,
};

Id _p2PDataCacheGetId(P2PDataCache object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _p2PDataCacheGetLinks(P2PDataCache object) {
  return [];
}

void _p2PDataCacheAttach(
    IsarCollection<dynamic> col, Id id, P2PDataCache object) {}

extension P2PDataCacheByIndex on IsarCollection<P2PDataCache> {
  Future<P2PDataCache?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  P2PDataCache? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<P2PDataCache?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<P2PDataCache?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(P2PDataCache object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(P2PDataCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<P2PDataCache> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<P2PDataCache> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension P2PDataCacheQueryWhereSort
    on QueryBuilder<P2PDataCache, P2PDataCache, QWhere> {
  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhere> anyType() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'type'),
      );
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhere> anyCreatedTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdTimestamp'),
      );
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhere> anyExpiredTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'expiredTimestamp'),
      );
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhere> anyIsProcessed() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isProcessed'),
      );
    });
  }
}

extension P2PDataCacheQueryWhere
    on QueryBuilder<P2PDataCache, P2PDataCache, QWhereClause> {
  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> idEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> idNotEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> typeEqualTo(
      P2PDataCacheType type) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'type',
        value: [type],
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> typeNotEqualTo(
      P2PDataCacheType type) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type',
              lower: [],
              upper: [type],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type',
              lower: [type],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type',
              lower: [type],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type',
              lower: [],
              upper: [type],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> typeGreaterThan(
    P2PDataCacheType type, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'type',
        lower: [type],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> typeLessThan(
    P2PDataCacheType type, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'type',
        lower: [],
        upper: [type],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> typeBetween(
    P2PDataCacheType lowerType,
    P2PDataCacheType upperType, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'type',
        lower: [lowerType],
        includeLower: includeLower,
        upper: [upperType],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause>
      createdTimestampEqualTo(DateTime createdTimestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdTimestamp',
        value: [createdTimestamp],
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause>
      createdTimestampNotEqualTo(DateTime createdTimestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdTimestamp',
              lower: [],
              upper: [createdTimestamp],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdTimestamp',
              lower: [createdTimestamp],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdTimestamp',
              lower: [createdTimestamp],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdTimestamp',
              lower: [],
              upper: [createdTimestamp],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause>
      createdTimestampGreaterThan(
    DateTime createdTimestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdTimestamp',
        lower: [createdTimestamp],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause>
      createdTimestampLessThan(
    DateTime createdTimestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdTimestamp',
        lower: [],
        upper: [createdTimestamp],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause>
      createdTimestampBetween(
    DateTime lowerCreatedTimestamp,
    DateTime upperCreatedTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdTimestamp',
        lower: [lowerCreatedTimestamp],
        includeLower: includeLower,
        upper: [upperCreatedTimestamp],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause>
      expiredTimestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'expiredTimestamp',
        value: [null],
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause>
      expiredTimestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expiredTimestamp',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause>
      expiredTimestampEqualTo(DateTime? expiredTimestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'expiredTimestamp',
        value: [expiredTimestamp],
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause>
      expiredTimestampNotEqualTo(DateTime? expiredTimestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expiredTimestamp',
              lower: [],
              upper: [expiredTimestamp],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expiredTimestamp',
              lower: [expiredTimestamp],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expiredTimestamp',
              lower: [expiredTimestamp],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expiredTimestamp',
              lower: [],
              upper: [expiredTimestamp],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause>
      expiredTimestampGreaterThan(
    DateTime? expiredTimestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expiredTimestamp',
        lower: [expiredTimestamp],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause>
      expiredTimestampLessThan(
    DateTime? expiredTimestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expiredTimestamp',
        lower: [],
        upper: [expiredTimestamp],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause>
      expiredTimestampBetween(
    DateTime? lowerExpiredTimestamp,
    DateTime? upperExpiredTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expiredTimestamp',
        lower: [lowerExpiredTimestamp],
        includeLower: includeLower,
        upper: [upperExpiredTimestamp],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause>
      isProcessedEqualTo(bool isProcessed) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isProcessed',
        value: [isProcessed],
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause>
      isProcessedNotEqualTo(bool isProcessed) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isProcessed',
              lower: [],
              upper: [isProcessed],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isProcessed',
              lower: [isProcessed],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isProcessed',
              lower: [isProcessed],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isProcessed',
              lower: [],
              upper: [isProcessed],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [null],
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> userIdEqualTo(
      String? userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> userIdNotEqualTo(
      String? userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> batchIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'batchId',
        value: [null],
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause>
      batchIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'batchId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> batchIdEqualTo(
      String? batchId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'batchId',
        value: [batchId],
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterWhereClause> batchIdNotEqualTo(
      String? batchId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'batchId',
              lower: [],
              upper: [batchId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'batchId',
              lower: [batchId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'batchId',
              lower: [batchId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'batchId',
              lower: [],
              upper: [batchId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension P2PDataCacheQueryFilter
    on QueryBuilder<P2PDataCache, P2PDataCache, QFilterCondition> {
  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      batchIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'batchId',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      batchIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'batchId',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      batchIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'batchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      batchIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'batchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      batchIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'batchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      batchIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'batchId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      batchIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'batchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      batchIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'batchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      batchIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'batchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      batchIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'batchId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      batchIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'batchId',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      batchIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'batchId',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      createdTimestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      createdTimestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      createdTimestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      createdTimestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdTimestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      expiredTimestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expiredTimestamp',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      expiredTimestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expiredTimestamp',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      expiredTimestampEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiredTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      expiredTimestampGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiredTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      expiredTimestampLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiredTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      expiredTimestampBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiredTimestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      isExpiredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isExpired',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      isProcessedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isProcessed',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      metaDataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metaData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      metaDataGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'metaData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      metaDataLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'metaData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      metaDataBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'metaData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      metaDataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'metaData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      metaDataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'metaData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      metaDataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'metaData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      metaDataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'metaData',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      metaDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metaData',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      metaDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'metaData',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      priorityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      priorityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      priorityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      priorityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> statusEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      statusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      statusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> statusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> statusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      subtitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      subtitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      subtitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      subtitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subtitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      subtitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      subtitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      subtitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      subtitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subtitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      subtitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subtitle',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      subtitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subtitle',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> typeEqualTo(
      P2PDataCacheType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      typeGreaterThan(
    P2PDataCacheType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> typeLessThan(
    P2PDataCacheType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> typeBetween(
    P2PDataCacheType lower,
    P2PDataCacheType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      updatedTimestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      updatedTimestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      updatedTimestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      updatedTimestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedTimestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> userIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      userIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      userIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> userIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> userIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> valueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      valueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> valueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> valueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> valueContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition> valueMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'value',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterFilterCondition>
      valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'value',
        value: '',
      ));
    });
  }
}

extension P2PDataCacheQueryObject
    on QueryBuilder<P2PDataCache, P2PDataCache, QFilterCondition> {}

extension P2PDataCacheQueryLinks
    on QueryBuilder<P2PDataCache, P2PDataCache, QFilterCondition> {}

extension P2PDataCacheQuerySortBy
    on QueryBuilder<P2PDataCache, P2PDataCache, QSortBy> {
  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByBatchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchId', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByBatchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchId', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy>
      sortByCreatedTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdTimestamp', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy>
      sortByCreatedTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdTimestamp', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy>
      sortByExpiredTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiredTimestamp', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy>
      sortByExpiredTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiredTimestamp', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByIsExpiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByIsProcessed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProcessed', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy>
      sortByIsProcessedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProcessed', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByMetaData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metaData', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByMetaDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metaData', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortBySubtitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortBySubtitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy>
      sortByUpdatedTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedTimestamp', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy>
      sortByUpdatedTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedTimestamp', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension P2PDataCacheQuerySortThenBy
    on QueryBuilder<P2PDataCache, P2PDataCache, QSortThenBy> {
  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByBatchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchId', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByBatchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batchId', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy>
      thenByCreatedTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdTimestamp', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy>
      thenByCreatedTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdTimestamp', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy>
      thenByExpiredTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiredTimestamp', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy>
      thenByExpiredTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiredTimestamp', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByIsExpiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByIsProcessed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProcessed', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy>
      thenByIsProcessedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProcessed', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByMetaData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metaData', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByMetaDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metaData', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenBySubtitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenBySubtitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy>
      thenByUpdatedTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedTimestamp', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy>
      thenByUpdatedTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedTimestamp', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension P2PDataCacheQueryWhereDistinct
    on QueryBuilder<P2PDataCache, P2PDataCache, QDistinct> {
  QueryBuilder<P2PDataCache, P2PDataCache, QDistinct> distinctByBatchId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'batchId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QDistinct>
      distinctByCreatedTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdTimestamp');
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QDistinct>
      distinctByExpiredTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiredTimestamp');
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QDistinct> distinctByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isExpired');
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QDistinct> distinctByIsProcessed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isProcessed');
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QDistinct> distinctByMetaData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metaData', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QDistinct> distinctByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priority');
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QDistinct> distinctBySubtitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subtitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QDistinct>
      distinctByUpdatedTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedTimestamp');
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCache, QDistinct> distinctByValue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value', caseSensitive: caseSensitive);
    });
  }
}

extension P2PDataCacheQueryProperty
    on QueryBuilder<P2PDataCache, P2PDataCache, QQueryProperty> {
  QueryBuilder<P2PDataCache, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<P2PDataCache, String?, QQueryOperations> batchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'batchId');
    });
  }

  QueryBuilder<P2PDataCache, DateTime, QQueryOperations>
      createdTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdTimestamp');
    });
  }

  QueryBuilder<P2PDataCache, DateTime?, QQueryOperations>
      expiredTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiredTimestamp');
    });
  }

  QueryBuilder<P2PDataCache, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<P2PDataCache, bool, QQueryOperations> isExpiredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isExpired');
    });
  }

  QueryBuilder<P2PDataCache, bool, QQueryOperations> isProcessedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isProcessed');
    });
  }

  QueryBuilder<P2PDataCache, String, QQueryOperations> metaDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metaData');
    });
  }

  QueryBuilder<P2PDataCache, int, QQueryOperations> priorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priority');
    });
  }

  QueryBuilder<P2PDataCache, String?, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<P2PDataCache, String, QQueryOperations> subtitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subtitle');
    });
  }

  QueryBuilder<P2PDataCache, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<P2PDataCache, P2PDataCacheType, QQueryOperations>
      typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<P2PDataCache, DateTime, QQueryOperations>
      updatedTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedTimestamp');
    });
  }

  QueryBuilder<P2PDataCache, String?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<P2PDataCache, String, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
