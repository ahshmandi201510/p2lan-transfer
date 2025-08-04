// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_installation.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppInstallationCollection on Isar {
  IsarCollection<AppInstallation> get appInstallations => this.collection();
}

const AppInstallationSchema = CollectionSchema(
  name: r'AppInstallation',
  id: -8556603532728503639,
  properties: {
    r'firstTimeSetupCompleted': PropertySchema(
      id: 0,
      name: r'firstTimeSetupCompleted',
      type: IsarType.bool,
    ),
    r'installationId': PropertySchema(
      id: 1,
      name: r'installationId',
      type: IsarType.string,
    ),
    r'installationWordId': PropertySchema(
      id: 2,
      name: r'installationWordId',
      type: IsarType.string,
    )
  },
  estimateSize: _appInstallationEstimateSize,
  serialize: _appInstallationSerialize,
  deserialize: _appInstallationDeserialize,
  deserializeProp: _appInstallationDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appInstallationGetId,
  getLinks: _appInstallationGetLinks,
  attach: _appInstallationAttach,
  version: '3.1.0+1',
);

int _appInstallationEstimateSize(
  AppInstallation object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.installationId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.installationWordId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _appInstallationSerialize(
  AppInstallation object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.firstTimeSetupCompleted);
  writer.writeString(offsets[1], object.installationId);
  writer.writeString(offsets[2], object.installationWordId);
}

AppInstallation _appInstallationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppInstallation();
  object.firstTimeSetupCompleted = reader.readBoolOrNull(offsets[0]);
  object.id = id;
  object.installationId = reader.readStringOrNull(offsets[1]);
  object.installationWordId = reader.readStringOrNull(offsets[2]);
  return object;
}

P _appInstallationDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appInstallationGetId(AppInstallation object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appInstallationGetLinks(AppInstallation object) {
  return [];
}

void _appInstallationAttach(
    IsarCollection<dynamic> col, Id id, AppInstallation object) {
  object.id = id;
}

extension AppInstallationQueryWhereSort
    on QueryBuilder<AppInstallation, AppInstallation, QWhere> {
  QueryBuilder<AppInstallation, AppInstallation, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppInstallationQueryWhere
    on QueryBuilder<AppInstallation, AppInstallation, QWhereClause> {
  QueryBuilder<AppInstallation, AppInstallation, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<AppInstallation, AppInstallation, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterWhereClause> idBetween(
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

extension AppInstallationQueryFilter
    on QueryBuilder<AppInstallation, AppInstallation, QFilterCondition> {
  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      firstTimeSetupCompletedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'firstTimeSetupCompleted',
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      firstTimeSetupCompletedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'firstTimeSetupCompleted',
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      firstTimeSetupCompletedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstTimeSetupCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'installationId',
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'installationId',
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'installationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'installationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'installationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'installationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'installationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'installationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'installationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'installationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'installationId',
        value: '',
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'installationId',
        value: '',
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationWordIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'installationWordId',
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationWordIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'installationWordId',
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationWordIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'installationWordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationWordIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'installationWordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationWordIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'installationWordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationWordIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'installationWordId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationWordIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'installationWordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationWordIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'installationWordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationWordIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'installationWordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationWordIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'installationWordId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationWordIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'installationWordId',
        value: '',
      ));
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterFilterCondition>
      installationWordIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'installationWordId',
        value: '',
      ));
    });
  }
}

extension AppInstallationQueryObject
    on QueryBuilder<AppInstallation, AppInstallation, QFilterCondition> {}

extension AppInstallationQueryLinks
    on QueryBuilder<AppInstallation, AppInstallation, QFilterCondition> {}

extension AppInstallationQuerySortBy
    on QueryBuilder<AppInstallation, AppInstallation, QSortBy> {
  QueryBuilder<AppInstallation, AppInstallation, QAfterSortBy>
      sortByFirstTimeSetupCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstTimeSetupCompleted', Sort.asc);
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterSortBy>
      sortByFirstTimeSetupCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstTimeSetupCompleted', Sort.desc);
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterSortBy>
      sortByInstallationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installationId', Sort.asc);
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterSortBy>
      sortByInstallationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installationId', Sort.desc);
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterSortBy>
      sortByInstallationWordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installationWordId', Sort.asc);
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterSortBy>
      sortByInstallationWordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installationWordId', Sort.desc);
    });
  }
}

extension AppInstallationQuerySortThenBy
    on QueryBuilder<AppInstallation, AppInstallation, QSortThenBy> {
  QueryBuilder<AppInstallation, AppInstallation, QAfterSortBy>
      thenByFirstTimeSetupCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstTimeSetupCompleted', Sort.asc);
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterSortBy>
      thenByFirstTimeSetupCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstTimeSetupCompleted', Sort.desc);
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterSortBy>
      thenByInstallationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installationId', Sort.asc);
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterSortBy>
      thenByInstallationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installationId', Sort.desc);
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterSortBy>
      thenByInstallationWordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installationWordId', Sort.asc);
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QAfterSortBy>
      thenByInstallationWordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installationWordId', Sort.desc);
    });
  }
}

extension AppInstallationQueryWhereDistinct
    on QueryBuilder<AppInstallation, AppInstallation, QDistinct> {
  QueryBuilder<AppInstallation, AppInstallation, QDistinct>
      distinctByFirstTimeSetupCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstTimeSetupCompleted');
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QDistinct>
      distinctByInstallationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'installationId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppInstallation, AppInstallation, QDistinct>
      distinctByInstallationWordId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'installationWordId',
          caseSensitive: caseSensitive);
    });
  }
}

extension AppInstallationQueryProperty
    on QueryBuilder<AppInstallation, AppInstallation, QQueryProperty> {
  QueryBuilder<AppInstallation, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppInstallation, bool?, QQueryOperations>
      firstTimeSetupCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstTimeSetupCompleted');
    });
  }

  QueryBuilder<AppInstallation, String?, QQueryOperations>
      installationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'installationId');
    });
  }

  QueryBuilder<AppInstallation, String?, QQueryOperations>
      installationWordIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'installationWordId');
    });
  }
}
