class Model {
  String? fileModelName;
  String? fileLabelName;
  String? modelName;

  Model({
    this.fileModelName,
    this.fileLabelName,
    this.modelName,
  });

  factory Model.fromMap(Map<String, dynamic> map) => Model(
        fileModelName: map['fileModelName'],
        fileLabelName: map['fileLabelName'],
        modelName: map['modelName'],
      );
}

List<Model> modelList = [
  Model(
    modelName: 'Pea',
    fileModelName: 'pea.tflite',
    fileLabelName: 'pea.txt',
  ),
  Model(
    modelName: 'Wheat',
    fileModelName: 'pea.tflite',
    fileLabelName: 'pea.txt',
  ),
  Model(
    modelName: 'FRHTS',
    fileModelName: 'pea.tflite',
    fileLabelName: 'pea.txt',
  ),
  Model(
    modelName: 'HVK',
    fileModelName: 'pea.tflite',
    fileLabelName: 'pea.txt',
  ),
  Model(
    modelName: 'FDK',
    fileModelName: 'pea.tflite',
    fileLabelName: 'pea.txt',
  ),
];
