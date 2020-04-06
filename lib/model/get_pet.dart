class GetPet {
  int count;
  Null next;
  Null previous;
  List<Results> results;

  GetPet({this.count, this.next, this.previous, this.results});

  GetPet.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int id;
  String speciesName;
  String name;
  int species;
  String petImage;
  int belongsTo;

  Results(
      {this.id,
        this.speciesName,
        this.name,
        this.species,
        this.petImage,
        this.belongsTo});

  Results.fromJson(Map<String, dynamic> json) {
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