class AddPetRequest {
  String id;
  String speciesName;
  String name;
  String species;
  String petImage;
  String belongsTo;

  AddPetRequest(
      {this.id,
        this.speciesName,
        this.name,
        this.species,
        this.petImage,
        this.belongsTo});

  AddPetRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    speciesName = json['species_name'];
    name = json['name'];
    species = json['species'];
    petImage = json['pet_image'];
    belongsTo = json['belongs_to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['species_name'] = this.speciesName;
    data['name'] = this.name;
    data['species'] = this.species;
    data['pet_image'] = this.petImage;
    data['belongs_to'] = this.belongsTo;
    return data;
  }
}
