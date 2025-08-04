// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'p2p_chat.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetP2PChatCollection on Isar {
  IsarCollection<P2PChat> get p2PChats => this.collection();
}

const P2PChatSchema = CollectionSchema(
  name: r'P2PChat',
  id: -9199541484853935557,
  properties: {
    r'autoCopyIncomingMessages': PropertySchema(
      id: 0,
      name: r'autoCopyIncomingMessages',
      type: IsarType.bool,
    ),
    r'clipboardSharing': PropertySchema(
      id: 1,
      name: r'clipboardSharing',
      type: IsarType.bool,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deleteAfterCopy': PropertySchema(
      id: 3,
      name: r'deleteAfterCopy',
      type: IsarType.bool,
    ),
    r'deleteAfterShare': PropertySchema(
      id: 4,
      name: r'deleteAfterShare',
      type: IsarType.bool,
    ),
    r'displayName': PropertySchema(
      id: 5,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'retention': PropertySchema(
      id: 6,
      name: r'retention',
      type: IsarType.byte,
      enumMap: _P2PChatretentionEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 7,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userAId': PropertySchema(
      id: 8,
      name: r'userAId',
      type: IsarType.string,
    ),
    r'userBId': PropertySchema(
      id: 9,
      name: r'userBId',
      type: IsarType.string,
    )
  },
  estimateSize: _p2PChatEstimateSize,
  serialize: _p2PChatSerialize,
  deserialize: _p2PChatDeserialize,
  deserializeProp: _p2PChatDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'messages': LinkSchema(
      id: -6311567938643663908,
      name: r'messages',
      target: r'P2PCMessage',
      single: false,
      linkName: r'chat',
    )
  },
  embeddedSchemas: {},
  getId: _p2PChatGetId,
  getLinks: _p2PChatGetLinks,
  attach: _p2PChatAttach,
  version: '3.1.0+1',
);

int _p2PChatEstimateSize(
  P2PChat object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.displayName.length * 3;
  bytesCount += 3 + object.userAId.length * 3;
  bytesCount += 3 + object.userBId.length * 3;
  return bytesCount;
}

void _p2PChatSerialize(
  P2PChat object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.autoCopyIncomingMessages);
  writer.writeBool(offsets[1], object.clipboardSharing);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeBool(offsets[3], object.deleteAfterCopy);
  writer.writeBool(offsets[4], object.deleteAfterShare);
  writer.writeString(offsets[5], object.displayName);
  writer.writeByte(offsets[6], object.retention.index);
  writer.writeDateTime(offsets[7], object.updatedAt);
  writer.writeString(offsets[8], object.userAId);
  writer.writeString(offsets[9], object.userBId);
}

P2PChat _p2PChatDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = P2PChat();
  object.autoCopyIncomingMessages = reader.readBool(offsets[0]);
  object.clipboardSharing = reader.readBool(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.deleteAfterCopy = reader.readBool(offsets[3]);
  object.deleteAfterShare = reader.readBool(offsets[4]);
  object.displayName = reader.readString(offsets[5]);
  object.id = id;
  object.retention =
      _P2PChatretentionValueEnumMap[reader.readByteOrNull(offsets[6])] ??
          MessageRetention.days7;
  object.updatedAt = reader.readDateTime(offsets[7]);
  object.userAId = reader.readString(offsets[8]);
  object.userBId = reader.readString(offsets[9]);
  return object;
}

P _p2PChatDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (_P2PChatretentionValueEnumMap[reader.readByteOrNull(offset)] ??
          MessageRetention.days7) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _P2PChatretentionEnumValueMap = {
  'days7': 0,
  'days15': 1,
  'days30': 2,
  'days60': 3,
  'days90': 4,
  'days180': 5,
  'days360': 6,
  'never': 7,
};
const _P2PChatretentionValueEnumMap = {
  0: MessageRetention.days7,
  1: MessageRetention.days15,
  2: MessageRetention.days30,
  3: MessageRetention.days60,
  4: MessageRetention.days90,
  5: MessageRetention.days180,
  6: MessageRetention.days360,
  7: MessageRetention.never,
};

