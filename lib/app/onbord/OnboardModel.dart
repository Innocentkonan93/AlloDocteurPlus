import 'package:flutter/material.dart';

class OnBoardModel {
  String image;
  String title;
  String description;
  Color bg;
  Color button;
  OnBoardModel({
    required this.image,
    required this.title,
    required this.description,
    required this.bg,
    required this.button,
  });
}


List<OnBoardModel> screens = [
  OnBoardModel(
    image: 'assets/images/team.png',
    title: 'Bienvenue',
    description: 'Allô Docteur plus est doté d’une équipe d’experts dans le domaine médical disposée à répondre à vos besoins médicaux',
    bg: Colors.white,
    button: Color(0XF5B67C7),
  ),
  OnBoardModel(
    image: 'assets/images/consulchat.png',
    title: 'Consultation',
    description: 'Décrivez vos symptômes en toute confidentialité à l’un de nos praticiens formés et ayez une consultation appropriée',
    bg: Colors.white,
    button: Color(0XF5B67C7),
  ),
  OnBoardModel(
    image: 'assets/images/videocall.png',
    title: 'Appel visio',
    description: 'L’application Allô docteur plus, vous donne la possibilité de vous consulter à distance pour une consultation un peu plus poussée',
    bg: Colors.white,
    button: Color(0XF5B67C7),
  ),
  OnBoardModel(
    image: 'assets/images/prescript.png',
    title: 'Prescription',
    description:
        'Obtenez des prescriptions d’ordonnances ou de bulletins d’examens au cours ou à la fin de votre consultation',
    bg: Colors.white,
    button: Color(0XF5B67C7),
  ),
  OnBoardModel(
    image: 'assets/images/interpretation.png',
    title: 'Interprétation',
    description: 'Faites interpréter vos résultats d’examen, vos ordonnances et vos documents médicaux et obtenez des avis de nos praticiens',
    bg: Colors.white,
    button: Color(0XF5B67C7),
  ),
]; 
