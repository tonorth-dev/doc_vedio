// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VideoRecord _$VideoRecordFromJson(Map<String, dynamic> json) {
  return _VideoRecord.fromJson(json);
}

/// @nodoc
mixin _$VideoRecord {
  String get filePath => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  DateTime get recordedAt => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get patientName => throw _privateConstructorUsedError;
  String? get patientId => throw _privateConstructorUsedError;

  /// Serializes this VideoRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoRecordCopyWith<VideoRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoRecordCopyWith<$Res> {
  factory $VideoRecordCopyWith(
          VideoRecord value, $Res Function(VideoRecord) then) =
      _$VideoRecordCopyWithImpl<$Res, VideoRecord>;
  @useResult
  $Res call(
      {String filePath,
      String fileName,
      DateTime recordedAt,
      String? description,
      String? patientName,
      String? patientId});
}

/// @nodoc
class _$VideoRecordCopyWithImpl<$Res, $Val extends VideoRecord>
    implements $VideoRecordCopyWith<$Res> {
  _$VideoRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filePath = null,
    Object? fileName = null,
    Object? recordedAt = null,
    Object? description = freezed,
    Object? patientName = freezed,
    Object? patientId = freezed,
  }) {
    return _then(_value.copyWith(
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      recordedAt: null == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      patientName: freezed == patientName
          ? _value.patientName
          : patientName // ignore: cast_nullable_to_non_nullable
              as String?,
      patientId: freezed == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoRecordImplCopyWith<$Res>
    implements $VideoRecordCopyWith<$Res> {
  factory _$$VideoRecordImplCopyWith(
          _$VideoRecordImpl value, $Res Function(_$VideoRecordImpl) then) =
      __$$VideoRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String filePath,
      String fileName,
      DateTime recordedAt,
      String? description,
      String? patientName,
      String? patientId});
}

/// @nodoc
class __$$VideoRecordImplCopyWithImpl<$Res>
    extends _$VideoRecordCopyWithImpl<$Res, _$VideoRecordImpl>
    implements _$$VideoRecordImplCopyWith<$Res> {
  __$$VideoRecordImplCopyWithImpl(
      _$VideoRecordImpl _value, $Res Function(_$VideoRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filePath = null,
    Object? fileName = null,
    Object? recordedAt = null,
    Object? description = freezed,
    Object? patientName = freezed,
    Object? patientId = freezed,
  }) {
    return _then(_$VideoRecordImpl(
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      recordedAt: null == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      patientName: freezed == patientName
          ? _value.patientName
          : patientName // ignore: cast_nullable_to_non_nullable
              as String?,
      patientId: freezed == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoRecordImpl implements _VideoRecord {
  const _$VideoRecordImpl(
      {required this.filePath,
      required this.fileName,
      required this.recordedAt,
      this.description,
      this.patientName,
      this.patientId});

  factory _$VideoRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoRecordImplFromJson(json);

  @override
  final String filePath;
  @override
  final String fileName;
  @override
  final DateTime recordedAt;
  @override
  final String? description;
  @override
  final String? patientName;
  @override
  final String? patientId;

  @override
  String toString() {
    return 'VideoRecord(filePath: $filePath, fileName: $fileName, recordedAt: $recordedAt, description: $description, patientName: $patientName, patientId: $patientId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoRecordImpl &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.patientName, patientName) ||
                other.patientName == patientName) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, filePath, fileName, recordedAt,
      description, patientName, patientId);

  /// Create a copy of VideoRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoRecordImplCopyWith<_$VideoRecordImpl> get copyWith =>
      __$$VideoRecordImplCopyWithImpl<_$VideoRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoRecordImplToJson(
      this,
    );
  }
}

abstract class _VideoRecord implements VideoRecord {
  const factory _VideoRecord(
      {required final String filePath,
      required final String fileName,
      required final DateTime recordedAt,
      final String? description,
      final String? patientName,
      final String? patientId}) = _$VideoRecordImpl;

  factory _VideoRecord.fromJson(Map<String, dynamic> json) =
      _$VideoRecordImpl.fromJson;

  @override
  String get filePath;
  @override
  String get fileName;
  @override
  DateTime get recordedAt;
  @override
  String? get description;
  @override
  String? get patientName;
  @override
  String? get patientId;

  /// Create a copy of VideoRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoRecordImplCopyWith<_$VideoRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