Id _p2PChatGetId(P2PChat object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _p2PChatGetLinks(P2PChat object) {
  return [object.messages];
}

void _p2PChatAttach(IsarCollection<dynamic> col, Id id, P2PChat object) {
  object.id = id;
  object.messages
      .attach(col, col.isar.collection<P2PCMessage>(), r'messages', id);
}

extension P2PChatQueryWhereSort on QueryBuilder<P2PChat, P2PChat, QWhere> {
  QueryBuilder<P2PChat, P2PChat, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension P2PChatQueryWhere on QueryBuilder<P2PChat, P2PChat, QWhereClause> {
  QueryBuilder<P2PChat, P2PChat, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension P2PChatQueryFilter
    on QueryBuilder<P2PChat, P2PChat, QFilterCondition> {
  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition>
      autoCopyIncomingMessagesEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoCopyIncomingMessages',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> clipboardSharingEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clipboardSharing',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> deleteAfterCopyEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deleteAfterCopy',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> deleteAfterShareEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deleteAfterShare',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> displayNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> displayNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> displayNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> displayNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> displayNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> displayNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> displayNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> displayNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition>
      displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> retentionEqualTo(
      MessageRetention value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'retention',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> retentionGreaterThan(
    MessageRetention value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'retention',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> retentionLessThan(
    MessageRetention value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'retention',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> retentionBetween(
    MessageRetention lower,
    MessageRetention upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'retention',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userAIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userAId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userAIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userAId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userAIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userAId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userAIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userAId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userAIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userAId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userAIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userAId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userAIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userAId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userAIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userAId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userAIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userAId',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userAIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userAId',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userBIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userBId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userBIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userBId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userBIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userBId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userBIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userBId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userBIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userBId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userBIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userBId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userBIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userBId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userBIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userBId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userBIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userBId',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> userBIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userBId',
        value: '',
      ));
    });
  }
}

extension P2PChatQueryObject
    on QueryBuilder<P2PChat, P2PChat, QFilterCondition> {}

extension P2PChatQueryLinks
    on QueryBuilder<P2PChat, P2PChat, QFilterCondition> {
  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> messages(
      FilterQuery<P2PCMessage> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'messages');
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> messagesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'messages', length, true, length, true);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> messagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'messages', 0, true, 0, true);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> messagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'messages', 0, false, 999999, true);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> messagesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'messages', 0, true, length, include);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition>
      messagesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'messages', length, include, 999999, true);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterFilterCondition> messagesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'messages', lower, includeLower, upper, includeUpper);
    });
  }
}

extension P2PChatQuerySortBy on QueryBuilder<P2PChat, P2PChat, QSortBy> {
  QueryBuilder<P2PChat, P2PChat, QAfterSortBy>
      sortByAutoCopyIncomingMessages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoCopyIncomingMessages', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy>
      sortByAutoCopyIncomingMessagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoCopyIncomingMessages', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByClipboardSharing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clipboardSharing', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByClipboardSharingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clipboardSharing', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByDeleteAfterCopy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteAfterCopy', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByDeleteAfterCopyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteAfterCopy', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByDeleteAfterShare() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteAfterShare', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByDeleteAfterShareDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteAfterShare', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByRetention() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retention', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByRetentionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retention', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByUserAId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userAId', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByUserAIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userAId', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByUserBId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userBId', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> sortByUserBIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userBId', Sort.desc);
    });
  }
}

extension P2PChatQuerySortThenBy
    on QueryBuilder<P2PChat, P2PChat, QSortThenBy> {
  QueryBuilder<P2PChat, P2PChat, QAfterSortBy>
      thenByAutoCopyIncomingMessages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoCopyIncomingMessages', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy>
      thenByAutoCopyIncomingMessagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoCopyIncomingMessages', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByClipboardSharing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clipboardSharing', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByClipboardSharingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clipboardSharing', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByDeleteAfterCopy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteAfterCopy', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByDeleteAfterCopyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteAfterCopy', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByDeleteAfterShare() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteAfterShare', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByDeleteAfterShareDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteAfterShare', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByRetention() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retention', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByRetentionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retention', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByUserAId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userAId', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByUserAIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userAId', Sort.desc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByUserBId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userBId', Sort.asc);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QAfterSortBy> thenByUserBIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userBId', Sort.desc);
    });
  }
}

extension P2PChatQueryWhereDistinct
    on QueryBuilder<P2PChat, P2PChat, QDistinct> {
  QueryBuilder<P2PChat, P2PChat, QDistinct>
      distinctByAutoCopyIncomingMessages() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoCopyIncomingMessages');
    });
  }

  QueryBuilder<P2PChat, P2PChat, QDistinct> distinctByClipboardSharing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clipboardSharing');
    });
  }

  QueryBuilder<P2PChat, P2PChat, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<P2PChat, P2PChat, QDistinct> distinctByDeleteAfterCopy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deleteAfterCopy');
    });
  }

  QueryBuilder<P2PChat, P2PChat, QDistinct> distinctByDeleteAfterShare() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deleteAfterShare');
    });
  }

  QueryBuilder<P2PChat, P2PChat, QDistinct> distinctByDisplayName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QDistinct> distinctByRetention() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retention');
    });
  }

  QueryBuilder<P2PChat, P2PChat, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<P2PChat, P2PChat, QDistinct> distinctByUserAId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userAId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<P2PChat, P2PChat, QDistinct> distinctByUserBId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userBId', caseSensitive: caseSensitive);
    });
  }
}

