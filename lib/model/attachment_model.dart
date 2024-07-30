class AttachmentsModel {
  int? id;
  String? attachmentFilename;
  String? attachmentFile;
  String? comments;
  String? attachmentDownloadLink;
  dynamic amaId;
  dynamic csaId;
  dynamic lpaId;
  dynamic isDeleted;

  AttachmentsModel(
      {this.id,
      this.attachmentFilename,
      this.attachmentFile,
      this.comments,
      this.attachmentDownloadLink,
      this.amaId,
      this.csaId,
      this.lpaId,
      this.isDeleted});

  AttachmentsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attachmentFilename = json['attachment_filename'];
    attachmentFile = json['attachment_file'];
    comments = json['comments'];
    attachmentDownloadLink = json['attachment_download_link'];
    amaId = json['ama_id'];
    csaId = json['csa_id'];
    lpaId = json['lpa_id'];
    isDeleted = json['is_deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['attachment_filename'] = attachmentFilename;
    data['attachment_file'] = attachmentFile;
    data['comments'] = comments;
    data['attachment_download_link'] = attachmentDownloadLink;
    data['ama_id'] = amaId;
    data['csa_id'] = csaId;
    data['lpa_id'] = lpaId;
    data['is_deleted'] = isDeleted;
    return data;
  }
}
