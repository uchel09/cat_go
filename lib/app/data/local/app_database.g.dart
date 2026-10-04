// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $KategoriTable extends Kategori
    with TableInfo<$KategoriTable, KategoriData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KategoriTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urutanMeta = const VerificationMeta('urutan');
  @override
  late final GeneratedColumn<int> urutan = GeneratedColumn<int>(
    'urutan',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nama, urutan];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kategori';
  @override
  VerificationContext validateIntegrity(
    Insertable<KategoriData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('urutan')) {
      context.handle(
        _urutanMeta,
        urutan.isAcceptableOrUnknown(data['urutan']!, _urutanMeta),
      );
    } else if (isInserting) {
      context.missing(_urutanMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KategoriData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KategoriData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      urutan: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urutan'],
      )!,
    );
  }

  @override
  $KategoriTable createAlias(String alias) {
    return $KategoriTable(attachedDatabase, alias);
  }
}

class KategoriData extends DataClass implements Insertable<KategoriData> {
  final String id;
  final String nama;
  final int urutan;
  const KategoriData({
    required this.id,
    required this.nama,
    required this.urutan,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nama'] = Variable<String>(nama);
    map['urutan'] = Variable<int>(urutan);
    return map;
  }

  KategoriCompanion toCompanion(bool nullToAbsent) {
    return KategoriCompanion(
      id: Value(id),
      nama: Value(nama),
      urutan: Value(urutan),
    );
  }

  factory KategoriData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KategoriData(
      id: serializer.fromJson<String>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
      urutan: serializer.fromJson<int>(json['urutan']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nama': serializer.toJson<String>(nama),
      'urutan': serializer.toJson<int>(urutan),
    };
  }

  KategoriData copyWith({String? id, String? nama, int? urutan}) =>
      KategoriData(
        id: id ?? this.id,
        nama: nama ?? this.nama,
        urutan: urutan ?? this.urutan,
      );
  KategoriData copyWithCompanion(KategoriCompanion data) {
    return KategoriData(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      urutan: data.urutan.present ? data.urutan.value : this.urutan,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KategoriData(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('urutan: $urutan')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nama, urutan);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KategoriData &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.urutan == this.urutan);
}

class KategoriCompanion extends UpdateCompanion<KategoriData> {
  final Value<String> id;
  final Value<String> nama;
  final Value<int> urutan;
  final Value<int> rowid;
  const KategoriCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.urutan = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KategoriCompanion.insert({
    required String id,
    required String nama,
    required int urutan,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nama = Value(nama),
       urutan = Value(urutan);
  static Insertable<KategoriData> custom({
    Expression<String>? id,
    Expression<String>? nama,
    Expression<int>? urutan,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (urutan != null) 'urutan': urutan,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KategoriCompanion copyWith({
    Value<String>? id,
    Value<String>? nama,
    Value<int>? urutan,
    Value<int>? rowid,
  }) {
    return KategoriCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      urutan: urutan ?? this.urutan,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (urutan.present) {
      map['urutan'] = Variable<int>(urutan.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KategoriCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('urutan: $urutan, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TesTable extends Tes with TableInfo<$TesTable, TesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kategoriIdMeta = const VerificationMeta(
    'kategoriId',
  );
  @override
  late final GeneratedColumn<String> kategoriId = GeneratedColumn<String>(
    'kategori_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kategori (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urutanMeta = const VerificationMeta('urutan');
  @override
  late final GeneratedColumn<int> urutan = GeneratedColumn<int>(
    'urutan',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, kategoriId, nama, urutan, packId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tes';
  @override
  VerificationContext validateIntegrity(
    Insertable<TesData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kategori_id')) {
      context.handle(
        _kategoriIdMeta,
        kategoriId.isAcceptableOrUnknown(data['kategori_id']!, _kategoriIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kategoriIdMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('urutan')) {
      context.handle(
        _urutanMeta,
        urutan.isAcceptableOrUnknown(data['urutan']!, _urutanMeta),
      );
    } else if (isInserting) {
      context.missing(_urutanMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kategoriId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kategori_id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      urutan: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urutan'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
    );
  }

  @override
  $TesTable createAlias(String alias) {
    return $TesTable(attachedDatabase, alias);
  }
}

class TesData extends DataClass implements Insertable<TesData> {
  final String id;
  final String kategoriId;
  final String nama;
  final int urutan;
  final String packId;
  const TesData({
    required this.id,
    required this.kategoriId,
    required this.nama,
    required this.urutan,
    required this.packId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kategori_id'] = Variable<String>(kategoriId);
    map['nama'] = Variable<String>(nama);
    map['urutan'] = Variable<int>(urutan);
    map['pack_id'] = Variable<String>(packId);
    return map;
  }

  TesCompanion toCompanion(bool nullToAbsent) {
    return TesCompanion(
      id: Value(id),
      kategoriId: Value(kategoriId),
      nama: Value(nama),
      urutan: Value(urutan),
      packId: Value(packId),
    );
  }

  factory TesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TesData(
      id: serializer.fromJson<String>(json['id']),
      kategoriId: serializer.fromJson<String>(json['kategoriId']),
      nama: serializer.fromJson<String>(json['nama']),
      urutan: serializer.fromJson<int>(json['urutan']),
      packId: serializer.fromJson<String>(json['packId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kategoriId': serializer.toJson<String>(kategoriId),
      'nama': serializer.toJson<String>(nama),
      'urutan': serializer.toJson<int>(urutan),
      'packId': serializer.toJson<String>(packId),
    };
  }

  TesData copyWith({
    String? id,
    String? kategoriId,
    String? nama,
    int? urutan,
    String? packId,
  }) => TesData(
    id: id ?? this.id,
    kategoriId: kategoriId ?? this.kategoriId,
    nama: nama ?? this.nama,
    urutan: urutan ?? this.urutan,
    packId: packId ?? this.packId,
  );
  TesData copyWithCompanion(TesCompanion data) {
    return TesData(
      id: data.id.present ? data.id.value : this.id,
      kategoriId: data.kategoriId.present
          ? data.kategoriId.value
          : this.kategoriId,
      nama: data.nama.present ? data.nama.value : this.nama,
      urutan: data.urutan.present ? data.urutan.value : this.urutan,
      packId: data.packId.present ? data.packId.value : this.packId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TesData(')
          ..write('id: $id, ')
          ..write('kategoriId: $kategoriId, ')
          ..write('nama: $nama, ')
          ..write('urutan: $urutan, ')
          ..write('packId: $packId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kategoriId, nama, urutan, packId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TesData &&
          other.id == this.id &&
          other.kategoriId == this.kategoriId &&
          other.nama == this.nama &&
          other.urutan == this.urutan &&
          other.packId == this.packId);
}

class TesCompanion extends UpdateCompanion<TesData> {
  final Value<String> id;
  final Value<String> kategoriId;
  final Value<String> nama;
  final Value<int> urutan;
  final Value<String> packId;
  final Value<int> rowid;
  const TesCompanion({
    this.id = const Value.absent(),
    this.kategoriId = const Value.absent(),
    this.nama = const Value.absent(),
    this.urutan = const Value.absent(),
    this.packId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TesCompanion.insert({
    required String id,
    required String kategoriId,
    required String nama,
    required int urutan,
    required String packId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kategoriId = Value(kategoriId),
       nama = Value(nama),
       urutan = Value(urutan),
       packId = Value(packId);
  static Insertable<TesData> custom({
    Expression<String>? id,
    Expression<String>? kategoriId,
    Expression<String>? nama,
    Expression<int>? urutan,
    Expression<String>? packId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kategoriId != null) 'kategori_id': kategoriId,
      if (nama != null) 'nama': nama,
      if (urutan != null) 'urutan': urutan,
      if (packId != null) 'pack_id': packId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TesCompanion copyWith({
    Value<String>? id,
    Value<String>? kategoriId,
    Value<String>? nama,
    Value<int>? urutan,
    Value<String>? packId,
    Value<int>? rowid,
  }) {
    return TesCompanion(
      id: id ?? this.id,
      kategoriId: kategoriId ?? this.kategoriId,
      nama: nama ?? this.nama,
      urutan: urutan ?? this.urutan,
      packId: packId ?? this.packId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kategoriId.present) {
      map['kategori_id'] = Variable<String>(kategoriId.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (urutan.present) {
      map['urutan'] = Variable<int>(urutan.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TesCompanion(')
          ..write('id: $id, ')
          ..write('kategoriId: $kategoriId, ')
          ..write('nama: $nama, ')
          ..write('urutan: $urutan, ')
          ..write('packId: $packId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubtesTable extends Subtes with TableInfo<$SubtesTable, SubtesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubtesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tesIdMeta = const VerificationMeta('tesId');
  @override
  late final GeneratedColumn<String> tesId = GeneratedColumn<String>(
    'tes_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durasiMenitMeta = const VerificationMeta(
    'durasiMenit',
  );
  @override
  late final GeneratedColumn<int> durasiMenit = GeneratedColumn<int>(
    'durasi_menit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urutanMeta = const VerificationMeta('urutan');
  @override
  late final GeneratedColumn<int> urutan = GeneratedColumn<int>(
    'urutan',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, tesId, nama, durasiMenit, urutan];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subtes';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubtesData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tes_id')) {
      context.handle(
        _tesIdMeta,
        tesId.isAcceptableOrUnknown(data['tes_id']!, _tesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tesIdMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('durasi_menit')) {
      context.handle(
        _durasiMenitMeta,
        durasiMenit.isAcceptableOrUnknown(
          data['durasi_menit']!,
          _durasiMenitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durasiMenitMeta);
    }
    if (data.containsKey('urutan')) {
      context.handle(
        _urutanMeta,
        urutan.isAcceptableOrUnknown(data['urutan']!, _urutanMeta),
      );
    } else if (isInserting) {
      context.missing(_urutanMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubtesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubtesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tes_id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      durasiMenit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}durasi_menit'],
      )!,
      urutan: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urutan'],
      )!,
    );
  }

  @override
  $SubtesTable createAlias(String alias) {
    return $SubtesTable(attachedDatabase, alias);
  }
}

class SubtesData extends DataClass implements Insertable<SubtesData> {
  final String id;
  final String tesId;
  final String nama;
  final int durasiMenit;
  final int urutan;
  const SubtesData({
    required this.id,
    required this.tesId,
    required this.nama,
    required this.durasiMenit,
    required this.urutan,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tes_id'] = Variable<String>(tesId);
    map['nama'] = Variable<String>(nama);
    map['durasi_menit'] = Variable<int>(durasiMenit);
    map['urutan'] = Variable<int>(urutan);
    return map;
  }

  SubtesCompanion toCompanion(bool nullToAbsent) {
    return SubtesCompanion(
      id: Value(id),
      tesId: Value(tesId),
      nama: Value(nama),
      durasiMenit: Value(durasiMenit),
      urutan: Value(urutan),
    );
  }

  factory SubtesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubtesData(
      id: serializer.fromJson<String>(json['id']),
      tesId: serializer.fromJson<String>(json['tesId']),
      nama: serializer.fromJson<String>(json['nama']),
      durasiMenit: serializer.fromJson<int>(json['durasiMenit']),
      urutan: serializer.fromJson<int>(json['urutan']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tesId': serializer.toJson<String>(tesId),
      'nama': serializer.toJson<String>(nama),
      'durasiMenit': serializer.toJson<int>(durasiMenit),
      'urutan': serializer.toJson<int>(urutan),
    };
  }

  SubtesData copyWith({
    String? id,
    String? tesId,
    String? nama,
    int? durasiMenit,
    int? urutan,
  }) => SubtesData(
    id: id ?? this.id,
    tesId: tesId ?? this.tesId,
    nama: nama ?? this.nama,
    durasiMenit: durasiMenit ?? this.durasiMenit,
    urutan: urutan ?? this.urutan,
  );
  SubtesData copyWithCompanion(SubtesCompanion data) {
    return SubtesData(
      id: data.id.present ? data.id.value : this.id,
      tesId: data.tesId.present ? data.tesId.value : this.tesId,
      nama: data.nama.present ? data.nama.value : this.nama,
      durasiMenit: data.durasiMenit.present
          ? data.durasiMenit.value
          : this.durasiMenit,
      urutan: data.urutan.present ? data.urutan.value : this.urutan,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubtesData(')
          ..write('id: $id, ')
          ..write('tesId: $tesId, ')
          ..write('nama: $nama, ')
          ..write('durasiMenit: $durasiMenit, ')
          ..write('urutan: $urutan')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tesId, nama, durasiMenit, urutan);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubtesData &&
          other.id == this.id &&
          other.tesId == this.tesId &&
          other.nama == this.nama &&
          other.durasiMenit == this.durasiMenit &&
          other.urutan == this.urutan);
}

class SubtesCompanion extends UpdateCompanion<SubtesData> {
  final Value<String> id;
  final Value<String> tesId;
  final Value<String> nama;
  final Value<int> durasiMenit;
  final Value<int> urutan;
  final Value<int> rowid;
  const SubtesCompanion({
    this.id = const Value.absent(),
    this.tesId = const Value.absent(),
    this.nama = const Value.absent(),
    this.durasiMenit = const Value.absent(),
    this.urutan = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubtesCompanion.insert({
    required String id,
    required String tesId,
    required String nama,
    required int durasiMenit,
    required int urutan,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tesId = Value(tesId),
       nama = Value(nama),
       durasiMenit = Value(durasiMenit),
       urutan = Value(urutan);
  static Insertable<SubtesData> custom({
    Expression<String>? id,
    Expression<String>? tesId,
    Expression<String>? nama,
    Expression<int>? durasiMenit,
    Expression<int>? urutan,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tesId != null) 'tes_id': tesId,
      if (nama != null) 'nama': nama,
      if (durasiMenit != null) 'durasi_menit': durasiMenit,
      if (urutan != null) 'urutan': urutan,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubtesCompanion copyWith({
    Value<String>? id,
    Value<String>? tesId,
    Value<String>? nama,
    Value<int>? durasiMenit,
    Value<int>? urutan,
    Value<int>? rowid,
  }) {
    return SubtesCompanion(
      id: id ?? this.id,
      tesId: tesId ?? this.tesId,
      nama: nama ?? this.nama,
      durasiMenit: durasiMenit ?? this.durasiMenit,
      urutan: urutan ?? this.urutan,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tesId.present) {
      map['tes_id'] = Variable<String>(tesId.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (durasiMenit.present) {
      map['durasi_menit'] = Variable<int>(durasiMenit.value);
    }
    if (urutan.present) {
      map['urutan'] = Variable<int>(urutan.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubtesCompanion(')
          ..write('id: $id, ')
          ..write('tesId: $tesId, ')
          ..write('nama: $nama, ')
          ..write('durasiMenit: $durasiMenit, ')
          ..write('urutan: $urutan, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StimulusTable extends Stimulus
    with TableInfo<$StimulusTable, StimulusData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StimulusTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtesIdMeta = const VerificationMeta(
    'subtesId',
  );
  @override
  late final GeneratedColumn<String> subtesId = GeneratedColumn<String>(
    'subtes_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subtes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _judulMeta = const VerificationMeta('judul');
  @override
  late final GeneratedColumn<String> judul = GeneratedColumn<String>(
    'judul',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isiMeta = const VerificationMeta('isi');
  @override
  late final GeneratedColumn<String> isi = GeneratedColumn<String>(
    'isi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urutanMeta = const VerificationMeta('urutan');
  @override
  late final GeneratedColumn<int> urutan = GeneratedColumn<int>(
    'urutan',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, subtesId, judul, isi, urutan];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stimulus';
  @override
  VerificationContext validateIntegrity(
    Insertable<StimulusData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subtes_id')) {
      context.handle(
        _subtesIdMeta,
        subtesId.isAcceptableOrUnknown(data['subtes_id']!, _subtesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subtesIdMeta);
    }
    if (data.containsKey('judul')) {
      context.handle(
        _judulMeta,
        judul.isAcceptableOrUnknown(data['judul']!, _judulMeta),
      );
    }
    if (data.containsKey('isi')) {
      context.handle(
        _isiMeta,
        isi.isAcceptableOrUnknown(data['isi']!, _isiMeta),
      );
    } else if (isInserting) {
      context.missing(_isiMeta);
    }
    if (data.containsKey('urutan')) {
      context.handle(
        _urutanMeta,
        urutan.isAcceptableOrUnknown(data['urutan']!, _urutanMeta),
      );
    } else if (isInserting) {
      context.missing(_urutanMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StimulusData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StimulusData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subtesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtes_id'],
      )!,
      judul: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}judul'],
      ),
      isi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}isi'],
      )!,
      urutan: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urutan'],
      )!,
    );
  }

  @override
  $StimulusTable createAlias(String alias) {
    return $StimulusTable(attachedDatabase, alias);
  }
}

class StimulusData extends DataClass implements Insertable<StimulusData> {
  final String id;
  final String subtesId;
  final String? judul;
  final String isi;
  final int urutan;
  const StimulusData({
    required this.id,
    required this.subtesId,
    this.judul,
    required this.isi,
    required this.urutan,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subtes_id'] = Variable<String>(subtesId);
    if (!nullToAbsent || judul != null) {
      map['judul'] = Variable<String>(judul);
    }
    map['isi'] = Variable<String>(isi);
    map['urutan'] = Variable<int>(urutan);
    return map;
  }

  StimulusCompanion toCompanion(bool nullToAbsent) {
    return StimulusCompanion(
      id: Value(id),
      subtesId: Value(subtesId),
      judul: judul == null && nullToAbsent
          ? const Value.absent()
          : Value(judul),
      isi: Value(isi),
      urutan: Value(urutan),
    );
  }

  factory StimulusData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StimulusData(
      id: serializer.fromJson<String>(json['id']),
      subtesId: serializer.fromJson<String>(json['subtesId']),
      judul: serializer.fromJson<String?>(json['judul']),
      isi: serializer.fromJson<String>(json['isi']),
      urutan: serializer.fromJson<int>(json['urutan']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subtesId': serializer.toJson<String>(subtesId),
      'judul': serializer.toJson<String?>(judul),
      'isi': serializer.toJson<String>(isi),
      'urutan': serializer.toJson<int>(urutan),
    };
  }

  StimulusData copyWith({
    String? id,
    String? subtesId,
    Value<String?> judul = const Value.absent(),
    String? isi,
    int? urutan,
  }) => StimulusData(
    id: id ?? this.id,
    subtesId: subtesId ?? this.subtesId,
    judul: judul.present ? judul.value : this.judul,
    isi: isi ?? this.isi,
    urutan: urutan ?? this.urutan,
  );
  StimulusData copyWithCompanion(StimulusCompanion data) {
    return StimulusData(
      id: data.id.present ? data.id.value : this.id,
      subtesId: data.subtesId.present ? data.subtesId.value : this.subtesId,
      judul: data.judul.present ? data.judul.value : this.judul,
      isi: data.isi.present ? data.isi.value : this.isi,
      urutan: data.urutan.present ? data.urutan.value : this.urutan,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StimulusData(')
          ..write('id: $id, ')
          ..write('subtesId: $subtesId, ')
          ..write('judul: $judul, ')
          ..write('isi: $isi, ')
          ..write('urutan: $urutan')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, subtesId, judul, isi, urutan);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StimulusData &&
          other.id == this.id &&
          other.subtesId == this.subtesId &&
          other.judul == this.judul &&
          other.isi == this.isi &&
          other.urutan == this.urutan);
}

class StimulusCompanion extends UpdateCompanion<StimulusData> {
  final Value<String> id;
  final Value<String> subtesId;
  final Value<String?> judul;
  final Value<String> isi;
  final Value<int> urutan;
  final Value<int> rowid;
  const StimulusCompanion({
    this.id = const Value.absent(),
    this.subtesId = const Value.absent(),
    this.judul = const Value.absent(),
    this.isi = const Value.absent(),
    this.urutan = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StimulusCompanion.insert({
    required String id,
    required String subtesId,
    this.judul = const Value.absent(),
    required String isi,
    required int urutan,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subtesId = Value(subtesId),
       isi = Value(isi),
       urutan = Value(urutan);
  static Insertable<StimulusData> custom({
    Expression<String>? id,
    Expression<String>? subtesId,
    Expression<String>? judul,
    Expression<String>? isi,
    Expression<int>? urutan,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subtesId != null) 'subtes_id': subtesId,
      if (judul != null) 'judul': judul,
      if (isi != null) 'isi': isi,
      if (urutan != null) 'urutan': urutan,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StimulusCompanion copyWith({
    Value<String>? id,
    Value<String>? subtesId,
    Value<String?>? judul,
    Value<String>? isi,
    Value<int>? urutan,
    Value<int>? rowid,
  }) {
    return StimulusCompanion(
      id: id ?? this.id,
      subtesId: subtesId ?? this.subtesId,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      urutan: urutan ?? this.urutan,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subtesId.present) {
      map['subtes_id'] = Variable<String>(subtesId.value);
    }
    if (judul.present) {
      map['judul'] = Variable<String>(judul.value);
    }
    if (isi.present) {
      map['isi'] = Variable<String>(isi.value);
    }
    if (urutan.present) {
      map['urutan'] = Variable<int>(urutan.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StimulusCompanion(')
          ..write('id: $id, ')
          ..write('subtesId: $subtesId, ')
          ..write('judul: $judul, ')
          ..write('isi: $isi, ')
          ..write('urutan: $urutan, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SoalTable extends Soal with TableInfo<$SoalTable, SoalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SoalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtesIdMeta = const VerificationMeta(
    'subtesId',
  );
  @override
  late final GeneratedColumn<String> subtesId = GeneratedColumn<String>(
    'subtes_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subtes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _stimulusIdMeta = const VerificationMeta(
    'stimulusId',
  );
  @override
  late final GeneratedColumn<String> stimulusId = GeneratedColumn<String>(
    'stimulus_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stimulus (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _urutanMeta = const VerificationMeta('urutan');
  @override
  late final GeneratedColumn<int> urutan = GeneratedColumn<int>(
    'urutan',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teksMeta = const VerificationMeta('teks');
  @override
  late final GeneratedColumn<String> teks = GeneratedColumn<String>(
    'teks',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String>
  opsi = GeneratedColumn<String>(
    'opsi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, String>>($SoalTable.$converteropsi);
  static const VerificationMeta _jawabanBenarMeta = const VerificationMeta(
    'jawabanBenar',
  );
  @override
  late final GeneratedColumn<String> jawabanBenar = GeneratedColumn<String>(
    'jawaban_benar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pembahasanMeta = const VerificationMeta(
    'pembahasan',
  );
  @override
  late final GeneratedColumn<String> pembahasan = GeneratedColumn<String>(
    'pembahasan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aktifMeta = const VerificationMeta('aktif');
  @override
  late final GeneratedColumn<bool> aktif = GeneratedColumn<bool>(
    'aktif',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("aktif" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subtesId,
    stimulusId,
    urutan,
    teks,
    opsi,
    jawabanBenar,
    pembahasan,
    aktif,
    packId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'soal';
  @override
  VerificationContext validateIntegrity(
    Insertable<SoalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subtes_id')) {
      context.handle(
        _subtesIdMeta,
        subtesId.isAcceptableOrUnknown(data['subtes_id']!, _subtesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subtesIdMeta);
    }
    if (data.containsKey('stimulus_id')) {
      context.handle(
        _stimulusIdMeta,
        stimulusId.isAcceptableOrUnknown(data['stimulus_id']!, _stimulusIdMeta),
      );
    }
    if (data.containsKey('urutan')) {
      context.handle(
        _urutanMeta,
        urutan.isAcceptableOrUnknown(data['urutan']!, _urutanMeta),
      );
    } else if (isInserting) {
      context.missing(_urutanMeta);
    }
    if (data.containsKey('teks')) {
      context.handle(
        _teksMeta,
        teks.isAcceptableOrUnknown(data['teks']!, _teksMeta),
      );
    } else if (isInserting) {
      context.missing(_teksMeta);
    }
    if (data.containsKey('jawaban_benar')) {
      context.handle(
        _jawabanBenarMeta,
        jawabanBenar.isAcceptableOrUnknown(
          data['jawaban_benar']!,
          _jawabanBenarMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_jawabanBenarMeta);
    }
    if (data.containsKey('pembahasan')) {
      context.handle(
        _pembahasanMeta,
        pembahasan.isAcceptableOrUnknown(data['pembahasan']!, _pembahasanMeta),
      );
    }
    if (data.containsKey('aktif')) {
      context.handle(
        _aktifMeta,
        aktif.isAcceptableOrUnknown(data['aktif']!, _aktifMeta),
      );
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SoalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SoalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subtesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtes_id'],
      )!,
      stimulusId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stimulus_id'],
      ),
      urutan: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urutan'],
      )!,
      teks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teks'],
      )!,
      opsi: $SoalTable.$converteropsi.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}opsi'],
        )!,
      ),
      jawabanBenar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jawaban_benar'],
      )!,
      pembahasan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pembahasan'],
      ),
      aktif: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}aktif'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
    );
  }

  @override
  $SoalTable createAlias(String alias) {
    return $SoalTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, String>, String> $converteropsi =
      const MapStringConverter();
}

class SoalData extends DataClass implements Insertable<SoalData> {
  final String id;
  final String subtesId;
  final String? stimulusId;
  final int urutan;
  final String teks;
  final Map<String, String> opsi;
  final String jawabanBenar;
  final String? pembahasan;
  final bool aktif;
  final String packId;
  const SoalData({
    required this.id,
    required this.subtesId,
    this.stimulusId,
    required this.urutan,
    required this.teks,
    required this.opsi,
    required this.jawabanBenar,
    this.pembahasan,
    required this.aktif,
    required this.packId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subtes_id'] = Variable<String>(subtesId);
    if (!nullToAbsent || stimulusId != null) {
      map['stimulus_id'] = Variable<String>(stimulusId);
    }
    map['urutan'] = Variable<int>(urutan);
    map['teks'] = Variable<String>(teks);
    {
      map['opsi'] = Variable<String>($SoalTable.$converteropsi.toSql(opsi));
    }
    map['jawaban_benar'] = Variable<String>(jawabanBenar);
    if (!nullToAbsent || pembahasan != null) {
      map['pembahasan'] = Variable<String>(pembahasan);
    }
    map['aktif'] = Variable<bool>(aktif);
    map['pack_id'] = Variable<String>(packId);
    return map;
  }

  SoalCompanion toCompanion(bool nullToAbsent) {
    return SoalCompanion(
      id: Value(id),
      subtesId: Value(subtesId),
      stimulusId: stimulusId == null && nullToAbsent
          ? const Value.absent()
          : Value(stimulusId),
      urutan: Value(urutan),
      teks: Value(teks),
      opsi: Value(opsi),
      jawabanBenar: Value(jawabanBenar),
      pembahasan: pembahasan == null && nullToAbsent
          ? const Value.absent()
          : Value(pembahasan),
      aktif: Value(aktif),
      packId: Value(packId),
    );
  }

  factory SoalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SoalData(
      id: serializer.fromJson<String>(json['id']),
      subtesId: serializer.fromJson<String>(json['subtesId']),
      stimulusId: serializer.fromJson<String?>(json['stimulusId']),
      urutan: serializer.fromJson<int>(json['urutan']),
      teks: serializer.fromJson<String>(json['teks']),
      opsi: serializer.fromJson<Map<String, String>>(json['opsi']),
      jawabanBenar: serializer.fromJson<String>(json['jawabanBenar']),
      pembahasan: serializer.fromJson<String?>(json['pembahasan']),
      aktif: serializer.fromJson<bool>(json['aktif']),
      packId: serializer.fromJson<String>(json['packId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subtesId': serializer.toJson<String>(subtesId),
      'stimulusId': serializer.toJson<String?>(stimulusId),
      'urutan': serializer.toJson<int>(urutan),
      'teks': serializer.toJson<String>(teks),
      'opsi': serializer.toJson<Map<String, String>>(opsi),
      'jawabanBenar': serializer.toJson<String>(jawabanBenar),
      'pembahasan': serializer.toJson<String?>(pembahasan),
      'aktif': serializer.toJson<bool>(aktif),
      'packId': serializer.toJson<String>(packId),
    };
  }

  SoalData copyWith({
    String? id,
    String? subtesId,
    Value<String?> stimulusId = const Value.absent(),
    int? urutan,
    String? teks,
    Map<String, String>? opsi,
    String? jawabanBenar,
    Value<String?> pembahasan = const Value.absent(),
    bool? aktif,
    String? packId,
  }) => SoalData(
    id: id ?? this.id,
    subtesId: subtesId ?? this.subtesId,
    stimulusId: stimulusId.present ? stimulusId.value : this.stimulusId,
    urutan: urutan ?? this.urutan,
    teks: teks ?? this.teks,
    opsi: opsi ?? this.opsi,
    jawabanBenar: jawabanBenar ?? this.jawabanBenar,
    pembahasan: pembahasan.present ? pembahasan.value : this.pembahasan,
    aktif: aktif ?? this.aktif,
    packId: packId ?? this.packId,
  );
  SoalData copyWithCompanion(SoalCompanion data) {
    return SoalData(
      id: data.id.present ? data.id.value : this.id,
      subtesId: data.subtesId.present ? data.subtesId.value : this.subtesId,
      stimulusId: data.stimulusId.present
          ? data.stimulusId.value
          : this.stimulusId,
      urutan: data.urutan.present ? data.urutan.value : this.urutan,
      teks: data.teks.present ? data.teks.value : this.teks,
      opsi: data.opsi.present ? data.opsi.value : this.opsi,
      jawabanBenar: data.jawabanBenar.present
          ? data.jawabanBenar.value
          : this.jawabanBenar,
      pembahasan: data.pembahasan.present
          ? data.pembahasan.value
          : this.pembahasan,
      aktif: data.aktif.present ? data.aktif.value : this.aktif,
      packId: data.packId.present ? data.packId.value : this.packId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SoalData(')
          ..write('id: $id, ')
          ..write('subtesId: $subtesId, ')
          ..write('stimulusId: $stimulusId, ')
          ..write('urutan: $urutan, ')
          ..write('teks: $teks, ')
          ..write('opsi: $opsi, ')
          ..write('jawabanBenar: $jawabanBenar, ')
          ..write('pembahasan: $pembahasan, ')
          ..write('aktif: $aktif, ')
          ..write('packId: $packId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subtesId,
    stimulusId,
    urutan,
    teks,
    opsi,
    jawabanBenar,
    pembahasan,
    aktif,
    packId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SoalData &&
          other.id == this.id &&
          other.subtesId == this.subtesId &&
          other.stimulusId == this.stimulusId &&
          other.urutan == this.urutan &&
          other.teks == this.teks &&
          other.opsi == this.opsi &&
          other.jawabanBenar == this.jawabanBenar &&
          other.pembahasan == this.pembahasan &&
          other.aktif == this.aktif &&
          other.packId == this.packId);
}

class SoalCompanion extends UpdateCompanion<SoalData> {
  final Value<String> id;
  final Value<String> subtesId;
  final Value<String?> stimulusId;
  final Value<int> urutan;
  final Value<String> teks;
  final Value<Map<String, String>> opsi;
  final Value<String> jawabanBenar;
  final Value<String?> pembahasan;
  final Value<bool> aktif;
  final Value<String> packId;
  final Value<int> rowid;
  const SoalCompanion({
    this.id = const Value.absent(),
    this.subtesId = const Value.absent(),
    this.stimulusId = const Value.absent(),
    this.urutan = const Value.absent(),
    this.teks = const Value.absent(),
    this.opsi = const Value.absent(),
    this.jawabanBenar = const Value.absent(),
    this.pembahasan = const Value.absent(),
    this.aktif = const Value.absent(),
    this.packId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SoalCompanion.insert({
    required String id,
    required String subtesId,
    this.stimulusId = const Value.absent(),
    required int urutan,
    required String teks,
    required Map<String, String> opsi,
    required String jawabanBenar,
    this.pembahasan = const Value.absent(),
    this.aktif = const Value.absent(),
    required String packId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subtesId = Value(subtesId),
       urutan = Value(urutan),
       teks = Value(teks),
       opsi = Value(opsi),
       jawabanBenar = Value(jawabanBenar),
       packId = Value(packId);
  static Insertable<SoalData> custom({
    Expression<String>? id,
    Expression<String>? subtesId,
    Expression<String>? stimulusId,
    Expression<int>? urutan,
    Expression<String>? teks,
    Expression<String>? opsi,
    Expression<String>? jawabanBenar,
    Expression<String>? pembahasan,
    Expression<bool>? aktif,
    Expression<String>? packId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subtesId != null) 'subtes_id': subtesId,
      if (stimulusId != null) 'stimulus_id': stimulusId,
      if (urutan != null) 'urutan': urutan,
      if (teks != null) 'teks': teks,
      if (opsi != null) 'opsi': opsi,
      if (jawabanBenar != null) 'jawaban_benar': jawabanBenar,
      if (pembahasan != null) 'pembahasan': pembahasan,
      if (aktif != null) 'aktif': aktif,
      if (packId != null) 'pack_id': packId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SoalCompanion copyWith({
    Value<String>? id,
    Value<String>? subtesId,
    Value<String?>? stimulusId,
    Value<int>? urutan,
    Value<String>? teks,
    Value<Map<String, String>>? opsi,
    Value<String>? jawabanBenar,
    Value<String?>? pembahasan,
    Value<bool>? aktif,
    Value<String>? packId,
    Value<int>? rowid,
  }) {
    return SoalCompanion(
      id: id ?? this.id,
      subtesId: subtesId ?? this.subtesId,
      stimulusId: stimulusId ?? this.stimulusId,
      urutan: urutan ?? this.urutan,
      teks: teks ?? this.teks,
      opsi: opsi ?? this.opsi,
      jawabanBenar: jawabanBenar ?? this.jawabanBenar,
      pembahasan: pembahasan ?? this.pembahasan,
      aktif: aktif ?? this.aktif,
      packId: packId ?? this.packId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subtesId.present) {
      map['subtes_id'] = Variable<String>(subtesId.value);
    }
    if (stimulusId.present) {
      map['stimulus_id'] = Variable<String>(stimulusId.value);
    }
    if (urutan.present) {
      map['urutan'] = Variable<int>(urutan.value);
    }
    if (teks.present) {
      map['teks'] = Variable<String>(teks.value);
    }
    if (opsi.present) {
      map['opsi'] = Variable<String>(
        $SoalTable.$converteropsi.toSql(opsi.value),
      );
    }
    if (jawabanBenar.present) {
      map['jawaban_benar'] = Variable<String>(jawabanBenar.value);
    }
    if (pembahasan.present) {
      map['pembahasan'] = Variable<String>(pembahasan.value);
    }
    if (aktif.present) {
      map['aktif'] = Variable<bool>(aktif.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SoalCompanion(')
          ..write('id: $id, ')
          ..write('subtesId: $subtesId, ')
          ..write('stimulusId: $stimulusId, ')
          ..write('urutan: $urutan, ')
          ..write('teks: $teks, ')
          ..write('opsi: $opsi, ')
          ..write('jawabanBenar: $jawabanBenar, ')
          ..write('pembahasan: $pembahasan, ')
          ..write('aktif: $aktif, ')
          ..write('packId: $packId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaketTerpasangTable extends PaketTerpasang
    with TableInfo<$PaketTerpasangTable, PaketTerpasangData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaketTerpasangTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packVersionMeta = const VerificationMeta(
    'packVersion',
  );
  @override
  late final GeneratedColumn<int> packVersion = GeneratedColumn<int>(
    'pack_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tanggalPasangMeta = const VerificationMeta(
    'tanggalPasang',
  );
  @override
  late final GeneratedColumn<DateTime> tanggalPasang =
      GeneratedColumn<DateTime>(
        'tanggal_pasang',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    packId,
    packVersion,
    nama,
    tanggalPasang,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'paket_terpasang';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaketTerpasangData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('pack_version')) {
      context.handle(
        _packVersionMeta,
        packVersion.isAcceptableOrUnknown(
          data['pack_version']!,
          _packVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packVersionMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('tanggal_pasang')) {
      context.handle(
        _tanggalPasangMeta,
        tanggalPasang.isAcceptableOrUnknown(
          data['tanggal_pasang']!,
          _tanggalPasangMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tanggalPasangMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packId};
  @override
  PaketTerpasangData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaketTerpasangData(
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      packVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pack_version'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      tanggalPasang: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal_pasang'],
      )!,
    );
  }

  @override
  $PaketTerpasangTable createAlias(String alias) {
    return $PaketTerpasangTable(attachedDatabase, alias);
  }
}

class PaketTerpasangData extends DataClass
    implements Insertable<PaketTerpasangData> {
  final String packId;
  final int packVersion;
  final String nama;
  final DateTime tanggalPasang;
  const PaketTerpasangData({
    required this.packId,
    required this.packVersion,
    required this.nama,
    required this.tanggalPasang,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pack_id'] = Variable<String>(packId);
    map['pack_version'] = Variable<int>(packVersion);
    map['nama'] = Variable<String>(nama);
    map['tanggal_pasang'] = Variable<DateTime>(tanggalPasang);
    return map;
  }

  PaketTerpasangCompanion toCompanion(bool nullToAbsent) {
    return PaketTerpasangCompanion(
      packId: Value(packId),
      packVersion: Value(packVersion),
      nama: Value(nama),
      tanggalPasang: Value(tanggalPasang),
    );
  }

  factory PaketTerpasangData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaketTerpasangData(
      packId: serializer.fromJson<String>(json['packId']),
      packVersion: serializer.fromJson<int>(json['packVersion']),
      nama: serializer.fromJson<String>(json['nama']),
      tanggalPasang: serializer.fromJson<DateTime>(json['tanggalPasang']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packId': serializer.toJson<String>(packId),
      'packVersion': serializer.toJson<int>(packVersion),
      'nama': serializer.toJson<String>(nama),
      'tanggalPasang': serializer.toJson<DateTime>(tanggalPasang),
    };
  }

  PaketTerpasangData copyWith({
    String? packId,
    int? packVersion,
    String? nama,
    DateTime? tanggalPasang,
  }) => PaketTerpasangData(
    packId: packId ?? this.packId,
    packVersion: packVersion ?? this.packVersion,
    nama: nama ?? this.nama,
    tanggalPasang: tanggalPasang ?? this.tanggalPasang,
  );
  PaketTerpasangData copyWithCompanion(PaketTerpasangCompanion data) {
    return PaketTerpasangData(
      packId: data.packId.present ? data.packId.value : this.packId,
      packVersion: data.packVersion.present
          ? data.packVersion.value
          : this.packVersion,
      nama: data.nama.present ? data.nama.value : this.nama,
      tanggalPasang: data.tanggalPasang.present
          ? data.tanggalPasang.value
          : this.tanggalPasang,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaketTerpasangData(')
          ..write('packId: $packId, ')
          ..write('packVersion: $packVersion, ')
          ..write('nama: $nama, ')
          ..write('tanggalPasang: $tanggalPasang')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packId, packVersion, nama, tanggalPasang);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaketTerpasangData &&
          other.packId == this.packId &&
          other.packVersion == this.packVersion &&
          other.nama == this.nama &&
          other.tanggalPasang == this.tanggalPasang);
}

class PaketTerpasangCompanion extends UpdateCompanion<PaketTerpasangData> {
  final Value<String> packId;
  final Value<int> packVersion;
  final Value<String> nama;
  final Value<DateTime> tanggalPasang;
  final Value<int> rowid;
  const PaketTerpasangCompanion({
    this.packId = const Value.absent(),
    this.packVersion = const Value.absent(),
    this.nama = const Value.absent(),
    this.tanggalPasang = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaketTerpasangCompanion.insert({
    required String packId,
    required int packVersion,
    required String nama,
    required DateTime tanggalPasang,
    this.rowid = const Value.absent(),
  }) : packId = Value(packId),
       packVersion = Value(packVersion),
       nama = Value(nama),
       tanggalPasang = Value(tanggalPasang);
  static Insertable<PaketTerpasangData> custom({
    Expression<String>? packId,
    Expression<int>? packVersion,
    Expression<String>? nama,
    Expression<DateTime>? tanggalPasang,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packId != null) 'pack_id': packId,
      if (packVersion != null) 'pack_version': packVersion,
      if (nama != null) 'nama': nama,
      if (tanggalPasang != null) 'tanggal_pasang': tanggalPasang,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaketTerpasangCompanion copyWith({
    Value<String>? packId,
    Value<int>? packVersion,
    Value<String>? nama,
    Value<DateTime>? tanggalPasang,
    Value<int>? rowid,
  }) {
    return PaketTerpasangCompanion(
      packId: packId ?? this.packId,
      packVersion: packVersion ?? this.packVersion,
      nama: nama ?? this.nama,
      tanggalPasang: tanggalPasang ?? this.tanggalPasang,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (packVersion.present) {
      map['pack_version'] = Variable<int>(packVersion.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (tanggalPasang.present) {
      map['tanggal_pasang'] = Variable<DateTime>(tanggalPasang.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaketTerpasangCompanion(')
          ..write('packId: $packId, ')
          ..write('packVersion: $packVersion, ')
          ..write('nama: $nama, ')
          ..write('tanggalPasang: $tanggalPasang, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttemptSubtesTable extends AttemptSubtes
    with TableInfo<$AttemptSubtesTable, AttemptSubtesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttemptSubtesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _subtesIdMeta = const VerificationMeta(
    'subtesId',
  );
  @override
  late final GeneratedColumn<String> subtesId = GeneratedColumn<String>(
    'subtes_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subtes (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SubtesStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SubtesStatus>($AttemptSubtesTable.$converterstatus);
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mulaiAtMeta = const VerificationMeta(
    'mulaiAt',
  );
  @override
  late final GeneratedColumn<DateTime> mulaiAt = GeneratedColumn<DateTime>(
    'mulai_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selesaiAtMeta = const VerificationMeta(
    'selesaiAt',
  );
  @override
  late final GeneratedColumn<DateTime> selesaiAt = GeneratedColumn<DateTime>(
    'selesai_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _benarMeta = const VerificationMeta('benar');
  @override
  late final GeneratedColumn<int> benar = GeneratedColumn<int>(
    'benar',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _salahMeta = const VerificationMeta('salah');
  @override
  late final GeneratedColumn<int> salah = GeneratedColumn<int>(
    'salah',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kosongMeta = const VerificationMeta('kosong');
  @override
  late final GeneratedColumn<int> kosong = GeneratedColumn<int>(
    'kosong',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalSoalMeta = const VerificationMeta(
    'totalSoal',
  );
  @override
  late final GeneratedColumn<int> totalSoal = GeneratedColumn<int>(
    'total_soal',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    subtesId,
    status,
    endTime,
    mulaiAt,
    selesaiAt,
    benar,
    salah,
    kosong,
    totalSoal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attempt_subtes';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttemptSubtesData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('subtes_id')) {
      context.handle(
        _subtesIdMeta,
        subtesId.isAcceptableOrUnknown(data['subtes_id']!, _subtesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subtesIdMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('mulai_at')) {
      context.handle(
        _mulaiAtMeta,
        mulaiAt.isAcceptableOrUnknown(data['mulai_at']!, _mulaiAtMeta),
      );
    }
    if (data.containsKey('selesai_at')) {
      context.handle(
        _selesaiAtMeta,
        selesaiAt.isAcceptableOrUnknown(data['selesai_at']!, _selesaiAtMeta),
      );
    }
    if (data.containsKey('benar')) {
      context.handle(
        _benarMeta,
        benar.isAcceptableOrUnknown(data['benar']!, _benarMeta),
      );
    }
    if (data.containsKey('salah')) {
      context.handle(
        _salahMeta,
        salah.isAcceptableOrUnknown(data['salah']!, _salahMeta),
      );
    }
    if (data.containsKey('kosong')) {
      context.handle(
        _kosongMeta,
        kosong.isAcceptableOrUnknown(data['kosong']!, _kosongMeta),
      );
    }
    if (data.containsKey('total_soal')) {
      context.handle(
        _totalSoalMeta,
        totalSoal.isAcceptableOrUnknown(data['total_soal']!, _totalSoalMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {subtesId};
  @override
  AttemptSubtesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttemptSubtesData(
      subtesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtes_id'],
      )!,
      status: $AttemptSubtesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      ),
      mulaiAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}mulai_at'],
      ),
      selesaiAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}selesai_at'],
      ),
      benar: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}benar'],
      ),
      salah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}salah'],
      ),
      kosong: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kosong'],
      ),
      totalSoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_soal'],
      ),
    );
  }

  @override
  $AttemptSubtesTable createAlias(String alias) {
    return $AttemptSubtesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SubtesStatus, String, String> $converterstatus =
      const EnumNameConverter<SubtesStatus>(SubtesStatus.values);
}

class AttemptSubtesData extends DataClass
    implements Insertable<AttemptSubtesData> {
  final String subtesId;
  final SubtesStatus status;
  final DateTime? endTime;
  final DateTime? mulaiAt;
  final DateTime? selesaiAt;
  final int? benar;
  final int? salah;
  final int? kosong;
  final int? totalSoal;
  const AttemptSubtesData({
    required this.subtesId,
    required this.status,
    this.endTime,
    this.mulaiAt,
    this.selesaiAt,
    this.benar,
    this.salah,
    this.kosong,
    this.totalSoal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['subtes_id'] = Variable<String>(subtesId);
    {
      map['status'] = Variable<String>(
        $AttemptSubtesTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    if (!nullToAbsent || mulaiAt != null) {
      map['mulai_at'] = Variable<DateTime>(mulaiAt);
    }
    if (!nullToAbsent || selesaiAt != null) {
      map['selesai_at'] = Variable<DateTime>(selesaiAt);
    }
    if (!nullToAbsent || benar != null) {
      map['benar'] = Variable<int>(benar);
    }
    if (!nullToAbsent || salah != null) {
      map['salah'] = Variable<int>(salah);
    }
    if (!nullToAbsent || kosong != null) {
      map['kosong'] = Variable<int>(kosong);
    }
    if (!nullToAbsent || totalSoal != null) {
      map['total_soal'] = Variable<int>(totalSoal);
    }
    return map;
  }

  AttemptSubtesCompanion toCompanion(bool nullToAbsent) {
    return AttemptSubtesCompanion(
      subtesId: Value(subtesId),
      status: Value(status),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      mulaiAt: mulaiAt == null && nullToAbsent
          ? const Value.absent()
          : Value(mulaiAt),
      selesaiAt: selesaiAt == null && nullToAbsent
          ? const Value.absent()
          : Value(selesaiAt),
      benar: benar == null && nullToAbsent
          ? const Value.absent()
          : Value(benar),
      salah: salah == null && nullToAbsent
          ? const Value.absent()
          : Value(salah),
      kosong: kosong == null && nullToAbsent
          ? const Value.absent()
          : Value(kosong),
      totalSoal: totalSoal == null && nullToAbsent
          ? const Value.absent()
          : Value(totalSoal),
    );
  }

  factory AttemptSubtesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttemptSubtesData(
      subtesId: serializer.fromJson<String>(json['subtesId']),
      status: $AttemptSubtesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      mulaiAt: serializer.fromJson<DateTime?>(json['mulaiAt']),
      selesaiAt: serializer.fromJson<DateTime?>(json['selesaiAt']),
      benar: serializer.fromJson<int?>(json['benar']),
      salah: serializer.fromJson<int?>(json['salah']),
      kosong: serializer.fromJson<int?>(json['kosong']),
      totalSoal: serializer.fromJson<int?>(json['totalSoal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'subtesId': serializer.toJson<String>(subtesId),
      'status': serializer.toJson<String>(
        $AttemptSubtesTable.$converterstatus.toJson(status),
      ),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'mulaiAt': serializer.toJson<DateTime?>(mulaiAt),
      'selesaiAt': serializer.toJson<DateTime?>(selesaiAt),
      'benar': serializer.toJson<int?>(benar),
      'salah': serializer.toJson<int?>(salah),
      'kosong': serializer.toJson<int?>(kosong),
      'totalSoal': serializer.toJson<int?>(totalSoal),
    };
  }

  AttemptSubtesData copyWith({
    String? subtesId,
    SubtesStatus? status,
    Value<DateTime?> endTime = const Value.absent(),
    Value<DateTime?> mulaiAt = const Value.absent(),
    Value<DateTime?> selesaiAt = const Value.absent(),
    Value<int?> benar = const Value.absent(),
    Value<int?> salah = const Value.absent(),
    Value<int?> kosong = const Value.absent(),
    Value<int?> totalSoal = const Value.absent(),
  }) => AttemptSubtesData(
    subtesId: subtesId ?? this.subtesId,
    status: status ?? this.status,
    endTime: endTime.present ? endTime.value : this.endTime,
    mulaiAt: mulaiAt.present ? mulaiAt.value : this.mulaiAt,
    selesaiAt: selesaiAt.present ? selesaiAt.value : this.selesaiAt,
    benar: benar.present ? benar.value : this.benar,
    salah: salah.present ? salah.value : this.salah,
    kosong: kosong.present ? kosong.value : this.kosong,
    totalSoal: totalSoal.present ? totalSoal.value : this.totalSoal,
  );
  AttemptSubtesData copyWithCompanion(AttemptSubtesCompanion data) {
    return AttemptSubtesData(
      subtesId: data.subtesId.present ? data.subtesId.value : this.subtesId,
      status: data.status.present ? data.status.value : this.status,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      mulaiAt: data.mulaiAt.present ? data.mulaiAt.value : this.mulaiAt,
      selesaiAt: data.selesaiAt.present ? data.selesaiAt.value : this.selesaiAt,
      benar: data.benar.present ? data.benar.value : this.benar,
      salah: data.salah.present ? data.salah.value : this.salah,
      kosong: data.kosong.present ? data.kosong.value : this.kosong,
      totalSoal: data.totalSoal.present ? data.totalSoal.value : this.totalSoal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttemptSubtesData(')
          ..write('subtesId: $subtesId, ')
          ..write('status: $status, ')
          ..write('endTime: $endTime, ')
          ..write('mulaiAt: $mulaiAt, ')
          ..write('selesaiAt: $selesaiAt, ')
          ..write('benar: $benar, ')
          ..write('salah: $salah, ')
          ..write('kosong: $kosong, ')
          ..write('totalSoal: $totalSoal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    subtesId,
    status,
    endTime,
    mulaiAt,
    selesaiAt,
    benar,
    salah,
    kosong,
    totalSoal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttemptSubtesData &&
          other.subtesId == this.subtesId &&
          other.status == this.status &&
          other.endTime == this.endTime &&
          other.mulaiAt == this.mulaiAt &&
          other.selesaiAt == this.selesaiAt &&
          other.benar == this.benar &&
          other.salah == this.salah &&
          other.kosong == this.kosong &&
          other.totalSoal == this.totalSoal);
}

class AttemptSubtesCompanion extends UpdateCompanion<AttemptSubtesData> {
  final Value<String> subtesId;
  final Value<SubtesStatus> status;
  final Value<DateTime?> endTime;
  final Value<DateTime?> mulaiAt;
  final Value<DateTime?> selesaiAt;
  final Value<int?> benar;
  final Value<int?> salah;
  final Value<int?> kosong;
  final Value<int?> totalSoal;
  final Value<int> rowid;
  const AttemptSubtesCompanion({
    this.subtesId = const Value.absent(),
    this.status = const Value.absent(),
    this.endTime = const Value.absent(),
    this.mulaiAt = const Value.absent(),
    this.selesaiAt = const Value.absent(),
    this.benar = const Value.absent(),
    this.salah = const Value.absent(),
    this.kosong = const Value.absent(),
    this.totalSoal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttemptSubtesCompanion.insert({
    required String subtesId,
    required SubtesStatus status,
    this.endTime = const Value.absent(),
    this.mulaiAt = const Value.absent(),
    this.selesaiAt = const Value.absent(),
    this.benar = const Value.absent(),
    this.salah = const Value.absent(),
    this.kosong = const Value.absent(),
    this.totalSoal = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : subtesId = Value(subtesId),
       status = Value(status);
  static Insertable<AttemptSubtesData> custom({
    Expression<String>? subtesId,
    Expression<String>? status,
    Expression<DateTime>? endTime,
    Expression<DateTime>? mulaiAt,
    Expression<DateTime>? selesaiAt,
    Expression<int>? benar,
    Expression<int>? salah,
    Expression<int>? kosong,
    Expression<int>? totalSoal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (subtesId != null) 'subtes_id': subtesId,
      if (status != null) 'status': status,
      if (endTime != null) 'end_time': endTime,
      if (mulaiAt != null) 'mulai_at': mulaiAt,
      if (selesaiAt != null) 'selesai_at': selesaiAt,
      if (benar != null) 'benar': benar,
      if (salah != null) 'salah': salah,
      if (kosong != null) 'kosong': kosong,
      if (totalSoal != null) 'total_soal': totalSoal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttemptSubtesCompanion copyWith({
    Value<String>? subtesId,
    Value<SubtesStatus>? status,
    Value<DateTime?>? endTime,
    Value<DateTime?>? mulaiAt,
    Value<DateTime?>? selesaiAt,
    Value<int?>? benar,
    Value<int?>? salah,
    Value<int?>? kosong,
    Value<int?>? totalSoal,
    Value<int>? rowid,
  }) {
    return AttemptSubtesCompanion(
      subtesId: subtesId ?? this.subtesId,
      status: status ?? this.status,
      endTime: endTime ?? this.endTime,
      mulaiAt: mulaiAt ?? this.mulaiAt,
      selesaiAt: selesaiAt ?? this.selesaiAt,
      benar: benar ?? this.benar,
      salah: salah ?? this.salah,
      kosong: kosong ?? this.kosong,
      totalSoal: totalSoal ?? this.totalSoal,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (subtesId.present) {
      map['subtes_id'] = Variable<String>(subtesId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $AttemptSubtesTable.$converterstatus.toSql(status.value),
      );
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (mulaiAt.present) {
      map['mulai_at'] = Variable<DateTime>(mulaiAt.value);
    }
    if (selesaiAt.present) {
      map['selesai_at'] = Variable<DateTime>(selesaiAt.value);
    }
    if (benar.present) {
      map['benar'] = Variable<int>(benar.value);
    }
    if (salah.present) {
      map['salah'] = Variable<int>(salah.value);
    }
    if (kosong.present) {
      map['kosong'] = Variable<int>(kosong.value);
    }
    if (totalSoal.present) {
      map['total_soal'] = Variable<int>(totalSoal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttemptSubtesCompanion(')
          ..write('subtesId: $subtesId, ')
          ..write('status: $status, ')
          ..write('endTime: $endTime, ')
          ..write('mulaiAt: $mulaiAt, ')
          ..write('selesaiAt: $selesaiAt, ')
          ..write('benar: $benar, ')
          ..write('salah: $salah, ')
          ..write('kosong: $kosong, ')
          ..write('totalSoal: $totalSoal, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JawabanTable extends Jawaban with TableInfo<$JawabanTable, JawabanData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JawabanTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _subtesIdMeta = const VerificationMeta(
    'subtesId',
  );
  @override
  late final GeneratedColumn<String> subtesId = GeneratedColumn<String>(
    'subtes_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subtes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _soalIdMeta = const VerificationMeta('soalId');
  @override
  late final GeneratedColumn<String> soalId = GeneratedColumn<String>(
    'soal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES soal (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _opsiMeta = const VerificationMeta('opsi');
  @override
  late final GeneratedColumn<String> opsi = GeneratedColumn<String>(
    'opsi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [subtesId, soalId, opsi];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'jawaban';
  @override
  VerificationContext validateIntegrity(
    Insertable<JawabanData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('subtes_id')) {
      context.handle(
        _subtesIdMeta,
        subtesId.isAcceptableOrUnknown(data['subtes_id']!, _subtesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subtesIdMeta);
    }
    if (data.containsKey('soal_id')) {
      context.handle(
        _soalIdMeta,
        soalId.isAcceptableOrUnknown(data['soal_id']!, _soalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_soalIdMeta);
    }
    if (data.containsKey('opsi')) {
      context.handle(
        _opsiMeta,
        opsi.isAcceptableOrUnknown(data['opsi']!, _opsiMeta),
      );
    } else if (isInserting) {
      context.missing(_opsiMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {subtesId, soalId};
  @override
  JawabanData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JawabanData(
      subtesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtes_id'],
      )!,
      soalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}soal_id'],
      )!,
      opsi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opsi'],
      )!,
    );
  }

  @override
  $JawabanTable createAlias(String alias) {
    return $JawabanTable(attachedDatabase, alias);
  }
}

class JawabanData extends DataClass implements Insertable<JawabanData> {
  final String subtesId;
  final String soalId;
  final String opsi;
  const JawabanData({
    required this.subtesId,
    required this.soalId,
    required this.opsi,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['subtes_id'] = Variable<String>(subtesId);
    map['soal_id'] = Variable<String>(soalId);
    map['opsi'] = Variable<String>(opsi);
    return map;
  }

  JawabanCompanion toCompanion(bool nullToAbsent) {
    return JawabanCompanion(
      subtesId: Value(subtesId),
      soalId: Value(soalId),
      opsi: Value(opsi),
    );
  }

  factory JawabanData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JawabanData(
      subtesId: serializer.fromJson<String>(json['subtesId']),
      soalId: serializer.fromJson<String>(json['soalId']),
      opsi: serializer.fromJson<String>(json['opsi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'subtesId': serializer.toJson<String>(subtesId),
      'soalId': serializer.toJson<String>(soalId),
      'opsi': serializer.toJson<String>(opsi),
    };
  }

  JawabanData copyWith({String? subtesId, String? soalId, String? opsi}) =>
      JawabanData(
        subtesId: subtesId ?? this.subtesId,
        soalId: soalId ?? this.soalId,
        opsi: opsi ?? this.opsi,
      );
  JawabanData copyWithCompanion(JawabanCompanion data) {
    return JawabanData(
      subtesId: data.subtesId.present ? data.subtesId.value : this.subtesId,
      soalId: data.soalId.present ? data.soalId.value : this.soalId,
      opsi: data.opsi.present ? data.opsi.value : this.opsi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JawabanData(')
          ..write('subtesId: $subtesId, ')
          ..write('soalId: $soalId, ')
          ..write('opsi: $opsi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(subtesId, soalId, opsi);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JawabanData &&
          other.subtesId == this.subtesId &&
          other.soalId == this.soalId &&
          other.opsi == this.opsi);
}

class JawabanCompanion extends UpdateCompanion<JawabanData> {
  final Value<String> subtesId;
  final Value<String> soalId;
  final Value<String> opsi;
  final Value<int> rowid;
  const JawabanCompanion({
    this.subtesId = const Value.absent(),
    this.soalId = const Value.absent(),
    this.opsi = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JawabanCompanion.insert({
    required String subtesId,
    required String soalId,
    required String opsi,
    this.rowid = const Value.absent(),
  }) : subtesId = Value(subtesId),
       soalId = Value(soalId),
       opsi = Value(opsi);
  static Insertable<JawabanData> custom({
    Expression<String>? subtesId,
    Expression<String>? soalId,
    Expression<String>? opsi,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (subtesId != null) 'subtes_id': subtesId,
      if (soalId != null) 'soal_id': soalId,
      if (opsi != null) 'opsi': opsi,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JawabanCompanion copyWith({
    Value<String>? subtesId,
    Value<String>? soalId,
    Value<String>? opsi,
    Value<int>? rowid,
  }) {
    return JawabanCompanion(
      subtesId: subtesId ?? this.subtesId,
      soalId: soalId ?? this.soalId,
      opsi: opsi ?? this.opsi,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (subtesId.present) {
      map['subtes_id'] = Variable<String>(subtesId.value);
    }
    if (soalId.present) {
      map['soal_id'] = Variable<String>(soalId.value);
    }
    if (opsi.present) {
      map['opsi'] = Variable<String>(opsi.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JawabanCompanion(')
          ..write('subtesId: $subtesId, ')
          ..write('soalId: $soalId, ')
          ..write('opsi: $opsi, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RaguTable extends Ragu with TableInfo<$RaguTable, RaguData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RaguTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _subtesIdMeta = const VerificationMeta(
    'subtesId',
  );
  @override
  late final GeneratedColumn<String> subtesId = GeneratedColumn<String>(
    'subtes_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subtes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _soalIdMeta = const VerificationMeta('soalId');
  @override
  late final GeneratedColumn<String> soalId = GeneratedColumn<String>(
    'soal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES soal (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [subtesId, soalId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ragu';
  @override
  VerificationContext validateIntegrity(
    Insertable<RaguData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('subtes_id')) {
      context.handle(
        _subtesIdMeta,
        subtesId.isAcceptableOrUnknown(data['subtes_id']!, _subtesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subtesIdMeta);
    }
    if (data.containsKey('soal_id')) {
      context.handle(
        _soalIdMeta,
        soalId.isAcceptableOrUnknown(data['soal_id']!, _soalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_soalIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {subtesId, soalId};
  @override
  RaguData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RaguData(
      subtesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtes_id'],
      )!,
      soalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}soal_id'],
      )!,
    );
  }

  @override
  $RaguTable createAlias(String alias) {
    return $RaguTable(attachedDatabase, alias);
  }
}

class RaguData extends DataClass implements Insertable<RaguData> {
  final String subtesId;
  final String soalId;
  const RaguData({required this.subtesId, required this.soalId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['subtes_id'] = Variable<String>(subtesId);
    map['soal_id'] = Variable<String>(soalId);
    return map;
  }

  RaguCompanion toCompanion(bool nullToAbsent) {
    return RaguCompanion(subtesId: Value(subtesId), soalId: Value(soalId));
  }

  factory RaguData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RaguData(
      subtesId: serializer.fromJson<String>(json['subtesId']),
      soalId: serializer.fromJson<String>(json['soalId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'subtesId': serializer.toJson<String>(subtesId),
      'soalId': serializer.toJson<String>(soalId),
    };
  }

  RaguData copyWith({String? subtesId, String? soalId}) => RaguData(
    subtesId: subtesId ?? this.subtesId,
    soalId: soalId ?? this.soalId,
  );
  RaguData copyWithCompanion(RaguCompanion data) {
    return RaguData(
      subtesId: data.subtesId.present ? data.subtesId.value : this.subtesId,
      soalId: data.soalId.present ? data.soalId.value : this.soalId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RaguData(')
          ..write('subtesId: $subtesId, ')
          ..write('soalId: $soalId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(subtesId, soalId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RaguData &&
          other.subtesId == this.subtesId &&
          other.soalId == this.soalId);
}

class RaguCompanion extends UpdateCompanion<RaguData> {
  final Value<String> subtesId;
  final Value<String> soalId;
  final Value<int> rowid;
  const RaguCompanion({
    this.subtesId = const Value.absent(),
    this.soalId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RaguCompanion.insert({
    required String subtesId,
    required String soalId,
    this.rowid = const Value.absent(),
  }) : subtesId = Value(subtesId),
       soalId = Value(soalId);
  static Insertable<RaguData> custom({
    Expression<String>? subtesId,
    Expression<String>? soalId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (subtesId != null) 'subtes_id': subtesId,
      if (soalId != null) 'soal_id': soalId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RaguCompanion copyWith({
    Value<String>? subtesId,
    Value<String>? soalId,
    Value<int>? rowid,
  }) {
    return RaguCompanion(
      subtesId: subtesId ?? this.subtesId,
      soalId: soalId ?? this.soalId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (subtesId.present) {
      map['subtes_id'] = Variable<String>(subtesId.value);
    }
    if (soalId.present) {
      map['soal_id'] = Variable<String>(soalId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RaguCompanion(')
          ..write('subtesId: $subtesId, ')
          ..write('soalId: $soalId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $KategoriTable kategori = $KategoriTable(this);
  late final $TesTable tes = $TesTable(this);
  late final $SubtesTable subtes = $SubtesTable(this);
  late final $StimulusTable stimulus = $StimulusTable(this);
  late final $SoalTable soal = $SoalTable(this);
  late final $PaketTerpasangTable paketTerpasang = $PaketTerpasangTable(this);
  late final $AttemptSubtesTable attemptSubtes = $AttemptSubtesTable(this);
  late final $JawabanTable jawaban = $JawabanTable(this);
  late final $RaguTable ragu = $RaguTable(this);
  late final Index soalSubtesUrutanIdx = Index(
    'soal_subtes_urutan_idx',
    'CREATE INDEX soal_subtes_urutan_idx ON soal (subtes_id, urutan)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    kategori,
    tes,
    subtes,
    stimulus,
    soal,
    paketTerpasang,
    attemptSubtes,
    jawaban,
    ragu,
    soalSubtesUrutanIdx,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'kategori',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('subtes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'subtes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stimulus', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'subtes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('soal', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stimulus',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('soal', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'subtes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('attempt_subtes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'subtes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('jawaban', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'soal',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('jawaban', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'subtes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ragu', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'soal',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ragu', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$KategoriTableCreateCompanionBuilder =
    KategoriCompanion Function({
      required String id,
      required String nama,
      required int urutan,
      Value<int> rowid,
    });
typedef $$KategoriTableUpdateCompanionBuilder =
    KategoriCompanion Function({
      Value<String> id,
      Value<String> nama,
      Value<int> urutan,
      Value<int> rowid,
    });

final class $$KategoriTableReferences
    extends BaseReferences<_$AppDatabase, $KategoriTable, KategoriData> {
  $$KategoriTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TesTable, List<TesData>> _tesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tes,
    aliasName: 'kategori__id__tes__kategori_id',
  );

  $$TesTableProcessedTableManager get tesRefs {
    final manager = $$TesTableTableManager(
      $_db,
      $_db.tes,
    ).filter((f) => f.kategoriId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$KategoriTableFilterComposer
    extends Composer<_$AppDatabase, $KategoriTable> {
  $$KategoriTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get urutan => $composableBuilder(
    column: $table.urutan,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tesRefs(
    Expression<bool> Function($$TesTableFilterComposer f) f,
  ) {
    final $$TesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tes,
      getReferencedColumn: (t) => t.kategoriId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TesTableFilterComposer(
            $db: $db,
            $table: $db.tes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KategoriTableOrderingComposer
    extends Composer<_$AppDatabase, $KategoriTable> {
  $$KategoriTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get urutan => $composableBuilder(
    column: $table.urutan,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KategoriTableAnnotationComposer
    extends Composer<_$AppDatabase, $KategoriTable> {
  $$KategoriTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<int> get urutan =>
      $composableBuilder(column: $table.urutan, builder: (column) => column);

  Expression<T> tesRefs<T extends Object>(
    Expression<T> Function($$TesTableAnnotationComposer a) f,
  ) {
    final $$TesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tes,
      getReferencedColumn: (t) => t.kategoriId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TesTableAnnotationComposer(
            $db: $db,
            $table: $db.tes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KategoriTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KategoriTable,
          KategoriData,
          $$KategoriTableFilterComposer,
          $$KategoriTableOrderingComposer,
          $$KategoriTableAnnotationComposer,
          $$KategoriTableCreateCompanionBuilder,
          $$KategoriTableUpdateCompanionBuilder,
          (KategoriData, $$KategoriTableReferences),
          KategoriData,
          PrefetchHooks Function({bool tesRefs})
        > {
  $$KategoriTableTableManager(_$AppDatabase db, $KategoriTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KategoriTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KategoriTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KategoriTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<int> urutan = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KategoriCompanion(
                id: id,
                nama: nama,
                urutan: urutan,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nama,
                required int urutan,
                Value<int> rowid = const Value.absent(),
              }) => KategoriCompanion.insert(
                id: id,
                nama: nama,
                urutan: urutan,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KategoriTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tesRefs) db.tes],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tesRefs)
                    await $_getPrefetchedData<
                      KategoriData,
                      $KategoriTable,
                      TesData
                    >(
                      currentTable: table,
                      referencedTable: $$KategoriTableReferences._tesRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$KategoriTableReferences(db, table, p0).tesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.kategoriId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$KategoriTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KategoriTable,
      KategoriData,
      $$KategoriTableFilterComposer,
      $$KategoriTableOrderingComposer,
      $$KategoriTableAnnotationComposer,
      $$KategoriTableCreateCompanionBuilder,
      $$KategoriTableUpdateCompanionBuilder,
      (KategoriData, $$KategoriTableReferences),
      KategoriData,
      PrefetchHooks Function({bool tesRefs})
    >;
typedef $$TesTableCreateCompanionBuilder =
    TesCompanion Function({
      required String id,
      required String kategoriId,
      required String nama,
      required int urutan,
      required String packId,
      Value<int> rowid,
    });
typedef $$TesTableUpdateCompanionBuilder =
    TesCompanion Function({
      Value<String> id,
      Value<String> kategoriId,
      Value<String> nama,
      Value<int> urutan,
      Value<String> packId,
      Value<int> rowid,
    });

final class $$TesTableReferences
    extends BaseReferences<_$AppDatabase, $TesTable, TesData> {
  $$TesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $KategoriTable _kategoriIdTable(_$AppDatabase db) =>
      db.kategori.createAlias('tes__kategori_id__kategori__id');

  $$KategoriTableProcessedTableManager get kategoriId {
    final $_column = $_itemColumn<String>('kategori_id')!;

    final manager = $$KategoriTableTableManager(
      $_db,
      $_db.kategori,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kategoriIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SubtesTable, List<SubtesData>> _subtesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.subtes,
    aliasName: 'tes__id__subtes__tes_id',
  );

  $$SubtesTableProcessedTableManager get subtesRefs {
    final manager = $$SubtesTableTableManager(
      $_db,
      $_db.subtes,
    ).filter((f) => f.tesId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_subtesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TesTableFilterComposer extends Composer<_$AppDatabase, $TesTable> {
  $$TesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get urutan => $composableBuilder(
    column: $table.urutan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnFilters(column),
  );

  $$KategoriTableFilterComposer get kategoriId {
    final $$KategoriTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kategoriId,
      referencedTable: $db.kategori,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KategoriTableFilterComposer(
            $db: $db,
            $table: $db.kategori,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> subtesRefs(
    Expression<bool> Function($$SubtesTableFilterComposer f) f,
  ) {
    final $$SubtesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subtes,
      getReferencedColumn: (t) => t.tesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtesTableFilterComposer(
            $db: $db,
            $table: $db.subtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TesTableOrderingComposer extends Composer<_$AppDatabase, $TesTable> {
  $$TesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get urutan => $composableBuilder(
    column: $table.urutan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnOrderings(column),
  );

  $$KategoriTableOrderingComposer get kategoriId {
    final $$KategoriTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kategoriId,
      referencedTable: $db.kategori,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KategoriTableOrderingComposer(
            $db: $db,
            $table: $db.kategori,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TesTableAnnotationComposer extends Composer<_$AppDatabase, $TesTable> {
  $$TesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<int> get urutan =>
      $composableBuilder(column: $table.urutan, builder: (column) => column);

  GeneratedColumn<String> get packId =>
      $composableBuilder(column: $table.packId, builder: (column) => column);

  $$KategoriTableAnnotationComposer get kategoriId {
    final $$KategoriTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kategoriId,
      referencedTable: $db.kategori,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KategoriTableAnnotationComposer(
            $db: $db,
            $table: $db.kategori,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> subtesRefs<T extends Object>(
    Expression<T> Function($$SubtesTableAnnotationComposer a) f,
  ) {
    final $$SubtesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subtes,
      getReferencedColumn: (t) => t.tesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtesTableAnnotationComposer(
            $db: $db,
            $table: $db.subtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TesTable,
          TesData,
          $$TesTableFilterComposer,
          $$TesTableOrderingComposer,
          $$TesTableAnnotationComposer,
          $$TesTableCreateCompanionBuilder,
          $$TesTableUpdateCompanionBuilder,
          (TesData, $$TesTableReferences),
          TesData,
          PrefetchHooks Function({bool kategoriId, bool subtesRefs})
        > {
  $$TesTableTableManager(_$AppDatabase db, $TesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kategoriId = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<int> urutan = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TesCompanion(
                id: id,
                kategoriId: kategoriId,
                nama: nama,
                urutan: urutan,
                packId: packId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kategoriId,
                required String nama,
                required int urutan,
                required String packId,
                Value<int> rowid = const Value.absent(),
              }) => TesCompanion.insert(
                id: id,
                kategoriId: kategoriId,
                nama: nama,
                urutan: urutan,
                packId: packId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (e.readTable(table), $$TesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({kategoriId = false, subtesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (subtesRefs) db.subtes],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (kategoriId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.kategoriId,
                                referencedTable: $$TesTableReferences
                                    ._kategoriIdTable(db),
                                referencedColumn: $$TesTableReferences
                                    ._kategoriIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (subtesRefs)
                    await $_getPrefetchedData<TesData, $TesTable, SubtesData>(
                      currentTable: table,
                      referencedTable: $$TesTableReferences._subtesRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$TesTableReferences(db, table, p0).subtesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tesId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TesTable,
      TesData,
      $$TesTableFilterComposer,
      $$TesTableOrderingComposer,
      $$TesTableAnnotationComposer,
      $$TesTableCreateCompanionBuilder,
      $$TesTableUpdateCompanionBuilder,
      (TesData, $$TesTableReferences),
      TesData,
      PrefetchHooks Function({bool kategoriId, bool subtesRefs})
    >;
typedef $$SubtesTableCreateCompanionBuilder =
    SubtesCompanion Function({
      required String id,
      required String tesId,
      required String nama,
      required int durasiMenit,
      required int urutan,
      Value<int> rowid,
    });
typedef $$SubtesTableUpdateCompanionBuilder =
    SubtesCompanion Function({
      Value<String> id,
      Value<String> tesId,
      Value<String> nama,
      Value<int> durasiMenit,
      Value<int> urutan,
      Value<int> rowid,
    });

final class $$SubtesTableReferences
    extends BaseReferences<_$AppDatabase, $SubtesTable, SubtesData> {
  $$SubtesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TesTable _tesIdTable(_$AppDatabase db) =>
      db.tes.createAlias('subtes__tes_id__tes__id');

  $$TesTableProcessedTableManager get tesId {
    final $_column = $_itemColumn<String>('tes_id')!;

    final manager = $$TesTableTableManager(
      $_db,
      $_db.tes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$StimulusTable, List<StimulusData>>
  _stimulusRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stimulus,
    aliasName: 'subtes__id__stimulus__subtes_id',
  );

  $$StimulusTableProcessedTableManager get stimulusRefs {
    final manager = $$StimulusTableTableManager(
      $_db,
      $_db.stimulus,
    ).filter((f) => f.subtesId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_stimulusRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SoalTable, List<SoalData>> _soalRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.soal,
    aliasName: 'subtes__id__soal__subtes_id',
  );

  $$SoalTableProcessedTableManager get soalRefs {
    final manager = $$SoalTableTableManager(
      $_db,
      $_db.soal,
    ).filter((f) => f.subtesId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_soalRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AttemptSubtesTable, List<AttemptSubtesData>>
  _attemptSubtesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.attemptSubtes,
    aliasName: 'subtes__id__attempt_subtes__subtes_id',
  );

  $$AttemptSubtesTableProcessedTableManager get attemptSubtesRefs {
    final manager = $$AttemptSubtesTableTableManager(
      $_db,
      $_db.attemptSubtes,
    ).filter((f) => f.subtesId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_attemptSubtesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$JawabanTable, List<JawabanData>>
  _jawabanRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.jawaban,
    aliasName: 'subtes__id__jawaban__subtes_id',
  );

  $$JawabanTableProcessedTableManager get jawabanRefs {
    final manager = $$JawabanTableTableManager(
      $_db,
      $_db.jawaban,
    ).filter((f) => f.subtesId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_jawabanRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RaguTable, List<RaguData>> _raguRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ragu,
    aliasName: 'subtes__id__ragu__subtes_id',
  );

  $$RaguTableProcessedTableManager get raguRefs {
    final manager = $$RaguTableTableManager(
      $_db,
      $_db.ragu,
    ).filter((f) => f.subtesId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_raguRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubtesTableFilterComposer
    extends Composer<_$AppDatabase, $SubtesTable> {
  $$SubtesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durasiMenit => $composableBuilder(
    column: $table.durasiMenit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get urutan => $composableBuilder(
    column: $table.urutan,
    builder: (column) => ColumnFilters(column),
  );

  $$TesTableFilterComposer get tesId {
    final $$TesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tesId,
      referencedTable: $db.tes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TesTableFilterComposer(
            $db: $db,
            $table: $db.tes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> stimulusRefs(
    Expression<bool> Function($$StimulusTableFilterComposer f) f,
  ) {
    final $$StimulusTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stimulus,
      getReferencedColumn: (t) => t.subtesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StimulusTableFilterComposer(
            $db: $db,
            $table: $db.stimulus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> soalRefs(
    Expression<bool> Function($$SoalTableFilterComposer f) f,
  ) {
    final $$SoalTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.soal,
      getReferencedColumn: (t) => t.subtesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SoalTableFilterComposer(
            $db: $db,
            $table: $db.soal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> attemptSubtesRefs(
    Expression<bool> Function($$AttemptSubtesTableFilterComposer f) f,
  ) {
    final $$AttemptSubtesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attemptSubtes,
      getReferencedColumn: (t) => t.subtesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttemptSubtesTableFilterComposer(
            $db: $db,
            $table: $db.attemptSubtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> jawabanRefs(
    Expression<bool> Function($$JawabanTableFilterComposer f) f,
  ) {
    final $$JawabanTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.jawaban,
      getReferencedColumn: (t) => t.subtesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JawabanTableFilterComposer(
            $db: $db,
            $table: $db.jawaban,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> raguRefs(
    Expression<bool> Function($$RaguTableFilterComposer f) f,
  ) {
    final $$RaguTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ragu,
      getReferencedColumn: (t) => t.subtesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RaguTableFilterComposer(
            $db: $db,
            $table: $db.ragu,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubtesTableOrderingComposer
    extends Composer<_$AppDatabase, $SubtesTable> {
  $$SubtesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durasiMenit => $composableBuilder(
    column: $table.durasiMenit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get urutan => $composableBuilder(
    column: $table.urutan,
    builder: (column) => ColumnOrderings(column),
  );

  $$TesTableOrderingComposer get tesId {
    final $$TesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tesId,
      referencedTable: $db.tes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TesTableOrderingComposer(
            $db: $db,
            $table: $db.tes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubtesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubtesTable> {
  $$SubtesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<int> get durasiMenit => $composableBuilder(
    column: $table.durasiMenit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get urutan =>
      $composableBuilder(column: $table.urutan, builder: (column) => column);

  $$TesTableAnnotationComposer get tesId {
    final $$TesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tesId,
      referencedTable: $db.tes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TesTableAnnotationComposer(
            $db: $db,
            $table: $db.tes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> stimulusRefs<T extends Object>(
    Expression<T> Function($$StimulusTableAnnotationComposer a) f,
  ) {
    final $$StimulusTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stimulus,
      getReferencedColumn: (t) => t.subtesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StimulusTableAnnotationComposer(
            $db: $db,
            $table: $db.stimulus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> soalRefs<T extends Object>(
    Expression<T> Function($$SoalTableAnnotationComposer a) f,
  ) {
    final $$SoalTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.soal,
      getReferencedColumn: (t) => t.subtesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SoalTableAnnotationComposer(
            $db: $db,
            $table: $db.soal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> attemptSubtesRefs<T extends Object>(
    Expression<T> Function($$AttemptSubtesTableAnnotationComposer a) f,
  ) {
    final $$AttemptSubtesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attemptSubtes,
      getReferencedColumn: (t) => t.subtesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttemptSubtesTableAnnotationComposer(
            $db: $db,
            $table: $db.attemptSubtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> jawabanRefs<T extends Object>(
    Expression<T> Function($$JawabanTableAnnotationComposer a) f,
  ) {
    final $$JawabanTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.jawaban,
      getReferencedColumn: (t) => t.subtesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JawabanTableAnnotationComposer(
            $db: $db,
            $table: $db.jawaban,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> raguRefs<T extends Object>(
    Expression<T> Function($$RaguTableAnnotationComposer a) f,
  ) {
    final $$RaguTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ragu,
      getReferencedColumn: (t) => t.subtesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RaguTableAnnotationComposer(
            $db: $db,
            $table: $db.ragu,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubtesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubtesTable,
          SubtesData,
          $$SubtesTableFilterComposer,
          $$SubtesTableOrderingComposer,
          $$SubtesTableAnnotationComposer,
          $$SubtesTableCreateCompanionBuilder,
          $$SubtesTableUpdateCompanionBuilder,
          (SubtesData, $$SubtesTableReferences),
          SubtesData,
          PrefetchHooks Function({
            bool tesId,
            bool stimulusRefs,
            bool soalRefs,
            bool attemptSubtesRefs,
            bool jawabanRefs,
            bool raguRefs,
          })
        > {
  $$SubtesTableTableManager(_$AppDatabase db, $SubtesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubtesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubtesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubtesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tesId = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<int> durasiMenit = const Value.absent(),
                Value<int> urutan = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubtesCompanion(
                id: id,
                tesId: tesId,
                nama: nama,
                durasiMenit: durasiMenit,
                urutan: urutan,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tesId,
                required String nama,
                required int durasiMenit,
                required int urutan,
                Value<int> rowid = const Value.absent(),
              }) => SubtesCompanion.insert(
                id: id,
                tesId: tesId,
                nama: nama,
                durasiMenit: durasiMenit,
                urutan: urutan,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SubtesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                tesId = false,
                stimulusRefs = false,
                soalRefs = false,
                attemptSubtesRefs = false,
                jawabanRefs = false,
                raguRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (stimulusRefs) db.stimulus,
                    if (soalRefs) db.soal,
                    if (attemptSubtesRefs) db.attemptSubtes,
                    if (jawabanRefs) db.jawaban,
                    if (raguRefs) db.ragu,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (tesId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tesId,
                                    referencedTable: $$SubtesTableReferences
                                        ._tesIdTable(db),
                                    referencedColumn: $$SubtesTableReferences
                                        ._tesIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (stimulusRefs)
                        await $_getPrefetchedData<
                          SubtesData,
                          $SubtesTable,
                          StimulusData
                        >(
                          currentTable: table,
                          referencedTable: $$SubtesTableReferences
                              ._stimulusRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubtesTableReferences(
                                db,
                                table,
                                p0,
                              ).stimulusRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subtesId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (soalRefs)
                        await $_getPrefetchedData<
                          SubtesData,
                          $SubtesTable,
                          SoalData
                        >(
                          currentTable: table,
                          referencedTable: $$SubtesTableReferences
                              ._soalRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubtesTableReferences(db, table, p0).soalRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subtesId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (attemptSubtesRefs)
                        await $_getPrefetchedData<
                          SubtesData,
                          $SubtesTable,
                          AttemptSubtesData
                        >(
                          currentTable: table,
                          referencedTable: $$SubtesTableReferences
                              ._attemptSubtesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubtesTableReferences(
                                db,
                                table,
                                p0,
                              ).attemptSubtesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subtesId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (jawabanRefs)
                        await $_getPrefetchedData<
                          SubtesData,
                          $SubtesTable,
                          JawabanData
                        >(
                          currentTable: table,
                          referencedTable: $$SubtesTableReferences
                              ._jawabanRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubtesTableReferences(
                                db,
                                table,
                                p0,
                              ).jawabanRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subtesId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (raguRefs)
                        await $_getPrefetchedData<
                          SubtesData,
                          $SubtesTable,
                          RaguData
                        >(
                          currentTable: table,
                          referencedTable: $$SubtesTableReferences
                              ._raguRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubtesTableReferences(db, table, p0).raguRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subtesId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SubtesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubtesTable,
      SubtesData,
      $$SubtesTableFilterComposer,
      $$SubtesTableOrderingComposer,
      $$SubtesTableAnnotationComposer,
      $$SubtesTableCreateCompanionBuilder,
      $$SubtesTableUpdateCompanionBuilder,
      (SubtesData, $$SubtesTableReferences),
      SubtesData,
      PrefetchHooks Function({
        bool tesId,
        bool stimulusRefs,
        bool soalRefs,
        bool attemptSubtesRefs,
        bool jawabanRefs,
        bool raguRefs,
      })
    >;
typedef $$StimulusTableCreateCompanionBuilder =
    StimulusCompanion Function({
      required String id,
      required String subtesId,
      Value<String?> judul,
      required String isi,
      required int urutan,
      Value<int> rowid,
    });
typedef $$StimulusTableUpdateCompanionBuilder =
    StimulusCompanion Function({
      Value<String> id,
      Value<String> subtesId,
      Value<String?> judul,
      Value<String> isi,
      Value<int> urutan,
      Value<int> rowid,
    });

final class $$StimulusTableReferences
    extends BaseReferences<_$AppDatabase, $StimulusTable, StimulusData> {
  $$StimulusTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubtesTable _subtesIdTable(_$AppDatabase db) =>
      db.subtes.createAlias('stimulus__subtes_id__subtes__id');

  $$SubtesTableProcessedTableManager get subtesId {
    final $_column = $_itemColumn<String>('subtes_id')!;

    final manager = $$SubtesTableTableManager(
      $_db,
      $_db.subtes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subtesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SoalTable, List<SoalData>> _soalRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.soal,
    aliasName: 'stimulus__id__soal__stimulus_id',
  );

  $$SoalTableProcessedTableManager get soalRefs {
    final manager = $$SoalTableTableManager(
      $_db,
      $_db.soal,
    ).filter((f) => f.stimulusId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_soalRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StimulusTableFilterComposer
    extends Composer<_$AppDatabase, $StimulusTable> {
  $$StimulusTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get judul => $composableBuilder(
    column: $table.judul,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isi => $composableBuilder(
    column: $table.isi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get urutan => $composableBuilder(
    column: $table.urutan,
    builder: (column) => ColumnFilters(column),
  );

  $$SubtesTableFilterComposer get subtesId {
    final $$SubtesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subtesId,
      referencedTable: $db.subtes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtesTableFilterComposer(
            $db: $db,
            $table: $db.subtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> soalRefs(
    Expression<bool> Function($$SoalTableFilterComposer f) f,
  ) {
    final $$SoalTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.soal,
      getReferencedColumn: (t) => t.stimulusId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SoalTableFilterComposer(
            $db: $db,
            $table: $db.soal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StimulusTableOrderingComposer
    extends Composer<_$AppDatabase, $StimulusTable> {
  $$StimulusTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get judul => $composableBuilder(
    column: $table.judul,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isi => $composableBuilder(
    column: $table.isi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get urutan => $composableBuilder(
    column: $table.urutan,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubtesTableOrderingComposer get subtesId {
    final $$SubtesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subtesId,
      referencedTable: $db.subtes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtesTableOrderingComposer(
            $db: $db,
            $table: $db.subtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StimulusTableAnnotationComposer
    extends Composer<_$AppDatabase, $StimulusTable> {
  $$StimulusTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get judul =>
      $composableBuilder(column: $table.judul, builder: (column) => column);

  GeneratedColumn<String> get isi =>
      $composableBuilder(column: $table.isi, builder: (column) => column);

  GeneratedColumn<int> get urutan =>
      $composableBuilder(column: $table.urutan, builder: (column) => column);

  $$SubtesTableAnnotationComposer get subtesId {
    final $$SubtesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subtesId,
      referencedTable: $db.subtes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtesTableAnnotationComposer(
            $db: $db,
            $table: $db.subtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> soalRefs<T extends Object>(
    Expression<T> Function($$SoalTableAnnotationComposer a) f,
  ) {
    final $$SoalTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.soal,
      getReferencedColumn: (t) => t.stimulusId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SoalTableAnnotationComposer(
            $db: $db,
            $table: $db.soal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StimulusTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StimulusTable,
          StimulusData,
          $$StimulusTableFilterComposer,
          $$StimulusTableOrderingComposer,
          $$StimulusTableAnnotationComposer,
          $$StimulusTableCreateCompanionBuilder,
          $$StimulusTableUpdateCompanionBuilder,
          (StimulusData, $$StimulusTableReferences),
          StimulusData,
          PrefetchHooks Function({bool subtesId, bool soalRefs})
        > {
  $$StimulusTableTableManager(_$AppDatabase db, $StimulusTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StimulusTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StimulusTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StimulusTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subtesId = const Value.absent(),
                Value<String?> judul = const Value.absent(),
                Value<String> isi = const Value.absent(),
                Value<int> urutan = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StimulusCompanion(
                id: id,
                subtesId: subtesId,
                judul: judul,
                isi: isi,
                urutan: urutan,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subtesId,
                Value<String?> judul = const Value.absent(),
                required String isi,
                required int urutan,
                Value<int> rowid = const Value.absent(),
              }) => StimulusCompanion.insert(
                id: id,
                subtesId: subtesId,
                judul: judul,
                isi: isi,
                urutan: urutan,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StimulusTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subtesId = false, soalRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (soalRefs) db.soal],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (subtesId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.subtesId,
                                referencedTable: $$StimulusTableReferences
                                    ._subtesIdTable(db),
                                referencedColumn: $$StimulusTableReferences
                                    ._subtesIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (soalRefs)
                    await $_getPrefetchedData<
                      StimulusData,
                      $StimulusTable,
                      SoalData
                    >(
                      currentTable: table,
                      referencedTable: $$StimulusTableReferences._soalRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$StimulusTableReferences(db, table, p0).soalRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.stimulusId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$StimulusTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StimulusTable,
      StimulusData,
      $$StimulusTableFilterComposer,
      $$StimulusTableOrderingComposer,
      $$StimulusTableAnnotationComposer,
      $$StimulusTableCreateCompanionBuilder,
      $$StimulusTableUpdateCompanionBuilder,
      (StimulusData, $$StimulusTableReferences),
      StimulusData,
      PrefetchHooks Function({bool subtesId, bool soalRefs})
    >;
typedef $$SoalTableCreateCompanionBuilder =
    SoalCompanion Function({
      required String id,
      required String subtesId,
      Value<String?> stimulusId,
      required int urutan,
      required String teks,
      required Map<String, String> opsi,
      required String jawabanBenar,
      Value<String?> pembahasan,
      Value<bool> aktif,
      required String packId,
      Value<int> rowid,
    });
typedef $$SoalTableUpdateCompanionBuilder =
    SoalCompanion Function({
      Value<String> id,
      Value<String> subtesId,
      Value<String?> stimulusId,
      Value<int> urutan,
      Value<String> teks,
      Value<Map<String, String>> opsi,
      Value<String> jawabanBenar,
      Value<String?> pembahasan,
      Value<bool> aktif,
      Value<String> packId,
      Value<int> rowid,
    });

final class $$SoalTableReferences
    extends BaseReferences<_$AppDatabase, $SoalTable, SoalData> {
  $$SoalTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubtesTable _subtesIdTable(_$AppDatabase db) =>
      db.subtes.createAlias('soal__subtes_id__subtes__id');

  $$SubtesTableProcessedTableManager get subtesId {
    final $_column = $_itemColumn<String>('subtes_id')!;

    final manager = $$SubtesTableTableManager(
      $_db,
      $_db.subtes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subtesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StimulusTable _stimulusIdTable(_$AppDatabase db) =>
      db.stimulus.createAlias('soal__stimulus_id__stimulus__id');

  $$StimulusTableProcessedTableManager? get stimulusId {
    final $_column = $_itemColumn<String>('stimulus_id');
    if ($_column == null) return null;
    final manager = $$StimulusTableTableManager(
      $_db,
      $_db.stimulus,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stimulusIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$JawabanTable, List<JawabanData>>
  _jawabanRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.jawaban,
    aliasName: 'soal__id__jawaban__soal_id',
  );

  $$JawabanTableProcessedTableManager get jawabanRefs {
    final manager = $$JawabanTableTableManager(
      $_db,
      $_db.jawaban,
    ).filter((f) => f.soalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_jawabanRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RaguTable, List<RaguData>> _raguRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ragu,
    aliasName: 'soal__id__ragu__soal_id',
  );

  $$RaguTableProcessedTableManager get raguRefs {
    final manager = $$RaguTableTableManager(
      $_db,
      $_db.ragu,
    ).filter((f) => f.soalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_raguRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SoalTableFilterComposer extends Composer<_$AppDatabase, $SoalTable> {
  $$SoalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get urutan => $composableBuilder(
    column: $table.urutan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teks => $composableBuilder(
    column: $table.teks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, String>,
    Map<String, String>,
    String
  >
  get opsi => $composableBuilder(
    column: $table.opsi,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get jawabanBenar => $composableBuilder(
    column: $table.jawabanBenar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pembahasan => $composableBuilder(
    column: $table.pembahasan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get aktif => $composableBuilder(
    column: $table.aktif,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnFilters(column),
  );

  $$SubtesTableFilterComposer get subtesId {
    final $$SubtesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subtesId,
      referencedTable: $db.subtes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtesTableFilterComposer(
            $db: $db,
            $table: $db.subtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StimulusTableFilterComposer get stimulusId {
    final $$StimulusTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stimulusId,
      referencedTable: $db.stimulus,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StimulusTableFilterComposer(
            $db: $db,
            $table: $db.stimulus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> jawabanRefs(
    Expression<bool> Function($$JawabanTableFilterComposer f) f,
  ) {
    final $$JawabanTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.jawaban,
      getReferencedColumn: (t) => t.soalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JawabanTableFilterComposer(
            $db: $db,
            $table: $db.jawaban,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> raguRefs(
    Expression<bool> Function($$RaguTableFilterComposer f) f,
  ) {
    final $$RaguTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ragu,
      getReferencedColumn: (t) => t.soalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RaguTableFilterComposer(
            $db: $db,
            $table: $db.ragu,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SoalTableOrderingComposer extends Composer<_$AppDatabase, $SoalTable> {
  $$SoalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get urutan => $composableBuilder(
    column: $table.urutan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teks => $composableBuilder(
    column: $table.teks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get opsi => $composableBuilder(
    column: $table.opsi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jawabanBenar => $composableBuilder(
    column: $table.jawabanBenar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pembahasan => $composableBuilder(
    column: $table.pembahasan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get aktif => $composableBuilder(
    column: $table.aktif,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubtesTableOrderingComposer get subtesId {
    final $$SubtesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subtesId,
      referencedTable: $db.subtes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtesTableOrderingComposer(
            $db: $db,
            $table: $db.subtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StimulusTableOrderingComposer get stimulusId {
    final $$StimulusTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stimulusId,
      referencedTable: $db.stimulus,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StimulusTableOrderingComposer(
            $db: $db,
            $table: $db.stimulus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SoalTableAnnotationComposer
    extends Composer<_$AppDatabase, $SoalTable> {
  $$SoalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get urutan =>
      $composableBuilder(column: $table.urutan, builder: (column) => column);

  GeneratedColumn<String> get teks =>
      $composableBuilder(column: $table.teks, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>, String> get opsi =>
      $composableBuilder(column: $table.opsi, builder: (column) => column);

  GeneratedColumn<String> get jawabanBenar => $composableBuilder(
    column: $table.jawabanBenar,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pembahasan => $composableBuilder(
    column: $table.pembahasan,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get aktif =>
      $composableBuilder(column: $table.aktif, builder: (column) => column);

  GeneratedColumn<String> get packId =>
      $composableBuilder(column: $table.packId, builder: (column) => column);

  $$SubtesTableAnnotationComposer get subtesId {
    final $$SubtesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subtesId,
      referencedTable: $db.subtes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtesTableAnnotationComposer(
            $db: $db,
            $table: $db.subtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StimulusTableAnnotationComposer get stimulusId {
    final $$StimulusTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stimulusId,
      referencedTable: $db.stimulus,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StimulusTableAnnotationComposer(
            $db: $db,
            $table: $db.stimulus,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> jawabanRefs<T extends Object>(
    Expression<T> Function($$JawabanTableAnnotationComposer a) f,
  ) {
    final $$JawabanTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.jawaban,
      getReferencedColumn: (t) => t.soalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JawabanTableAnnotationComposer(
            $db: $db,
            $table: $db.jawaban,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> raguRefs<T extends Object>(
    Expression<T> Function($$RaguTableAnnotationComposer a) f,
  ) {
    final $$RaguTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ragu,
      getReferencedColumn: (t) => t.soalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RaguTableAnnotationComposer(
            $db: $db,
            $table: $db.ragu,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SoalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SoalTable,
          SoalData,
          $$SoalTableFilterComposer,
          $$SoalTableOrderingComposer,
          $$SoalTableAnnotationComposer,
          $$SoalTableCreateCompanionBuilder,
          $$SoalTableUpdateCompanionBuilder,
          (SoalData, $$SoalTableReferences),
          SoalData,
          PrefetchHooks Function({
            bool subtesId,
            bool stimulusId,
            bool jawabanRefs,
            bool raguRefs,
          })
        > {
  $$SoalTableTableManager(_$AppDatabase db, $SoalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SoalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SoalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SoalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subtesId = const Value.absent(),
                Value<String?> stimulusId = const Value.absent(),
                Value<int> urutan = const Value.absent(),
                Value<String> teks = const Value.absent(),
                Value<Map<String, String>> opsi = const Value.absent(),
                Value<String> jawabanBenar = const Value.absent(),
                Value<String?> pembahasan = const Value.absent(),
                Value<bool> aktif = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SoalCompanion(
                id: id,
                subtesId: subtesId,
                stimulusId: stimulusId,
                urutan: urutan,
                teks: teks,
                opsi: opsi,
                jawabanBenar: jawabanBenar,
                pembahasan: pembahasan,
                aktif: aktif,
                packId: packId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subtesId,
                Value<String?> stimulusId = const Value.absent(),
                required int urutan,
                required String teks,
                required Map<String, String> opsi,
                required String jawabanBenar,
                Value<String?> pembahasan = const Value.absent(),
                Value<bool> aktif = const Value.absent(),
                required String packId,
                Value<int> rowid = const Value.absent(),
              }) => SoalCompanion.insert(
                id: id,
                subtesId: subtesId,
                stimulusId: stimulusId,
                urutan: urutan,
                teks: teks,
                opsi: opsi,
                jawabanBenar: jawabanBenar,
                pembahasan: pembahasan,
                aktif: aktif,
                packId: packId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SoalTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                subtesId = false,
                stimulusId = false,
                jawabanRefs = false,
                raguRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (jawabanRefs) db.jawaban,
                    if (raguRefs) db.ragu,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (subtesId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.subtesId,
                                    referencedTable: $$SoalTableReferences
                                        ._subtesIdTable(db),
                                    referencedColumn: $$SoalTableReferences
                                        ._subtesIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (stimulusId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.stimulusId,
                                    referencedTable: $$SoalTableReferences
                                        ._stimulusIdTable(db),
                                    referencedColumn: $$SoalTableReferences
                                        ._stimulusIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (jawabanRefs)
                        await $_getPrefetchedData<
                          SoalData,
                          $SoalTable,
                          JawabanData
                        >(
                          currentTable: table,
                          referencedTable: $$SoalTableReferences
                              ._jawabanRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SoalTableReferences(db, table, p0).jawabanRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.soalId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (raguRefs)
                        await $_getPrefetchedData<
                          SoalData,
                          $SoalTable,
                          RaguData
                        >(
                          currentTable: table,
                          referencedTable: $$SoalTableReferences._raguRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $$SoalTableReferences(db, table, p0).raguRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.soalId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SoalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SoalTable,
      SoalData,
      $$SoalTableFilterComposer,
      $$SoalTableOrderingComposer,
      $$SoalTableAnnotationComposer,
      $$SoalTableCreateCompanionBuilder,
      $$SoalTableUpdateCompanionBuilder,
      (SoalData, $$SoalTableReferences),
      SoalData,
      PrefetchHooks Function({
        bool subtesId,
        bool stimulusId,
        bool jawabanRefs,
        bool raguRefs,
      })
    >;
typedef $$PaketTerpasangTableCreateCompanionBuilder =
    PaketTerpasangCompanion Function({
      required String packId,
      required int packVersion,
      required String nama,
      required DateTime tanggalPasang,
      Value<int> rowid,
    });
typedef $$PaketTerpasangTableUpdateCompanionBuilder =
    PaketTerpasangCompanion Function({
      Value<String> packId,
      Value<int> packVersion,
      Value<String> nama,
      Value<DateTime> tanggalPasang,
      Value<int> rowid,
    });

class $$PaketTerpasangTableFilterComposer
    extends Composer<_$AppDatabase, $PaketTerpasangTable> {
  $$PaketTerpasangTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get packVersion => $composableBuilder(
    column: $table.packVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggalPasang => $composableBuilder(
    column: $table.tanggalPasang,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaketTerpasangTableOrderingComposer
    extends Composer<_$AppDatabase, $PaketTerpasangTable> {
  $$PaketTerpasangTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get packVersion => $composableBuilder(
    column: $table.packVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggalPasang => $composableBuilder(
    column: $table.tanggalPasang,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaketTerpasangTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaketTerpasangTable> {
  $$PaketTerpasangTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get packId =>
      $composableBuilder(column: $table.packId, builder: (column) => column);

  GeneratedColumn<int> get packVersion => $composableBuilder(
    column: $table.packVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggalPasang => $composableBuilder(
    column: $table.tanggalPasang,
    builder: (column) => column,
  );
}

class $$PaketTerpasangTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaketTerpasangTable,
          PaketTerpasangData,
          $$PaketTerpasangTableFilterComposer,
          $$PaketTerpasangTableOrderingComposer,
          $$PaketTerpasangTableAnnotationComposer,
          $$PaketTerpasangTableCreateCompanionBuilder,
          $$PaketTerpasangTableUpdateCompanionBuilder,
          (
            PaketTerpasangData,
            BaseReferences<
              _$AppDatabase,
              $PaketTerpasangTable,
              PaketTerpasangData
            >,
          ),
          PaketTerpasangData,
          PrefetchHooks Function()
        > {
  $$PaketTerpasangTableTableManager(
    _$AppDatabase db,
    $PaketTerpasangTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaketTerpasangTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaketTerpasangTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaketTerpasangTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packId = const Value.absent(),
                Value<int> packVersion = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<DateTime> tanggalPasang = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaketTerpasangCompanion(
                packId: packId,
                packVersion: packVersion,
                nama: nama,
                tanggalPasang: tanggalPasang,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packId,
                required int packVersion,
                required String nama,
                required DateTime tanggalPasang,
                Value<int> rowid = const Value.absent(),
              }) => PaketTerpasangCompanion.insert(
                packId: packId,
                packVersion: packVersion,
                nama: nama,
                tanggalPasang: tanggalPasang,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaketTerpasangTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaketTerpasangTable,
      PaketTerpasangData,
      $$PaketTerpasangTableFilterComposer,
      $$PaketTerpasangTableOrderingComposer,
      $$PaketTerpasangTableAnnotationComposer,
      $$PaketTerpasangTableCreateCompanionBuilder,
      $$PaketTerpasangTableUpdateCompanionBuilder,
      (
        PaketTerpasangData,
        BaseReferences<_$AppDatabase, $PaketTerpasangTable, PaketTerpasangData>,
      ),
      PaketTerpasangData,
      PrefetchHooks Function()
    >;
typedef $$AttemptSubtesTableCreateCompanionBuilder =
    AttemptSubtesCompanion Function({
      required String subtesId,
      required SubtesStatus status,
      Value<DateTime?> endTime,
      Value<DateTime?> mulaiAt,
      Value<DateTime?> selesaiAt,
      Value<int?> benar,
      Value<int?> salah,
      Value<int?> kosong,
      Value<int?> totalSoal,
      Value<int> rowid,
    });
typedef $$AttemptSubtesTableUpdateCompanionBuilder =
    AttemptSubtesCompanion Function({
      Value<String> subtesId,
      Value<SubtesStatus> status,
      Value<DateTime?> endTime,
      Value<DateTime?> mulaiAt,
      Value<DateTime?> selesaiAt,
      Value<int?> benar,
      Value<int?> salah,
      Value<int?> kosong,
      Value<int?> totalSoal,
      Value<int> rowid,
    });

final class $$AttemptSubtesTableReferences
    extends
        BaseReferences<_$AppDatabase, $AttemptSubtesTable, AttemptSubtesData> {
  $$AttemptSubtesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SubtesTable _subtesIdTable(_$AppDatabase db) =>
      db.subtes.createAlias('attempt_subtes__subtes_id__subtes__id');

  $$SubtesTableProcessedTableManager get subtesId {
    final $_column = $_itemColumn<String>('subtes_id')!;

    final manager = $$SubtesTableTableManager(
      $_db,
      $_db.subtes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subtesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AttemptSubtesTableFilterComposer
    extends Composer<_$AppDatabase, $AttemptSubtesTable> {
  $$AttemptSubtesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<SubtesStatus, SubtesStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get mulaiAt => $composableBuilder(
    column: $table.mulaiAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get selesaiAt => $composableBuilder(
    column: $table.selesaiAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get benar => $composableBuilder(
    column: $table.benar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get salah => $composableBuilder(
    column: $table.salah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kosong => $composableBuilder(
    column: $table.kosong,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalSoal => $composableBuilder(
    column: $table.totalSoal,
    builder: (column) => ColumnFilters(column),
  );

  $$SubtesTableFilterComposer get subtesId {
    final $$SubtesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subtesId,
      referencedTable: $db.subtes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtesTableFilterComposer(
            $db: $db,
            $table: $db.subtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttemptSubtesTableOrderingComposer
    extends Composer<_$AppDatabase, $AttemptSubtesTable> {
  $$AttemptSubtesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get mulaiAt => $composableBuilder(
    column: $table.mulaiAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get selesaiAt => $composableBuilder(
    column: $table.selesaiAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get benar => $composableBuilder(
    column: $table.benar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get salah => $composableBuilder(
    column: $table.salah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kosong => $composableBuilder(
    column: $table.kosong,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalSoal => $composableBuilder(
    column: $table.totalSoal,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubtesTableOrderingComposer get subtesId {
    final $$SubtesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subtesId,
      referencedTable: $db.subtes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtesTableOrderingComposer(
            $db: $db,
            $table: $db.subtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttemptSubtesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttemptSubtesTable> {
  $$AttemptSubtesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<SubtesStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<DateTime> get mulaiAt =>
      $composableBuilder(column: $table.mulaiAt, builder: (column) => column);

  GeneratedColumn<DateTime> get selesaiAt =>
      $composableBuilder(column: $table.selesaiAt, builder: (column) => column);

  GeneratedColumn<int> get benar =>
      $composableBuilder(column: $table.benar, builder: (column) => column);

  GeneratedColumn<int> get salah =>
      $composableBuilder(column: $table.salah, builder: (column) => column);

  GeneratedColumn<int> get kosong =>
      $composableBuilder(column: $table.kosong, builder: (column) => column);

  GeneratedColumn<int> get totalSoal =>
      $composableBuilder(column: $table.totalSoal, builder: (column) => column);

  $$SubtesTableAnnotationComposer get subtesId {
    final $$SubtesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subtesId,
      referencedTable: $db.subtes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtesTableAnnotationComposer(
            $db: $db,
            $table: $db.subtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttemptSubtesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttemptSubtesTable,
          AttemptSubtesData,
          $$AttemptSubtesTableFilterComposer,
          $$AttemptSubtesTableOrderingComposer,
          $$AttemptSubtesTableAnnotationComposer,
          $$AttemptSubtesTableCreateCompanionBuilder,
          $$AttemptSubtesTableUpdateCompanionBuilder,
          (AttemptSubtesData, $$AttemptSubtesTableReferences),
          AttemptSubtesData,
          PrefetchHooks Function({bool subtesId})
        > {
  $$AttemptSubtesTableTableManager(_$AppDatabase db, $AttemptSubtesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttemptSubtesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttemptSubtesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttemptSubtesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> subtesId = const Value.absent(),
                Value<SubtesStatus> status = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<DateTime?> mulaiAt = const Value.absent(),
                Value<DateTime?> selesaiAt = const Value.absent(),
                Value<int?> benar = const Value.absent(),
                Value<int?> salah = const Value.absent(),
                Value<int?> kosong = const Value.absent(),
                Value<int?> totalSoal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttemptSubtesCompanion(
                subtesId: subtesId,
                status: status,
                endTime: endTime,
                mulaiAt: mulaiAt,
                selesaiAt: selesaiAt,
                benar: benar,
                salah: salah,
                kosong: kosong,
                totalSoal: totalSoal,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String subtesId,
                required SubtesStatus status,
                Value<DateTime?> endTime = const Value.absent(),
                Value<DateTime?> mulaiAt = const Value.absent(),
                Value<DateTime?> selesaiAt = const Value.absent(),
                Value<int?> benar = const Value.absent(),
                Value<int?> salah = const Value.absent(),
                Value<int?> kosong = const Value.absent(),
                Value<int?> totalSoal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttemptSubtesCompanion.insert(
                subtesId: subtesId,
                status: status,
                endTime: endTime,
                mulaiAt: mulaiAt,
                selesaiAt: selesaiAt,
                benar: benar,
                salah: salah,
                kosong: kosong,
                totalSoal: totalSoal,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AttemptSubtesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subtesId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (subtesId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.subtesId,
                                referencedTable: $$AttemptSubtesTableReferences
                                    ._subtesIdTable(db),
                                referencedColumn: $$AttemptSubtesTableReferences
                                    ._subtesIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AttemptSubtesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttemptSubtesTable,
      AttemptSubtesData,
      $$AttemptSubtesTableFilterComposer,
      $$AttemptSubtesTableOrderingComposer,
      $$AttemptSubtesTableAnnotationComposer,
      $$AttemptSubtesTableCreateCompanionBuilder,
      $$AttemptSubtesTableUpdateCompanionBuilder,
      (AttemptSubtesData, $$AttemptSubtesTableReferences),
      AttemptSubtesData,
      PrefetchHooks Function({bool subtesId})
    >;
typedef $$JawabanTableCreateCompanionBuilder =
    JawabanCompanion Function({
      required String subtesId,
      required String soalId,
      required String opsi,
      Value<int> rowid,
    });
typedef $$JawabanTableUpdateCompanionBuilder =
    JawabanCompanion Function({
      Value<String> subtesId,
      Value<String> soalId,
      Value<String> opsi,
      Value<int> rowid,
    });

final class $$JawabanTableReferences
    extends BaseReferences<_$AppDatabase, $JawabanTable, JawabanData> {
  $$JawabanTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubtesTable _subtesIdTable(_$AppDatabase db) =>
      db.subtes.createAlias('jawaban__subtes_id__subtes__id');

  $$SubtesTableProcessedTableManager get subtesId {
    final $_column = $_itemColumn<String>('subtes_id')!;

    final manager = $$SubtesTableTableManager(
      $_db,
      $_db.subtes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subtesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SoalTable _soalIdTable(_$AppDatabase db) =>
      db.soal.createAlias('jawaban__soal_id__soal__id');

  $$SoalTableProcessedTableManager get soalId {
    final $_column = $_itemColumn<String>('soal_id')!;

    final manager = $$SoalTableTableManager(
      $_db,
      $_db.soal,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_soalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$JawabanTableFilterComposer
    extends Composer<_$AppDatabase, $JawabanTable> {
  $$JawabanTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get opsi => $composableBuilder(
    column: $table.opsi,
    builder: (column) => ColumnFilters(column),
  );

  $$SubtesTableFilterComposer get subtesId {
    final $$SubtesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subtesId,
      referencedTable: $db.subtes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtesTableFilterComposer(
            $db: $db,
            $table: $db.subtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SoalTableFilterComposer get soalId {
    final $$SoalTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.soalId,
      referencedTable: $db.soal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SoalTableFilterComposer(
            $db: $db,
            $table: $db.soal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JawabanTableOrderingComposer
    extends Composer<_$AppDatabase, $JawabanTable> {
  $$JawabanTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get opsi => $composableBuilder(
    column: $table.opsi,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubtesTableOrderingComposer get subtesId {
    final $$SubtesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subtesId,
      referencedTable: $db.subtes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtesTableOrderingComposer(
            $db: $db,
            $table: $db.subtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SoalTableOrderingComposer get soalId {
    final $$SoalTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.soalId,
      referencedTable: $db.soal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SoalTableOrderingComposer(
            $db: $db,
            $table: $db.soal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JawabanTableAnnotationComposer
    extends Composer<_$AppDatabase, $JawabanTable> {
  $$JawabanTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get opsi =>
      $composableBuilder(column: $table.opsi, builder: (column) => column);

  $$SubtesTableAnnotationComposer get subtesId {
    final $$SubtesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subtesId,
      referencedTable: $db.subtes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtesTableAnnotationComposer(
            $db: $db,
            $table: $db.subtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SoalTableAnnotationComposer get soalId {
    final $$SoalTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.soalId,
      referencedTable: $db.soal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SoalTableAnnotationComposer(
            $db: $db,
            $table: $db.soal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JawabanTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JawabanTable,
          JawabanData,
          $$JawabanTableFilterComposer,
          $$JawabanTableOrderingComposer,
          $$JawabanTableAnnotationComposer,
          $$JawabanTableCreateCompanionBuilder,
          $$JawabanTableUpdateCompanionBuilder,
          (JawabanData, $$JawabanTableReferences),
          JawabanData,
          PrefetchHooks Function({bool subtesId, bool soalId})
        > {
  $$JawabanTableTableManager(_$AppDatabase db, $JawabanTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JawabanTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JawabanTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JawabanTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> subtesId = const Value.absent(),
                Value<String> soalId = const Value.absent(),
                Value<String> opsi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JawabanCompanion(
                subtesId: subtesId,
                soalId: soalId,
                opsi: opsi,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String subtesId,
                required String soalId,
                required String opsi,
                Value<int> rowid = const Value.absent(),
              }) => JawabanCompanion.insert(
                subtesId: subtesId,
                soalId: soalId,
                opsi: opsi,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$JawabanTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subtesId = false, soalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (subtesId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.subtesId,
                                referencedTable: $$JawabanTableReferences
                                    ._subtesIdTable(db),
                                referencedColumn: $$JawabanTableReferences
                                    ._subtesIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (soalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.soalId,
                                referencedTable: $$JawabanTableReferences
                                    ._soalIdTable(db),
                                referencedColumn: $$JawabanTableReferences
                                    ._soalIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$JawabanTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JawabanTable,
      JawabanData,
      $$JawabanTableFilterComposer,
      $$JawabanTableOrderingComposer,
      $$JawabanTableAnnotationComposer,
      $$JawabanTableCreateCompanionBuilder,
      $$JawabanTableUpdateCompanionBuilder,
      (JawabanData, $$JawabanTableReferences),
      JawabanData,
      PrefetchHooks Function({bool subtesId, bool soalId})
    >;
typedef $$RaguTableCreateCompanionBuilder =
    RaguCompanion Function({
      required String subtesId,
      required String soalId,
      Value<int> rowid,
    });
typedef $$RaguTableUpdateCompanionBuilder =
    RaguCompanion Function({
      Value<String> subtesId,
      Value<String> soalId,
      Value<int> rowid,
    });

final class $$RaguTableReferences
    extends BaseReferences<_$AppDatabase, $RaguTable, RaguData> {
  $$RaguTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubtesTable _subtesIdTable(_$AppDatabase db) =>
      db.subtes.createAlias('ragu__subtes_id__subtes__id');

  $$SubtesTableProcessedTableManager get subtesId {
    final $_column = $_itemColumn<String>('subtes_id')!;

    final manager = $$SubtesTableTableManager(
      $_db,
      $_db.subtes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subtesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SoalTable _soalIdTable(_$AppDatabase db) =>
      db.soal.createAlias('ragu__soal_id__soal__id');

  $$SoalTableProcessedTableManager get soalId {
    final $_column = $_itemColumn<String>('soal_id')!;

    final manager = $$SoalTableTableManager(
      $_db,
      $_db.soal,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_soalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RaguTableFilterComposer extends Composer<_$AppDatabase, $RaguTable> {
  $$RaguTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SubtesTableFilterComposer get subtesId {
    final $$SubtesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subtesId,
      referencedTable: $db.subtes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtesTableFilterComposer(
            $db: $db,
            $table: $db.subtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SoalTableFilterComposer get soalId {
    final $$SoalTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.soalId,
      referencedTable: $db.soal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SoalTableFilterComposer(
            $db: $db,
            $table: $db.soal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RaguTableOrderingComposer extends Composer<_$AppDatabase, $RaguTable> {
  $$RaguTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SubtesTableOrderingComposer get subtesId {
    final $$SubtesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subtesId,
      referencedTable: $db.subtes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtesTableOrderingComposer(
            $db: $db,
            $table: $db.subtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SoalTableOrderingComposer get soalId {
    final $$SoalTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.soalId,
      referencedTable: $db.soal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SoalTableOrderingComposer(
            $db: $db,
            $table: $db.soal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RaguTableAnnotationComposer
    extends Composer<_$AppDatabase, $RaguTable> {
  $$RaguTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SubtesTableAnnotationComposer get subtesId {
    final $$SubtesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subtesId,
      referencedTable: $db.subtes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtesTableAnnotationComposer(
            $db: $db,
            $table: $db.subtes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SoalTableAnnotationComposer get soalId {
    final $$SoalTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.soalId,
      referencedTable: $db.soal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SoalTableAnnotationComposer(
            $db: $db,
            $table: $db.soal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RaguTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RaguTable,
          RaguData,
          $$RaguTableFilterComposer,
          $$RaguTableOrderingComposer,
          $$RaguTableAnnotationComposer,
          $$RaguTableCreateCompanionBuilder,
          $$RaguTableUpdateCompanionBuilder,
          (RaguData, $$RaguTableReferences),
          RaguData,
          PrefetchHooks Function({bool subtesId, bool soalId})
        > {
  $$RaguTableTableManager(_$AppDatabase db, $RaguTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RaguTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RaguTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RaguTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> subtesId = const Value.absent(),
                Value<String> soalId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RaguCompanion(
                subtesId: subtesId,
                soalId: soalId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String subtesId,
                required String soalId,
                Value<int> rowid = const Value.absent(),
              }) => RaguCompanion.insert(
                subtesId: subtesId,
                soalId: soalId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$RaguTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({subtesId = false, soalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (subtesId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.subtesId,
                                referencedTable: $$RaguTableReferences
                                    ._subtesIdTable(db),
                                referencedColumn: $$RaguTableReferences
                                    ._subtesIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (soalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.soalId,
                                referencedTable: $$RaguTableReferences
                                    ._soalIdTable(db),
                                referencedColumn: $$RaguTableReferences
                                    ._soalIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RaguTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RaguTable,
      RaguData,
      $$RaguTableFilterComposer,
      $$RaguTableOrderingComposer,
      $$RaguTableAnnotationComposer,
      $$RaguTableCreateCompanionBuilder,
      $$RaguTableUpdateCompanionBuilder,
      (RaguData, $$RaguTableReferences),
      RaguData,
      PrefetchHooks Function({bool subtesId, bool soalId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$KategoriTableTableManager get kategori =>
      $$KategoriTableTableManager(_db, _db.kategori);
  $$TesTableTableManager get tes => $$TesTableTableManager(_db, _db.tes);
  $$SubtesTableTableManager get subtes =>
      $$SubtesTableTableManager(_db, _db.subtes);
  $$StimulusTableTableManager get stimulus =>
      $$StimulusTableTableManager(_db, _db.stimulus);
  $$SoalTableTableManager get soal => $$SoalTableTableManager(_db, _db.soal);
  $$PaketTerpasangTableTableManager get paketTerpasang =>
      $$PaketTerpasangTableTableManager(_db, _db.paketTerpasang);
  $$AttemptSubtesTableTableManager get attemptSubtes =>
      $$AttemptSubtesTableTableManager(_db, _db.attemptSubtes);
  $$JawabanTableTableManager get jawaban =>
      $$JawabanTableTableManager(_db, _db.jawaban);
  $$RaguTableTableManager get ragu => $$RaguTableTableManager(_db, _db.ragu);
}