extension P2PChatQueryProperty
    on QueryBuilder<P2PChat, P2PChat, QQueryProperty> {
  QueryBuilder<P2PChat, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<P2PChat, bool, QQueryOperations>
      autoCopyIncomingMessagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoCopyIncomingMessages');
    });
  }

  QueryBuilder<P2PChat, bool, QQueryOperations> clipboardSharingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clipboardSharing');
    });
  }

  QueryBuilder<P2PChat, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<P2PChat, bool, QQueryOperations> deleteAfterCopyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deleteAfterCopy');
    });
  }

  QueryBuilder<P2PChat, bool, QQueryOperations> deleteAfterShareProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deleteAfterShare');
    });
  }

  QueryBuilder<P2PChat, String, QQueryOperations> displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<P2PChat, MessageRetention, QQueryOperations>
      retentionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retention');
    });
  }

  QueryBuilder<P2PChat, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<P2PChat, String, QQueryOperations> userAIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userAId');
    });
  }

  QueryBuilder<P2PChat, String, QQueryOperations> userBIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userBId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetP2PCMessageCollection on Isar {
  IsarCollection<P2PCMessage> get p2PCMessages => this.collection();
}

const P2PCMessageSchema = CollectionSchema(
  name: r'P2PCMessage',
  id: 939390777613869699,
  properties: {
    r'content': PropertySchema(
      id: 0,
      name: r'content',
      type: IsarType.string,
    ),
    r'filePath': PropertySchema(
      id: 1,
      name: r'filePath',
      type: IsarType.string,
    ),
    r'senderId': PropertySchema(
      id: 2,
      name: r'senderId',
      type: IsarType.string,
    ),
    r'sentAt': PropertySchema(
      id: 3,
      name: r'sentAt',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 4,
      name: r'status',
      type: IsarType.byte,
      enumMap: _P2PCMessagestatusEnumValueMap,
    ),
    r'syncId': PropertySchema(
      id: 5,
      name: r'syncId',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 6,
      name: r'type',
      type: IsarType.byte,
      enumMap: _P2PCMessagetypeEnumValueMap,
    )
  },
  estimateSize: _p2PCMessageEstimateSize,
  serialize: _p2PCMessageSerialize,
  deserialize: _p2PCMessageDeserialize,
  deserializeProp: _p2PCMessageDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'chat': LinkSchema(
      id: 4897894041850331801,
      name: r'chat',
      target: r'P2PChat',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _p2PCMessageGetId,
  getLinks: _p2PCMessageGetLinks,
  attach: _p2PCMessageAttach,
  version: '3.1.0+1',
);

int _p2PCMessageEstimateSize(
  P2PCMessage object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.content.length * 3;
  {
    final value = object.filePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.senderId.length * 3;
  bytesCount += 3 + object.syncId.length * 3;
  return bytesCount;
}

void _p2PCMessageSerialize(
  P2PCMessage object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.content);
  writer.writeString(offsets[1], object.filePath);
  writer.writeString(offsets[2], object.senderId);
  writer.writeDateTime(offsets[3], object.sentAt);
  writer.writeByte(offsets[4], object.status.index);
  writer.writeString(offsets[5], object.syncId);
  writer.writeByte(offsets[6], object.type.index);
}

P2PCMessage _p2PCMessageDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = P2PCMessage();
  object.content = reader.readString(offsets[0]);
  object.filePath = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.senderId = reader.readString(offsets[2]);
  object.sentAt = reader.readDateTime(offsets[3]);
  object.status =
      _P2PCMessagestatusValueEnumMap[reader.readByteOrNull(offsets[4])] ??
          P2PCMessageStatus.waiting;
  object.syncId = reader.readString(offsets[5]);
  object.type =
      _P2PCMessagetypeValueEnumMap[reader.readByteOrNull(offsets[6])] ??
          P2PCMessageType.text;
  return object;
}

P _p2PCMessageDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (_P2PCMessagestatusValueEnumMap[reader.readByteOrNull(offset)] ??
          P2PCMessageStatus.waiting) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (_P2PCMessagetypeValueEnumMap[reader.readByteOrNull(offset)] ??
          P2PCMessageType.text) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _P2PCMessagestatusEnumValueMap = {
  'waiting': 0,
  'onDevice': 1,
  'request': 2,
  'lost': 3,
  'lostBoth': 4,
  'deleted': 5,
};
const _P2PCMessagestatusValueEnumMap = {
  0: P2PCMessageStatus.waiting,
  1: P2PCMessageStatus.onDevice,
  2: P2PCMessageStatus.request,
  3: P2PCMessageStatus.lost,
  4: P2PCMessageStatus.lostBoth,
  5: P2PCMessageStatus.deleted,
};
const _P2PCMessagetypeEnumValueMap = {
  'text': 0,
  'file': 1,
  'mediaImage': 2,
  'mediaVideo': 3,
};
const _P2PCMessagetypeValueEnumMap = {
  0: P2PCMessageType.text,
  1: P2PCMessageType.file,
  2: P2PCMessageType.mediaImage,
  3: P2PCMessageType.mediaVideo,
};

