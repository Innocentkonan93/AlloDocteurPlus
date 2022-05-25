import 'package:app_allo_docteur_plus/app/pharmacie_de_garde/pharmacie_tile.dart';
import 'package:app_allo_docteur_plus/data/models/Pharmacies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PharmaciesList extends StatefulWidget {
  const PharmaciesList(
      {Key? key, required this.pharmacies, required this.userAdress})
      : super(key: key);
  final List<Pharmacie> pharmacies;
  final String userAdress;

  @override
  State<PharmaciesList> createState() => _PharmaciesListState();
}

class _PharmaciesListState extends State<PharmaciesList> {
  @override
  Widget build(BuildContext context) {
    final String userCountry = widget.userAdress.split(',').last;

    print(userCountry.toLowerCase());
    final pharmacies = widget.pharmacies
        .where((pharmacie) => pharmacie.statutPharmacie != 'fermee')
        .where((pharmacie) =>
            pharmacie.paysPharmacie!.trim().toLowerCase() ==
            userCountry.trim().toLowerCase())
        .toList();
    pharmacies.sort(((a, b) {
      return a.statutPharmacie!.compareTo(b.statutPharmacie!);
    }));
    return pharmacies.isEmpty
        ? Center(child: Text('Aucune pharmacie trouvée dans votre zone'))
        : ListView.builder(
            shrinkWrap: true,
            itemCount: pharmacies.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              Pharmacie pharmacie = pharmacies[i];
              return PharmacieTile(pharmacie: pharmacie);
            },
          );
  }
}
