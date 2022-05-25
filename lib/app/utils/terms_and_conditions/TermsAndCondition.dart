import '../login/log/LogScreenWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({required this.isStarting, Key? key})
      : super(key: key);

  final bool isStarting;

  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isStarting ? null : AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      'Conditions générales d\'utilisation',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w800,
                        fontSize: 26,
                        color: Colors.indigo[900],
                      ),
                      maxLines: 2,
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Scrollbar(
                  radius: Radius.circular(12),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'En vigueur au 15-12-2020\n',
                          style: GoogleFonts.montserrat(
                            // fontWeight: FontWeight.w800,
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          """Les présentes conditions générales d'utilisation (dites « CGU ») ont pour objet l'encadrement juridique des modalités de mise à disposition de l’application mobile et des services par CREATIVE GROUP  et de définir les conditions d’accès et d’utilisation des services par « l'Utilisateur ».\nLes présentes CGU sont accessibles sur l’application à la rubrique «CGU».
                  \nToute inscription ou utilisation de l’application implique l'acceptation sans aucune réserve ni restriction des présentes CGU par l’utilisateur. Lors de l'inscription sur  l’application via le Formulaire d’inscription, chaque utilisateur accepte expressément les présentes CGU en cochant la case précédant le texte suivant : « Je reconnais avoir lu et compris les CGU et je les accepte ».\nEn cas de non-acceptation des CGU stipulées dans le présent contrat, l'Utilisateur se doit de renoncer à l'accès des services proposés par l’application.\nCREATIVE GROUP  se réserve le droit de modifier unilatéralement et à tout moment le contenu des présentes CGU.
                  """,
                          style: GoogleFonts.montserrat(),
                          textAlign: TextAlign.justify,
                        ),
                        Text(
                          "Article 1 : Les mentions légales\n",
                          style: GoogleFonts.montserrat(),
                        ),
                        Text(
                          """L'édition de l’application Allôdocteur+ est assurée par la Société CREATIVE GROUP au capital de 1524 euros, immatriculée au RCS de Bassam (Côte d’Ivoire) / Evry (France) sous les numéros CI-GRDBSM-2021-B-11461 / 907 820 997 R.C.S. Evry, dont le siège social est situé à Bassam.\nNuméro de téléphone : (+225) 0171753355 / (+33) 06 41 40 14 94\nAdresse e-mail : groupecreative@gmail.com
                \nLe Directeur de la publication est : Kouassi Ahouphouet Sylvain
                \nL'hébergeur de l’application Allô docteur + est la société Hébergeur discount (LWS), dont le siège social est situé en France, avec le numéro de téléphone : +33 (0)1 77 62 30 03.\n""",
                          style: GoogleFonts.montserrat(),
                          textAlign: TextAlign.justify,
                        ),
                        Text(
                          "ARTICLE 2 : Accès au site\n",
                          style: GoogleFonts.montserrat(),
                        ),
                        Text(
                          """L’application Allôdocteur+  propose à l'Utilisateur un accès aux services suivants : \nTéléconsultation, interprétation d’examen, informations dans le domaine de la médecine. 
                \nL’application est accessible gratuitement en tout lieu à tout Utilisateur ayant un accès à Internet. Tous les frais supportés par l'Utilisateur pour accéder au service (matériel informatique, logiciels, connexion Internet, etc.) sont à sa charge.
                \nL’Utilisateur non membre n'a pas accès aux services réservés. Pour cela, il doit s’inscrire en remplissant le formulaire. En acceptant de s’inscrire aux services réservés, l’Utilisateur membre s’engage à fournir des informations sincères et exactes concernant son état civil et ses coordonnées, notamment son adresse email.
                \nPour accéder aux services, l’Utilisateur doit ensuite s'identifier à l'aide de son identifiant et de son mot de passe qui lui seront communiqués après son inscription.
                \nTout Utilisateur membre régulièrement inscrit pourra également solliciter sa désinscription en se rendant à la page dédiée sur son espace personnel. Celle-ci sera effective dans un délai raisonnable.
                \nTout événement dû à un cas de force majeure ayant pour conséquence un dysfonctionnement du site ou serveur et sous réserve de toute interruption ou modification en cas de maintenance, n'engage pas la responsabilité de CREATIVE GROUP. Dans ces cas, l’Utilisateur accepte ainsi ne pas tenir rigueur à l’éditeur de toute interruption ou suspension de service, même sans préavis.
                L'Utilisateur a la possibilité de contacter le site par messagerie électronique à l’adresse email de l’éditeur communiqué à l’ARTICLE 1.\n""",
                          style: GoogleFonts.montserrat(),
                          textAlign: TextAlign.justify,
                        ),
                        Text(
                          "ARTICLE 3 : Collecte des données\n",
                          style: GoogleFonts.montserrat(),
                        ),
                        Text(
                          """L’application assure à l'Utilisateur une collecte et un traitement d'informations personnelles dans le respect de la vie privée conformément à la loi n°78-17 du 6 janvier 1978 relative à l'informatique, aux fichiers et aux libertés. 
                En vertu de la loi Informatique et Libertés, en date du 6 janvier 1978, l'Utilisateur dispose d'un droit d'accès, de rectification, de suppression et d'opposition de ses données personnelles. L'Utilisateur exerce ce droit :\n""",
                          style: GoogleFonts.montserrat(),
                          textAlign: TextAlign.justify,
                        ),
                        Text(
                          "ARTICLE 4 : Propriété intellectuelle\n",
                          style: GoogleFonts.montserrat(),
                        ),
                        Text(
                          """Les marques, logos, signes ainsi que tous les contenus du site (textes, images, son…) font l'objet d'une protection par le Code de la propriété intellectuelle et plus particulièrement par le droit d'auteur.
                \nLa marque Allô docteur+ est une marque déposée par CREATIVE GROUP. Toute représentation et/ou reproduction et/ou exploitation partielle ou totale de cette marque, de quelque nature que ce soit, est totalement prohibée.
                \nL'Utilisateur doit solliciter l'autorisation préalable de l’application pour toute reproduction, publication, copie des différents contenus. Il s'engage à une utilisation des contenus du site dans un cadre strictement privé, toute utilisation à des fins commerciales et publicitaires est strictement interdite.
                \nToute représentation totale ou partielle de ce site par quelque procédé que ce soit, sans l’autorisation expresse de l’exploitant du site Internet constituerait une contrefaçon sanctionnée par l’article L 335-2 et suivants du Code de la propriété intellectuelle.
                \nIl est rappelé conformément à l’article L122-5 du Code de propriété intellectuelle que l’Utilisateur qui reproduit, copie ou publie le contenu protégé doit citer l’auteur et sa source.\n""",
                          style: GoogleFonts.montserrat(),
                          textAlign: TextAlign.justify,
                        ),
                        Text(
                          "ARTICLE 5 : Responsabilité\n",
                          style: GoogleFonts.montserrat(),
                        ),
                        Text(
                          """Les sources des informations diffusées sur l’application Allô docteur+   sont réputées fiables mais le site ne garantit pas qu’il soit exempt de défauts, d’erreurs ou d’omissions.
                \nLes informations communiquées sont présentées à titre indicatif et général sans valeur contractuelle. Malgré des mises à jour régulières, l’application ne peut être tenue responsable de la modification des dispositions administratives et juridiques survenant après la publication. De même, l’application ne peut être tenue responsable de l’utilisation et de l’interprétation de l’information contenue dans ce site.
                \nL'Utilisateur s'assure de garder son mot de passe secret. Toute divulgation du mot de passe, quelle que soit sa forme, est interdite. Il assume les risques liés à l'utilisation de son identifiant et mot de passe. Le site décline toute responsabilité.
                \nL’application Allô docteur+ ne peut être tenue pour responsable d’éventuels virus qui pourraient infecter l’ordinateur ou tout matériel informatique de l’Internaute, suite à une utilisation, à l’accès, ou au téléchargement provenant de ce site.
                \nLa responsabilité du site ne peut être engagée en cas de force majeure ou du fait imprévisible et insurmontable d'un tiers.\n""",
                          style: GoogleFonts.montserrat(),
                          textAlign: TextAlign.justify,
                        ),
                        Text(
                          "ARTICLE 6 : Liens hypertextes\n",
                          style: GoogleFonts.montserrat(),
                          
                        ),
                        Text(
                          """Des liens hypertextes peuvent être présents sur le site. L’Utilisateur est informé qu’en cliquant sur ces liens, il sortira de l’application Allô docteur+. Ce dernier n’a pas de contrôle sur les pages web sur lesquelles aboutissent ces liens et ne saurait, en aucun cas, être responsable de leur contenu.\n""",
                          style: GoogleFonts.montserrat(),
                          textAlign: TextAlign.justify,
                        ),
                        Text(
                          "ARTICLE 7 : Cookies\n",
                          style: GoogleFonts.montserrat(),
                        ),
                        Text(
                          """L’Utilisateur est informé que lors de ses visites sur le site, un cookie peut s’installer automatiquement sur son logiciel de navigation. Les cookies sont de petits fichiers stockés temporairement sur le disque dur de l’ordinateur de l’Utilisateur par votre navigateur et qui sont nécessaires à l’utilisation de l’application Allô docteur+. Les cookies ne contiennent pas d’information personnelle et ne peuvent pas être utilisés pour identifier quelqu’un. Un cookie contient un identifiant unique, généré aléatoirement et donc anonyme. Certains cookies expirent à la fin de la visite de l’Utilisateur, d’autres restent.
                \nL’information contenue dans les cookies est utilisée pour améliorer l’application Allô docteur+.
                \nEn naviguant sur le site, L’Utilisateur les accepte.\nL’Utilisateur doit toutefois donner son consentement quant à l’utilisation de certains cookies.
                \nA défaut d’acceptation, l’Utilisateur est informé que certaines fonctionnalités ou pages risquent de lui être refusées.
                \nL’Utilisateur pourra désactiver ces cookies par l’intermédiaire des paramètres figurant au sein de son logiciel de navigation.\n""",
                          style: GoogleFonts.montserrat(),
                          textAlign: TextAlign.justify,
                        ),
                        Text(
                          "ARTICLE 8 : Droit applicable et juridiction compétentent\n",
                          style: GoogleFonts.montserrat(),
                        ),
                        Text(
                          """La législation française s'applique au présent contrat. En cas d'absence de résolution amiable d'un litige né entre les parties, les tribunaux français seront seuls compétents pour en connaître.
       \nPour toute question relative à l’application des présentes CGU, vous pouvez joindre l’éditeur aux coordonnées inscrites à l’ARTICLE 1.\n\n\n\n\n""",
                          style: GoogleFonts.montserrat(),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo[900],
        child: Icon(Icons.check),
        onPressed: () {
          print(widget.isStarting);
          if (widget.isStarting) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LogScreenWidget(),
              ),
            );
          }else{
            Navigator.pop(context);
          }
         
        },
      ),
    );
  }
}