Id _p2PCMessageGetId(P2PCMessage object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _p2PCMessageGetLinks(P2PCMessage object) {
  return [object.chat];
}

void _p2PCMessageAttach(
    IsarCollection<dynamic> col, Id id, P2PCMessage object) {
  object.id = id;
  object.chat.attach(col, col.isar.collection<P2PChat>(), r'chat', id);
}

extension P2PCMessageQueryWhereSort
    on QueryBuilder<P2PCMessage, P2PCMessage, QWhere> {
  QueryBuilder<P2PCMessage, P2PCMessage, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension P2PCMessageQueryWhere
    on QueryBuilder<P2PCMessage, P2PCMessage, QWhereClause> {
  QueryBuilder<P2PCMessage, P2PCMessage, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension P2PCMessageQueryFilter
    on QueryBuilder<P2PCMessage, P2PCMessage, QFilterCondition> {
  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> contentContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> contentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      filePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'filePath',
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      filePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'filePath',
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> filePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      filePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      filePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> filePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'filePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      filePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      filePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      filePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> filePathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'filePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      filePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      filePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> senderIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'senderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      senderIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'senderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      senderIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'senderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> senderIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'senderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      senderIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'senderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      senderIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'senderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      senderIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'senderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> senderIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'senderId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      senderIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'senderId',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      senderIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'senderId',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> sentAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sentAt',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      sentAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sentAt',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> sentAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sentAt',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> sentAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sentAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> statusEqualTo(
      P2PCMessageStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      statusGreaterThan(
    P2PCMessageStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> statusLessThan(
    P2PCMessageStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> statusBetween(
    P2PCMessageStatus lower,
    P2PCMessageStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> syncIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      syncIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> syncIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> syncIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      syncIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'syncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> syncIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'syncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> syncIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'syncId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> syncIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'syncId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      syncIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncId',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition>
      syncIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncId',
        value: '',
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> typeEqualTo(
      P2PCMessageType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> typeGreaterThan(
    P2PCMessageType value, {
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

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> typeLessThan(
    P2PCMessageType value, {
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

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> typeBetween(
    P2PCMessageType lower,
    P2PCMessageType upper, {
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
}

extension P2PCMessageQueryObject
    on QueryBuilder<P2PCMessage, P2PCMessage, QFilterCondition> {}

extension P2PCMessageQueryLinks
    on QueryBuilder<P2PCMessage, P2PCMessage, QFilterCondition> {
  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> chat(
      FilterQuery<P2PChat> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'chat');
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterFilterCondition> chatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'chat', 0, true, 0, true);
    });
  }
}

extension P2PCMessageQuerySortBy
    on QueryBuilder<P2PCMessage, P2PCMessage, QSortBy> {
  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> sortByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> sortByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> sortBySenderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderId', Sort.asc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> sortBySenderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderId', Sort.desc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> sortBySentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentAt', Sort.asc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> sortBySentAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentAt', Sort.desc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> sortBySyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.asc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> sortBySyncIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.desc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension P2PCMessageQuerySortThenBy
    on QueryBuilder<P2PCMessage, P2PCMessage, QSortThenBy> {
  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> thenByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> thenByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> thenBySenderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderId', Sort.asc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> thenBySenderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderId', Sort.desc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> thenBySentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentAt', Sort.asc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> thenBySentAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentAt', Sort.desc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> thenBySyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.asc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> thenBySyncIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.desc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension P2PCMessageQueryWhereDistinct
    on QueryBuilder<P2PCMessage, P2PCMessage, QDistinct> {
  QueryBuilder<P2PCMessage, P2PCMessage, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QDistinct> distinctByFilePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QDistinct> distinctBySenderId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'senderId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QDistinct> distinctBySentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sentAt');
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QDistinct> distinctBySyncId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessage, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension P2PCMessageQueryProperty
    on QueryBuilder<P2PCMessage, P2PCMessage, QQueryProperty> {
  QueryBuilder<P2PCMessage, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<P2PCMessage, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<P2PCMessage, String?, QQueryOperations> filePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filePath');
    });
  }

  QueryBuilder<P2PCMessage, String, QQueryOperations> senderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'senderId');
    });
  }

  QueryBuilder<P2PCMessage, DateTime, QQueryOperations> sentAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sentAt');
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessageStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<P2PCMessage, String, QQueryOperations> syncIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncId');
    });
  }

  QueryBuilder<P2PCMessage, P2PCMessageType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
