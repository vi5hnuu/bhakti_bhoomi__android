class UserImageMeta {
  final String format;
  final String resource_type;
  final String secure_url;
  final String in_secure_url;
  final String created_at;
  final String asset_id;
  final String version_id;
  final String version;
  final String public_id;
  final int bytes;
  final int width;
  final int height;
  final String etag;

  UserImageMeta({
    required this.format,
    required this.resource_type,
    required this.secure_url,
    required this.in_secure_url,
    required this.created_at,
    required this.asset_id,
    required this.version_id,
    required this.version,
    required this.public_id,
    required this.bytes,
    required this.width,
    required this.height,
    required this.etag,
  });

  factory UserImageMeta.fromJson(Map<String, dynamic> userImageMeta) {
    return UserImageMeta(
      format: userImageMeta['format'],
      resource_type: userImageMeta['resource_type'],
      secure_url: userImageMeta['secure_url'],
      in_secure_url: userImageMeta['in_secure_url'],
      created_at: userImageMeta['created_at'],
      asset_id: userImageMeta['asset_id'],
      version_id: userImageMeta['version_id'],
      version: userImageMeta['version'],
      public_id: userImageMeta['public_id'],
      bytes: userImageMeta['bytes'],
      width: userImageMeta['width'],
      height: userImageMeta['height'],
      etag: userImageMeta['etag'],
    );
  }
}
